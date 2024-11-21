public  with sharing class LC_ProjectCentralHomePage {
   @AuraEnabled
    public static List<GC_Connect2_Show__c> getShowsApex() {  
     List<GC_Connect2_Show__c> shows =
            [SELECT Id, Name, Show_End_Date__c,FormulaShowDates__c  ,Show_Start_Date__c,Show_Name__c, Opportunity_Name__c,Facility__c, Job_Number__c,Facility_Address__c
              FROM GC_Connect2_Show__c  WHERE Job_Number__c!=null AND Show_End_Date__c>TODAY order by Show_Start_Date__c asc  LIMIT 2000 ];
        return shows;
    } 
      
    //SAL-1215 - added isPastShow parametner in the method call to display the Past shows - 07/26/24 - Sajid
    @AuraEnabled
    public static List<GC_Connect2_Show__c> getrecords(string searchname,date searchbydatefield, Boolean isPastShow) {
        
        searchname= string.isNotBlank(searchname)?searchname.normalizeSpace():searchname;
        String searchKey = '%' + searchname + '%';
        String searchQueryString = 'SELECT Id, Name, Show_End_Date__c,FormulaShowDates__c ,Show_Start_Date__c,Show_Name__c, Opportunity_Name__c,Facility__c, Job_Number__c,Facility_Address__c FROM GC_Connect2_Show__c WHERE Job_Number__c!=null ';
        
        if(searchname != null && searchbydatefield != null){
            searchQueryString +=' AND (Show_Name__c Like :searchKey OR Show_Start_Date__c  =: searchbydatefield)';
        }
        else if(searchname != null){
            searchQueryString += ' AND Show_Name__c Like :searchKey';
        }
        
        else if(searchbydatefield != null){
            searchQueryString += ' AND Show_Start_Date__c  =: searchbydatefield';
        }
        //SAL-1215 - Display the Past shows - 07/26/24 - Sajid
        if(isPastShow){
            searchQueryString += ' AND Show_End_Date__c  < TODAY order by Show_Start_Date__c desc  LIMIT 2000';
        }else{
            searchQueryString += ' AND Show_End_Date__c  >= TODAY';
        }
        //SAL-1215 - end
        
        List<GC_Connect2_Show__c> showsdetail = new  List<GC_Connect2_Show__c>();
        showsdetail = Database.query(searchQueryString);
        return showsdetail;
    } 
    
     @AuraEnabled
    public static string checkUsersPermission() {
        string profileId= userInfo.getProfileId();
        if(System.Label.LC_ProfilesToCreateSTM.contains(userInfo.getProfileId()) || System.Label.LC_ProfilesToCreateSTM.contains(profileId.left(15))){
            return 'canCreateSTM';
        }else{
            throw new AuraHandledException('Please consult your Account Manager');
        }
        
    }
 
    @AuraEnabled
    public static boolean overRidePermissions() {
        return(System.Label.LC_AtShowOverride.contains(UserInfo.getProfileId())); 
    }
    
    @AuraEnabled
    public static string saveNewSTM(GC_Show_Team_Member__c newSTM) {
        try{
            upsert newSTM;
            return null;
        }catch(exception e){
            string errorMessage= e.getMessage();
            return errorMessage ;
        }
    }
    
    //method to be called to maintain the current show on every page
    @AuraEnabled
    public static GC_Connect2_Show__c returnCurrentShow(String projectNumber) {
        GC_Connect2_Show__c currentShow =[SELECT Id, Name, Show_End_Date__c ,Show_Start_Date__c,Show_Name__c, Opportunity_Name__c,Facility__c, Job_Number__c
              FROM GC_Connect2_Show__c WHERE Job_Number__c=:projectNumber];
        return currentShow;
    }
    
 
   /* @AuraEnabled
    public static List<String> getUserSessionID() {
        List<String> results= new List<String>();
        string apiSsn= LC_IntegrationsApexController.getSessionIDWithLogin();
        string userSsn= LC_IntegrationsApexController.getUserSessionID();
        results.add(userSsn);
        results.add(apiSsn);
        return results;
    }*/
    
    @AuraEnabled 
    public static user fetchUser(){
       User u = [select id,FirstName from User where id =: userInfo.getUserId()];
        return u;
    }
}