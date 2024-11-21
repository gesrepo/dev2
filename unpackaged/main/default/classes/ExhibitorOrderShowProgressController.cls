/**
* @author rahul sinha For SLK Software Services
* @description Controller for the Expresso Report pages on community
* 2018-01-25 : Original Version
* 2018-07-12 : Modified to include other reports 5, 6 7
**/
global  class ExhibitorOrderShowProgressController {
    public Boolean isClassic{get; set;}
    Public String showHeaderVal{get; set;}
    public Boolean isLightningComm{get; set;}
    private GC_Show_Team_Member__c teamMember;
    public static GC_Core_Session__c exSessionObject;
    
    public ExhibitorOrderShowProgressController() {
        isLightningComm=false;
        teamMember = new GC_Show_Team_Member__c();
        String ntwrkId = Network.getNetworkId();
        String isLightning     =   Apexpages.currentPage().getParameters().get('isLightning');
        String isCommunity     =   Apexpages.currentPage().getParameters().get('isCommunity'); 
        system.debug('ntwrkId==='+ntwrkId);
        if(ntwrkId==null){
            isClassic= true;
            showHeaderVal='true';
            
        }else{
            isClassic= false;
            showHeaderVal='false';
        }
        if(string.isNotBlank(isLightning)||string.isNotBlank(isCommunity)){
            showHeaderVal='false';
            isLightningComm=true;
        }
    }
    
    /* Methods to be used for ExhibitorShowProgress report -Report1*/
    //method to separate values from ExhibitorOrderShowProgress 
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
            wrapper.OrProSumWrap = OrProSumWrap;
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
    
    
    //Wrapper for ExhibitorInfo to remove nulls
    public class ExhibitorInfoWrapper {
        public String Address;
        public String City;
        public String CompanyName;
        public String Country;
        public String CustomerNumber;
        public String EmailAddress;
        public String FirstName;
        public String LastName;
        public String PhoneNumber;
        public String PostalCode;
        public String State;
        
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
        public String ExhbitorsWithOrdersCount;
        public String ExhibitorsCount;
        public String Percentage;
        public String OrderDueDate;
        public String ProjectNumber;
        public String ShowName;
        
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
        public List<ExhibitorInfoWrapper> ExInfoWrapList;
        public OrderProSumWrapper OrProSumWrap;
    } 
    
    public PageReference loadCheckListTasks(){
        
        string domainUrl=URL.getSalesforceBaseUrl().toExternalForm();
        System.debug('domainUrl--------' + domainUrl);
        return null;
    }
    
    // using remote action for generating reports with view state much larger than 135 KB
    
    @RemoteAction
    global static String getReport(String projectNumber, String showId){
        if (String.isNotBlank(showId) && String.isBlank(projectNumber)) {
            GC_Connect2_Show__c show = GC_Connect2ShowDao.getInstance().getConnect2ShowById(showId);
            projectNumber= show.Job_Number__c;
        } 
        String ApplicationID   = System.Label.GC_Label_AppID ;
        String ApplicationKey  = System.Label.GC_Label_AppKey;
        showAndExListWrapper reportWrapper = new showAndExListWrapper();
        String userID= UserInfo.getUserId();
        GC_Show_Team_Member__c teamMember = new GC_Show_Team_Member__c();
        try{
            teamMember = [Select id, Show_Analytics_Role__c from GC_Show_Team_Member__c where User__c= :userID AND Connect2_Show__r.Job_Number__c=:projectNumber Limit 1];
        }catch(Exception e){}       
        
        if(teamMember.Show_Analytics_Role__c || System.Label.GC_Label_ProfilesForAnalytics.contains(UserInfo.getProfileId())){
            try{
                String expressoSessionId=getExSessionID();
                wwwViadComV1_all.BasicHttpBinding_IExhibitorService IExhibitorServiceObject= new wwwViadComV1_all.BasicHttpBinding_IExhibitorService(); 
                wwwViadComV1_all.ShowInstanceOrderProgress reportObject= IExhibitorServiceObject.GetExhibitorOrderProgress(expressoSessionId,projectNumber);
                //system.debug('reportObject==='+reportObject); 
                // deserialize the recieved response 
                reportWrapper = deserializeExOrProReport(reportObject);             
                
            }catch(exception e){
                
            }
            
            
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please contact your GES Account Manager for Analytics access. Thank You!'));
        }
        String jsonReportString = JSON.serialize(reportWrapper);
        return jsonReportString;
    }
    
    /* Methods to be used for ExhibitorShowProgress report -Report1 --- Till here*/
    /* Methods to be used for ExhibitorFormProgress report -Report2*/
    @RemoteAction
    global static String GetExhibitorFormProgress(String projectNumber, String showId){
        String userID= UserInfo.getUserId();
        GC_Show_Team_Member__c teamMember = new GC_Show_Team_Member__c();
        if (String.isNotBlank(showId) && String.isBlank(projectNumber)) {
            GC_Connect2_Show__c show = GC_Connect2ShowDao.getInstance().getConnect2ShowById(showId);
            projectNumber= show.Job_Number__c;
        }
        try{
            teamMember = [Select id, Show_Analytics_Role__c from GC_Show_Team_Member__c where User__c= :userID AND Connect2_Show__r.Job_Number__c=:projectNumber Limit 1];
        }catch(Exception e){
            system.debug('error at==='+e.getStackTraceString());
        } 
        
        String ApplicationID   = System.Label.GC_Label_AppID ;
        String ApplicationKey  = System.Label.GC_Label_AppKey;
        ExOrProReportWrapper reportWrapper = new ExOrProReportWrapper();
        
        
        
        if(teamMember.Show_Analytics_Role__c || System.Label.GC_Label_ProfilesForAnalytics.contains(UserInfo.getProfileId()) ){
            try{
                String expressoSessionId=getExSessionID();
                wwwViadComV1_all.BasicHttpBinding_IExhibitorService IExhibitorServiceObject= new wwwViadComV1_all.BasicHttpBinding_IExhibitorService(); 
                wwwViadComV1_all.ShowFormProgressStatus reportObject= IExhibitorServiceObject.GetExhibitorFormProgress(expressoSessionId,projectNumber);
                // deserialize the recieved response 
                reportWrapper = deserializeExFoProReport(reportObject); 
                reportObject =  new wwwViadComV1_all.ShowFormProgressStatus();      
                //system.debug('reportWrapper==='+reportWrapper);
            }catch(exception e){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There is some issue with the web services. Please wait till it is fixed. Thank you!'));
                system.debug('e==='+e.getStackTraceString());
                
            }
            
            
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please contact your GES Account Manager for Analytics access. Thank You!'));
        }
        String jsonReportString = JSON.serialize(reportWrapper);
        //system.debug('jsonReportString==='+jsonReportString);
        return jsonReportString;
    }
    
    //method to deserialize the response object recieved from Expresso
    public static ExOrProReportWrapper deserializeExFoProReport(wwwViadComV1_all.ShowFormProgressStatus recievedObject){
        ExOrProReportWrapper reportWrapper = new ExOrProReportWrapper();
        List<ExhibitorFormProgressWrapper> exFormWrapList = new List<ExhibitorFormProgressWrapper>();
        List<ShowFormProgressWrapper> showFormWrapList = new List<ShowFormProgressWrapper>();
        List<wwwViadComV1_all.ExhibitorFormProgress> ExhibitorFormProgress = new List<wwwViadComV1_all.ExhibitorFormProgress>();
        if(recievedObject.ExhibitorFormProgress!=null){
            ExhibitorFormProgress= recievedObject.ExhibitorFormProgress.ExhibitorFormProgress;
        }
        
        List<wwwViadComV1_all.ShowFormProgress> ShowFormProgress = new List<wwwViadComV1_all.ShowFormProgress>();
        ShowFormProgress = recievedObject.ShowFormProgress.ShowFormProgress;
        //system.debug('ExhibitorFormProgress.size==='+ExhibitorFormProgress.size());
        if(ExhibitorFormProgress!=null && ExhibitorFormProgress.size()>0){
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
               // system.debugsystem.debug('showFormWrap==='+showFormWrap);
            }
            reportWrapper.ShowFormProWrapList = showFormWrapList;
        }
        return reportWrapper;
    }
    
    public class ExOrProReportWrapper {
        public List<ExhibitorFormProgressWrapper> ExFoProWrapList;
        public List<ShowFormProgressWrapper> ShowFormProWrapList;
    }
    
    public class ExhibitorFormProgressWrapper{
        public String BoothNumber;
        public String CustomerName;
        public String CustomerNumber;
        public String FormTitle;
        public String Submitted; 
        
        public ExhibitorFormProgressWrapper(wwwViadComV1_all.ExhibitorFormProgress exForPro){
            this.BoothNumber        =       (exForPro.BoothNumber!= null ? exForPro.BoothNumber: '');
            this.CustomerName       =       (exForPro.CustomerName!= null ? exForPro.CustomerName: '');
            this.CustomerNumber     =       (exForPro.CustomerNumber!= null ? exForPro.CustomerNumber: '');
            this.FormTitle          =       (exForPro.FormTitle!= null ? exForPro.FormTitle: '');
            this.Submitted          =       (exForPro.Submitted!= null ? exForPro.Submitted: '');
        }
    }
    
    public class ShowFormProgressWrapper{
        public String FormTitle;
        public String ProjectNumber;
        public String ShowName;
        public Integer Submitted;
        public Integer Total; 
        public String percentage;
        
        public ShowFormProgressWrapper(wwwViadComV1_all.ShowFormProgress  showFormPro){
            this.FormTitle          =       (showFormPro.FormTitle!= null ? showFormPro.FormTitle: '');
            this.ProjectNumber      =       (showFormPro.ProjectNumber!= null ? showFormPro.ProjectNumber: '');
            this.ShowName           =       (showFormPro.ShowName!= null ? showFormPro.ShowName: '');
            this.Submitted          =       (showFormPro.Submitted!= null ? showFormPro.Submitted: 0);
            this.Total              =       (showFormPro.Total!= null ? showFormPro.Total: 0);
            if(showFormPro.Total!=0){
                Decimal orderedCount = Decimal.valueOf(String.valueOf(showFormPro.Submitted))*100;
                Decimal totalCount = Decimal.valueOf(String.valueOf(showFormPro.Total));
                this.percentage             =   String.valueOf(orderedCount.divide(totalCount, 2))+'%';
            }else{
                this.percentage             =   'Can not be defined';
            }
        }
    }
    /* Methods to be used for ExhibitorFormProgress report till here -Report2*/
    
    /* Methods to be used for ExhibitorChecklistStatus report - Report3*/
    @RemoteAction
    global static String GetExhibitorChecklistStatus(String projectNumber, String showId){
        GC_Show_Team_Member__c teamMember = new GC_Show_Team_Member__c(); 
        String userID= UserInfo.getUserId();
        if (String.isNotBlank(showId) && String.isBlank(projectNumber)) {
            GC_Connect2_Show__c show = GC_Connect2ShowDao.getInstance().getConnect2ShowById(showId);
            projectNumber= show.Job_Number__c;
        }
        try{
            teamMember = [Select id, Show_Analytics_Role__c from GC_Show_Team_Member__c where User__c= :userID AND Connect2_Show__r.Job_Number__c=:projectNumber Limit 1];
        }catch(Exception e){
            //system.debug('User is not associated with this show');
        }
        
        String ApplicationID   = System.Label.GC_Label_AppID ;
        String ApplicationKey  = System.Label.GC_Label_AppKey;
        ExChkListReportWrapper reportWrapper = new ExChkListReportWrapper();
        if(teamMember.Show_Analytics_Role__c || System.Label.GC_Label_ProfilesForAnalytics.contains(UserInfo.getProfileId()) ){
            try{
                String expressoSessionId=getExSessionID();
                wwwViadComV1_all.BasicHttpBinding_IExhibitorService IExhibitorServiceObject= new wwwViadComV1_all.BasicHttpBinding_IExhibitorService(); 
                wwwViadComV1_all.ArrayOfExhibitorChecklistStatus  reportObject= IExhibitorServiceObject.GetExhibitorChecklistStatus(expressoSessionId,projectNumber);
                system.debug('reportObject==='+reportObject); 
                // deserialize the recieved response 
                reportWrapper = deserializeExChkReport(reportObject,projectNumber);             
                
            }catch(exception e){
                system.debug('error message==='+e.getMessage()); 
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There is some issue with the web services. Please wait till it is fixed. Thank you!'));
                
            }
            
            
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please contact your GES Account Manager for Analytics access. Thank You!'));
        }
        
        String jsonReportString = JSON.serialize(reportWrapper);
        return jsonReportString;
    }
    
    //method to deserialize the response object recieved from Expresso
    public static ExChkListReportWrapper deserializeExChkReport(wwwViadComV1_all.ArrayOfExhibitorChecklistStatus recievedObject, String projectNumber){
        ExChkListReportWrapper reportWrapper = new ExChkListReportWrapper(); // to be reurned from this method
        List<ExChklistStatusWrapper> ExChkWrapList = new List<ExChklistStatusWrapper>();
        List<wwwViadComV1_all.ExhibitorChecklistStatus> ExhibitorChecklistStatus = new List<wwwViadComV1_all.ExhibitorChecklistStatus>();
        ExhibitorChecklistStatus = recievedObject.ExhibitorChecklistStatus;
        //system.debug('ExhibitorChecklistStatus ==='+e.getMessage());
        if(ExhibitorChecklistStatus.size()>0){
            for(wwwViadComV1_all.ExhibitorChecklistStatus exChkList: ExhibitorChecklistStatus){
                ExChklistStatusWrapper  exChkListWrap = new ExChklistStatusWrapper(exChkList);
                ExChkWrapList.add(exChkListWrap);
            }
            reportWrapper.ExChkWrapList = ExChkWrapList;
        }
        GC_Connect2_Show__c currentShow= getShowDetails(projectNumber);
        reportWrapper.showName=currentShow.Show_Name__c!=null? currentShow.Show_Name__c:'';
        reportWrapper.startDate= currentShow.Show_Start_Date__c!=null?currentShow.Show_Start_Date__c.format():'';
        reportWrapper.endDate=currentShow.Show_End_Date__c!=null?currentShow.Show_End_Date__c.format():'';
        return reportWrapper;
    }
    
    public class ExChkListReportWrapper {
        public List<ExChklistStatusWrapper> ExChkWrapList;
        public String showName;
        public String startDate;
        public String endDate;
    }
    
    public class ExChklistStatusWrapper{
        public String BoothNumber;
        public String CompanyName;
        public String DateUpdated;
        public String ProjectCode;
        public String ShowName;
        public String Status;
        public String Title;
        
        public ExChklistStatusWrapper(wwwViadComV1_all.ExhibitorChecklistStatus exChkList){
            this.BoothNumber        =       (exChkList.BoothNumber!= null ? exChkList.BoothNumber: '');
            this.CompanyName       =       (exChkList.CompanyName!= null ? exChkList.CompanyName: '');
            this.ProjectCode     =       (exChkList.ProjectCode!= null ? exChkList.ProjectCode: '');
            this.ShowName          =       (exChkList.ShowName!= null ? exChkList.ShowName: '');
            this.Status          =       (exChkList.Status!= null ? exChkList.Status: '');
            this.Title          =       (exChkList.Title!= null ? exChkList.Title: '');
            if(exChkList.DateUpdated!=null){
                this.DateUpdated = exChkList.DateUpdated.format();
            }else{
                this.DateUpdated = 'N/A';
            }
        }
    }
    
    /* Methods to be used for ExhibitorChecklistStatus report till here - Report3 */
    
    /* Methods to be used for ExhibitorOrderTypeStatus report --report4*/
    @RemoteAction
    global static String GetExhibitorOrderTypeStatus(String projectNumber, String showId, String startDateStr, String endDateStr){
        Date startDate= Date.valueOf(startDateStr);
        Date endDate= Date.valueOf(endDateStr);
        Boolean validationFlag =validateUser(projectNumber);
        String expressoSessionId=getExSessionID();
        ExOrCatReportWrapper reportWrapper = new ExOrCatReportWrapper();            
        if(validationFlag){
            try{
                wwwViadComV1_all.BasicHttpBinding_IExhibitorService IExhibitorServiceObject= new wwwViadComV1_all.BasicHttpBinding_IExhibitorService(); 
                wwwViadComV1_all.ArrayOfExhibitorOrderTypeStatus  reportObject= IExhibitorServiceObject.GetExhibitorOrderTypeStatus(expressoSessionId,projectNumber, startDate, endDate);
                //system.debug('reportObject==='+reportObject); 
                // deserialize the recieved response 
                reportWrapper = deserializeExOrCatReport(reportObject);             
                
            }catch(exception e){
                system.debug('error message==='+e.getMessage()); 
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There is some issue with the web services. Please wait till it is fixed. Thank you!'));
                
            }
            
            
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please contact your GES Account Manager for Analytics access. Thank You!'));
        }
        GC_Connect2_Show__c currentShow= getShowDetails(projectNumber);
        reportWrapper.showName=currentShow.Show_Name__c!=null? currentShow.Show_Name__c:'';
        reportWrapper.startDate= currentShow.Show_Start_Date__c!=null?currentShow.Show_Start_Date__c.format():'';
        reportWrapper.endDate=currentShow.Show_End_Date__c!=null?currentShow.Show_End_Date__c.format():'';
        String jsonReportString = JSON.serialize(reportWrapper);
        return jsonReportString;
    }
    
    //method to deserialize the response object recieved from Expresso
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
        public List<ExOrTypeWrapper> ExOrTypeWrapList;
        public String showName;
        public String startDate;
        public String endDate;
        
    }
    
    public class ExOrTypeWrapper{
        public String BoothNumber;
        public String CompanyName;
        public String ItemType;
        public String Ordered;
        public String ProjectCode;
        public String ShowName;
        
        public ExOrTypeWrapper(wwwViadComV1_all.ExhibitorOrderTypeStatus exChkList){
            this.BoothNumber        =       (exChkList.BoothNumber!= null ? exChkList.BoothNumber: '');
            this.CompanyName       =       (exChkList.CompanyName!= null ? exChkList.CompanyName: '');
            this.ProjectCode     =       (exChkList.ProjectCode!= null ? exChkList.ProjectCode: '');
            this.ShowName          =       (exChkList.ShowName!= null ? exChkList.ShowName: '');
            this.ItemType          =       (exChkList.ItemType!= null ? exChkList.ItemType: '');
            this.Ordered          =       (exChkList.Ordered!= null ? exChkList.Ordered: '');
            
        }
    }
    
    /* Methods to be used for ExhibitorOrderTypeStatus report till here --report4*/
    
    /* Methods to be used for GetShowInstanceChecklistItems report from here --report5*/
    @RemoteAction
    global static String ShowInstanceChecklistItems (String projectNumber, String showId){
        Boolean validationFlag =validateUser(projectNumber);
        String expressoSessionId=getExSessionID();
        ChecklistItemsWrapper reportWrapper = new ChecklistItemsWrapper();
        if(validationFlag){
            try{
                wwwViadComV1_all.BasicHttpBinding_IExhibitorService IExhibitorServiceObject= new wwwViadComV1_all.BasicHttpBinding_IExhibitorService(); 
                wwwViadComV1_all.ArrayOfShowInstanceChecklistItem  reportObject= IExhibitorServiceObject.GetShowInstanceChecklistItems(expressoSessionId,projectNumber);
                // deserialize the recieved response 
                reportWrapper = deserializeshowInstaChkReport(reportObject, projectNumber);                       
                
            }catch(exception e){
                system.debug('error message==='+e.getStackTraceString()); 
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There is some issue with the web services. Please wait till it is fixed. Thank you!'));
                
            }
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please contact your GES Account Manager for Analytics access. Thank You!'));
        }
        GC_Connect2_Show__c currentShow= getShowDetails(projectNumber);
        reportWrapper.showName=currentShow.Show_Name__c!=null? currentShow.Show_Name__c:'';
        reportWrapper.startDate= currentShow.Show_Start_Date__c!=null?currentShow.Show_Start_Date__c.format():'';
        reportWrapper.endDate=currentShow.Show_End_Date__c!=null?currentShow.Show_End_Date__c.format():'';
        String jsonReportString = JSON.serialize(reportWrapper);
        return jsonReportString;
    }
    
    //method to deserialize the response object recieved from Expresso
    public static ChecklistItemsWrapper deserializeshowInstaChkReport(wwwViadComV1_all.ArrayOfShowInstanceChecklistItem recievedObject, String projectNumber){
        ChecklistItemsWrapper reportWrapper = new ChecklistItemsWrapper(); // to be reurned from this method
        List<ShowInstaChkWrapper> ExOrTypeWrapList = new List<ShowInstaChkWrapper>();
        List<wwwViadComV1_all.ShowInstanceChecklistItem> ShowInstanceChecklistItem = new List<wwwViadComV1_all.ShowInstanceChecklistItem>();
        ShowInstanceChecklistItem = recievedObject.ShowInstanceChecklistItem;
        integer totalCount=0;
        
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
                totalCount+=exChkListWrap.Total;
                            system.debug('totalCount===='+totalCount);
                ExOrTypeWrapList.add(exChkListWrap);
            }
            reportWrapper.ExOrTypeWrapList = ExOrTypeWrapList;
            reportWrapper.totalCount=totalCount;
        }
        return reportWrapper;
    }
    
    public class ChecklistItemsWrapper {
        public List<ShowInstaChkWrapper> ExOrTypeWrapList;
        public String showName;
        public String startDate;
        public String endDate;
        public integer totalCount;
    }
    
    public class ShowInstaChkWrapper{
        
        public String ChecklistGroup;
        public Integer ChecklistGroupId;
        public string DueDate;
        public String FormName;
        public String FormType;
        public String Progress;
        public String ProjectNumber;
        public Integer ShowInstanceChecklistId;
        public Integer Submitted;
        public Integer Total;
        public String unRead;
        
        public ShowInstaChkWrapper(wwwViadComV1_all.ShowInstanceChecklistItem showInstaChkList, Integer readCount){

            this.ChecklistGroup         =       (showInstaChkList.ChecklistGroup!= null ? showInstaChkList.ChecklistGroup: '');
            this.ChecklistGroupId       =       (showInstaChkList.ChecklistGroupId!= null ? showInstaChkList.ChecklistGroupId: 0);
            this.DueDate                =       (showInstaChkList.DueDate!= null) ?(showInstaChkList.DueDate).date().format():'';
            this.FormName               =       (showInstaChkList.FormName!= null ? showInstaChkList.FormName: 'Click Here');
            this.FormType               =       (showInstaChkList.FormType!= null ? showInstaChkList.FormType: '');
            this.Progress               =       string.valueOf((showInstaChkList.Progress!= null ? showInstaChkList.Progress: 0)*100)+'%';
            this.ProjectNumber          =       (showInstaChkList.ProjectNumber!= null ? showInstaChkList.ProjectNumber: '');
            this.ShowInstanceChecklistId=       (showInstaChkList.ShowInstanceChecklistId!= null ? showInstaChkList.ShowInstanceChecklistId: 0);
            this.Submitted              =       (showInstaChkList.Submitted!= null ? showInstaChkList.Submitted: 0);
            this.Total                  =       (showInstaChkList.Total!= null ? showInstaChkList.Total: 0);
            system.debug('showInstaChkList.Total==='+showInstaChkList.Total);
            if(this.FormType!='Online Form'){
                this.unRead             ='--';
            }else{
                this.unRead             =     (this.Submitted-readCount>0) ?String.valueOf(this.Submitted-readCount):'--';
            }
            
            
        }
    }
    
    /* Methods to be used for GetShowInstanceChecklistItems report till here --report5*/
    
    /* Methods to be GetRegistrationCheckListTask report from here --report6*/
    @RemoteAction
    global static String GetRegistrationCheckListTasks (String projectNumber, Integer showInstanceCheckListId){
        Boolean validationFlag =validateUser(projectNumber);
        String expressoSessionId=getExSessionID();
        RegChkListItemsWrapper reportWrapper = new RegChkListItemsWrapper();           
        if(validationFlag ){
            try{
                wwwViadComV1_all.BasicHttpBinding_IExhibitorService IExhibitorServiceObject= new wwwViadComV1_all.BasicHttpBinding_IExhibitorService(); 
                wwwViadComV1_all.ShowInstanceChecklistTasks reportObject= IExhibitorServiceObject.GetRegistrationChecklistTasks(expressoSessionId, showInstanceCheckListId);
                system.debug('reportObject==='+reportObject); 
                // deserialize the recieved response 
                RegChkTaskStatus storedMap = storeReadStatus(projectNumber, String.valueOf(showInstanceCheckListId), reportObject.RegistrationChecklistTasks.RegistrationChecklistTask);
                reportWrapper = deserializeRegChkListItemReport(reportObject, storedMap, String.valueOf(showInstanceCheckListId));             
                
            }catch(exception e){
                system.debug('error message==='+e.getStackTraceString()); 
                system.debug('error message==='+e.getMessage()); 
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There is some issue with the web services. Please wait till it is fixed. Thank you!'));
                
            }
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please contact your GES Account Manager for Analytics access. Thank You!'));
        }
        //System.debug('reportWrapper>>>>>>'+reportWrapper);
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
        reportWrapper.formName= string.isNotBlank(RegistrationChkList[0].ShowInstanceChecklistItem.FormName)?RegistrationChkList[0].ShowInstanceChecklistItem.FormName.replaceAll('\\&', ' and '):'';
        reportWrapper.formName=reportWrapper.formName.replaceAll('\\W', ' ');
        return reportWrapper;
    }
    
    public class RegChkListItemsWrapper {
        public List<RegChkListItemWrapper> RegistrationChkList;
        public String formName;
    }
    
    public class RegChkListItemWrapper{
        
        //public wwwViadComV1_all.ArrayOfRegistrationChecklistTask RegistrationChecklistTasks;
        public List<regChkListTaskWrapper> RegistrationChecklistTasks; 
        public wwwViadComV1_all.ShowInstanceChecklistItem ShowInstanceChecklistItem;
        public String ExhibitorName;
        public String Hall;
        public Integer RegChkLstTaskId;
        public String StandType;
        public String Status;
        public DateTime SubmittedOn;
        public DateTime UpdatedOn;
        
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
        public String ExhibitorName;
        // public String Hall;
        public String RegistrationChecklistTaskId;
        // public String StandType;
        public String Status;
        public String SubmittedOn;
        public String UpdatedOn;
        public String readStatus;
        public boolean isSelected;
        public String BoothType;
        public String Zone;
        public String BoothNumber;
        
        public regChkListTaskWrapper(wwwViadComV1_all.RegistrationChecklistTask receivedTask, String readStatus){
            this.ExhibitorName = String.isNotBlank(receivedTask.ExhibitorName)? receivedTask.ExhibitorName: '';
            this.RegistrationChecklistTaskId = receivedTask.RegistrationChecklistTaskId !=null ? String.valueOf(receivedTask.RegistrationChecklistTaskId): '';
            this.SubmittedOn = receivedTask.SubmittedOn !=null ? receivedTask.SubmittedOn.format(): '';
            this.UpdatedOn = receivedTask.UpdatedOn !=null ? receivedTask.UpdatedOn.format(): '';
            this.Status = String.isNotBlank(receivedTask.Status)? receivedTask.Status: '';
            this.readStatus=readStatus;
            isSelected = false;
            this.BoothType = String.isNotBlank(receivedTask.BoothType)? receivedTask.BoothType: '';
            this.Zone = String.isNotBlank(receivedTask.Zone)? receivedTask.Zone: '';
            this.BoothNumber = String.isNotBlank(receivedTask.BoothNumber)? receivedTask.BoothNumber: '';

        }
    }
    
    /* Methods to be GetRegistrationCheckListTask report till  here --report6*/
    
    /* Methods to be GetRegistrationCheckListTaskDetails report from here --report7*/
    @RemoteAction
    global static String RegistrationCheckListTaskDetails (String projectNumber, Integer regCheckListTaskId){  
        Boolean validationFlag =validateUser(projectNumber);
        String expressoSessionId=getExSessionID();
        RegChkListTaskDetailsItemsWrapper reportWrapper = new RegChkListTaskDetailsItemsWrapper();           
        if(validationFlag){
            try{
                wwwViadComV1_all.BasicHttpBinding_IExhibitorService IExhibitorServiceObject= new wwwViadComV1_all.BasicHttpBinding_IExhibitorService(); 
                wwwViadComV1_all.RegistrationChecklistTaskDetails reportObject= IExhibitorServiceObject.GetRegistrationChecklistTaskDetails(expressoSessionId, regCheckListTaskId);
                //system.debug('reportObject==='+reportObject); 
                // deserialize the recieved response 
                reportWrapper = deserializeRegChkTaskDtlListReport(reportObject);             
                
            }catch(exception e){
                system.debug('error message==='+e.getMessage()); 
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There is some issue with the web services. Please wait till it is fixed. Thank you!'));
                
            }
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please contact your GES Account Manager for Analytics access. Thank You!'));
        }
        String jsonReportString = JSON.serialize(reportWrapper);
        return jsonReportString;
    }
    
    //method to deserialize the response object recieved from Expresso
    public static RegChkListTaskDetailsItemsWrapper deserializeRegChkTaskDtlListReport(wwwViadComV1_all.RegistrationChecklistTaskDetails  recievedObject){
        RegChkListTaskDetailsItemsWrapper reportWrapper = new RegChkListTaskDetailsItemsWrapper(); // to be returned from this method
        List<RegChkListTaskDetailsItemWrapper> RegChkDtlList = new List<RegChkListTaskDetailsItemWrapper>();
        wwwViadComV1_all.RegistrationChecklistTaskDetails registrationChecklistTaskDetails = new wwwViadComV1_all.RegistrationChecklistTaskDetails();
        registrationChecklistTaskDetails = recievedObject;
        //system.debug('ShowInstanceChecklistItem ==='+e.getMessage());
        if(registrationChecklistTaskDetails != null){
            RegChkListTaskDetailsItemWrapper  regListWrap = new RegChkListTaskDetailsItemWrapper(registrationChecklistTaskDetails);
            RegChkDtlList.add(regListWrap);
        }
        reportWrapper.RegChkTaskDtlList = RegChkDtlList;
        system.debug('Report wrapper ==='+reportWrapper);
        system.debug('RegChkDtlList ==='+RegChkDtlList);
        return reportWrapper;
        
    }
    
    public class RegChkListTaskDetailsItemsWrapper {
        public List<RegChkListTaskDetailsItemWrapper> RegChkTaskDtlList;
    }
    
    public class RegChkListTaskDetailsItemWrapper{
        public wwwViadComV1_all.ArrayOfRegistrationChecklistStatusDetail RegistrationChecklistStatusDetails;
        public wwwViadComV1_all.RegistrationChecklistTask RegistrationChecklistTask;
        
        public RegChkListTaskDetailsItemWrapper(wwwViadComV1_all.RegistrationChecklistTaskDetails  regChkTaskDetailsList){
            this.RegistrationChecklistStatusDetails = (regChkTaskDetailsList.RegistrationChecklistStatusDetails);
            this.RegistrationChecklistTask = (regChkTaskDetailsList.RegistrationChecklistTask);
        }
    }
    
    /* Methods for GetRegistrationCheckListTaskDetails report till here --report7*/
    
    
    //method to go back to the Report List
    public static Pagereference returnToReportList(){
        String projectNumber   =   Apexpages.currentPage().getParameters().get('projectNumber');
        String showId          =   Apexpages.currentPage().getParameters().get('showId');
        String isLightning     =   Apexpages.currentPage().getParameters().get('isLightning');
        String isCommunity     =   Apexpages.currentPage().getParameters().get('isCommunity'); 
        
        pageReference pager = Page.GC_Community_ExpressoReportsList;
        pager.getParameters().put('showId',showId);
        if(string.isNotBlank(isLightning)){
            pager.getParameters().put('isLightning',isLightning);
        }
        if(string.isNotBlank(isCommunity)){
                pager.getParameters().put('isCommunity',isCommunity);
        }
        pager.getParameters().put('projectNumber',projectNumber);
        pager.setRedirect(true);
        return pager;                        
    }
    
    public static string getExSessionID() {
        List<GC_Core_Session__c> existingSessionObjects = [SELECT Id, Expresso_Session_ID__c, Expresso_Session_Expiration__c, Expresso_Session_Error_Message__c FROM GC_Core_Session__c WHERE OwnerId = :UserInfo.getUserId() order by LastModifiedDate desc];
        //system.debug('existingSessionObjects===='+existingSessionObjects);  
        if(existingSessionObjects.size()==0){
            if(Test.isRunningTest()){
                //system.debug('Returning a test session Id');
                exSessionObject = new GC_Core_Session__c();
                exSessionObject.Expresso_Session_ID__c= '1111111111111111111';
                Datetime currentDT = Datetime.now();
                exSessionObject.Expresso_Session_Expiration__c= currentDT.addDays(20);
                return exSessionObject.Expresso_Session_ID__c;
                
            }else{
                exSessionObject = new GC_Core_Session__c();
                wwwViadComSecurityV2Vaccc.BasicHttpBinding_IAuthenticationService appSecurity = new wwwViadComSecurityV2Vaccc.BasicHttpBinding_IAuthenticationService();
                //appSecurity.endpoint_x =  'https://uatapi.viad.com/Security/v2/AuthenticationService.svc' ;
                wwwViadComSecurityV2Vaccc.AppSessionInfo responseAppSessionInfo = appSecurity.StartAppSession(System.Label.GC_Label_AppID,  System.Label.GC_Label_AppKey, '', '');
                exSessionObject.Expresso_Session_ID__c= responseAppSessionInfo.SessionID;
                exSessionObject.Expresso_Session_Expiration__c= responseAppSessionInfo.Expiration;
                upsert exSessionObject;
                system.debug('creating and returning a new session==='); 
                return exSessionObject.Expresso_Session_ID__c;
            }
        }
        else{
            exSessionObject = existingSessionObjects.get(0);
            if(exSessionObject.Expresso_Session_Expiration__c == null || exSessionObject.Expresso_Session_Expiration__c < DateTime.Now()){
                if(Test.isRunningTest()){
                    exSessionObject = new GC_Core_Session__c();
                    exSessionObject.Expresso_Session_ID__c= '1111111111111111111';
                    Datetime currentDT = Datetime.now();
                    exSessionObject.Expresso_Session_Expiration__c= currentDT.addDays(20);
                    return exSessionObject.Expresso_Session_ID__c;
                }else{
                    wwwViadComSecurityV2Vaccc.BasicHttpBinding_IAuthenticationService appSecurity = new wwwViadComSecurityV2Vaccc.BasicHttpBinding_IAuthenticationService();
                    wwwViadComSecurityV2Vaccc.AppSessionInfo responseAppSessionInfo = appSecurity.StartAppSession(System.Label.GC_Label_AppID,  System.Label.GC_Label_AppKey, '', '');
                    exSessionObject.Expresso_Session_ID__c= responseAppSessionInfo.SessionID;
                    exSessionObject.Expresso_Session_Expiration__c= responseAppSessionInfo.Expiration;
                    //system.debug('Returning a created session Id');
                    system.debug('session expired, creating, updating and then returning===');
                    upsert exSessionObject;
                    return exSessionObject.Expresso_Session_ID__c;
                }
            }
            else{
                system.debug('returning existing session===');
                exSessionObject = existingSessionObjects.get(0);
            }
        }
        return exSessionObject.Expresso_Session_ID__c;
    }
    
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
        RegChkTaskStatus derivedMapObject= (RegChkTaskStatus)JSON.deserializeStrict(mapObject.Staus_Map__c, RegChkTaskStatus.Class);
        return derivedMapObject;
    }
    
    public class RegChkTaskStatus{
        //public Map<String, String> mapReadStatusToId;
        public Map<String, List<String>> mapOfReadTasksToParent;
        public String projectNumber;
        
        public RegChkTaskStatus(){
            this.mapOfReadTasksToParent= new Map<String, List<String>>();
        }
        
        public RegChkTaskStatus(String projectNumber, String showInstanceCheckListId, List<wwwViadComV1_all.RegistrationChecklistTask> receivedTasks){
            this.projectNumber= projectNumber;
            mapOfReadTasksToParent= new Map<String, List<String>>();
            //mapReadStatusToId = new Map<String, String>();
            for(wwwViadComV1_all.RegistrationChecklistTask varTask: receivedTasks){
                if(!mapOfReadTasksToParent.containsKey(showInstanceCheckListId)){
                    mapOfReadTasksToParent.put(showInstanceCheckListId,new List<string>());
                }
            }
        }
    }
    
    
    public static Boolean validateUser(String projectNumber) {          
        GC_Show_Team_Member__c teamMember = new GC_Show_Team_Member__c(); 
        GC_Connect2_Show__c show = new GC_Connect2_Show__c();
        String userID= UserInfo.getUserId();
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
                system.debug('e.message==='+e.getMessage());
            }
        }            
        if(teamMember.Show_Analytics_Role__c || System.Label.GC_Label_ProfilesForAnalytics.contains(UserInfo.getProfileId())){
            return true;
        }else{
            return false;
        }
    }
    
    public static Boolean markAsRead(String projectNumber, List<String> readTasks, String showInstanceCheckListId){
        try{
            //system.debug('inside markAsRead');
            List<GC_RegistrationChecklistTask__c> existingMapObjects = [SELECT Id, Staus_Map__c,Project_Number__c  FROM GC_RegistrationChecklistTask__c WHERE Project_Number__c = :projectNumber order by LastModifiedDate desc];
            GC_RegistrationChecklistTask__c mapObject = existingMapObjects.get(0);
            RegChkTaskStatus derivedMapObject= (RegChkTaskStatus)JSON.deserializeStrict(mapObject.Staus_Map__c, RegChkTaskStatus.Class);
            if(!derivedMapObject.mapOfReadTasksToParent.containsKey(showInstanceCheckListId)){
                derivedMapObject.mapOfReadTasksToParent.put(showInstanceCheckListId, new List<String>());
            }
            for(String readId:readTasks){
                if(!derivedMapObject.mapOfReadTasksToParent.get(showInstanceCheckListId).contains(readId)){
                    derivedMapObject.mapOfReadTasksToParent.get(showInstanceCheckListId).add(readId);
                }
            }
            
            
            String jsonMap= JSON.serialize(derivedMapObject);
            mapObject.Staus_Map__c= jsonMap;
            upsert mapObject; 
            return true;
        }catch(exception e){
            system.debug(e.getMessage());
            return false;
        }
        
    }
    
    /* Method to print multiple tasks in one pdf from here */
    @RemoteAction
    global static String PrintSlectedTasksApex(String projectNumber,List<String> selectedTaskIds, String showInstanceCheckListId){
        if(selectedTaskIds.size()>0){
            markAsRead(projectNumber,selectedTaskIds, showInstanceCheckListId);
            String jsonSelectedTaskIds= JSON.serialize(selectedTaskIds);
            GC_Core_Interface_Log__c objectToStoreIds = new GC_Core_Interface_Log__c ();
            objectToStoreIds.Message_Content__c = jsonSelectedTaskIds;
            objectToStoreIds.Method_Name__c = 'PrintSlectedTasksApex';
            upsert objectToStoreIds; 
            return (string.valueOf(objectToStoreIds.Id));
        }else{
            DmlException e = new DmlException();
            e.setMessage('No IDs selected. Please select one.');
            throw e;
            return null;
        }
        
    }    
    /* Method to print multiple tasks in one pdf till here*/
    
    public static GC_Connect2_Show__c getShowDetails(String projectNumber){
        GC_Connect2_Show__c currentShow = new GC_Connect2_Show__c();
        try{
            currentShow=[SELECT id, Name, Show_Name__c, Show_Start_Date__c,Show_End_Date__c FROM GC_Connect2_Show__c WHERE Job_Number__c=:projectNumber LIMIT 1];
        }catch(exception e){
            system.debug(e.getMessage());
        }
        return currentShow;
    }
}