@isTest
private class TrgBeforeInsertUpdateCaseTest {
    @isTest static void test_method_one() {
        
        Profile profile1 = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User testUser = new User(
            ProfileId = profile1.Id,
            Username ='DarkKnight@test.com',
            Alias = 'batman',
            Email='bruce.wayne@wayneenterprises.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Wayne',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
        );
        insert(testUser);
        
        Profile profile2 = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User adminUser = new User(
            ProfileId = profile2.Id,
            Username ='admintestuser001@test.com',
            Alias = 'adtest',
            Email='admin.user@test.com',
            EmailEncodingKey='UTF-8',
            Firstname='Admin',
            Lastname='User',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
        );
        insert(adminUser);
        PermissionSet ps = [SELECT Id 
                            FROM PermissionSet 
                            WHERE Name = 'Manage_Cases'];
        
        insert new PermissionSetAssignment(AssigneeId = adminUser.Id, PermissionSetId = ps.Id);
        
        System.runAs(adminUser){
            Account a = new Account(
                Name = 'Goguta are firma',
                Business_Type__c = 'Contractor',
                Cust_Type__c = '01 Organiser'
            );
            insert a;
            
            Account a2 = new Account(
                Name = 'Goguta are firma Test',
                Business_Type__c = 'Contractor',
                Cust_Type__c = '01 Organiser'
            );
            insert a2;
            
            Contact co = new Contact( LastName = 'Sarmala',
                                     Account = a,
                                     Phone = '07656788987665'
                                    );
            insert co;
            
            Case c = new Case(
                Account = a,
                Contact = co,
                Origin = 'Phone',
                Customer_Type__c = 'Exhibitor',
                Show_Status__c = 'Showsite (Breakdown)',
                GES_Type__c = 'Furnishings',
                Reason__c = 'Placed Order',
                Priority = 'Low Priority',
                Status = 'Open'
            );
            insert c;
            
            Contact co1 = new Contact( LastName = 'Sarmala',
                                      Account = a,
                                      Phone = '07656788987665'
                                     );
            insert co1;
            
            Opportunity op1 = new Opportunity();
            op1.Name = 'opp1';
            op1.stageName = 'oppStage';
            op1.closeDate = Date.today();
            insert op1;
            
            Show__c theShow = new Show__c();
            theShow.Sales_Person__c = testUser.id;
            theShow.Account__c = a.id;
            theShow.Name = 'TheShow';
            theShow.Show_Type__c = 'Food Sector';
            theShow.Show_ID__c = 'fasdsd';
            theShow.CurrencyIsoCode = 'USD';
            insert theShow;
            
            
            
            Oracle_Show_Booth__c bo = new Oracle_Show_Booth__c();
            bo.Name = 'boooooo';
            bo.Account__c = a.id;
            bo.Show_Occurrence__c = op1.id;
            insert bo;
            
            
            Case c2 = new Case(
                Account = a,
                Contact = co,
                Origin = 'Phone',
                Customer_Type__c = 'Exhibitor',
                Show_Status__c = 'Showsite (Breakdown)',
                GES_Type__c = 'Furnishings',
                Reason__c = 'Placed Order',
                Priority = 'Low Priority',
                Status = 'Open',
                Booth__c = bo.id,
                Show_Opportunity__c = op1.id
            );
            insert c2;
            
            c2.EMEA_Onsite_Service_Request__c = true;
            c2.Is_Mass_Close_Case__c = true;
            c2.Status = 'Closed';
            //c2.Reassign_To_Onsite_Owner__c = 'Approved';
            c2.Show_Name__c = theShow.Id;
            c2.ContactId = co1.Id;
            c2.AccountId = a2.Id;
            update c2;
        }        
    }
}