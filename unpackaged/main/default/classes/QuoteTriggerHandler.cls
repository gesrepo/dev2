public class QuoteTriggerHandler {
    
    public void createTMSShippingOrderStg(List<Quote__c> listQuote){
        List<TMS_Full_Shipping_Order_Stg__c> tmsFullShippingOrderStgList = new List<TMS_Full_Shipping_Order_Stg__c>();
        Set<Id> quoteIds = new Set<Id>(); 
        Set<Id> accIds = new Set<Id>();
        Set<Id> contIds = new Set<Id>();
        Set<Id> ownerIds = new Set<Id>();
        Set<Id> parentQuoteIds = new Set<Id>();
        Set<Id> showOccurIds = new Set<Id>();
        Set<Id> recordTypeIds = new Set<Id>();
        Set<Id> groupIds = new Set<Id>();
        
        for(Quote__c quote: listQuote){
            quoteIds.add(quote.Id);
            accIds.add(quote.Account_Id__c);
            accIds.add(quote.Facility__c);
            accIds.add(quote.OB_Facility__c);
            contIds.add(quote.Billing_Contact__c);
            String owId = quote.OwnerId;
            if(owId.StartsWith('00G')){
                groupIds.add(quote.OwnerId);
            }else{
                ownerIds.add(quote.OwnerId);
            }
            ownerIds.add(quote.Sales_Rep__c);
            parentQuoteIds.add(quote.Parent_Quote__c);
            showOccurIds.add(quote.Show_Occurrence__c);
            recordTypeIds.add(quote.RecordTypeId);
        }
        
        Map<Id, Account> mapAccount = new Map<Id, Account>([Select id, name, Oracle_AR_Cust_Account_Id__c, Oracle_AR_Cust_Number__c, LMS_Facility_ID__c from Account where Id IN: accIds]);
        Map<Id, Contact> mapContact = new Map<Id, Contact>([Select id, firstname, lastname, name, email, fax, phone from Contact where Id IN: contIds]);
        Map<Id, Quote__c> mapQuote = new Map<Id, Quote__c>([Select id, name from Quote__c where Id IN: parentQuoteIds]);
        Map<Id, Opportunity> mapOpportunity = new Map<Id, Opportunity>([Select id, name,Show_ID_LMS_Calculated__c from Opportunity where Id IN: showOccurIds]);
        Map<Id, RecordType> mapRecordType = new Map<Id, RecordType>([Select id, name from RecordType where Id IN: recordTypeIds]);
        Map<Id, User> mapUser;
        Map<Id, Group> mapGroup;
        if(groupIds != null){
            mapGroup = new Map<Id, Group>([Select id, name from Group where Id IN: groupIds]);
        }
        if(ownerIds != null){
            mapUser = new Map<Id, User>([Select id, firstname, lastname, name from user where Id IN: ownerIds]);
        }
        
        for(Quote__c quote: listQuote){
            Account acc = mapAccount.get(quote.Account_Id__c);
            Account facility = mapAccount.get(quote.Facility__c);
            Account obFacility = mapAccount.get(quote.OB_Facility__c);
            Contact con = mapContact.get(quote.Billing_Contact__c);
            User salesRep = mapUser.get(quote.Sales_Rep__c);
            Quote__c parentQuote = mapQuote.get(quote.Parent_Quote__c);
            Opportunity showOccurance = mapOpportunity.get(quote.Show_Occurrence__c);
            RecordType recType = mapRecordType.get(quote.RecordTypeId);
            String owId = quote.OwnerId;
            User ownerRec;
            Group groupRec;
            if(owId.StartsWith('00G')){
                groupRec = mapGroup.get(quote.OwnerId);
            }else{
                ownerRec = mapUser.get(quote.OwnerId);
            }
            
            System.debug('New stage record created for newly quote record');
            TMS_Full_Shipping_Order_Stg__c tmsShippingOrderStg = new TMS_Full_Shipping_Order_Stg__c();
            tmsFullShippingOrderStgList.add(updateTMSShippingRecord(quote, tmsShippingOrderStg, null, acc, facility, obFacility, con, ownerRec, salesRep, parentQuote, showOccurance, recType, groupRec)); 
        }
        
        if(tmsFullShippingOrderStgList != null && tmsFullShippingOrderStgList.size() >0){
            insert tmsFullShippingOrderStgList;
        }
    }
    
    public void updateTMSShippingOrderStg(List<Quote__c> listQuote){
        List<TMS_Full_Shipping_Order_Stg__c> updateTMSFullShippingOrderStgList = new List<TMS_Full_Shipping_Order_Stg__c>();
        List<TMS_Full_Shipping_Order_Stg__c> insertTMSFullShippingOrderStgList = new List<TMS_Full_Shipping_Order_Stg__c>();
        Map<Id, LIST<TMS_Full_Shipping_Order_Stg__c>> mapFreightItemIdTOShippingOrderStg = new Map<Id, LIST<TMS_Full_Shipping_Order_Stg__c>>();
        Map<Id, LIST<Freight_Item__c>> mapFreightItem = new Map<Id, LIST<Freight_Item__c>>();
        Set<Id> quoteIds = new Set<Id>(); 
        Set<Id> accIds = new Set<Id>();
        Set<Id> contIds = new Set<Id>();
        Set<Id> ownerIds = new Set<Id>();
        Set<Id> parentQuoteIds = new Set<Id>();
        Set<Id> showOccurIds = new Set<Id>();
        Set<Id> recordTypeIds = new Set<Id>();
        Set<Id> groupIds = new Set<Id>();       
        
        
        for(Quote__c quote: listQuote){
            quoteIds.add(quote.Id);
            accIds.add(quote.Account_Id__c);
            accIds.add(quote.Facility__c);
            accIds.add(quote.OB_Facility__c);
            contIds.add(quote.Billing_Contact__c);
            String owId = quote.OwnerId;
            if(owId.StartsWith('00G')){
                groupIds.add(quote.OwnerId);
            }else{
                ownerIds.add(quote.OwnerId);
            }
            ownerIds.add(quote.Sales_Rep__c);
            parentQuoteIds.add(quote.Parent_Quote__c);
            showOccurIds.add(quote.Show_Occurrence__c);
            recordTypeIds.add(quote.RecordTypeId);
        }
        
        
        Map<Id, Account> mapAccount = new Map<Id, Account>([Select id, name, Oracle_AR_Cust_Account_Id__c, Oracle_AR_Cust_Number__c, LMS_Facility_ID__c from Account where Id IN: accIds]);
        Map<Id, Contact> mapContact = new Map<Id, Contact>([Select id, firstname, lastname, name, email, fax, phone from Contact where Id IN: contIds]);
        Map<Id, Quote__c> mapQuote = new Map<Id, Quote__c>([Select id, name from Quote__c where Id IN: parentQuoteIds]);
        Map<Id, Opportunity> mapOpportunity = new Map<Id, Opportunity>([Select id, name,Show_ID_LMS_Calculated__c from Opportunity where Id IN: showOccurIds]);
        Map<Id, RecordType> mapRecordType = new Map<Id, RecordType>([Select id, name from RecordType where Id IN: recordTypeIds]);
        Map<Id, User> mapUser;
        Map<Id, Group> mapGroup;
        if(groupIds != null){
            mapGroup = new Map<Id, Group>([Select id, name from Group where Id IN: groupIds]);
        }
        if(ownerIds != null){
            mapUser = new Map<Id, User>([Select id, firstname, lastname, name from user where Id IN: ownerIds]);
        }
        
        List<Freight_Item__c> listFreightItem = [Select Id, Name, Crated_Weight__c, CreatedById, CreatedDate, CurrencyIsoCode, Description__c, 
                                                                                Hazardous_Material__c, Height__c, LastModifiedById, LastModifiedDate, Length__c, Line_Number__c, 
                                                                                Quantity__c, Quote__c, Quote__r.Name, Width__c, Void__c from Freight_Item__c 
                                                                                where Quote__c IN: quoteIds];
        
        for(Freight_Item__c freightItem : listFreightItem){
            if(mapFreightItem.containsKey(freightItem.Quote__c) && mapFreightItem.get(freightItem.Quote__c)!= null){
                List<Freight_Item__c> lst_fi = mapFreightItem.get(freightItem.Quote__c);
                lst_fi.add(freightItem);
                mapFreightItem.put(freightItem.Quote__c,lst_fi); 
            }else{
                mapFreightItem.put(freightItem.Quote__c,new List<Freight_Item__c>{freightItem});
            }
        }
        
        
        List<TMS_Full_Shipping_Order_Stg__c> listTMSShippingOrderStg = [Select Id, Account_Id__c, Account_Name__c, Oracle_AR_Cust_Account_Id__c, Oracle_AR_Cust_Number__c, Additional_Labor__c, Additional_Labor_Fee__c, Addl_Information__c, Advance_Order_Discount__c, AGS_Beyond_Point__c, AM_Specified__c, AM_Specified_Fee__c, Apply_Round_Trip_Discount__c, Attempt__c, Attempt_Fee__c, 
                                                                        Billing_Contact__c, Billing_Contact_Email__c, Billing_Contact_Fax__c, Billing_Contact_FirstName__c, Billing_Contact_LastName__c, Billing_Contact_Phone__c, Booth__c, Booth_Number__c, Call_Before_Delivery__c, Call_Before_Pickup__c, Carrier_Notes__c, Class_of_Service__c, Complete_By__c, Copy_to_OB_Destination_Address__c,
                                                                        Copy_To_OB_Pickup_Address__c, CORE_Order_Number__c, Crated_Weight__c, Quote_CreatedByID__c, Quote_CreatedDate__c, Quote_CurrencyIsoCode__c, Custom_Quote__c, Delivery_Booth_No__c, Delivery_Contact_Fax__c, Delivery_Contact_Name__c, Delivery_Contact_Phone__c, Delivery_Date__c, Delivery_Destination__c, Delivery_Show_Contractor__c,
                                                                        Delivery_Show_Name__c, Delivery_Window_Start__c, Destination_Address__c, Destination_City__c, Destination_Country__c, Destination_Postal_Code__c, Destination_State__c, Destination_Street__c, Dim_Weight__c, Discount_End_Date__c, EDV_Amount__c, EDV_Amount_Exceeds_Limit__c, Facility__c, Facility_LMS_Facility_ID__c, Facility_Name__c, 
                                                                        Flat_Rate_Unit_Price_Type__c, Fuel_Surcharge__c, Fuel_Unit_Surcharge__c, Hazardous_Material__c, HM_Contact_Phone__c, Quote_Id__c, Inside_Pickup__c, Inside_Surcharge__c, Job_Code__c, Quote_LastActivityDate__c, Quote_LastModifiedById__c, Quote_LastModifiedDate__c, Lift_Gate__c, Lift_Gate_Surcharge__c, Lost_Comment__c, Lost_Reason__c,
                                                                        Message__c, Quote_Name__c, OB_Additional_Labor__c, OB_Additional_Labor_Fee__c, OB_Addl_Information__c, OB_Advance_Order_Discount__c, OB_AM_Specified__c, OB_AM_Specified_Fee__c, OB_Attempt__c, OB_Attempt_Fee__c, OB_Call_Before_Delivery__c, OB_Call_Before_Pickup__c, OB_Carrier_Notes__c, OB_Class_of_Service__c, OB_Custom_Quote__c,
                                                                        OB_Delivery_Booth_No__c, OB_Delivery_Contact_Name__c, OB_Delivery_Contact_Phone__c, OB_Delivery_Date__c, OB_Delivery_Destination__c, OB_Delivery_Show_Contractor__c, OB_Delivery_Show_Name__c, OB_Delivery_Window_Start__c, OB_Destination_Address__c, OB_Destination_City__c, OB_Destination_Country__c, OB_Destination_Postal_Code__c,
                                                                        OB_Destination_State__c, OB_Destination_Street__c, OB_Facility__c, OB_Facility_LMS_Facility_ID__c, OB_Facility_Name__c, OB_Flat_Rate_Unit_Price_Type__c, OB_Fuel_Surcharge__c, OB_Fuel_Unit_Surcharge__c, OB_Hazardous_Materials__c, OB_HM_Contact_Phone__c, OB_Inside_Pickup__c, OB_Inside_Surcharge__c, OB_Lift_Gate__c, OB_Lift_Gate_Surcharge__c,
                                                                        OB_Origination_City__c, OB_Origination_Country__c, OB_Origination_Postal_Code__c, OB_Origination_State__c, OB_Origination_Street__c, OB_Pallet_Jack__c, OB_Palletization__c, OB_Palletization_Fee__c, OB_Pickup_Address__c, OB_Pickup_Booth_No__c, OB_Pickup_Contact_Name__c, OB_Pickup_Contact_Phone__c, OB_Pickup_Date__c, OB_Pickup_Show_Contractor__c,
                                                                        OB_Pickup_Show_Name__c, OB_Pickup_Window_Start__c, OB_Pickup_Window_Start_Late__c, OB_Residential_Pickup__c, OB_Residential_Surcharge__c, OB_Round_Trip_Discount__c, OB_Selection__c, OB_Service_Type__c, OB_Shipment_Type__c, OB_Sub_Total__c, OB_Total__c, OB_Unit_Price__c, OB_Wait_Time__c, OB_Wait_Time_Fee__c, OB_Weekend_Delivery__c, OB_Weekend_Fee__c,
                                                                        OB_Weekend_Pickup__c, Order_Date__c, Origination_City__c, Origination_Country__c, Origination_Postal_Code__c, Origination_State__c, Origination_Street__c, Quote_Owner_FirstName__c, Quote_Owner_LastName__c, Quote_Owner_Name__c, Quote_OwnerId__c, Pallet_Jack__c, Palletization__c, Palletization_Fee__c, Parent_Quote__c, Parent_Quote_Name__c, Pickup_Address__c,
                                                                        Pickup_Booth_No__c, Pickup_Contact_Fax__c, Pickup_Contact_Name__c, Pickup_Contact_Phone__c, Pickup_Date__c, Pickup_Show_Contractor__c, Pickup_Show_Name__c, Pickup_Window_Start__c, Pickup_Window_Start_Late__c, Project_Number__c, Quote_Inside_Surcharge__c, Quote_Subject__c, Quoted_Total__c, Quoted_Fuel_Surcharge__c, Quoted_Lift_Gate_Surcharge__c,
                                                                        Quoted_Residential_Surcharge__c, Quote_RecordType_Name__c, Quote_RecordTypeId__c, Residential_Pickup__c, Residential_Surcharge__c, Round_Trip_Discount__c, Sales_Rep__c, Sales_Rep_FirstName__c, Sales_Rep_LastName__c, Selection__c, Service_Type__c, Ship_To_Location__c, Shipment_Type__c, Show__c, Show_Occurrence__c, Show_Occurrence_Name__c,
                                                                        Source__c, Special_Discount_Program__c, Stage__c, Status__c, Sub_Total__c, Total__c, Type__c, Unit_Price__c, Wait_Time__c, Wait_Time_Fee__c, Weekend_Delivery__c, Weekend_Fee__c, Weekend_Pickup__c, Weight_Override__c, TOPS_Quote_Number__c, Merged_AR_Customer_Number__c, FI_Crated_Weight__c, FI_CreatedById__c, FI_CreatedDate__c, FI_CurrencyIsoCode__c,
                                                                        Description__c, Height__c, FI_Id__c, FI_LastModifiedById__c, FI_LastModifiedDate__c, Length__c, Line_Number__c, FI_Name__c, Quantity__c, Width__c, Void__c
                                                                        , Delivery_Contact_Email__c, OB_Delivery_Contact_Email__c, Pickup_Contact_Email__c, OB_Pickup_Contact_Email__c  //AMARAB 2/2/2024 to add emails
                                                                        , Inbound_Stage__c, Outbound_Stage__c, TMS_Inbound_Shipping_Order__c, TMS_Outbound_Shipping_Order__c   //AMARAB 5/21/2024 to add Order # and Stage
                                                                        , Beyond_Point__c, OB_Beyond_Point__c, IN_Beyond_Point_Fee__c, OB_Beyond_Point_Fee__c, NY_City__c, OB_NY_City__c, IN_New_York_City_Fee__c, OB_New_York_City_Fee__c //Amarab 06/28/2024 to add beyond point and ny city fields
                                                                        , Show_Open_Date__c, Show_Close_Date__c, Oracle_Booth_Id__c, Inbound_Owner__c, Outbound_Owner__c //Amarab 09/11/2024 to add booth, Inbound Outbound Owner fields
                                                                        from TMS_Full_Shipping_Order_Stg__c where Quote_Id__c IN: quoteIds];
        
        
        
        for(TMS_Full_Shipping_Order_Stg__c tmsShippingOrderStg : listTMSShippingOrderStg){
            if(mapFreightItemIdTOShippingOrderStg.containsKey(tmsShippingOrderStg.Quote_Id__c) && mapFreightItemIdTOShippingOrderStg.get(tmsShippingOrderStg.Quote_Id__c)!= null){
                List<TMS_Full_Shipping_Order_Stg__c> lst_stgRecord = mapFreightItemIdTOShippingOrderStg.get(tmsShippingOrderStg.Quote_Id__c);
                lst_stgRecord.add(tmsShippingOrderStg);
                mapFreightItemIdTOShippingOrderStg.put(tmsShippingOrderStg.Quote_Id__c,lst_stgRecord); 
            }else{
                mapFreightItemIdTOShippingOrderStg.put(tmsShippingOrderStg.Quote_Id__c,new List<TMS_Full_Shipping_Order_Stg__c>{tmsShippingOrderStg});
            }
        }
        
        Boolean isFINull = false;
        Boolean isFIUpdated = false;
        for(Quote__c quote: listQuote){
            Account acc = mapAccount.get(quote.Account_Id__c);
            Account facility = mapAccount.get(quote.Facility__c);
            Account obFacility = mapAccount.get(quote.OB_Facility__c);
            Contact con = mapContact.get(quote.Billing_Contact__c);
            User salesRep = mapUser.get(quote.Sales_Rep__c);
            Quote__c parentQuote = mapQuote.get(quote.Parent_Quote__c);
            Opportunity showOccurance = mapOpportunity.get(quote.Show_Occurrence__c);
            RecordType recType = mapRecordType.get(quote.RecordTypeId);
            String owId = quote.OwnerId;
            User ownerRec = null;
            Group groupRec = null;
            if(owId.StartsWith('00G')){
                groupRec = mapGroup.get(quote.OwnerId);
            }else{
                ownerRec = mapUser.get(quote.OwnerId);
            }
            
            List<TMS_Full_Shipping_Order_Stg__c> listTMSShippingOrder = mapFreightItemIdTOShippingOrderStg.get(quote.Id);
            List<Freight_Item__c> listfi = mapFreightItem.get(quote.Id);
            
            if(listfi != null && listfi.size() >0){
                for(Freight_Item__c fi : listfi){
                    isFINull = false;
                    isFIUpdated = false;
                    TMS_Full_Shipping_Order_Stg__c tempTMSShippingOrder = new TMS_Full_Shipping_Order_Stg__c();
                    if(listTMSShippingOrder != null && listTMSShippingOrder.size() > 0){
                        for(TMS_Full_Shipping_Order_Stg__c tmsShippingOrder:listTMSShippingOrder ){
                            if(tmsShippingOrder.FI_Id__c == fi.Id){ // if freight item exist in stage table
                                System.debug('freight item exist in stage table, updated exisitng one');
                                updateTMSFullShippingOrderStgList.add(updateTMSShippingRecord(quote, tmsShippingOrder, fi, acc, facility, obFacility, con, ownerRec, salesRep, parentQuote, showOccurance,recType, groupRec));
                                isFIUpdated = true;
                            }else if(tmsShippingOrder.FI_Id__c == null){ // when fright item not associated with stage table 
                                tempTMSShippingOrder = tmsShippingOrder;
                                isFINull = true;
                            }
                        }
                        if(isFINull && !isFIUpdated){
                             System.debug('freight item not exist in stage table but stage record exist without frieght detail, updateed exisitng one');
                            updateTMSFullShippingOrderStgList.add(updateTMSShippingRecord(quote, tempTMSShippingOrder, fi, acc, facility, obFacility, con, ownerRec, salesRep, parentQuote, showOccurance,recType, groupRec));                       
                        }
                        else if(!isFINull && !isFIUpdated){
                            System.debug('1-Freight item associated with Quote but no stage record found, created new one');
                            TMS_Full_Shipping_Order_Stg__c newTMSShippingOrder = new TMS_Full_Shipping_Order_Stg__c();
                            insertTMSFullShippingOrderStgList.add(updateTMSShippingRecord(quote, newTMSShippingOrder, fi, acc, facility, obFacility, con, ownerRec, salesRep, parentQuote, showOccurance,recType, groupRec));    
                        }
                    }else{
                        System.debug('2-Freight record associated with Quote but no stage record found, created new one');
                        TMS_Full_Shipping_Order_Stg__c newTMSShippingOrder = new TMS_Full_Shipping_Order_Stg__c();
                        insertTMSFullShippingOrderStgList.add(updateTMSShippingRecord(quote, newTMSShippingOrder, fi, acc, facility, obFacility, con, ownerRec, salesRep, parentQuote, showOccurance,recType, groupRec)); 
                    } 
                }
            }else{
                if(listTMSShippingOrder != null && listTMSShippingOrder.size() > 0){
                    for(TMS_Full_Shipping_Order_Stg__c tmsShippingOrder:listTMSShippingOrder ){
                        System.debug('No Freight item linked to quote but stage record found, updated all stage records');
                        updateTMSFullShippingOrderStgList.add(updateTMSShippingRecord(quote, tmsShippingOrder, null, acc, facility, obFacility, con, ownerRec, salesRep, parentQuote, showOccurance,recType, groupRec));   
                    }
                }
                else{
                    System.debug('No Freight item linked to quote and no stage record found, created new stage record');
                    TMS_Full_Shipping_Order_Stg__c newTMSShippingOrder = new TMS_Full_Shipping_Order_Stg__c();
                    insertTMSFullShippingOrderStgList.add(updateTMSShippingRecord(quote, newTMSShippingOrder, null, acc, facility, obFacility, con, ownerRec, salesRep, parentQuote, showOccurance,recType, groupRec)); 
                }
            }
        }
        System.debug('updateTMSFullShippingOrderStgList:: '+updateTMSFullShippingOrderStgList.size());
        if(updateTMSFullShippingOrderStgList !=null && updateTMSFullShippingOrderStgList.size() > 0){
            TMS_Full_Shipping_Order_Stg__c tms = updateTMSFullShippingOrderStgList[0];
            System.debug('tms::: '+tms);
            update updateTMSFullShippingOrderStgList;
        }
        if(insertTMSFullShippingOrderStgList !=null && insertTMSFullShippingOrderStgList.size() > 0){
            insert insertTMSFullShippingOrderStgList;
        }
        
    }
    
    public TMS_Full_Shipping_Order_Stg__c updateTMSShippingRecord(Quote__c quote, TMS_Full_Shipping_Order_Stg__c tmsShippingOrder, Freight_Item__c freightItem, Account acc, Account facility, Account obFacility, Contact con, User ownerRec, User salesRep, Quote__c parentQuote, Opportunity showOccurance, RecordType recType, Group groupRec){
        System.debug('quote hazardus:: '+quote.Hazardous_Materials__c);
        if(acc != null){
            tmsShippingOrder.Account_Id__c = acc.Id;
            tmsShippingOrder.Account_Name__c = acc.Name;
            tmsShippingOrder.Oracle_AR_Cust_Account_Id__c = acc.Oracle_AR_Cust_Account_Id__c;
            tmsShippingOrder.Oracle_AR_Cust_Number__c = acc.Oracle_AR_Cust_Number__c;
        }
        tmsShippingOrder.Additional_Labor__c = quote.Additional_Labor__c;
        tmsShippingOrder.Additional_Labor_Fee__c = quote.Additional_Labor_Fee__c;
        tmsShippingOrder.Addl_Information__c = quote.Addl_Information__c;
        tmsShippingOrder.Advance_Order_Discount__c = quote.Advance_Order_Discount__c;
        tmsShippingOrder.AGS_Beyond_Point__c = quote.AGS_Beyond_Point__c;
        tmsShippingOrder.AM_Specified__c = quote.AM_Specified__c;
        tmsShippingOrder.AM_Specified_Fee__c = quote.AM_Specified_Fee__c;
        tmsShippingOrder.Apply_Round_Trip_Discount__c = quote.Apply_Round_Trip_Discount__c;
        tmsShippingOrder.Attempt__c = quote.Attempt__c;
        tmsShippingOrder.Attempt_Fee__c = quote.Attempt_Fee__c;
        if(con != null){
            tmsShippingOrder.Billing_Contact__c = con.Id;
            tmsShippingOrder.Billing_Contact_Email__c = con.Email;
            tmsShippingOrder.Billing_Contact_Fax__c = con.Fax;
            tmsShippingOrder.Billing_Contact_FirstName__c = con.FirstName;
            tmsShippingOrder.Billing_Contact_LastName__c = con.LastName;
            tmsShippingOrder.Billing_Contact_Phone__c = con.Phone;
        }
        tmsShippingOrder.Booth__c = quote.Booth__c;
        tmsShippingOrder.Booth_Number__c = quote.Booth_Number__c;
        tmsShippingOrder.Call_Before_Delivery__c = quote.Call_Before_Delivery__c;
        tmsShippingOrder.Call_Before_Pickup__c = quote.Call_Before_Pickup__c;
        tmsShippingOrder.Carrier_Notes__c = quote.Carrier_Notes__c;
        tmsShippingOrder.Class_of_Service__c = quote.Class_of_Service__c;
        tmsShippingOrder.Complete_By__c = quote.Complete_By__c;
        tmsShippingOrder.Copy_to_OB_Destination_Address__c = quote.Copy_to_OB_Destination_Address__c;
        tmsShippingOrder.Copy_To_OB_Pickup_Address__c = quote.Copy_To_OB_Pickup_Address__c;
        tmsShippingOrder.CORE_Order_Number__c = quote.CORE_Order_Number__c;
        tmsShippingOrder.Crated_Weight__c = quote.Crated_Weight__c;
        tmsShippingOrder.Quote_CreatedByID__c = quote.CreatedById;
        tmsShippingOrder.Quote_CreatedDate__c = quote.CreatedDate;
        tmsShippingOrder.Quote_CurrencyIsoCode__c = quote.CurrencyIsoCode;
        tmsShippingOrder.Custom_Quote__c = quote.Custom_Quote__c;
        tmsShippingOrder.Delivery_Booth_No__c = quote.Delivery_Booth_No__c;
        tmsShippingOrder.Delivery_Contact_Fax__c = quote.Delivery_Contact_Fax__c;
        tmsShippingOrder.Delivery_Contact_Name__c = quote.Delivery_Contact_Name__c;
        tmsShippingOrder.Delivery_Contact_Phone__c = quote.Delivery_Contact_Phone__c;
        tmsShippingOrder.Delivery_Date__c = quote.Delivery_Date__c;
        tmsShippingOrder.Delivery_Destination__c = quote.Delivery_Destination__c;
        tmsShippingOrder.Delivery_Show_Contractor__c = quote.Delivery_Show_Contractor__c;
        tmsShippingOrder.Delivery_Show_Name__c = quote.Delivery_Show_Name__c;
        tmsShippingOrder.Delivery_Window_Start__c = quote.Delivery_Window_Start__c;
        tmsShippingOrder.Destination_Address__c = quote.Destination_Address__c;
        tmsShippingOrder.Destination_City__c = quote.Destination_City__c;
        tmsShippingOrder.Destination_Country__c = quote.Destination_Country__c;
        tmsShippingOrder.Destination_Postal_Code__c = quote.Destination_Postal_Code__c;
        tmsShippingOrder.Destination_State__c = quote.Destination_State__c;
        tmsShippingOrder.Destination_Street__c = quote.Destination_Street__c;
        tmsShippingOrder.Dim_Weight__c = quote.Dim_Weight__c;
        tmsShippingOrder.Discount_End_Date__c = quote.Discount_End_Date__c;
        tmsShippingOrder.EDV_Amount__c = quote.EDV_Amount__c;
        tmsShippingOrder.EDV_Amount_Exceeds_Limit__c = quote.EDV_Amount_Exceeds_Limit__c;
        if(facility != null){
            tmsShippingOrder.Facility__c = facility.Id;
            tmsShippingOrder.Facility_LMS_Facility_ID__c = facility.LMS_Facility_ID__c;
            tmsShippingOrder.Facility_Name__c = facility.Name;
        }
        tmsShippingOrder.Flat_Rate_Unit_Price_Type__c = quote.Flat_Rate_Unit_Price_Type__c;
        tmsShippingOrder.Fuel_Surcharge__c = quote.Fuel_Surcharge__c;
        tmsShippingOrder.Fuel_Unit_Surcharge__c = quote.Fuel_Unit_Surcharge__c;
        tmsShippingOrder.Hazardous_Material__c = quote.Hazardous_Materials__c;
        tmsShippingOrder.HM_Contact_Phone__c = quote.HM_Contact_Phone__c;
        tmsShippingOrder.Quote_Id__c = quote.Id;
        tmsShippingOrder.Inside_Pickup__c = quote.Inside_Pickup__c;
        tmsShippingOrder.Inside_Surcharge__c = quote.Inside_Surcharge__c;
        tmsShippingOrder.Job_Code__c = quote.Job_Code__c;
        tmsShippingOrder.Quote_LastActivityDate__c = quote.LastActivityDate;
        tmsShippingOrder.Quote_LastModifiedById__c = quote.LastModifiedById;
        tmsShippingOrder.Quote_LastModifiedDate__c = quote.LastModifiedDate;
        tmsShippingOrder.Lift_Gate__c = quote.Lift_Gate__c;
        tmsShippingOrder.Lift_Gate_Surcharge__c = quote.Lift_Gate_Surcharge__c;
        tmsShippingOrder.Lost_Comment__c = quote.Lost_Comment__c;
        tmsShippingOrder.Lost_Reason__c = quote.Lost_Reason__c;
        tmsShippingOrder.Message__c = quote.Message__c;
        tmsShippingOrder.Quote_Name__c = quote.Name;
        tmsShippingOrder.OB_Additional_Labor__c = quote.OB_Additional_Labor__c;
        tmsShippingOrder.OB_Additional_Labor_Fee__c = quote.OB_Additional_Labor_Fee__c;
        tmsShippingOrder.OB_Addl_Information__c = quote.OB_Addl_Information__c;
        tmsShippingOrder.OB_Advance_Order_Discount__c = quote.OB_Advance_Order_Discount__c;
        tmsShippingOrder.OB_AM_Specified__c = quote.OB_AM_Specified__c;
        tmsShippingOrder.OB_AM_Specified_Fee__c = quote.OB_AM_Specified_Fee__c;
        tmsShippingOrder.OB_Attempt__c = quote.OB_Attempt__c;
        tmsShippingOrder.OB_Attempt_Fee__c = quote.OB_Attempt_Fee__c;
        tmsShippingOrder.OB_Call_Before_Delivery__c = quote.OB_Call_Before_Delivery__c;
        tmsShippingOrder.OB_Call_Before_Pickup__c = quote.OB_Call_Before_Pickup__c;
        tmsShippingOrder.OB_Carrier_Notes__c = quote.OB_Carrier_Notes__c;
        tmsShippingOrder.OB_Class_of_Service__c = quote.OB_Class_of_Service__c;
        tmsShippingOrder.OB_Custom_Quote__c = quote.OB_Custom_Quote__c;
        tmsShippingOrder.OB_Delivery_Booth_No__c = quote.OB_Delivery_Booth_No__c;
        tmsShippingOrder.OB_Delivery_Contact_Name__c = quote.OB_Delivery_Contact_Name__c;
        tmsShippingOrder.OB_Delivery_Contact_Phone__c = quote.OB_Delivery_Contact_Phone__c;
        tmsShippingOrder.OB_Delivery_Date__c = quote.OB_Delivery_Date__c;
        tmsShippingOrder.OB_Delivery_Destination__c = quote.OB_Delivery_Destination__c;
        tmsShippingOrder.OB_Delivery_Show_Contractor__c = quote.OB_Delivery_Show_Contractor__c;
        tmsShippingOrder.OB_Delivery_Show_Name__c = quote.OB_Delivery_Show_Name__c;
        tmsShippingOrder.OB_Delivery_Window_Start__c = quote.OB_Delivery_Window_Start__c;
        tmsShippingOrder.OB_Destination_Address__c = quote.OB_Destination_Address__c;
        tmsShippingOrder.OB_Destination_City__c = quote.OB_Destination_City__c;
        tmsShippingOrder.OB_Destination_Country__c = quote.OB_Destination_Country__c;
        tmsShippingOrder.OB_Destination_Postal_Code__c = quote.OB_Destination_Postal_Code__c;
        tmsShippingOrder.OB_Destination_State__c = quote.OB_Destination_State__c;
        tmsShippingOrder.OB_Destination_Street__c = quote.OB_Destination_Street__c;
        if(obFacility != null){
            tmsShippingOrder.OB_Facility__c = obFacility.Id;
            tmsShippingOrder.OB_Facility_LMS_Facility_ID__c = obFacility.LMS_Facility_ID__c;
            tmsShippingOrder.OB_Facility_Name__c = obFacility.Name;
        }
        tmsShippingOrder.OB_Flat_Rate_Unit_Price_Type__c = quote.OB_Flat_Rate_Unit_Price_Type__c;
        tmsShippingOrder.OB_Fuel_Surcharge__c = quote.OB_Fuel_Surcharge__c;
        tmsShippingOrder.OB_Fuel_Unit_Surcharge__c = quote.OB_Fuel_Unit_Surcharge__c;
        tmsShippingOrder.OB_Hazardous_Materials__c = quote.OB_Hazardous_Materials__c;
        tmsShippingOrder.OB_HM_Contact_Phone__c = quote.OB_HM_Contact_Phone__c;
        tmsShippingOrder.OB_Inside_Pickup__c = quote.OB_Inside_Pickup__c;
        tmsShippingOrder.OB_Inside_Surcharge__c = quote.OB_Inside_Surcharge__c;
        tmsShippingOrder.OB_Lift_Gate__c = quote.OB_Lift_Gate__c;
        tmsShippingOrder.OB_Lift_Gate_Surcharge__c = quote.OB_Lift_Gate_Surcharge__c;
        tmsShippingOrder.OB_Origination_City__c = quote.OB_Origination_City__c;
        tmsShippingOrder.OB_Origination_Country__c = quote.OB_Origination_Country__c;
        tmsShippingOrder.OB_Origination_Postal_Code__c = quote.OB_Origination_Postal_Code__c;
        tmsShippingOrder.OB_Origination_State__c = quote.OB_Origination_State__c;
        tmsShippingOrder.OB_Origination_Street__c = quote.OB_Origination_Street__c;
        tmsShippingOrder.OB_Pallet_Jack__c = quote.OB_Pallet_Jack__c;
        tmsShippingOrder.OB_Palletization__c = quote.OB_Palletization__c;
        tmsShippingOrder.OB_Palletization_Fee__c = quote.OB_Palletization_Fee__c;
        tmsShippingOrder.OB_Pickup_Address__c = quote.OB_Pickup_Address__c;
        tmsShippingOrder.OB_Pickup_Booth_No__c = quote.OB_Pickup_Booth_No__c;
        tmsShippingOrder.OB_Pickup_Contact_Name__c = quote.OB_Pickup_Contact_Name__c;
        tmsShippingOrder.OB_Pickup_Contact_Phone__c = quote.OB_Pickup_Contact_Phone__c;
        tmsShippingOrder.OB_Pickup_Date__c = quote.OB_Pickup_Date__c;
        tmsShippingOrder.OB_Pickup_Show_Contractor__c = quote.OB_Pickup_Show_Contractor__c;
        tmsShippingOrder.OB_Pickup_Show_Name__c = quote.OB_Pickup_Show_Name__c;
        tmsShippingOrder.OB_Pickup_Window_Start__c = quote.OB_Pickup_Window_Start__c;
        tmsShippingOrder.OB_Pickup_Window_Start_Late__c = quote.OB_Pickup_Window_Start_Late__c;
        tmsShippingOrder.OB_Residential_Pickup__c = quote.OB_Residential_Pickup__c;
        tmsShippingOrder.OB_Residential_Surcharge__c = quote.OB_Residential_Surcharge__c;
        tmsShippingOrder.OB_Round_Trip_Discount__c = quote.OB_Round_Trip_Discount__c;
        tmsShippingOrder.OB_Selection__c = quote.OB_Selection__c;
        tmsShippingOrder.OB_Service_Type__c = quote.OB_Service_Type__c;
        tmsShippingOrder.OB_Shipment_Type__c = quote.OB_Shipment_Type__c;
        tmsShippingOrder.OB_Sub_Total__c = quote.OB_Sub_Total__c;
        tmsShippingOrder.OB_Total__c = quote.OB_Total__c;
        tmsShippingOrder.OB_Unit_Price__c = quote.OB_Unit_Price__c;
        tmsShippingOrder.OB_Wait_Time__c = quote.OB_Wait_Time__c;
        tmsShippingOrder.OB_Wait_Time_Fee__c = quote.OB_Wait_Time_Fee__c;
        tmsShippingOrder.OB_Weekend_Delivery__c = quote.OB_Weekend_Delivery__c;
        tmsShippingOrder.OB_Weekend_Fee__c = quote.OB_Weekend_Fee__c;
        tmsShippingOrder.OB_Weekend_Pickup__c = quote.OB_Weekend_Pickup__c;
        tmsShippingOrder.Order_Date__c = quote.Order_Date__c;
        tmsShippingOrder.Origination_City__c = quote.Origination_City__c;
        tmsShippingOrder.Origination_Country__c = quote.Origination_Country__c;
        tmsShippingOrder.Origination_Postal_Code__c = quote.Origination_Postal_Code__c;
        tmsShippingOrder.Origination_State__c = quote.Origination_State__c;
        tmsShippingOrder.Origination_Street__c = quote.Origination_Street__c;
        if(ownerRec != null){
            tmsShippingOrder.Quote_Owner_FirstName__c = ownerRec.FirstName;
            tmsShippingOrder.Quote_Owner_LastName__c = ownerRec.LastName;
            tmsShippingOrder.Quote_Owner_Name__c = ownerRec.Name;
            tmsShippingOrder.Quote_OwnerId__c = ownerRec.id;
        }else if(groupRec != null){
            tmsShippingOrder.Quote_Owner_Name__c = groupRec.Name;
            tmsShippingOrder.Quote_OwnerId__c = groupRec.id;
        }
        tmsShippingOrder.Pallet_Jack__c = quote.Pallet_Jack__c;
        tmsShippingOrder.Palletization__c = quote.Palletization__c;
        tmsShippingOrder.Palletization_Fee__c = quote.Palletization_Fee__c;
        if(parentQuote != null){
            tmsShippingOrder.Parent_Quote__c = parentQuote.Id;
            tmsShippingOrder.Parent_Quote_Name__c = parentQuote.Name;
        }
        tmsShippingOrder.Pickup_Address__c = quote.Pickup_Address__c;
        tmsShippingOrder.Pickup_Booth_No__c = quote.Pickup_Booth_No__c;
        tmsShippingOrder.Pickup_Contact_Fax__c = quote.Pickup_Contact_Fax__c;
        tmsShippingOrder.Pickup_Contact_Name__c = quote.Pickup_Contact_Name__c;
        tmsShippingOrder.Pickup_Contact_Phone__c = quote.Pickup_Contact_Phone__c;
        tmsShippingOrder.Pickup_Date__c = quote.Pickup_Date__c;
        tmsShippingOrder.Pickup_Show_Contractor__c = quote.Pickup_Show_Contractor__c;
        tmsShippingOrder.Pickup_Show_Name__c = quote.Pickup_Show_Name__c;
        tmsShippingOrder.Pickup_Window_Start__c = quote.Pickup_Window_Start__c;
        tmsShippingOrder.Pickup_Window_Start_Late__c = quote.Pickup_Window_Start_Late__c;
        tmsShippingOrder.Project_Number__c = quote.Project_Number__c;
        tmsShippingOrder.Quote_Inside_Surcharge__c = quote.Quote_Inside_Surcharge__c;
        tmsShippingOrder.Quote_Subject__c = quote.Quote_Subject__c;
        tmsShippingOrder.Quoted_Total__c = quote.Quoted_Total__c;
        tmsShippingOrder.Quoted_Fuel_Surcharge__c = quote.Quoted_Fuel_Surcharge__c;
        tmsShippingOrder.Quoted_Lift_Gate_Surcharge__c = quote.Quoted_Lift_Gate_Surcharge__c;
        tmsShippingOrder.Quoted_Residential_Surcharge__c = quote.Quoted_Residential_Surcharge__c;
        if(recType != null){
            tmsShippingOrder.Quote_RecordType_Name__c = recType.Name;
            tmsShippingOrder.Quote_RecordTypeId__c = recType.Id;
        }
        tmsShippingOrder.Residential_Pickup__c = quote.Residential_Pickup__c;
        tmsShippingOrder.Residential_Surcharge__c = quote.Residential_Surcharge__c;
        tmsShippingOrder.Round_Trip_Discount__c = quote.Round_Trip_Discount__c;
        if(salesRep != null){
            tmsShippingOrder.Sales_Rep__c = salesRep.Id;
            tmsShippingOrder.Sales_Rep_FirstName__c = salesRep.FirstName;
            tmsShippingOrder.Sales_Rep_LastName__c = salesRep.LastName;
        }
        tmsShippingOrder.Selection__c = quote.Selection__c;
        tmsShippingOrder.Service_Type__c = quote.Service_Type__c;
        tmsShippingOrder.Ship_To_Location__c = quote.Ship_To_Location__c;
        tmsShippingOrder.Shipment_Type__c = quote.Shipment_Type__c;
        tmsShippingOrder.Show__c = quote.Show__c;
        if(showOccurance != null){
            tmsShippingOrder.Show_Occurrence__c = showOccurance.Id;
            tmsShippingOrder.Show_Occurrence_Name__c = showOccurance.Name;
            tmsShippingOrder.Show_ID_LMS__c = showOccurance.Show_ID_LMS_Calculated__c;
        }
        tmsShippingOrder.Source__c = quote.Source__c;
        tmsShippingOrder.Special_Discount_Program__c = quote.Special_Discount_Program__c;
        tmsShippingOrder.Stage__c = quote.Stage__c;
        tmsShippingOrder.Status__c = quote.Status__c;
        tmsShippingOrder.Sub_Total__c = quote.Sub_Total__c;
        tmsShippingOrder.Total__c = quote.Total__c;
        tmsShippingOrder.Type__c = quote.Type__c;
        tmsShippingOrder.Unit_Price__c = quote.Unit_Price__c;
        tmsShippingOrder.Wait_Time__c = quote.Wait_Time__c;
        tmsShippingOrder.Wait_Time_Fee__c = quote.Wait_Time_Fee__c;
        tmsShippingOrder.Weekend_Delivery__c = quote.Weekend_Delivery__c;
        tmsShippingOrder.Weekend_Fee__c = quote.Weekend_Fee__c;
        tmsShippingOrder.Weekend_Pickup__c = quote.Weekend_Pickup__c;
        tmsShippingOrder.Weight_Override__c = quote.Weight_Override__c;
        tmsShippingOrder.TOPS_Quote_Number__c = quote.TOPS_Quote_Number__c;
        tmsShippingOrder.Merged_AR_Customer_Number__c = quote.Formula_Merged_AR_Customer_Number__c;
        // Amarab 2/2/2024 to add emails 
        tmsShippingOrder.Delivery_Contact_Email__c = quote.Delivery_Contact_Email__c;
        tmsShippingOrder.OB_Delivery_Contact_Email__c = quote.OB_Delivery_Contact_Email__c;
        tmsShippingOrder.OB_Pickup_Contact_Email__c = quote.OB_Pickup_Contact_Email__c;
        tmsShippingOrder.Pickup_Contact_Email__c = quote.Pickup_Contact_Email__c;
        //AMARAB 5/21/2024 to add Order # and Stage
        tmsShippingOrder.Inbound_Stage__c = quote.Inbound_Stage__c;
        tmsShippingOrder.Outbound_Stage__c = quote.Outbound_Stage__c;
        tmsShippingOrder.TMS_Inbound_Shipping_Order__c = quote.TMS_Inbound_Shipping_Order__c;
        tmsShippingOrder.TMS_Outbound_Shipping_Order__c = quote.TMS_Outbound_Shipping_Order__c;
        //Amarab 06/28/2024 to add beyond point and ny city fields
        tmsShippingOrder.Beyond_Point__c = quote.Beyond_Point__c; 
        tmsShippingOrder.OB_Beyond_Point__c = quote.OB_Beyond_Point__c; 
        tmsShippingOrder.IN_Beyond_Point_Fee__c = quote.IN_Beyond_Point_Fee__c; 
        tmsShippingOrder.OB_Beyond_Point_Fee__c = quote.OB_Beyond_Point_Fee__c; 
        tmsShippingOrder.NY_City__c = quote.NY_City__c; 
        tmsShippingOrder.OB_NY_City__c = quote.OB_NY_City__c;
        tmsShippingOrder.IN_New_York_City_Fee__c = quote.IN_New_York_City_Fee__c;
        tmsShippingOrder.OB_New_York_City_Fee__c = quote.OB_New_York_City_Fee__c;
        //Amarab 09/11/2024 to add booth, Inbound Outbound Owner fields
        tmsShippingOrder.Oracle_Booth_Id__c= quote.Oracle_Booth_Id__c;
        if(!Test.isRunningTest()){
            Time myTime = Time.newInstance(0, 0, 0, 0);
            tmsShippingOrder.Show_Open_Date__c= Datetime.newInstance(quote.Show_Open_Date__c, myTime);
            tmsShippingOrder.Show_Close_Date__c=Datetime.newInstance(quote.Show_Close_Date__c, myTime);
        }       
        tmsShippingOrder.Inbound_Owner__c= quote.Inbound_Owner__c;
        tmsShippingOrder.Outbound_Owner__c= quote.Outbound_Owner__c;
        
        if(freightItem != null){
            tmsShippingOrder.FI_Crated_Weight__c = freightItem.Crated_Weight__c;
            tmsShippingOrder.FI_CreatedById__c = freightItem.CreatedById;
            tmsShippingOrder.FI_CreatedDate__c = freightItem.CreatedDate;
            tmsShippingOrder.FI_CurrencyIsoCode__c = freightItem.CurrencyIsoCode;
            tmsShippingOrder.Description__c = freightItem.Description__c;
            tmsShippingOrder.Hazardous_Material__c = freightItem.Hazardous_Material__c;
            tmsShippingOrder.Height__c = freightItem.Height__c;
            tmsShippingOrder.FI_Id__c = freightItem.Id;
            tmsShippingOrder.FI_LastModifiedById__c = freightItem.LastModifiedById;
            tmsShippingOrder.FI_LastModifiedDate__c = freightItem.LastModifiedDate;
            tmsShippingOrder.Length__c = freightItem.Length__c;
            tmsShippingOrder.Line_Number__c = freightItem.Line_Number__c;
            tmsShippingOrder.FI_Name__c = freightItem.Name;
            tmsShippingOrder.Quantity__c = freightItem.Quantity__c;
            tmsShippingOrder.Width__c = freightItem.Width__c;
            tmsShippingOrder.Void__c = freightItem.Void__c;
        }
        return tmsShippingOrder;
}    
    
    public static void updateInboundOutboundOwner(List<Quote__c> listQuote){
        
        Set<Id> userIds = new Set<Id>();
        Set<Id> groupIds = new Set<Id>();
        for (Quote__c quote : listQuote) {
            if(quote.Inbound_Stage__c == null && quote.Inbound_Owner__c != null){
                quote.Inbound_Owner__c = null;
            }
            if(quote.Outbound_Stage__c == null && quote.Outbound_Owner__c != null){
                quote.Outbound_Owner__c = null;
            }
            
            String recOwnerId = quote.OwnerId;
            if (recOwnerId != null){
                if(recOwnerId.subString(0,3)=='005'){
                    userIds.add(recOwnerId);
                }else{
                    groupIds.add(recOwnerId);
                }
            }
        }
        
        Map<Id, User> userMap = new Map<Id, User>();
        Map<Id, Group> groupMap = new Map<Id, Group>();
        Boolean hasOwner = false;
        if(!userIds.isEmpty()){
            userMap = new Map<Id, User>([SELECT Id, Name FROM User WHERE Id IN :userIds]);
            hasOwner = true;
        }
        if(!groupIds.isEmpty()){
            groupMap = new Map<Id, Group>([SELECT Id, Name, Type FROM Group WHERE Id IN :groupIds]);
            hasOwner = true;
        }
        
        if(hasOwner){
            for (Quote__c quote : listQuote) {
                String recOwnerId = quote.OwnerId;
                if (recOwnerId != null){
                    if(recOwnerId.subString(0,3)=='005'){
                        if(quote.Inbound_Stage__c != null){
                            quote.Inbound_Owner__c = userMap.get(recOwnerId).Name;
                        }
                        if(quote.Outbound_Stage__c != null){
                            quote.Outbound_Owner__c = userMap.get(recOwnerId).Name;
                        }
                    }
                    else{
                        if(quote.Inbound_Stage__c != null){
                            quote.Inbound_Owner__c = groupMap.get(recOwnerId).Name;
                        }
                        if(quote.Outbound_Stage__c != null){
                            quote.Outbound_Owner__c = groupMap.get(recOwnerId).Name;
                        }
                    }
                }
            }
        }
    }
}