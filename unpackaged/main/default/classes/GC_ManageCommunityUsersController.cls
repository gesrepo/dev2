public without sharing class GC_ManageCommunityUsersController {
    public String clientProfile { get; set; }
    public String vendorProfile { get; set; }

    public List<User> clientUsers { get; set; }
    public List<User> vendorUsers { get; set; }
    public User tempUser { get; set; }
    public List<SelectOption> userOptions { get; set; }
    public String selectedUserOption { get; set; }
    public Boolean displayPopup { get; set; }

    private Map<Id, User> clientUserMap { get; set; }
    private Map<Id, User> vendorUserMap { get; set; }

    private List<Profile> profiles { get; set; }

    public List<User> clientResults { get; set; }
    public List<User> vendorResults { get; set; }

    public List<SelectOption> serviceTypes { get; set; }
    public String selectedServiceTypeOption { get; set; }

     public Boolean showServiceType { get; set; }
     public Set<String> serviceTypeSet { get; set; }

    public GC_ManageCommunityUsersController() {
        clientProfile = 'GC Community Client';
        vendorProfile = 'GC Community Vendor';
        tempUser = new User();
        profiles = new List<Profile>();

        userOptions = new List<SelectOption>();
        userOptions.add(new SelectOption('', '--None--'));
        userOptions.add(new SelectOption('Client', 'Client'));
        userOptions.add(new SelectOption('Vendor', 'Vendor'));

        serviceTypes = new List<SelectOption>();
        List<GC_Show_Attribute__c> showAttributes = [select Id, Name, RecordType.Name from GC_Show_Attribute__c order by Name];

        if (serviceTypes == null) {
            serviceTypes = new List<SelectOption>();
        }

        serviceTypes.clear();
        SelectOption noneSelectOption = new SelectOption('', '---None---');
        serviceTypes.add(noneSelectOption);

        serviceTypeSet = new Set<String>();

        for (GC_Show_Attribute__c showAttribute : showAttributes) {
            if (showAttribute.RecordType.Name == 'Show Service') {
                serviceTypeSet.add(showAttribute.Name);
            }
        }

        if(serviceTypeSet.size() > 0)
        {
            for(String str: serviceTypeSet)
            {
                SelectOption option = new SelectOption(str, str);
                serviceTypes.Add(option);
            }
        }

        reloadUsers();
    }

    public PageReference reloadUsers() {
        clientUsers = [Select Id, FirstName, LastName, Email, IsActive, Username, ContactId From User Where Profile.Name = :clientProfile];
        vendorUsers = [Select Id, FirstName, LastName, Email, IsActive, Username, ContactId From User Where Profile.Name = :vendorProfile];

        clientUserMap = new Map<Id, User>();
        vendorUserMap = new Map<Id, User>();
        if (clientUsers.size() > 0) {
            for (User client : clientUsers) {
                clientUserMap.put(client.Id, client);
            }
        }
        if (vendorUsers.size() > 0) {
            for (User vendor : vendorUsers) {
                vendorUserMap.put(vendor.Id, vendor);
            }
        }

        String queryString = 'Select Id, FirstName, LastName, Email, IsActive, Username, ContactId From User Where Profile.Name = \'' + clientProfile + '\'';
        clientResults = Database.query(queryString);

        queryString = 'Select Id, FirstName, LastName, Email, IsActive, Username, ContactId From User Where Profile.Name = \'' + vendorProfile + '\'';
        vendorResults = Database.query(queryString);

        return null;
    }

    public void updateClientRecord() {
        Id clientId = ApexPages.CurrentPage().getParameters().get('userId');
        if (clientUserMap.containsKey(clientId)) {
            User clientUser = clientUserMap.get(clientId);
            if (clientUser.IsActive) {
                clientUser.IsActive = false;
                update clientUser;
            }
            else if (!clientUser.IsActive) {
                clientUser.IsActive = true;
                update clientUser;
            }
        }
        reloadUsers();
    }

    public void updateVendorRecord() {
        Id vendorId = ApexPages.CurrentPage().getParameters().get('userId');
        if (vendorUserMap.containsKey(vendorId)) {
            User vendorUser = vendorUserMap.get(vendorId);
            if (vendorUser.IsActive) {
                vendorUser.IsActive = false;
                update vendorUser;
            }
            else if (!vendorUser.IsActive) {
                vendorUser.IsActive = true;
                update vendorUser;
            }
        }
        reloadUsers();
    }

    public PageReference addUser() {
        displayPopup = true;
        showServiceType = false;
        return null;
    }

    public PageReference displayServiceType() {
        if(selectedUserOption == 'Vendor')
        {
            showServiceType = true;
        }
        else
        {
             showServiceType = false;
        }
        return null;
    }

    public PageReference saveUser() {
        if (tempUser.ContactId == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select Contact.'));
        }
        else {
            try {
                User newUser = new User();
                newUser.ContactId = tempUser.ContactId;
                newUser.FirstName = tempUser.FirstName;
                newUser.LastName = tempUser.LastName;
                newUser.Email = tempUser.Email;
                newUser.LocaleSidKey = 'en_US';
                newUser.Alias = '' + tempUser.FirstName.left(1).toLowerCase() + tempUser.FirstName.left(4).toLowerCase();
                newUser.TimeZoneSidKey = 'America/Los_Angeles';
                newUser.EmailEncodingKey = 'ISO-8859-1';
                newUser.UserName = tempUser.Username;
                newUser.IsActive = true;
                newUser.LanguageLocaleKey = 'en_US';
                if (selectedUserOption == 'Client') {
                    newUser.ProfileId = [select Id from Profile where Name = 'GC Community Client'].get(0).Id;
                }
                else if (selectedUserOption == 'Vendor') {
                    newUser.ProfileId = [select Id from Profile where Name = 'GC Community Vendor'].get(0).Id;
                }
                newUser.ServiceType__c = selectedServiceTypeOption;
                insert newUser;
                displayPopup = false;
                return reloadUsers();
            }
            catch (Exception e) {
                Boolean expectedExceptionThrown = e.getMessage().contains('PORTAL_USER_ALREADY_EXISTS_FOR_CONTACT') ? true : false;
                if (expectedExceptionThrown) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Portal user already exists for contact.'));
                    displayPopup = false;
                }
                else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An error occurred while creating the user: ' + e.getMessage()));
                    displayPopup = true;
                }
            }
        }

        return null;
    }

    public void closePopup() {
        displayPopup = false;
    }

    public PageReference tempUserContactChanged() {
        Contact c = [select Id, Name, FirstName, LastName, Email from Contact where Id = :tempUser.ContactId];
        if (c != null) {
            tempUser.FirstName = c.FirstName;
            tempUser.LastName = c.LastName;
            tempUser.Email = c.Email;
            tempUser.Username = c.FirstName + '.' + c.LastName + '@ges.connectcommunity.com';
        }
        return null;
    }
}