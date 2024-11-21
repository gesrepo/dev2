public class GT_ExhibitApexController {
    
    @AuraEnabled
    public Static String getProfileName(){
        id userId = userinfo.getProfileId();
        LIST<profile> ProfileName = new LIST<profile>();
        ProfileName = [select Name from profile where id = :userId LIMIT 1];
        Return ProfileName[0].Name;
    }
    @AuraEnabled
    public static string cloneRecord(GT_Exhibit__c fieldsOfRecordViewForm,Id recordId){
        List<GT_Brand__c> listToInsert=new List<GT_Brand__c>();
        List<GT_Brand__c> productsOfExhibit=[select Id,Exhibit__c,GES_Connect_Event__c,Brand_Name_Pharma__c,Brand_Team_Contact__c,
                                             Therapeutic_Area__c,Contact_Not_Listed__c,Business_Unit_Pharma__c,
                                             Finance_Coordinator__c,COE_Supported__c,Booth_Space_Cost_Estimated__c,Funding_Provider_Region__c,
                                             Booth_Space_Cost_Actual__c,Funding_Provider_Brand__c,Estimated_Cost_Origination__c,Funding_Provider_Department__c,
                                             GES_Costs_Estimated__c,Cost_Center__c,GES_Costs_Actual__c,Company_Code__c,CurrencyIsoCode,Canceled__c,Reason_for_Cancellation__c,
                                             Cancelled_Date__c from GT_Brand__c where Exhibit__c=:recordId];
        upsert fieldsOfRecordViewForm;
        if(productsOfExhibit.size()>0){
            for(GT_Brand__c brand : productsOfExhibit){
                GT_Brand__c b = new GT_Brand__c();
                b.Exhibit__c=fieldsOfRecordViewForm.Id;
                b.GES_Connect_Event__c=brand.GES_Connect_Event__c;
                b.Brand_Name_Pharma__c=brand.Brand_Name_Pharma__c;
                b.Brand_Team_Contact__c=brand.Brand_Team_Contact__c;
                b.Therapeutic_Area__c=brand.Therapeutic_Area__c;
                b.Contact_Not_Listed__c=brand.Contact_Not_Listed__c;
                b.Business_Unit_Pharma__c=brand.Business_Unit_Pharma__c;
                b.Finance_Coordinator__c=brand.Finance_Coordinator__c;
                b.COE_Supported__c=brand.COE_Supported__c;
                b.Booth_Space_Cost_Estimated__c=brand.Booth_Space_Cost_Estimated__c;
                b.Funding_Provider_Region__c=brand.Funding_Provider_Region__c;
                b.Booth_Space_Cost_Actual__c=brand.Booth_Space_Cost_Actual__c;
                b.Funding_Provider_Brand__c=brand.Funding_Provider_Brand__c;
                b.Estimated_Cost_Origination__c=brand.Estimated_Cost_Origination__c;
                b.Funding_Provider_Department__c=brand.Funding_Provider_Department__c;
                b.GES_Costs_Estimated__c=brand.GES_Costs_Estimated__c;
                b.Cost_Center__c=  brand.Cost_Center__c;
                b.GES_Costs_Actual__c=brand.GES_Costs_Actual__c;
                b.Company_Code__c=brand.Company_Code__c;
                b.CurrencyIsoCode=brand.CurrencyIsoCode;
                b.Canceled__c=brand.Canceled__c;
                b.Reason_for_Cancellation__c=brand.Reason_for_Cancellation__c;
                b.Cancelled_Date__c=brand.Cancelled_Date__c; 
                listToInsert.add(b);
            }
            insert listToInsert;
        }
        return fieldsOfRecordViewForm.Id;
    }
    @AuraEnabled
    public static string cloneRecordspeakingEngagement(GT_Speaking_Engagement__c fieldsOfRecordViewForm,Id recordId){
        system.debug('fieldsOfRecordViewForm'+fieldsOfRecordViewForm);
        system.debug('recordId'+recordId);
        List<GT_Brand__c> listToInsert=new List<GT_Brand__c>();
        List<GT_Brand__c> productsOfSE=[select Id,Therapeutic_Area__c,GES_Connect_Event__c,Therapeutic_Area_Subgroup__c,Speaking_Engagement__c,
                                        Product__c,Budget_Owner__c,Speaker_Cost_Estimated_CrownCastle__c,
                                        Funding_Provider_Region__c,Speaker_Cost_Actual_CrownCastle__c,NNI_Stakeholder__c,Estimate_Cost_Origin__c,
                                        NNI_Stakeholder_email__c,Purchase_Order_No__c,SOW__c,Value_for_SOW__c,
                                        SOW_Due_Date__c,SOW_Submitted_Date__c,Proposal_Due_Date__c,Proposal_Submitted_to_NNI__c,
                                        Budget_Forecast_Due__c,Budget_Forecast_Sent__c,Budget_Update_Due__c,Budget_Update_Sent__c,Survey_Monkey_Due__c,
                                        Survey_Monkey_Sent__c,Final_Invoice_Due__c,Final_Invoice_submitted_to_NNI__c,Cost_Savings_report_submitted_to_NNI__c,
                                        Canceled__c,Reason_for_Cancellation__c,Cancelled_Date__c
                                        from GT_Brand__c where Speaking_Engagement__c=:recordId];
        upsert fieldsOfRecordViewForm;
        system.debug('productsOfSE '+productsOfSE);
        
        if(productsOfSE.size()>0){
            for(GT_Brand__c brand : productsOfSE){
                GT_Brand__c b = new GT_Brand__c();
                b.Speaking_Engagement__c=fieldsOfRecordViewForm.Id;
                b.GES_Connect_Event__c=brand.GES_Connect_Event__c;
                b.Therapeutic_Area__c=brand.Therapeutic_Area__c;
                b.Therapeutic_Area_Subgroup__c=brand.Therapeutic_Area_Subgroup__c;
                b.Product__c=brand.Product__c;
                b.Budget_Owner__c=brand.Budget_Owner__c;
                b.Speaker_Cost_Estimated_CrownCastle__c=brand.Speaker_Cost_Estimated_CrownCastle__c;
                b.Funding_Provider_Region__c=brand.Funding_Provider_Region__c;
                b.Speaker_Cost_Actual_CrownCastle__c=brand.Speaker_Cost_Actual_CrownCastle__c;
                b.NNI_Stakeholder__c=brand.NNI_Stakeholder__c;
                b.Estimate_Cost_Origin__c=brand.Estimate_Cost_Origin__c;
                b.NNI_Stakeholder_email__c=brand.NNI_Stakeholder_email__c;
                b.Purchase_Order_No__c=brand.Purchase_Order_No__c;
                b.SOW__c=brand.SOW__c;
                b.Value_for_SOW__c=brand.Value_for_SOW__c;
                b.SOW_Submitted_Date__c=  brand.SOW_Submitted_Date__c;
                b.Proposal_Submitted_to_NNI__c=brand.Proposal_Submitted_to_NNI__c;
                b.Budget_Forecast_Sent__c=brand.Budget_Forecast_Sent__c;
                b.Budget_Update_Sent__c=brand.Budget_Update_Sent__c;
                b.Survey_Monkey_Sent__c=brand.Survey_Monkey_Sent__c;
                b.Final_Invoice_submitted_to_NNI__c=brand.Final_Invoice_submitted_to_NNI__c;
                b.Cost_Savings_report_submitted_to_NNI__c=brand.Cost_Savings_report_submitted_to_NNI__c;
                b.Canceled__c=brand.Canceled__c;
                b.Reason_for_Cancellation__c=brand.Reason_for_Cancellation__c;
                b.Cancelled_Date__c=brand.Cancelled_Date__c; 
                listToInsert.add(b);
            }
            insert listToInsert;
        }
        system.debug('fieldsOfRecordViewForm after upsert'+fieldsOfRecordViewForm.Id);
        return fieldsOfRecordViewForm.Id;
    }
    @AuraEnabled
    public static string cloneRecordMeetingRoom(GT_Meeting_Room__c fieldsOfRecordViewForm,Id recordId){
        system.debug('fieldsOfRecordViewForm'+fieldsOfRecordViewForm);
        system.debug('recordId'+recordId);
        List<GT_Brand__c> listToInsert=new List<GT_Brand__c>();
        List<GT_Brand__c> productsOfExhibit=[select Id,Meeting_Room__c,GES_Connect_Event__c,Brand_Name_Pharma__c,Brand_Team_Contact__c,
                                             Therapeutic_Area__c,Contact_Not_Listed__c,Business_Unit_Pharma__c,
                                             Finance_Coordinator__c,COE_Supported__c,Meeting_Room_Cost_Estimated_CrownCastle__c,Funding_Provider_Region__c,
                                             Meeting_Room_Cost_Actual_CrownCastle__c,Funding_Provider_Brand__c,Estimated_Cost_Origination__c,Funding_Provider_Department__c,
                                             Meeting_Room_Services_Cost_Estimated_CC__c,Cost_Center__c,Meeting_Room_Services_Cost_Actual_CC__c,Company_Code__c,CurrencyIsoCode,Canceled__c,Reason_for_Cancellation__c,
                                             Cancelled_Date__c from GT_Brand__c where Meeting_Room__c=:recordId];
        upsert fieldsOfRecordViewForm;
        system.debug('productsOfExhibit meeting room'+productsOfExhibit);
        if(productsOfExhibit.size()>0){
            for(GT_Brand__c brand : productsOfExhibit){
                GT_Brand__c b = new GT_Brand__c();
                b.Meeting_Room__c=fieldsOfRecordViewForm.Id;
                b.GES_Connect_Event__c=brand.GES_Connect_Event__c;
                b.Brand_Name_Pharma__c=brand.Brand_Name_Pharma__c;
                b.Brand_Team_Contact__c=brand.Brand_Team_Contact__c;
                b.Therapeutic_Area__c=brand.Therapeutic_Area__c;
                b.Contact_Not_Listed__c=brand.Contact_Not_Listed__c;
                b.Business_Unit_Pharma__c=brand.Business_Unit_Pharma__c;
                b.Finance_Coordinator__c=brand.Finance_Coordinator__c;
                b.COE_Supported__c=brand.COE_Supported__c;
                b.Meeting_Room_Cost_Estimated_CrownCastle__c=brand.Meeting_Room_Cost_Estimated_CrownCastle__c;
                b.Funding_Provider_Region__c=brand.Funding_Provider_Region__c;
                b.Meeting_Room_Cost_Actual_CrownCastle__c=brand.Meeting_Room_Cost_Actual_CrownCastle__c;
                b.Funding_Provider_Brand__c=brand.Funding_Provider_Brand__c;
                b.Estimated_Cost_Origination__c=brand.Estimated_Cost_Origination__c;
                b.Funding_Provider_Department__c=brand.Funding_Provider_Department__c;
                b.Meeting_Room_Services_Cost_Estimated_CC__c=brand.Meeting_Room_Services_Cost_Estimated_CC__c;
                b.Cost_Center__c=  brand.Cost_Center__c;
                b.Meeting_Room_Services_Cost_Actual_CC__c=brand.Meeting_Room_Services_Cost_Actual_CC__c;
                b.Company_Code__c=brand.Company_Code__c;
                b.CurrencyIsoCode=brand.CurrencyIsoCode;
                b.Canceled__c=brand.Canceled__c;
                b.Reason_for_Cancellation__c=brand.Reason_for_Cancellation__c;
                b.Cancelled_Date__c=brand.Cancelled_Date__c; 
                listToInsert.add(b);
            }
            insert listToInsert;
        }
        system.debug('fieldsOfRecordViewForm after upsert'+fieldsOfRecordViewForm.Id);
        return fieldsOfRecordViewForm.Id;
    }
    @AuraEnabled
    public static string cloneRecordSponsorship(GT_Sponsorship__c fieldsOfRecordViewForm,Id recordId){
        system.debug('fieldsOfRecordViewForm'+fieldsOfRecordViewForm);
        system.debug('recordId'+recordId);
        List<GT_Brand__c> listToInsert=new List<GT_Brand__c>();
        List<GT_Brand__c> productsSponsership=[select Id,Sponsorship__c,GES_Connect_Event__c,Brand_Name_Pharma__c,Brand_Team_Contact__c,
                                               Therapeutic_Area__c,Contact_Not_Listed__c,Business_Unit_Pharma__c,COE_Supported__c,Sponsorship_Cost_Estimated_CrownCastle__c,Funding_Provider_Region__c,
                                               Sponsorship_Cost_Actual_CrownCastle__c,Funding_Provider_Brand__c,Cost_Center__c,Funding_Provider_Department__c,Company_Code__c,
                                               CurrencyIsoCode
                                               from GT_Brand__c where Sponsorship__c=:recordId];
        upsert fieldsOfRecordViewForm;
        system.debug('productsSponsership'+productsSponsership);
        if(productsSponsership.size()>0){
            for(GT_Brand__c brand : productsSponsership){
                GT_Brand__c b = new GT_Brand__c();
                b.Sponsorship__c=fieldsOfRecordViewForm.Id;
                b.GES_Connect_Event__c=brand.GES_Connect_Event__c;
                b.Brand_Name_Pharma__c=brand.Brand_Name_Pharma__c;
                b.Brand_Team_Contact__c=brand.Brand_Team_Contact__c;
                b.Contact_Not_Listed__c=brand.Contact_Not_Listed__c;
                b.Business_Unit_Pharma__c=brand.Business_Unit_Pharma__c;
                b.Therapeutic_Area__c=brand.Therapeutic_Area__c;
                b.COE_Supported__c=brand.COE_Supported__c;
                b.Sponsorship_Cost_Estimated_CrownCastle__c=brand.Sponsorship_Cost_Estimated_CrownCastle__c;
                b.Funding_Provider_Region__c=brand.Funding_Provider_Region__c;
                b.Sponsorship_Cost_Actual_CrownCastle__c=brand.Sponsorship_Cost_Actual_CrownCastle__c;
                b.Company_Code__c=brand.Company_Code__c;
                b.Funding_Provider_Brand__c=brand.Funding_Provider_Brand__c;
                b.Cost_Center__c=  brand.Cost_Center__c;
                b.Funding_Provider_Department__c=brand.Funding_Provider_Department__c;
                b.CurrencyIsoCode=brand.CurrencyIsoCode;
                
                listToInsert.add(b);
            }
            insert listToInsert;
        }
        system.debug('fieldsOfRecordViewForm after upsert'+fieldsOfRecordViewForm.Id);
        return fieldsOfRecordViewForm.Id;
    }
    
    @AuraEnabled
    public static string getObjectName(Id ObjRecordId){
        return string.valueOf(ObjRecordId.getSobjectType());
    }
    @AuraEnabled
    public static GT_Speaking_Engagement__c CalendarValues(string recordId){
        GT_Speaking_Engagement__c se=[select Speaking_Engagement_Start_Date_Time__c,Speaking_Engagement_End_Date_Time__c from GT_Speaking_Engagement__c where id=:recordId];
        return se;
    }
    @AuraEnabled
    public static GT_Meeting_Room__c CalendarValuesMeetingRoom(string recordId){
        GT_Meeting_Room__c mr=[select Day_5_Close_date_time__c,Day_5_Open_date_time__c,Day_4_Close_date_time__c,Day_4_Open_date_time__c,Day_3_Close_date_time__c,Day_3_Open_date_time__c,Day_2_Close_date_time__c,Day_2_Open_date_time__c,
                               Day_1_Close_date_time__c,Day_1_Open_date_time__c,Meeting_Room_Time__c from GT_Meeting_Room__c where id=:recordId];
        return mr;
    }
    @AuraEnabled
    public static Date exhibitOpenDateValue(string recordId,string objectName){
        string queryString='select Id,GES_Connect_Event__r.Exhibit_Open_Date__c from '+objectName+' where Id ='+'\''+recordId+'\'';
        if(objectName == 'GT_Speaking_Engagement__c'){
            GT_Speaking_Engagement__c se=database.query(queryString);
            return se.GES_Connect_Event__r.Exhibit_Open_Date__c;
        }
        if(objectName == 'GT_Meeting_Room__c'){
            GT_Meeting_Room__c se=database.query(queryString);
            return se.GES_Connect_Event__r.Exhibit_Open_Date__c;
        }
        if(objectName == 'GT_Event_RL__c'){
            GT_Event_RL__c se=database.query(queryString);
            return se.GES_Connect_Event__r.Exhibit_Open_Date__c;
        }
        return null;
    }
    @AuraEnabled
    public static GT_Event_RL__c CalendarValuesEventRL(string recordId){
        GT_Event_RL__c eventrl=[select Day_5_Close_date_time__c,Day_5_Open_date_time__c,Day_4_Close_date_time__c,Day_4_Open_date_time__c,Day_3_Close_date_time__c,Day_3_Open_date_time__c,Day_2_Close_date_time__c,Day_2_Open_date_time__c,
                               Day_1_Close_date_time__c,Day_1_Open_date_time__c from GT_Event_RL__c where id=:recordId];
        return eventrl;
    }
    
    
}