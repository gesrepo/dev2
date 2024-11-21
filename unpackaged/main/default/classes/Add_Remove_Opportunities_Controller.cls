public class Add_Remove_Opportunities_Controller 
{
   
    public Show_Plan__c CurrentShowPlan {get;set;}

    public PageReference init() 
    {
        CurrentShowPlan = new Show_Plan__c();           
        if(System.currentPageReference().getParameters().get('id') != null){
            CurrentShowPlan = [Select name, id, show_name__c,Show_Name__r.Name From Show_Plan__c Where id = : System.currentPageReference().getParameters().get('id') Limit 1];
        }
        
        return null;
    }

    public List<oOpportunity> oppList{get; set;}  
        
          
    public List<oOpportunity> getopp()
    {       
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
    
        for(Opportunity o : [select Amount,name,show_name__c,show_name__r.name,Account_Plan__c,Account_Plan__r.name,Show_Close_Date__c,CloseDate,StageName from opportunity where Account_Plan__c !=: CurrentShowPlan.id and Account_Plan__c =: null and  show_name__c =:CurrentShowPlan.show_name__c and show_name__c !=: null and RecordTypeId not in :rtSet Order By Name Limit 1000])
        {
            oppList.add(new oOpportunity(o));
        } 
        return oppList;   
    }


    //remove list
    
    public List<oOpportunity> oppListRemove{get; set;}  
        
          
    public List<oOpportunity> getoppRemove()
    {       
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
        oppListRemove = new List<oOpportunity>();
    
        for(Opportunity o : [select Amount,name,show_name__c,show_name__r.name,Account_Plan__c,Account_Plan__r.name,Show_Close_Date__c,CloseDate,StageName from opportunity where Account_Plan__c =: CurrentShowPlan.id and RecordTypeId not in :rtSet Order By Name Limit 1000])
        {
            oppListRemove.add(new oOpportunity(o));
        } 
        return oppListRemove;   
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
        
    public PageReference DoSelect() 
    {
        try
        {       
            Opportunity[] oppUpdate= new Opportunity[0];
            Set<Id> oppIds = new Set<Id>();

            if (oppList!= null)  
            {     system.debug('in opp list');
                                  
                for(oOpportunity o: oppList)
                {    
                system.debug('oopp' + o.opp.Id);
                system.debug('selected' + o.selected);
                
                    if(o.selected == true) // && !oppSet.Contains(o.opp.Id))
                    {    
                        system.debug('in select true');
                        oppIds.add(o.opp.Id);                       
                    } 
                        
                }
                
                for(Opportunity oppsToUpdate:[select id,Account_Plan__c from Opportunity where id in : oppIds])
                {
                    oppsToUpdate.Account_Plan__c = CurrentShowPlan.id;
                    oppUpdate.add(oppsToUpdate);
                }
                
                if(oppUpdate.size() > 0)
                {
                    update oppUpdate;
                }                 
            }           
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
        }
        return null;
    }
    
    public PageReference DoRemove() {
        try
        {       
            Opportunity[] oppUpdate= new Opportunity[0];
            Set<Id> oppIds = new Set<Id>();

            if (oppListRemove!= null)  
            {     system.debug('in opp list');
                                  
                for(oOpportunity o: oppListRemove)
                {    
                system.debug('oopp' + o.opp.Id);
                system.debug('selected' + o.selected);
                
                    if(o.selected == true) // && !oppSet.Contains(o.opp.Id))
                    {    
                        system.debug('in select true');
                        oppIds.add(o.opp.Id);                       
                    } 
                        
                }
                
                for(Opportunity oppsToUpdate:[select id,Account_Plan__c from Opportunity where id in : oppIds])
                {
                    oppsToUpdate.Account_Plan__c = null;
                    oppUpdate.add(oppsToUpdate);
                }
                
                if(oppUpdate.size() > 0)
                {
                    update oppUpdate;
                }
                 
            }           
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
        }
        return null;
    }
    
    public PageReference BackToPlan() 
    {
        PageReference pr = null;
        try
        {        
            pr = new PageReference('/' + CurrentShowPlan.Id);
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
        }
        return pr;
    }

}