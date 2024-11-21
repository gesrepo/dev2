@isTest
public class LC_OrderFilterViewTest {
    @testsetup
    public static void testSetup(){
       // Opportunity opp=LC_TestUtils.insertOpportunity();
        GC_Connect2_Show__c show = LC_TestUtils.insertShow('','test oppo');
        GC_Order__c order = LC_TestUtils.insertOrder(show.Id);
        GC_Show_Attribute__c deptat = LC_TestUtils.insertDeptAttributes(show.Id);
        GC_Show_Attribute__c venueat = LC_TestUtils.insertVenueAttributes(show.Id);
        LC_TestUtils.insertGOT(order.Id,venueat.Id,deptat.Id);
        LC_TestUtils.insertVOT(order.Id,null);
        Account acc = new Account(
            Name = 'New Show Account',
            Phone = '212-460-5555',
            Fax = '212-888-5555',
            BillingStreet = '1201 S gter St.' ,
            BillingCity = '42' ,
            BillingState = 'CA',
            BillingPostalCode = '90015-4343',
            NumberOfEmployees = 535,
            AnnualRevenue = 53535353
        );
        insert acc;
        Opportunity insertNewOpp=new Opportunity();
        insertNewOpp.Name='New Opportunity1';
        insertNewOpp.AccountId=acc.Id;
        insertNewOpp.StageName='CV';
        insertNewOpp.CloseDate = System.Today() + 40;
        insertNewOpp.Prime_Contractor__c = acc.Id;
        insert insertNewOpp;
        GC_Connect2_Show__c show1= new GC_Connect2_Show__c();
        show1.Opportunity_Id__c=insertNewOpp.Id;
        show1.CreatedById=userinfo.getUserId();
        show1.Opportunity_Name__c=insertNewOpp.Name;
        show1.Show_Name__c = 'test show1';
        show1.Job_Number__c = '12345';
        insert show1;
        GC_Show_Attribute__c deptatToShow= LC_TestUtils.insertDeptAttributes(show1.Id);
        // GC_Show_Team_Member__c insertMemberForToShow=LC_TestUtils.insertShowTeamMember(venueatToShow.Id,show1.Id);
    }
    
    @isTest
    public static void testMethod1() {
        GC_Connect2_Show__c show=[select id from GC_Connect2_Show__c where Show_Name__c = 'test show'];
        Test.startTest();    
        GC_Connect2_Show__c ToClone = [select Id from GC_Connect2_Show__c where Show_Name__c = 'test show1'];
        string showToBeClonned= ToClone.Id;
        string cloneFromShow = show.Id;
        Date deliveryDate = date.today();
        List<GC_Order__c> ord=[select Id from GC_Order__c where Booth_Area__c='new Booth Area' limit 1];
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(ord);
        LC_OrderFilterViewApexController obj= new LC_OrderFilterViewApexController(sc);
        LC_OrderFilterViewApexController.getPicklistValues(show.Id);
        LC_OrderFilterViewApexController.fetchTableData(show.Id);
        List<string> users=new List<string>();
        List<string> users2=new List<string>();
        List<string> selectedStatusToPrint=new List<String>();
        selectedStatusToPrint.add('New');
        users.add('');
        List<string> onsitePerson=new List<string>();
        onsitePerson.add('');
        List<string> onsitePersonOther=new List<string>();
        onsitePersonOther.add('');
        List<string> onsitePersonOther2=new List<string>();
        List<string> onsitePerson2=new List<string>();
        List<string> selectedStatusToPrint2=new List<String>();
        List<String> newDeliveryLoc= new List<String>();
        newDeliveryLoc.add('');
        GC_Order__c existingOrders=[select Id from GC_Order__c where Connect2_Show__c=:show.Id AND Booth_Area__c='new Booth Area' limit 1];
        List<String> oldDeliveryLoc= new List<String>();
        oldDeliveryLoc.add(existingOrders.Id);
        Map<String, DateTime> boothAreaDeliveryMap = new Map<String, DateTime>();
        Map<String, DateTime> boothAreaCompletionMap = new Map<String, DateTime>();
        Map<String, DateTime> boothAreaRemovalMap = new Map<String, DateTime>();
        Map<String, String> boothAreaIdMap = new  Map<String, String>();
        LC_OrderFilterViewApexController.getTableValue(show.Id,'new Booth Area','new order area',users,'new',system.today().addDays(10),system.today().addDays(5),system.today().addDays(15),system.today().addDays(3),system.today().addDays(6),system.today().addDays(3),system.today().addDays(3),'Shubhashree Joshi','Test Department attribut1','new Booth Area','Test Venue attribut1',onsitePerson,onsitePersonOther,selectedStatusToPrint,true);
        LC_OrderFilterViewApexController.getTableValue(show.Id,null,null,users2,null,null,null,null,null,null,null,null,null,null,null,null,onsitePerson2,onsitePersonOther2,selectedStatusToPrint2,false);
        LC_OrderFilterViewApexController.getTableValue(show.Id,null,null,users2,null,null,null,null,system.today().addDays(3),null,null,null,null,null,null,null,onsitePerson2,onsitePersonOther2,selectedStatusToPrint2,true);
        LC_OrderFilterViewApexController.getTableValue(show.Id,null,null,users2,null,null,null,null,null,system.today().addDays(3),null,null,null,null,null,null,onsitePerson2,onsitePersonOther2,selectedStatusToPrint2,true);
        LC_OrderFilterViewApexController.getTableValue(show.Id,null,null,users2,null,null,null,null,null,null,system.today().addDays(3),null,null,null,null,null,onsitePerson2,onsitePersonOther2,selectedStatusToPrint2,true);
        LC_OrderFilterViewApexController.getTableValue(show.Id,null,null,users2,null,null,null,null,null,null,null,system.today().addDays(3),null,null,null,null,onsitePerson2,onsitePersonOther2,selectedStatusToPrint2,true);
        LC_OrderFilterViewApexController.saveFilteredValues('new Booth Area','new order area',users,onsitePerson,onsitePersonOther,'new',system.today().addDays(10),system.today().addDays(5),system.today().addDays(15),system.today().addDays(3),system.today().addDays(6),system.today().addDays(3),system.today().addDays(3),'Shubhashree Joshi','Test Department attribut1','new Booth Area','Test Venue attribut1');
        LC_OrderFilterViewApexController.saveFilteredValues('new Booth Area','new order area',users,onsitePerson,onsitePersonOther,'new',system.today().addDays(10),system.today().addDays(5),system.today().addDays(15),null,system.today().addDays(6),system.today().addDays(3),system.today().addDays(3),'Shubhashree Joshi','Test Department attribut1','new Booth Area','Test Venue attribut1');
        LC_OrderFilterViewApexController.saveFilteredValues('new Booth Area','new order area',users,onsitePerson,onsitePersonOther,'new',system.today().addDays(10),system.today().addDays(5),system.today().addDays(15),system.today().addDays(3),null,system.today().addDays(3),system.today().addDays(3),'Shubhashree Joshi','Test Department attribut1','new Booth Area','Test Venue attribut1');
        LC_OrderFilterViewApexController.saveFilteredValues('new Booth Area','new order area',users,onsitePerson,onsitePersonOther,'new',system.today().addDays(10),system.today().addDays(5),system.today().addDays(15),system.today().addDays(3),system.today().addDays(6),null,system.today().addDays(3),'Shubhashree Joshi','Test Department attribut1','new Booth Area','Test Venue attribut1');
        LC_OrderFilterViewApexController.saveFilteredValues('new Booth Area','new order area',users,onsitePerson,onsitePersonOther,'new',system.today().addDays(10),system.today().addDays(5),system.today().addDays(15),system.today().addDays(3),system.today().addDays(6),system.today().addDays(3),null,'Shubhashree Joshi','Test Department attribut1','new Booth Area','Test Venue attribut1');
        LC_OrderFilterViewApexController.saveFilteredValues('new Booth Area','new order area',users,onsitePerson,onsitePersonOther,'new',null,null,system.today().addDays(15),null,null,null,null,'Shubhashree Joshi','Test Department attribut1','new Booth Area','Test Venue attribut1');
        LC_OrderFilterViewApexController.getFilterValues();
        LC_OrderFilterViewApexController.fetchUser(show.Id);
        LC_OrderFilterViewApexController.isCommunity();
        LC_OrderFilterViewApexController.getProfileName();
        LC_OrderFilterViewApexController.getShowID(show.Id);
        LC_OrderFilterViewApexController.escapeSpecialCharacters('Venodr & demo $ 2');
        LC_OrderFilterViewApexController.cloneOrdersToShow(newDeliveryLoc,oldDeliveryLoc,showToBeClonned,cloneFromShow,boothAreaDeliveryMap,boothAreaCompletionMap,boothAreaRemovalMap,boothAreaIdMap);
        LC_OrderFilterViewApexController.getSessionId();
        LC_OrderFilterViewApexController.getNewDeliveryLocations(showToBeClonned,cloneFromShow,cloneFromShow);
        LC_OrderFilterViewApexController.getDateString(deliveryDate);
        Test.stopTest();
    }
    
}