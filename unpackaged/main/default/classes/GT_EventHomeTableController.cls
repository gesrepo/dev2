public with sharing class GT_EventHomeTableController {
    
    @AuraEnabled 
    public static Generic_Template_Setting__mdt getConnectSettings() {
        
        Id profileId = userinfo.getProfileId();
        String profileName = [SELECT Id, Name FROM Profile WHERE Id=:profileId].Name;
        String customerName = '';
        
        switch on profileName {
            when 'GC Crown Castle' {
                customerName = 'Crown Castle';
            }
            when 'GC Novo Nordisk' {
                customerName = 'Novo Nordisk';
            }
            when 'GC Pharma Template' {
                customerName = 'Pharma Template';
            }
            when 'GC Merck' {
                customerName = 'Merck';
            }
            when else {
                customerName = 'Generic Template';
            }
        }
        List<Generic_Template_Setting__mdt> customSettings = [SELECT Customer_Name__c, Entity_Name__c, Program_Name__c FROM Generic_Template_Setting__mdt WHERE Customer_Name__c =: customerName LIMIT 1]; 
        return customSettings[0]; 
    }
    
    @AuraEnabled
    public static List<GT_Event__c> getEvents() {
        Date todayDate = Date.today();
        List<GT_Event__c> Events =new List<GT_Event__c>();
        Generic_Template_Setting__mdt temp=getConnectSettings();
        if(temp.Customer_Name__c.equals('Novo Nordisk') || temp.Customer_Name__c.equals('Pharma Template')|| temp.Customer_Name__c.equals('Merck'))
            Events= [SELECT Id, Name,Name_of_Event__c,Name_of_Congress__c,Event_Acronym__c,Congress_Acronym__c,Exhibit_Open_Date__c,Event_Start_Date__c,Congress_Start_Date__c,Event_End_Date__c,Congress_End_Date__c,
                     Exhibit_Close_Date__c,Shipping_City__c,Shipping_State_Province__c,Event_Cancelled__c,Congress_Cancelled__c FROM GT_Event__c WHERE Congress_Start_Date__c >= :todayDate ORDER BY Congress_Start_Date__c];
        else
            Events= [SELECT Id, Name,Name_of_Event__c,Name_of_Congress__c,Event_Acronym__c,Congress_Acronym__c,Exhibit_Open_Date__c,Event_Start_Date__c,Congress_Start_Date__c,Event_End_Date__c,Congress_End_Date__c,
                     Exhibit_Close_Date__c,Shipping_City__c,Shipping_State_Province__c,Event_Cancelled__c,ExpressoPro__c,GES_Supported_Event__c,Congress_Cancelled__c FROM GT_Event__c WHERE Event_Start_Date__c >= :todayDate ORDER BY Event_Start_Date__c ];
        
        return Events;
    }
    @AuraEnabled
    public static List<GT_Event__c> getSearchResults(string evName, string evAcronym, string evYear, string ccProjectManager, string division, string businessUnit,string congManager,string accManager,string tArea) {
        
        system.debug('--------->>>>>>>>' + ccProjectManager);
        system.debug('--------->>>>>>>>' + division);
        system.debug('--------->>>>>>>>' + businessUnit);
        system.debug('--------->>>>>>>>' + congManager);
        system.debug('--------->>>>>>>>' + accManager);
        system.debug('--------->>>>>>>>' + tArea);
        
        integer eventyear = String.isNotBlank(evYear) ? Integer.valueof(evYear) : 0;
        string query = 'SELECT Id, ExpressoPro__c,GES_Supported_Event__c,Name,Name_of_Congress__c, Name_of_Event__c, Event_Acronym__c,Congress_Acronym__c,Event_Start_Date__c,Congress_Start_Date__c,Event_Cancelled__c,Event_End_Date__c,Congress_End_Date__c,Congress_Cancelled__c,Exhibit_Open_Date__c, Exhibit_Close_Date__c,Shipping_City__c,Shipping_State_Province__c FROM GT_Event__c WHERE Id != null ';
        
        if( String.isNotBlank(division) && division != '--- None ---'){
            query += ' AND id IN (SELECT GES_Connect_Event__c FROM GT_Brand__c WHERE Product_Category_CrownCastle__c = ' + '\'' + division + '\'';
        }
        
        if((String.isNotBlank(division) && division != '--- None ---') && (String.isNotBlank(businessUnit) && businessUnit != '--- None ---')){
            query += ' AND  Brand_Name__c = ' + '\'' + businessUnit + '\'' + ') ';
        }
        
        if(!(String.isNotBlank(division) && division != '--- None ---') && (String.isNotBlank(businessUnit) && businessUnit != '--- None ---')){
            query += ' AND id IN (SELECT GES_Connect_Event__c FROM GT_Brand__c WHERE Brand_Name__c = ' + '\'' + businessUnit + '\'' + ') ';
        }
        
        else if((String.isNotBlank(division) && division != '--- None ---') && !(String.isNotBlank(businessUnit) && businessUnit != '--- None ---')){
            query += ') ';
        }
        
        
        if( String.isNotBlank(tArea) && tArea != '--- None ---'){
            /* query += ' AND id IN (SELECT GES_Connect_Event__c FROM GT_Brand__c WHERE Therapeutic_Area__c = ' + '\'' + tArea + '\'';
query += ') ';
*/
            String subquery='SELECT GES_Connect_Event__c FROM GT_Brand__c WHERE Therapeutic_Area__c = ' + '\'' + tArea + '\'';
            List<GT_Brand__c> bdList=new List<GT_Brand__c>();
            bdList=Database.query(subquery);
            List<Id> prodId=new List<Id>();
            for(GT_Brand__c bd:bdList){
                prodId.add(bd.GES_Connect_Event__c);
            }
            
            query += ' AND id IN :prodId ';
            
        }
        if( String.isNotBlank(ccProjectManager) && ccProjectManager != '--- None ---'){
            ccProjectManager = ccProjectManager.trim();
            query += ' AND id IN (SELECT GES_Connect_Event__c FROM GT_Brand__c WHERE id != null ';
            query += ' AND (Exhibit__r.Project_Manager_CrownCastle__c = ' + '\''+ccProjectManager+'\'';
            query += ' OR Event__r.Project_Manager_CrownCastle__c = ' + '\'' +ccProjectManager+'\'';
            query += ' OR Registration_Attend_Only__r.Project_Manager_CrownCastle__c = '+'\''+ccProjectManager+'\'';
            query += ' OR Sporting_Event__r.CC_Project_Manager__c  = '+'\''+ccProjectManager+ '\'';
            query += ' OR Sponsorship__r.Project_Manager_CrownCastle__c  = '+'\''+ccProjectManager+'\'';
            query += ' OR Speaking_Engagement__r.Project_Manager_CrownCastle__c  = '+ '\''+ccProjectManager+'\'';
            query += ' OR Meeting_Room__r.Project_Manager__c  = ' + '\''+ccProjectManager+'\'';
            query += ' OR Membership__r.CC_Project_Manager__c  = ' + '\''+ccProjectManager+'\'';
            query += ')) ';
        }
        
        
        if( String.isNotBlank(congManager) && congManager != '--- None ---'){
            congManager = congManager.trim();
            query += ' AND id IN (SELECT GES_Connect_Event__c FROM GT_Brand__c WHERE id != null ';
            query += ' AND (Exhibit__r.Congress_Manager__c = ' + '\''+congManager+'\'';
            query += ' OR Event__r.Congress_Manager__c = ' + '\'' +congManager+'\'';
            // query += ' OR Registration_Attend_Only__r.Project_Manager_CrownCastle__c = '+'\''+congManager+'\'';
            //query += ' OR Sporting_Event__r.CC_Project_Manager__c  = '+'\''+congManager+ '\'';
            query += ' OR Sponsorship__r.Congress_Manager__c  = '+'\''+congManager+'\'';
            query += ' OR Speaking_Engagement__r.Congress_Manager__c  = '+ '\''+congManager+'\'';
            query += ' OR Meeting_Room__r.Congress_Manager__c  = ' + '\''+congManager+'\'';
            query += ' OR Meeting_Planning__r.Congress_Manager__c  = ' + '\''+congManager+'\'';
            query += ')) ';
        }
        if( String.isNotBlank(accManager) && accManager != '--- None ---'){
            accManager = accManager.trim();
            query += ' AND id IN (SELECT GES_Connect_Event__c FROM GT_Brand__c WHERE id != null ';
            query += ' AND (Exhibit__r.GES_Account_Manager__c = ' + '\''+accManager+'\'';
            query += ' OR Event__r.GES_Account_Manager__c = ' + '\'' +accManager+'\'';
            // query += ' OR Registration_Attend_Only__r.Project_Manager_CrownCastle__c = '+'\''+congManager+'\'';
            //query += ' OR Sporting_Event__r.CC_Project_Manager__c  = '+'\''+congManager+ '\'';
            query += ' OR Sponsorship__r.GES_Account_Manager__c  = '+'\''+accManager+'\'';
            query += ' OR Speaking_Engagement__r.GES_Account_Manager__c  = '+ '\''+accManager+'\'';
            query += ' OR Meeting_Room__r.GES_Account_Manager__c  = ' + '\''+accManager+'\'';
            query += ' OR Meeting_Planning__r.GES_Account_Manager__c  = ' + '\''+accManager+'\'';
            query += ')) ';
        }
        
        Generic_Template_Setting__mdt temp=getConnectSettings();
        if( String.isNotBlank(evName)){
            if(temp.Customer_Name__c.equals('Novo Nordisk') || temp.Customer_Name__c.equals('Pharma Template')|| temp.Customer_Name__c.equals('Merck'))
                query += 'AND Name_of_Congress__c LIKE \'%'+ evName + '%\'';
            else
                query += 'AND Name_of_Event__c LIKE \'%'+ evName + '%\'';
            
        }
        
        if( String.isNotBlank(evAcronym)){
            if(temp.Customer_Name__c.equals('Novo Nordisk') || temp.Customer_Name__c.equals('Pharma Template')|| temp.Customer_Name__c.equals('Merck'))
                query += 'AND Congress_Acronym__c LIKE \'%'+ evAcronym + '%\'';
            else
                query += 'AND Event_Acronym__c LIKE \'%'+ evAcronym + '%\'';
            
        }
        
        if(eventyear != 0){
            if(temp.Customer_Name__c.equals('Novo Nordisk') || temp.Customer_Name__c.equals('Pharma Template') || temp.Customer_Name__c.equals('Merck'))
                query += ' AND CALENDAR_YEAR(Congress_Start_Date__c) ='+ eventyear +'';
            else
                query += ' AND CALENDAR_YEAR(Event_Start_Date__c) ='+ eventyear +'';
            
        }
        
        /*if( String.isNotBlank(evName) && String.isBlank(evAcronym) && eventyear == 0){
query += 'WHERE Name_of_Event__c LIKE \'%'+ evName + '%\'';
}
else if(String.isNotBlank(evAcronym) && String.isBlank(evYear) && String.isBlank(evName) ){
query += 'WHERE Event_Acronym__c LIKE \'%'+ evAcronym + '%\'';
}
else if(String.isBlank(evName) && String.isBlank(evAcronym) && String.isNotBlank(evYear)){
query += 'Where CALENDAR_YEAR(Event_Start_Date__c) ='+ eventyear +'';
}
else if( String.isNotBlank(evName) && String.isNotBlank(evAcronym) && String.isBlank(evYear)){
query += 'WHERE Name_of_Event__c LIKE \'%'+ evName + '%\' AND';
query += ' Event_Acronym__c LIKE \'%'+ evAcronym + '%\'' ;
}
else if(String.isBlank(evName) && String.isNotBlank(evAcronym) && String.isNotBlank(evYear)){
query += 'WHERE Event_Acronym__c LIKE \'%'+ evAcronym + '%\' AND' ;
query += ' CALENDAR_YEAR(Event_Start_Date__c) ='+ eventyear +'' ;
}
else if(String.isNotBlank(evName) && String.isBlank(evAcronym) && String.isNotBlank(evYear)){
query +=  'WHERE Name_of_Event__c LIKE \'%'+ evName + '%\' AND' ;
query += ' CALENDAR_YEAR(Event_Start_Date__c) ='+ eventyear +'' ;
}else if (String.isNotBlank(evName) && String.isNotBlank(evAcronym) && String.isNotBlank(evYear)){
query += 'WHERE Name_of_Event__c LIKE \'%'+ evName + '%\' AND' ;
query += ' Event_Acronym__c LIKE \'%'+ evAcronym + '%\' AND' ;
query += ' CALENDAR_YEAR(Event_Start_Date__c) ='+ eventyear +'';
}*/
        
        // Generic_Template_Setting__mdt temp=getConnectSettings();
        if(temp.Customer_Name__c.equals('Novo Nordisk') || temp.Customer_Name__c.equals('Pharma Template') || temp.Customer_Name__c.equals('Merck'))
            query += ' ORDER BY Congress_Start_Date__c';
        else
            query += ' ORDER BY Event_Start_Date__c';
        system.debug('Query -----------------------------' + query);
        List<GT_Event__c> filteredEvents = Database.Query(query);
        system.debug('Events------------------------->>>>>>>>>>>>>>>>>' + filteredEvents);
        
        /*List<GT_Event__c> filteredEventsList = new List<GT_Event__c>();

Set<Id> productFilteredIds = new Set<Id>();
for(Integer i=0 ; i<=productFilteredIds.size() ; i++){
productFilteredIds.add(productFilteredIds[i].Id);
}
system.debug(productFilteredIds);


*/
        return filteredEvents;
    }
}