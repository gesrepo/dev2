global class batchOppUpdatetrg implements Database.Batchable<sObject>,Database.Stateful

/*{
public String Query{get;set;}
public  set<Id> OppListIds{get;set;}
List<Opportunity> OppToUpdate{get;set;}
List<Opportunity> OppToUpdate1{get;set;}
global batchOppUpdatetrg( set<Id> OppListIds) {
this.OppListIds = OppListIds;
 OppToUpdate = new List<Opportunity>();
 OppToUpdate1 = new List<Opportunity>();
}
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
    
      System.debug('inside start==============='+OppListIds);
        return Database.getQueryLocator([SELECT Id, Name,Show_Name__c,Show_Occurrence__r.Show_Name__c, RecordType.Name, (SELECT Id, Name,RecordType.Name FROM Show_Opportunities__r) FROM Opportunity Where Id IN :OppListIds]);
    }
   
    global void execute(Database.BatchableContext BC, List<Opportunity> scope)
    {
    
       
   
    for(Opportunity Opp: scope){
        if(Opp.Show_Opportunities__r.size()>0){
            
            list<Opportunity> RelatedOpp = Opp.Show_Opportunities__r;
            for(Opportunity oppr: RelatedOpp){ 
                if(oppr.RecordType.Name == 'AV - Master' || oppr.RecordType.Name == 'AV - CR' || oppr.RecordType.Name == 'AV - CC' || oppr.RecordType.Name == 'AV - CV' || oppr.RecordType.Name == 'AV - DB'
                   || oppr.RecordType.Name == 'AV - IA' || oppr.RecordType.Name == 'AV - LO' || oppr.RecordType.Name == 'AV - PO' || oppr.RecordType.Name == 'AV - PS' || oppr.RecordType.Name == 'AV - TS'
                   || oppr.RecordType.Name == 'US - Housing' || oppr.RecordType.Name == 'US - Registration'){      
                       oppr.Name = Opp.Name;
                       OppToUpdate.add(oppr);
                   }               
            }
        }
    }
  
    
     try{
     
    for(Opportunity Opp:  scope){
    system.debug('inside show');
        if(opp.RecordType.Name == 'AV - Master' || opp.RecordType.Name == 'AV - CR' || opp.RecordType.Name == 'AV - CC' || opp.RecordType.Name == 'AV - CV' || opp.RecordType.Name == 'AV - DB'
           || opp.RecordType.Name == 'AV - IA' || opp.RecordType.Name == 'AV - LO' || opp.RecordType.Name == 'AV - PO' || opp.RecordType.Name == 'AV - PS' || opp.RecordType.Name == 'AV - TS'
           || opp.RecordType.Name == 'US - Housing' || opp.RecordType.Name == 'US - Registration'){ 
               if(opp.Show_Name__c != Opp.Show_Occurrence__r.Show_Name__c){
                   opp.Show_Name__c  = Opp.Show_Occurrence__r.Show_Name__c;
                   OppToUpdate1.add(opp);
               }               
           }
        }
        
 } catch(exception e){}
 
 }
 
   global void finish(Database.BatchableContext BC)
    {
    
      if(OppToUpdate.size()>0){
    update OppToUpdate;
    }
    
      if(OppToUpdate1.size()>0){
        update OppToUpdate1;
    }  
    
  }

 
  
}*/
{
    set<Id> OppListIds;
    global batchOppUpdatetrg(set<Id> OppListIds) 
    {
        this.OppListIds = OppListIds;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) 
    {    
        return Database.getQueryLocator([SELECT Id, Name,Show_Occurrence__r.Name, RecordType.Name, Supplemental_Revenue_Stream_Type__c FROM Opportunity Where Id IN :OppListIds]);
    }

    global void execute(Database.BatchableContext BC, List<Opportunity> scope)
    {        
        for(Opportunity Opp:  scope)
        {            
            system.debug('record type name..!'+opp.RecordType.Name);
            if(opp.RecordType.Name == 'US - Housing')
            {
                opp.Name = Opp.Show_Occurrence__r.Name+'-Housing';
            }
            else if(opp.RecordType.Name == 'US - Housing Supplemental' && opp.Supplemental_Revenue_Stream_Type__c == 'Alternative Accomodations')
            {
                opp.Name = Opp.Show_Occurrence__r.Name+'-HS'+'-AA';
            }
            else if(opp.RecordType.Name == 'US - Housing Supplemental' && opp.Supplemental_Revenue_Stream_Type__c == 'Promotion')
            {
                opp.Name = Opp.Show_Occurrence__r.Name+'-HS'+'-PR';
            }
            else if(opp.RecordType.Name == 'US - Housing Supplemental' && opp.Supplemental_Revenue_Stream_Type__c == 'Dollar Rebate')
            {
                opp.Name = Opp.Show_Occurrence__r.Name+'-HS'+'-DR';
            }
            else if(opp.RecordType.Name == 'US - Registration')
            {
                opp.Name = Opp.Show_Occurrence__r.Name+'-Reg';
            }
            else if(opp.RecordType.Name.containsIgnoreCase('AV -'))
            {
                opp.Name = Opp.Show_Occurrence__r.Name+'-AV';
            }
        }
        
        update scope;
    }
    global void finish(Database.BatchableContext BC)
    {       
    }
}