trigger TrgBeforeInsertUpdateBooth on Oracle_Show_Booth__c (before insert, before update) {
    
    
 //Desc:  Below code to avoid trigger execute during the merge of account from Demand tool
    // Date: 25-May-2017
    // Added By : Kumud 
    
    if(Userinfo.getProfileID()==Label.MergeSystemAdminId){
      
        return;
    }
    
    //End here
    
    
    /* Populate the Denormalized Fields */
    set<Id> SoAccountId = new set<Id>();
    set<Id> SoShowOccurrenceId = new set<Id>();
    set<Id> SoShowId = new set<Id>();
    
    for(Oracle_Show_Booth__c booth : Trigger.new)
    {
        if (booth.Account__c != null)
            SoAccountId.add(booth.Account__c);
            
        if (booth.Show_Occurrence__c != null)
            SoShowOccurrenceId.add(booth.Show_Occurrence__c);
    }
    
    list<Account> LoAccounts = [Select Id, Name From Account Where Id In :SoAccountId];
    map<Id, String> MoAccountIdToName = new map<Id, String>();
    
    for(Account account : LoAccounts)
        MoAccountIdToName.put(account.Id, account.Name);
        
    list<Opportunity> LoShowOccurrences = [Select Id, Show_Name__c From Opportunity Where Id In :SoShowOccurrenceId];
    map<Id, String> MoShowOccIdToShowId = new  map<Id, String>();
    
    for(Opportunity opty : LoShowOccurrences)
    {
        SoShowId.add(opty.Show_Name__c);
        MoShowOccIdToShowId.put(opty.Id, opty.Show_Name__c);
    }
        
    list<Show__c> LoShows = [Select Id, Name From Show__c Where Id In :SoShowId];
    map<Id, String> MoShowIdToName = new map<Id, String>();
    
    for(Show__c show : LoShows)
        MoShowIdToName.put(show.Id, show.Name);    
    
    for(Oracle_Show_Booth__c booth : Trigger.new)
    {       
        if (booth.Account__c != null)
        {
            booth.Exhibitor_Name_Denormalized__c =  MoAccountIdToName.get(booth.Account__c);
        }
        
        if (booth.Show_Occurrence__c != null)
        {
            booth.show_name_denormalized__c = MoShowIdToName.get(MoShowOccIdToShowId.get(booth.Show_Occurrence__c));
        }
        
        booth.Booth_Name_Searchable__c = booth.Project_Number__c + ' ' + booth.Exhibitor_Name_Denormalized__c;
    }
}