@isTest
public class TestbatchOppUpdateTrg {
	@testsetup 
    static void setupData(){
            List<Opportunity> lsopps=new List<Opportunity>();
            Set<id> OppListIds=new Set<id>();
            RecordType oRectype1 = [Select Id From RecordType Where SObjectType = 'Opportunity' And Name = 'US - Registration'];
            Id Rectype1 = oRectype1.Id; 
            RecordType oRectype2 = [Select Id From RecordType Where SObjectType = 'Opportunity' And Name = 'Sales Rep Show Occurrence'];
            Id RecType2 = oRectype2.Id;  
            for(integer i=0;i<10;i++){
                Opportunity opp = new Opportunity();
                opp.Job_Number__c = 'TEST_JOB_'+i;        
                opp.OwnerId = UserInfo.getUserId();   
                opp.Sales_Person__c = UserInfo.getUserId();        
                opp.Sales_Location__c = 'TEST_LOCATION_'+i;        
                opp.Name = 'TestShowOpp-'+i;        
                opp.Prime_Contractor__c = null;        
                opp.Production_Location__c = 'TEST_LOCATION_'+i; 
                if(i==0){
                  opp.RecordTypeId = RecType1; 
                }
                else if(i==1){
                  opp.RecordTypeId = RecType2;    
                }
                  opp.StageName = 'SL1';  
                  opp.CloseDate = Date.newInstance(DateTime.now().yearGmt()-1,12,2); 
                  lsopps.add(opp);
                }
            Database.insert(lsopps);
     
    }
    
    @isTest
    static void runTest(){
        Map<Id,Opportunity> mOpps=new Map<Id,Opportunity>([Select Id, Name,Show_Occurrence__r.Name, RecordType.Name, Supplemental_Revenue_Stream_Type__c FROM Opportunity]);
        Test.startTest();
        	batchOppUpdatetrg oppBatch=new batchOppUpdatetrg(mOpps.keySet());
        	Database.executeBatch(oppBatch);
        Test.stopTest();
    }
}