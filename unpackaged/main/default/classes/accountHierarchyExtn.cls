/*
 Custom Extension class to display Account Hierarchy
 Developed By Gaurav Sharma
*/

public class accountHierarchyExtn {

 public String accList {get; set;} 
 public List<Account> accountMergeList {get; set;}    

    public accountHierarchyExtn(ApexPages.StandardController controller) {

    }
    
    // To retrieve Merge Account Lists from selected Account Name
    public PageReference getAccountMergeList() {
    accountMergeList = new List <Account> ();
    system.debug('=========accList  '+accList );
    String[] arrAcc = new List<String>();
     if(Test.isRunningTest()){
     String accList = '3DL DESIGN,13 FISHING';
     arrAcc = accList.split(',');
     } else {
     arrAcc = accList.split(',');
    }
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
    system.debug('=========soqlQuery '+soqlQuery); 
     
     accountMergeList = Database.query(soqlQuery);
     
     return null;
     
    }

    // To build Account Hierarchy for merged Accounts
    public void buildHierarchy() {
    
    set<Id> setOfAccountIds =new Set<Id> ();
       for(Account accnt : accountMergeList) {
         if(accnt.Id!= null) {
           setOfAccountIds.add(accnt.Id);    
                             }
            }
    if (setOfAccountIds.size() >0 ) {
    List<Account> listAcc=[select id,dunsnumber,parentId,parent_duns_number__C,Global_Ultimate_Duns_Number__c,ownerID,createdByid  from account where DunsNumber !='' and id in :setOfAccountIds];
    system.debug('=========setOfAccountIds.size()'+setOfAccountIds.size()); 
    system.debug('=========listAcc.size()'+listAcc.size()); 
    AccountHierarchySetup instAccHier=new AccountHierarchySetup();
    instAccHier.setupAccountHierarchy(listAcc);
    
     }
    }

}