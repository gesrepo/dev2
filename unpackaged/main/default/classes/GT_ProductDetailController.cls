/**
* @Author   :		Namratha
* @Date		:		29-Oct-2018
* @Desc		:		Controller for GT_Product Detail Component
* */
public class GT_ProductDetailController {
    
    
    @AuraEnabled
    public Static String getProfileName(){
        id userId = userinfo.getProfileId();
        LIST<profile> ProfileName = new LIST<profile>();
		ProfileName = [select Name,Id from profile where id = :userId LIMIT 1];
        system.debug('profile id--->'+ProfileName[0].Id);
        Return ProfileName[0].Name;
    }
    
    @AuraEnabled
    Public static String getFields(ID recordId){
        String FieldString;
        String parentObjName;
        String DependantFields;
        
        GT_Brand__c brandObj = [SELECT name,id,Brand_Name__c,GES_Connect_Event__c,Funding_Provider_Owner__c,Funding_Provider_Brand__c,
                                GES_Costs_Estimated__c,Funding_Provider_Region__c,GES_Costs_Actual__c,Cost_Center__c,Meeting_Planning__c,
                                Event__c,Exhibit__c,Meeting_Room__c,Sponsorship__c,Speaking_Engagement__c,Registration_Attend_Only__c,
                                General_Event_Costs__c,Sporting_Event__c,Membership__c,Canceled__c,Reason_for_Cancellation__c,Cancelled_Date__c
                                FROM GT_Brand__c where id =:recordId];
        
        if(brandObj.Exhibit__c != null || brandObj.Meeting_Room__c != null){
            if(brandObj.Exhibit__c != null){
                parentObjName = 'Exhibit__c,';
                DependantFields = 'GES_Costs_Estimated__c,Cost_Center__c,GES_Costs_Actual__c,';
                
                FieldString = 'Brand_Name__c,GES_Connect_Event__c,';
                FieldString += parentObjName ;
                FieldString += 'Funding_Provider_Owner__c,Booth_Space_Cost_Estimated__c,Funding_Provider_Brand__c,Booth_Space_Cost_Actual__c,';
                FieldString += 'Funding_Provider_Region__c,';
                FieldString += DependantFields ;
                FieldString += 'Canceled__c,Reason_for_Cancellation__c,Cancelled_Date__c';
            }
            if(brandObj.Meeting_Room__c != null){
                parentObjName = 'Meeting_Room__c,';
                DependantFields = 'Meeting_Room_Services_Cost_Estimated_CC__c,Cost_Center__c,Meeting_Room_Services_Cost_Actual_CC__c,';
                
                FieldString = 'Brand_Name__c,GES_Connect_Event__c,';
                FieldString += parentObjName ;
                FieldString += 'Funding_Provider_Owner__c,Meeting_Room_Cost_Estimated_CrownCastle__c,Funding_Provider_Brand__c,Meeting_Room_Cost_Actual_CrownCastle__c,';
                FieldString += 'Funding_Provider_Region__c,';
                FieldString += DependantFields ;
                FieldString += 'Canceled__c,Reason_for_Cancellation__c,Cancelled_Date__c';
            }
            
        }
        else if(brandObj.Meeting_Planning__c != null){
            FieldString = 'Brand_Name__c,GES_Connect_Event__c,';
            FieldString += 'Product_Category_CrownCastle__c,Meeting_Planning__c,Corporate_Business_Unit__c,';
            FieldString += 'Budget_Owner__c,Estimate_Cost_Origin__c,NNI_Stakeholder__c,MP_Costs_Estimated__c,';
            FieldString += 'NNI_Stakeholder_email__c,MP_Costs_Actual__c,Company_Code__c,Cost_Center__c,';
            FieldString += 'Canceled__c,Reason_for_Cancellation__c,Cancelled_Date__c';
        }
        else{
            
            if(brandObj.Event__c != null){
                parentObjName = 'Event__c,';
                DependantFields = 'Event_Cost_Estimated_CrownCastle__c,Cost_Center__c,Event_Costs_Actual_CrownCastle__c,';
            }
            
            if(brandObj.Sponsorship__c != null){
                parentObjName = 'Sponsorship__c,';
                DependantFields = 'Sponsorship_Cost_Estimated_CrownCastle__c,Cost_Center__c,Sponsorship_Cost_Actual_CrownCastle__c,';
            }
            if(brandObj.Speaking_Engagement__c != null){
                parentObjName = 'Speaking_Engagement__c,';
                DependantFields = 'Speaker_Cost_Estimated_CrownCastle__c,Cost_Center__c,Speaker_Cost_Actual_CrownCastle__c,';
            }
            if(brandObj.Registration_Attend_Only__c != null){
                parentObjName = 'Registration_Attend_Only__c,';
                DependantFields = 'Reg_Attend_Cost_Estimated_CrownCastle__c,Cost_Center__c,Reg_Attend_Cost_Actual_CrownCastle__c,';
            }
            if(brandObj.Sporting_Event__c != null){
                parentObjName = 'Sporting_Event__c,';
                DependantFields = 'Sporting_Event_Costs_Actual__c,Cost_Center__c,Sporting_Event_Costs_Estimated__c,Cost_of_additional_tickets__c';
            }
            if(brandObj.Membership__c != null){
                parentObjName = 'Membership__c,';
                DependantFields = 'Membership_Costs_Actual__c,Cost_Center__c,Membership_Costs_Estimated__c,';
            }
            /*if(brandObj.General_Event_Costs__c != null){
				parentObjName = 'General_Event_Costs__c,';
				DependantFields = 'General_Event_Cost_Estimated__c,Cost_Center__c,General_Event_Cost_Actual__c,';
			} */
            
            FieldString = 'Brand_Name__c,GES_Connect_Event__c,';
            FieldString += parentObjName ;
            FieldString += 'Funding_Provider_Owner__c,Funding_Provider_Brand__c,';
            FieldString += 'Funding_Provider_Region__c,';
            FieldString += DependantFields ;
            FieldString += 'Canceled__c,Reason_for_Cancellation__c,Cancelled_Date__c';
        }   
        
        
        
        return FieldString;
    }
    
    @AuraEnabled
    Public static String getParentObj(ID recordId){
        String FieldString;
        String parentObjName;
        String DependantFields;
        
        GT_Brand__c brandObj = [SELECT name,id,Brand_Name__c,GES_Connect_Event__c,Funding_Provider_Owner__c,Funding_Provider_Brand__c,
                                GES_Costs_Estimated__c,Funding_Provider_Region__c,GES_Costs_Actual__c,Cost_Center__c,Meeting_Planning__c,
                                Event__c,Exhibit__c,Meeting_Room__c,Sponsorship__c,Speaking_Engagement__c,Registration_Attend_Only__c,
                                General_Event_Costs__c,Sporting_Event__c,Membership__c,Canceled__c,Reason_for_Cancellation__c,Cancelled_Date__c
                                FROM GT_Brand__c where id =:recordId];
        
        if(brandObj.Event__c != null){
            parentObjName = 'GT_Event_RL__c';
        }
        if(brandObj.Exhibit__c != null){
            parentObjName = 'GT_Exhibit__c';
        }
        if(brandObj.Meeting_Room__c != null){
            parentObjName = 'GT_Meeting_Room__c';
        }
        if(brandObj.Sponsorship__c != null){
            parentObjName = 'GT_Sponsorship__c';
        }
        if(brandObj.Speaking_Engagement__c != null){
            parentObjName = 'GT_Speaking_Engagement__c';
        }
        if(brandObj.Registration_Attend_Only__c != null){
            parentObjName = 'GT_Reg_Attend_Only__c';
        }
        if(brandObj.General_Event_Costs__c != null){
            parentObjName = 'GT_General_Event_Costs__c';
        }
        if(brandObj.Meeting_Planning__c != null){
            parentObjName = 'GT_Meeting_Planning__c';
        }
        if(brandObj.Sporting_Event__c != null){
            parentObjName = 'GT_Sporting_Event__c';
        }
        if(brandObj.Membership__c != null){
            parentObjName = 'GT_Membership__c';
        }
        
        return parentObjName;
    }
    
}