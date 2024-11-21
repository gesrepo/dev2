@isTest(SeeAllData = true)
public class GNT_OpportunityTriggerTest1  {

    public static testMethod void testmethod_1() {
    
    opportunity opp = [select id, name from opportunity limit 1];
    delete opp;
    
    }
  
  }