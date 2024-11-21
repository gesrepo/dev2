/* Class Name: AccountHierarchySetup

    Author: Nehal Jain
    Created Date: 5/18/2017*/

@isTest
                                
public class Test_AccountHierarchySetup  {

static  testMethod void testMethod1() {



List<Account> AccLst1= new List<Account>();

    Account Acc1= new Account();
    Acc1.Name= 'Test';
    Acc1.BillingStreet= 'Test1';
    Acc1.BillingCity= 'Delhi';
    Acc1.BillingState= 'New Delhi';
    Acc1.BillingPostalCode= '201013';
    Acc1.BillingCountry= 'US';
   // Acc1.ParentId=Acc1.id;
    //Acc1.parent_duns_number__C='001326495';
    Acc1.DunsNumber='015280873';
   // Acc.parent_duns_number__C='000000000';
   // Acc1.Custom_Parent_Account__c=Acc1.id;
   // Acc1.Processed_Flag__c=true;
    AccLst1.add(Acc1);
    
    Test.StartTest();
    insert AccLst1;
    
    
List<Account> AccLst2= new List<Account>();

    Account Acc2= new Account();
    Acc2.Name= 'Test';
    Acc2.BillingStreet= 'Test1';
    Acc2.BillingCity= 'Delhi';
    Acc2.BillingState= 'New Delhi';
    Acc2.BillingPostalCode= '201013';
    Acc2.BillingCountry= 'US';
    //Acc2.ParentId=Acc1.id;
    //Acc2.parent_duns_number__C='001326495';
    Acc2.DunsNumber='001326495';
   // Acc.parent_duns_number__C='000000000';
   // Acc2.Custom_Parent_Account__c=Acc1.id;
   // Acc2.Processed_Flag__c=false;
    AccLst2.add(Acc2);
    
    
    insert AccLst2;    
    
   
List<Account> AccLst3= new List<Account>();

    Account Acc3= new Account();
    Acc3.Name= 'Test';
    Acc3.BillingStreet= 'Test1';
    Acc3.BillingCity= 'Delhi';
    Acc3.BillingState= 'New Delhi';
    Acc3.BillingPostalCode= '201013';
    Acc3.BillingCountry= 'US';
    //Acc3.ParentId=Acc2.id;
    //Acc3.parent_duns_number__C='001326495';
    Acc3.DunsNumber='122526325';
   // Acc.parent_duns_number__C='000000000';
    //Acc3.Custom_Parent_Account__c=Acc2.id;
   // Acc3.Processed_Flag__c=false;
    AccLst3.add(Acc3);
    
    
    insert AccLst3;   
    
   
  

  /*  DatacloudDandBCompany dbcloud = new DatacloudDandBCompany();
    dbcloud.Name='testdb';
    dbcloud.DunsNumber='12000001';
    dbcloud.ParentOrHqDunsNumber ='3423453';
    insert dbcloud;*/
     
    
    
    AccountHierarchySetup obj= new AccountHierarchySetup();
    obj.setupAccountHierarchy(AccLst1);
    obj.setupAccountHierarchy(AccLst2);
    obj.setupAccountHierarchy(AccLst3);
   
    Test.StopTest();

}


}