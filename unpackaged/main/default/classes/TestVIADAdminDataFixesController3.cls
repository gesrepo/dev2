/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestVIADAdminDataFixesController3 {

    static testMethod void myUnitTest() {
        
        /*
        //Test RFC001930_MoveShowOccurrenceActivitiesToShow
          
        //Retrieve User (for Owner)
        ID OwnerId = UserInfo.getUserId();
        
        //Retrieve User Sales Person
        ID SalesRepId = UserInfo.getUserId();

        //Determine RecordTypeId of "Sales Rep Show Occurrence" Opportunity record type.
        RecordType RTOpp = [Select Id From RecordType Where SObjectType = 'Opportunity' And Name = 'Sales Rep Show Occurrence'];
        Id SalesRepShowOccRecordTypeId = RTOpp.Id;
        
        //Determine RecordTypeId of "Facility" Account record type.
        RecordType RTAccFac = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Facility'];
        Id FacilityRecordTypeId = RTAccFac.Id;
        
        //Determine RecordTypeId of "Firm" Account record type.
        RecordType RTAccFirm = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Firm'];
        Id FirmRecordTypeId = RTAccFirm.Id;  

        //Create Facility
        Account Facility = new Account();
        Facility.Sales_Person__c = SalesRepId;
        Facility.Name = 'MyTestFacilityName';
        Facility.Type = 'Hotel';
        Facility.GES_Status__c = 'Preferred';
        Facility.LMS_Facility_ID__c = 'ABCFAC';
        Facility.BillingStreet = '950 Grier Dr';
        Facility.BillingCity = 'Las Vegas';
        Facility.BillingPostalCode = '89119-0000';
        Facility.BillingState = 'Nevada';
        Facility.BillingCountry = 'US';
        Facility.RecordTypeId = FacilityRecordTypeId;
        database.insert(Facility);  
        
        //Create Account of Record Type "Firm"
        Account Firm = new Account();
        Firm.Sales_Person__c = SalesRepId;
        Firm.Name = 'MyTestExhibitorName';
        Firm.Phone = '7022631500';
        Firm.BillingStreet = '950 Grier Dr';
        Firm.BillingCity = 'Las Vegas';
        Firm.BillingPostalCode = '89119-0000';
        Firm.BillingState = 'Nevada';
        Firm.BillingCountry = 'US';
        Firm.RecordTypeId = FirmRecordTypeId;
        database.insert(Firm);
        
        //Create Show
        Show__c Show = new Show__c();
        Show.Sales_Person__c = SalesRepId;
        Show.Account__c = Firm.Id;
        Show.Name ='MyTestShow001';
        Show.Show_Type__c = 'Food Sector';
        Show.Show_ID__c = '123456';
        database.insert(Show);  
        
        //Create Opportunities
        List<Opportunity> ListOfOpportunities = new List<Opportunity>();
        Opportunity[] ArrayOfOpportunities = new Opportunity[200];
                
        Integer OptyLoopCounter = 0;
        
        for(Integer i=0; i<=201;i++)
        {
	        //Create ShowOccurrence
	        Opportunity MyShowOcc = new Opportunity();
	       
	        MyShowOcc.OwnerId = OwnerId;
	        MyShowOcc.Sales_Person__c = SalesRepId;
	        MyShowOcc.Sales_Location__c = '520- Miami, Orlando, Tampa';
	        MyShowOcc.Name = 'MyTestShow # ' + String.valueof(i) ;
	        MyShowOcc.Prime_Contractor__c = null;
	        MyShowOcc.Production_Location__c = '710- Chicago, Cleveland, Milwaukee, St. Louis';
	        MyShowOcc.Facility__c = Facility.Id;
	        MyShowOcc.StageName = 'OF';
	        MyShowOcc.Amount = 1000;
	        MyShowOcc.Type = 'ITYFTY';
	        MyShowOcc.New_Repeat__c = 'New';
	        MyShowOcc.Frequency__c = 'B1';
	        MyShowOcc.Job_Number_Status__c = 'Open';
	        MyShowOcc.AccountId = Firm.Id;
	        MyShowOcc.Show_Name__c = Show.Id;
	        MyShowOcc.RecordTypeId = SalesRepShowOccRecordTypeId;
	        
	        Date MyShowOccOpenDate = Date.newInstance(2010,12,1);
	        Date MyShowOccCloseDate = Date.newInstance(2010,12,2);
	        
	        MyShowOcc.Show_Open_Date__c = MyShowOccOpenDate;
	        MyShowOcc.Show_Close_Date__c = MyShowOccCloseDate;
	        MyShowOcc.CloseDate = MyShowOccCloseDate;
	                    
            ArrayOfOpportunities[OptyLoopCounter] = MyShowOcc;
            
            if (OptyLoopCounter == 199)
            {                           	
                Database.insert(ArrayOfOpportunities, false);
                
                for(Opportunity opty: ArrayOfOpportunities)
                    ListOfOpportunities.add(opty.clone(true,true));
                
                OptyLoopCounter = -1;
                ArrayOfOpportunities = new Opportunity[2];
            }
            
            OptyLoopCounter++;
        }
        
        Database.insert(ArrayOfOpportunities, false); 
        
        for(Opportunity opty: ArrayOfOpportunities)
			ListOfOpportunities.add(opty.clone(true,true));        
        
        
        Task[] ArrayOfShowOccTasks = new Task[200];
                
        Integer MyShowOccTaskLoopCounter = 0;
        
        for(Integer i=0; i<=201;i++)
        {           
            Task MyShowOccTask = new Task();
            MyShowOccTask.WhatId = ListOfOpportunities.get(i).Id;
            MyShowOccTask.Type__c = 'External';
            MyShowOccTask.Type = 'Phone';
            MyShowOccTask.Subject = 'Test Move Activity to Show # ' + String.valueof(i);
            MyShowOccTask.Sub_Type__c = 'Facility Visit';
            MyShowOccTask.Status = 'Completed';
            MyShowOccTask.Priority = 'Normal';
            MyShowOccTask.OwnerId = OwnerId;
            MyShowOccTask.Managers_Notes_Exist__c = false;
            MyShowOccTask.MH_Greensheet__c = false;
            MyShowOccTask.MH_Action__c = false;
            //MyShowOccTask.IsReminderSet = false; Defaulted on creation
            //MyShowOccTask.IsRecurrence = false; Defaulted on creation.
            //MyShowOccTask.IsDeleted = false; Defaulted on creation.
            //MyShowOccTask.IsClosed = false; Defaulted on creation.
            //MyShowOccTask.IsArchived = false; Defaulted on creation.
            MyShowOccTask.Description = 'Sample description # ' + String.valueof(i);
            MyShowOccTask.CurrencyIsoCode = 'USD';
            //MyShowOccTask.Additional_Notes_Exist__c = false; Defaulted on creation.
            
            ArrayOfShowOccTasks[MyShowOccTaskLoopCounter] = MyShowOccTask;            
            
            if (MyShowOccTaskLoopCounter == 199)
            {
                Database.insert(ArrayOfShowOccTasks, false);
               
                MyShowOccTaskLoopCounter = -1;
                ArrayOfShowOccTasks = new Task[2];
            }
            
            MyShowOccTaskLoopCounter++;
        }
        
        Database.insert(ArrayOfShowOccTasks, false);   
        
        VIADAdminDataFixesController controler = new VIADAdminDataFixesController();              
        controler.setFixType('RFC001930_MoveShowOccurrenceActivitiesToShow');
        System.AssertEquals('RFC001930_MoveShowOccurrenceActivitiesToShow', controler.getFixType());
                
        PageReference ref = controler.Save(); 
        */       
        
    }
}