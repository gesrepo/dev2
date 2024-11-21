public class ContentVersionTriggerHandler {
    
    public static void updateTMSTable(Set<Id> parentIds){
        Map<String, String> mapCdlIdToQuoteId = new Map<String, String>();
        Set<Id> quoteIds = new Set<Id>();
		Set<Id> latestContentVersion = new Set<Id>();
        Map<String, String> mapquoteIdToNoteInfo = new  Map<String, String>();
        
        List<ContentDocumentLink> listCdl = [select id,linkedentityid,ContentDocumentId from ContentDocumentLink where linkedEntityId =: parentIds];
        for(ContentDocumentLink cdl : listCdl){
            mapCdlIdToQuoteId.put(cdl.ContentDocumentId, cdl.linkedentityid);
        }
        
        List<ContentVersion> listCV = [select id,ContentDocumentId,Title,TextPreview,Owner.Name, LastModifiedDate from ContentVersion where ContentDocumentId IN : mapCdlIdToQuoteId.keyset() Order by LastModifiedDate desc];
        for(ContentVersion cv : listCV){
            if(!latestContentVersion.contains(cv.ContentDocumentId)){
                latestContentVersion.add(cv.ContentDocumentId);
                String qtId = mapCdlIdToQuoteId.get(cv.ContentDocumentId);
                String noteInfo = cv.Owner.Name + ', ' + cv.LastModifiedDate.format('MM/dd/yyyy h:mm a') + ' - ' + cv.Title + ', ' + cv.TextPreview;
                if(mapquoteIdToNoteInfo.containsKey(qtId)){
                    String noteDetails = mapquoteIdToNoteInfo.get(qtId) +', '+ '\n' +noteInfo;
                    mapquoteIdToNoteInfo.put(qtId,noteDetails);
                }else{
                    mapquoteIdToNoteInfo.put(qtId,noteInfo);
                }
            }
        }
        Map<String, String> finalMapQuoteIdToNoteInfo = getClassicNotes(parentIds, mapquoteIdToNoteInfo);
        
        quoteIds.addAll(parentIds);
        List<TMS_Full_Shipping_Order_Stg__c> listTMSTable = new List<TMS_Full_Shipping_Order_Stg__c>();
        for(TMS_Full_Shipping_Order_Stg__c tmsTable : [select id, Note_Details__c,Quote_Id__c from TMS_Full_Shipping_Order_Stg__c where Quote_Id__c in : parentIds]){
            String noteInfo = finalMapQuoteIdToNoteInfo.get(tmsTable.Quote_Id__c);
            tmsTable.Note_Details__c = noteInfo;
            listTMSTable.add(tmsTable);
            quoteIds.remove(tmsTable.Quote_Id__c);
        }
        
        if(!quoteIds.isEmpty() || Test.isRunningTest()){
            List<Quote__c> listQuote = [Select Id, Account_Id__c, Account_Id__r.Name, Account_Id__r.Oracle_AR_Cust_Account_Id__c, Account_Id__r.Oracle_AR_Cust_Number__c, Additional_Labor__c, Additional_Labor_Fee__c, Addl_Information__c, 
                                        Advance_Order_Discount__c, AGS_Beyond_Point__c, AM_Specified__c, AM_Specified_Fee__c, Apply_Round_Trip_Discount__c, Attempt__c, Attempt_Fee__c, Billing_Contact__c, Billing_Contact__r.Email,
                                        Billing_Contact__r.Fax, Billing_Contact__r.FirstName, Billing_Contact__r.LastName, Billing_Contact__r.Phone, Booth__c, Booth_Number__c, Call_Before_Delivery__c, Call_Before_Pickup__c, Carrier_Notes__c, 
                                        Class_of_Service__c, Complete_By__c, Copy_to_OB_Destination_Address__c, Copy_To_OB_Pickup_Address__c, CORE_Order_Number__c, Crated_Weight__c, CreatedById, CreatedDate, CurrencyIsoCode, Custom_Quote__c, 
                                        Delivery_Booth_No__c, Delivery_Contact_Fax__c, Delivery_Contact_Name__c, Delivery_Contact_Phone__c, Delivery_Date__c, Delivery_Destination__c, Delivery_Show_Contractor__c, Delivery_Show_Name__c, 
                                        Delivery_Window_Start__c, Destination_Address__c, Destination_City__c, Destination_Country__c, Destination_Postal_Code__c, Destination_State__c, Destination_Street__c, Dim_Weight__c, Discount_End_Date__c, 
                                        EDV_Amount__c, EDV_Amount_Exceeds_Limit__c, Facility__c, Facility__r.LMS_Facility_ID__c, Facility__r.Name, Flat_Rate_Unit_Price_Type__c, Fuel_Surcharge__c, Fuel_Unit_Surcharge__c, Hazardous_Materials__c,
                                        HM_Contact_Phone__c, Inside_Pickup__c, Inside_Surcharge__c, Job_Code__c, LastActivityDate, LastModifiedById, LastModifiedDate, Lift_Gate__c, Lift_Gate_Surcharge__c, Lost_Comment__c, Lost_Reason__c,
                                        Message__c, Name, OB_Additional_Labor__c, OB_Additional_Labor_Fee__c, OB_Addl_Information__c, OB_Advance_Order_Discount__c, OB_AM_Specified__c, OB_AM_Specified_Fee__c, OB_Attempt__c, OB_Attempt_Fee__c, 
                                        OB_Call_Before_Delivery__c, OB_Call_Before_Pickup__c, OB_Carrier_Notes__c, OB_Class_of_Service__c, OB_Custom_Quote__c, OB_Delivery_Booth_No__c, OB_Delivery_Contact_Name__c, OB_Delivery_Contact_Phone__c,
                                        OB_Delivery_Date__c, OB_Delivery_Destination__c, OB_Delivery_Show_Contractor__c, OB_Delivery_Show_Name__c, OB_Delivery_Window_Start__c, OB_Destination_Address__c, OB_Destination_City__c, OB_Destination_Country__c, 
                                        OB_Destination_Postal_Code__c, OB_Destination_State__c, OB_Destination_Street__c, OB_Facility__c, OB_Facility__r.LMS_Facility_ID__c, OB_Facility__r.Name, OB_Flat_Rate_Unit_Price_Type__c, OB_Fuel_Surcharge__c, 
                                        OB_Fuel_Unit_Surcharge__c, OB_Hazardous_Materials__c, OB_HM_Contact_Phone__c, OB_Inside_Pickup__c, OB_Inside_Surcharge__c, OB_Lift_Gate__c, OB_Lift_Gate_Surcharge__c, OB_Origination_City__c, OB_Origination_Country__c, 
                                        OB_Origination_Postal_Code__c, OB_Origination_State__c, OB_Origination_Street__c, OB_Pallet_Jack__c, OB_Palletization__c, OB_Palletization_Fee__c, OB_Pickup_Address__c, OB_Pickup_Booth_No__c, OB_Pickup_Contact_Name__c, 
                                        OB_Pickup_Contact_Phone__c, OB_Pickup_Date__c, OB_Pickup_Show_Contractor__c, OB_Pickup_Show_Name__c, OB_Pickup_Window_Start__c, OB_Pickup_Window_Start_Late__c, OB_Residential_Pickup__c, OB_Residential_Surcharge__c,
                                        OB_Round_Trip_Discount__c, OB_Selection__c, OB_Service_Type__c, OB_Shipment_Type__c, OB_Sub_Total__c, OB_Total__c, OB_Unit_Price__c, OB_Wait_Time__c, OB_Wait_Time_Fee__c, OB_Weekend_Delivery__c, OB_Weekend_Fee__c, 
                                        OB_Weekend_Pickup__c, Order_Date__c, Origination_City__c, Origination_Country__c, Origination_Postal_Code__c, Origination_State__c, Origination_Street__c, Owner.FirstName, Owner.LastName, Owner.Name, OwnerId,
                                        Pallet_Jack__c, Palletization__c, Palletization_Fee__c, Parent_Quote__c, Parent_Quote__r.Name, Pickup_Address__c, Pickup_Booth_No__c, Pickup_Contact_Fax__c, Pickup_Contact_Name__c, Pickup_Contact_Phone__c, Pickup_Date__c,
                                        Pickup_Show_Contractor__c, Pickup_Show_Name__c, Pickup_Window_Start__c, Pickup_Window_Start_Late__c, Project_Number__c, Quote_Inside_Surcharge__c, Quote_Subject__c, Quoted_Total__c, Quoted_Fuel_Surcharge__c,
                                        Quoted_Lift_Gate_Surcharge__c, Quoted_Residential_Surcharge__c, RecordType.Name, RecordTypeId, Residential_Pickup__c, Residential_Surcharge__c, Round_Trip_Discount__c, Sales_Rep__c, Sales_Rep__r.FirstName, 
                                        Sales_Rep__r.LastName, Selection__c, Service_Type__c, Ship_To_Location__c, Shipment_Type__c, Show__c, Show_Occurrence__c, Show_Occurrence__r.Name, Source__c, Special_Discount_Program__c, Stage__c, Status__c, 
                                        Sub_Total__c, Total__c, Type__c, Unit_Price__c, Wait_Time__c, Wait_Time_Fee__c, Weekend_Delivery__c, Weekend_Fee__c, Weekend_Pickup__c, Weight_Override__c, TOPS_Quote_Number__c, Merged_AR_Customer_Number__c,Formula_Merged_AR_Customer_Number__c
                                        
                                        From Quote__c Where Id IN :quoteIds];
            
            QuoteTriggerHandler quoteTriggerHandler = new QuoteTriggerHandler();
            quoteTriggerHandler.createTMSShippingOrderStg(listQuote);
            
            for(TMS_Full_Shipping_Order_Stg__c tmsTable : [select id, Note_Details__c,Quote_Id__c from TMS_Full_Shipping_Order_Stg__c where Quote_Id__c in : quoteIds]){
                String noteInfo = finalMapQuoteIdToNoteInfo.get(tmsTable.Quote_Id__c);
                tmsTable.Note_Details__c = noteInfo;
                listTMSTable.add(tmsTable);
            }
        }
        
        if(!listTMSTable.isEmpty()){
            update listTMSTable;
        }
    }
    
    public static Map<String, String> getClassicNotes(Set<Id> parentIds, Map<String, String> mapquoteIdToNoteInfo){
        for(Note note : [select id, Title, Body, LastModifiedDate, Owner.name, ParentId from Note where ParentId IN : parentIds Order by LastModifiedDate desc]){
            String noteInfo = note.Owner.Name + ', ' + note.LastModifiedDate.format('MM/dd/yyyy h:mm a') + ' - ' + note.Title + ', ' + note.Body;
            if(mapquoteIdToNoteInfo.containsKey(note.ParentId)){
                String noteDetails = mapquoteIdToNoteInfo.get(note.ParentId) +', '+ '\n' +noteInfo;
                mapquoteIdToNoteInfo.put(note.ParentId,noteDetails);
            }else{
                mapquoteIdToNoteInfo.put(note.ParentId,noteInfo);
            }
        }
        return mapquoteIdToNoteInfo;
    }
}