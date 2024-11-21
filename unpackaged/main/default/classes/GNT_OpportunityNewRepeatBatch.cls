/**
* @author Brian Lau
* @version 1.0
* @description COMPONENT: GNT (GES New/Repeat Trigger)
*              CLASS: GNT_OpportunityNewRepeatBatch
*              PURPOSE: Batch class to handle large amounts of record updates
*                       for Opportunities
*              CREATED: 08/2016 Ethos Solutions - www.ethos.com
**/
global class GNT_OpportunityNewRepeatBatch implements Database.Batchable<sObject> {

    public String query {get; private set;}
    private Set<String> showValues;

    private Map<String, String> recordTypeDevMap; // record type developer name to line of business
    private Map<String, Set<String>> lobMap; // line of business grouping of record type developer names
    private static Boolean runQuery;

    global GNT_OpportunityNewRepeatBatch(Set<String> showValues, Set<String> recordTypeIds) {
        this.showValues = showValues;
        runQuery = true;

        // Build up a map of Lines of Businesses to List of RecordTypeIds
        lobMap = new Map<String, Set<String>>();

        List<LOB__c> lobs = LOB__c.getall().values();
        if (Test.isRunningTest() && lobs.size() == 0) {
            GNT_TestUtil.createTestCustomSettings();
            lobs = LOB__c.getall().values();
        }

        for (LOB__c lob : lobs) {
            if (!lobMap.containsKey(lob.Picklist_Value__c)) {
                lobMap.put(lob.Picklist_Value__c, new Set<String>());
            }
            lobMap.get(lob.Picklist_Value__c).add(lob.RTDevName__c);
        }

        Set<String> lobsFound = new Set<String>();

        // Find which Lines of Business are referenced
        for (LOB__c lob : lobs) {
            if (!recordTypeIds.contains(lob.RTDevName__c)) {
                continue;
            }
            lobsFound.add(lob.Picklist_Value__c);
        }

        //
        recordTypeDevMap = new Map<String, String>();
        for (String foundLob : lobsFound) {
            for (String recordType : lobMap.get(foundLob)) {
                recordTypeDevMap.put(recordType, foundLob);
            }
        }

        query = 'Select Id, Name, New_Repeat__c, Record_Type_Developer_Name__c, Show_Id_LMS_Calculated__c, YRMO__c, StageName, LMS_Facility_ID__c '
                + 'from Opportunity '
                + 'where Show_Id_LMS_Calculated__c IN (' + keySetToCSV(showValues) + ') '
                + 'AND Record_Type_Developer_Name__c IN (' + keySetToCSV(recordTypeDevMap.keySet()) + ') '
                + 'AND Show_Close_Date__c >= 2015-01-01 '
                + 'AND (NOT Record_Type_Developer_Name__c LIKE \'EMEA%\') '
                + 'AND (NOT Record_Type_Developer_Name__c LIKE \'E_D_%\') '
                + 'AND Record_Type_Developer_Name__c != \'Sales_Goal\' '
                + 'ORDER BY Show_Id_LMS_Calculated__c ASC, YRMO__c ASC, Id ASC';
        runQuery = !recordTypeDevMap.keySet().isEmpty();
        // For Debugging Purposes, leave in for Reference.
        //Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        //String[] toAddresses = new String[] {'bfaber@ethos.com'};
        //mail.setToAddresses(toAddresses);
        //mail.setSubject('GNT Opportunity Trigger Summary');
        //String bodyText = '';
        //bodyText += 'Running Username: ' + UserInfo.getUserName() + '\r\n';
        //bodyText += 'query: ' + query + '\r\n';
        //bodyText += 'recordTypeIds: ' + JSON.serializePretty(recordTypeIds) + '\r\n';
        //bodyText += 'recordTypeDevMap: ' + JSON.serializePretty(recordTypeDevMap) + '\r\n';
        //bodyText += 'lobsFound: ' + JSON.serializePretty(lobsFound) + '\r\n';
        //bodyText += 'lobMap: ' + JSON.serializePretty(lobMap) + '\r\n';
        //mail.setPlainTextBody(bodyText);
        //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

    public static String keySetToCSV(Set<String> ids) {
        List<String> optionsList = new List<String>();
        for (String myId : ids) {
            optionsList.add('\'' + myId + '\'');
        }
        return String.join(optionsList, ' , ');
    }

    public static void recalcOpportunities(Set<String> showValues, Set<String> recordTypeIds) {
        GNT_OpportunityNewRepeatBatch b = new GNT_OpportunityNewRepeatBatch(showValues, recordTypeIds);

        if (Test.isRunningTest() && runQuery) {
            // Because there are multiple batch processes which must finish in order we need to run it synchronously in test mode
            System.debug(b.query);
            List<sObject> result = Database.query(b.query);
            System.debug(showValues);
            b.execute(null, result);
            b.finish(null);
        }
        else if (runQuery) {
            Database.executeBatch(b);
        }
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        //---Partial saves of opportunities
        Map<Id, Opportunity> opps = new Map<Id, Opportunity>();
        Map<String, List<Opportunity>> oppMap = new Map<String, List<Opportunity>>();


        // Create a mapping to represent shows that contain mulitple opportunities for the same record type for the same year.
        // Build up a mapping to indicate multiple years have been found.
        Map<String, Boolean> uniqueShowsMap = new Map<String, Boolean>();

        for (Opportunity opp : (List<Opportunity>)scope) {
            String oppYearMonth = opp.Show_ID_LMS_Calculated__c + ',' + recordTypeDevMap.get(opp.Record_Type_Developer_Name__c) + ',' + opp.YRMO__c;
            if (!uniqueShowsMap.containsKey(oppYearMonth)) {
                uniqueShowsMap.put(oppYearMonth, false);
            }
            else {
                uniqueShowsMap.put(oppYearMonth, true);
            }
        }

        for (Opportunity opp : (List<Opportunity>)scope) {
            String showRtKey = opp.Show_ID_LMS_Calculated__c + ',' + recordTypeDevMap.get(opp.Record_Type_Developer_Name__c) + ',' + opp.YRMO__c;
            Boolean multiYearMonthFound = uniqueShowsMap.get(showRtKey);


            // Here we group by ShowID, Facility Id, and Record Type, for example '3DPCE' and 'North America - Exhibition & Events'
            // So that we're only updating opportunities within the same show, facility, and line.
            //
            // If this is a multiple opportunity show year, then update it.
            String key = !multiYearMonthFound ?
                         opp.Show_ID_LMS_Calculated__c + ',' + recordTypeDevMap.get(opp.Record_Type_Developer_Name__c) :
                         opp.Show_ID_LMS_Calculated__c + ',' + recordTypeDevMap.get(opp.Record_Type_Developer_Name__c) + ',' + opp.LMS_Facility_ID__c;
            if (oppMap.containsKey(key)) {
                oppMap.get(key).add(opp);
            }
            else {
                oppMap.put(key, new List<Opportunity> {opp});
            }
        }
        List<String> changeSummary = new List<String>();
        for (String key : oppMap.keySet()) {
            List<Opportunity> oppList = oppMap.get(key);
            for (Integer i = 0; i < oppList.size(); i++) {
                //---Update the most immediate after
                if (i < oppList.size() - 1) {
                    String oldValue = oppList[i + 1].New_Repeat__c;
                    String newValue = oppList[i].StageName == 'CR' || oppList[i].StageName == 'CV' ? 'Repeat' : 'New';
                    // Only Update if it needs updating to reduce number of DML.
                    if (oldValue != newValue) {
                        changeSummary.add('Opportunity ' + oppList[i + 1].Name + '[' + oppList[i + 1].Id + '] Old New/Repeat Value: ' + oldValue);
                        oppList[i + 1].New_Repeat__c = newValue;
                        opps.put(oppList[i + 1].Id, oppList[i + 1]);
                        changeSummary.add('Opportunity ' + oppList[i + 1].Name + '[' + oppList[i + 1].Id + '] New New/Repeat Value: ' + newValue);
                    }
                }
            }
        }
        if (!opps.isEmpty()) {
            Database.update(opps.values(), false);
            //Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            //String[] toAddresses = new String[] {'bfaber@ethos.com'};
            //mail.setToAddresses(toAddresses);
            //mail.setSubject('GNT Opportunity Trigger Summary');
            //String bodyText = '';
            //bodyText += 'Running Username: ' + UserInfo.getUserName() + '\r\n';
            //for (String change : changeSummary) {
            //    bodyText += change + '\r\n';
            //}
            //mail.setPlainTextBody(bodyText);
            //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }

    global void finish(Database.BatchableContext BC) {

    }

}