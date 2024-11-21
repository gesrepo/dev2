@isTest
public class LC_CreateSTMFromContactTest {
    @testSetup static void setup(){
        Opportunity opp=new Opportunity(Name='Test',CloseDate=Date.today(),StageName='Open / Pending');
        insert opp;
        List<GC_Connect2_Show__c> testShws = new List<GC_Connect2_Show__c>();
        for(Integer i=0;i<2;i++) {
            testShws.add(new GC_Connect2_Show__c(Job_Number__c='Show'+i,Show_Start_Date__c=Date.today(),Show_End_Date__c=Date.today()+3,Opportunity_Id__c=opp.ID,SharePoint_Link__c='https://www.example.com',Sponsorship_Link__c='https://www.test.com'));
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
        
        GC_Show_Team_Member__c STM= new GC_Show_Team_Member__c(Tiles_Access__c='Tasks',User__c=u.Id,Connect2_Show__c=testShws[0].Id);
        insert STM;
        
        Account acc=new Account(Name='TestAcc');
        insert acc;
        Contact cnt=new Contact(LastName='LastName',FirstName='FirstName',salutation='Mr',AccountId=acc.Id,email='test@test.com',phone='321324234');
        insert cnt;
    }
    
    @isTest static void testgetTilesForShowTeamMember1(){
        List<AS_Tile__c> allowedTiles=  LC_CreateSTMFromContact.getTilesForShowTeamMember('Show0');
        string sponLink=  LC_CreateSTMFromContact.getShowLinks('Show0', 'Sponsorship');
    }
    
    @isTest static void testgetTilesForShowTeamMember2(){
        
        User u=[select id from user where LastName = 'last' Limit 1];
        System.runAs(u) {
            List<AS_Tile__c> allowedTiles=  LC_CreateSTMFromContact.getTilesForShowTeamMember('Show0');
            string shareLink=  LC_CreateSTMFromContact.getShowLinks('Show1', 'SharePoint');
        }
    }
    @isTest static void testinitializeContact1(){
        contact cnt=LC_CreateSTMFromContact.initializeContact('');
    }
    @isTest static void testinitializeContact2(){
        Opportunity opp=new Opportunity(Name='Test',CloseDate=Date.today(),StageName='Open / Pending');
        insert opp;
        GC_Connect2_Show__c shw= new GC_Connect2_Show__c(Opportunity_Id__c=opp.ID);
        insert shw;
        contact cnt=LC_CreateSTMFromContact.initializeContact(shw.Id);
    }
    @isTest static void testsaveNewContact(){
        Contact cnt=[select LastName,FirstName,salutation,AccountId,email,phone from contact where email='test@test.com' ];
        GC_Connect2_Show__c shw=[select id from GC_Connect2_Show__c Limit 1];       
        List<String> tiles=New List<String>{'Tasks'};
            User u=[select id from user where LastName = 'last' Limit 1];
            String result=LC_CreateSTMFromContact.saveNewContact(cnt,tiles,'Show Organizer',shw.Id);
            System.debug('resultttttttt'+result);
        }
}