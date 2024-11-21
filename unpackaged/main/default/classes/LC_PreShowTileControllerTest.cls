@isTest
public class LC_PreShowTileControllerTest {
    @testSetup static void setup(){
        
List<GC_Connect2_Show__c> testShws = new List<GC_Connect2_Show__c>();
        for(Integer i=0;i<2;i++) {
            testShws.add(new GC_Connect2_Show__c(Job_Number__c='Show'+i,Show_Start_Date__c=Date.today(),Show_End_Date__c=Date.today()+3,SharePoint_Link__c='https://www.example.com',Sponsorship_Link__c='https://www.test.com'));
        }
        insert testShws;  
        
        AS_Tile__c tile=new AS_Tile__c(Name='Tasks',Order_of_Display__c=1,UniqueId_Number__c=2);
        insert tile;
        
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Digital Products/IT Admin'].Id,
            LastName = 'last',
            Email = 'test@test.com',
            Username = 'test@test.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        insert u;
        GC_Show_Team_Member__c STM= new GC_Show_Team_Member__c(Tiles_Access__c='Tasks',User__c=u.Id,Connect2_Show__c=testShws[0].Id,Pre_show_Tile_Access__c='OrdersPreshow');
        insert STM;
    }
    @isTest static void testmethod1(){
         test.startTest();
        List<AS_Tile__c> allowedTiles=  LC_PreShowTileController.getTilesForShowTeamMember('Show0');
         test.stopTest();
        
    }
    @isTest static void testmethod2(){
        User u=[select id from user where LastName = 'last' Limit 1];
        System.runAs(u) {
            test.startTest();
            List<AS_Tile__c> allowedTiles=  LC_PreShowTileController.getTilesForShowTeamMember('Show0');
            test.stopTest();
        }
    }

}