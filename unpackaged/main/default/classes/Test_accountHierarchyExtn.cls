/* Class Name: accountHierarchyExtn */

@isTest
                                
public class Test_accountHierarchyExtn  {

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
    Acc1.Alternate_Name__c='Test1';
    Acc1.parent_duns_number__C='001326495';
    Acc1.Parent_Business_Name__c='Test1';
    Acc1.Global_Ultimate_Business_Name__c='Test1';
    Acc1.Global_Ultimate_Duns_Number__c='001326495';
    // Acc1.Data_Com_SIC_Description__c='Test1';
       // Acc.parent_duns_number__C='000000000';
   // Acc1.Custom_Parent_Account__c=Acc1.id;
   // Acc1.Processed_Flag__c=true;
    AccLst1.add(Acc1);
    
   
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
    Acc1.Alternate_Name__c='Test1';
    Acc1.parent_duns_number__C='001326495';
    Acc1.Parent_Business_Name__c='Test1';
    Acc1.Global_Ultimate_Business_Name__c='Test1';
    Acc1.Global_Ultimate_Duns_Number__c='001326495';
   // Acc1.Data_Com_SIC_Description__c='Test1';
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
    Acc1.Alternate_Name__c='Test1';
    Acc1.parent_duns_number__C='001326495';
    Acc1.Parent_Business_Name__c='Test1';
    Acc1.Global_Ultimate_Business_Name__c='Test1';
    Acc1.Global_Ultimate_Duns_Number__c='001326495';
  //  Acc1.Data_Com_SIC_Description__c='Test1';
   // Acc.parent_duns_number__C='000000000';
    //Acc3.Custom_Parent_Account__c=Acc2.id;
   // Acc3.Processed_Flag__c=false;
  Test.StartTest();
    AccLst3.add(Acc3);
    
    
    insert AccLst3;   
    
   
  

  /*  DatacloudDandBCompany dbcloud = new DatacloudDandBCompany();
    dbcloud.Name='testdb';
    dbcloud.DunsNumber='12000001';
    dbcloud.ParentOrHqDunsNumber ='3423453';
    insert dbcloud;*/
    
     ApexPages.StandardController sc = new ApexPages.StandardController(Acc3);
     accountHierarchyExtn obj = new accountHierarchyExtn(sc);
     
   String accList = '3DL DESIGN,13 FISHING';
    String[] arrAcc = accList.split(',');
    Boolean first = true;
    String soqlQuery;
    soqlQuery= 'Select Id, Name, dunsnumber, parentId,parent_duns_number__C,Global_Ultimate_Duns_Number__c,Owner.name FROM Account';
    for(String qr : arrAcc){
    if(!first){
        soqlQuery= soqlQuery+ ' OR';
    } else {
        soqlQuery= soqlQuery+ ' WHERE';
    }
    soqlQuery= soqlQuery+ ' Account.Name LIKE \'%' + qr + '%\'';
    first = false;
    }
         
    List<Account> accountMergeList = Database.query(soqlQuery);
     
    obj.getAccountMergeList() ;
    obj.buildHierarchy();   
    
    //AccountHierarchySetup obj= new AccountHierarchySetup();
   // obj.setupAccountHierarchy(AccLst1);
   // obj.setupAccountHierarchy(AccLst2);
   // obj.setupAccountHierarchy(AccLst3);
   
    Test.StopTest();

}


}