public class TestDataUtilityClass
{


    /***************************************
* @MethodName        : oppCreation
* @author            : Prema(Birlasoft)
* @created date      : 7/08/2019
* @Last modified by  : 
* @Last modified date: 7/08/2019
* @Purpose           : Create the test opportunity record.
****************************************/   
     public List<opportunity> oppCreation(Integer count)
     { 
    
        List<opportunity> oppLst=new List<opportunity>();
        Opportunity opp=new Opportunity();
        for(Integer i=0;i<count;i++)
        {
            opp=new Opportunity(Name='Test'+i);
            opp.PRF_Sent_to_CORE__c = false;
            opp.Processed_in_CORE__c = false;
            opp.Type  =  'Competitor CORE Show';
            opp.stagename='Prospecting';
            opp.CloseDate=date.today();
            oppLst.add(opp);
                
        }
        try{
            if(oppLst.size()>0)
            {
                Database.insert(oppLst,false);
            }
        }
        catch(Exception e)
        {
              System.debug('TestDataFactory Opportunity insert'+ e);
        }
        return oppLst;
    }
    
    
      
    /***************************************
* @MethodName        : recordTypeCreation
* @author            : Prema(Birlasoft)
* @created date      : 7/08/2019
* @Last modified by  : 
* @Last modified date: 7/08/2019
* @Purpose           : Create the test opportunity recordtype record.
****************************************/   
     public static void recordTypeCreation(String sobj)
     { 
    
        RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType = :sobj LIMIT 1];
        Schema.DescribeSObjectResult d = Schema.SObjectType.Opportunity; 
        Map<Id,Schema.RecordTypeInfo> rtMapById = d.getRecordTypeInfosById();
        Schema.RecordTypeInfo rtById =  rtMapById.get(rt.id);
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName =  rtMapByName.get(rt.name);
        System.assertEquals(rtById,rtByName);
    }
}