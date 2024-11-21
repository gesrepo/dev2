@istest(seealldata=true)
private class TestTrgBeforeInsertUpdateQuoteNew {

    static testMethod void myUnitTest() {
      
    //Create User (for Owner)
    ID OwnerId = UserInfo.getUserId();
    
    //Create User Sales Person
    ID SalesRepId = UserInfo.getUserId();
             
    RecordType FacilityRecordType = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Facility'];
    Id FacilityRecordTypeId = FacilityRecordType.Id;
                 
    RecordType ExhibitorRecordType = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Exhibitor'];
    Id ExhibitorRecordTypeId = ExhibitorRecordType.Id;
            
    RecordType EDProjectRecordType = [Select Id From RecordType Where SObjectType = 'Opportunity' And Name = 'E&D - Projects'];
    Id EDProjectRecordTypeId = EDProjectRecordType.Id;
    
    RecordType LogisticsDomesticQuoteRecordType = [Select Id From RecordType Where SObjectType = 'Quote__c' And Name = 'Logistics Domestic'];
    Id LogisticsDomesticQuoteRecordTypeId = LogisticsDomesticQuoteRecordType.Id;    
        
        

Quote__c q3 = new Quote__c();
        
        //Account ac1 = [select id from account where name ='WWIN GROUP']; 
        //Opportunity opty1 = [select id from opportunity where name ='ASDLVA-201208-LVCC'];
        //Shipping_Address__c shpAdd = [select id from Shipping_Address__c where Address_1__c = '100 Main st' limit 1];
        //Account Fac = [select id from account where name ='Las Vegas Convention Center']; 
        //0000055945
        Account ac1 = [select id from account where name ='HOUSING WORKS']; 
        Opportunity opty1 = [select id from opportunity where name ='NMAC-201210-CAEPAL'];
        Shipping_Address__c shpAdd = [select id from Shipping_Address__c where Address_1__c = '727 15TH STREET NW #210' limit 1];
        Shipping_Address__c dest = [select id from Shipping_Address__c where Address_1__c = '100 Main st' limit 1];
        Account Fac = [select id from account where name ='Las Vegas Convention Center']; 
        
        Shipping_Address__c ExhibitorAddress = new Shipping_Address__c();
        ExhibitorAddress.Address_1__c = '7000 Bagel Pkwy';
        ExhibitorAddress.City__c = 'Pheonix';
        ExhibitorAddress.State__c = 'AZ';
        ExhibitorAddress.Postal_Code__c = '56044';
        ExhibitorAddress.Country__c = 'United States';
        ExhibitorAddress.Account__c = ac1.Id;
        
        Database.insert(ExhibitorAddress);
        
        Shipping_Address__c ExhibitorAddress2 = new Shipping_Address__c();
        ExhibitorAddress2.Address_1__c = '7150 S Tenaya Way';
        ExhibitorAddress2.City__c = 'Las Vegas';
        ExhibitorAddress2.State__c = 'NV';
        ExhibitorAddress2.Postal_Code__c = '89123';
        ExhibitorAddress2.Country__c = 'United States';
        ExhibitorAddress2.Account__c = ac1.Id;
        
        Database.insert(ExhibitorAddress2);
        
        q3.RecordTypeId = LogisticsDomesticQuoteRecordTypeId;        
        q3.Quote_Subject__c = 'Roundtrip';
        //q3.Account_Id__c = Exhibitor.Id;
        q3.Account_Id__c = ac1.Id; 
       // q3.Show_Occurrence__c = Opty.Id;
        q3.Show_Occurrence__c = opty1.Id;
        //q3.Booth__c = Booth1.Id; DO NOT SET THE BOOTH, SO LINE # 262, 264, 266 AND 267 will be tested
        q3.Sales_Rep__c = null;
        q3.Job_Code__c = 'JOB001';
        //q3.Discount_End_Date__c = Date.newInstance(2012,12,1);
        //q3.Billing_Contact__c = '';
          q3.Origination_Shipping_Address__c = ExhibitorAddress.Id;
        //q3.Origination_Shipping_Address__c = shpAdd.Id;
        q3.Copy_To_OB_Destination_Address__c = true;
        q3.Pickup_Show_Name__c = 'International CES';
        q3.Pickup_Booth_No__c = '1000';
        q3.Pickup_Show_Contractor__c = 'GES';
        q3.Pickup_Contact_Name__c = 'John Doe';
        q3.Pickup_Contact_Phone__c = '7022631500';
        q3.Pickup_Date__c = Date.newInstance(2020,12,1);
        q3.Pickup_Window_Start__c = '16:00';
        q3.Pickup_Window_Start_Late__c = true;
        //q3.Facility__c = Facility.Id;
        q3.Facility__c = Fac.Id;
        q3.Delivery_Show_Name__c = 'Some Delivery Show';
        q3.Delivery_Booth_No__c = 'DELBOOTH';        
        q3.Delivery_Show_Contractor__c = 'Freeman';
        q3.Delivery_Contact_Name__c = 'Del Contact Joe';
        q3.Delivery_Contact_Phone__c = '9042345767';
        q3.Delivery_Date__c = Date.newInstance(2020,12,20);
        q3.Delivery_Window_Start__c = '16:00';
        q3.Delivery_Destination__c = 'Show Site';
        q3.Class_of_Service__c = '2nd Day';
        q3.Order_Date__c = Date.newInstance(2020,11,15);
        q3.Shipment_Type__c = null;
        q3.Service_Type__c = '';
        q3.Ship_To_Location__c = 'Warehouse';
        q3.Inside_Pickup__c = true;
        q3.Lift_Gate__c = true;
        q3.Pallet_Jack__c = true;
        q3.Residential_Pickup__c = true;
        q3.Call_Before_Pickup__c = true;
        q3.Call_Before_Delivery__c = true;
        q3.Weekend_Pickup__c = true;
        q3.Weekend_Delivery__c = true;
        q3.Hazardous_Materials__c = true;
        q3.Carrier_Notes__c = 'Carrier Notes';
        q3.EDV_Amount__c = 25000;
        q3.EDV_Amount_Exceeds_Limit__c = true;
        q3.Crated_Weight__c = 250;
        q3.Weight_Override__c = 500;
        q3.Fuel_Surcharge__c = 50;
        q3.Inside_Surcharge__c = 75;
        q3.Lift_Gate_Surcharge__c = 25;
        q3.Residential_Surcharge__c = 20;
        
        q3.Sub_Total__c = 500;
        q3.Total__c = 1000;
        q3.Custom_Quote__c = true;
        q3.Selection__c = 'Low';
        //q3.OB_Facility__c = Facility.Id;
        q3.OB_Facility__c = Fac.id;
        q3.OB_Pickup_Show_Name__c = 'Show Some';
        q3.OB_Pickup_Booth_No__c = 'PickBooth'; 
        q3.OB_Pickup_Show_Contractor__c = 'Freeman';
        q3.OB_Pickup_Contact_Name__c = 'Jane Doe';
        q3.OB_Pickup_Contact_Phone__c = '9042309898';
        q3.OB_Pickup_Date__c = Date.newInstance(2020,12,20);
        q3.OB_Pickup_Window_Start__c = '15:00';
        q3.OB_Pickup_Window_Start_Late__c = true;
        q3.OB_Destination_Shipping_Address__c = ExhibitorAddress.Id;
        q3.OB_Delivery_Show_Name__c = 'Del Show';
        q3.OB_Delivery_Booth_No__c = '19871';
        q3.OB_Delivery_Show_Contractor__c = 'None';
        q3.OB_Delivery_Contact_Name__c = 'James Cook';
        q3.OB_Delivery_Contact_Phone__c = '678-923-9876';
        q3.OB_Delivery_Date__c = Date.newInstance(2020,12,30);
        q3.OB_Delivery_Window_Start__c = '08:00';
        q3.OB_Shipment_Type__c = null;
        q3.OB_Class_of_Service__c = '';
        q3.OB_Service_Type__c = 'LTL';
        q3.OB_Inside_Pickup__c = true;
        q3.OB_Lift_Gate__c = true;
        q3.OB_Pallet_Jack__c = true;
        q3.OB_Residential_Pickup__c = true;
        q3.OB_Call_Before_Pickup__c = true;
        q3.OB_Call_Before_Delivery__c = true; 
        q3.OB_Weekend_Pickup__c = true;
        q3.OB_Weekend_Delivery__c = true;
        q3.OB_Hazardous_Materials__c = true; 
        q3.OB_Carrier_Notes__c = 'Notes';
        q3.OB_Fuel_Surcharge__c = 23; 
        q3.OB_Inside_Surcharge__c = 15;
        q3.OB_Lift_Gate_Surcharge__c = 50; 
        q3.OB_Residential_Surcharge__c = 75;
        q3.OB_Sub_Total__c = 120;
        q3.OB_Total__c = 200;
        q3.OB_Custom_Quote__c = true; 
        q3.Copy_To_OB_Pickup_Address__c = true;
        q3.OB_Selection__c = 'High';        
        
        test.startTest();
        
        Database.insert(q3);
        
        set<Id> SoBillingContactId = new set<Id>();
        SoBillingContactId.add('0034000000s8fuQAAQ');
        
        List<Contact> LoBillingContacts = [Select Id, Name, Phone, Fax From Contact Where Id = : OwnerId];
        map<Id, Contact> MoBillingContactIdToContact = new map<Id, Contact>();
    
        for (Contact c : LoBillingContacts) {
      MoBillingContactIdToContact.put(c.Id, c);
        }
        
               
        
        
         if ((q3.Stage__c == 'Pending Carrier Quote' ||
          q3.Stage__c == 'Pending Traffic Quote' ||
          q3.Stage__c == 'Re-Book' ||
          q3.Stage__c == 'Sent Traffic Quote') &&
          q3.Stage__c == 'Qualification')
          {
            q3.OwnerId = SalesRepId;
          }
        
        q3.Quote_Subject__c = 'Roundtrip';
        q3.Pickup_Date__c = Date.newInstance(2021,1,1);
        q3.Delivery_Date__c = Date.newInstance(2021,1,10);
        q3.OB_Pickup_Date__c = Date.newInstance(2021,1,11);
        q3.OB_Delivery_Date__c = Date.newInstance(2021,1,20);        
        q3.Origination_Shipping_Address__c = ExhibitorAddress.Id;
        q3.Facility__c = null;
        q3.Destination_Shipping_Address__c = ExhibitorAddress2.Id;
        q3.OB_Origination_Shipping_Address__c = ExhibitorAddress.Id;
        q3.OB_Facility__c = null;
        q3.OB_Destination_Shipping_Address__c = ExhibitorAddress2.Id;        
        q3.Additional_Labor__c = true;
        q3.Attempt__c = true;
        q3.AM_Specified__c = true;
        q3.Call_Before_Pickup__c = false;
        q3.Call_Before_Delivery__c = false;
        q3.Lift_Gate__c = false;
        q3.Hazardous_Materials__c = false;
        q3.Pallet_Jack__c = false;
        q3.Palletization__c = true;
        q3.Inside_Pickup__c = false;
        q3.Residential_Pickup__c = false;
        q3.Wait_Time__c = true;
        q3.Weekend_Pickup__c = false;
        q3.Weekend_Delivery__c = false;
        q3.OB_Additional_Labor__c = true;
        q3.OB_Attempt__c = true;
        q3.OB_AM_Specified__c = true;
        q3.OB_Call_Before_Pickup__c = false;
        q3.OB_Call_Before_Delivery__c = false;
        q3.OB_Lift_Gate__c = false;
        q3.OB_Hazardous_Materials__c = false;
        q3.OB_Pallet_Jack__c = false;
        q3.OB_Palletization__c = true;
        q3.OB_Inside_Pickup__c = false;
        q3.OB_Residential_Pickup__c = false;
        q3.OB_Wait_Time__c = true;
        q3.OB_Weekend_Pickup__c = false;
        q3.OB_Weekend_Delivery__c = false;
        
        if (q3.Copy_To_OB_Pickup_Address__c != null && q3.Copy_To_OB_Pickup_Address__c)
      {
        if (q3.Facility__c != null)
        {
          q3.OB_Facility__c = q3.Facility__c;
          q3.OB_Origination_Shipping_Address__c = null;
        }
        else if (q3.Destination_Shipping_Address__c != null)
        {
          q3.OB_Origination_Shipping_Address__c = q3.Destination_Shipping_Address__c;
          q3.OB_Facility__c = null;
        }
        
        q3.OB_Origination_Street__c = q3.Destination_Street__c;
        q3.OB_Origination_City__c = q3.Destination_City__c;
        q3.OB_Origination_State__c = q3.Destination_State__c;
        q3.OB_Origination_Country__c = q3.Destination_Country__c;
        q3.OB_Origination_Postal_Code__c = q3.Destination_Postal_Code__c;
        //Reset copy flag
        q3.Copy_To_OB_Pickup_Address__c = false;        
      }      
      
        
        Database.update(q3);
        
        
        test.stopTest();
        
        }
        }