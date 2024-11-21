public with sharing class LogisticsCampaignMemberAssignment {
    
    static final Integer MaxBatchSize = 200;
    static final Integer MaxDMLRows = 8000;
    static final Integer MaxQueryRows = 50000;
    
    public List<User> LoLogisticsUsers;
    public List<CustomUserObject> LoCustomUsers { get; set; }
    public List<CustomUserObject> LoCustomUsersPageSet { get; set; }
     
    public Campaign ParentCampaign {get; set;}
    public Integer TotalShowContactCount {get; set;} 
    public Integer ShowContactCount {get; set;}
    private List<Contact> LoShowContacts {get; set;}
    
    private Integer iTotalToAssignCount;
    
    public Integer TotalToAssignCount
    {
      get {return iTotalToAssignCount;} 
      set { 
        iTotalToAssignCount = value;
      }
    }
    
    private Decimal iTotalToAssignPercent;
    
    public Decimal TotalToAssignPercent
    {
      get {return iTotalToAssignPercent.setScale(5);} 
      set { 
        iTotalToAssignPercent = value;
      }
    }    
    
    public String RowUncheckAction {get; set;}
    public String RowCheckAction {get; set;}
    
    public Integer NSFValue {get; set;}
    public String NSFFilterOperator {get; set;}
    public String ExcludeCustomersList {get; set; }
    public String ExcludeOwnersList {get; set; }
    public String IncludeCustomersDomIntlValue {get; set;}  
    
    public Integer CurrentPageNumber {get; set;}
    private Integer CurrentPageSize;
    
    private String DefaultProfile = 'GES Service'; //'GES Exhibitor Sales';
    public Id UserId {get; set;}
    public Boolean CheckAll {get; set;}
    
    public List<Oracle_Show_Booth_Contact__c> LoBoothContactsToAssign = new List<Oracle_Show_Booth_Contact__c>();
    
    public LogisticsCampaignMemberAssignment() {
        
        DistributionMethod = 'Count';
        TotalToAssignPercent = 100;
        NSFValue = 400;
        IncludeCustomersDomIntlValue = '0';
        RowUncheckAction = '1';
        RowCheckAction = '1';
        CurrentPageNumber = 0;
        CurrentPageSize = 0;
        
        //ExcludeCustomersList = 'COVIDIEN,MILLENNIUM,FIDELITY,SCHERING,MERCK,BOEHRINGER'; --Bhargavi 12/5/2016
        ExcludeCustomersList = 'COVIDIEN,MILLENNIUM,FIDELITY,SCHERING,MERCK,BOEHRINGER,GENERAL DYNAMICS,NORDISK,TESARO,BRISTOL,VERTEX,NANOSTRING,NANOPORE,JDA,DENDREON,FUJIFILM,TAKEDA,PFIZER,WYETH';
        ExcludeOwnersList = '\'awithrow@ges.com\',\'dboncek@ges.com\',\'dbullock@ges.com\',\'efrankel@ges.com\',\'eloomis@ges.com\',\'jboy@ges.com\',\'jcarnahan@ges.com\',\'jkelleher@ges.com\',\'jnalbor@ges.com\',\'kwatson@ges.com\',\'leskievich@ges.com\',\'lkleidon@ges.com\',\'Llepley@ges.com\',\'mgoulter@ges.com\',\'msiconolfi@ges.com\',\'rniemeyer@ges.com\',\'sborne@ges.com\',\'tcampanaro@ges.com\',\'tiverson@ges.com\',\'vfratello@ges.com\',\'vsaia@ges.com\'';
        
        if (LoLogisticsUsers == null)
        {
            SetParentCampaign(ApexPages.currentPage().getParameters().get('Id'));
            LoLogisticsUsers = [Select Id, LastName, FirstName, Email From User Where Profile.Name = :DefaultProfile And IsActive = true And UserPermissionsSupportUser = true And Assign_Logistics_Campaign__c = true Order by FirstName, LastName];
            
            LoCustomUsers = new List<CustomUserObject>();
            LoCustomUsersPageSet = new List<CustomUserObject>();
            
            Integer added = 0;
        
          if (LoLogisticsUsers != null)
          {
              if (LoLogisticsUsers.size() > 0)
              {
                  for(User usr : LoLogisticsUsers)
                  {
                      CustomUserObject CustUsr = new CustomUserObject();
                      CustUsr.Id = usr.Id;
                      CustUsr.FirstName = usr.FirstName;
                      CustUsr.LastName = usr.LastName;
                      CustUsr.Email = usr.Email;
                      
                      LoCustomUsers.add(CustUsr);
                      added++;
                  }
                  
                  CurrentProfile = DefaultProfile;
                  TotalToAssignCount = ShowContactCount;
                  //Select checkbox for all users and populate counts 
                  SelectAllUsers(ShowContactCount);
                  
                  PageSize = 10; //Set default page size and build page set
                  
                  //Select CheckAll Flag
                  CheckAll = true;
              }
          }     
        }
    }
    
    /* START: POPULATE DROP-DOWN LIST VALUES */

    public List<SelectOption> getDistributionMethodOptions()
    {
        return (new List<SelectOption> {new SelectOption('Count', 'Count'), new SelectOption('Percent','%')});
    }
    
    public List<SelectOption> getPageSizeOptions()
    {
        List<SelectOption> PageSizeOptions = new List<SelectOption>();
        
        PageSizeOptions.add(new SelectOption('5','5'));
        PageSizeOptions.add(new SelectOption('10','10'));
        PageSizeOptions.add(new SelectOption('20','20'));
        PageSizeOptions.add(new SelectOption('30','30'));
        PageSizeOptions.add(new SelectOption('40','40'));
        PageSizeOptions.add(new SelectOption('50','50'));
        PageSizeOptions.add(new SelectOption('100','100'));
        PageSizeOptions.add(new SelectOption('200','200'));
        
        return PageSizeOptions;
    }
    
    public List<SelectOption> getProfileOptions()
    {
        List<SelectOption> Profiles = new List<SelectOption>();
        
        List<Profile> LoProfiles = [Select Id, Name From Profile Where Name = 'GES Service' Order By Name];
        
        if (LoProfiles != null)
        { 
            for(Profile p : LoProfiles)
            {
                Profiles.add(new SelectOption(p.name,p.name));
            }
        }
        
        LoProfiles.clear();
        LoProfiles = [Select Id, Name From Profile Where Name Like 'GES Exhibitor%' Order By Name];
        
        if (LoProfiles != null)
        { 
            for(Profile p : LoProfiles)
            {
                Profiles.add(new SelectOption(p.name,p.name));
            }
        }
        
        LoProfiles.clear();
        LoProfiles = [Select Id, Name From Profile Where (Not Name Like 'GES Exhibitor%') And Name != 'GES Service' Order By Name];
        
        if (LoProfiles != null)
        {
            Profiles.add(new SelectOption('---- Other Profiles ----','---- Other Profiles ----'));
             
            for(Profile p : LoProfiles)
            {
                Profiles.add(new SelectOption(p.name,p.name));
            }
        }       
        
        return Profiles;
    }
    
    public List<SelectOption> getNSFFilterOperatorOptions()
    {
        List<SelectOption> NSFOperatorOptions = new List<SelectOption>();
        
        NSFOperatorOptions.add(new SelectOption('<','Less Than'));
        NSFOperatorOptions.add(new SelectOption('>','Greater Than'));
        NSFOperatorOptions.add(new SelectOption('<=','Less Than Equal'));
        NSFOperatorOptions.add(new SelectOption('>=','Greater Than Equal'));
        NSFOperatorOptions.add(new SelectOption('=','Equal'));
        
        return NSFOperatorOptions;
    }
    
    public List<SelectOption> getRowUncheckActionOptions()
    {
        List<SelectOption> RowUncheckOptions = new List<SelectOption>();
        
        RowUncheckOptions.add(new SelectOption('0','Release'));
        RowUncheckOptions.add(new SelectOption('1','Distribute Evenly'));
        
        return RowUncheckOptions;
    }
    
    public List<SelectOption> getRowCheckActionOptions()
    {
        List<SelectOption> RowCheckOptions = new List<SelectOption>();
        
        RowCheckOptions.add(new SelectOption('0','None'));
        RowCheckOptions.add(new SelectOption('1','Distribute Evenly'));
        
        return RowCheckOptions;
    }
    
    public List<SelectOption> getIncludeCustomersDomIntlOptions()
    {
        List<SelectOption> DomIntlOptions = new List<SelectOption>();
        
        DomIntlOptions.add(new SelectOption('0','Domestic'));
        DomIntlOptions.add(new SelectOption('1','Canada'));        
        DomIntlOptions.add(new SelectOption('2','All'));
        DomIntlOptions.add(new SelectOption('3','International'));
        
        return DomIntlOptions;
    }  
    
    /* END: POPULATE DROP-DOWN LIST VALUES */    
    
    /* START: SYNC PROPERTIES WITH UI CHANGES */
            
    public String DistributionMethod {get; set; } 
    
    private String CurrentProfile;
    
    public String SelectedProfile {
        get { return CurrentProfile;} 
        set { 
              //This check is very important. Note, during postback all setter methods are 
              //executed along with any set methods. In this case, when checkbox is checked
              //postback occurs. If this check is not in place, the LoCustomUsers and PageSet
              //are rebuilt. You don't want that because it will cause users selection to
              //be voided.
              if (CurrentProfile != value) 
                refreshCustomUsersListProfileChanged(value);
                
              CurrentProfile = value;
            }
    } 
    
    /* END: SYNC PROPERTIES WITH UI CHANGES */   
       
    public Integer pageSize {get {return CurrentPageSize;} 
        set 
        {
            CurrentPageSize = value;
            CurrentPageNumber = 1;
            UpdatePageSet(CurrentPageSize);
        }
    }
      
    private void updatePageSet(Integer pageSize)
    {
        LoCustomUsersPageSet.clear();
        
        Integer added = 0;
                
        if (LoCustomUsers.size() > 0)
        {
            for(CustomUserObject usr : LoCustomUsers)
            {               
                if (added < pageSize)
                    LoCustomUsersPageSet.add(usr);
                
                added++;
            } 
        }       
    }
    
    public void setParentCampaign(Id campaignId)
    {
        if (ParentCampaign == Null)
        {
            ParentCampaign = [Select Id, Name, Status, Opportunity__c, ParentId From Campaign Where Id = :campaignId];
            ShowContactCount = FetchShowContactCount(0);          
        }
    }
    
    public void selectAllUsers(integer showContactCount)
    {
        if (LoCustomUsers != null)
        {
            if (LoCustomUsers.size() > 0)
            {
                Double Quotient = ShowContactCount/LoCustomUsers.size();
                Integer Remainder = Math.mod(ShowContactCount, LoCustomUsers.size());
                
                Integer FirstUserCount = (Integer)Quotient + Remainder;
                
                for(CustomUserObject c : LoCustomUsers)
                {
                    c.Count = (Integer)Quotient;
                    c.IsChecked = true;
                }
                
                for(CustomUserObject c : LoCustomUsers)
                {
                    if (Remainder == 0)
                        break;
                    c.Count++;
                    Remainder--;
                }
            }
        }
    }    
    
    public Integer FetchShowContactCount(Integer limitCount)
    {
      Integer ContactCount = 0;
      
        if (ParentCampaign != null && ParentCampaign.Opportunity__c != null)
        {
          //Get Total Show Contact Count
            String TotalShowContactCountQuery = 'Select Id, Contact__c, Oracle_Show_Booth__c, PRIMARY_FLAG__c, Contact__r.Account.Id From Oracle_Show_Booth_Contact__c ';
            TotalShowContactCountQuery += ' Where Oracle_Show_Booth__r.Show_Occurrence__c = \'' + ParentCampaign.Opportunity__c + '\'';
            //Based on research of production data, the PRIMARY_FLAG__c is not always checcked and the CONTACT_ROLE__c
            //is PRIMARY for majority of contacts. In some cases (perhaps many), a booth has multiple contacts but
            //none of them have PRIAMRY_FLAG__c checked and in contrast, some booths have only 1 contact and the
            //PRIMARY_FLAG__c is not checked. This criteria should not be used without further evaluation.
            //TotalShowContactCountQuery += ' And (Primary_Flag__c = \'Y\' Or CONTACT_ROLE__c = \'PRIMARY\')';
            TotalShowContactCountQuery += ' And (Oracle_Show_Booth__r.Account__r.Exhibitor_Account_Type__c = null Or (Oracle_Show_Booth__r.Account__r.Exhibitor_Account_Type__c != \'Program\' And Oracle_Show_Booth__r.Account__r.Exhibitor_Account_Type__c != \'Priority\'))';          
      TotalShowContactCountQuery += ' And (Not Oracle_Show_Booth__r.Account__r.Owner.Username In (' + ExcludeOwnersList + ')) And Oracle_Show_Booth__r.Inactive_Flag__c = False';  //Amarab 7/26/2017 to exclude inactive booths
      
      List<Oracle_Show_Booth_Contact__c> LoAllBoothContacts = Database.query(TotalShowContactCountQuery);
      
      if (LoAllBoothContacts != null)
        TotalShowContactCount = LoAllBoothContacts.size();
      
      /* 
        STEP 1: Check if there are child campaigns for this campaign and
            create a list of such campaigns
        
        STEP 2: If there are child campaigns, build a list of all contacts/members
            in another list.
      */
      
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
            
            /*
              If any of these Exhibitor(s) have open Non-Tradeshow Opportunities, exclude the 
              corresponding, booth from the list.
            */
            
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
              //See comments towards the top of this method
              //ConQuery += ' And (Primary_Flag__c = \'Y\' Or CONTACT_ROLE__c = \'PRIMARY\')';
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
            //   Booth Contacts selected for assignment must be selected using these rules (IDEALLY):
            //
            //   1. If a Booth has already been assigned on a child campaign, then it should
            //   not be assigned again. This condition is already addressed as the 
            //   query to retrieve "LoBoothContacts" already filters on unassigned booths
            //
            //   2. For all unassigned Booths, if a Customer has the same contact across 
            //   multiple booths, then select only one from those booths and the corresponding
            //   contact as Campaign Member
            //
            //   NOTE: This requirement cannot be fulfilled in currenct SFDC design of
            //   Campaign Member object as it does not allow a contact be added to more
            //   than 1 campaign member. Therefore, the list of contacts, regardless of
            //   Account needs to be deduped. If a contact represents more than 1 customer,
            //   use the first customer (or any one randomly) - the other customers are
            //   out of luck.
            //
            //   3. If a Customer and Contact combination has been assigned already, then don't
            //   assign it again.
            //   
            //   NOTE: Because of inability to fulfill requirement # 2, for this requirement
            //   consider only contact but not combinatino of accountid and contactid.
            
            /* This approach can't be used as same contact cannot be added to more than 1 campaign member
            
            String ConcatenatedAccountIdContactId = sbc.Oracle_Show_Booth__r.Account__c + ',' + sbc.Contact__c;
            
            if (!SoConcatenatedAccountIdContactId.contains(ConcatenatedAccountIdContactId) 
              && !SoAssignedConcatenatedAccountIdContactIds.contains(ConcatenatedAccountIdContactId))
            {
              SoConcatenatedAccountIdContactId.add(ConcatenatedAccountIdContactId);
              MoBthContIdToBthCont.put(sbc.Id, sbc);
              LoBoothContactsToAssign.add(sbc);
            }
            
            */
            
            //   The two conditions in if statement below remove:
            //
            //   1. Duplicates within the batch and 
            //   2. Remove Contacts already defined as contact members in any child campaign.
            //
            //   NOTE: The query to retrieve booth contacts filters Show Booth Contact object based 
            //   on unassigned Booths. However, a contact can exist across both assigned and 
            //   unassigned booth; therefore, such contact needs to be eliminated from the
            //   final list as well. The 2nd clause in the if statement below accomodates this 
            //   scenario.
            
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
        
        return ContactCount;    
    }
    
    private void refreshCustomUsersListProfileChanged(string profileName)
    {
        if (profileName != null && profileName != '')
        {
            LoLogisticsUsers = [Select Id, LastName, FirstName, Email From User Where Profile.Name = :profileName And IsActive = true And UserPermissionsSupportUser = true And Assign_Logistics_Campaign__c = true Order By FirstName, LastName];
            
            LoCustomUsers.clear(); // = new List<CustomUserObject>();
            LoCustomUsersPageSet.clear(); // = new List<CustomUserObject>();        
            
            Integer added = 0;
            
            if (LoLogisticsUsers != null)
            {
                if (LoLogisticsUsers.size() > 0)
                {
                    LoCustomUsers.clear();
                    
                    for(User usr : LoLogisticsUsers)
                    {
                        CustomUserObject CustUsr = new CustomUserObject();
                        CustUsr.Id = usr.Id;
                        CustUsr.FirstName = usr.FirstName;
                        CustUsr.LastName = usr.LastName;
                        CustUsr.Email = usr.Email;
                        
                        LoCustomUsers.add(CustUsr);
                        added++;
                    }
                    
                    //Select checkbox for all users and populate counts 
                    SelectAllUsers(TotalToAssignCount);
                    
                    PageSize = 10; //Set default page size and build page set
                    
                    //This is required because by default the global checkbox is unchecked 
                    //and it initiates a reset of the check for the first page of the list
                    CheckAll = true;
                }
            }
        }
    }    
        
    public Boolean hasNext
    {
        get {
          if (LoCustomUsers != null)
          {
              if (LoCustomUsers.size() > CurrentPageNumber * CurrentPageSize)
                  return true;
              else
                  return false;
          }
          else
            return false;
        }
        set;
    } 
    
    public Boolean hasPrevious
    {
        get {
            if (CurrentPageNumber > 1)
                return true;
            else
                return false;
        }
        set;
    }  
    
    public Integer pageNumber
    {
        get { return CurrentPageNumber; }
        set { CurrentPageNumber = value; }
    }
    
    public Boolean hasMultiplePages
    {               
        get {
          if (LoCustomUsers != null)
          {
                Double Pages = LoCustomUsers.size()/CurrentPageSize;
                Integer Rem = Math.mod(LoCustomUsers.size(), CurrentPageSize);
                
                if (Pages > 1 || (Pages == 1 && Rem > 0))
                    return true;
                else
                    return false;
          }
          else
            return false;
        }
        set;
    }        
    
    public void first()
    {
        CurrentPageNumber = 1;
        
        if (LoCustomUsers != null)
        {
          LoCustomUsersPageSet.clear();
          
          Integer LowerBound = 0;
          Integer UpperBound = (CurrentPageSize > LoCustomUsers.size() ? LoCustomUsers.size() : CurrentPageSize);
          
          for(Integer i = LowerBound; i < UpperBound; i++)
          {
              LoCustomUsersPageSet.add(LoCustomUsers[i]);
          }
        }
    }    
    
    public void last()
    {
      if (LoCustomUsers != null)
      {
          Double Rem = Math.mod(LoCustomUsers.size(), CurrentPageSize);
          
          if (Rem > 0)
              CurrentPageNumber = (LoCustomUsers.size()/CurrentPageSize) + 1;
          else
              CurrentPageNumber = LoCustomUsers.size()/CurrentPageSize;
          
          LoCustomUsersPageSet.clear();
          
          Integer LowerBound = (CurrentPageNumber - 1) * CurrentPageSize;
          Integer UpperBound = LoCustomUsers.size();
          
          for(Integer i = LowerBound; i < UpperBound; i++)
          {
              LoCustomUsersPageSet.add(LoCustomUsers[i]);
          }
      }
    } 
    
    public void previous()
    {
        CurrentPageNumber = Integer.valueOf(ApexPages.currentPage().getParameters().get('CurrentPageNumber'));
        CurrentPageNumber--;
        LoCustomUsersPageSet.clear();
        
        Integer LowerBound = (CurrentPageNumber - 1) * CurrentPageSize;
        Integer UpperBound = (CurrentPageNumber * CurrentPageSize > LoCustomUsers.size() ? LoCustomUsers.size() : CurrentPageNumber * CurrentPageSize);
        
        for(Integer i = LowerBound; i < UpperBound; i++)
        {
            LoCustomUsersPageSet.add(LoCustomUsers[i]);
        }
    } 
    
    public void next()
    {
        CurrentPageNumber = Integer.valueOf(ApexPages.currentPage().getParameters().get('CurrentPageNumber'));
        CurrentPageNumber++;
            
        LoCustomUsersPageSet.clear();
        
        Integer LowerBound = (CurrentPageNumber - 1)* CurrentPageSize;
        Integer UpperBound = (CurrentPageNumber * CurrentPageSize > LoCustomUsers.size() ? LoCustomUsers.size() : CurrentPageNumber * CurrentPageSize);
        
        for(Integer i = LowerBound; i < UpperBound; i++)
        {
            LoCustomUsersPageSet.add(LoCustomUsers[i]);
        }
    }
    
    public void CheckUncheckAll(Boolean value)
    {
        if (LoCustomUsersPageSet != null)
        {
            for(CustomUserObject cs : LoCustomUsersPageSet)
            {
                cs.IsChecked = value;
                
                if (!value)
                {
                    cs.Count = 0;
                }               
            }
        }
        
        if (!value)
        {       
            if (LoCustomUsers != null)
            {
                for(CustomUserObject cs: LoCustomUsers)
                {
                    cs.IsChecked = false;
                    cs.Count = 0;
                }
            }
        }
        
        //All Counts needs to be updated
        if (value)
        {   
            SelectAllUsers(showContactCount); //This will update LoCustomUsers with counts
            PageSize = 10; //This will sync up LoCustomUsersPageSet with update LoCustomUsers
        }       
    }
    
    public void selectAll()
    {
        CheckUncheckAll(true);
    }
    
    public void unselectAll()
    {
        CheckUncheckAll(false);
    }
        
    public PageReference rowCheckboxChanged()
    {        
        Id UserId = ApexPages.currentPage().getParameters().get('UserId');
        String CheckValue = ApexPages.currentPage().getParameters().get('CheckValue');
        
        //NOTE: CheckValue is a toggle and retrieves the current value of the IsChecked property
        //So, if value of item.IsChecked is false initially, CeckValue will be false and therefore 
        //the action was to Check the box. And vice-versa
        
        for(CustomUserObject c : LoCustomUsers)
        {           
            if (c.Id == UserId)
            {
                //Set Initial count of row to 0, regardless of if row is checked or unchecked
                c.Count = 0;
                
                //Initial IsChecked value is false, so action is Check
                if (CheckValue == null || CheckValue == '' || CheckValue == 'false')
                    c.IsChecked = true;
                else 
                    c.IsChecked = false;

                //Sync-up count in PageSet to the initial count
                for(CustomUserObject cps : LoCustomUsersPageset)
                {           
                    if (cps.Id == UserId)
                    {               
                        cps.Count = 0;              
                    }
                }               
                
                //If Row is checked/unchecked, apply the Row check/uncheck Action
                //which is to redistribute, if the default option is not selected.
                if ((!(RowCheckAction == '0') && c.IsChecked) || (!(RowUncheckAction == '0') && !c.IsChecked)) //When action is default action, do nothing
                {
                    //Distribute Rows equally among selected users
                    Redistribute();
                }
                
                //Also make sure the Select All and Clear all flag is appropriately set
                if (CheckAll && !c.IsChecked)
                    CheckAll = false;       
            }
        }
                
        return null;
    } 
    
    public PageReference rowCountChanged()
    {        
        Id UserId = ApexPages.currentPage().getParameters().get('UserId');
        Integer CountValue = 0; // ApexPages.currentPage().getParameters().get('CountValue');
        
        for(CustomUserObject c : LoCustomUsersPageset)
        {           
            if (c.Id == UserId)
            {               
                CountValue = c.Count;               
            }
        }       
        
        for(CustomUserObject c : LoCustomUsers)
        {           
            if (c.Id == UserId)
            {               
                c.Count = Integer.valueOf(CountValue);              
            }
        }
                
        return null;
    }
    
    public PageReference nsfFilterOperatorChanged()
    {
        NSFFilterOperator = ApexPages.currentPage().getParameters().get('operator');
        ShowContactCount = FetchShowContactCount(0);
        selectAllUsers(ShowContactCount);
        TotalToAssignCount = ShowContactCount;
        TotalToAssignPercent = 100; 
        CheckAll = true; //When Filter Operator is changed, all LoCustomUsers are selected, so this checkbox needs to be true;
        
        return null;
    }
    
    public PageReference includCustomersDomIntlChanged()
    {
        IncludeCustomersDomIntlValue = ApexPages.currentPage().getParameters().get('operator');
        ShowContactCount = FetchShowContactCount(0);
        selectAllUsers(ShowContactCount);
        TotalToAssignCount = ShowContactCount;
        TotalToAssignPercent = 100; 
        CheckAll = true; //When any filter is changed, all LoCustomUsers are selected, so this checkbox needs to be true;
              
      return null;
    }
    
    public PageReference distributionMethodChanged()
    {
      String Method = ApexPages.currentPage().getParameters().get('method');
        Integer Count = integer.valueOf(ApexPages.currentPage().getParameters().get('count'));
        Decimal Percent = decimal.valueOf(ApexPages.currentPage().getParameters().get('percent'));
                                
        if (Method.toUpperCase() == 'COUNT')
        {
            if (Count > showContactCount)
            {   
                TotalToAssignCount = showContactCount;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Count must be greater than 0 and less than or equal to ' + string.valueOf(showContactCount) + '.'));
                return null;
            }
            else
            {
              TotalToAssignCount = Count;
                ShrinkAssignedShowContactList(Count);
            }
        }
        else if (Method.toUpperCase() == 'PERCENT')
        {
            if (Percent <= 0 || Percent > 100)
            {
                TotalToAssignPercent = 100;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Percent must be greater than 0 and less than or equal to 100.'));
                return null;
            } 
            else
            {
              Integer NewCount = integer.valueOf(showContactCount * Percent / 100);
              TotalToAssignPercent = Percent;
                ShrinkAssignedShowContactList(NewCount);
            }       
        }
        return null;
    }
    
    private void ShrinkAssignedShowContactList(Integer Count)
    {
        if (LoCustomUsers != null)
        {
            List<CustomUserObject> NewLoCustomUsers = new List<CustomUserObject>();
            
            Integer UCount = LoCustomUsers.size() >= Count ? Count : LoCustomUsers.size();
            Integer LoopCount = 0;
            
            for(CustomUserObject cusr : LoCustomUsers)
            {
                NewLoCustomUsers.add(cusr);
                LoopCount++;
                
                if (LoopCount == Count)
                    break;                  
            }
            
            LoCustomUsers.clear();
            LoCustomUsers = NewLoCustomUsers;
            
            selectAllUsers(Count);
            TotalToAssignCount = Count;
            PageSize = 10;  
            CheckAll = true;
        }       
    }
    
    public PageReference nsfChanged()
    {
        Integer NSF = integer.valueOf(ApexPages.currentPage().getParameters().get('nsf'));
                              
        if (NSF < 0)
        {   
            NSFValue = 400;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Net Square Feet must be a positive integer.'));
            return null;
        }
        
        NSFValue = NSF;
        ShowContactCount = FetchShowContactCount(0);
        selectAllUsers(ShowContactCount);
        TotalToAssignCount = ShowContactCount;
        TotalToAssignPercent = 100; 
        CheckAll = true; //When Filter Operator is changed, all LoCustomUsers are selected, so this checkbox needs to be true;      

        return null;
    }
    
    public PageReference customersToExcludeChanged()
    {
        String ExcludeCustomers = ApexPages.currentPage().getParameters().get('excludeCustomers');
        ExcludeCustomersList = ExcludeCustomers;
        
        ShowContactCount = FetchShowContactCount(0);
        selectAllUsers(ShowContactCount);
        TotalToAssignCount = ShowContactCount;
        TotalToAssignPercent = 100; 
        CheckAll = true; //When Filter Operator is changed, all LoCustomUsers are selected, so this checkbox needs to be true;      

        return null;
    }
    
      
    
    public PageReference Redistribute() {
        
        try {
            
            List<CustomUserObject> SelectedUsers = new List<CustomUserObject>();
            Integer ContactCount = TotalToAssignCount;
            
            for(CustomUserObject c : LoCustomUsers)
            {               
                if (c.IsChecked)
                    SelectedUsers.add(c);
            }
            
            Double Quotient = ContactCount/SelectedUsers.size();
            Integer Remainder = Math.mod(ContactCount, SelectedUsers.size());
            
            for(CustomUserObject c : SelectedUsers)
            {
                c.Count = (Integer)Quotient;
            }
                
            for(CustomUserObject c : SelectedUsers)
            {
                if (Remainder == 0)
                    break;
                c.Count++;
                Remainder--;
            }
            
            Map<Id, CustomUserObject> MoUserIdToUser = new Map<Id, CustomUserObject>();
            
            for(CustomUserObject c : SelectedUsers)
            {
                MoUserIdToUser.put(c.Id, c);
            }
            
            for(CustomUserObject c : LoCustomUsersPageSet)
            {
                if (MoUserIdToUser.containsKey(c.Id))
                    c.Count = MoUserIdToUser.get(c.Id).Count;
            }       
        
        }
        catch(Exception e)
        {
            ApexPages.addMessages(e);
        }
        
        PageReference p = ApexPages.currentPage();
        
        return p;
    }
    
    public void Assign()
    {
      Integer CountOfSelectedUsers = 0;
      
      for(CustomUserObject cu : LoCustomUsers)
      {
        if (cu.IsChecked)
          CountOfSelectedUsers++;
      }
      
      if (CountOfSelectedUsers <= 0 || LoBoothContactsToAssign.size() <= 0) //if (showContactCount <= 0)
      {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Either no user(s) selected or there is no contact to assign.'));
      }
      else
      {
        CreateCampaign(ParentCampaign.Id, LoCustomUsers);
        CreateCampaignMembers(ParentCampaign.Id, LoCustomUsers);
        ShowContactCount = FetchShowContactCount(0);
          TotalToAssignCount = ShowContactCount;
          TotalToAssignPercent = 100;         
        Redistribute();
      }
    }
    
    public void CreateCampaign(Id parentCampaignId, List<CustomUserObject> users)
    {           
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
      
      for(CustomUserObject cu : LoUsersNeedingNewCampaigns)
      {
        Campaign cmp = new Campaign();
        cmp.OwnerId = cu.Id;
        cmp.ParentId = ParentCampaign.Id;
        cmp.Name = ParentCampaign.Name + ' - ' + cu.FirstName + ' ' + cu.LastName;
        cmp.IsActive = true;
        LoNewCampaigns.add(cmp);
      }
      
      Database.SaveResult[] InsertResults = Database.insert(LoNewCampaigns);
      
      /* END: CREATE CHILD CAMPAIGNS */   
    }
    
    public void CreateCampaignMembers(Id parentCampaignId, List<CustomUserObject> users)
    {
      Map<Id, CustomUserObject> MoUserIdToCustomUsers = new Map<Id, CustomUserObject>();
      
      for(CustomUserObject cu : users)
      {
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
    
    /*
    public List<Oracle_Show_Booth_Contact__c> SortListOfBoothContactsAsc(List<Oracle_Show_Booth_Contact__c> loBC)
    {
      List<Oracle_Show_Booth_Contact__c> SortedList = new List<Oracle_Show_Booth_Contact__c>();
            
      return SortedList;
    }
    */
}