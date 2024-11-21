/**
* @author Ethos Solutions - www.ethos.com
* @description Test code for the Manage User page controller
* 2016-06-27 : Original Version
**/
@isTest

public with sharing class GC_ManageCommunityUsersControllerTest {
    public static testMethod void manageClientUserPageTest() {

        User accountManager = GC_TestUtils.createUser('GC Account Manager', 'TheManager', 'ofAccounts');
        accountManager.UserRoleId = [select Id from UserRole where Name = 'System Administrator'].Id;
        update accountManager;

        System.runAs(accountManager) {

            Test.startTest();

            DateTime testStartTime = DateTime.now();

            Account account = GC_TestUtils.getAccount();
            Contact contact = GC_TestUtils.getContact('firstname', 'lastname', account);
            Profile profile1 = [Select Id, Name From Profile Where Name = 'GC Community Client'];
            List<User> clientUsers = new List<User>();

            GC_ManageCommunityUsersController con = new GC_ManageCommunityUsersController();

            con.addUser();
            con.selectedUserOption = 'Client';

            clientUsers = con.clientUsers;
            Integer clientsSize = clientUsers.size();

            User tempUser = new User (
                ContactId = contact.Id,
                FirstName = 'Test',
                LastName = 'June',
                Email = 'TJune@xyz.com',
                UserName = 'TJune@xyz.com'
            );

            con.tempUser = tempUser;

            con.saveUser();

            System.assertEquals(false, con.displayPopup);

            clientUsers = con.clientUsers;

            System.assertEquals(clientsSize + 1, clientUsers.size());

            GC_PageUtil.setParam('userId', [select Id from User where Email = 'TJune@xyz.com'].Id);
            con.updateClientRecord();
            con.reloadUsers();

            List<User> updatedUsers = con.clientUsers;

            List<User> updatedUsers1 = [Select Id, IsActive, ProfileId From User Where Profile.Name = :con.clientProfile and IsActive = false and CreatedDate >= :testStartTime];

            System.assertEquals(1, updatedUsers1.size());

            GC_PageUtil.setParam('userId', [select Id from User where Email = 'TJune@xyz.com'].Id);
            con.updateClientRecord();
            con.reloadUsers();

            updatedUsers = con.clientUsers;

            updatedUsers1 = [Select Id, IsActive, ProfileId From User Where Profile.Name = :con.clientProfile and IsActive = true and CreatedDate >= :testStartTime];

            System.assertEquals(1, updatedUsers1.size());

            con.closePopup();

            Test.stopTest();
        }
    }

    public static testMethod void manageVendorUserPageTest() {

        User accountManager = GC_TestUtils.createUser('GC Account Manager', 'TheManager', 'ofAccounts');
        accountManager.UserRoleId = [select Id from UserRole where Name = 'System Administrator'].Id;
        update accountManager;

        System.runAs(accountManager) {

            Test.startTest();

            DateTime testStartTime = DateTime.now();

            Account account1 = GC_TestUtils.getAccount();
            Contact contact1 = GC_TestUtils.getContact('firstname', 'lastname', account1);
            Profile profile2 = [Select Id, Name From Profile Where Name = 'GC Community Vendor'];
            List<User> vendorUsers = new List<User>();

            GC_ManageCommunityUsersController con = new GC_ManageCommunityUsersController();

            vendorUsers = con.vendorUsers;
            Integer vendorsSize = vendorUsers.size();

            con.addUser();
            con.selectedUserOption = 'Vendor';

            User tempUser1 = new User (
                ContactId = contact1.Id,
                FirstName = 'Test1',
                LastName = 'June1',
                Email = 'TJune1@xyz.com',
                UserName = 'TJune1@xyz.com'
            );

            con.tempUser = tempUser1;

            con.saveUser();

            System.assertEquals(false, con.displayPopup);

            vendorUsers = con.vendorUsers;

            System.assertEquals(vendorsSize + 1, vendorUsers.size());

            // test deactivate
            GC_PageUtil.setParam('userId', [select Id from User where Email = 'TJune1@xyz.com'].Id);
            con.updateVendorRecord();
            con.reloadUsers();

            List<User> updatedUsers = con.vendorUsers;

            List<User> updatedUsers1 = [Select Id, IsActive, ProfileId From User Where Profile.Name = :con.vendorProfile and IsActive = false and CreatedDate >= :testStartTime];

            System.assertEquals(1, updatedUsers1.size());

            GC_PageUtil.setParam('userId', [select Id from User where Email = 'TJune1@xyz.com'].Id);
            con.updateVendorRecord();
            con.reloadUsers();

            updatedUsers = con.vendorUsers;

            updatedUsers1 = [Select Id, IsActive, ProfileId From User Where Profile.Name = :con.vendorProfile and IsActive = true and CreatedDate >= :testStartTime];

            System.assertEquals(1, updatedUsers1.size());

            tempUser1 = new User (
                ContactId = contact1.Id,
                FirstName = 'Test1',
                LastName = 'June1',
                Email = 'TJune1@xyz.com',
                UserName = 'TJune1@xyz.com'
            );
            con.tempUser = tempUser1;
            con.tempUserContactChanged();
            con.tempUser = tempUser1;
            con.selectedUserOption = 'Vendor';
            con.saveUser(); // we should get an error here.
            vendorUsers = con.vendorUsers;
            System.assert(con.displayPopup, true);
            System.assertEquals(vendorsSize + 1, vendorUsers.size());

            con.closePopup();

            Test.stopTest();
        }
    }
}