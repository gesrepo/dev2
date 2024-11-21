@isTest
public class LC_VOTRelatedListControllerTest {
    @testsetup
    public static void testSetup(){
        Opportunity opp=LC_TestUtils.insertOpportunity();
        GC_Connect2_Show__c show=LC_TestUtils.insertShow(opp.Id,opp.Name);
        GC_Order__c order=LC_TestUtils.insertOrder(show.Id);
        GC_Show_Attribute__c serviceAttribute=LC_TestUtils.insertServiceAttributes(show.Id);
        GC_Show_Attribute__c venueAttribute=LC_TestUtils.insertVenueAttributes(show.Id);
        GC_Show_Team_Member__c member=LC_TestUtils.insertShowTeamMember(serviceAttribute.Id,show.Id);
        GC_Vendor_Order_Task__c vot=LC_TestUtils.insertVOT(order.Id,serviceAttribute.Id);
    }
    @isTest
    public static void testMethod1() {
        GC_Show_Team_Member__c member=[select User__c from GC_Show_Team_Member__c limit 1];
        GC_Show_Team_Member__c mem=[select User__r.Name from GC_Show_Team_Member__c where User__c=:member.User__c];
        string vendorName=mem.User__r.Name;
        GC_Order__c order=[select id from GC_Order__c where Booth_Area__c='new Booth Area'];
        GC_Vendor_Order_Task__c vot=[select id, name,Status__c,Order__c,Delivery_Location_Ven__c from GC_Vendor_Order_Task__c where Delivery_Location_Ven__c='votForExistingMethod Location'];
        Test.startTest();    
        LC_VOTRelatedListController.getOrdersData(order.Id);
        LC_VOTRelatedListController.fetchVOTData(order.Id);
        LC_VOTRelatedListController.getPicklistValues(order.Id);
        LC_VOTRelatedListController.getVenueLocations(order.Id);
        LC_VOTRelatedListController.InsertVOT(null,false,order.Id,'Test Service attribut1','Test Service attribut1','Test Service attribut1','Test Service attribut1','Test Service attribut1',vendorName,vendorName,vendorName,vendorName,vendorName,'Test Vendor Instructions from Test Class','Test Venue attribut1','Delivery Area',system.today().addDays(10),system.today().addDays(5),system.today().addDays(11));
        LC_VOTRelatedListController.existingValues(vot.Id);  
        //LC_VOTRelatedListController.getOrderID(vot.Id);
        LC_VOTRelatedListController.vendorsAssigned(vot.Id);
        LC_VOTRelatedListController.getClonedVOT();
        LC_VOTRelatedListController.InsertVOT(vot.Id,true,order.Id,'Test Service attribut1','Test Service attribut1','Test Service attribut1','Test Service attribut1','Test Service attribut1',vendorName,vendorName,vendorName,vendorName,vendorName,'Test Vendor Instructions from Test Class','Test Venue attribut1','Delivery Area',system.today().addDays(10),system.today().addDays(5),system.today().addDays(11));
        LC_VOTRelatedListController.InsertVOT(vot.Id,false,order.Id,'Test Service attribut1','Test Service attribut1','Test Service attribut1','Test Service attribut1','Test Service attribut1',vendorName,vendorName,vendorName,vendorName,vendorName,'Test Vendor Instructions from Test Class','Test Venue attribut1','Delivery Area',system.today().addDays(10),system.today().addDays(5),system.today().addDays(11));
        LC_VOTRelatedListController.submitRecord(vot.Id);
        LC_VOTRelatedListController.deleteVOTRecords(vot.Id);
        LC_VOTRelatedListController.isCommunity();
        system.debug('vot---'+vot);
        LC_VOTRelatedListController.getVotBannerData(vot.Id);
        LC_VOTRelatedListController.getCurrentUserProfile();
        Test.stopTest();
    }
}