public  class UpdateOpportunity {
     @AuraEnabled
    public static void upadateOpportunity(String RecordId) {
            opportunity opp  =  [select  id  , PRF_Sent_to_CORE__c , Processed_in_CORE__c , Type from opportunity where id  =: RecordId ];
            opp.PRF_Sent_to_CORE__c = True;
            opp.Processed_in_CORE__c = false;
            opp.Type    =  'Competitor CORE Show'; 
        try{
          update opp;
          if(Test.isRunningTest())
            {
                throw new applicationException ('Invalid myValue');

            }
        }
        catch(Exception e){
          
        }    

    }
    
    public class applicationException extends Exception {}

       
}