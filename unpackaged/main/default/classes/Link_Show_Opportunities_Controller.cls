public class Link_Show_Opportunities_Controller 
{   
    public Account_Credit__c CurrentAccCredit {get;set;}

    public PageReference init() 
    {
        CurrentAccCredit = new Account_Credit__c();           
        if(System.currentPageReference().getParameters().get('id') != null){
            CurrentAccCredit = [Select Id, Account__c From Account_Credit__c Where id = : System.currentPageReference().getParameters().get('id') Limit 1];
        }
        
        return null;
    }
           
    public List<oOpportunity> oppList{get; set;}  
        
          
    public List<oOpportunity> getopp()
    {
        //create a list of opps that are already linked.
        Set<Id> acSet = new Set<Id>();
        for(Account_Credit__c ac:[Select Id, Account__c From Account_Credit__c Where Account__c = : CurrentAccCredit.Account__c])
        {
            acSet.add(ac.Id);
        }
        Set<Id> oppSet = new Set<Id>();
        for(Account_Credit_Opportunity__c aco:[Select Id, Opportunity__c, Account_Credit__c From Account_Credit_Opportunity__c where Account_Credit__c in :acSet]) // =:CurrentAccCredit.Id])
        {
            system.debug('this opp is related already: ' + aco.Opportunity__c);
            oppSet.add(aco.Opportunity__c);
        }
        
        //create a list of E&D opp record types
        Set<Id> rtSet= new Set<Id>();
        for(RecordType rt:[select Id, Name from RecordType where SobjectType = 'Opportunity'])
        {
            if(rt.Name.Contains('E&D'))
            {
                rtSet.add(rt.Id);
            }
        }
        
        //create a list of available opps (excluding those already linked and E&D record types)
        oppList = new List<oOpportunity>();
    
        for(Opportunity o : [Select Id, Name, AccountId, Account.name, OwnerId, Owner.Name From Opportunity Where AccountId = : CurrentAccCredit.Account__c and Id not in :oppSet and RecordTypeId not in :rtSet Order By Name Limit 1000])
        {
            oppList.add(new oOpportunity(o));
        } 
        return oppList;   
    }
          
    /* Wrapper class to contain contact record and a boolean flag */
    public class oOpportunity
    { 
        public Opportunity opp {get; set;} 
        public Boolean selected {get; set;} 
        /*This is the contructor method. When we create a new oOpportunity object we pass a Opportunity that is set to the opp property. We also set the selected value to false*/ 
        public oOpportunity(Opportunity o) 
        {     
            opp = o;     
            selected = false; 
        }
    }/* end of Wrapper class */  
        
    public PageReference DoCancel() 
    {
        PageReference pr = null;
        try
        {        
            pr = new PageReference('/' + CurrentAccCredit.Id);
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
        }
        return pr;
    } 
    
    public PageReference DoSelect() 
    {
        PageReference pr = null;
        try
        {       


            Account_Credit_Opportunity__c[] acoInsert = new Account_Credit_Opportunity__c[0];

            if (oppList!= null)  
            {     system.debug('in opp list');
                                  
                for(oOpportunity o: oppList)
                {    
                system.debug('oopp' + o.opp.Id);
                system.debug('selected' + o.selected);
                
                    if(o.selected == true) // && !oppSet.Contains(o.opp.Id))
                    {    
                        system.debug('in select true');
                        Account_Credit_Opportunity__c acoNew = new Account_Credit_Opportunity__c();
                        acoNew.Account_Credit__c = CurrentAccCredit.Id;
                        acoNew.Opportunity__c = o.opp.Id;
                        acoInsert.add(acoNew);
                    } 
                        
                }
                
                if(acoInsert.size() > 0)
                {
                    insert acoInsert;
                }
                 
            }
           
            pr = new PageReference('/' + CurrentAccCredit.Id);
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
        }
        return pr;
    }       
}