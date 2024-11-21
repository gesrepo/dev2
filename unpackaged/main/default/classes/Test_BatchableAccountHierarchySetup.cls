/* Class Name: BatchableAccountHierarchySetup */

@isTest(SeeAllData=false)
                                
public class Test_BatchableAccountHierarchySetup  {

static  testMethod void testMethod1() {
Test.StartTest();


List<Account> AccLst= new List<Account>();
     Account Acc= new Account();
    Acc.Name= 'Test';
    Acc.BillingStreet= 'Test1';
    Acc.BillingCity= 'Delhi';
    Acc.BillingState= 'New Delhi';
    Acc.BillingPostalCode= '201013';
    Acc.BillingCountry= 'US';
    Acc.EMEA__c = False; 
   // Acc.Melissa_Integration_Status__c = 'Success';
    Acc.parent_duns_number__C='09873545';
   // Acc.DunsNumber='test123';
    Acc.dunsNumber='199472668';
    Acc.Custom_Parent_Account__c=Acc.id;
    Acc.Processed_Flag__c=true;
    Acc.Alternate_Name__c   = 'Test';
    Acc.Parent_Business_Name__c ='Test';
    Acc.Global_Ultimate_Business_Name__c = 'Test';
    Acc.Global_Ultimate_Duns_Number__c = 'Test';
   // Acc.Data_Com_SIC_Description__c = 'Test';
   // Acc.RecordTypeId = rt.id;
   // Acc.Test__c = True;
    AccLst.add(Acc);
    insert AccLst;
    
      
    
    
    BatchableAccountHierarchySetup obj= new BatchableAccountHierarchySetup();
    Database.executeBatch(obj);
    Test.StopTest();

}

}