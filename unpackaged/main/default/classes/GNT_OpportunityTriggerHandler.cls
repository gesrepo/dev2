/**
* @author Brian Lau
* @version 1.0
* @description COMPONENT: GNT (GES New/Repeat Trigger)
*              CLASS: GNT_OpportunityTriggerHandler
*              PURPOSE: Trigger handler for GNT_OpportunityTrigger
*              CREATED: 08/2016 Ethos Solutions - www.ethos.com
**/
public without sharing class GNT_OpportunityTriggerHandler {
    public static Boolean runUnitTests = false;

    public static void handleAfterInsert(List<Opportunity> opps) {
        Set<String> showValues = new Set<String>();
        Set<String> recordTypeIds = new Set<String>();
        for (Opportunity opp : opps) {
            if (opp.Record_Type_Developer_Name__c.startsWith('EMEA') ||
                opp.Record_Type_Developer_Name__c.startsWith('E_D_') ||
                opp.Record_Type_Developer_Name__c.startsWith('Sales_Goa')) {
                continue;
            }
            if (String.isNotBlank(opp.Show_ID_LMS_Calculated__c)) {
                showValues.add(opp.Show_ID_LMS_Calculated__c);
            }
            if (String.isNotBlank(opp.Record_Type_Developer_Name__c)) {
                recordTypeIds.add(opp.Record_Type_Developer_Name__c);
            }
        }
        try {
            if (!showValues.isEmpty() && !recordTypeIds.isEmpty()) {
                GNT_OpportunityNewRepeatBatch.recalcOpportunities(showValues, recordTypeIds);
            }
        }
        catch (Exception e) {
            System.debug('************ After Insert Error: ' + e.getMessage());
            System.debug('************ Shows: ' + JSON.serialize(showValues));
            System.debug('************ Record Types: ' + JSON.serialize(recordTypeIds));
            throw e;
        }
    }

    public static void handlerAfterUpdate(Map<Id, Opportunity> newMap, Map<Id, Opportunity> oldMap) {
        Set<String> showValues = new Set<String>();
        Set<String> recordTypeIds = new Set<String>();

        for (Id oppId : newMap.keySet()) {
            if (newMap.get(oppId).Record_Type_Developer_Name__c.startsWith('EMEA') ||
                newMap.get(oppId).Record_Type_Developer_Name__c.startsWith('E_D_') ||
                newMap.get(oppId).Record_Type_Developer_Name__c.startsWith('Sales_Goa')) {
                continue;
            }

            if (newMap.get(oppId).Show_ID_LMS_Calculated__c != oldMap.get(oppId).Show_ID_LMS_Calculated__c
                    || newMap.get(oppId).StageName != oldMap.get(oppId).StageName
                    || newMap.get(oppId).RecordTypeId != oldMap.get(oppId).RecordTypeId
                    || newMap.get(oppId).YRMO__c != oldMap.get(oppId).YRMO__c
                    || newMap.get(oppId).LMS_Facility_ID__c != oldMap.get(oppId).LMS_Facility_ID__c) {
                if (String.isNotBlank(newMap.get(oppId).Show_ID_LMS_Calculated__c)) {
                    showValues.add(newMap.get(oppId).Show_ID_LMS_Calculated__c);
                }
                if (String.isNotBlank(newMap.get(oppId).Record_Type_Developer_Name__c)) {
                    recordTypeIds.add(newMap.get(oppId).Record_Type_Developer_Name__c);
                }
            }
        }

        try {
            if (!showValues.isEmpty() && !recordTypeIds.isEmpty()) {
                GNT_OpportunityNewRepeatBatch.recalcOpportunities(showValues, recordTypeIds);
            }
        }
        catch (Exception e) {
            System.debug('************ After Update Error: ' + e.getMessage());
            System.debug('************ Opportunities: ' + JSON.serialize(newMap.keySet()));
            System.debug('************ Shows: ' + JSON.serialize(showValues));
            System.debug('************ Record Types: ' + JSON.serialize(recordTypeIds));
            throw e;
        }
    }

    public static void handleAfterDelete(List<Opportunity> opps) {
        Set<String> showValues = new Set<String>();
        Set<String> recordTypeIds = new Set<String>();

        for (Opportunity opp : opps) {
            if (opp.Record_Type_Developer_Name__c.startsWith('EMEA') ||
                opp.Record_Type_Developer_Name__c.startsWith('E_D_') ||
                opp.Record_Type_Developer_Name__c.startsWith('Sales_Goa')) {
                continue;
            }
            if (String.isNotBlank(opp.Show_ID_LMS_Calculated__c)) {
                showValues.add(opp.Show_ID_LMS_Calculated__c);
            }
            if (String.isNotBlank(opp.Record_Type_Developer_Name__c)) {
                recordTypeIds.add(opp.Record_Type_Developer_Name__c);
            }
        }
        try {
            if (!showValues.isEmpty() && !recordTypeIds.isEmpty()) {
                GNT_OpportunityNewRepeatBatch.recalcOpportunities(showValues, recordTypeIds);
            }
        }
        catch (Exception e) {
            System.debug('************ After Delete Error: ' + e.getMessage());
            System.debug('************ Shows: ' + JSON.serialize(showValues));
            System.debug('************ Record Types: ' + JSON.serialize(recordTypeIds));
            throw e;
        }
    }

}