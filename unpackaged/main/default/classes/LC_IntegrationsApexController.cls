public without sharing class LC_IntegrationsApexController {
    
    //Wrapper for ExhibitorInfo to remove nulls
    public class ExhibitorInfoWrapper {
        
        @AuraEnabled public String Address;
        
        @AuraEnabled public String City;
        
        @AuraEnabled public String CompanyName;
        
        @AuraEnabled public String Country;
        
        @AuraEnabled public String CustomerNumber;
        
        @AuraEnabled public String EmailAddress;
        
        @AuraEnabled public String FirstName;
        @AuraEnabled public String LastName;
        @AuraEnabled public String PhoneNumber;
        @AuraEnabled public String PostalCode;
        @AuraEnabled public String State;
        
        
        
        public ExhibitorInfoWrapper(wwwViadComV1_all.ExhibitorInfo exInfo){
            this.Address        =       (exInfo.Address!= null ? exInfo.Address: '');
            this.City           =       (exInfo.City!= null ? exInfo.City: '');
            this.CompanyName    =       (exInfo.CompanyName!= null ? exInfo.CompanyName: '');
            this.Country        =       (exInfo.Country!= null ? exInfo.Country: '');
            this.CustomerNumber =       (exInfo.CustomerNumber!= null ? exInfo.CustomerNumber: '');
            this.EmailAddress   =       (exInfo.EmailAddress!= null ? exInfo.EmailAddress: '');
            this.FirstName      =       (exInfo.FirstName!= null ? exInfo.FirstName: '');
            this.LastName       =       (exInfo.LastName!= null ? exInfo.LastName: '');
            this.PhoneNumber    =       (exInfo.PhoneNumber!= null ? exInfo.PhoneNumber: '');
            this.PostalCode     =       (exInfo.PostalCode!= null ? exInfo.PostalCode: '');
            this.State          =       (exInfo.State!= null ? exInfo.State: '');
        }
    }
    
    public class OrderProSumWrapper {
        @AuraEnabled public String ExhbitorsWithOrdersCount;
        @AuraEnabled public String ExhibitorsCount;
        @AuraEnabled public String Percentage;
        @AuraEnabled public String OrderDueDate;
        @AuraEnabled public String ProjectNumber;
        @AuraEnabled public String ShowName;
        
        public OrderProSumWrapper(wwwViadComV1_all.OrderProgressSummary OrderProgressSummary){
            this.ExhbitorsWithOrdersCount   =   String.valueOf((OrderProgressSummary.ExhbitorsWithOrdersCount!= null ? OrderProgressSummary.ExhbitorsWithOrdersCount: 0));
            this.ExhibitorsCount            =   String.valueOf((OrderProgressSummary.ExhibitorsCount!= null ? OrderProgressSummary.ExhibitorsCount: 0));
            if(OrderProgressSummary.OrderDueDate!=null){
                this.OrderDueDate= OrderProgressSummary.OrderDueDate.format();
            }else{
                this.OrderDueDate           =   '';
            }
            this.ProjectNumber              =   (OrderProgressSummary.ProjectNumber!= null ? OrderProgressSummary.ProjectNumber: '');
            this.ShowName                   =   (OrderProgressSummary.ShowName!= null ? OrderProgressSummary.ShowName: '');
            if(OrderProgressSummary.ExhibitorsCount!=0){
                Decimal orderedCount = Decimal.valueOf(String.valueOf(OrderProgressSummary.ExhbitorsWithOrdersCount))*100;
                Decimal totalCount = Decimal.valueOf(String.valueOf(OrderProgressSummary.ExhibitorsCount));
                //Decimal percent= orderedCount.divide(totalCount, 2);
                this.percentage             =   String.valueOf(orderedCount.divide(totalCount, 2))+'%';
            }else{
                this.percentage             =   'Can not be defined';
            }
            
        }
    }
    
    public class showAndExListWrapper {
        @AuraEnabled
        public List<ExhibitorInfoWrapper> ExInfoWrapList;
        @AuraEnabled
        public List<OrderProSumWrapper> OrProSumWrap;
        @AuraEnabled
        public string errMsg;
    }
    
    /* Methods to be used for ExhibitorShowProgress report -Report1*/
    //method to separate values from ExhibitorOrderShowProgress 
    @AuraEnabled
    public static showAndExListWrapper deserializeExOrProReport(wwwViadComV1_all.ShowInstanceOrderProgress recievedObject){
        List<wwwViadComV1_all.ExhibitorInfo> ExhibitorInfo = new List<wwwViadComV1_all.ExhibitorInfo>();
        List<ExhibitorInfoWrapper> ExInfoWrapList = new List<ExhibitorInfoWrapper>();
        ExhibitorInfo = recievedObject.ExhibitorsWithoutOrders.ExhibitorInfo;
        showAndExListWrapper wrapper = new showAndExListWrapper();
        String [] ExhibitorsWithoutOrdersEmailList = recievedObject.ExhibitorsWithoutOrdersEmailList.string_x;
        // the following contains ExhbitorsWithOrdersCount;ExhibitorsCount; OrderDueDate; ProjectNumber; ShowName
        wwwViadComV1_all.OrderProgressSummary OrderProgressSummary = recievedObject.OrderProgressSummary;
        if(OrderProgressSummary!=null){
            OrderProSumWrapper OrProSumWrap = new OrderProSumWrapper(OrderProgressSummary);
            wrapper.OrProSumWrap= new List<OrderProSumWrapper>();
            wrapper.OrProSumWrap.add(OrProSumWrap);
        }
        if(ExhibitorInfo.size()>0){
            for(wwwViadComV1_all.ExhibitorInfo exInfo: ExhibitorInfo){
                ExhibitorInfoWrapper exInforWrap= new ExhibitorInfoWrapper(exInfo);
                ExInfoWrapList.add(exInforWrap);
                //system.debug('exInforWrap==='+exInforWrap);
            }
            wrapper.ExInfoWrapList = ExInfoWrapList;
        }  
        return wrapper;
    }
    
    
    
    // Method to get an expresso session ID
    @AuraEnabled
    public static string getExSessionID() {
        GC_Core_Session__c exSessionObject;
        List<GC_Core_Session__c> existingSessionObjects = [SELECT Id, Expresso_Session_ID__c, Expresso_Session_Expiration__c, Expresso_Session_Error_Message__c FROM GC_Core_Session__c WHERE OwnerId = :UserInfo.getUserId() order by LastModifiedDate desc];
        system.debug('existingSessionObjects===='+existingSessionObjects);  
        if(existingSessionObjects.size()==0){
            if(Test.isRunningTest()){
                Test.setMock(WebServiceMock.class, new ACCC_wwwViadComSecurityV2Vaccc_Mock()); 
            }
            exSessionObject = new GC_Core_Session__c();
            wwwViadComSecurityV2Vaccc.BasicHttpBinding_IAuthenticationService appSecurity = new wwwViadComSecurityV2Vaccc.BasicHttpBinding_IAuthenticationService();
            //appSecurity.endpoint_x =  'https://uatapi.viad.com/Security/v2/AuthenticationService.svc' ;
            wwwViadComSecurityV2Vaccc.AppSessionInfo responseAppSessionInfo = appSecurity.StartAppSession(System.Label.GC_Label_AppID,  System.Label.GC_Label_AppKey, '', '');
            exSessionObject.Expresso_Session_ID__c= responseAppSessionInfo.SessionID;
            exSessionObject.Expresso_Session_Expiration__c= responseAppSessionInfo.Expiration;
            if(!Test.isRunningTest()){
                upsert exSessionObject;
            }
            
            system.debug('creating and returning a new session==='+exSessionObject); 
            
        }
        else{
            exSessionObject = existingSessionObjects.get(0);
            if(exSessionObject.Expresso_Session_Expiration__c == null || exSessionObject.Expresso_Session_Expiration__c < DateTime.Now()){
                
                //exSessionObject = new GC_Core_Session__c();
                wwwViadComSecurityV2Vaccc.BasicHttpBinding_IAuthenticationService appSecurity = new wwwViadComSecurityV2Vaccc.BasicHttpBinding_IAuthenticationService();
                //appSecurity.endpoint_x =  'https://uatapi.viad.com/Security/v2/AuthenticationService.svc' ;
                wwwViadComSecurityV2Vaccc.AppSessionInfo responseAppSessionInfo = appSecurity.StartAppSession(System.Label.GC_Label_AppID,  System.Label.GC_Label_AppKey, '', '');
                exSessionObject.Expresso_Session_ID__c= responseAppSessionInfo.SessionID;
                exSessionObject.Expresso_Session_Expiration__c= responseAppSessionInfo.Expiration;
                //system.debug('Returning a created session Id');
                system.debug('session expired, creating, updating and then returning===');
                upsert exSessionObject;
                return exSessionObject.Expresso_Session_ID__c;
                //}
            }
            else{
                system.debug('returning existing session===');
                exSessionObject = existingSessionObjects.get(0);
            }
        }
        return exSessionObject.Expresso_Session_ID__c;
    }
    
    // using remote action for generating reports with view state much larger than 135 KB
    
    @AuraEnabled
    public static showAndExListWrapper getReport(String projectNumber){
        
        GC_Show_Team_Member__c teamMember = new GC_Show_Team_Member__c();
        showAndExListWrapper reportWrapper = new showAndExListWrapper();
        String ApplicationID   = System.Label.GC_Label_AppID ;
        String ApplicationKey  = System.Label.GC_Label_AppKey;
        
        try{
            GC_Connect2_Show__c show =[SELECT Id, Name, Show_End_Date__c ,Show_Start_Date__c,Show_Name__c, Opportunity_Name__c,Facility__c, Job_Number__c FROM GC_Connect2_Show__c WHERE Job_Number__c=:projectNumber];
            String userID= UserInfo.getUserId();
            teamMember = [Select id, Show_Analytics_Role__c from GC_Show_Team_Member__c where User__c= :userID AND Connect2_Show__r.Job_Number__c=:projectNumber Limit 1];
        }catch(Exception e){}       
        
        if(teamMember.Show_Analytics_Role__c || System.Label.GC_Label_ProfilesForAnalytics.contains(UserInfo.getProfileId())){
            try{
                wwwViadComSecurityV2Vaccc.BasicHttpBinding_IAuthenticationService appSecurity = new wwwViadComSecurityV2Vaccc.BasicHttpBinding_IAuthenticationService();
                //wwwViadComSecurityV2Vaccc.AppSessionInfo responseAppSessionInfo = appSecurity.StartAppSession(ApplicationID,  ApplicationKey, '', '');
                String sessionId= getExSessionID();
                wwwViadComV1_all.BasicHttpBinding_IExhibitorService IExhibitorServiceObject= new wwwViadComV1_all.BasicHttpBinding_IExhibitorService(); 
                if(Test.isRunningTest()){
                    Test.setMock(WebServiceMock.class, new wwwViadComV1_allMockImpl()); 
                }
                
                wwwViadComV1_all.ShowInstanceOrderProgress reportObject= IExhibitorServiceObject.GetExhibitorOrderProgress(sessionId,projectNumber);
                
                // deserialize the recieved response 
                reportWrapper = deserializeExOrProReport(reportObject);             
                
            }catch(exception e){
                reportWrapper.errMsg= e.getMessage();
                system.debug('error is==='+e.getMessage());
                system.debug('error at==='+e.getStackTraceString());
            }
            
            
        }else{
            reportWrapper.errMsg='Please contact your GES Account Manager for Analytics access. Thank You!';
        }
        //String jsonReportString = JSON.serialize(reportWrapper);
        //system.debug('reportWrapper==='+reportWrapper); 
        return reportWrapper;
    }
    
    /* Methods to be used for ExhibitorFormProgress report -Report2*/
    @AuraEnabled
    public static ExOrProReportWrapper GetExhibitorFormProgress(String projectNumber){
        String userID= UserInfo.getUserId();
        String ApplicationID   = System.Label.GC_Label_AppID ;
        String ApplicationKey  = System.Label.GC_Label_AppKey;
        ExOrProReportWrapper reportWrapper = new ExOrProReportWrapper();
        GC_Show_Team_Member__c teamMember = new GC_Show_Team_Member__c();
        try{
            GC_Connect2_Show__c show = [SELECT Id, Name, Show_End_Date__c ,Show_Start_Date__c,Show_Name__c, Opportunity_Name__c,Facility__c, Job_Number__c FROM GC_Connect2_Show__c WHERE Job_Number__c=:projectNumber];
            
            teamMember = [Select id, Show_Analytics_Role__c from GC_Show_Team_Member__c where User__c= :userID AND Connect2_Show__r.Job_Number__c=:projectNumber Limit 1];
        }catch(Exception e){
            system.debug('e==='+e.getMessage());
            reportWrapper.errMsg=e.getMessage();
        } 
        
        if(teamMember.Show_Analytics_Role__c || System.Label.GC_Label_ProfilesForAnalytics.contains(UserInfo.getProfileId()) ){
            try{ 
                wwwViadComSecurityV2Vaccc.BasicHttpBinding_IAuthenticationService appSecurity = new wwwViadComSecurityV2Vaccc.BasicHttpBinding_IAuthenticationService();
                String sessionId=getExSessionID();
                if(Test.isRunningTest()){
                    Test.setMock(WebServiceMock.class, new wwwViadComV1_allMockImpl()); 
                }
                wwwViadComV1_all.BasicHttpBinding_IExhibitorService IExhibitorServiceObject= new wwwViadComV1_all.BasicHttpBinding_IExhibitorService(); 
                wwwViadComV1_all.ShowFormProgressStatus reportObject= IExhibitorServiceObject.GetExhibitorFormProgress(sessionId,projectNumber);
                
                reportWrapper = deserializeExFoProReport(reportObject); 
                reportObject =  new wwwViadComV1_all.ShowFormProgressStatus();      
                
            }catch(exception e){
                reportWrapper.errMsg=e.getMessage();
                system.debug('e==='+e.getMessage());
                system.debug('error at===='+e.getStackTraceString());
                
                
            }
            
            
        }else{
            reportWrapper.errMsg='Please contact your GES Account Manager for Analytics access. Thank You!';
        }
        //String jsonReportString = JSON.serialize(reportWrapper);
        //system.debug('jsonReportString==='+jsonReportString);
        return reportWrapper;
    }
    
    //method to deserialize the response object recieved from Expresso
    @AuraEnabled
    public static ExOrProReportWrapper deserializeExFoProReport(wwwViadComV1_all.ShowFormProgressStatus recievedObject){
        ExOrProReportWrapper reportWrapper = new ExOrProReportWrapper();
        List<ExhibitorFormProgressWrapper> exFormWrapList = new List<ExhibitorFormProgressWrapper>();
        List<ShowFormProgressWrapper> showFormWrapList = new List<ShowFormProgressWrapper>();
        List<wwwViadComV1_all.ExhibitorFormProgress> ExhibitorFormProgress = new List<wwwViadComV1_all.ExhibitorFormProgress>();
        ExhibitorFormProgress= recievedObject.ExhibitorFormProgress.ExhibitorFormProgress;
        List<wwwViadComV1_all.ShowFormProgress> ShowFormProgress = new List<wwwViadComV1_all.ShowFormProgress>();
        ShowFormProgress = recievedObject.ShowFormProgress.ShowFormProgress;
        system.debug('ExhibitorFormProgress.size==='+ExhibitorFormProgress.size());
        if(ExhibitorFormProgress.size()>0){
            for(wwwViadComV1_all.ExhibitorFormProgress exForm: ExhibitorFormProgress){
                ExhibitorFormProgressWrapper exFormWrap= new ExhibitorFormProgressWrapper(exForm);
                exFormWrapList.add(exFormWrap);
            }
            reportWrapper.ExFoProWrapList = exFormWrapList;
        }  
        
        if(ShowFormProgress.size()>0){
            for(wwwViadComV1_all.ShowFormProgress showForm: ShowFormProgress){
                ShowFormProgressWrapper showFormWrap= new ShowFormProgressWrapper(showForm);
                showFormWrapList.add(showFormWrap);
                system.debug('showFormWrap==='+showFormWrap);
            }
            reportWrapper.ShowFormProWrapList = showFormWrapList;
        }
        return reportWrapper;
    }
    
    public class ExOrProReportWrapper {
        @AuraEnabled public List<ExhibitorFormProgressWrapper> ExFoProWrapList;
        @AuraEnabled public List<ShowFormProgressWrapper> ShowFormProWrapList;
        @AuraEnabled public string errMsg;
    }
    
    public class ExhibitorFormProgressWrapper{
        @AuraEnabled public String BoothNumber;
        @AuraEnabled public String CustomerName;
        @AuraEnabled public String CustomerNumber;
        @AuraEnabled public String FormTitle;
        @AuraEnabled public String Submitted; 
        
        public ExhibitorFormProgressWrapper(wwwViadComV1_all.ExhibitorFormProgress exForPro){
            this.BoothNumber        =       (exForPro.BoothNumber!= null ? exForPro.BoothNumber: '');
            this.CustomerName       =       (exForPro.CustomerName!= null ? exForPro.CustomerName: '');
            this.CustomerNumber     =       (exForPro.CustomerNumber!= null ? exForPro.CustomerNumber: '');
            this.FormTitle          =       (exForPro.FormTitle!= null ? exForPro.FormTitle: '');
            this.Submitted          =       (exForPro.Submitted!= null ? exForPro.Submitted: '');
        }
    }
    
    public class ShowFormProgressWrapper{
        @AuraEnabled public String FormTitle;
        @AuraEnabled public String ProjectNumber;
        @AuraEnabled public String ShowName;
        @AuraEnabled public Integer Submitted;
        @AuraEnabled public Integer Total; 
        @AuraEnabled public String percentage;
        
        public ShowFormProgressWrapper(wwwViadComV1_all.ShowFormProgress  showFormPro){
            this.FormTitle          =       (showFormPro.FormTitle!= null ? showFormPro.FormTitle: '');
            this.ProjectNumber      =       (showFormPro.ProjectNumber!= null ? showFormPro.ProjectNumber: '');
            this.ShowName           =       (showFormPro.ShowName!= null ? showFormPro.ShowName: '');
            this.Submitted          =       (showFormPro.Submitted!= null ? showFormPro.Submitted: 0);
            this.Total              =       (showFormPro.Total!= null ? showFormPro.Total: 0);
            if(showFormPro.Total!=0){
                Decimal orderedCount = Decimal.valueOf(String.valueOf(showFormPro.Submitted))*100;
                Decimal totalCount = Decimal.valueOf(String.valueOf(showFormPro.Total));
                //Decimal percent= orderedCount.divide(totalCount, 2);
                this.percentage             =   String.valueOf(orderedCount.divide(totalCount, 2))+'%';
            }else{
                this.percentage             =   'Can not be defined';
            }
        }
    }
    /* Methods to be used for ExhibitorFormProgress report till here -Report2*/
    
    /* Methods to be used for ExhibitorOrderTypeStatus report --report3*/
    @AuraEnabled
    public static ExOrCatReportWrapper GetExhibitorOrderTypeStatus(String projectNumber, date startDate, date endDate){
        //Date startDate= Date.valueOf(startDateStr);
        //Date endDate= Date.valueOf(endDateStr);
        system.debug('startDate=='+startDate);
        system.debug('endDate=='+endDate);
        Boolean validationFlag =validateUser(projectNumber);
        String expressoSessionId=getExSessionID();
        ExOrCatReportWrapper reportWrapper = new ExOrCatReportWrapper();            
        if(validationFlag){
            try{
                if(Test.isRunningTest()){
                    Test.setMock(WebServiceMock.class, new wwwViadComV1_allMockImpl()); 
                }
                wwwViadComV1_all.BasicHttpBinding_IExhibitorService IExhibitorServiceObject= new wwwViadComV1_all.BasicHttpBinding_IExhibitorService(); 
                wwwViadComV1_all.ArrayOfExhibitorOrderTypeStatus  reportObject= IExhibitorServiceObject.GetExhibitorOrderTypeStatus(expressoSessionId,projectNumber, startDate, endDate);
                reportWrapper = deserializeExOrCatReport(reportObject);             
                
            }catch(exception e){
                system.debug('error message==='+e.getMessage()); 
                reportWrapper.errMsg=+e.getMessage();
            }
            
            
        }else{
            reportWrapper.errMsg='Please contact your GES Account Manager for Analytics access. Thank You!';
        }
        //String jsonReportString = JSON.serialize(reportWrapper);
        return reportWrapper;
    }
    
    //method to deserialize the response object recieved from Expresso
    @AuraEnabled
    public static ExOrCatReportWrapper deserializeExOrCatReport(wwwViadComV1_all.ArrayOfExhibitorOrderTypeStatus recievedObject){
        ExOrCatReportWrapper reportWrapper = new ExOrCatReportWrapper(); // to be reurned from this method
        List<ExOrTypeWrapper> ExOrTypeWrapList = new List<ExOrTypeWrapper>();
        List<wwwViadComV1_all.ExhibitorOrderTypeStatus> ExhibitorOrderTypeStatus = new List<wwwViadComV1_all.ExhibitorOrderTypeStatus>();
        ExhibitorOrderTypeStatus = recievedObject.ExhibitorOrderTypeStatus;
        //system.debug('ExhibitorOrderTypeStatus ==='+e.getMessage());
        if(ExhibitorOrderTypeStatus.size()>0){
            for(wwwViadComV1_all.ExhibitorOrderTypeStatus exChkList: ExhibitorOrderTypeStatus){
                ExOrTypeWrapper  exChkListWrap = new ExOrTypeWrapper(exChkList);
                ExOrTypeWrapList.add(exChkListWrap);
            }
            reportWrapper.ExOrTypeWrapList = ExOrTypeWrapList;
        }
        return reportWrapper;
    }
    
    public class ExOrCatReportWrapper {
        @AuraEnabled public List<ExOrTypeWrapper> ExOrTypeWrapList;
        @AuraEnabled public string errMsg;
    }
    
    public class ExOrTypeWrapper{
        @AuraEnabled public String BoothNumber;
        @AuraEnabled public String CompanyName;
        @AuraEnabled public String ItemType;
        @AuraEnabled public String Ordered;
        @AuraEnabled public String ProjectCode;
        @AuraEnabled public String ShowName;
        
        public ExOrTypeWrapper(wwwViadComV1_all.ExhibitorOrderTypeStatus exChkList){
            this.BoothNumber        =       (exChkList.BoothNumber!= null ? exChkList.BoothNumber: '');
            this.CompanyName       =       (exChkList.CompanyName!= null ? exChkList.CompanyName: '');
            this.ProjectCode     =       (exChkList.ProjectCode!= null ? exChkList.ProjectCode: '');
            this.ShowName          =       (exChkList.ShowName!= null ? exChkList.ShowName: '');
            this.ItemType          =       (exChkList.ItemType!= null ? exChkList.ItemType: '');
            this.Ordered          =       (exChkList.Ordered!= null ? exChkList.Ordered: '');
            
        }
    }
    
    /* Methods to be used for ExhibitorOrderTypeStatus report till here --report3*/
    @AuraEnabled
    public static Boolean validateUser(String projectNumber) {          
        GC_Show_Team_Member__c teamMember = new GC_Show_Team_Member__c(); 
        GC_Connect2_Show__c show = new GC_Connect2_Show__c();
        String userID= UserInfo.getUserId();
        System.debug('userID'+userID);
        if(String.isNotBlank(projectNumber) && projectNumber.length()!=9 || String.isBlank(projectNumber)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter a project number of Nine Characters. Thank you!'));
            return false;
        }else{
            try{
                teamMember=[Select id, Show_Analytics_Role__c, Connect2_Show__r.Job_Number__c, Connect2_Show__r.Id from GC_Show_Team_Member__c where User__c= :userID AND Connect2_Show__r.Job_Number__c = :projectNumber Limit 1];
                show=GC_Connect2ShowDao.getInstance().getConnect2ShowById(teamMember.Connect2_Show__r.Id);
            }catch(Exception e){
                teamMember = new GC_Show_Team_Member__c(); 
                show = new GC_Connect2_Show__c();
                system.debug('e.message====='+e.getMessage());
            }
        }            
        if(teamMember.Show_Analytics_Role__c || System.Label.GC_Label_ProfilesForAnalytics.contains(UserInfo.getProfileId())){
            return true;
        }else{
            return false;
        }
    }
    
    @AuraEnabled
    public static string setExpoCadURL(String projectNumber) {
        system.debug('projectNumber==='+projectNumber);
        String expoCadBaseURL=System.Label.LC_ExpoCadBaseURL;
        //string finalURL=expoCadBaseURL+'2182032';
        string finalURL=expoCadBaseURL+projectNumber;
        return finalURL;
    }
    
    
    // method to be called when the expocad page is loaded. This will help refresh the session ID and will not cause Uncommitted work pending error
    @AuraEnabled
    public static String getSessionIDWithLogin() {
        GC_Core_Session__c session;
        String integrationUserId= System.Label.LC_LC_IntegrationUserId;
        List<GC_Core_Session__c> existingSession = [SELECT Id, Core_Application_Session_ID__c, Is_Logged_In__c, Core_Application_Session_Error_Message__c, Core_Application_Login_Error_Message__c, User_ID__c, Core_Application_Login_Expiration__c, Core_Application_Session_Expiration__c FROM GC_Core_Session__c WHERE OwnerId = :integrationUserId order by LastModifiedDate desc];
        if (existingSession.size() == 0) {
            if (Test.isRunningTest()) {
                Test.setMock(WebServiceMock.class, new CORE_SECURITY_IMPLMockImpl());
                
            }
            
            session = new GC_Core_Session__c();
            CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService s = new CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService();
            s.ApplicationID ='SalesForce';
            s.ApplicationKey='76v.H-_7};9^+4(]J.;3';
            
            CORE_SECURITY.AppSessionInfo a = s.StartAppSession();
            
            session.Core_Application_Session_ID__c = a.SessionID;
            session.Core_Application_Session_Expiration__c = a.Expiration;
            session.Is_Logged_In__c = false;
            //insert session;
            
        }
        else if (existingSession.size() > 0 && existingSession.get(0).Core_Application_Session_Expiration__c < DateTime.Now()) {
            if (Test.isRunningTest()) {
                Test.setMock(WebServiceMock.class, new CORE_SECURITY_IMPLMockImpl());
            }
            
            session = existingSession.get(0);
            CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService s = new CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService();
            s.ApplicationID ='SalesForce';
            s.ApplicationKey='76v.H-_7};9^+4(]J.;3';
            CORE_SECURITY.AppSessionInfo a = s.StartAppSession();
            session.Core_Application_Session_ID__c = a.SessionID;
            session.Core_Application_Session_Expiration__c = a.Expiration;
            session.Is_Logged_In__c = false;
            //update session;
            
        }
        else {
            session = existingSession.get(0);
        }
        if (!session.Is_Logged_In__c || (session.Is_Logged_In__c && session.Core_Application_Login_Expiration__c < DateTime.now())) {
            if (Test.isRunningTest()) {
                // set test mock here
            }
            
            CORE_SECURITY.UserLogin_element request = new CORE_SECURITY.UserLogin_element();
            request.AppSessionID = session.Core_Application_Session_ID__c;
            request.LoginName = 'mjones112001';
            request.Password = 'password1';
            request.RetrieveSecurityGroups = false;
            
            CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService s = new CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService();
            s.ApplicationID ='SalesForce';
            s.ApplicationKey='76v.H-_7};9^+4(]J.;3';
            CORE_SECURITY.AppSessionInfo a = s.UserLogin(request);
            
            session.Is_Logged_In__c = true;
            session.Core_Application_Login_Expiration__c = a.Expiration;
            upsert session;
            system.debug('session updated=='+session);
            
            
        }
        return session.Core_Application_Session_ID__c;
    }
    
    // method to be called to authorise the ExpoCad page to interact with SFDC. The output should be set in the page as a parameter
    @AuraEnabled
    public static String getUserSessionID() {
        System.debug(UserInfo.getOrganizationId()+''+UserInfo.getSessionId().SubString(15));
        return(UserInfo.getOrganizationId()+''+UserInfo.getSessionId().SubString(15));
    }
    
    // Report5 Start (Created by Anusha)

    public class ChecklistItemsWrapper {
        @AuraEnabled public List<ShowInstaChkWrapper> ExOrTypeWrapList;
        @AuraEnabled public string errMsg;
    }
   
    public class ShowInstaChkWrapper{
        
        @AuraEnabled    public String ChecklistGroup;
        @AuraEnabled   public Integer ChecklistGroupId;
        @AuraEnabled   public string DueDate;
        @AuraEnabled  public String FormName;
        @AuraEnabled   public String FormType;
        @AuraEnabled  public Decimal Progress;
        @AuraEnabled  public String ProjectNumber;
        @AuraEnabled  public Integer ShowInstanceChecklistId;
        @AuraEnabled     public Integer Submitted;
        @AuraEnabled    public Integer Total;
        @AuraEnabled     public Integer unRead;
        
        public ShowInstaChkWrapper(wwwViadComV1_all.ShowInstanceChecklistItem showInstaChkList, Integer readCount){
            
            this.ChecklistGroup        =       (showInstaChkList.ChecklistGroup!= null ? showInstaChkList.ChecklistGroup: '');
            this.ChecklistGroupId       =       (showInstaChkList.ChecklistGroupId!= null ? showInstaChkList.ChecklistGroupId: 0);
            this.DueDate = (showInstaChkList.DueDate!= null ?String.valueOf(showInstaChkList.DueDate).substringBefore('T') : '');
            this.FormName          =       (showInstaChkList.FormName!= null ? showInstaChkList.FormName: 'Click Here');
            this.FormType          =       (showInstaChkList.FormType!= null ? showInstaChkList.FormType: '');
            this.Progress          =       (showInstaChkList.Progress!= null ? showInstaChkList.Progress: 0);
            this.ProjectNumber          =       (showInstaChkList.ProjectNumber!= null ? showInstaChkList.ProjectNumber: '');
            this.ShowInstanceChecklistId    = (showInstaChkList.ShowInstanceChecklistId!= null ? showInstaChkList.ShowInstanceChecklistId: 0);
            this.Submitted          =       (showInstaChkList.Submitted!= null ? showInstaChkList.Submitted: 0);
            this.Total          =       (showInstaChkList.Total!= null ? showInstaChkList.Total: 0);
            this.unRead= this.Submitted-readCount;
            
        }
    }
    
    
   @AuraEnabled
    public static ChecklistItemsWrapper ShowInstanceChecklistItems(String projectNumber){
        Boolean validationFlag =validateUser(projectNumber);
        String expressoSessionId=getExSessionID();
        ChecklistItemsWrapper reportWrapper = new ChecklistItemsWrapper();
        if(validationFlag){
            try{
                 if(Test.isRunningTest()){
                    Test.setMock(WebServiceMock.class, new wwwViadComV1_allMockImpl()); 
                }
                wwwViadComV1_all.BasicHttpBinding_IExhibitorService IExhibitorServiceObject= new wwwViadComV1_all.BasicHttpBinding_IExhibitorService(); 
                wwwViadComV1_all.ArrayOfShowInstanceChecklistItem  reportObject= IExhibitorServiceObject.GetShowInstanceChecklistItems(expressoSessionId,projectNumber);
                //system.debug('reportObject==='+reportObject); 
                // deserialize the recieved response 
                reportWrapper = deserializeshowInstaChkReport(reportObject, projectNumber);          
                //system.debug('sessionId==='+responseAppSessionInfo.SessionID);              
                
            }catch(exception e){
                system.debug('error message==='+e.getStackTraceString()); 
           		reportWrapper.errMsg=e.getMessage() + e.getStackTraceString();
                
            }
        }else{
            //exPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please contact your GES Account Manager for Analytics access. Thank You!'));
        }
       
        return reportWrapper;
    }
      @AuraEnabled
      public static ChecklistItemsWrapper deserializeshowInstaChkReport(wwwViadComV1_all.ArrayOfShowInstanceChecklistItem recievedObject, String projectNumber){
        ChecklistItemsWrapper reportWrapper = new ChecklistItemsWrapper(); // to be reurned from this method
        List<ShowInstaChkWrapper> ExOrTypeWrapList = new List<ShowInstaChkWrapper>();
        List<wwwViadComV1_all.ShowInstanceChecklistItem> ShowInstanceChecklistItem = new List<wwwViadComV1_all.ShowInstanceChecklistItem>();
        ShowInstanceChecklistItem = recievedObject.ShowInstanceChecklistItem;
        
        List<GC_RegistrationChecklistTask__c> existingMapObjects = [SELECT Id, Staus_Map__c,Project_Number__c  FROM GC_RegistrationChecklistTask__c WHERE Project_Number__c = :projectNumber order by LastModifiedDate desc];
        RegChkTaskStatus derivedMapObject = new RegChkTaskStatus();
        if(existingMapObjects.size()>0){
            GC_RegistrationChecklistTask__c mapObject = existingMapObjects.get(0);
            derivedMapObject= (RegChkTaskStatus)JSON.deserializeStrict(mapObject.Staus_Map__c, RegChkTaskStatus.Class);
        }
        
        
        //system.debug('ShowInstanceChecklistItem ==='+e.getMessage());
        if(ShowInstanceChecklistItem.size()>0){
            for(wwwViadComV1_all.ShowInstanceChecklistItem exChkList: ShowInstanceChecklistItem){
                ShowInstaChkWrapper  exChkListWrap;
                if(derivedMapObject.mapOfReadTasksToParent.containsKey(string.valueOf(exChkList.ShowInstanceChecklistId))){
                    exChkListWrap = new ShowInstaChkWrapper(exChkList,derivedMapObject.mapOfReadTasksToParent.get(string.valueOf(exChkList.ShowInstanceChecklistId)).size());
                }else{
                    exChkListWrap = new ShowInstaChkWrapper(exChkList,0);
                }
                
                ExOrTypeWrapList.add(exChkListWrap);
            }
            reportWrapper.ExOrTypeWrapList = ExOrTypeWrapList;
        }
        return reportWrapper;
    }
    
    public class RegChkTaskStatus{
        //public Map<String, String> mapReadStatusToId;
        @AuraEnabled  public Map<String, List<String>> mapOfReadTasksToParent;
        @AuraEnabled  public String projectNumber;
        
        public RegChkTaskStatus(){
            this.mapOfReadTasksToParent= new Map<String, List<String>>();
        }
        
        public RegChkTaskStatus(String projectNumber, String showInstanceCheckListId, List<wwwViadComV1_all.RegistrationChecklistTask> receivedTasks){
            this.projectNumber= projectNumber;
            mapOfReadTasksToParent= new Map<String, List<String>>();
            //mapReadStatusToId = new Map<String, String>();
            for(wwwViadComV1_all.RegistrationChecklistTask varTask: receivedTasks){
                /*if(!mapReadStatusToId.containsKey(String.valueOf(varTask.RegistrationChecklistTaskId))){
                    mapReadStatusToId.put(String.valueOf(varTask.RegistrationChecklistTaskId),'Unread');
                }*/
                if(!mapOfReadTasksToParent.containsKey(showInstanceCheckListId)){
                    mapOfReadTasksToParent.put(showInstanceCheckListId,new List<string>());
                }
                //mapOfReadTasksToParent.get(showInstanceCheckListId).add(String.valueOf(varTask.RegistrationChecklistTaskId));
            }
        }
    }
    
    // Report5 End
    
    // Report6 Start
    
    @AuraEnabled
    Public static String GetRegistrationCheckListTasks (String projectNumber, Integer showInstanceCheckListId){
        Boolean validationFlag =validateUser(projectNumber);
        String expressoSessionId=getExSessionID();
        RegChkListItemsWrapper reportWrapper = new RegChkListItemsWrapper();           
        if(validationFlag ){
            try{
                if(Test.isRunningTest()){
                    Test.setMock(WebServiceMock.class, new wwwViadComV1_allMockImpl()); 
                }
                wwwViadComV1_all.BasicHttpBinding_IExhibitorService IExhibitorServiceObject= new wwwViadComV1_all.BasicHttpBinding_IExhibitorService(); 
                wwwViadComV1_all.ShowInstanceChecklistTasks reportObject= IExhibitorServiceObject.GetRegistrationChecklistTasks(expressoSessionId, showInstanceCheckListId);
                //system.debug('reportObject==='+reportObject); 
                // deserialize the recieved response 
                RegChkTaskStatus storedMap = storeReadStatus(projectNumber, String.valueOf(showInstanceCheckListId), reportObject.RegistrationChecklistTasks.RegistrationChecklistTask);
                reportWrapper = deserializeRegChkListItemReport(reportObject, storedMap, String.valueOf(showInstanceCheckListId));             
                
            }catch(exception e){
                system.debug('error message==='+e.getStackTraceString()); 
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There is some issue with the web services. Please wait till it is fixed. Thank you!'));
                
            }
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please contact your GES Account Manager for Analytics access. Thank You!'));
        }
        String jsonReportString = JSON.serialize(reportWrapper);
        return jsonReportString;
    }
    
    //method to deserialize the response object recieved from Expresso
    public static RegChkListItemsWrapper deserializeRegChkListItemReport(wwwViadComV1_all.ShowInstanceChecklistTasks recievedObject, RegChkTaskStatus storedMap, String showInstanceCheckListId){
        RegChkListItemsWrapper reportWrapper = new RegChkListItemsWrapper(); // to be reurned from this method
        List<RegChkListItemWrapper> RegistrationChkList = new List<RegChkListItemWrapper>();
        wwwViadComV1_all.ShowInstanceChecklistTasks registrationChecklistTask = new wwwViadComV1_all.ShowInstanceChecklistTasks();
        registrationChecklistTask = recievedObject;
        
        if(registrationChecklistTask != null){      
            RegChkListItemWrapper  regListWrap = new RegChkListItemWrapper(registrationChecklistTask, storedMap.mapOfReadTasksToParent, showInstanceCheckListId);     
            RegistrationChkList.add(regListWrap);
        }
        reportWrapper.RegistrationChkList = RegistrationChkList;
        
        
        
        return reportWrapper;
    }
    
    public class RegChkListItemsWrapper {
        public List<RegChkListItemWrapper> RegistrationChkList;
    }
    
    public class RegChkListItemWrapper{
        
        //public wwwViadComV1_all.ArrayOfRegistrationChecklistTask RegistrationChecklistTasks;
        @AuraEnabled public List<regChkListTaskWrapper> RegistrationChecklistTasks; 
        @AuraEnabled public wwwViadComV1_all.ShowInstanceChecklistItem ShowInstanceChecklistItem;
        @AuraEnabled public String ExhibitorName;
        @AuraEnabled public String Hall;
        @AuraEnabled public Integer RegChkLstTaskId;
        @AuraEnabled public String StandType;
        @AuraEnabled public String Status;
        @AuraEnabled public DateTime SubmittedOn;
        @AuraEnabled public DateTime UpdatedOn;
        
        public RegChkListItemWrapper(wwwViadComV1_all.ShowInstanceChecklistTasks showInstChkList, Map<String, List<String>> statusMap, String showInstanceCheckListId){
            this.RegistrationChecklistTasks = new List<regChkListTaskWrapper>();
            //storeReadStatus();
            for(wwwViadComV1_all.RegistrationChecklistTask tempTask: showInstChkList.RegistrationChecklistTasks.RegistrationChecklistTask){
                RegChkListTaskWrapper tempVar;
                if(statusMap.containsKey(showInstanceCheckListId)){
                    //(String.valueOf(tempTask.RegistrationChecklistTaskId)))
                    if(statusMap.get(showInstanceCheckListId).contains(String.valueOf(tempTask.RegistrationChecklistTaskId))){
                        tempVar = new regChkListTaskWrapper(tempTask,'Read');
                    }else{
                        tempVar = new regChkListTaskWrapper(tempTask,'Unread');
                    }
                    // tempVar = new regChkListTaskWrapper(tempTask,statusMap.get(String.valueOf(tempTask.RegistrationChecklistTaskId)));
                }else{
                    tempVar = new regChkListTaskWrapper(tempTask,'Unread');
                }
                
                this.RegistrationChecklistTasks.add(tempVar);
            }
            //this.RegistrationChecklistTasks = (showInstChkList.RegistrationChecklistTasks);
            this.ShowInstanceChecklistItem = (showInstChkList.ShowInstanceChecklistItem);
        }
    }
    
    public class regChkListTaskWrapper{
        @AuraEnabled public String ExhibitorName;
        // public String Hall;
        @AuraEnabled public String RegistrationChecklistTaskId;
        // public String StandType;
        @AuraEnabled public String Status;
        @AuraEnabled public String SubmittedOn;
        @AuraEnabled public String UpdatedOn;
        @AuraEnabled public String readStatus;
        @AuraEnabled public boolean isSelected;
        
        public regChkListTaskWrapper(wwwViadComV1_all.RegistrationChecklistTask receivedTask, String readStatus){
            this.ExhibitorName = String.isNotBlank(receivedTask.ExhibitorName)? receivedTask.ExhibitorName: '';
            this.RegistrationChecklistTaskId = receivedTask.RegistrationChecklistTaskId !=null ? String.valueOf(receivedTask.RegistrationChecklistTaskId): '';
            this.SubmittedOn = receivedTask.SubmittedOn !=null ? String.valueOf(receivedTask.SubmittedOn): '';
            this.UpdatedOn = receivedTask.UpdatedOn !=null ? String.valueOf(receivedTask.UpdatedOn): '';
            this.Status = String.isNotBlank(receivedTask.Status)? receivedTask.Status: '';
            this.readStatus=readStatus;
            isSelected = false;
        }
    }
    
    @AuraEnabled
    public static RegChkTaskStatus storeReadStatus(String projectNumber, String showInstanceCheckListId,  List<wwwViadComV1_all.RegistrationChecklistTask> listOfTasks) {
        List<GC_RegistrationChecklistTask__c> existingMapObjects = [SELECT Id, Staus_Map__c,Project_Number__c  FROM GC_RegistrationChecklistTask__c WHERE Project_Number__c = :projectNumber order by LastModifiedDate desc];
        //system.debug('existingMapObjects===='+existingMapObjects);
        GC_RegistrationChecklistTask__c mapObject = new GC_RegistrationChecklistTask__c();
        if(existingMapObjects.size()==0){
            RegChkTaskStatus storageObject = new RegChkTaskStatus(projectNumber,showInstanceCheckListId, listOfTasks);
            String jsonMap= JSON.serialize(storageObject);
            mapObject.Staus_Map__c= jsonMap;
            mapObject.Project_Number__c= projectNumber;
            upsert mapObject;
            
        }else{
            mapObject = existingMapObjects.get(0);
        }
        //RegChkTaskStatus derivedMapObject= new RegChkTaskStatus();
        RegChkTaskStatus derivedMapObject= (RegChkTaskStatus)JSON.deserializeStrict(mapObject.Staus_Map__c, RegChkTaskStatus.Class);
        return derivedMapObject;
    }
    
    
    // Report6 End
    
    
}