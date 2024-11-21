@istest
public class LC_FloorPlanControllerTest {
    @istest
    public static void getPCIdTest(){
        Opportunity opp=LC_TestUtils.insertOpportunity();
        GC_Connect2_Show__c show=LC_TestUtils.insertShow(opp.Id, opp.Name);
        
        Floor_Plan_Request__c fpr = new Floor_Plan_Request__c();
        fpr.Request_Plan_Type__c = 'Initial';
        fpr.Connect2_Show__c = show.Id;
        fpr.Halls__c = '1';
        fpr.Fire_Marshaling__c = 'Yes';
        insert fpr;
        
        string result = LC_FloorPlanController.getPCId(fpr.Id);
        System.assertEquals(show.Id, result);
    }
}