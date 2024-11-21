global class BatchImportLogisticsQuote implements Database.Batchable<SObject>, Database.Stateful 
{

    public String query; 
    global database.querylocator start(Database.BatchableContext BC){return Database.getQueryLocator(query);}        
    global void execute(Database.BatchableContext BC, Sobject[] scope)
    {
    
        List<Quote_Staging__c> LoStageQuotes = new List<Quote_Staging__c>();

        for(SObject s: scope)
            LoStageQuotes.add((Quote_Staging__c)s);

        set<string> SoAllStageQuoteId = new set<string>();
        set<Id> SoAllQuoteId = new set<Id>();
        map<Id, Quote_Staging__c> MoStageQuotesToStageQuoteId = new map<Id, Quote_Staging__c>();
        map<Id, Quote_Staging__c> MoStageQuotesToQuoteId = new map<Id, Quote_Staging__c>();
                
        for(Quote_Staging__c stgQ: LoStageQuotes)
        {
            SoAllStageQuoteId.add(stgQ.Id);
            MoStageQuotesToStageQuoteId.put(stgQ.Id, stgQ);
               
            if (!SoAllQuoteId.contains(stgQ.Quote_Id__c))
            {
                SoAllQuoteId.add(stgQ.Quote_Id__c);
                MoStageQuotesToQuoteId.put(stgQ.Quote_Id__c, stgQ);
            }
        }

        List<Quote__c> LoQuotes = [Select q.Weight_Override__c, q.Weekend_Pickup__c, q.Weekend_Fee__c, q.Weekend_Delivery__c, q.Wait_Time__c, q.Wait_Time_Fee__c, q.Unit_Price__c, q.Type__c, q.Total__c, q.SystemModstamp, q.Sub_Total__c, q.Status__c, q.Stage__c, q.Source__c, q.Show__c, q.Show_Occurrence__c, q.Shipment_Type__c, q.Ship_To_Location__c, q.Service_Type__c, q.Selection__c, q.Sales_Rep__c, q.Round_Trip_Discount__c, q.Residential_Surcharge__c, q.Residential_Pickup__c, q.RecordTypeId, q.Quoted_Total__c, q.Quoted_Residential_Surcharge__c, q.Quoted_Lift_Gate_Surcharge__c, q.Quoted_Fuel_Surcharge__c, q.Quote_Total__c, q.Quote_Subject__c, q.Quote_Inside_Surcharge__c, q.Project_Number__c, q.Pickup_Window_Start__c, q.Pickup_Window_Start_Late__c, q.Pickup_Show_Name__c, q.Pickup_Show_Contractor__c, q.Pickup_Date__c, q.Pickup_Contact_Phone__c, q.Pickup_Contact_Name__c, q.Pickup_Contact_Fax__c, q.Pickup_Booth_No__c, q.Pickup_Address__c, q.Parent_Quote__c, q.Palletization__c, q.Palletization_Fee__c, q.Pallet_Jack__c, q.OwnerId, q.Origination_Street__c, q.Origination_State__c, q.Origination_Shipping_Address__c, q.Origination_Postal_Code__c, q.Origination_Country__c, q.Origination_City__c, q.Order_Date__c, q.OB_Weekend_Pickup__c, q.OB_Weekend_Fee__c, q.OB_Weekend_Delivery__c, q.OB_Wait_Time__c, q.OB_Wait_Time_Fee__c, q.OB_Unit_Price__c, q.OB_Total__c, q.OB_Sub_Total__c, q.OB_Shipment_Type__c, q.OB_Service_Type__c, q.OB_Selection__c, q.OB_Round_Trip_Discount__c, q.OB_Residential_Surcharge__c, q.OB_Residential_Pickup__c, q.OB_Pickup_Window_Start__c, q.OB_Pickup_Window_Start_Late__c, q.OB_Pickup_Show_Name__c, q.OB_Pickup_Show_Contractor__c, q.OB_Pickup_Date__c, q.OB_Pickup_Contact_Phone__c, q.OB_Pickup_Contact_Name__c, q.OB_Pickup_Booth_No__c, q.OB_Pickup_Address__c, q.OB_Palletization__c, q.OB_Palletization_Fee__c, q.OB_Pallet_Jack__c, q.OB_Origination_Street__c, q.OB_Origination_State__c, q.OB_Origination_Shipping_Address__c, q.OB_Origination_Postal_Code__c, q.OB_Origination_Country__c, q.OB_Origination_City__c, q.OB_Lift_Gate__c, q.OB_Lift_Gate_Surcharge__c, q.OB_Inside_Surcharge__c, q.OB_Inside_Pickup__c, q.OB_Hazardous_Materials__c, q.OB_HM_Contact_Phone__c, q.OB_Fuel_Unit_Surcharge__c, q.OB_Fuel_Surcharge__c, q.OB_Flat_Rate_Unit_Price_Type__c, q.OB_Facility__c, q.OB_Destination_Street__c, q.OB_Destination_State__c, q.OB_Destination_Shipping_Address__c, q.OB_Destination_Postal_Code__c, q.OB_Destination_Country__c, q.OB_Destination_City__c, q.OB_Destination_Address__c, q.OB_Delivery_Window_Start__c, q.OB_Delivery_Show_Name__c, q.OB_Delivery_Show_Contractor__c, q.OB_Delivery_Destination__c, q.OB_Delivery_Date__c, q.OB_Delivery_Contact_Phone__c, q.OB_Delivery_Contact_Name__c, q.OB_Delivery_Booth_No__c, q.OB_Custom_Quote__c, q.OB_Class_of_Service__c, q.OB_Carrier_Notes__c, q.OB_Call_Before_Pickup__c, q.OB_Call_Before_Delivery__c, q.OB_Attempt__c, q.OB_Attempt_Fee__c, q.OB_Advance_Order_Discount__c, q.OB_Addl_Information__c, q.OB_Additional_Labor__c, q.OB_Additional_Labor_Fee__c, q.OB_AM_Specified__c, q.OB_AM_Specified_Fee__c, q.Name, q.Message__c, q.Lost_Reason__c, q.Lost_Comment__c, q.Lift_Gate__c, q.Lift_Gate_Surcharge__c, q.LastModifiedDate, q.LastModifiedById, q.LastActivityDate, q.Job_Code__c, q.IsDeleted, q.Inside_Surcharge__c, q.Inside_Pickup__c, q.Id, q.Hazardous_Materials__c, q.HM_Contact_Phone__c, q.Fuel_Unit_Surcharge__c, q.Fuel_Surcharge__c, q.Flat_Rate_Unit_Price_Type__c, q.Facility__c, q.EDV_Amount__c, q.EDV_Amount_Exceeds_Limit__c, q.Discount_End_Date__c, q.Dim_Weight__c, q.Destination_Street__c, q.Destination_State__c, q.Destination_Shipping_Address__c, q.Destination_Postal_Code__c, q.Destination_Country__c, q.Destination_City__c, q.Destination_Address__c, q.Delivery_Window_Start__c, q.Delivery_Show_Name__c, q.Delivery_Show_Contractor__c, q.Delivery_Destination__c, q.Delivery_Date__c, q.Delivery_Contact_Phone__c, q.Delivery_Contact_Name__c, q.Delivery_Contact_Fax__c, q.Delivery_Booth_No__c, q.Custom_Quote__c, q.CurrencyIsoCode, q.CreatedDate, q.CreatedById, q.Crated_Weight__c, q.Copy_To_OB_Pickup_Address__c, q.Copy_To_OB_Destination_Address__c, q.Complete_By__c, q.Class_of_Service__c, q.Carrier_Notes__c, q.Call_Before_Pickup__c, q.Call_Before_Delivery__c, q.CORE_Order_Number__c, q.Booth__c, q.Booth_Number__c, q.Billing_Contact__c, q.Attempt__c, q.Attempt_Fee__c, q.Apply_Round_Trip_Discount__c, q.Advance_Order_Discount__c, q.Addl_Information__c, q.Additional_Labor__c, q.Additional_Labor_Fee__c, q.Account_Id__c, q.AM_Specified__c, q.AM_Specified_Fee__c, q.AGS_Beyond_Point__c From Quote__c q Where q.Id In :SoAllQuoteId];

        List<Quote__c> LoQuotesForUpdate = new List<Quote__c>();
        List<Quote_Staging__c> LoStageQuotesForUpdate = new List<Quote_Staging__c>();

        for(Quote__c q : LoQuotes)
        {
            //Retrieve stage quote for the current quote in loop
            Quote_Staging__c qs = MoStageQuotesToQuoteId.get(q.Id);
            LoStageQuotesForUpdate.add(qs);
            
            //Set fields here - map between staging and quote objects
            q.TOPS_Quote_Number__c = qs.TOPS_Quote_Number__c;
            q.Quote_Subject__c = qs.Quote_Subject__c;            
            q.Source__c = qs.Source__c;
            q.Stage__c = qs.Stage__c;
            q.Type__c = qs.Type__c;
            q.Job_Code__c = qs.Job_Code__c;
            q.Lost_Comment__c = qs.Lost_Comment__c;
            q.Lost_Reason__c = qs.Lost_Reason__c;
            q.Complete_By__c = qs.Complete_By__c;
            q.CORE_Order_Number__c = qs.CORE_Order_Number__c;

            q.EDV_Amount__c = qs.EDV_Amount__c;
            q.EDV_Amount_Exceeds_Limit__c = qs.EDV_Amount_Exceeds_Limit__c;

            q.Weight_Override__c = qs.Weight_Override__c;
            
            //Inbound Pickup Info
            q.Pickup_Show_Name__c = qs.Pickup_Show_Name__c;            
            q.Pickup_Show_Contractor__c = qs.Pickup_Show_Contractor__c;
            q.Pickup_Booth_No__c = qs.Pickup_Booth_No__c;
            q.Pickup_Contact_Name__c = qs.Pickup_Contact_Name__c;
            q.Pickup_Contact_Phone__c = qs.Pickup_Contact_Phone__c;
            q.Pickup_Contact_Fax__c = qs.Pickup_Contact_Fax__c;
                        
            q.Pickup_Date__c = qs.Pickup_Date__c;
            q.Pickup_Window_Start__c = qs.Pickup_Window_Start__c;
            q.Pickup_Window_Start_Late__c = qs.Pickup_Window_Start_Late__c; 
            
            q.Custom_Quote__c = qs.Custom_Quote__c;        

			//Inbound Pickup Address
            q.Origination_Street__c = qs.Origination_Street__c;            
            q.Origination_City__c =  qs.Origination_City__c;
            q.Origination_State__c = qs.Origination_State__c;
            q.Origination_Postal_Code__c = qs.Origination_Postal_Code__c;
            q.Origination_Country__c = qs.Origination_Country__c;
            
         	//Inbound Delivery Info
            q.Delivery_Show_Name__c = qs.Delivery_Show_Name__c;
            q.Delivery_Show_Contractor__c = qs.Delivery_Show_Contractor__c;
            q.Delivery_Booth_No__c = qs.Delivery_Booth_No__c;
            q.Delivery_Destination__c = qs.Delivery_Destination__c;            
            q.Delivery_Contact_Name__c = qs.Delivery_Contact_Name__c;
            q.Delivery_Contact_Phone__c = qs.Delivery_Contact_Phone__c;
            q.Delivery_Contact_Fax__c = qs.Delivery_Contact_Fax__c;
                   
            q.Ship_To_Location__c = qs.Ship_To_Location__c;
            
            q.Delivery_Date__c = qs.Delivery_Date__c;
            q.Delivery_Window_Start__c = qs.Delivery_Window_Start__c;
            
            //Inbound Delivery Address  
            q.Destination_City__c = qs.Destination_City__c;
            q.Destination_Country__c = qs.Destination_Country__c;
            q.Destination_Postal_Code__c = qs.Destination_Postal_Code__c;
            q.Destination_State__c = qs.Destination_State__c;
            q.Destination_Street__c = qs.Destination_Street__c; 
            
            //Inbound Trasportation Mode    
            q.Selection__c = qs.Selection__c;
            q.Service_Type__c = qs.Service_Type__c;
            q.Shipment_Type__c = qs.Shipment_Type__c;
            q.Class_of_Service__c = qs.Class_of_Service__c;
            
            //Inbound Flags            
            q.Apply_Round_Trip_Discount__c = qs.Apply_Round_Trip_Discount__c;
            q.Additional_Labor__c = qs.Additional_Labor__c;
            q.AM_Specified__c=qs.AM_Specified__c;
            q.Attempt__c = qs.Attempt__c;
            q.Call_Before_Delivery__c = qs.Call_Before_Delivery__c;
            q.Call_Before_Pickup__c = qs.Call_Before_Pickup__c;
            q.Inside_Pickup__c = qs.Inside_Pickup__c;
            q.Lift_Gate__c = qs.Lift_Gate__c;             
            q.Pallet_Jack__c = qs.Pallet_Jack__c;
            q.Palletization__c = qs.Palletization__c;
            q.Residential_Pickup__c = qs.Residential_Pickup__c;
            q.Wait_Time__c = qs.Wait_Time__c;            
            q.Weekend_Delivery__c = qs.Weekend_Delivery__c;
            q.Weekend_Pickup__c = qs.Weekend_Pickup__c;
            
            q.Hazardous_Materials__c = qs.Hazardous_Materials__c;
            
            q.Carrier_Notes__c = qs.Carrier_Notes__c;
            q.HM_Contact_Phone__c = qs.HM_Contact_Phone__c;
            
            //Inbound Flat Rate
            q.Flat_Rate_Unit_Price_Type__c = qs.Flat_Rate_Unit_Price_Type__c;
            
            //Outbound Pickup Info
            
            q.OB_Pickup_Show_Name__c = qs.OB_Pickup_Show_Name__c;            
            q.OB_Pickup_Show_Contractor__c = qs.OB_Pickup_Show_Contractor__c;
            q.OB_Pickup_Booth_No__c = qs.OB_Pickup_Booth_No__c;
            q.OB_Pickup_Contact_Name__c = qs.OB_Pickup_Contact_Name__c;
            q.OB_Pickup_Contact_Phone__c = qs.OB_Pickup_Contact_Phone__c;

            q.OB_Pickup_Date__c = qs.OB_Pickup_Date__c;
            q.OB_Pickup_Window_Start__c = qs.OB_Pickup_Window_Start__c;
            q.OB_Pickup_Window_Start_Late__c = qs.OB_Pickup_Window_Start_Late__c;
                        
            q.OB_Class_of_Service__c = qs.OB_Class_of_Service__c;            
            q.OB_Selection__c = qs.OB_Selection__c;
            q.OB_Service_Type__c = qs.OB_Service_Type__c;
            q.OB_Shipment_Type__c = qs.OB_Shipment_Type__c;            

            q.OB_Custom_Quote__c = qs.OB_Custom_Quote__c;
            
            //Outbound Pickup Address
            q.OB_Origination_Street__c = qs.OB_Origination_Street__c; 
            q.OB_Origination_City__c = qs.OB_Origination_City__c;
            q.OB_Origination_State__c = qs.OB_Origination_State__c;
            q.OB_Origination_Country__c = qs.OB_Origination_Country__c;
            q.OB_Origination_Postal_Code__c = qs.OB_Origination_Postal_Code__c;
           
            //Outbound Delivery Info
            q.OB_Delivery_Show_Name__c = qs.OB_Delivery_Show_Name__c;
            q.OB_Delivery_Show_Contractor__c = qs.OB_Delivery_Show_Contractor__c;            
            q.OB_Delivery_Booth_No__c = qs.OB_Delivery_Booth_No__c;
            q.OB_Delivery_Contact_Name__c = qs.OB_Delivery_Contact_Name__c;
            q.OB_Delivery_Contact_Phone__c = qs.OB_Delivery_Contact_Phone__c;
            
            q.OB_Delivery_Date__c = qs.OB_Delivery_Date__c;
            q.OB_Delivery_Destination__c = qs.OB_Delivery_Destination__c;
            q.OB_Delivery_Window_Start__c = qs.OB_Delivery_Window_Start__c;
            
            q.OB_Destination_Street__c = qs.OB_Destination_Street__c;
            q.OB_Destination_City__c = qs.OB_Destination_City__c;
            q.OB_Destination_State__c = qs.OB_Destination_State__c;            
            q.OB_Destination_Country__c = qs.OB_Destination_Country__c;
            q.OB_Destination_Postal_Code__c = qs.OB_Destination_Postal_Code__c;
            
            q.OB_Flat_Rate_Unit_Price_Type__c = qs.OB_Flat_Rate_Unit_Price_Type__c;
            
            //Outbound Flags
            q.OB_Additional_Labor__c = qs.OB_Additional_Labor__c;                        
            q.OB_AM_Specified__c = qs.OB_AM_Specified__c;
            q.OB_Attempt__c = qs.OB_Attempt__c;
            q.OB_Call_Before_Delivery__c = qs.OB_Call_Before_Delivery__c;
            q.OB_Call_Before_Pickup__c = qs.OB_Call_Before_Pickup__c;
            q.OB_Inside_Pickup__c = qs.OB_Inside_Pickup__c;
            q.OB_Lift_Gate__c = qs.OB_Lift_Gate__c;            
            q.OB_Pallet_Jack__c = qs.OB_Pallet_Jack__c;
            q.OB_Palletization__c = qs.OB_Palletization__c;            
            q.OB_Residential_Pickup__c = qs.OB_Residential_Pickup__c;
            q.OB_Wait_Time__c = qs.OB_Wait_Time__c;
            q.OB_Weekend_Delivery__c = qs.OB_Weekend_Delivery__c;
            q.OB_Weekend_Pickup__c = qs.OB_Weekend_Pickup__c;
            
            q.OB_Carrier_Notes__c = qs.OB_Carrier_Notes__c;
            q.OB_Hazardous_Materials__c = qs.OB_Hazardous_Materials__c;
            q.OB_HM_Contact_Phone__c = qs.OB_HM_Contact_Phone__c;

            if (qs.Stage__c == 'Traffic / Carrier Quote Returned') {
            	//Inbound fee            
				q.Additional_Labor_Fee__c = qs.Additional_Labor_Fee__c;
				q.Advance_Order_Discount__c = qs.Advance_Order_Discount__c;
				q.AM_Specified_Fee__c = qs.AM_Specified_Fee__c;
				q.Attempt_Fee__c = qs.Attempt_Fee__c;
	            q.Fuel_Surcharge__c = qs.Fuel_Surcharge__c;
	            q.Fuel_Unit_Surcharge__c = qs.Fuel_Unit_Surcharge__c;
            	q.Inside_Surcharge__c = qs.Inside_Surcharge__c;
            	q.Lift_Gate_Surcharge__c = qs.Lift_Gate_Surcharge__c;
				q.Palletization_Fee__c = qs.Palletization_Fee__c;
				q.Residential_Surcharge__c = qs.Residential_Surcharge__c;
				q.Round_Trip_Discount__c = qs.Round_Trip_Discount__c;
	            q.Unit_Price__c = qs.Unit_Price__c;   
	            q.Wait_Time_Fee__c = qs.Wait_Time_Fee__c;            
	            q.Weekend_Fee__c = qs.Weekend_Fee__c;
	            q.Sub_Total__c = qs.Sub_Total__c;
	            q.Total__c = qs.Total__c;
	            
            	//Outbound fee columns
				q.OB_Additional_Labor_Fee__c = qs.OB_Additional_Labor_Fee__c;
				q.OB_Advance_Order_Discount__c = qs.OB_Advance_Order_Discount__c;
				q.OB_AM_Specified_Fee__c = qs.OB_AM_Specified_Fee__c;
				q.OB_Attempt_Fee__c = qs.OB_Attempt_Fee__c;
				q.OB_Inside_Surcharge__c = qs.OB_Inside_Surcharge__c;
				q.OB_Fuel_Surcharge__c = qs.OB_Fuel_Surcharge__c;
				q.OB_Fuel_Unit_Surcharge__c = qs.OB_Fuel_Unit_Surcharge__c;
				q.OB_Lift_Gate_Surcharge__c = qs.OB_Lift_Gate_Surcharge__c;
            	q.OB_Palletization_Fee__c = qs.OB_Palletization_Fee__c;
            	q.OB_Residential_Surcharge__c = qs.OB_Residential_Surcharge__c;
            	q.OB_Round_Trip_Discount__c = qs.OB_Round_Trip_Discount__c;
	            q.OB_Unit_Price__c = qs.OB_Unit_Price__c;
	            q.OB_Wait_Time_Fee__c = qs.OB_Wait_Time_Fee__c;
	            q.OB_Weekend_Fee__c = qs.OB_Weekend_Fee__c;	
	            q.OB_Sub_Total__c = qs.OB_Sub_Total__c;
	            q.OB_Total__c = qs.OB_Total__c;
            }

            //Add quote to list for update
            LoQuotesForUpdate.add(q);
 
        }

        List<Database.Saveresult> LoSr = Database.Update(LoQuotesForUpdate, false);

        List<Quote_Staging__c> LoStageQuotesUpdateStatus = new List<Quote_Staging__c>();
        
        integer UpdateCount = 0;

        for(Database.Saveresult result : LoSr)
        {
                        
            Quote_Staging__c StgQuoteToUpdate = LoStageQuotesForUpdate[UpdateCount];
            StgQuoteToUpdate.Interface_Process_Attempts__c = (StgQuoteToUpdate.Interface_Process_Attempts__c == null ? 0 : StgQuoteToUpdate.Interface_Process_Attempts__c + 1);
            
            if (result.isSuccess())
            {
                StgQuoteToUpdate.Interface_Status__c = 'Updated';
                StgQuoteToUpdate.Interface_Error_Message__c = '';
            }
            else
            {
                StgQuoteToUpdate.Interface_Status__c = 'Failed';
                string ErrorMessage = '';
                for(Database.Error err : result.getErrors())
                {
                    ErrorMessage += err.getMessage();
                }
                
                StgQuoteToUpdate.Interface_Error_Message__c = ErrorMessage;              
            }
            
            LoStageQuotesUpdateStatus.add(StgQuoteToUpdate);
                        
            UpdateCount++;
        }
        
          if (LoStageQuotesUpdateStatus.size() > 0)
            Database.update(LoStageQuotesUpdateStatus, false);  

  }

    global void finish(Database.BatchableContext BC)
    {      
    }
}