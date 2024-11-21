public with sharing class CCXNewCustomerController {

    private final Account acnt;
    private final ApexPages.StandardController controller;
    public List<Account> results {get; set; }
    
    public CCXNewCustomerController(ApexPages.StandardController stdController)
    {
        controller = stdController;
        this.acnt = (Account)stdController.getRecord();
    }
    
    public PageReference saveAccount()
    {
        if (acnt.BillingStreet == '' || acnt.BillingStreet == null
            || acnt.BillingCity == '' || acnt.BillingCity == null
            || acnt.BillingState == '' || acnt.BillingState == null
            || acnt.BillingCountry == '' || acnt.BillingCountry == null
            || acnt.BillingPostalCode == '' || acnt.BillingPostalCode == null
            || acnt.Name == '' || acnt.Name == null
            || acnt.Phone == '' || acnt.Phone == null)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please provide values for required fields. Fields Name, Phone, Billing Street, Billing City, Billing State, Billing Postal Code, and Billing Country are required.'));
        }
        else
        {
            try
            {
                Account NewAccount = new Account();
                NewAccount.Name = acnt.Name;
                NewAccount.Phone = acnt.Phone;
                NewAccount.BillingStreet = acnt.BillingStreet;
                NewAccount.BillingCity = acnt.BillingCity;
                NewAccount.BillingState = acnt.BillingState;
                NewAccount.BillingCountry = acnt.BillingCountry;
                NewAccount.BillingPostalCode = acnt.BillingPostalCode;
                NewAccount.Fax = acnt.Fax;
                NewAccount.Website = acnt.Website;
                
                Database.insert(NewAccount);
                
                acnt.Create_New__c = false;
                
                accountExists();
            }
            catch(Exception e)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            }
        }
        return null;
    }
    
    public PageReference deleteAccount()
    {
        Database.delete(acnt);
    
        return null;
    }
    
    public PageReference accountExists()
    {
        if (acnt.Create_New__c)
        {
            this.saveAccount();
        }
        else
        {
            String accountName = this.acnt.Name;
         
            String Query = 'Select Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, Phone From Account';
            String WhereClause = '';
    
            if (!accountName.equals(''))
            {
                if (WhereClause.equals(''))
                    WhereClause = ' Where ';
                else
                    WhereClause += ' And ';
                    
                WhereClause += ' Name LIKE \'%'+ String.escapeSingleQuotes(accountName).toUpperCase() + '%\'';
            }
            
            Query += WhereClause + ' Limit 20';
            
            results = Database.query(Query);
        }
        
        return null;
    }   
}