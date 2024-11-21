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
private class TestTrgUpdateTypeFieldForApprovalTasks {

    static testMethod void myUnitTest() {
     
        List<Task> Tasks = new List<Task>();
        
        //Create Activity Records here
        
        Task myTask1 = new Task();
        myTask1.OwnerId = UserInfo.getUserId();
        myTask1.Type__c = 'Internal';
        myTask1.Sub_Type__c = 'Account Planning';
        myTask1.CurrencyIsoCode = 'USD';
        myTask1.Priority = 'Low';
        myTask1.Status = 'In Progress';
        myTask1.Subject = 'DB Follow Up-Field Entries';
        
        Tasks.add(myTask1);
        
        Task myTask2 = new Task();
        myTask2.OwnerId = UserInfo.getUserId();
        myTask2.Type__c = 'Internal';
        myTask2.Sub_Type__c = 'Account Planning';
        myTask2.CurrencyIsoCode = 'USD';
        myTask2.Priority = 'Low';
        myTask2.Status = 'In Progress';
        myTask2.Subject = 'LO/LR/LPE/LPM Follow Up';            
        
        Tasks.add(myTask2);
        
        Task myTask3 = new Task();
        myTask3.OwnerId = UserInfo.getUserId();
        myTask3.Type__c = 'Internal';
        myTask3.Sub_Type__c = 'Account Planning';
        myTask3.CurrencyIsoCode = 'USD';
        myTask3.Priority = 'Low';
        myTask3.Status = 'In Progress';
        myTask3.Subject = 'Non Opportunity Follow Up';  
        
        Tasks.add(myTask3);
               
        Task myTask4 = new Task();
        myTask4.OwnerId = UserInfo.getUserId();
        myTask4.Type__c = 'Internal';
        myTask4.Sub_Type__c = 'Account Planning';
        myTask4.CurrencyIsoCode = 'USD';
        myTask4.Priority = 'Low';
        myTask4.Status = 'In Progress';
        myTask4.Subject = 'Show Occurrence Contract';  

        Tasks.add(myTask4);
            
        Task myTask5 = new Task();
        myTask5.OwnerId = UserInfo.getUserId();
        myTask5.Type__c = 'Internal';
        myTask5.Sub_Type__c = 'Account Planning';
        myTask5.CurrencyIsoCode = 'USD';
        myTask5.Priority = 'Low';
        myTask5.Status = 'In Progress';
        myTask5.Subject = 'Show Occurrence Follow up'; 
            
        Tasks.add(myTask5);
                        
        Task myTask6 = new Task();
        myTask6.OwnerId = UserInfo.getUserId();
        myTask6.Type__c = 'Internal';
        myTask6.Sub_Type__c = 'Account Planning';
        myTask6.CurrencyIsoCode = 'USD';
        myTask6.Priority = 'Low';
        myTask6.Status = 'In Progress';
        myTask6.Subject = 'TS Follow Up-Field Entries for'; 
        
        Tasks.add(myTask6);
        
        Database.insert(Tasks,true);
    }
}