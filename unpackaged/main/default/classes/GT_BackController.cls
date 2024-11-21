/**
* @Author   :		Namratha
* @Date		:		17-Sept-2018
* @Desc		:		Controller for GT_Back Lightning Component
* */
public class GT_BackController {
    
    @AuraEnabled        
    public static String getRelatedRecordId(ID recID){
        String recordId;
        String exhibitId;
        String sponsorshipId;
        String meetingRoomId;
        String eventId;
        String speakingEngagementId;
        String regAttendOnlyId;
        String generalEventCostId;
        String meetingPlanningId;
        
        String  objectName = String.valueOf(recID.getSObjectType());
        
        System.debug('objectName--- '+objectName);
        
        if(objectName.contains('GT_Brand__c')){
            GT_Brand__c brand = [select name,Id,Exhibit__c,Sponsorship__c,Event__c,Meeting_Room__c,Speaking_Engagement__c,
                                 Registration_Attend_Only__c,General_Event_Costs__c,Meeting_Planning__c,Membership__c,Sporting_Event__c from GT_Brand__c where id =: recID ];
            
            exhibitId = brand.Exhibit__c;
            sponsorshipId = brand.Sponsorship__c;
            meetingRoomId = brand.Meeting_Room__c;
            speakingEngagementId = brand.Speaking_Engagement__c;
            eventId = brand.Event__c;
            regAttendOnlyId = brand.Registration_Attend_Only__c;
            generalEventCostId = brand.General_Event_Costs__c;
            meetingPlanningId = brand.Meeting_Planning__c;
            
            if(String.isNotBlank(exhibitId)){
                recordId =  exhibitId;
            }else if(String.isNotBlank(sponsorshipId)){
                recordId =  sponsorshipId;
            }else if(String.isNotBlank(meetingRoomId)){
                recordId =  meetingRoomId;
            }else if(String.isNotBlank(speakingEngagementId)){
                recordId =  speakingEngagementId;
            }else if(String.isNotBlank(eventId)){
                recordId =  eventId;
            }
            else if(String.isNotBlank(regAttendOnlyId)){
                recordId =  regAttendOnlyId;
            }
            else if(String.isNotBlank(generalEventCostId)){
                recordId =  generalEventCostId;
            }
            else if(String.isNotBlank(meetingPlanningId)){
                recordId =  meetingPlanningId;
            }
            else if(String.isNotBlank(brand.Membership__c)){
                recordId =  brand.Membership__c;
            }
            
            else if(String.isNotBlank(brand.Sporting_Event__c)){
                recordId =  brand.Sporting_Event__c;
            }
            
            
        }
        else if(objectName.contains('GT_Exhibit__c')){
            GT_Exhibit__c exhibit = [select name,Id,GES_Connect_Event__c from GT_Exhibit__c
                                 where id =: recID ];
            recordId = exhibit.GES_Connect_Event__c;
        }
        else if(objectName.contains('GT_Sponsorship__c')){
            GT_Sponsorship__c sponsorship = [select name,Id,GES_Connect_Event__c from GT_Sponsorship__c
                                 where id =: recID ];
            recordId = sponsorship.GES_Connect_Event__c;
        }
        else if(objectName.contains('GT_Meeting_Room__c')){
            GT_Meeting_Room__c meetingRoom = [select name,Id,GES_Connect_Event__c from GT_Meeting_Room__c
                                 where id =: recID ];
            recordId = meetingRoom.GES_Connect_Event__c;
        }
        else if(objectName.contains('GT_Speaking_Engagement__c')){
            GT_Speaking_Engagement__c speakingEngagement = [select name,Id,GES_Connect_Event__c from GT_Speaking_Engagement__c
                                 where id =: recID ];
            recordId = speakingEngagement.GES_Connect_Event__c;
        }
        else if(objectName.contains('GT_Event_RL__c')){
            GT_Event_RL__c eventObj = [select name,Id,GES_Connect_Event__c from GT_Event_RL__c
                                 where id =: recID ];
            recordId = eventObj.GES_Connect_Event__c;
        }
        else if(objectName.contains('GT_Reg_Attend_Only__c')){
            GT_Reg_Attend_Only__c regAttendObj = [select name,Id,GES_Connect_Event__c from GT_Reg_Attend_Only__c
                                 where id =: recID ];
            recordId = regAttendObj.GES_Connect_Event__c;
        }
        else if(objectName.contains('GT_General_Event_Costs__c')){
            GT_General_Event_Costs__c genEventCostObj = [select name,Id,GES_Connect_Event__c from GT_General_Event_Costs__c
                                 where id =: recID ];
            recordId = genEventCostObj.GES_Connect_Event__c;
        }
        else if(objectName.contains('GT_Meeting_Planning__c')){
            GT_Meeting_Planning__c meetingPlaninngObj = [select name,Id,GES_Connect_Event__c from GT_Meeting_Planning__c
                                 where id =: recID ];
            recordId = meetingPlaninngObj.GES_Connect_Event__c;
        }
         else if(objectName.contains('GT_Membership__c')){
            GT_Membership__c memberObj = [select name,Id,GES_Connect_Event__c from GT_Membership__c
                                 where id =: recID ];
            recordId = memberObj.GES_Connect_Event__c;
        }
        else if(objectName.contains('GT_Sporting_Event__c')){
            GT_Sporting_Event__c memberObj = [select name,Id,GES_Connect_Event__c from GT_Sporting_Event__c
                                 where id =: recID ];
            recordId = memberObj.GES_Connect_Event__c;
        }
        
        system.debug('recordId---->'+recordId);
        return recordId;
    }
}