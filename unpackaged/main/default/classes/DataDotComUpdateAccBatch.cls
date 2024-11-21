/**
 * Class: DataDotComUpdateAccBatch.cls
 * Developer: Marian Iovi (marian.iovi@vertiba.com)
 * Created: January 26, 2017
 * Modified: -
 * Objective: This class provides methods for BoothUploadProcessingBatch.cls
 *
 *
 **/ 

global class DataDotComUpdateAccBatch implements Database.Batchable<SObject>, Database.AllowsCallouts {
    
    global String query {get;set;}
    global String ERBody { get; set; }
    global Boolean haveErr {get;set;}
    global String sessionId {get;set;}

    global DataDotComUpdateAccBatch(String s) {
        //query = 'SELECT Id, Isdeleted, Masterrecordid, Name, Type, Recordtypeid, Parentid, Billingstreet, Billingcity, Billingstate, Billingpostalcode, Billingcountry, Billinglatitude, Billinglongitude, Billinggeocodeaccuracy, Billingaddress, Shippingstreet, Shippingcity, Shippingstate, Shippingpostalcode, Shippingcountry, Shippinglatitude, Shippinglongitude, Shippinggeocodeaccuracy, ShippingAddress, Phone, Fax, Website, Photourl, Sic, Industry, Annualrevenue, Numberofemployees, Tickersymbol, Description, Site, Currencyisocode, Ownerid, Createddate, Createdbyid, Lastmodifieddate, Lastmodifiedbyid, Systemmodstamp, Lastactivitydate, Lastvieweddate, Lastreferenceddate, Iscustomerportal, Jigsaw, Jigsawcompanyid, Cleanstatus, Accountsource, Dunsnumber, Tradestyle, Naicscode, Naicsdesc, Yearstarted, Sicdesc, Dandbcompanyid, Duns_number__c, Portfolio__c, Number_of_shows__c, Lms_firm_id__c, Lms_facility_id__c, Facility_contract_contact__c, Commission_structure__c, Do_no_contact__c, Duplicate_account__c, Rfp_coming_out__c, Ges_account_type__c, Roi_clm__a_engagement_score_avg__c, Roi_clm__a_engagement_score_sum__c, This_account_is_a_duplicate_of__c, Ges_status__c, Facility_constr_renov_new_constr__c, Facility_construction_close_period__c, Nsf__c, Capabilities_presentation__c, Client_presentation__c, Hotel_calendar__c, Commissionable_firm__c, Presentation_date__c, Inactive__c, Gbms_venue_id__c, Portfolio_code__c, Sales_person__c, Roi_clm__a_lifecycle_stage__c, Classification__c, Jsimpacts__added_from_data_com__c, Jsimpacts__data_com_managed__c, Jsimpacts__data_com_matched__c, Jsimpacts__data_com_does_not_auto_update__c, Roi_clm__a_number_of_contacts__c, Roi_clm__a_profile_score_average__c, Roi_clm__a_profile_score_sum__c, Date_of_last_opportunity_bid__c, Owner_s_manager__c, Dba__c, Roi_clm__a_roi_id__c, Roi_clm__a_score_as_of__c, Billing_email_address__c, Last_modified_date_of_opportunity__c, Opportunities__c, Decorating_preferred__c, Decorating_exclusive__c, Electrical_preferred__c, Electrical_exclusive__c, Account_date__c, Client_vp__c, Credit_limit__c, Erp_id__c, Decorating_ges_commission__c, Facility__c, Gbms_customerid__c, Electrical_ges_commission__c, Payment_terms__c, Relationship_type__c, Ship__c, Rigging_ges_commission__c, Plumbing_ges_commission__c, Approval_status__c, Ges_master_customer_number__c, Oracle_ar_cust_creation_date__c, Oracle_ar_cust_account_id__c, Oracle_ar_cust_last_update_date__c, Oracle_ar_cust_number__c, Oracle_ar_cust_status__c, Create_new__c, Audio_visual_ges_commission__c, Labor_ges_commission__c, Materials_ges_commission__c, Carpet_ges_commission__c, Graphics_ges_commission__c, Standard_furniture_ges_commission__c, Ges_relationship__c, Custom_furniture_ges_commission__c, Janitorial_ges_commission__c, Rental_booths_ges_commission__c, Custom_booths_ges_commission__c, Exhibitor_account_type__c, Total_ges_revenue__c, Drayage_ges_commission__c, Sfdc__c, Owner_is_active__c, Amount_closed_won_cy_expo__c, Balance_due__c, Billable__c, Credit_available__c, Discount__c, Labor_price__c, Main_city__c, Main_country__c, Main_postal_code__c, Main_state__c, Main_street__c, Pay_at__c, Pay_method__c, R2_id__c, R2_sales_person__c, Terms__c, Emea_finance_approved__c, Sop_sync__c, Alternative_org_name_1__c, Alternative_org_name_2__c, Alternative_org_name_3__c, Batch__c, Business_type__c, Cust_type__c, Date_created_sop__c, Department__c, Emea__c, Euro_sop_id__c, Last_modified_in_sop__c, Me_sop_id__c, Tax__c, Uk_sop_id__c, Vip_client__c, Vat_number__c, Account_issue__c, Account_issue_yes_no__c, Business_type_numerical_value__c, Onpeak_housing_provider__c, Onpeak_housing_contract_exp_date__c, Xblitz_updated_9_2015__c, Is_phone_populated__c, Is_website_populated__c, Is_billing_address_populated__c, Under_contract__c, Provider__c, Phone_visibility__c, Is_account_type_populated__c, Contract_expiration_date__c, Win_percentage__c, Executive_sponsor__c, Is_portfolio_code_populated__c, Sync_with_marketo__c, Count_of_opportunities__c, Count_of_won_opportunities__c, Date_of_last_won_deal__c, Total_value_of_won_opportunities__c, Emea_sales_tag__c, Malongitude__c, Malatitude__c, Vat_number_country_code__c, Vat_registered_address__c, Vat_registered_company__c, Vies_vat_validation_status__c, Source_exhibitor_upload__c, Exhibitor_ondatacom__c FROM Account Where Source_Exhibitor_Upload__c = true and Exhibitor_onDataCom__c = true';
        query = 'SELECT Id, Isdeleted, Name, Type, Recordtypeid, Parentid, Billingstreet, Billingcity, Billingstate, Billingpostalcode, Billingcountry, Billinglatitude, Billinglongitude, Billingaddress, Shippingstreet, Shippingcity, Shippingstate, Shippingpostalcode, Shippingcountry, Shippinglatitude, Shippinglongitude, Shippinggeocodeaccuracy, ShippingAddress, Phone, Fax, Website, Photourl, Sic, Industry, Annualrevenue, Numberofemployees, Description, Site, Currencyisocode, Ownerid, Createddate, Createdbyid, Lastmodifieddate, Lastmodifiedbyid, Lastactivitydate, Lastvieweddate, Lastreferenceddate, Cleanstatus, Accountsource, Dunsnumber, Tradestyle, Naicscode, Naicsdesc, Yearstarted, Sicdesc, Dandbcompanyid, Duns_number__c, Portfolio__c, Number_of_shows__c, Lms_firm_id__c, Lms_facility_id__c, Facility_contract_contact__c, Commission_structure__c, Do_no_contact__c, Duplicate_account__c, Ges_account_type__c, Ges_status__c, Inactive__c, Classification__c, Billing_email_address__c, Opportunities__c, Account_date__c, Credit_limit__c, Facility__c, Payment_terms__c, Relationship_type__c, Exhibitor_account_type__c, Sfdc__c, Emea_finance_approved__c, Sop_sync__c, Alternative_org_name_1__c, Alternative_org_name_2__c, Alternative_org_name_3__c, Batch__c, Business_type__c, Cust_type__c, Date_created_sop__c, Department__c, Emea__c, Euro_sop_id__c, Last_modified_in_sop__c, Me_sop_id__c, Tax__c, Uk_sop_id__c, Vip_client__c, Vat_number__c, Business_type_numerical_value__c, Under_contract__c, Is_account_type_populated__c, Sync_with_marketo__c, Vat_number_country_code__c, Vat_registered_address__c, Vat_registered_company__c, Vies_vat_validation_status__c, Source_exhibitor_upload__c, Exhibitor_ondatacom__c FROM Account Where Source_Exhibitor_Upload__c = true and Exhibitor_onDataCom__c = true';
        haveErr = false;
        sessionId = s;
        String ERBody = 'Errors on runing DataDotComUpdateAccBatch.cls <br/><br/><br/>';
        //get all fields from Account obj
        /*Boolean first = true;
        SObjectType accountType = Schema.getGlobalDescribe().get('Account');
        Map<String,Schema.SObjectField> mfields = accountType.getDescribe().fields.getMap();
        for(String name: mfields.keySet()){
            if(!first){
                query += ', ';
            }else{
                first = false;
            }
            query += name.capitalize();
        }
        query += ' FROM Account where Source_Exhibitor_Upload__c = true and Exhibitor_onDataCom__c = true';*/

        System.debug('***query: ' + query);
    }
    
    global Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext context, List<Account> scope) {
        System.debug('***scope: ' + scope);
        try{
            DataDotComUpdateHandler.updateAccounts(scope, sessionId);
        }catch(Exception e){
            haveErr = true;
            ERBody += 'The following error has occurred. <br/>';
            ERBody +=  e.getMessage() +'<br/><br/>';
        }
    }

    global void finish(Database.BatchableContext context) {
        if(haveErr){
            sendErrorEmail();
        }
    }

    global void sendErrorEmail(){
        List<InformaApiErrorEmail__c> emails = [Select Id, Name, Email__c from InformaApiErrorEmail__c];

        System.debug('***emails: ' + emails);
        //send emails if get errors
        if(emails.size() > 0){
            Messaging.reserveSingleEmailCapacity(2);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            // Strings to hold the email addresses to which you are sending the email.
            String[] toAddresses = new List<String>();
            for(Integer i = 0; i< emails.size();i++){
                toAddresses.add(emails.get(i).Email__c);
            }
            System.debug('Email adress: ' + toAddresses );

            // Assign the addresses for the To and CC lists to the mail object.
            mail.setToAddresses(toAddresses);
            mail.setSenderDisplayName('Salesforce Support');
            mail.setSubject('Informa integration errors');
            mail.setUseSignature(false);
            mail.setHtmlBody(ERBody);

            try{
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }catch(Exception ex){
                System.debug('***Error: ' + ex.getMessage());
            }
        }
    }
}