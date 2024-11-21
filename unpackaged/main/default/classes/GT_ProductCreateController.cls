/**
* @Author   :		Namratha
* @Date		:		24-Oct-2018
* @Desc		:		Controller for GT_Product Create Component
* */
public class GT_ProductCreateController {
    
    @AuraEnabled
    public static String getObjectName(id ObjectId){
        String objectname;
        objectName = String.valueOf(ObjectId.getSObjectType());
        System.debug('objectname-----'+objectname);
        
        return objectName;
    }
    
    @AuraEnabled
    public Static String getProfileName(){
        id userId = userinfo.getProfileId();
        LIST<profile> ProfileName = new LIST<profile>();
		ProfileName = [select Name,Id from profile where id = :userId LIMIT 1];
        system.debug('profile id--->'+ProfileName[0].Id);
        Return ProfileName[0].Name;
    }
    
    @AuraEnabled
    public static Object getObject(id ObjectId){
        
        Object  ParentObject;
        String recordId;
        String objectname;
        
        objectName = String.valueOf(ObjectId.getSObjectType());
        System.debug('objectname-----'+objectname);
        
        if(objectName.contains('GT_Exhibit__c')){
            GT_Exhibit__c exhibit = [select name,Id,GES_Connect_Event__c,GES_Connect_Event__r.Name,GES_Connect_Event__r.CurrencyIsoCode from GT_Exhibit__c
                                     where id =: ObjectId ];
            System.debug('exhibit>>>'+exhibit);
            ParentObject = exhibit;
        }
        else if(objectName.contains('GT_Sponsorship__c')){
            GT_Sponsorship__c sponsorship = [select name,Id,GES_Connect_Event__c,GES_Connect_Event__r.Name from GT_Sponsorship__c
                                             where id =: ObjectId ];
            ParentObject = sponsorship;
        }
        else if(objectName.contains('GT_Meeting_Room__c')){
            GT_Meeting_Room__c meetingRoom = [select name,Id,GES_Connect_Event__c,GES_Connect_Event__r.Name from GT_Meeting_Room__c
                                              where id =: ObjectId ];
            ParentObject = meetingRoom;
        }
        else if(objectName.contains('GT_Speaking_Engagement__c')){
            GT_Speaking_Engagement__c speakingEngagement = [select name,Id,GES_Connect_Event__c,GES_Connect_Event__r.Name from GT_Speaking_Engagement__c
                                                            where id =: ObjectId ];
            ParentObject = speakingEngagement;
        }
        else if(objectName.contains('GT_Event_RL__c')){
            GT_Event_RL__c eventObj = [select name,Id,GES_Connect_Event__c,GES_Connect_Event__r.Name from GT_Event_RL__c
                                       where id =: ObjectId ];
            ParentObject = eventObj;
        }
        else if(objectName.contains('GT_Reg_Attend_Only__c')){
            GT_Reg_Attend_Only__c regAttendObj = [select name,Id,GES_Connect_Event__c,GES_Connect_Event__r.Name from GT_Reg_Attend_Only__c
                                                  where id =: ObjectId ];
            ParentObject = regAttendObj;
        }
         else if(objectName.contains('GT_General_Event_Costs__c')){
            GT_General_Event_Costs__c generalEventObj = [select name,Id,GES_Connect_Event__c,GES_Connect_Event__r.Name from GT_General_Event_Costs__c
                                                  where id =: ObjectId ];
            ParentObject = generalEventObj;
        }
        else if(objectName.contains('GT_Meeting_Planning__c')){
            GT_Meeting_Planning__c meetingPlanningObj = [select name,Id,GES_Connect_Event__c,GES_Connect_Event__r.Name from GT_Meeting_Planning__c
                                                  where id =: ObjectId ];
            ParentObject = meetingPlanningObj;
        }
        else if(objectName.contains('GT_Sporting_Event__c')){
            GT_Sporting_Event__c sportingEventObj = [select name,Id,GES_Connect_Event__c,GES_Connect_Event__r.Name from GT_Sporting_Event__c
                                                  where id =: ObjectId ];
            ParentObject = sportingEventObj;
        }
        else if(objectName.contains('GT_Membership__c')){
            GT_Membership__c membershipObj = [select name,Id,GES_Connect_Event__c,GES_Connect_Event__r.Name from GT_Membership__c
                                                  where id =: ObjectId ];
            ParentObject = membershipObj;
        }
        
        return ParentObject;
    }
    
    @AuraEnabled
    public static Object getProductObj(id ObjectId){
        
        GT_Brand__c brandObj = [SELECT id,name,GES_Connect_Event__c,Event__c,Exhibit__c,
                                Meeting_Room__c,Sponsorship__c,Speaking_Engagement__c,Registration_Attend_Only__c,Meeting_Planning__c,
                                General_Event_Costs__c,Sporting_Event__c,Membership__c,GES_Connect_Event__r.name,
                                Event__r.name,Exhibit__r.name,Sponsorship__r.name, Meeting_Room__r.name,Registration_Attend_Only__r.name,
                                General_Event_Costs__r.name,Speaking_Engagement__r.name,Meeting_Planning__r.name, Sporting_Event__r.name,Membership__r.name from GT_Brand__c where id =: ObjectId LIMIT 1];
        System.debug('brandObj-----'+brandObj);
        System.debug('name --->'+brandObj.Meeting_Room__r.name);
        
        return brandObj;
    }
}