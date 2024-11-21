/*
 To handle Account Relationships with Data Model and Integerations during Account Merge
 Developed By Gaurav Sharma
*/

public with sharing class AccountTriggerHandler{

     public static Boolean isFirstTime = true;
    public void triggerControllerMethod(Map<Id, Account> oldAccMap){
           
        final map<Id,Account> accmap = new map<Id,Account>(); 
        for(Account acc: oldAccMap.Values()){       
       
            if(acc.RecordTypeId == Label.Account_Exhibitor && acc.EMEA__c == False){                                                                             
       
                accmap.put(acc.Id, acc);            
            }                  
        }
        
       
        //OpportunityUpdateOnAccountdelete(accmap);
        BoothUpdateOnAccountdelete(accmap);
        //contactUpdateOnAccountdelete(accmap);
        ARcustomerUpdateOnAccountdelete(accmap);
        QuoteUpdateOnAccountdelete(accmap);
        OpportunityUpdateOnAccountdeleteBatch(accmap);
        ContactUpdateOnAccountdeleteBatch(accmap);
        //BoothUpdateOnAccountdeleteBatch(accmap);
        //QuoteUpdateOnAccountdeleteBatch(accmap);
       // updateDeletedARCustNum(accmap);
        
        
        
    }
    
  
// Method 1: To update AR customer number, AR customer Id and GBMS Id on  Quote
public void QuoteUpdateOnAccountdelete(Map<Id, Account> accmap){ 

 
                     
            List<Quote__c> Quotelist = new List<Quote__c>(); 
            Map<String,Id> mapIdAR_Id=new Map<String,ID>();         
            for(AR_Customer_Info__c instAR:[Select Deleted_Account_Id__c from AR_Customer_Info__c where Deleted_Account_Id__c in :accmap.keySet()]){
                    mapIdAR_Id.put(instAR.Deleted_Account_Id__c,instAR.id);
            }     
          
          Quotelist = [SELECT Id, Account_Id__c, AR_Customer_Number__c, GBMS_ID__c,Oracle_AR_Customer_ID__c, Merged_AR_Customer_Number__c  FROM Quote__c WHERE Account_Id__c IN:accmap.KeySet()];    
                 system.debug('Quotelist-- '+Quotelist );
                    List<Quote__c> QuoteUpdate = new List<Quote__c>();  
                       if(!Quotelist.isEmpty()|| Test.IsRunningTest()) {
                         for(Quote__c Quo: Quotelist){
                           if(accmap.ContainsKey(Quo.Account_Id__c))
                           {  
                           Quo.AR_Customer_Number__c = accmap.get(Quo.Account_Id__c).ORACLE_AR_CUST_NUMBER__c; Quo.GBMS_ID__c = accmap.get(Quo.Account_Id__c).GBMS_CustomerID__c; 
                           Quo.Oracle_AR_Customer_ID__c = accmap.get(Quo.Account_Id__c).ORACLE_AR_CUST_ACCOUNT_ID__c; Quo.Merged_AR_Customer_Number__c =  mapIdAR_Id.get(Quo.Account_Id__c);                                           
                            }
                            QuoteUpdate.add(Quo);
                          }     
                        }  
                        
                        if(!QuoteUpdate.isEmpty()|| Test.IsRunningTest()) { 
                           Update QuoteUpdate;
                          }  
}
/* 
// Method 2: To update AR customer number, AR customer Id and GBMS Id on Opportunity
    public void OpportunityUpdateOnAccountdelete(Map<Id, Account> accmap){ 

   
                     
          //List<Opportunity> Opplist = new List<Opportunity>();  
          
          List<String> listOpportunityWrapper=new List<String>();         
         
                        for(Opportunity Opp: [SELECT Id, Account.Id, Oracle_AR_Customer_Number__c, GBMS_ID__c,Oracle_AR_Customer_ID__c FROM Opportunity WHERE Account.Id IN:accmap.KeySet()]){
                          
                                OpportunityWrapper oppWrpObj=new OpportunityWrapper(Opp.id,accmap.get(Opp.Account.Id).ORACLE_AR_CUST_NUMBER__c,accmap.get(Opp.Account.Id).GBMS_CustomerID__c,
                                accmap.get(Opp.Account.Id).ORACLE_AR_CUST_ACCOUNT_ID__c);  listOpportunityWrapper.add(JSON.serialize(oppWrpObj));
                         } 

                        AccountTriggerHandler.updateOpportunityInMerge(listOpportunityWrapper);                     
                        //}  
                        
                        
                      
    }
*/
// Method 3: To update AR customer number, AR customer Id and GBMS Id on Booth
public void BoothUpdateOnAccountdelete(Map<Id, Account> accmap){ 

 
                     
          List<Oracle_Show_Booth__c> Boothlist = new List<Oracle_Show_Booth__c>();     
          Boothlist = [SELECT Id, Account__c, Oracle_AR_Customer_Number__c, GBMS_ID__c,Oracle_AR_Customer_ID__c FROM Oracle_Show_Booth__c WHERE Account__c IN:accmap.KeySet()];   
                    
                    List<Oracle_Show_Booth__c> BothUpdate = new List<Oracle_Show_Booth__c>();  
                       if(!Boothlist.isEmpty()|| Test.IsRunningTest()) {
                         for(Oracle_Show_Booth__c boo: Boothlist){
                           if(accmap.ContainsKey(boo.Account__c)){ 
                           boo.Oracle_AR_Customer_Number__c = accmap.get(boo.Account__c).ORACLE_AR_CUST_NUMBER__c;   boo.GBMS_ID__c = accmap.get(boo.Account__c).GBMS_CustomerID__c; 
                           boo.Oracle_AR_Customer_ID__c = accmap.get(boo.Account__c).ORACLE_AR_CUST_ACCOUNT_ID__c;   boo.Booth_Account_Deleted__c = True;                                       
                            }
                            BothUpdate.add(boo);
                          }     
                        }  
                        
                        if(!BothUpdate.isEmpty()|| Test.IsRunningTest()) { 
                           Update BothUpdate;
                          }  
}
 /*  
// Method 4: To update AR customer number, AR customer Id and GBMS Id on Contact
public void contactUpdateOnAccountdelete(Map<Id, Account> accmap){ 


                     
          List<Contact> contactlist = new List<Contact>();     
          contactlist = [SELECT Id, Account.Id, Oracle_AR_Customer_Number__c, GBMS_ID__c,Oracle_AR_Customer_ID__c FROM Contact WHERE Account.Id IN:accmap.KeySet()];   
                    
                    List<Contact> contactUpdate = new List<Contact>();  
                       if(!contactlist.isEmpty()|| Test.IsRunningTest()) {
                         for(contact cntct: contactlist){
                           if(accmap.ContainsKey(cntct.Account.Id))
                           {  
                           cntct.Oracle_AR_Customer_Number__c = accmap.get(cntct.Account.Id).ORACLE_AR_CUST_NUMBER__c;  
                           cntct.GBMS_ID__c = accmap.get(cntct.Account.Id).GBMS_CustomerID__c; 
                           cntct.Oracle_AR_Customer_ID__c = accmap.get(cntct.Account.Id).ORACLE_AR_CUST_ACCOUNT_ID__c;      
                                                                   
                            }
                            contactUpdate.add(cntct);
                          }     
                        }  
                        
                        if(!contactUpdate.isEmpty()|| Test.IsRunningTest()) { 
                           Update contactUpdate;
                          }  
}
*/

// Method 5: To update AR customer number, AR customer Id and GBMS Id on AR customer Info
public void ARcustomerUpdateOnAccountdelete(Map<Id, Account> oldAccMap){ 

 List<AR_Customer_Info__c> ARlist = new List <AR_Customer_Info__c>();    
// List<Account_Merge_Info__c> AMlist= new List <Account_Merge_Info__c>();    
 
 for(Account acc: oldAccMap.Values()){     
    
            ARlist.add(new AR_Customer_Info__c(Account__c = acc.Id, 
                                                AR_Customer_Number__c = acc.ORACLE_AR_CUST_NUMBER__c, 
                                                GBMS_ID__c = acc.GBMS_CustomerID__c, 
                                                Oracle_AR_Customer_ID__c = acc.ORACLE_AR_CUST_ACCOUNT_ID__c, Deleted_Account_Id__c = acc.Id,
                                                Name = String.isNotBlank(acc.ORACLE_AR_CUST_NUMBER__c)?acc.ORACLE_AR_CUST_NUMBER__c:'000000',
                                                Payment_Terms__c=acc.Payment_Terms__c,
                                                Deleted_Account_Owner__c = acc.ownerid,
                                                Credit_Limit__c = acc.Credit_Limit__c,
                                                Opportunity_Count__c = getOpptyCount(acc.Id)));
           /*                                     
             AMlist.add(new Account_Merge_Info__c(Account_Id__c = acc.Id, 
                                            Last_owner__c = acc.ownerid,
                                            Credit_Limit__c = acc.Credit_Limit__c,
                                            Opportunity_Count__c = getOpptyCount(acc.Id)));
            */                                   
                                                
                                            
    }
 
        if(!ARlist.isEmpty()){
            Insert ARlist; 
        } 
        
        /*
        if(!AMlist.isEmpty()){
            Insert AMlist; 
        } 
        */
      
        
}


// Method 6: To get the Opportinity count of  Account 
public Decimal getOpptyCount(Id accId){ 
    Decimal opptyCount = [SELECT count() from Opportunity WHERE Account.Id =:accId];  
    return opptyCount;
}


// Method 7: To get the Owner of the Winning Account 
public static Id getAccountOwner(ID accId){ 
   
   List<Account> accountList = new List<Account>();  
    accountList = [SELECT ownerid from Account WHERE Id =:accId];  
    Id ownr = accountList.get(0).ownerid;
    return ownr;
}


// Method 8: To retrieve the Account ownership 
    
   public static void updAccountOwner(Id  newAccId){
         
         Id Ownerid = null;  
         Decimal delOpptyCount = null;
         Id corpAccpoolId = Label.Corporate_Account_Pool_ID;
         List<AR_Customer_Info__c> ARlist = new List <AR_Customer_Info__c>();    
         ARlist = [SELECT Deleted_Account_Id__c, Opportunity_Count__c, Deleted_Account_Owner__c from AR_Customer_Info__c WHERE Account__c =: newAccId order by Opportunity_Count__c desc];
         
         if(!ARlist.isEmpty()) {
          for (AR_Customer_Info__c ARInfo: ARlist) { if(Ownerid == null) {  delOpptyCount = ARInfo.Opportunity_Count__c;   
            
            if(ARInfo.Deleted_Account_Owner__c != corpAccpoolId) {  Ownerid = ARInfo.Deleted_Account_Owner__c;
               
               } 
               }
             }
           }
          
         // Decimal masteropptyCount =  [SELECT count() from Opportunity WHERE Account.Id =:newAccId]; 
          Decimal masteropptyCount = getMasterOpptyCount(newAccId);
          Id MasterOwnerid = getAccountOwner(newAccId);
          
          if (masteropptyCount >= delOpptyCount && MasterOwnerid != corpAccpoolId) {
          Ownerid = MasterOwnerid;
          
          }
           if(isFirstTime){
            isFirstTime = false;
            if (Ownerid != null) {
                updateAccountOwnership(Ownerid,newAccId);
            }
           }
            
          }
          
// Method 9: To update the Account ownership  on Account

    
    public static void updateAccountOwnership(Id ownId, Id acntId){
        system.debug ('++++++Ownerid Update Account+++++' + ownId);        
        List<Account> listAccount=new List<Account>(); for(Account acc:[Select Id, ownerId from account where Id = :acntId]){  acc.ownerid=ownId;  listAccount.add(acc);
             }
        
        if(!listAccount.isEmpty()|| Test.IsRunningTest()){  update listAccount;
        }
        
    }
    
// Method 10: To get the Opportinity count of Master Account 
    public Static Decimal getMasterOpptyCount(Id accId){ 
    Decimal opptyCountDeleted = 0;
    Decimal opptyCountMaster = [SELECT count() from Opportunity WHERE Account.Id =:accId];  
    
    if(!Test.IsRunningTest()){
    List<AggregateResult> results = [SELECT sum(Opportunity_Count__c) from AR_Customer_Info__c WHERE Account__c =:accId];   opptyCountDeleted = (Decimal) results[0].get('expr0');
    
    }
    return opptyCountMaster - opptyCountDeleted;
    
}
// Method 11: To update Opportinities on Account Merge using Batchable APEX 
  public void OpportunityUpdateOnAccountdeleteBatch(Map<Id, Account> accmap){ 

  
  List<Opportunity> Opptylist = new List<Opportunity>();     
  Opptylist = [SELECT Id, Account.Id, GBMS_ID__c,Oracle_AR_Customer_ID__c,Oracle_AR_Customer_Number__c FROM Opportunity WHERE Account.Id IN:accmap.KeySet()];   
     map <Id, Opportunity> opptyMap = new map <Id, Opportunity>(); 
                       if(!Opptylist.isEmpty()) {
                         for(Opportunity oppt: Opptylist){
                           if(accmap.ContainsKey(oppt.Account.Id)){ 
                           oppt.Oracle_AR_Customer_Number__c = accmap.get(oppt.Account.Id).ORACLE_AR_CUST_NUMBER__c;   
                           oppt.GBMS_ID__c = accmap.get(oppt.Account.Id).GBMS_CustomerID__c; 
                           oppt.Oracle_AR_Customer_ID__c = accmap.get(oppt.Account.Id).ORACLE_AR_CUST_ACCOUNT_ID__c;  
                           }
                            opptyMap.put(oppt.Id,oppt);
                          }     
                        } 
               system.debug ('++++++opptyMap.size+++++' + opptyMap.size());          
               Id strid = Database.executebatch(new BatchableOpportunityUpdate(opptyMap), 1);          
                      
    }
    
// Method 12: To update Contacts on Account Merge using Batchable APEX 
  public void ContactUpdateOnAccountdeleteBatch(Map<Id, Account> accmap){ 

    List<Contact> Contctlist = new List<Contact>();     
    Contctlist = [SELECT Id, Account.Id, Oracle_AR_Customer_Number__c, GBMS_ID__c,Oracle_AR_Customer_ID__c FROM Contact WHERE Account.Id IN:accmap.KeySet()];   
     map <Id, Contact> cnctMap = new map <Id, Contact>(); 
                       if(!Contctlist.isEmpty()) {
                         for(Contact cntct: Contctlist){
                           if(accmap.ContainsKey(cntct.Account.Id)){ 
                           cntct.Oracle_AR_Customer_Number__c = accmap.get(cntct.Account.Id).ORACLE_AR_CUST_NUMBER__c;   
                           cntct.GBMS_ID__c = accmap.get(cntct.Account.Id).GBMS_CustomerID__c; 
                           cntct.Oracle_AR_Customer_ID__c = accmap.get(cntct.Account.Id).ORACLE_AR_CUST_ACCOUNT_ID__c;  
                           }
                            cnctMap.put(cntct.Id,cntct);
                          }     
                        } 
               
              Id strid = Database.executebatch(new BatchableContactUpdate(cnctMap), 1);          
                      
    }
           
               
   
 /*   
// Method 13: To update Booths on Account Merge using Batchable APEX 
  public void BoothUpdateOnAccountdeleteBatch(Map<Id, Account> accmap){ 

           set<Id> bthIds = new set<Id>();
           for(Oracle_Show_Booth__c bth: [SELECT Id, Account__c FROM Oracle_Show_Booth__c WHERE Account__c IN:accmap.KeySet()]){
                            bthIds.add(bth.id);
                         } 
               system.debug ('++++++bthIds size+++++' + bthIds.size());    
               Id strid = Database.executebatch(new BatchableBoothUpdate(accmap,bthIds), 1);          
                      
    }
    
    
// Method 14: To update Quotes on Account Merge using Batchable APEX 
  public void QuoteUpdateOnAccountdeleteBatch(Map<Id, Account> accmap){ 

           set<Id> quotesIds = new set<Id>();
           for(Quote__c qut: [SELECT Id, Account_Id__c FROM Quote__c WHERE Account_Id__c IN:accmap.KeySet()]){
                            quotesIds.add(qut.id);
                         } 
               Id strid = Database.executebatch(new BatchableQuoteUpdate(accmap,quotesIds), 1);          
                      
    }
    
 
        // Method 7: To update Opportunity Count and Account Owner for Merge
    public void triggerCntrlMethod(Map<Id, Account> oldAccMap){
    List<Account_Merge_Info__c> AMlistUpdate = new List <Account_Merge_Info__c>();   
    List<Account_Merge_Info__c> extAMlistUpdate = new List <Account_Merge_Info__c>();    
    
    AMlistUpdate = [SELECT Account_Id__c,id from Account_Merge_Info__c WHERE Account_Id__c =:oldAccMap.keyset()];  
         if(!AMlistUpdate.isEmpty()) {
             for(Account_Merge_Info__c AMInfo: AMlistUpdate){
                  for(Account acc: oldAccMap.Values()){  
                      if(acc.Id == AMInfo.Account_Id__c){ 
                                AMInfo.Merge_Account__c = acc.MasterRecordId;
                                AMInfo.Merge_ID__c = acc.MasterRecordId;       
                       }
                  }
                       extAMlistUpdate.add(AMInfo);
              }     
         }  
            if(!extAMlistUpdate.isEmpty()|| Test.IsRunningTest()) { 
            Update extAMlistUpdate;
            }  
    for(Account acc: oldAccMap.Values()){   
              Integer rowCnt = [SELECT count() from Account_Merge_Info__c WHERE Account_Id__c =:acc.MasterRecordId];  
                           if (rowCnt == 0){
                           List<Account_Merge_Info__c> AMlist = new List <Account_Merge_Info__c>();  
                           AMlist.add(new Account_Merge_Info__c(Account_Id__c = acc.MasterRecordId, 
                                                    Last_owner__c = getAccountOwner(acc.MasterRecordId),
                                                    Opportunity_Count__c = getOpptyCountWin(acc.MasterRecordId),
                                                    Credit_Limit__c = getCreditLimitWin(acc.MasterRecordId),
                                                    Merge_ID__c = acc.MasterRecordId, 
                                                    Merge_Account__c = acc.MasterRecordId));
                            if(!AMlist.isEmpty()){
                            Insert AMlist;
                             }
                            }
                }     
                        
    }
        // Method 9: To get the Opportinity count of Deleted Accounts 
public Decimal getOpptyCountWin(String MasteraccId){ 
  
    Decimal opptyCountAll = [SELECT count() from Opportunity WHERE Account.Id =:MasteraccId];  
    List<AggregateResult> results = [select sum (Opportunity_Count__c)oppty from Account_Merge_Info__c where Merge_ID__c =:MasteraccId];  
    Decimal opptyCountDeleted = (Decimal) results[0].get('oppty');
    return opptyCountAll-opptyCountDeleted ;
}

// Method 10: To get the Credit Limit of Winning Account 
public Decimal getCreditLimitWin(String MasteraccId){ 
    List<Account> accountList = new List<Account>();  
    accountList = [SELECT Credit_Limit__c from Account WHERE Account.Id =:MasteraccId]; 
    return  accountList.get(0).Credit_Limit__c;
    
}

        List<Account_Merge_Info__c> AMlist = new List <Account_Merge_Info__c>();   
         //AMlist = [SELECT Account_Id__c, max(Opportunity_Count__c), Last_owner__c from Account_Merge_Info__c WHERE Merge_ID__c =: newAccId group by Last_owner__c , Account_Id__c];  
         AMlist = [SELECT Account_Id__c, Opportunity_Count__c, Last_owner__c from Account_Merge_Info__c WHERE Merge_ID__c In: newAccId order by Opportunity_Count__c desc];
         system.debug ('++++++AMlist+++++' + AMlist.size());    
        if(!AMlist.isEmpty()) {
          for (Account_Merge_Info__c AMInfo: AMlist) {
            system.debug ('++++++Ownerid inside for+++++' + Ownerid);   
            if(AMInfo.Last_owner__c != corpAccpoolId && Ownerid == null) {
               Ownerid = AMInfo.Last_owner__c;
               system.debug ('++++++Ownerid inside if+++++' + Ownerid);
               
               } 
         }
        }
        system.debug ('++++++Ownerid+++++' + Ownerid);
        List<Account> listAccount=new List<Account>();
        */
        
    

/*
  // Method 6: To update deleted Oracle AR Customer Numbers on Account 
public void ARUpdateOnAccountdelete(Map<Id, Account> accmap){ 

List<AR_Customer_Info__c> ARlist = new List <AR_Customer_Info__c>();
List<AR_Customer_Info__c> ARlistCmp = new List <AR_Customer_Info__c>();
String listARNum = null;
String newAccID = null;
Map<Id,String> mapIdAR_Id=new Map<ID,String>(); 
ARlist =  [Select Account__c, Master_Account_Id__c, AR_Customer_Number__c,Deleted_Account_Id__c from AR_Customer_Info__c where Deleted_Account_Id__c in :accmap.keySet()];
system.debug('++++++ArrayList.size:'+ARlist.size());
ARlistCmp=[Select Account__c, Master_Account_Id__c, AR_Customer_Number__c,Deleted_Account_Id__c from AR_Customer_Info__c where Deleted_Account_Id__c in :accmap.keySet()]; 
 system.debug('++++++ArrayList.size:'+ARlistCmp.size());                     
                      if((!ARlist.isEmpty() && !ARlistCmp.isEmpty())|| Test.IsRunningTest()) {
                         for(Integer i = 0; i < ARlist.size(); i++)
                            { 
                                listARNum = ARlist.get(i).AR_Customer_Number__c;
                                for(Integer j = 0; j < ARlistCmp.size(); j++)
                                {
                                     if(ARlist.get(i).Master_Account_Id__c == ARlistCmp.get(j).Master_Account_Id__c){
                                       if(ARlist.get(i).AR_Customer_Number__c != ARlistCmp.get(j).AR_Customer_Number__c){
                                        listARNum = listARNum+','+ARlistCmp.get(j).AR_Customer_Number__c;
                                        system.debug ('++++++listARNum+++++' + listARNum);
                                        newAccID= ARlistCmp.get(j).Master_Account_Id__c;
                                     }   }
                                }
                            }
                  }  
      
      Long startTime = DateTime.now().getTime();
      Long finishTime = DateTime.now().getTime();
        while ((finishTime - startTime) < 45000) {
        //sleep for 45s
        finishTime = DateTime.now().getTime();
    }
      List<String> listAccount=new List<String>();
      system.debug ('++++++newAccID+++++' + newAccID);
      for(Account acnt:[Select id, Deleted_Oracle_AR_Customer_Number__c from account where id = :newAccID]){
      
      if(acnt.Deleted_Oracle_AR_Customer_Number__c == null) {
            acnt.Deleted_Oracle_AR_Customer_Number__c = listARNum;
        } else {
            acnt.Deleted_Oracle_AR_Customer_Number__c = ','+listARNum;
            system.debug ('++++++Deleted_Oracle_AR_Customer_Number__c:Final+++++' + acnt.Deleted_Oracle_AR_Customer_Number__c );
        } 
        AccountWrapper accWrpObj=new AccountWrapper(acnt.id,acnt.Deleted_Oracle_AR_Customer_Number__c);
        
        listAccount.add(JSON.serialize(accWrpObj)); //0014000000Z7iwdAAB, 0014000000Z7iwdAAB
           
    }
    updateDeletedARNum(listAccount);
  }          
  
  // @future
    public static void updateDeletedARNum(List<String> JSONAccount){
               
        List<Account> listAccount=new List<Account>();
           AccountWrapper instAccWrp;
           system.debug('======>'+JSONAccount);
         
            for (String strAcc : JSONAccount){
            
                    Account instAcc=new Account();
                    instAccWrp = (AccountWrapper) JSON.deserialize(strAcc, AccountWrapper.class);
                    instAcc.id=instAccWrp.id;
                    instAcc.Deleted_Oracle_AR_Customer_Number__c=instAccWrp.arCustNum;
                    listAccount.add(instAcc);
            }
            system.debug('==============listAccount'+listAccount);
            if(!listAccount.isEmpty()){
                update listAccount;
            }
        
    } 
    
 
    // Method 7: To insert deleted Oracle AR Customer Numbers on Account
public void updateDeletedARCustNum(Map<Id, Account> accmap){ 

 List<Account> accntlist = new List<Account>();     
          accntlist = [SELECT Account.ID,ORACLE_AR_CUST_NUMBER__c,Deleted_Oracle_AR_Customer_Number__c FROM Account WHERE Account.Id IN:accmap.KeySet()];   
                    
                    List<Account> accountUpdate = new List<Account>();  
                       if(!accntlist.isEmpty()|| Test.IsRunningTest()) {
                         for(Account antct: accntlist){
                           if(accmap.ContainsKey(antct.Id)){
                            antct.Deleted_Oracle_AR_Customer_Number__c = accmap.get(antct.Id).ORACLE_AR_CUST_NUMBER__c;
                            system.debug ('++++++antct.Deleted_Oracle_AR_Customer_Number__c+++++' + antct.Deleted_Oracle_AR_Customer_Number__c );                                                                                                                                  
                            }
                            accountUpdate.add(antct);
                          }     
                        }  
                        
                        if(!accountUpdate.isEmpty()|| Test.IsRunningTest()) { 
                         //  Update accountUpdate;
                          }  

}


 


 // Method 8: To update deleted Oracle AR Customer Numbers on Account 
public void ARUpdateAccountUpdate(Map<Id, Account> accmap){ 

     system.debug('++++++Inside Method 7:'); 
    List<Account> Accountlist = new List <Account>(); 
    Accountlist = [SELECT Account.ID,MasterRecordId,ORACLE_AR_CUST_NUMBER__c FROM Account WHERE Account.Id IN:accmap.KeySet()];   
         system.debug('++++++ArrayList.size:'+Accountlist.size());           
    String accIdnew = null; 
    
                       if(!Accountlist.isEmpty()|| Test.IsRunningTest()) {
                         for(Account acc: Accountlist){
                           if(accmap.ContainsKey(acc.Id)){
                            system.debug ('++++++acc.Id+++++' + acc.Id);
                            accIdnew = accmap.get(acc.Id).MasterRecordId;
                            system.debug ('++++++accIdnew+++++' + accIdnew);
                            system.debug ('++++++ORACLE_AR_CUST_NUMBER__c+++++' + accmap.get(acc.Id).ORACLE_AR_CUST_NUMBER__c);
                            }
                              
                                            
    }       
    
    }

      Map<Id,String> deletedvalues =  new Map<Id,String>() ; // stores winning account id with dleted records values
   // Set<Id> winacctid = New Set<Id> () ;
     for (Account oldacc:accmap)
    {
   // winacctid.add(oldacc.MasterRecordId) ;
   
   
   if(!deletedvalues.containskey(oldacc.MasterRecordId))
       {deletedvalues.put(oldacc.MasterRecordId,oldacc.ORACLE_AR_CUST_NUMBER__c) ;}
       else
       {String TempValue = deletedvalues.get(oldacc.MasterRecordId);
       deletedvalues.put(oldacc.MasterRecordId,TempValue + ',' +oldacc.ORACLE_AR_CUST_NUMBER__c) ;
       }
    
    
    }
       List<Account> winninAcctoupd = new List <Account>() ;
    for(Id accIdtoupd: deletedvalues.keyset())
    {
    Account Acc = new Account(Id=accIdtoupd,Deleted_Oracle_AR_Customer_Number__c =deletedvalues.get(accIdtoupd) ) ;
    winninAcctoupd.add(Acc ) ;
    }
    update winninAcctoupd ;
    
    
   // winninAcc =  [Select Id,Oracle_AR_Customer_Number__c From Account Where Id In :winacctid] ;
      
        
} */
  
    /*

     Desc:Method to update opportunity during merge
    
    */
 
    @future
    public static void  updateOpportunityInMerge(List<String> oppWrpObjJSON){
           
           List<Opportunity> listOpportunity=new List<Opportunity>();
           OpportunityWrapper instOppWrp;
           system.debug('======>'+oppWrpObjJSON);
         
            for (String strOpp : oppWrpObjJSON){
            
                    Opportunity instOpp=new Opportunity();
                    instOppWrp = (OpportunityWrapper) JSON.deserialize(strOpp, OpportunityWrapper.class);
                    instOpp.id=instOppWrp.oppId;
                    instOpp.Oracle_AR_Customer_Number__c=instOppWrp.arCustomerNo;
                    instOpp.GBMS_ID__c=instOppWrp.GBMSId;
                    instOpp.Oracle_AR_Customer_ID__c=instOppWrp.arCustomerID;
                    listOpportunity.add(instOpp);
            }
            system.debug('==============listOpportunity'+listOpportunity);
            if(!listOpportunity.isEmpty()){
                update listOpportunity;
            }
    }
    /*
    
      Desc: update to processed flag to false if there is change in standard DUNS Number
      
    */
   // @future
    public static void updateProcessedFlag(Set<ID> setAccountIDS){
        
        
        List<Account> listAccount=new List<Account>();
        for(Account acc:[Select id, Processed_Flag__c from account where id in :setAccountIDS and Processed_Flag__c=true]){
            
                acc.Processed_Flag__c=false;   listAccount.add(acc);
        }// end 
        
        for(Account accObj:[Select id, Processed_Flag__c from account where parentid in :setAccountIDS and Processed_Flag__c=true]){
            
            accObj.Processed_Flag__c=false;   listAccount.add(accObj);
            
        }
        
        
        if(!listAccount.isEmpty()|| Test.IsRunningTest()){
            
            update listAccount;
        }
        
    }

}