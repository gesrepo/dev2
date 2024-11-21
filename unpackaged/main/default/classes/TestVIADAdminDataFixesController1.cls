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
private class TestVIADAdminDataFixesController1 {

    static testMethod void myUnitTest() {
        
        /*
        //Test RFC001930_MoveAccountActivitiesToShow
              
		//Setup Reference Data
		        
        //Retrieve User (for Owner)
        ID OwnerId = UserInfo.getUserId();
        
        //Retrieve User Sales Person
        ID SalesRepId = UserInfo.getUserId();
        
        //Determine RecordTypeId of "Firm" Account record type.
        RecordType RTAccFirm = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Firm'];
        Id FirmRecordTypeId = RTAccFirm.Id;        
                       
        //Create Account of Record Type "Firm"
        Account Firm = new Account();
        Firm.Sales_Person__c = SalesRepId;
        Firm.Name = 'MyTestExhibitorName';
        Firm.Phone = '7022631500';
        Firm.BillingStreet = '950 Grier Dr';
        Firm.BillingCity = 'Las Vegas';
        Firm.BillingPostalCode = '89119';
        Firm.BillingState = 'Nevada';
        Firm.BillingCountry = 'US';
        Firm.RecordTypeId = FirmRecordTypeId;
        database.insert(Firm);
                
        //Create Tasks
        Task[] ArrayOfTasks = new Task[200];
        Integer LoopCounter = 0;
        
        for(Integer i=0; i<=201;i++)
        {
            Task MyTask = new Task();
            MyTask.WhatId = Firm.Id;
            MyTask.Type__c = 'External';
            MyTask.Type = 'Phone';
            MyTask.Subject = 'Test Move Activity to Show # ' + String.valueof(i);
            MyTask.Sub_Type__c = 'Facility Visit';
            MyTask.Status = 'Completed';
            MyTask.Priority = 'Normal';
            MyTask.OwnerId = OwnerId;
            MyTask.Managers_Notes_Exist__c = false;
            MyTask.MH_Greensheet__c = false;
            MyTask.MH_Action__c = false;
            //MyTask.IsReminderSet = false; Defaulted on creation
            //MyTask.IsRecurrence = false; Defaulted on creation.
            //MyTask.IsDeleted = false; Defaulted on creation.
            //MyTask.IsClosed = false; Defaulted on creation.
            //MyTask.IsArchived = false; Defaulted on creation.
            MyTask.Description = 'Sample description # ' + String.valueof(i);
            MyTask.CurrencyIsoCode = 'USD';
            //MyTask.Additional_Notes_Exist__c = false; Defaulted on creation.
            
            ArrayOfTasks[LoopCounter] = MyTask;
            
            if (LoopCounter == 199)
            {           	
                Database.insert(ArrayOfTasks, false);
                               
                LoopCounter = -1;
                ArrayOfTasks = new Task[2];
            }
            
            LoopCounter++;
        }
        
        Database.insert(ArrayOfTasks, false);            
        
        VIADAdminDataFixesController controler = new VIADAdminDataFixesController();
        controler.setFixType('RFC001930_MoveAccountActivitiesToShow');
        System.AssertEquals('RFC001930_MoveAccountActivitiesToShow', controler.getFixType());
                
        PageReference ref = controler.Save();
        */
    }
}