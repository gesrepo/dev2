public class CalculateIncentiveController {
  
  public static list<Incentives__c> lstIncentive = new list<Incentives__c>();
  public static Incentives__c objTmpIncentive;
 @AuraEnabled
 public static void createIncentives(string agreementID){
 
    
     list<string> lstRelatedOpp = new list<string>();    
     list<Agreements__c> lstAgree = new list<Agreements__c>([SELECT ID,Incentive_Created__c,Show_Occurrence__c, Show_Occurrence_2__c, Show_Occurrence_3__c, Show_Occurrence_4__c, Show_Occurrence_5__c, Sales_Person__c,Show_Occurrence_6__c,Front_End_Percent__c,Rep_1_Back_End_Percent__c,SalesRep1__c,User__c,SalesRep3__c,SalesRep4__c,Rep_2_Back_End_Percent__c,Rep_4_Back_End_Percent__c,Rep_3_Back_End_Percent__c,Rep_2_Front_End_Percent__c,Rep_3_Front_End_Percent__c,Rep_4_Front_End_Percent__c, AV_Opportunity__c, AV_Opportunity_2__c, AV_Opportunity_3__c, AV_Opportunity_4__c, AV_Opportunity_5__c, AV_Opportunity_6__c From Agreements__c WHERE ID=:agreementID]);
     if(lstAgree[0].Incentive_Created__c == false) 
     {
        if (lstAgree[0].Show_Occurrence__c != null) 
        { 
        lstRelatedOpp.add(lstAgree[0].Show_Occurrence__c); 
        } 
        if (lstAgree[0].Show_Occurrence_2__c != null) 
        { 
        lstRelatedOpp.add(lstAgree[0].Show_Occurrence_2__c); 
        } 
        if (lstAgree[0].Show_Occurrence_3__c != null) 
        { 
        lstRelatedOpp.add(lstAgree[0].Show_Occurrence_3__c); 
        } 
        if (lstAgree[0].Show_Occurrence_4__c != null) 
        { 
        lstRelatedOpp.add(lstAgree[0].Show_Occurrence_4__c); 
        } 
        if (lstAgree[0].Show_Occurrence_5__c != null) 
        { 
        lstRelatedOpp.add(lstAgree[0].Show_Occurrence_5__c); 
        } 
        if (lstAgree[0].Show_Occurrence_6__c != null) 
        { 
        lstRelatedOpp.add(lstAgree[0].Show_Occurrence_6__c); 
        } 
        if (lstAgree[0].AV_Opportunity__c != null) 
        { 
        lstRelatedOpp.add(lstAgree[0].AV_Opportunity__c); 
        } 
        if (lstAgree[0].AV_Opportunity_2__c != null) 
        { 
        lstRelatedOpp.add(lstAgree[0].AV_Opportunity_2__c); 
        } 
        if (lstAgree[0].AV_Opportunity_3__c != null) 
        { 
        lstRelatedOpp.add(lstAgree[0].AV_Opportunity_3__c); 
        } 
        if (lstAgree[0].AV_Opportunity_4__c != null) 
        { 
        lstRelatedOpp.add(lstAgree[0].AV_Opportunity_4__c); 
        } 
        if (lstAgree[0].AV_Opportunity_5__c != null) 
        { 
        lstRelatedOpp.add(lstAgree[0].AV_Opportunity_5__c); 
        } 
        if (lstAgree[0].AV_Opportunity_6__c != null) 
        { 
        lstRelatedOpp.add(lstAgree[0].AV_Opportunity_6__c); 
        } 
         
     }
     system.debug('Opportunity List size :'+lstRelatedOpp.size()+'Opportunity List to be iterated :'+lstRelatedOpp);
     if(lstRelatedOpp.size()>0)
     {
        Incentives__c objTmpIncentive;
        for(string oppID : lstRelatedOpp)
        {
            if(oppID != null)
            {
                
                salesrep(oppID,lstAgree[0],lstAgree[0].SalesRep1__c,lstAgree[0].Rep_1_Back_End_Percent__c,lstAgree[0].Front_End_Percent__c);
                salesrep(oppID,lstAgree[0],lstAgree[0].User__c,lstAgree[0].Rep_2_Back_End_Percent__c,lstAgree[0].Rep_2_Front_End_Percent__c);
                salesrep(oppID,lstAgree[0],lstAgree[0].SalesRep3__c,lstAgree[0].Rep_3_Back_End_Percent__c,lstAgree[0].Rep_3_Front_End_Percent__c);
                salesrep(oppID,lstAgree[0],lstAgree[0].SalesRep4__c,lstAgree[0].Rep_4_Back_End_Percent__c,lstAgree[0].Rep_4_Front_End_Percent__c);
            }           
        }
        system.debug('incentive List size :'+lstIncentive.size()+'incentive List tobe created : '+lstIncentive);
        if(!lstIncentive.isEmpty())
        {
            try{
                    insert lstIncentive;    
                    lstAgree[0].Incentive_Created__c = true;
                    update lstAgree;
                
            }catch(Exception e){
                system.debug('Exception occured while inserting Incentives : '+e.getMessage());
				throw new AuraHandledException(e.getMessage());
            }
        }
     }
 }
 
 public static void salesrep(string oppID,Agreements__c tempAgreement,string userId,Decimal incentiveback, Decimal incentivefront)
 {
    if(userId != null)
    {
         objTmpIncentive = new Incentives__c();
         objTmpIncentive.Show_Occurrence__c = oppID; 
         objTmpIncentive.Sales_Person__c = tempAgreement.Sales_Person__c; 
         objTmpIncentive.Sales_Rep__c = userId; 
         objTmpIncentive.Incentive__c = incentiveback; 
         objTmpIncentive.Type__c = 'Back-end';   
         lstIncentive.add(objTmpIncentive);
         
         objTmpIncentive = new Incentives__c();
         objTmpIncentive.Show_Occurrence__c = oppID; 
         objTmpIncentive.Sales_Person__c = tempAgreement.Sales_Person__c; 
         objTmpIncentive.Sales_Rep__c = userId; 
         objTmpIncentive.Incentive__c = incentivefront; 
         objTmpIncentive.Type__c = 'Front-end';      
         lstIncentive.add(objTmpIncentive);
     }
 }
 
}