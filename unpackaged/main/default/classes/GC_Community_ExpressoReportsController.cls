/**
* @author rahul sinha For SLK Software Services
* @description Controller for the Expresso Report pages on community
* 2018-01-25 : Original Version
* 2018-07-05 : Added new method 
* 2019-02-05 : Commented lines removal and addition of new checks in case user enters a project number not in SFDC Org
**/
public with sharing class GC_Community_ExpressoReportsController {
    Public String projectNumber{get; set;}
    Public String showId{get; set;}
    Public Date startDate{get; set;}
    Public Date endDate{get; set;}
    public Boolean isClassic{get; set;}
    public Boolean isLightningComm{get; set;}
    Public String showHeaderVal{get; set;}
    Public String isLightning{get; set;}
    Public String isCommunity{get; set;}
    GC_Connect2_Show__c show = new GC_Connect2_Show__c();
    public GC_Community_ExpressoReportsController() {
        projectNumber   =   Apexpages.currentPage().getParameters().get('projectNumber');
        showId          =   Apexpages.currentPage().getParameters().get('showId');   
        isCommunity     =   Apexpages.currentPage().getParameters().get('isCommunity');
        isLightning          =   Apexpages.currentPage().getParameters().get('isLightning'); 
        //system.debug('projectNumber='+projectNumber+' showId='+showId);     
        startDate= date.today();
        endDate= date.today();
        isLightningComm= false;
        String ntwrkId = Network.getNetworkId();
        //system.debug('ntwrkId==='+ntwrkId);
        if(ntwrkId==null){
            isClassic= true;
            showHeaderVal='true';
            
        }else{
            isClassic= false;
            showHeaderVal='false';
        }
        if(string.isNotBlank(isCommunity)){
            isClassic= false;
            showHeaderVal='false';
        }
        if(string.isNotBlank(isLightning)){
            isLightningComm= true;
        }
    }    

    public void generateSessionID() {
        try{
            String x= ExhibitorOrderShowProgressController.getExSessionID();
        }catch(CalloutException e){
            System.debug(e.getMessage());
        }
        
    }

    public PageReference ExhibitorOrderShowProgress() {
        GC_Show_Team_Member__c teamMember = new GC_Show_Team_Member__c(); 
        GC_Connect2_Show__c show = new GC_Connect2_Show__c();
        String userID= UserInfo.getUserId();
        if(projectNumber.length()!=9){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter a project number of Nine Characters. Thank you!'));
            return null;
        }else{
            try{
                try{
                    show=[SELECT id, Show_Name__c, Show_Start_Date__c, Show_End_Date__c,Job_Number__c FROM GC_Connect2_Show__c WHERE Job_Number__c=:projectNumber LIMIT 1];
                }catch(Exception e){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This Project Number is not associated with a show present in this org. Please check with your System Administrator.'));
                    return null;
                } 
                teamMember=[Select id, Show_Analytics_Role__c, Connect2_Show__r.Job_Number__c, Connect2_Show__c, Connect2_Show__r.Id from GC_Show_Team_Member__c where User__c= :userID AND Connect2_Show__r.Job_Number__c = :projectNumber Limit 1];
                                               
            }catch(Exception e){                
                system.debug('e.message==='+e.getMessage());                
            }
        }       
        
        if(teamMember.Show_Analytics_Role__c || System.Label.GC_Label_ProfilesForAnalytics.contains(UserInfo.getProfileId()) ){
            pageReference pager = Page.GC_Community_ShowReport;
            pager.getParameters().put('showId',show.Id);
            pager.getParameters().put('projectNumber',projectNumber);
            if(string.isNotBlank(isLightning)){
                pager.getParameters().put('isLightning',isLightning);
            }
            if(string.isNotBlank(isCommunity)){
                pager.getParameters().put('isCommunity',isCommunity);
            }
            pager.setRedirect(true);
            return pager;                        
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please contact your GES Account Manager for Analytics access. Thank You!'));
        }
        return null;
    }
    
    public PageReference ExhibitorOrdersByCategory() {
        GC_Show_Team_Member__c teamMember = new GC_Show_Team_Member__c(); 
        GC_Connect2_Show__c show = new GC_Connect2_Show__c();
        String userID= UserInfo.getUserId();
        if(projectNumber.length()!=9){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter a project number of Nine Characters. Thank you!'));
            return null;
        }else{
            try{
                try{
                    show=[SELECT id, Show_Name__c, Show_Start_Date__c, Show_End_Date__c,Job_Number__c FROM GC_Connect2_Show__c WHERE Job_Number__c=:projectNumber LIMIT 1];
                }catch(Exception e){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This Project Number is not associated with a show present in this org. Please check with your System Administrator.'));
                    return null;
                } 
                teamMember=[Select id, Show_Analytics_Role__c, Connect2_Show__r.Job_Number__c, Connect2_Show__c, Connect2_Show__r.Id from GC_Show_Team_Member__c where User__c= :userID AND Connect2_Show__r.Job_Number__c = :projectNumber Limit 1];
                                  
            }catch(Exception e){
                system.debug('e.message==='+e.getMessage());
            }
        }
        
        if(teamMember.Show_Analytics_Role__c || System.Label.GC_Label_ProfilesForAnalytics.contains(UserInfo.getProfileId()) ){
            String startDateStr= String.valueOf(startDate);
            String endDateStr= String.valueOf(endDate);
            pageReference pager = Page.GC_Community_ExhibitorOrdersByCategory ;
            pager.getParameters().put('showId',show.Id);
            pager.getParameters().put('projectNumber',projectNumber);
            pager.getParameters().put('startDateStr',startDateStr);
            pager.getParameters().put('endDateStr',endDateStr);
            if(string.isNotBlank(isLightning)){
                pager.getParameters().put('isLightning',isLightning);
            }
            if(string.isNotBlank(isCommunity)){
                pager.getParameters().put('isCommunity',isCommunity);
            }
            pager.setRedirect(true);
            return pager;                        
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please contact your GES Account Manager for Analytics access. Thank You!'));
        }
        return null; 
    }
    
    public PageReference SubmittedFormShowProgress() {        
        GC_Show_Team_Member__c teamMember = new GC_Show_Team_Member__c(); 
        GC_Connect2_Show__c show = new GC_Connect2_Show__c();
        String userID= UserInfo.getUserId();
        if(projectNumber.length()!=9){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter a project number of Nine Characters. Thank you!'));
            return null;
        }else{
            try{
                try{
                    show=[SELECT id, Show_Name__c, Show_Start_Date__c, Show_End_Date__c,Job_Number__c FROM GC_Connect2_Show__c WHERE Job_Number__c=:projectNumber LIMIT 1];
                }catch(Exception e){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This Project Number is not associated with a show present in this org. Please check with your System Administrator.'));
                    return null;
                }
                teamMember=[Select id, Show_Analytics_Role__c, Connect2_Show__r.Job_Number__c, Connect2_Show__c, Connect2_Show__r.Id from GC_Show_Team_Member__c where User__c= :userID AND Connect2_Show__r.Job_Number__c = :projectNumber Limit 1];
                                   
            }catch(Exception e){                
                system.debug('e.message==='+e.getMessage());
            }
        }
        if(teamMember.Show_Analytics_Role__c || System.Label.GC_Label_ProfilesForAnalytics.contains(UserInfo.getProfileId()) ){
            pageReference pager = Page.GC_Community_ExhibitorOnlineFormProgress;
            pager.getParameters().put('showId',show.Id);
            pager.getParameters().put('projectNumber',projectNumber);
            if(string.isNotBlank(isLightning)){
                pager.getParameters().put('isLightning',isLightning);
            }
            if(string.isNotBlank(isCommunity)){
                pager.getParameters().put('isCommunity',isCommunity);
            }
            pager.setRedirect(true);
            return pager;                        
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please contact your GES Account Manager for Analytics access. Thank You!'));
        }
        return null;
    }
    
    public PageReference ExhibitorChecklistStatus() {
        GC_Show_Team_Member__c teamMember = new GC_Show_Team_Member__c(); 
        GC_Connect2_Show__c show = new GC_Connect2_Show__c();
        String userID= UserInfo.getUserId();
        if(projectNumber.length()!=9){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter a project number of Nine Characters. Thank you!'));
            return null;
        }else{
            try{
                try{
                    show=[SELECT id, Show_Name__c, Show_Start_Date__c, Show_End_Date__c,Job_Number__c FROM GC_Connect2_Show__c WHERE Job_Number__c=:projectNumber LIMIT 1];
                }catch(Exception e){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This Project Number is not associated with a show present in this org. Please check with your System Administrator.'));
                    return null;
                } 
                teamMember=[Select id, Show_Analytics_Role__c, Connect2_Show__c, Connect2_Show__r.Job_Number__c, Connect2_Show__r.Id from GC_Show_Team_Member__c where User__c= :userID AND Connect2_Show__r.Job_Number__c = :projectNumber Limit 1];
  
            }catch(Exception e){
                system.debug('e.message==='+e.getMessage());
            }
        }  
        if(teamMember.Show_Analytics_Role__c || System.Label.GC_Label_ProfilesForAnalytics.contains(UserInfo.getProfileId()) ){
            pageReference pager = Page.GC_Community_ExhibitorChecklistStatus;
            pager.getParameters().put('showId',String.valueOf(show.Id));
            pager.getParameters().put('projectNumber',projectNumber);
            if(string.isNotBlank(isLightning)){
                pager.getParameters().put('isLightning',isLightning);
            }
            if(string.isNotBlank(isCommunity)){
                pager.getParameters().put('isCommunity',isCommunity);
            }
            pager.setRedirect(true);
            return pager;                        
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please contact your GES Account Manager for Analytics access. Thank You!'));
        }
        return null;
    }
    
    
/****** This function is added under SAL-674 (Function Start) ******/ 
   
    public PageReference ShowInstanceChecklistItems () {        
        if(checkValidations() ){
            pageReference pager = Page.GC_ShowInstanceChecklistItems;
            pager.getParameters().put('showId',String.valueOf(show.Id));
            pager.getParameters().put('projectNumber',projectNumber);
            if(string.isNotBlank(isLightning)){
                pager.getParameters().put('isLightning',isLightning);
            }
            if(string.isNotBlank(isCommunity)){
                pager.getParameters().put('isCommunity',isCommunity);
            }
            pager.setRedirect(true);
            return pager;                        
        }else{
            
        }
        return null;
    }
    
    public Boolean checkValidations () {
        GC_Show_Team_Member__c teamMember = new GC_Show_Team_Member__c(); 
        show = new GC_Connect2_Show__c();
        String userID= UserInfo.getUserId();
        if(projectNumber.length()!=9){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter a project number of Nine Characters. Thank you!'));
            return false;
        }else{
            try{
                try{
                    show=[SELECT id, Show_Name__c, Show_Start_Date__c, Show_End_Date__c,Job_Number__c FROM GC_Connect2_Show__c WHERE Job_Number__c=:projectNumber LIMIT 1];
                }catch(Exception e){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This Project Number is not associated with a show present in this org. Please check with your System Administrator.'));
                    return false;
                } 
                teamMember=[Select id, Show_Analytics_Role__c, Connect2_Show__c, Connect2_Show__r.Job_Number__c, Connect2_Show__r.Id from GC_Show_Team_Member__c where User__c= :userID AND Connect2_Show__r.Job_Number__c = :projectNumber Limit 1];
                  
            }catch(Exception e){
                teamMember = new GC_Show_Team_Member__c(); 
                system.debug('e.message==='+e.getMessage());
            }
        }
        if(teamMember.Show_Analytics_Role__c || System.Label.GC_Label_ProfilesForAnalytics.contains(UserInfo.getProfileId()) ){
            return true;
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please contact your GES Account Manager for Analytics access. Thank You!'));
            return false;
        }  
    }
    
/****** This function is added under SAL-674 (Function End) to-do reduce code redundancy ******/  

    
}