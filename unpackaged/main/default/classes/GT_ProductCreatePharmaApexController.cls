public class GT_ProductCreatePharmaApexController {
     @AuraEnabled
    public Static String getProfileName(){
        id userId = userinfo.getProfileId();
        LIST<profile> ProfileName = new LIST<profile>();
        ProfileName = [select Name from profile where id = :userId LIMIT 1];
        Return ProfileName[0].Name;
    }
    @AuraEnabled
    public static String ParentObjNameusingId(id parentRecId){
        String objectname;
        objectName = String.valueOf(parentRecId.getSObjectType());
        return objectName;
    }
    
    @AuraEnabled
    public static Pharma_Template__mdt getTherapeuticAndBusinessUnitValues(String productName){
        String objectname;
        system.debug('objectname-----------' + objectname);
        Pharma_Template__mdt therapeuticAndBusinessUnit = [SELECT Business_Unit__c,Therapeutic_Area__c FROM Pharma_Template__mdt WHERE Product_Name__c =: productName LIMIT 1]; 
        system.debug('therapeuticAndBusinessUnit-----------' + therapeuticAndBusinessUnit);
        return therapeuticAndBusinessUnit;
    }
    
   /* @AuraEnabled
    public static Id connectEventId(id parentRecId){
        Id idOfConnectEvent;
        GT_Exhibit__c idValue=[Select GES_Connect_Event__c from GT_Exhibit__c where id=:parentRecId];
        idOfConnectEvent=idValue.GES_Connect_Event__c;
        system.debug('idOfConnectEvent'+idOfConnectEvent);
        return idOfConnectEvent;
    }*/
    @AuraEnabled
    public static Id connectEventId(id parentRecId,string objectName){
        Id idOfConnectEvent;
        string fieldName='GES_Connect_Event__c';
        string queryString='select Id,'+fieldName+' from ';
        queryString+=objectName+' where Id = ';
        queryString+='\''+parentRecId+'\'';
        if(objectName == 'GT_Exhibit__c')
        {
            List<GT_Exhibit__c> idValue = database.query(queryString);
            for(GT_Exhibit__c exhibit : idValue){
                idOfConnectEvent = exhibit.GES_Connect_Event__c;
            }
        }
        if(objectName == 'GT_Sponsorship__c')
        {
            List<GT_Sponsorship__c> idValue = database.query(queryString);
            for(GT_Sponsorship__c sponsporship : idValue){
                idOfConnectEvent = sponsporship.GES_Connect_Event__c;
            }
        }
        if(objectName == 'GT_Meeting_Room__c')
        {
            List<GT_Meeting_Room__c> idValue = database.query(queryString);
            for(GT_Meeting_Room__c meetingRoom : idValue){
                idOfConnectEvent = meetingRoom.GES_Connect_Event__c;
            }
        }
        if(objectName == 'GT_Speaking_Engagement__c')
        {
            List<GT_Speaking_Engagement__c> idValue = database.query(queryString);
            for(GT_Speaking_Engagement__c speakingEngagement : idValue){
                idOfConnectEvent = speakingEngagement.GES_Connect_Event__c;
            }
        }
        if(objectName == 'GT_Event_RL__c')
        {
            List<GT_Event_RL__c> idValue = database.query(queryString);
            for(GT_Event_RL__c event : idValue){
                idOfConnectEvent = event.GES_Connect_Event__c;
            }
        }
        if(objectName == 'GT_Meeting_Planning__c')
        {
            List<GT_Meeting_Planning__c> idValue = database.query(queryString);
            for(GT_Meeting_Planning__c meetingPlanning : idValue){
                idOfConnectEvent = meetingPlanning.GES_Connect_Event__c;
            }
        }
        return idOfConnectEvent;
    }
     @AuraEnabled
    public static string getParentObjName(string recordId){
        GT_Brand__c recordValues=[select Exhibit__c,Sponsorship__c,Meeting_Room__c,Speaking_Engagement__c,Event__c,Meeting_Planning__c from GT_Brand__c where id=:recordId];
        if(recordValues.Exhibit__c != null){
            return 'GT_Exhibit__c';
        }
         if(recordValues.Sponsorship__c != null){
            return 'GT_Sponsorship__c';
        }
         if(recordValues.Meeting_Room__c != null){
            return 'GT_Meeting_Room__c';
        }
        if(recordValues.Speaking_Engagement__c != null){
            return 'GT_Speaking_Engagement__c';
        }
        if(recordValues.Event__c != null){
            return 'GT_Event_RL__c';
        }
        if(recordValues.Meeting_Planning__c != null){
            return 'GT_Meeting_Planning__c';
        }
        return null;
    }

     @AuraEnabled
    public static string cloneRecord(GT_Brand__c fieldsOfRecordViewForm){
        upsert fieldsOfRecordViewForm;
        return fieldsOfRecordViewForm.Id;
    }
    @AuraEnabled
    public static Date exhibitOpenDateOfCOngress(string recordId){
        GT_Event__c event=[select Id,Exhibit_Open_Date__c from GT_Event__c where id=:recordId];
        return event.Exhibit_Open_Date__c;
    }
    @AuraEnabled
    public static GT_Brand__c CalendarValues(string recordId){
        GT_Brand__c product=[select SOW_Submitted_Date__c,Proposal_Submitted_to_NNI__c,Budget_Forecast_Sent__c,Budget_Update_Sent__c,Survey_Monkey_Sent__c,Final_Invoice_submitted_to_NNI__c,Cost_Savings_report_submitted_to_NNI__c from GT_Brand__c where id=:recordId];
        return product;
    }
    @AuraEnabled
    public static Date exhibitOpenDateValue(string recordId){
        GT_Brand__c brand=[select Id,Name,Speaking_Engagement__r.GES_Connect_Event__r.Exhibit_Open_Date__c from GT_Brand__c where id=:recordId];
        return brand.Speaking_Engagement__r.GES_Connect_Event__r.Exhibit_Open_Date__c;
    }
    
}