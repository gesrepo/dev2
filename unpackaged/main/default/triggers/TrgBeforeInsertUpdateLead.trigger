trigger TrgBeforeInsertUpdateLead on Lead (before insert, before update) {
    
    //Pool, Corporate Accounts
    //Id: 00540000001bR7gAAE (same in development and production)
    //Username (Dev): exhibitorlist_interface@viad.com.dev2
    //Username (Prod): exhibitorlist_interface@viad.com
    
    User CorporateAccountsPoolUser = [Select Id From User Where Username = 'exhibitorlist_interface@viad.com.dev2'];
    String UserId = CorporateAccountsPoolUser.Id;
    
    for(Lead l : Trigger.New)
    {           
        if (l.RecordTypeId == '0124000000019JxAAI' && (l.Status == 'Not interested at this time' || l.Status == 'Unable to Contact'))
            l.OwnerId = UserId;
    }
}