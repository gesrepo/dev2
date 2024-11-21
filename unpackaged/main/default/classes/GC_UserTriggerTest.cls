@isTest
public class GC_UserTriggerTest
{
    @isTest
    static void test()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'GC Director of Account Management']; 
        User u = new User(Alias = 'standt', Email='GC_UserTrigger@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='GC_UserTrigger@testorg.com');
        insert u;
        
        p = [SELECT Id FROM Profile WHERE Name = 'System Administrator']; 
        u.ProfileId = p.Id;
        update u;
        
        p = [SELECT Id FROM Profile WHERE Name = 'GC Director of Account Management']; 
        u.ProfileId = p.Id;
        update u;
        
        p = [SELECT Id FROM Profile WHERE Name = 'GC Account Manager']; 
        u.ProfileId = p.Id;
        update u;
    }
    
    @isTest
    static void updateCallCenterTest()
    {
        List<UserRole> listUR = new List<UserRole>();
        UserRole ur1 = new UserRole(DeveloperName = 'GESNSCInboundRep', Name = 'GES NSC Inbound Rep');
        listUR.add(ur1);
        UserRole ur2 = new UserRole(DeveloperName = 'GESExhibitorServicesWestRep', Name = 'GES Exhibitor Services West Rep');
        listUR.add(ur2);
        insert listUR;
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'GC Director of Account Management']; 
        User u = new User(Alias = 'standt2', Email='GC_UserTrigger@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='GC_UserTrigger@testorg2.com',
                         UserRoleId = ur1.Id);
        insert u;
        
        User u2 = [SELECT Id, CallCenterId FROM User WHERE UserName = 'GC_UserTrigger@testorg2.com' limit 1]; 
        u2.UserRoleId = ur2.Id;
        update u2;
        
    }
}