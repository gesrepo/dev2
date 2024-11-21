/**
* @author Ethos Solutions - www.ethos.com
* @description Controller class for the Header component for community
* 2016-04-13 : Original Version
**/
public with sharing class GC_Community_HeaderController {
    public GC_Connect2_Show__c show {get; set;}
    public GC_Order__c order {get; set;}
    
    public GC_Community_HeaderController() {
        String showId = ApexPages.currentPage().getParameters().get('showId');
        if (String.isNotBlank(showId)) {
            show = GC_Connect2ShowDao.getInstance().getConnect2ShowById(showId);
        }
        String orderId = ApexPages.currentPage().getParameters().get('orderId');
        if (String.isNotBlank(orderId)) {
            order = GC_OrderDao.getInstance().getOrderById(orderId);
        }
    }
    
     public Boolean getDownTimeStart(){
        String customLabelValue = System.Label.GES_Connect_OracleDownTimeNotification;
        system.debug('customLabelValue==='+ customLabelValue);
        String labelStatus= customLabelValue.substringBefore(':');
        if(labelStatus.toLowerCase()=='alert'){
            return true;
        }else{
            return false;
        }
     }
    
    /**
* @description Retrieves show start and end dates
* @return String of start and end dates
**/
    public String getShowDates() {
        return show.Show_Start_Date__c.format() + ' - ' + show.Show_End_Date__c.format();
    }
    
    /**
* @description Determines if user has taskRay permission set assigned.
**/
    public Boolean hasTaskRayAccess {
        get {
            Boolean hasAccess = false;
            List<PermissionSet> taskRayPermSet = [select Id, Name from PermissionSet where Name = 'TaskRay_Standard_Access'];
            if (taskRayPermSet.size() > 0) {
                String permSetId = taskRayPermSet[0].Id;
                List<PermissionSetAssignment> permSetAssignments = [select Id, AssigneeId, PermissionSetId from PermissionSetAssignment where AssigneeId = :UserInfo.getUserId() AND PermissionSetId = :permSetId];
                if (permSetAssignments.size() > 0) {
                    hasAccess = true;
                }
            }
            System.debug('Has Access ' + hasAccess);
            return hasAccess;
        }
    }
    
    public Boolean hasCongressAccess {
        get {
            Boolean hasAccess = false;
            List<Profile> Profile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];  
            String MyProflieName = Profile[0].Name;
            if(MyProflieName == 'GC Congress Client' || MyProflieName == 'GC Congress Internal' || MyProflieName == 'System Administrator' || MyProflieName == 'Digital Products/IT Admin') {
                hasAccess = true;           
            } else {
                hasAccess = false;
            }         
            System.debug('Has Congress Access ' + hasAccess);
            return hasAccess;
        }
    }
    
    public Boolean hasTradeshowAccess {
        get {
            Boolean hasAccess = false;
            List<Profile> Profile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];  
            String MyProflieName = Profile[0].Name;
            if(MyProflieName == 'GC Community Client' || MyProflieName == 'GC Community Vendor' || MyProflieName == 'System Administrator' || MyProflieName == 'Digital Products/IT Admin') {
                hasAccess = true;           
            } else {
                hasAccess = false;
            }         
            System.debug('Has Tradeshow Access ' + hasAccess);
            return hasAccess;
        }
    }
    
    /* Start here- Added this to check access to use analytics page SAL-436 */
    public PageReference navigateAnalytics() {
        System.debug('profile id' + UserInfo.getProfileId());
        String c2ShowID = ApexPages.currentPage().getParameters().get('showId');
        if (String.isNotBlank(c2ShowID)) {
            show = GC_Connect2ShowDao.getInstance().getConnect2ShowById(c2ShowID);
        }
        String userID= UserInfo.getUserId();
        GC_Show_Team_Member__c teamMember = new GC_Show_Team_Member__c();
        try{
            teamMember = [Select id, Show_Analytics_Role__c from GC_Show_Team_Member__c where User__c= :userID AND Connect2_Show__r.Job_Number__c=:show.Job_Number__c Limit 1];
        }catch(Exception e){}       
        
        if(String.isNotBlank(c2ShowID)&& (teamMember.Show_Analytics_Role__c || System.Label.GC_Label_ProfilesForAnalytics.contains(UserInfo.getProfileId()))){
            
                pageReference pager = Page.GC_Community_ExpressoReportsList;
                pager.getParameters().put('showId',show.Id);
                pager.getParameters().put('projectNumber',show.Job_Number__c);
                pager.setRedirect(true);
                return pager;
        }else if(String.isBlank(c2ShowID)){
            pageReference pager = Page.GC_Community_ConnectAnaltyticsHome;          
            pager.setRedirect(true);
            return pager;            
        }
        
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please contact your GES Account Manager for Analytics access. Thank You!'));
        }
        return null;
    }
    
    /* Stop here- Added this to check access to use analytics page SAL-436 */
}