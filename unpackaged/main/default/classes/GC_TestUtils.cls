/**
* @author Ethos Solutions - www.ethos.com
* @description Utility class for test classes
* 2016-04-13 : Original Version
**/
@isTest
public without sharing class GC_TestUtils {
    
    public static Opportunity getTestOpportunity() {
        RecordType facilityRT = [Select Id, SobjectType, Name From RecordType WHERE Name = 'Facility' and SobjectType = 'Account' limit 1];
        RecordType contractorRT = [Select Id, SobjectType, Name From RecordType WHERE Name = 'Contractor' and SobjectType = 'Account' limit 1];
        RecordType masterShowRT = [Select Id, SobjectType, Name From RecordType WHERE Name = 'Master Show Occurrence' and SobjectType = 'Opportunity' limit 1];
        Account acc = new Account(
            Name = 'Auto Show',
            Phone = '212-460-6659',
            Fax = '212-888-6523',
            BillingStreet = '1201 S Figueroa St.' ,
            BillingCity = 'Los Angeles' ,
            BillingState = 'CA',
            BillingPostalCode = '90015-1308',
            NumberOfEmployees = 500,
            AnnualRevenue = 60000000);
        Account facility = new Account(
            Name = 'Las Vegas Convention Center',
            Phone = '(702) 892-0711',
            Fax = '555-555-5555',
            BillingStreet = '43150 Paradise Rd.',
            BillingCity = 'Las Vegas',
            BillingState = 'NV' ,
            BillingPostalCode = '89109',
            NumberOfEmployees = 200,
            LMS_Facility_ID__c = '123456',
            AnnualRevenue = 20000000,
            RecordTypeId = facilityRT.Id);
        List<Account> accList = new List<Account>();
        accList.add(acc);
        accList.add(facility);
        insert acclist;
        Opportunity opp = new Opportunity(
            Name = 'LA Auto Show',
            AccountId = acc.Id,
            Facility__c = facility.Id,
            CloseDate = System.Today() + 40,
            StageName = 'CV',
            Amount = 30000,
            Show_Start_Date_Time__c = System.Today() + 12,
            Show_End_Date_Time__c = System.Today() + 17,
            Exhibit_Hall_Hours_Day_1__c = '5:00 PM To 8:00 PM',
            Exhibit_Hall_Hours_Day_2__c = '7:00 AM To 6:30 PM',
            Exhibit_Hall_Hours_Day_3__c = '8:00 AM To 4:00 PM',
            Exhibit_Hall_Hours_Day_4__c = '9:00 AM To 10:00 PM',
            Exhibit_Hall_Hours_Day_5__c = '9:00 AM To 10:00 PM',
            Exhibitor_Move_In_Date__c = System.Today() + 11,
            RecordTypeId = masterShowRT.Id,
            Prime_Contractor__c = acc.Id,
            Move_Out__c = System.Today() + 14);
        insert opp;
        return opp;
    }
    //
    public static String getMasterShowRTID() {
        RecordType masterShowRT = [Select Id, SobjectType, Name From RecordType WHERE Name = 'Master Show Occurrence' and SobjectType = 'Opportunity' limit 1];
        return masterShowRT.id;
    }
    
    public static Discount__c getTestDiscount(){
        
        Booth_Area__c ba = new Booth_Area__c();  
        ba.Name = 'Test Booth';
        ba.Connect2_Show__c='a3r40000000bqdj';
        insert ba; 
        
        system.debug('Disc ID---------' + ba.Id);
        
        Discount__c discount = new Discount__c(
            Apply_To_All__c = true,
            Discount__c  = '10',
            BoothAreaID__c = '123456',
            Booth_Area__c = ba.Id);
        return discount;
    }
    
    public static Opportunity getTestOpportunity(String oppName) {
        Opportunity opp = new Opportunity(
            Name = oppName,
            CloseDate = System.Today() + 40,
            StageName = 'CV',
            Amount = 30000,
            Show_Start_Date_Time__c = System.Today() + 12,
            Show_End_Date_Time__c = System.Today() + 17,
            Exhibit_Hall_Hours_Day_1__c = '5:00 PM To 8:00 PM',
            Exhibit_Hall_Hours_Day_2__c = '7:00 AM To 6:30 PM',
            Exhibit_Hall_Hours_Day_3__c = '8:00 AM To 4:00 PM',
            Exhibit_Hall_Hours_Day_4__c = '9:00 AM To 10:00 PM',
            Exhibit_Hall_Hours_Day_5__c = '9:00 AM To 10:00 PM',
            Exhibitor_Move_In_Date__c = System.Today() + 11,
            Move_Out__c = System.Today() + 14);
        return opp;
    }
    
    public static Account getTestFacility() {
        RecordType facilityRT = [Select Id, SobjectType, Name From RecordType WHERE Name = 'Facility' and SobjectType = 'Account' limit 1];
        Account facility = new Account(
            Name = 'Las Vegas Convention Center',
            Phone = '(702) 892-0711',
            Fax = '555-555-5555',
            BillingStreet = '43150 Paradise Rd.',
            BillingCity = 'Las Vegas',
            BillingState = 'NV' ,
            BillingPostalCode = '89109',
            NumberOfEmployees = 200,
            AnnualRevenue = 20000000,
            RecordTypeId = facilityRT.Id);
        return facility;
    }
    
    public static GC_Connect2_Show__c getTestConnect2Show() {
        //Opportunity opp = getTestOpportunity();
        GC_Connect2_Show__c newShow = new GC_Connect2_Show__c();
        newShow.Opportunity_Name__c = '01453-201601-';
        newShow.Opportunity_Id__c = '006f000000F6EbtAAF';
        newShow.Show_Name__c = 'test show';
        newShow.Job_Number__c = '12345';
        newShow.Show_Start_Date__c = Date.today();
        newShow.Show_End_Date__c = Date.today();
        newShow.Exhibit_Hall_Hours_Day_1__c = '5:00 PM To 8:00 PM';
        newShow.Exhibit_Hall_Hours_Day_2__c = '7:00 AM To 6:30 PM';
        newShow.Exhibit_Hall_Hours_Day_3__c = '8:00 AM To 4:00 PM';
        newShow.Exhibit_Hall_Hours_Day_4__c = '9:00 AM To 10:00 PM';
        newShow.Exhibit_Hall_Hours_Day_5__c = '9:00 AM To 10:00 PM';
        insert newShow;
        return newShow;
    }
    
    public static GC_Connect2_Show__c getTestConnect2Show1() {
        //Opportunity opp = getTestOpportunity();
        GC_Connect2_Show__c newShow = new GC_Connect2_Show__c();
        newShow.Opportunity_Name__c = '01453-201601-';
        newShow.Opportunity_Id__c = '006f000000F6EbtAAF';
        newShow.Show_Name__c = 'test show';
        newShow.Job_Number__c = '12345';
        newShow.Show_Start_Date__c = Date.today();
        newShow.Show_End_Date__c = Date.today()+30;
        newShow.Exhibit_Hall_Hours_Day_1__c = '5:00 PM To 8:00 PM';
        newShow.Exhibit_Hall_Hours_Day_2__c = '7:00 AM To 6:30 PM';
        newShow.Exhibit_Hall_Hours_Day_3__c = '8:00 AM To 4:00 PM';
        newShow.Exhibit_Hall_Hours_Day_4__c = '9:00 AM To 10:00 PM';
        newShow.Exhibit_Hall_Hours_Day_5__c = '9:00 AM To 10:00 PM';
        insert newShow;
        return newShow;
    }
    
    public static GC_Design_Request_Form__c getTestDRF(Id showId) {
        
        RecordType rfpRT = [Select Id, SobjectType, Name From RecordType WHERE Name = 'RFP (Exhibition or Event)' and SobjectType = 'GC_Design_Request_Form__c' limit 1];
        GC_Design_Request_Form__c drf = new GC_Design_Request_Form__c();
        drf.Connect2_Show__c = showId;
        drf.RecordType  = rfpRT;
        drf.Facility__c='testFacility';
        drf.Status__c = 'New';
        insert drf;
        return drf;
    }
    
    public static GC_Design_Request_Form__c getTestDRF1(Id showId) {
        RecordType seRT = [Select Id, SobjectType, Name From RecordType WHERE Name = 'Sold Event' and SobjectType = 'GC_Design_Request_Form__c' limit 1];
        GC_Design_Request_Form__c drf = new GC_Design_Request_Form__c();
        drf.Connect2_Show__c = showId;
        drf.RecordType = seRT;
        drf.Status__c = 'New';
        insert drf;
        GC_Design_Request_Form__c updatedDRF = [Select Id, Name, RecordType_Name__c from GC_Design_Request_Form__c where Id =: drf.Id];
        return updatedDRF;
    }
    
    public static GC_Design_Element__c getTestDesignElement(Id showId) {
        Account acc = getAccount(2);
        GC_Design_Element__c de = new GC_Design_Element__c();
        //de.Design_Request_Form__c = drfId;
        de.Client__c = acc.Id;
        de.Requester__c = UserInfo.getUserId();
        de.Task_Type__c = 'Design';
        de.Design_Element__c = 'Entrance';
        de.Task_Description__c = 'Test Design Element';
        de.Deliverable__c = 'Graphics';
        de.Status__c = 'New';
        de.Revision__c = 1;
        de.LOC1__c = '1234';
        de.LOC2__c = '5678';
        de.LOC3__c = '9100';
        de.Connect2_Show__c = showId;
        insert de;
        return de;
    }
    
    public static GC_Order__c getTestOrder() {
        
        GC_Connect2_Show__c show =  GC_TestUtils.getTestConnect2Show();
        
        GC_Order__c order = new GC_Order__c();
        order.Connect2_Show__c = show.Id;
        order.Booth_Area_ID__c = '1390259';
        insert order;
        
        return order;
    }
    
    public static GC_GES_Order_Task__c setupOrderAndTask() {
        Map<String, User> userMap = GC_TestUtils.getUsers();
        User user = userMap.get('AM');
        return setupOrderAndTask(user.Id);
    }
    
    public static GC_GES_Order_Task__c setupOrderAndTask(Id accountManagerId) {
        GC_Order__c order = getTestOrder();
        
        GC_Show_Team_Member__c teamMember = new GC_Show_Team_Member__c(Connect2_Show__c = order.Connect2_Show__c, Show_Role__c = 'Account Manager', User__c = accountManagerId);
        insert teamMember;
        
        return getTestOrderTask(order.Id, accountManagerId);
    }
    
    public static GC_GES_Order_Task__c getTestOrderTask(Id orderId, Id accountManagerId) {
        
        GC_GES_Order_Task__c got = new GC_GES_Order_Task__c();
        got.Order__c = orderId;
        got.Sign_Length__c = 10;
        got.Sign_Width__c = 10;
        got.Onsite_Contact_Person__c = accountManagerId;
        got.Delivery_Date_Time__c = DateTime.now();
        got.Completion_Date_Time__c = DateTime.now() + 10;
        got.Removal_Date_Time__c = DateTime.now() + 15;
        got.QuantityNum__c = 5;
        got.Carpet_Length__c = 15;
        got.Carpet_Width__c = 15;
        got.Revision__c = 1;
        got.Status__c = 'New';
        got.Item_Number__c = '12345';
        got.Item_Template__c = 'Carpet';
        insert got;
        
        return got;
    }
    
    public static GC_Vendor_Order_Task__c getTestVendorTask(Id orderId, Id vendorId) {
        GC_Vendor_Order_Task__c vot = new GC_Vendor_Order_Task__c();
        vot.Order__c = orderId;
        vot.Vendor__c = vendorId;
        vot.Vendor_Instructions__c = 'Do This';
        vot.Status__c = 'New';
        insert vot;
        return vot;
    }
    
    public static User createUser(String profileName, String firstName, String lastName) {
        List<Profile> profile = [Select Id, Name from Profile where Name = :profileName];
        User newUser = new User();
        newUser.FirstName = firstName;
        newUser.LastName = lastName;
        newUser.Email = 'test@example.com';
        newUser.Phone = '1231231234';
        newUser.LocaleSidKey = 'en_US';
        newUser.Alias = '' + firstName.left(1).toLowerCase() + firstName.left(4).toLowerCase();
        newUser.TimeZoneSidKey = 'America/Los_Angeles';
        newUser.EmailEncodingKey = 'ISO-8859-1';
        newUser.UserName = firstName + '.' + lastName + '@apexTest' + UserInfo.getUsername().substringAfter('@');
        newUser.LanguageLocaleKey = 'en_US';
        newUser.ProfileId = profile[0].Id;
        insert newUser;
        return newUser;
    }
    
    public static User createPortalUser(String profileName, String firstName, String lastName, Account acc) {
        List<Profile> profile = [Select Id, Name from Profile where Name = :profileName];
        User newUser = new User();
        newUser.FirstName = firstName;
        newUser.LastName = lastName;
        newUser.Email = 'test@example.com';
        newUser.Phone = '1231231234';
        newUser.LocaleSidKey = 'en_US';
        newUser.Alias = '' + firstName.left(1).toLowerCase() + firstName.left(4).toLowerCase();
        newUser.TimeZoneSidKey = 'America/Los_Angeles';
        newUser.EmailEncodingKey = 'ISO-8859-1';
        newUser.UserName = firstName + '.' + lastName + '@apexTest' + UserInfo.getUsername().substringAfter('@');
        newUser.LanguageLocaleKey = 'en_US';
        newUser.ProfileId = profile[0].Id;
        Contact contact = getContact(firstName, lastName, acc);
        newUser.ContactId = contact.Id;
        newUser.CommunityNickname = firstName + '.' + lastName;
        insert newUser;
        return newUser;
    }
    // Return map from Profile Name to user so it's easy to get a user for whichever profile is needed in a test
    public static Map<String, User> getUsers() {
        String orgPostfix = 'ethos.com.test';
        String orgEmail = 'test@example.com';
        // get the profiles
        List<Profile> profiles = [select Id, Name from Profile where Name like 'GC%' or Name = 'System Administrator'];
        Map<String, Profile> profileMap = new Map<String, Profile>();
        for (Profile profile : profiles) {
            profileMap.put(profile.Name, profile);
        }
        Map<String, String> usersToAdd = new Map<String, String>();
        usersToAdd.put('admin' + '@' + orgPostfix, 'Sys,Admin,System Administrator,System Administrator');
        usersToAdd.put('testAccountManager@' + orgPostfix, 'test,AccountManager,GC Account Manager,AM');
        //usersToAdd.put('testSalesManager@' + orgPostfix, 'test,SalesManager,GC Sales Manager,SM');
        usersToAdd.put('testCreativeDirector@' + orgPostfix, 'test,CreativeDirector,GC Creative Director,CD');
        usersToAdd.put('testTrafficAdministrator@' + orgPostfix, 'test,TrafficAdministrator,GC Traffic Administrator,TA');
        usersToAdd.put('testDetailer@' + orgPostfix, 'test,Detailer,GC Detailer,DET');
        usersToAdd.put('testDetailer2@' + orgPostfix, 'test,Detailer,GC Detailer,DET2');
        usersToAdd.put('testDetailer3@' + orgPostfix, 'test,Detailer,GC Detailer,DET3');
        usersToAdd.put('testDetailer4@' + orgPostfix, 'test,Detailer,GC Detailer,DET4');
        usersToAdd.put('testDetailer5@' + orgPostfix, 'test,Detailer,GC Detailer,DET5');
        usersToAdd.put('testDirectorAccountManagement@' + orgPostfix, 'test,DirectorAccountManagement,GC Director of Account Management,DAM');
        usersToAdd.put('testGraphicsProjectManager@' + orgPostfix, 'test,GraphicsProjectManager,GC Graphics Project Manager,GPM');
        Map<String, User> usersBeingAdded = new Map<String, User>();
        Set<String> userNames = new Set<String>();
        for (String userName : usersToAdd.keySet()) {
            String[] userParams = usersToAdd.get(userName).split(',');
            //system.debug('userParams ==='+userParams +'userName ==='+userName );
            User testUser = new User();
            testUser.Username = userName;
            testUser.Email = orgEmail;
            testUser.Lastname = userParams[1];
            testUser.Firstname = userParams[0];
            testUser.Alias = '' + userParams[0].left(1).toLowerCase() + userParams[1].left(4).toLowerCase();
            testUser.ProfileId = profileMap.get(userParams[2]).Id;
            testUser.TimeZoneSidKey = 'America/Los_Angeles';
            testUser.LocaleSidKey = 'en_US';
            testUser.EmailEncodingKey = 'ISO-8859-1';
            testUser.LanguageLocaleKey = 'en_US';
            // Map user profile name(e.g. GC Account Manager) to user
            usersBeingAdded.put(userParams[3], testUser);
            userNames.add(testUser.Username);
        }
        // TODO find users that match alias's and update them.
        List<User> existingUsers = [select Id, Username from User where Username in :userNames];
        Map<String, String> usernameIdMap = new Map<String, String>();
        for (User existingUser  : existingUsers) {
            usernameIdMap.put(existingUser.Username, existingUser.Id);
        }
        List<User> insertUsers = new List<User>();
        List<User> updateUsers = new List<User>();
        for (User userToUpdate : usersBeingAdded.Values()) {
            if (usernameIdMap.containsKey(userToUpdate.Username)) {
                userToUpdate.Id = usernameIdMap.get(userToUpdate.Username);
                updateUsers.add(userToUpdate);
            }
            else {
                insertUsers.add(userToUpdate);
            }
        }
        insert insertUsers;
        update updateUsers;
        return usersBeingAdded;
    }
    
    public static Map<String, User> getPortalUsers() {
        String orgPostfix = 'ethos.com.test';
        String orgEmail = 'test@example.com';
        // get the profiles
        List<Profile> profiles = [select Id, Name from Profile where Name like 'GC%' or Name = 'System Administrator'];
        Map<String, Profile> profileMap = new Map<String, Profile>();
        for (Profile profile : profiles) {
            profileMap.put(profile.Name, profile);
        }
        Map<String, String> usersToAdd = new Map<String, String>();
        usersToAdd.put('testClient@' + orgPostfix, 'test,Client,GC Community Client');
        usersToAdd.put('testVendor@' + orgPostfix, 'test,Vendor,GC Community Vendor');
        usersToAdd.put('testVendor1@' + orgPostfix, 'test,Vendor,GC Community Vendor');
        usersToAdd.put('testVendor2@' + orgPostfix, 'test,Vendor,GC Community Vendor');
        usersToAdd.put('testVendor3@' + orgPostfix, 'test,Vendor,GC Community Vendor');
        usersToAdd.put('testVendor4@' + orgPostfix, 'test,Vendor,GC Community Vendor');
        Map<String, User> usersBeingAdded = new Map<String, User>();
        Set<String> userNames = new Set<String>();
        for (String userName : usersToAdd.keySet()) {
            String[] userParams = usersToAdd.get(userName).split(',');
            User testUser = new User();
            testUser.Username = userName;
            testUser.Email = orgEmail;
            testUser.Lastname = userParams[1];
            testUser.Firstname = userParams[0];
            testUser.Alias = '' + userParams[0].left(1).toLowerCase() + userParams[1].left(4).toLowerCase();
            testUser.ProfileId = profileMap.get(userParams[2]).Id;
            testUser.TimeZoneSidKey = 'America/Los_Angeles';
            testUser.LocaleSidKey = 'en_US';
            testUser.EmailEncodingKey = 'ISO-8859-1';
            testUser.LanguageLocaleKey = 'en_US';
            testUser.ServiceType__c = 'Test Venue';
            if (userParams[2] == 'GC Community Client') {
                Account acc = getAccount();
                Contact contact = getContact('GC Community Client', 'CommunityClientUser', acc);
                testUser.ContactId = contact.Id;
                testUser.CommunityNickname = 'CommunityUser1';
            }
            else if (userParams[2] == 'GC Community Vendor') {
                Account acc = getAccount();
                Contact contact = getContact('GC Community Vendor', 'CommunityVendorUser', acc);
                testUser.ContactId = contact.Id;
                testUser.CommunityNickname = 'CommunityUser2';
            }
            // Map user profile name(e.g. GC Account Manager) to user
            usersBeingAdded.put(userParams[2], testUser);
            userNames.add(testUser.Username);
        }
        List<User> existingUsers = [select Id, Username from User where Username in :userNames];
        Map<String, String> usernameIdMap = new Map<String, String>();
        for (User existingUser  : existingUsers) {
            usernameIdMap.put(existingUser.Username, existingUser.Id);
        }
        List<User> insertUsers = new List<User>();
        List<User> updateUsers = new List<User>();
        for (User userToUpdate : usersBeingAdded.Values()) {
            if (usernameIdMap.containsKey(userToUpdate.Username)) {
                userToUpdate.Id = usernameIdMap.get(userToUpdate.Username);
                updateUsers.add(userToUpdate);
            }
            else {
                insertUsers.add(userToUpdate);
            }
        }
        insert insertUsers;
        update updateUsers;
        return usersBeingAdded;
    }
    
    public static Contact getContact(String fn, String ln, Account acc) {
        Contact c = new Contact(firstname = fn, lastname = ln, AccountId = acc.Id);
        insert c;
        return c;
    }
    
    public static Account getAccount() {
        return getAccount(1);
    }
    
    public static Account getAccount(Integer accNumber) {
        Account acc = new Account();
        if (accNumber == 1) {
            acc = new Account(
                Name = 'Auto Show2',
                Phone = '212-460-6659',
                Fax = '212-888-6523',
                ShippingStreet = '4108 W. 52nd Place',
                BillingStreet = '1201 S Figueroa St.' ,
                BillingCity = 'Los Angeles' ,
                BillingState = 'CA',
                BillingCountry = 'United States',
                BillingPostalCode = '90015-1308',
                NumberOfEmployees = 500,
                AnnualRevenue = 60000000);
        }
        else {
            acc = new Account(
                Name = 'Specifier Summit2',
                Phone = '415-900-5322',
                Fax = '115-900-5233',
                ShippingStreet = '1201 S Figueroa St.',
                BillingStreet = '4108 W. 52nd Place' ,
                BillingCity = 'Chicago' ,
                BillingState = 'IL',
                BillingCountry = 'United States',
                BillingPostalCode = '60632',
                NumberOfEmployees = 200,
                AnnualRevenue = 20000000);
        }
        insert acc;
        return acc;
    }
    
    public static Boolean simulateException = false;
    
    public static CORE_V2.ShowProject getTestShowProject() {
        if (Test.isRunningTest() && simulateException) {
            throw new NullPointerException();
        }
        CORE_V2.ShowProject testShowProject = new CORE_V2.ShowProject();
        testShowProject.BoothAreas = new CORE_V2.ArrayOfBoothArea();
        testShowProject.BoothAreas.BoothArea = new List<CORE_V2.BoothArea>();
        testShowProject.BoothAreas.BoothArea.add(new CORE_V2.BoothArea());
        testShowProject.BoothAreas.BoothArea[0].Area = 'Test Area';
        testShowProject.BoothAreas.BoothArea[0].BoothAreaId = 1390259;
        testShowProject.showOccrProjectId = 54321;
        return testShowProject;
    }
    
    public static CORE_V1.ArrayOfShowOrgProduct getTestShowProducts() {
        if (Test.isRunningTest() && simulateException) {
            throw new NullPointerException();
        }
        CORE_V1.ArrayOfShowOrgProduct showOrgProducts = new CORE_V1.ArrayOfShowOrgProduct();
        showOrgProducts.ShowOrgProduct = new List<CORE_V1.ShowOrgProduct>();
        showOrgProducts.ShowOrgProduct.add(new CORE_V1.ShowOrgProduct());
        showOrgProducts.ShowOrgProduct.add(new CORE_V1.ShowOrgProduct());
        showOrgProducts.ShowOrgProduct.add(new CORE_V1.ShowOrgProduct());
        showOrgProducts.ShowOrgProduct.add(new CORE_V1.ShowOrgProduct());
        showOrgProducts.ShowOrgProduct.add(new CORE_V1.ShowOrgProduct());
        //showOrgProducts.ShowOrgProduct[0].CategoryID = 1896;
        showOrgProducts.ShowOrgProduct[0].DiscountPercentage = 50;
        //showOrgProducts.ShowOrgProduct[0].CategoryDescription = 'Standard Furniture';
        showOrgProducts.ShowOrgProduct[0].ItemNumber = '300004';
        showOrgProducts.ShowOrgProduct[0].ItemDescription = 'Test Item Description';
        showOrgProducts.ShowOrgProduct[0].ItemOptionTemplate = 'Basic';
        showOrgProducts.ShowOrgProduct[0].UOM = 'EA';
        // showOrgProducts.ShowOrgProduct[1].CategoryID = 2000;
        showOrgProducts.ShowOrgProduct[1].DiscountPercentage = 50;
        // showOrgProducts.ShowOrgProduct[1].CategoryDescription = 'Graphics';
        showOrgProducts.ShowOrgProduct[1].ItemNumber = '200004';
        showOrgProducts.ShowOrgProduct[1].ItemDescription = 'Test Item Description';
        showOrgProducts.ShowOrgProduct[1].ItemOptionTemplate = 'Graphics';
        showOrgProducts.ShowOrgProduct[1].UOM = 'EA';
        // showOrgProducts.ShowOrgProduct[2].CategoryID = 3000;
        showOrgProducts.ShowOrgProduct[2].DiscountPercentage = 50;
        //showOrgProducts.ShowOrgProduct[2].CategoryDescription = 'Custom Graphics';
        showOrgProducts.ShowOrgProduct[2].ItemNumber = '300004';
        showOrgProducts.ShowOrgProduct[2].ItemDescription = 'Test Item Description';
        showOrgProducts.ShowOrgProduct[2].ItemOptionTemplate = 'Custom Graphics';
        showOrgProducts.ShowOrgProduct[2].UOM = 'EA';
        // showOrgProducts.ShowOrgProduct[3].CategoryID = 4000;
        showOrgProducts.ShowOrgProduct[3].DiscountPercentage = 50;
        //showOrgProducts.ShowOrgProduct[3].CategoryDescription = 'Carpet';
        showOrgProducts.ShowOrgProduct[3].ItemNumber = '400004';
        showOrgProducts.ShowOrgProduct[3].ItemDescription = 'Test Item Description';
        showOrgProducts.ShowOrgProduct[3].ItemOptionTemplate = 'Carpet';
        showOrgProducts.ShowOrgProduct[3].UOM = 'EA';
        //showOrgProducts.ShowOrgProduct[4].CategoryID = 5000;
        showOrgProducts.ShowOrgProduct[4].DiscountPercentage = 50;
        //showOrgProducts.ShowOrgProduct[4].CategoryDescription = 'Custom Carpet';
        showOrgProducts.ShowOrgProduct[4].ItemNumber = '500004';
        showOrgProducts.ShowOrgProduct[4].ItemDescription = 'Test Item Description';
        showOrgProducts.ShowOrgProduct[4].ItemOptionTemplate = 'Custom Carpet';
        showOrgProducts.ShowOrgProduct[4].UOM = 'SF';
        //showOrgProducts.ShowOrgProduct[4].CategoryID = 2172;
        showOrgProducts.ShowOrgProduct[4].DiscountPercentage = 50;
        //showOrgProducts.ShowOrgProduct[4].CategoryDescription = 'STANDARD FURNITURE';
        showOrgProducts.ShowOrgProduct[4].ItemNumber = '300015';
        showOrgProducts.ShowOrgProduct[4].ItemDescription = 'Test Item Description';
        showOrgProducts.ShowOrgProduct[4].ItemOptionTemplate = 'Custom Carpet';
        showOrgProducts.ShowOrgProduct[4].UOM = 'SF';
        return showOrgProducts;
    }
    
    public static CORE_V1.ArrayOfShowOrgParentCategory getTestShowParentProducts() {
        if (Test.isRunningTest() && simulateException) {
            throw new NullPointerException();
        }
        CORE_V1.ArrayOfShowOrgParentCategory showOrgParenProducts = new CORE_V1.ArrayOfShowOrgParentCategory();
        showOrgParenProducts.ShowOrgParentCategory  = new List<CORE_V1.ShowOrgParentCategory>();
        
        CORE_V1.ShowOrgParentCategory newParentCat= new CORE_V1.ShowOrgParentCategory();
        newParentCat.Name ='testParentCategory';
        newParentCat.ChildCategories =new CORE_V1.ArrayOfShowOrgChildCategory();
        newParentCat.ChildCategories.ShowOrgChildCategory = new List<CORE_V1.ShowOrgChildCategory>();
        
        CORE_V1.ShowOrgChildCategory newChild = new CORE_V1.ShowOrgChildCategory ();
        newChild.name='testChildCategory1';
        newChild.Products= new CORE_V1.ArrayOfShowOrgProduct();
        newChild.Products.ShowOrgProduct= new List<CORE_V1.ShowOrgProduct>();
        
        CORE_V1.ShowOrgProduct newProduct = new CORE_V1.ShowOrgProduct();
        newProduct.DiscountPercentage=12;
        newProduct.ImageUrl ='Test Url';
        newProduct.InventoryItemId = 1;
        newProduct.ItemDescription ='Test Desc';
        newProduct.ItemNumber ='400004';
        newProduct.ItemOptionTemplate ='Carpet';
        newProduct.Price = 12;
        newProduct.PublishFlag = True;
        newProduct.TaxRate =12.0;
        
        newChild.Products.ShowOrgProduct.add(newProduct);
        
        newParentCat.ChildCategories.ShowOrgChildCategory.add(newChild);
        showOrgParenProducts.ShowOrgParentCategory.add(newParentCat);
        return showOrgParenProducts;
    }
    
    public static CORE_V4.ArrayOfShowOrgParentCategory getTestShowParentProducts2() {
        if (Test.isRunningTest() && simulateException) {
            throw new NullPointerException();
        }
        CORE_V4.ArrayOfShowOrgParentCategory showOrgParenProducts = new CORE_V4.ArrayOfShowOrgParentCategory();
        showOrgParenProducts.ShowOrgParentCategory  = new List<CORE_V4.ShowOrgParentCategory>();
        
        CORE_V4.ShowOrgParentCategory newParentCat= new CORE_V4.ShowOrgParentCategory();
        newParentCat.Name ='testParentCategory';
        newParentCat.ChildCategories =new CORE_V4.ArrayOfShowOrgChildCategory();
        newParentCat.ChildCategories.ShowOrgChildCategory = new List<CORE_V4.ShowOrgChildCategory>();
        
        CORE_V4.ShowOrgChildCategory newChild = new CORE_V4.ShowOrgChildCategory ();
        newChild.name='testChildCategory1';
        newChild.Products= new CORE_V4.ArrayOfShowOrgProduct();
        newChild.Products.ShowOrgProduct= new List<CORE_V4.ShowOrgProduct>();
        
        CORE_V4.ShowOrgProduct newProduct = new CORE_V4.ShowOrgProduct();
        newProduct.DiscountPercentage=12;
        newProduct.ImageUrl ='Test Url';
        newProduct.InventoryItemId = 1;
        newProduct.ItemDescription ='Test Desc';
        newProduct.ItemNumber ='400004';
        newProduct.ItemOptionTemplate ='Carpet';
        newProduct.Price = 12;
        newProduct.PublishFlag = True;
        newProduct.TaxRate =12.0;
        
        newChild.Products.ShowOrgProduct.add(newProduct);
        
        newParentCat.ChildCategories.ShowOrgChildCategory.add(newChild);
        showOrgParenProducts.ShowOrgParentCategory.add(newParentCat);
        return showOrgParenProducts;
    }
    
    public static CORE_V1.ArrayOfShowOrgChildCategory  getTestShowChildProducts() {
        if (Test.isRunningTest() && simulateException) {
            throw new NullPointerException();
        }
        CORE_V1.ArrayOfShowOrgChildCategory showOrgChildProducts = new CORE_V1.ArrayOfShowOrgChildCategory();
        showOrgChildProducts.ShowOrgChildCategory  = new List<CORE_V1.ShowOrgChildCategory>();
        showOrgChildProducts.ShowOrgChildCategory .add(new CORE_V1.ShowOrgChildCategory());
        showOrgChildProducts.ShowOrgChildCategory .add(new CORE_V1.ShowOrgChildCategory());
        showOrgChildProducts.ShowOrgChildCategory .add(new CORE_V1.ShowOrgChildCategory());
        showOrgChildProducts.ShowOrgChildCategory .add(new CORE_V1.ShowOrgChildCategory());
        showOrgChildProducts.ShowOrgChildCategory .add(new CORE_V1.ShowOrgChildCategory());
        
        showOrgChildProducts.ShowOrgChildCategory[0].Name ='test';
        
        return showOrgChildProducts;
    }
    
    public static CORE_V1.ArrayOfShowOrgSpecialProduct getTestShowOrgSpecialProducts() {
        if (Test.isRunningTest() && simulateException) {
            throw new NullPointerException();
        }
        CORE_V1.ArrayOfShowOrgSpecialProduct showOrgSpecialProducts = new CORE_V1.ArrayOfShowOrgSpecialProduct();
        showOrgSpecialProducts.ShowOrgSpecialProduct  = new List<CORE_V1.ShowOrgSpecialProduct>();
        showOrgSpecialProducts.ShowOrgSpecialProduct .add(new CORE_V1.ShowOrgSpecialProduct());
        showOrgSpecialProducts.ShowOrgSpecialProduct .add(new CORE_V1.ShowOrgSpecialProduct());
        showOrgSpecialProducts.ShowOrgSpecialProduct .add(new CORE_V1.ShowOrgSpecialProduct());
        showOrgSpecialProducts.ShowOrgSpecialProduct .add(new CORE_V1.ShowOrgSpecialProduct());
        showOrgSpecialProducts.ShowOrgSpecialProduct .add(new CORE_V1.ShowOrgSpecialProduct());
        
        
        showOrgSpecialProducts.ShowOrgSpecialProduct[0].CategoryDescription ='test';
        showOrgSpecialProducts.ShowOrgSpecialProduct[0].CategoryID =12;
        showOrgSpecialProducts.ShowOrgSpecialProduct[0].InventoryItemId =12;
        showOrgSpecialProducts.ShowOrgSpecialProduct[0].ItemDescription ='test';
        showOrgSpecialProducts.ShowOrgSpecialProduct[0].ItemNumber ='12';
        showOrgSpecialProducts.ShowOrgSpecialProduct[0].ItemType ='12';
        showOrgSpecialProducts.ShowOrgSpecialProduct[0].Price = 12.0;
        showOrgSpecialProducts.ShowOrgSpecialProduct[0].PublishFlag = True; 
        showOrgSpecialProducts.ShowOrgSpecialProduct[0].ShowOrgSpecialProductId = 12;
        showOrgSpecialProducts.ShowOrgSpecialProduct[0].UOM = 'test';
        showOrgSpecialProducts.ShowOrgSpecialProduct[0].VertexSegment1 = 'test';
        showOrgSpecialProducts.ShowOrgSpecialProduct[0].VertexSegment2 = 'test1';
        
        return showOrgSpecialProducts;
    }
    public static GC_Core_Session__c createTestSession() {
        if (Test.isRunningTest() && simulateException) {
            throw new NullPointerException();
        }
        GC_Core_Session__c session = new GC_Core_Session__c();
        session.Core_Application_Session_ID__c = '7abacb3c-36f1-4963-a5e4-7e891ad26e43';
        session.Core_Application_Login_Expiration__c = DateTime.now().addDays(1);
        insert session;
        return session;
    }
    
    public static wwwViadComDataV3_v1.ShowOrgOrderEntryStatus getSubmitShowOrgOrderResponse(wwwViadComV3_v1.SubmitShowOrgOrder_element submitOrder) {
        //return null;
        
        wwwViadComDataV3_v1.ShowOrgOrderEntryStatus submitResponse= new wwwViadComDataV3_v1.ShowOrgOrderEntryStatus();
        submitResponse.LineNumber = 'Active';
        submitResponse.Success=true;
        submitResponse.EnteredDateTime= Date.Today();
        submitResponse.ErrorMessage='';
        submitResponse.OrderHeaderId=1234;
        submitResponse.OrderLineId=234;
        submitResponse.OrderNumber=456;
        submitResponse.SourceOrderCode=submitOrder.order.SourceOrderCode;
        return submitResponse;
    }
    
    public static wwwViadComDataV3_v1.ShowOrgOrderEntryStatus getCancelShowOrgOrderResponse(wwwViadComV3_v1.SubmitShowOrgOrder_element cancelOrder) {
        //return null;
        
        wwwViadComDataV3_v1.ShowOrgOrderEntryStatus submitResponse= new wwwViadComDataV3_v1.ShowOrgOrderEntryStatus();
        submitResponse.LineNumber = 'Active';
        submitResponse.Success=true;
        submitResponse.EnteredDateTime= Date.Today();
        submitResponse.ErrorMessage='';
        submitResponse.OrderHeaderId=1234;
        submitResponse.OrderLineId=234;
        submitResponse.OrderNumber=456;
        submitResponse.SourceOrderCode=cancelOrder.order.SourceOrderCode;
        return submitResponse;
    }
    
    public static wwwViadComDataV3_v1.ArrayOfShowOrgOrderEntryStatus getProcessShowOrgOrderResponse(wwwViadComV3_v1.ProcessShowOrgOrderBatch_element processOrder, Map<String, GC_GES_Order_Task__c> gesOrderTasksByName ) {
        // return null;
        
        wwwViadComDataV3_v1.ArrayOfShowOrgOrderEntryStatus status = new wwwViadComDataV3_v1.ArrayOfShowOrgOrderEntryStatus();
        status.ShowOrgOrderEntryStatus = new List<wwwViadComDataV3_v1.ShowOrgOrderEntryStatus> ();
        for(GC_GES_Order_Task__c got: gesOrderTasksByName.values()){
            wwwViadComDataV3_v1.ShowOrgOrderEntryStatus submitResponse= new wwwViadComDataV3_v1.ShowOrgOrderEntryStatus();
            submitResponse.LineNumber = 'Active';
            submitResponse.Success=true;
            submitResponse.EnteredDateTime= Date.Today();
            submitResponse.ErrorMessage='';
            submitResponse.OrderHeaderId=1234;
            submitResponse.OrderLineId=234;
            submitResponse.OrderNumber=456;
            submitResponse.SourceOrderCode=got.name;
            status.ShowOrgOrderEntryStatus.add(submitResponse);
        }
        return status;
    }
    
    public static Map<String, RecordType> getRecordType(String sObjectType) {
        List<RecordType> records = [Select Id, SobjectType, Name From RecordType WHERE SobjectType = :sObjectType];
        //System.Debug(JSON.serializePretty(records));
        Map<String, RecordType> recordTypes = new Map<String, RecordType>();
        for (RecordType record : records) {
            recordTypes.put(record.Name, record);
        }
        //System.Debug(JSON.serializePretty(recordTypes));
        
        return recordTypes;
    }
    
    /* Returs a test congress */
    public static GES_Connect_Corporate_Accounts__c getTestCongress(){
        //GC_Connect2_Show__c parentShow = GC_TestUtils.getTestConnect2Show();
        //insert parentShow;
        GES_Connect_Corporate_Accounts__c Congress= new GES_Connect_Corporate_Accounts__c();
        
        Congress.Name_of_Congress__c='Test Congress for Devs';
        Congress.Acronym_of_Congress__c = 'TCFD01';
        Congress.Exhibit_Open_Date__c = Date.Today();
        Congress.Exhibit_Close_Date__c = Date.Today()+10;
        Congress.Congress_Start_Date__c = Date.today();
        Congress.Congress_End_Date__c= Date.today()+15;
        Congress.Facility_Name__c = 'Test Facility 01';
        Congress.Shipping_City__c = 'Bengaluru';
        Congress.Shipping_Street_c__c='Nagwara';
        Congress.Shipping_Zip_Postal_Code__c = '825318';
        Congress.Housing_Logistics_Vendor__c = 'BCD Travel';
        Congress.Number_of_rooms_Secured__c = 6;
        //Congress.Show_Name__c ='Test Show'; //parentShow.id;
        Congress.CurrencyIsoCode='USD';
        Congress.Association_Contact_Name__c='SLK Soft';
        Congress.Association_Name__c='rksinha';
        Congress.Shipping_Country__c='India';
        insert Congress;
        
        return Congress;
    }
    
    /* Returs a test Exhibit */
    public static Exhibit__c getTestExhibit(){
        
        Exhibit__c exhibit= new Exhibit__c();
        GES_Connect_Corporate_Accounts__c parentCongress = GC_TestUtils.getTestCongress();
        exhibit.Activity_Type_Exhibit_Instance_c__c = parentCongress.id;
        exhibit.Booth_Length__c = 10;
        exhibit.Booth_Width__c = 10;
        exhibit.Exhibit_Name__c = 'Test Exhibit for Devs';
        exhibit.Activity_Level__c = '1';
        exhibit.CurrencyIsoCode = 'USD';       
        exhibit.GES_Congress_Manager__c='n/a';
        exhibit.Congress_Lead__c='n/a';
        exhibit.GES_Account_Manager__c='n/a';
        insert exhibit;
        
        return exhibit;
    }
    
    /* Returs a test Sponsonsorship */
    public static Sponsorship__c getTestSponsorship(){
        GES_Connect_Corporate_Accounts__c parentCongress = GC_TestUtils.getTestCongress();
        Sponsorship__c sponsorship = new Sponsorship__c();
        sponsorship.Sponsorship_Name__c = 'Test Sponsonsorship for Devs';
        sponsorship.Activity_Level__c = '1';
        sponsorship.Sponsorship__c = parentCongress.Id;     
        sponsorship.CurrencyIsoCode = 'USD';       
        sponsorship.GES_Congress_Manager__c='n/a';
        sponsorship.Congress_Lead__c='n/a';
        sponsorship.GES_Account_Manager__c='n/a';
        insert sponsorship;
        
        return sponsorship;
    }
    
    /* Returs a test Symposia */
    public static Symposia__c getTestSymposia(){
        GES_Connect_Corporate_Accounts__c parentCongress = GC_TestUtils.getTestCongress();
        Symposia__c symposia = new Symposia__c();
        symposia.Symposia_Name__c = 'Test symposia for Devs';
        symposia.Activity_Level__c = '2';        
        symposia.Congress__c = parentCongress.Id;
        symposia.CurrencyIsoCode = 'USD';      
        symposia.GES_Congress_Manager__c='n/a';
        symposia.Congress_Lead__c='n/a';
        symposia.GES_Account_Manager__c='n/a';
        insert symposia;
        
        return symposia;
    }
    
    /* Returs a test Meeting room */
    public static Meeting_Room__c  getTestMeetingRoom(){
        GES_Connect_Corporate_Accounts__c parentCongress = GC_TestUtils.getTestCongress();
        Meeting_Room__c  meetingRoom  = new Meeting_Room__c ();
        meetingRoom.Meeting_Room_Name__c  = 'Test Meeting_Room__c for Devs';
        meetingRoom.Activity_Level__c = '2';        
        meetingRoom.Congress__c = parentCongress.Id;
        meetingRoom.CurrencyIsoCode = 'USD';      
        meetingRoom.GES_Congress_Manager__c='n/a';
        meetingRoom.Congress_Lead__c='n/a';
        meetingRoom.GES_Account_Manager__c='n/a';
        insert meetingRoom;
        
        return meetingRoom;
    }
    
    /* Returs a test Meeting room */
    public static Product_Theater__c   getTestProductTheater(){
        GES_Connect_Corporate_Accounts__c parentCongress = GC_TestUtils.getTestCongress();
        Product_Theater__c   productTheatre  = new Product_Theater__c  ();
        productTheatre.Product_Theater_Name__c  = 'Test Product_Theater__c  for Devs';
        productTheatre.Activity_Level__c = '2';        
        productTheatre.Congress__c = parentCongress.Id;
        productTheatre.CurrencyIsoCode = 'USD';      
        productTheatre.GES_Congress_Manager__c='n/a';
        productTheatre.Congress_Lead__c='n/a';
        productTheatre.GES_Account_Manager__c='n/a';
        insert productTheatre;
        
        return productTheatre;
    }
    
    /* Returs a test Brand */
    public static Brand__c getTestBrand(){
        //GES_Connect_Corporate_Accounts__c parentCongress = GC_TestUtils.getTestCongress();
        //insert parentCongress;
        Brand__c brand = new Brand__c();
        brand.Brand_Name__c = 'Acrodat';
        brand.Brand_Category__c= 'Rare Diseases';
        brand.Business_Unit__c= 'CH';
        brand.GES_Congress_Manager__c = 'McCartney, Eva';       
        //brand.GES_Connect_Corporate_Accounts__c = parentCongress.Id;
        brand.Brand_Team_Contact__c = 'Adamczyk, Alice';
        brand.Company_Code__c  = '12345';  
        brand.Cost_Center__c  =67894;  
        brand.Funding_Provider_Department__c  = 'Medical';  
        brand.Funding_Provider_Region__c  = 'Global';  
        brand.Funding_Provider_Brand__c  = 'Acrodat';  
        
        insert brand;
        
        return brand;
    }
    
    public static void setSimulateException(Boolean val){
        simulateException=val;
    }
}