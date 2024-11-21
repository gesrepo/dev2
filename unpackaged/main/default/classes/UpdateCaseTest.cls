@isTest
public class UpdateCaseTest {
    private static testMethod void checkFunctionality(){
        Account a  = new Account();
        a.Name = 'test Acc';
        insert a;
        
        Contact cont = new Contact();
		cont.FirstName = 'xyzFirst';
		cont.LastName = 'XyZLast';
		cont.AccountId = a.Id;
		cont.Email = 'xyzmail@mail.com';
        insert cont;
        
        User u = new user();
        u.LastName = 'Test Code';
        u.Email = 'test@test.com';
        u.Alias = 'Tcode';
        u.Username = 'test231411234444@tasd1511a131est.com';
        u.CommunityNickname = 'test12';
        u.LocaleSidKey = 'en_US';
        u.TimeZoneSidKey = 'GMT';
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        u.ProfileID = profileId.Id;
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        insert u;
        
        Case c = new Case();
        c.AccountId = a.id;
        c.ContactId = cont.Id;
        c.Customer_Type__c = 'Exhibitor';
        c.Show_Status__c = 'Showsite (Build)';
        c.Type = 'Audio-Visual';
        c.Reason__c = 'New Order';
        c.Priority = 'Low Priority';
        c.Status = 'Open';
        c.EMEA_Onsite_Service_Request__c = true;
        insert c;
        
        ApexPages.currentPage().getParameters().put('id', c.id);
		ApexPages.StandardController stdCtrl = new ApexPages.StandardController(c);
	    UpdateCase controller  = new UpdateCase(stdCtrl);
        
        PageReference newPage = controller.SaveCase();
        system.assertEquals('/'+c.Id, newPage.getUrl());
        
        c.Delegated_Owner__c = u.Id;
        c.Reassign_to_Onsite_Owner__c = 'Yes';
        
        newPage = controller.SaveCase();
        system.assertEquals(null, newPage);
    }
    
}