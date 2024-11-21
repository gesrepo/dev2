public without sharing class GC_Connect2ShowViewController {
    
    public GC_Connect2_Show__c show {get; set;}
    public Boolean isOnShow {get; set;}
    public Boolean isSysAdmin {get; set;}
    public List<SelectOption> showRoles {get; set;}
    public String selectedRole {get; set;}
    public String showList {get; set;} // SAL-568
    public GC_Task_Field_Manager__c taskField {get; set;}
    public string displayOption {get; set;}
    private Id connect2ShowId;
    
    public GC_Connect2ShowViewController(ApexPages.StandardController stdController) {
        connect2ShowId = stdController.getId();
        showList= 'true';
        displayOption = 'Shown';
        try{
            taskField = [SELECT Id,Background__c,Booth_Area_Discount__c,Budget_Code__c,Client_Layout_Notes__c,Completion_Date_Time__c,Connect2_Show__c,
            Copy_Placement__c,Default_Completion_Date_Time__c,Default_Installation_Delivery_Date_Time__c,Default_Removal_Date_Time__c,
            Delivery_Area__c,File_Reference_Link_Folder__c,Installation_Delivery_Date_Time__c,Installation_Method__c,Onsite_Contact_Person__c
            ,Onsite_Contact_Person_Number__c,Outdoors__c,Price__c,Removal_Date_Time__c,Save_Signs__c,Sign_Copy__c,Sign_Title__c,Sign_Type__c,
            Sign_Type_Other__c,Single_Double_Sided__c,Special_Instructions_Client_Remarks__c,User_Item_Description__c ,Hide_Order_Level_File_Upload__c FROM GC_Task_Field_Manager__c WHERE Connect2_Show__c =:connect2ShowId LIMIT 1];
            system.debug(taskField);
        }catch (exception e){
            taskField= new GC_Task_Field_Manager__c();
            taskField.Connect2_Show__c = connect2ShowId;
            taskField.User__c= UserInfo.getUserId();
        }
        try{
            show = GC_Connect2ShowDao.getInstance().getConnect2ShowById(stdController.getId());
            if(String.isNotBlank(show.job_number__c)){
                if( show.job_number__c.indexOf('000')<0){
                    showList= 'true';
                }else{
                    showList= 'false';
                }
            }
        }catch(exception e){
            GC_PageUtil.AddErrorMessage('There is no valid ID for the show to be displayed. Please check the URL and try going back to get a proper URL.');
            return;
        }        
        isOnShow = false;
        isSysAdmin = false;
        
        // Find out if the current user is on the show, if so set the flag and return;
        checkIsAdmin();        
        
        if (isSysAdmin) {
            return;
        }
        
        checkIsOnShow();
        
        if (isOnShow) {
            return;
        }
        showRoles = new List<SelectOption>();
        SelectOption noneSelectOption = new SelectOption('', '---None---');
        showRoles.add(noneSelectOption);
        
        User currentUser = [select Id, Name, GC_Show_Role__c from User where Id = :UserInfo.getUserId()];
        
        for (String role : currentUser.GC_Show_Role__c.split(';')) {
            String allowedRole = role.replace('GC ', '');
            //SAL-506
            if(System.Label.GC_Label_ProfileToAdd.contains(allowedRole)){
                SelectOption roleOption1 = new SelectOption(System.Label.GC_Label_AccMgrProfile,System.Label.GC_Label_AccMgrProfile);
                showRoles.add(roleOption1);
            }
            SelectOption roleOption = new SelectOption(allowedRole, allowedRole);
            showRoles.add(roleOption);
        }
        
    }
    
    public void checkIsAdmin() {
        // If sysadmin set the flag and return, display page completely.
        Map<Id, Profile> adminProfiles = new Map<Id, Profile>([select Id, Name from Profile where Name like '%System Admin%']);
        
        if (adminProfiles.containsKey(UserInfo.getProfileId())) {
            isSysAdmin = true;
        }
        
    }
    
    
    public void checkIsOnShow() {
        // If sysadmin set the flag and return, display page completely.
        List<GC_Show_Team_Member__c> showTeamMembers = [select Id, Name, User__c from GC_Show_Team_Member__c where User__c = :UserInfo.getUserId() AND Connect2_Show__c = :show.Id];
        
        isOnShow = showTeamMembers.size() > 0;
        //if (String.isNotBlank(show.Show_Team_Member_Ids__c) && show.Show_Team_Member_Ids__c.contains(UserInfo.getUserId())) {
        //    isOnShow = true;
        //}
    }
    
    public PageReference addCurrentUserToShow() {
        if (String.isBlank(selectedRole)) {
            GC_PageUtil.AddErrorMessage('You must select a Role on the show.  Allowed roles are defined by your system administrator.');
            return null;
        }
        
        try {
            GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c();
            stm.User__c = UserInfo.getUserId();
            stm.Show_Role__c = selectedRole;
            stm.Connect2_Show__c = show.Id;
            insert stm;
        } catch (Exception e) {
            GC_PageUtil.AddErrorMessage('Failed to add the current user to the show. ' + e.getMessage());
            return null;
        }
        
        // Requery to get updated information
        show = GC_Connect2ShowDao.getInstance().getConnect2ShowById(show.Id);
        checkIsOnShow();
        return null;
    }
    
    public List<SelectOption> getDisplayOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Hidden', ''));
        options.add(new SelectOption('Shown and Required', ''));
        return options;
    }
    
     public List<SelectOption> getHiddenOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Hidden', ''));
         return options;
    }
    
    private GC_Task_Field_Manager__c getTaskFieldForShow(){
        GC_Task_Field_Manager__c records =   [SELECT Id,Background__c,Booth_Area_Discount__c,Budget_Code__c,Client_Layout_Notes__c,Completion_Date_Time__c,Connect2_Show__c,Copy_Placement__c,Default_Completion_Date_Time__c,Default_Installation_Delivery_Date_Time__c,Default_Removal_Date_Time__c,Delivery_Area__c,File_Reference_Link_Folder__c,Installation_Delivery_Date_Time__c,Installation_Method__c,Onsite_Contact_Person__c,Onsite_Contact_Person_Number__c,Outdoors__c,Price__c,Removal_Date_Time__c,Save_Signs__c,Sign_Copy__c,Sign_Title__c,Sign_Type__c,Sign_Type_Other__c,Single_Double_Sided__c,Special_Instructions_Client_Remarks__c,User_Item_Description__c,Hide_Order_Level_File_Upload__c FROM GC_Task_Field_Manager__c WHERE Connect2_Show__c =:connect2ShowId LIMIT 1];
        return records;
    }
    
    public PageReference saveDisplayOptions(){
        try{
            upsert taskField;
        }        
        catch (DmlException e) {
            GC_PageUtil.AddErrorMessage(e.getStackTraceString());
            return null;
        }
        //system.debug('taskField----->'+taskField);
        PageReference pr = Page.GC_Connect2ShowView;
        pr.getParameters().put('id', connect2ShowId);
        pr.setRedirect(true);
        return null;
    }
    
    public PageReference resetDisplayOptions(){
        //get all the fields of the object
        SObjectType objToken = Schema.getGlobalDescribe().get('GC_Task_Field_Manager__c');
        DescribeSObjectResult objDef = objToken.getDescribe();
        
        SObject sTaskField = (SObject)taskField;
        // make all the fields as Shown
        for (String key : objDef.fields.getMap().keySet()) {
            if(key.contains('__c') && (key !='User__c' && key!='Connect2_Show__c' && key!='Hide_Order_Level_File_Upload__c')){
                sTaskField.put(key,'Shown');
            }
            
        }
        sTaskField.put('User__c',UserInfo.getUserId());
        sTaskField.put('Hide_Order_Level_File_Upload__c',false);
        update taskField;
        System.debug('taskField---------' + taskField);
        return null;
    }
}