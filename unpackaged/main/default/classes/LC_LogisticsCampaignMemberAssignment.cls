public class LC_LogisticsCampaignMemberAssignment {
    public static String ExcludeCustomersList = 'COVIDIEN,MILLENNIUM,FIDELITY,SCHERING,MERCK,BOEHRINGER,GENERAL DYNAMICS,NORDISK,TESARO,BRISTOL,VERTEX,NANOSTRING,NANOPORE,JDA,DENDREON,FUJIFILM,TAKEDA,PFIZER,WYETH';
    public static String ExcludeOwnersList = '\'awithrow@ges.com\',\'dboncek@ges.com\',\'dbullock@ges.com\',\'efrankel@ges.com\',\'eloomis@ges.com\',\'jboy@ges.com\',\'jcarnahan@ges.com\',\'jkelleher@ges.com\',\'jnalbor@ges.com\',\'kwatson@ges.com\',\'leskievich@ges.com\',\'lkleidon@ges.com\',\'Llepley@ges.com\',\'mgoulter@ges.com\',\'msiconolfi@ges.com\',\'rniemeyer@ges.com\',\'sborne@ges.com\',\'tcampanaro@ges.com\',\'tiverson@ges.com\',\'vfratello@ges.com\',\'vsaia@ges.com\'';
    @AuraEnabled
    public static LogisticsCampaignWrapper getCampaign(String campaignId){
        String distributionMethod = 'Count';
        Integer totalToAssignPercent = 100;
        Integer NSFValue = 400;
        Integer LimitCount = 0;
        Integer ContactCount = 0;
        String IncludeCustomersDomIntlValue = '0';
        String DefaultProfile = 'GES Service';
        String NSFFilterOperator;
        
        LogisticsCampaignWrapper lcWrapper = new LogisticsCampaignWrapper();
        Campaign ParentCampaign = [Select Id, Name, Status, Opportunity__c, ParentId From Campaign Where Id = :campaignId];
        
        if(ParentCampaign.Opportunity__c != null){
            lcWrapper = FetchShowContactCount(LimitCount, ParentCampaign, NSFValue, NSFFilterOperator, IncludeCustomersDomIntlValue);
            lcWrapper.hasOppty = true;
            lcWrapper.campaign = ParentCampaign;
            lcWrapper.distributionMethod = distributionMethod;
            lcWrapper.totalToAssignPercent = totalToAssignPercent;
            lcWrapper.NSFValue = NSFValue;
            lcWrapper.ExcludeCustomersList = ExcludeCustomersList;
            lcWrapper.totalToAssignCount = lcWrapper.showContactCount;
            lcWrapper.IncludeCustomersDomIntlValue = IncludeCustomersDomIntlValue;
            
            lcWrapper.listProfilePicklist = getProfileOptions();
            lcWrapper.mapNSFFilterOperatorPicklist = getNSFOperatorOptions();
            lcWrapper.mapIncludeCustomerPicklist = getIncludeCustomersOptions();
            lcWrapper.mapSubsetByPicklist = getSubsetOptions();
            lcWrapper.mapUserSelectedPicklist = getRowCheckActionOptions();
            lcWrapper.mapUserUnselectedPicklist = getRowUncheckActionOptions();
            
            List<User> LoLogisticsUsers = [Select Id, LastName, FirstName, Email From User Where Profile.Name = :DefaultProfile And IsActive = true And UserPermissionsSupportUser = true And Assign_Logistics_Campaign__c = true Order by FirstName, LastName];
            List<UserWrapper> listUserWrapper = selectAllUsers(lcWrapper.showContactCount,LoLogisticsUsers);
            lcWrapper.userWrapper = listUserWrapper;
            lcWrapper.listUser=LoLogisticsUsers;
        }else{
            lcWrapper.hasOppty = false;
        }
        return lcWrapper;
    }
    
    public static LogisticsCampaignWrapper FetchShowContactCount(Integer limitCount, Campaign ParentCampaign, Integer NSFValue, String NSFFilterOperator,String IncludeCustomersDomIntlValue){
        LogisticsCampaignWrapper lcWrapper = new LogisticsCampaignWrapper();
        Integer ContactCount = 0;
        List<Oracle_Show_Booth_Contact__c> LoBoothContactsToAssign = new List<Oracle_Show_Booth_Contact__c>();
        
        if (ParentCampaign != null && ParentCampaign.Opportunity__c != null)
        {
            //Get Total Show Contact Count
            String TotalShowContactCountQuery = 'Select Id, Contact__c, Oracle_Show_Booth__c, PRIMARY_FLAG__c, Contact__r.Account.Id From Oracle_Show_Booth_Contact__c ';
            TotalShowContactCountQuery += ' Where Oracle_Show_Booth__r.Show_Occurrence__c = \'' + ParentCampaign.Opportunity__c + '\'';
            TotalShowContactCountQuery += ' And (Oracle_Show_Booth__r.Account__r.Exhibitor_Account_Type__c = null Or (Oracle_Show_Booth__r.Account__r.Exhibitor_Account_Type__c != \'Program\' And Oracle_Show_Booth__r.Account__r.Exhibitor_Account_Type__c != \'Priority\'))';          
            TotalShowContactCountQuery += ' And (Not Oracle_Show_Booth__r.Account__r.Owner.Username In (' + ExcludeOwnersList + ')) And Oracle_Show_Booth__r.Inactive_Flag__c = False';
            
            List<Oracle_Show_Booth_Contact__c> LoAllBoothContacts = Database.query(TotalShowContactCountQuery);
            
            if (LoAllBoothContacts != null){
                lcWrapper.TotalShowContactCount = LoAllBoothContacts.size();
            }
            
            List<Campaign> LoChildCampaigns = [Select Id, Name, OwnerId From Campaign Where ParentId = :ParentCampaign.Id And Status = 'Planned'];
            Map<Id, Id> MoUserIdChildCampaignId = new Map<Id, Id>();
            Map<Id, List<CampaignMember>> MoOwnerIdToLoCampaignMembers = new Map<Id, List<CampaignMember>>();
            Set<Id> SoAssignedContactIds = new Set<Id>();
            Set<Id> SoAssignedBoothIds = new Set<Id>();
            Set<String> SoAssignedConcatenatedAccountIdContactIds = new Set<String>();
            
            List<CampaignMember> LoCampaignMembers = new List<CampaignMember>();
            
            if (LoChildCampaigns != null && LoChildCampaigns.size() > 0)
            {
                Set<Id> SoChildCampaignIds = new Set<Id>();
                
                for(Campaign c : LoChildCampaigns)
                {
                    SoChildCampaignIds.add(c.Id);
                    MoUserIdChildCampaignId.put(c.OwnerId, c.Id);
                }
                
                LoCampaignMembers = [Select Id, ContactId, CampaignId, Booth__c, Booth__r.Account__c From CampaignMember Where CampaignId In :SoChildCampaignIds And Booth__c != null Order By CampaignId];
                
                if (LoCampaignMembers != null && LoCampaignMembers.size() > 0)
                {
                    /* START: Build Map of Campagin Id to Campaign Members */
                    
                    Map<Id, List<CampaignMember>> MoCampIdToLoCampaignMembers = new Map<Id, List<CampaignMember>>();
                    List<CampaignMember> LoCampMemberForCamp = new List<CampaignMember>();
                    Id CampId = null;
                    
                    for(CampaignMember cm : LoCampaignMembers)
                    {
                        /*START: Build a list of unique Contacts and Booths that are already assigned*/
                        SoAssignedContactIds.add(cm.ContactId);
                        SoAssignedBoothIds.add(cm.Booth__c);
                        
                        if (cm.Booth__c != null && cm.Booth__r != null && cm.Booth__r.Account__c != null)
                            SoAssignedConcatenatedAccountIdContactIds.add(cm.Booth__r.Account__c + ',' + cm.ContactId);
                        
                        /*END: Build a list of unique Contacts  and Booths that are already assigned*/
                        
                        if (CampId == null)
                            CampId = cm.CampaignId;
                        
                        if (CampId != cm.CampaignId)
                        {
                            MoCampIdToLoCampaignMembers.put(CampId, LoCampMemberForCamp);
                            LoCampMemberForCamp.clear();
                            CampId = cm.CampaignId;
                        }
                        else
                        {
                            LoCampMemberForCamp.add(cm);
                        }
                    }
                    
                    if (LoCampMemberForCamp != null && LoCampMemberForCamp.size() > 0)
                    {
                        MoCampIdToLoCampaignMembers.put(CampId, LoCampMemberForCamp);
                        LoCampMemberForCamp.clear();
                        CampId = null;            
                    }
                    
                    /* END: Build Map of Campagin Id to Campaign Members */
                    
                    /* START: Build Map of Owner Id to Campaign Members */
                    
                    for (Id ownerId : MoUserIdChildCampaignId.keySet())
                    {
                        for(Campaign c : LoChildCampaigns)
                        {
                            if (ownerId == c.OwnerId)
                            {
                                MoOwnerIdToLoCampaignMembers.put(ownerId, MoCampIdToLoCampaignMembers.get(c.Id));
                                break;
                            }
                        }
                    }
                    
                    /* END: Build Map of Owner Id to Campaign Members */
                }      
            }
            
            Id OpportunityId = ParentCampaign.Opportunity__c;
            
            String Query = 'Select Id, Account__c, Account__r.Exhibitor_Account_Type__c From Oracle_Show_Booth__c ';
            String WhereClause = ' Where Show_Occurrence__c = \'' + OpportunityId + '\'';
            
            If (NSFValue == null)
                NSFValue = 0;
            
            if (NSFFilterOperator == '>')
                WhereClause += ' And (BOOTH_SIZE__c > ' + NSFValue + ' Or BOOTH_SIZE__c = null)';
            else if (NSFFilterOperator == '>=')
                WhereClause += ' And (BOOTH_SIZE__c >= ' + NSFValue + ' Or BOOTH_SIZE__c = null)';
            else if (NSFFilterOperator == '<')              
                WhereClause += ' And (BOOTH_SIZE__c < ' + NSFValue + ' Or BOOTH_SIZE__c = null)';
            else if (NSFFilterOperator == '<=')
                WhereClause += ' And (BOOTH_SIZE__c <= ' + NSFValue + ' Or BOOTH_SIZE__c = null)';
            else if (NSFFilterOperator == '=')
                WhereClause += ' And (BOOTH_SIZE__c = ' + NSFValue + ' Or BOOTH_SIZE__c = null)';
            else
                WhereClause += ' And (BOOTH_SIZE__c < ' + NSFValue + ' Or BOOTH_SIZE__c = null)';
            
            WhereClause += ' And (Account__r.Do_No_Contact__c = null Or Account__r.Do_No_Contact__c = false) ';
            WhereClause += ' And (Account__r.Exhibitor_Account_Type__c = null Or (Not Account__r.Exhibitor_Account_Type__c In (\'Program\',\'Priority\'))) ';
            WhereClause += ' And (Not Account__r.Owner.Username In (' + ExcludeOwnersList + ')) And Inactive_Flag__c = False'; //Amarab 7/26/2017 to exclude inactive booths
            
            if(IncludeCustomersDomIntlValue == '0') //Domestic
            {
                WhereClause += ' And (Account__r.BillingCountry = \'US\' Or Account__r.BillingCountry = \'United States\')';
            }
            else if(IncludeCustomersDomIntlValue == '1') //Canada
            {
                WhereClause += ' And (Account__r.BillingCountry = \'CA\' Or Account__r.BillingCountry = \'Canada\')';
            }
            else if (IncludeCustomersDomIntlValue == '3') //International
            {
                WhereClause += ' And (Account__r.BillingCountry != \'US\' And Account__r.BillingCountry != \'United States\' And Account__r.BillingCountry != \'CA\' And Account__r.BillingCountry != \'Canada\')';
            }
            
            String[] LoCustomersToExclude = new String[] {};
                
                if (ExcludeCustomersList != null && ExcludeCustomersList != '')
            {
                LoCustomersToExclude = ExcludeCustomersList.split(',');
            }
            
            for(String custName : LoCustomersToExclude)
            {
                WhereClause += ' And (Not Account__r.Name Like \'%' + custName + '%\')';
            }
            
            String LimitClause = '';
            
            if (LimitCount > 0)
                LimitClause = ' Limit ' + String.valueOf(LimitCount);
            
            List<Oracle_Show_Booth__c> LoBooths = Database.Query(Query + WhereClause + LimitClause);
            
            Set<Id> SoAllUnassignedBoothIds = new Set<Id>();
            Set<Id> SoExhibitorIds = new Set<Id>();
            map<Id, Id> MoExhibitorIdToBoothId = new map<Id, Id>();
            
            for(Oracle_Show_Booth__c Booth : LoBooths)
            {
                if (!SoAssignedBoothIds.Contains(Booth.Id))
                {
                    SoAllUnassignedBoothIds.add(Booth.Id);
                    
                    SoExhibitorIds.add(Booth.Account__c);
                    MoExhibitorIdToBoothId.put(Booth.Account__c, Booth.Id);
                }
            }
            
            List<Opportunity> LoOpenEEOpty = new List<Opportunity>();
            Set<Id> SoBoothIdsForOpenOptys = new Set<Id>();
            
            LoOpenEEOpty = Database.Query('Select Id, AccountId From Opportunity Where AccountId In :SoExhibitorIds And Show_Occurrence__c = :OpportunityId And (Not RecordType.Name In (\'Sales Rep Show Occurrence\',\'Master Show Occurrence\',\'Field Security-TS\',\'Field Security-PS\',\'Field Security-NE\',\'Field Security-LR\',\'Field Security-LPM\',\'Field Security-LPE\',\'Field Security-LO\',\'Field Security-IA\',\'Field Security-DB\',\'Field Security-CV\',\'Field Security-CR\'))');
            
            for(Opportunity o : LoOpenEEOpty)
            {
                SoBoothIdsForOpenOptys.add(MoExhibitorIdToBoothId.get(o.AccountId));
            }
            
            Set<Id> SoUnassignedBoothIdsWithoutOpenOptys = new Set<Id>();
            
            for(Id bid : SoAllUnassignedBoothIds)
            {
                if (!SoBoothIdsForOpenOptys.contains(bid))
                    SoUnassignedBoothIdsWithoutOpenOptys.add(bid);
            }            
            
            if (SoUnassignedBoothIdsWithoutOpenOptys.size() > 0)
            {
                //Changed query to filter out show booth contact, if contact__c field is
                //blank or null. Delete of a contact related to show booth contact will
                //cause this condition.
                String ConQuery = 'Select Id, PRIMARY_FLAG__c, Contact__c, Contact__r.Account.Id, Oracle_Show_Booth__c, Oracle_Show_Booth__r.Account__c';
                ConQuery += ' From Oracle_Show_Booth_Contact__c ';
                ConQuery += ' Where Oracle_Show_Booth__c In :SoUnassignedBoothIdsWithoutOpenOptys';
                ConQuery += ' And (Contact__r.HasOptedOutOfEmail = null Or Contact__r.HasOptedOutOfEmail = false)';
                ConQuery += ' And Contact__c !=  null And Oracle_Show_Booth__r.Inactive_Flag__c = False'; //Amarab 7/26/2017 to exclude inactive booths
                ConQuery += ' Order By Oracle_Show_Booth__r.Account__r.Name, Contact__r.LastName, Contact__r.FirstName';
                
                List<Oracle_Show_Booth_Contact__c> LoBoothContacts = Database.query(ConQuery);
                
                if (LoBoothContacts != null)
                {
                    LoBoothContactsToAssign.clear();
                    
                    //Remove duplicates from this
                    Set<String> SoConcatenatedAccountIdContactId = new Set<String>();
                    Map<Id, Oracle_Show_Booth_Contact__c> MoBthContIdToBthCont = new Map<Id, Oracle_Show_Booth_Contact__c>();
                    
                    Set<Id> SoUniqueContacts = new Set<Id>();
                    for(Oracle_Show_Booth_Contact__c sbc : LoBoothContacts)
                    {
                        if (!SoUniqueContacts.contains(sbc.Contact__c) && !SoAssignedContactIds.contains(sbc.Contact__c))
                        {
                            SoUniqueContacts.add(sbc.Contact__c);
                            LoBoothContactsToAssign.add(sbc);
                        }
                    }
                    ContactCount = LoBoothContactsToAssign.size();
                }
            }
        }
        lcWrapper.showContactCount = ContactCount;
        lcWrapper.listBoothContacts = LoBoothContactsToAssign;
        return lcWrapper;    
    }
    
    @AuraEnabled
    public static List<UserWrapper> redistributeSelectedUsers(Integer showContactCount, String wrapperData){
        LogisticsCampaignWrapper lcWrapper = (LogisticsCampaignWrapper) JSON.deserialize(wrapperData, LogisticsCampaignWrapper.class);
        List<UserWrapper> listUserWrapper = lcWrapper.userWrapper;
        system.debug('showContactCount:: '+showContactCount);
        system.debug('listUserWrapper:: '+listUserWrapper.size());
        system.debug('listUserWrapper:: '+listUserWrapper);
        List<UserWrapper> selectedUsers = new List<UserWrapper>();
        for(UserWrapper uw: listUserWrapper){
            if(uw.isChecked){
                selectedUsers.add(uw);
            }
        }
        
        Double Quotient = showContactCount/selectedUsers.size();
        Integer Remainder = Math.mod(showContactCount, selectedUsers.size());
        Integer FirstUserCount = (Integer)Quotient + Remainder;
        
        for(UserWrapper uw: listUserWrapper){
            if(uw.isChecked){
                uw.Count = (Integer)Quotient;
            }else{
                uw.Count = 0;
            }
        }
        
        for(UserWrapper uw: listUserWrapper){
            if(uw.isChecked){
                if (Remainder == 0){
                    break;
                }
                uw.Count++;
                Remainder--;
            }
        }
        
        return listUserWrapper;
    }
    
    @AuraEnabled
    public static List<UserWrapper> selectAllUsers(Integer showContactCount, List<User> listLogisticsUsers){
        List<UserWrapper> listUserWrapper = new List<UserWrapper>();
        if (listLogisticsUsers != null && listLogisticsUsers.size() > 0){
            Double Quotient = showContactCount/listLogisticsUsers.size();
            Integer Remainder = Math.mod(showContactCount, listLogisticsUsers.size());
            Integer FirstUserCount = (Integer)Quotient + Remainder;
            
            for(User u: listLogisticsUsers){
                UserWrapper uWrp = new UserWrapper();
                uWrp.user = u;
                uWrp.isChecked = true;
                uWrp.Count = (Integer)Quotient;
                listUserWrapper.add(uWrp);
            }
            
            
            for(UserWrapper uw: listUserWrapper){
                if (Remainder == 0)
                    break;
                uw.Count++;
                Remainder--;
            }
            
            system.debug('listUserWrapper2:: '+listUserWrapper);
        }
        
        return listUserWrapper;
    }
    
    public static List<String> getProfileOptions(){
        List<String> Profiles = new List<String>();
        List<Profile> LoProfiles = [Select Id, Name From Profile Where Name = 'GES Service' Order By Name];
        if (LoProfiles != null){ 
            for(Profile p : LoProfiles){
                Profiles.add(p.name);
            }
        }
        
        LoProfiles.clear();
        LoProfiles = [Select Id, Name From Profile Where Name Like 'GES Exhibitor%' Order By Name];
        if (LoProfiles != null){
            for(Profile p : LoProfiles){
                Profiles.add(p.name);
            }
        }
        
        LoProfiles.clear();
        LoProfiles = [Select Id, Name From Profile Where (Not Name Like 'GES Exhibitor%') And Name != 'GES Service' Order By Name];
        if (LoProfiles != null){
            Profiles.add('---- Other Profiles ----');
            for(Profile p : LoProfiles){
                Profiles.add(p.name);
            }
        }
        return Profiles;
    }
    
    public static Map<String,String> getNSFOperatorOptions(){
        Map<String,String> nsfList = new Map<String,String>();
        nsfList.put('<','Less Than');
        nsfList.put('>','Greater Than');
        nsfList.put('<=','Less Than Equal');
        nsfList.put('>=','Greater Than Equal');
        nsfList.put('=','Equal');
        return nsfList;
    }
    
    public static Map<String,String> getIncludeCustomersOptions(){
        Map<String,String> countryOptions = new Map<String,String>();
        countryOptions.put('0','Domestic');
        countryOptions.put('1','Canada');
        countryOptions.put('2','All');
        countryOptions.put('3','International');
        return countryOptions;
    }
    
    public static Map<String,String> getSubsetOptions(){
        Map<String,String> subsetOptions = new Map<String,String>();
        subsetOptions.put('Count','Count');
        subsetOptions.put('Percent','%');
        return subsetOptions;
    }
    
    public static Map<String,String> getRowCheckActionOptions(){
        Map<String,String> rowCheckOptions = new Map<String,String>();
        rowCheckOptions.put('0','None');
        rowCheckOptions.put('1','Distribute Evenly');
        return rowCheckOptions;
    }
    
    public static Map<String,String> getRowUncheckActionOptions(){
        Map<String,String> rowUncheckOptions = new Map<String,String>();
        rowUncheckOptions.put('0','Release');
        rowUncheckOptions.put('1','Distribute Evenly');
        return rowUncheckOptions;
    }
    
    @AuraEnabled
    public static LogisticsCampaignWrapper nsfFilterOperatorChanged(String wrapperData){
        system.debug('wrapperData:: '+wrapperData);
        
        LogisticsCampaignWrapper lcWrapper = (LogisticsCampaignWrapper) JSON.deserialize(wrapperData, LogisticsCampaignWrapper.class);
        ExcludeCustomersList = lcWrapper.ExcludeCustomersList;
        
        LogisticsCampaignWrapper newLCWrapper = FetchShowContactCount(0, lcWrapper.campaign, lcWrapper.NSFValue, lcWrapper.NSFFilterOperator, lcWrapper.IncludeCustomersDomIntlValue);
        lcWrapper.TotalShowContactCount = newLCWrapper.TotalShowContactCount;
        lcWrapper.showContactCount = newLCWrapper.showContactCount;
        
        List<UserWrapper> listUserWrapper = selectAllUsers(newLCWrapper.showContactCount,lcWrapper.listUser);
        lcWrapper.userWrapper = listUserWrapper;
        lcWrapper.TotalToAssignCount = newLCWrapper.showContactCount;
        lcWrapper.TotalToAssignPercent = 100; 
        return lcWrapper;
    }
    
    @AuraEnabled
    public static LogisticsCampaignWrapper distributionMethodChanged(String wrapperData, String method){
        LogisticsCampaignWrapper lcWrapper = (LogisticsCampaignWrapper) JSON.deserialize(wrapperData, LogisticsCampaignWrapper.class);
        Integer count = lcWrapper.showContactCount;
        List<User> lst_User = new List<User>();
        if (method.toUpperCase() == 'COUNT'){
            count = lcWrapper.totalToAssignCount;
            lst_User =  shrinkAssignedShowContactList(lcWrapper.totalToAssignCount,lcWrapper.listUser);
        }
        else if (method.toUpperCase() == 'PERCENT'){
            count = integer.valueOf(lcWrapper.showContactCount * lcWrapper.totalToAssignPercent / 100);
            lst_User = shrinkAssignedShowContactList(count,lcWrapper.listUser);
        }
        
        List<UserWrapper> listUserWrapper = selectAllUsers(count,lst_User);
        lcWrapper.userWrapper = listUserWrapper;
        lcWrapper.TotalToAssignCount = count;
        
        return lcWrapper;
    }
    
    private static List<User> shrinkAssignedShowContactList(Integer Count, List<User> LoCustomUsers){
        List<User> NewLoCustomUsers = new List<User>();
        if (LoCustomUsers != null){
            Integer UCount = LoCustomUsers.size() >= Count ? Count : LoCustomUsers.size();
            Integer LoopCount = 0;
            
            for(User cusr : LoCustomUsers){
                NewLoCustomUsers.add(cusr);
                LoopCount++;
                
                if (LoopCount == Count)
                    break;                  
            }
        } 
        return NewLoCustomUsers;
    }
    

    @AuraEnabled
    public static LogisticsCampaignWrapper refreshCustomUsersListProfileChanged(String wrapperData, String profileName){
        LogisticsCampaignWrapper lcWrapper = (LogisticsCampaignWrapper) JSON.deserialize(wrapperData, LogisticsCampaignWrapper.class);
        lcWrapper.userWrapper  = new List<UserWrapper>();
        if (profileName != null && profileName != ''){
            List<User> LoLogisticsUsers = [Select Id, LastName, FirstName, Email From User Where Profile.Name = :profileName And IsActive = true And UserPermissionsSupportUser = true And Assign_Logistics_Campaign__c = true Order By FirstName, LastName];
            if (LoLogisticsUsers != null && LoLogisticsUsers.size() > 0){
                List<UserWrapper> listUserWrapper = selectAllUsers(lcWrapper.TotalToAssignCount,LoLogisticsUsers);
                lcWrapper.userWrapper = listUserWrapper;
            }
        }
        return lcWrapper;
    }
    
    @AuraEnabled
    public static LogisticsCampaignWrapper assign(String wrapperData){
        LogisticsCampaignWrapper lcWrapper = (LogisticsCampaignWrapper) JSON.deserialize(wrapperData, LogisticsCampaignWrapper.class);
        List<UserWrapper> listUserWrapper = lcWrapper.userWrapper;
        Campaign parentCampaign = lcWrapper.campaign;
        List<Oracle_Show_Booth_Contact__c> listBoothContacts = lcWrapper.listBoothContacts;
        
        List<CustomUserObject> listCustomUser = new List<CustomUserObject>();
        if(listUserWrapper != null && listUserWrapper.size() > 0){
            for(UserWrapper uw: listUserWrapper){
                CustomUserObject cu = new CustomUserObject();
                cu.Id = uw.user.Id;
                cu.FirstName = uw.user.FirstName;
                cu.LastName = uw.user.LastName;
                cu.Email = uw.user.Email;
                cu.IsChecked = uw.isChecked;
                cu.Count = uw.count;
                listCustomUser.add(cu);
            }
        }
        createCampaign(parentCampaign,listCustomUser);
        CreateCampaignMembers(parentCampaign.Id, listCustomUser, listBoothContacts);
        
        LogisticsCampaignWrapper newLCWrapper = FetchShowContactCount(0, lcWrapper.campaign, lcWrapper.NSFValue, lcWrapper.NSFFilterOperator, lcWrapper.IncludeCustomersDomIntlValue);
        lcWrapper.TotalShowContactCount = newLCWrapper.TotalShowContactCount;
        lcWrapper.showContactCount = newLCWrapper.showContactCount;
        lcWrapper.TotalToAssignCount = newLCWrapper.showContactCount;
        lcWrapper.TotalToAssignPercent = 100;
        lcWrapper.listBoothContacts = newLCWrapper.listBoothContacts;
        List<UserWrapper> listUserWrapper2 = redistribute(newLCWrapper.showContactCount, listUserWrapper);
        lcWrapper.userWrapper = listUserWrapper2;
        return lcWrapper;
    }
    
    public static List<UserWrapper> redistribute(Integer ContactCount, List<UserWrapper> listUserWrapper) {

        List<UserWrapper> SelectedUsers = new List<UserWrapper>();
        for(UserWrapper uw : listUserWrapper){               
            if (uw.isChecked)
                SelectedUsers.add(uw);
        }
        
        Double Quotient = ContactCount/SelectedUsers.size();
        Integer Remainder = Math.mod(ContactCount, SelectedUsers.size());
        
        for(UserWrapper uw : listUserWrapper){
            if (uw.isChecked){
                uw.Count = (Integer)Quotient;
            }
        }
        
        for(UserWrapper uw : listUserWrapper){
            if (uw.isChecked){
                if (Remainder == 0)
                    break;
                uw.Count++;
                Remainder--;
            }
        }
        return listUserWrapper;
    }
    
    public static void CreateCampaign(Campaign parentCampaign, List<CustomUserObject> users){
        system.debug('*** start CreateCampaign ltn:: ***');
        system.debug('parentCampaignId :: '+parentCampaign.Id);
        system.debug('users size:: '+users.size());
        system.debug('users:: '+users);
        
        Id parentCampaignId = parentCampaign.Id;
        List<Campaign> LoChildCampaigns = [Select Id, Name, ParentId, OwnerId From Campaign Where ParentId = :parentCampaignId And Status = 'Planned'];
        List<CustomUserObject> LoUsersNeedingNewCampaigns = new List<CustomUserObject>();
        
        /* START: DETERMINE IF CAMPAIGN NEEDS TO BE CREATED*/
        
        if (LoChildCampaigns != null && LoChildCampaigns.size() > 0)
        {
            for(CustomUserObject cs : users)
            {
                if (cs.IsChecked)
                {
                    Boolean CampExists = false;
                    
                    for (Campaign cmp : LoChildCampaigns)
                    {
                        if (cmp.OwnerId == cs.Id)
                        {
                            CampExists = true;
                            break;
                        }
                    }
                    
                    if (!CampExists)
                        LoUsersNeedingNewCampaigns.add(cs);
                }
            }
        }
        else
        {
            for(CustomUserObject cs : users)
            {
                if (cs.IsChecked)
                    LoUsersNeedingNewCampaigns.add(cs);
            }        
        }
        
        /* END: DETERMINE IF CAMPAIGN NEEDS TO BE CREATED*/
        
        /* START: CREATE CHILD CAMPAIGNS */   
        
        List<Campaign> LoNewCampaigns = new List<Campaign>();
        
        system.debug('LoUsersNeedingNewCampaigns size:: '+LoUsersNeedingNewCampaigns.size());
        for(CustomUserObject cu : LoUsersNeedingNewCampaigns)
        {
            Campaign cmp = new Campaign();
            cmp.OwnerId = cu.Id;
            cmp.ParentId = ParentCampaign.Id;
            cmp.Name = ParentCampaign.Name + ' - ' + cu.FirstName + ' ' + cu.LastName;
            cmp.IsActive = true;
            LoNewCampaigns.add(cmp);
        }
        system.debug('LoNewCampaigns size:: '+LoNewCampaigns.size());
        system.debug('LoNewCampaigns:: '+LoNewCampaigns);
        system.debug('*** end CreateCampaign:: ***');
        
        Database.SaveResult[] InsertResults = Database.insert(LoNewCampaigns);
        
        /* END: CREATE CHILD CAMPAIGNS */   
    }
    
    public static void CreateCampaignMembers(Id parentCampaignId, List<CustomUserObject> users, List<Oracle_Show_Booth_Contact__c> LoBoothContactsToAssign){
        Map<Id, CustomUserObject> MoUserIdToCustomUsers = new Map<Id, CustomUserObject>();
        
        for(CustomUserObject cu : users){
            MoUserIdToCustomUsers.put(cu.Id, cu);
        }
        
        List<Campaign> LoChildCampaigns = [Select Id, Name, ParentId, OwnerId From Campaign Where ParentId = :parentCampaignId  And Status = 'Planned' Order By Name];
        
        if (LoChildCampaigns != null)
        {
            if (LoChildCampaigns.size() > 0)
            {
                List<CampaignMember> LoNewCampMembers = new List<CampaignMember>();
                Integer MembersAssigned = 0;
                
                for(Campaign cmp : LoChildCampaigns)
                {
                    CustomUserObject CustomUser = MoUserIdToCustomUsers.get(cmp.OwnerId);
                    
                    if (CustomUser != null)
                    {
                        LoNewCampMembers.clear();
                        Integer BatchCount = 0;
                        
                        for(Integer i = 0; i < CustomUser.Count ; i++)
                        {
                            Oracle_Show_Booth_Contact__c Bc = LoBoothContactsToAssign[MembersAssigned];
                            
                            CampaignMember Mem = new CampaignMember();
                            Mem.CampaignId = cmp.Id;
                            Mem.ContactId = Bc.Contact__c;
                            Mem.Status = 'Planned';
                            
                            string PrimaryFlag = Bc.PRIMARY_FLAG__c;
                            
                            Mem.Primary_Contact__c = (PrimaryFlag != '' && PrimaryFlag != null && PrimaryFlag.toUpperCase() == 'Y' ? true : false);            
                            Mem.Exhibitor__c = Bc.Contact__r.Account.Id;
                            Mem.Booth__c = Bc.Oracle_Show_Booth__c;
                            
                            LoNewCampMembers.add(Mem);
                            BatchCount++;
                            MembersAssigned++;
                            
                            if (BatchCount == 199)
                            {
                                Database.insert(LoNewCampMembers);
                                BatchCount = 0;
                                LoNewCampMembers.clear();
                            }
                        } // End for
                        system.debug('LoNewCampMembers size:: '+LoNewCampMembers.size());
                        system.debug('LoNewCampMembers:: '+LoNewCampMembers);
                        if (BatchCount > 0)
                        {
                            Database.insert(LoNewCampMembers);
                            LoNewCampMembers.clear();
                            BatchCount = 0;
                        }
                    } //End If
                } //End for
            } //End If
        } // End if
    } // End Function
    
    

    
    public class LogisticsCampaignWrapper{
        @AuraEnabled
        public Campaign campaign;
        @AuraEnabled
        public Boolean hasOppty;
        @AuraEnabled
        public Integer totalShowContactCount;
        @AuraEnabled
        public Integer showContactCount;
        @AuraEnabled
        public Integer totalToAssignCount;
        @AuraEnabled
        public Double totalToAssignPercent;
        @AuraEnabled
        public String IncludeCustomersDomIntlValue;
        @AuraEnabled
        public List<User> listUser;
        @AuraEnabled
        public Integer NSFValue;
        @AuraEnabled
        public String ExcludeCustomersList;
        @AuraEnabled
        public String distributionMethod;
        @AuraEnabled
        public String NSFFilterOperator;
        @AuraEnabled
        public List<String> listProfilePicklist;
        @AuraEnabled
        public Map<String,String> mapNSFFilterOperatorPicklist;
        @AuraEnabled
        public Map<String,String> mapIncludeCustomerPicklist;
        @AuraEnabled
        public Map<String,String> mapSubsetByPicklist;
        @AuraEnabled
        public Map<String,String> mapUserSelectedPicklist;
        @AuraEnabled
        public Map<String,String> mapUserUnselectedPicklist;
        @AuraEnabled
        public List<UserWrapper> userWrapper;
        @AuraEnabled
        public List<Oracle_Show_Booth_Contact__c> listBoothContacts;
        
    }
    
    public class UserWrapper{
        @AuraEnabled
        public User user;
        @AuraEnabled
        public Boolean isChecked;
        @AuraEnabled
        public Integer count;
    }
}