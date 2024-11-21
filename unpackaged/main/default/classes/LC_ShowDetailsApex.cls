// The class is without sharing to override the difficulties in getting facility name
public without sharing class LC_ShowDetailsApex {

    // method to get the show details to display on each page in community.
    @AuraEnabled
    public static GC_Connect2_Show__c showDetils(string showId,String jobNo){
        GC_Connect2_Show__c shw=new GC_Connect2_Show__c();
        if(String.isNotBlank(showId)&&String.isBlank(jobNo))
        {
           shw=[SELECT Id,Show_Name__c,Show_Start_Date__c,Show_End_Date__c,Facility_lk__r.Name FROM  GC_Connect2_Show__c WHERE Id=:showId]; 
        }
        if(String.isNotBlank(jobNo)&&String.isBlank(showId)){
            shw=[SELECT Id,Show_Name__c,Show_Start_Date__c,Show_End_Date__c, Facility_lk__r.Name FROM  GC_Connect2_Show__c WHERE Job_Number__c=:jobNo];
        }
        if((String.isNotBlank(jobNo))&&(String.isNotBlank(showId))){
            shw=[SELECT Id,Show_Name__c,Show_Start_Date__c,Show_End_Date__c, Facility_lk__r.Name FROM  GC_Connect2_Show__c WHERE Id=:showId AND Job_Number__c=:jobNo];
        }
        if((jobNo == 'undefined')&&(String.isNotBlank(showId))){
            shw=[SELECT Id,Show_Name__c,Show_Start_Date__c,Show_End_Date__c, Facility_lk__r.Name FROM  GC_Connect2_Show__c WHERE Id=:showId];
        }
      
        return shw;
        
    }
    
    // method to get the user details for welcome page
    @AuraEnabled 
    public static user fetchUser(){
       User currentUser = [SELECT Id,FirstName FROM User WHERE Id =: userInfo.getUserId()];
        return currentUser;
    }
      @AuraEnabled
    public static string getShows(string ShowsId) {
    GC_Connect2_Show__c shows =new GC_Connect2_Show__c();
     shows=[SELECT Id, Name, Job_Number__c,Facility_Address__c  FROM GC_Connect2_Show__c WHERE Id =:ShowsId];
        return shows.Job_Number__c;
    } 
      
    
}