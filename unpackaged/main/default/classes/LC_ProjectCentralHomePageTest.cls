@isTest
public class LC_ProjectCentralHomePageTest {
    @testSetup static void setup() {
        List<GC_Connect2_Show__c> testShws = new List<GC_Connect2_Show__c>();
        for(Integer i=0;i<2;i++) {
            testShws.add(new GC_Connect2_Show__c(Job_Number__c='Show'+i,Show_Start_Date__c=Date.today(),Facility__c='facility'+i,Show_End_Date__c=Date.today()+3));
        }
        insert testShws;     
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Digital Products/IT Admin'].Id,
            LastName = 'last',
            Email = 'test@test.com',
            Username = 'test@test.com'+ System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        insert u;
        GC_Show_Team_Member__c  shwTeamMemeber=new GC_Show_Team_Member__c(Tiles_Access__c='Tasks',User__c=u.Id,Connect2_Show__c=testShws[0].Id);
        insert shwTeamMemeber;
        List<GC_Order__c> orderList = new List<GC_Order__c>();
        for(Integer i=0;i<2;i++) {
            orderList.add(new GC_Order__c(Delivery_Date_Time__c=Date.today(),Completion_Date_Time__c=Date.today()+5,Connect2_Show__c=testShws[0].Id));
        }
        insert orderList;     
    }
    @isTest static void testgetShows(){
        Test.startTest();
        List<GC_Connect2_Show__c> shows=LC_ProjectCentralHomePage.getShowsApex();
        Test.stopTest();
    }
    @isTest Static Void testfogetrecords(){
        List<GC_Connect2_Show__c> showgetrecords=LC_ProjectCentralHomePage.getrecords('Show0',system.today(),false);
    }
     @isTest Static Void testfogetrecordssearch(){
        List<GC_Connect2_Show__c> showget1=LC_ProjectCentralHomePage.getrecords('Show0',null,false);
    }
     @isTest Static Void testfogetrecordsfacility(){
        List<GC_Connect2_Show__c> showgetrec=LC_ProjectCentralHomePage.getrecords('',system.today(),false);
    }
    @isTest Static Void testPastShows1(){
        List<GC_Connect2_Show__c> showgetrec=LC_ProjectCentralHomePage.getrecords(null,null,false);
    }
    @isTest Static Void testPastShows2(){
        List<GC_Connect2_Show__c> showgetrec=LC_ProjectCentralHomePage.getrecords(null,null,true);
    }
    @isTest static void testoverRidePermissions(){
        Boolean bl=LC_ProjectCentralHomePage.overRidePermissions();
    }
    @isTest static void testsaveNewSTM(){
        GC_Show_Team_Member__c STM=[select id,Tiles_Access__c from GC_Show_Team_Member__c where  Tiles_Access__c='Tasks'];
        STM.Tiles_Access__c='Orders';
        String result=LC_ProjectCentralHomePage.saveNewSTM(STM);
    }
    @isTest static void testreturnCurrentShow(){
        GC_Connect2_Show__c currentShow =LC_ProjectCentralHomePage.returnCurrentShow('Show1');
    }
    @isTest static void tescheckUsersPermission(){
        String result=LC_ProjectCentralHomePage.checkUsersPermission();
    }
    
  /*  @isTest static void testgetUserSessionID(){
        Test.startTest();
        List<String> results=LC_ProjectCentralHomePage.getUserSessionID();
        Test.stopTest();
    }*/
      @isTest static void fetchuserMethod(){
       user u=LC_ProjectCentralHomePage.fetchUser();
    }
}