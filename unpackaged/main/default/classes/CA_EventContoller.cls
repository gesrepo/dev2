public class CA_EventContoller {
    
    @AuraEnabled(cacheable=true)  
    public static CA_Personalized_Object_Setting__c getHomePageSettings() {
        CA_Personalized_Object_Setting__c resultObj= new CA_Personalized_Object_Setting__c();
        User currentUser = [select id,Name,profile.name,IsPortalEnabled FROM User Where id =: userInfo.getUserId()];
        string profileName='GC';
        if(System.Label.CA_ProfileOverride.contains(currentUser.profile.name)){
            profileName=System.Label.CA_ProfileImpersonation;
        }else if(System.Label.CA_SysAdminProfile.contains(currentUser.profile.name)){
            profileName=System.Label.CA_DevProfile;
        }else{
            profileName=currentUser.profile.name;
        }
        if(Test.isRunningTest()){profileName='GC BMS Profile';}
        List<CA_Personalized_Object_Setting__c> existingSettings = [select id, name,Logo__c,Record_Type_ID__c,Object_Label__c,Object_Name__c,Profile_Name__c,Available_Tiles__c,Available_Reports__c,Customer_Logo__c,Object_Color__c,Home_Page_Style__c,Analytics_Link__c,Files_Link__c,Graphic_Proofing_Link__c,Ordering_Link__c,Tasks_Link__c,Consolidated_PowerBI__c FROM CA_Personalized_Object_Setting__c WHERE Profile_Name__c=:profileName and Object_Name__c='CA_Main_Event__c' LIMIT 1];
        if(existingSettings.size()>0){
            resultObj=existingSettings.get(0);
            if( System.Label.CA_SysAdminProfile.contains(currentUser.profile.name) || System.Label.CA_ProfileOverride.contains(currentUser.profile.name)){
                resultObj.Available_Tiles__c+=';Admin';
                return resultObj;
                
            }            
            system.debug('existingSettings==='+existingSettings[0].id);
        }else{
            throw new AuraHandledException('No Existing settings detected for this profile. Please check with your system admin'); 
        }
        return (existingSettings.get(0));
    }

  // this method will give settings for create/edit/detail components    
    @AuraEnabled(cacheable=true)  
    public static CA_Personalized_Object_Setting__c getObjSettings() {
        User currentUser = [select id,Name,profile.name,IsPortalEnabled FROM User Where id =: userInfo.getUserId()];
        string profileName='GC';
        if(System.Label.CA_ProfileOverride.contains(currentUser.profile.name)){
            //system.debug('user is=='+currentUser.profile.name);
            profileName=System.Label.CA_ProfileImpersonation;
        }else if(System.Label.CA_SysAdminProfile.contains(currentUser.profile.name)){
            profileName=System.Label.CA_DevProfile;
        }else{
            profileName=currentUser.profile.name;
        }
        if(Test.isRunningTest()){profileName='GC BMS Profile';}
        List<CA_Personalized_Object_Setting__c> existingSettings = [select id, name, Delete_Children__c,Record_Type_ID__c,Field_Label_Map__c,Logo__c,Number_Of_Sections__c,Object_Color__c,Object_Label__c,Object_Name__c,Profile_Name__c,Run_Trigger__c,Error_Message__c,Save_Button_Label__c,Success_Message__c,Global_Button_Style__c,Home_Page_Style__c,Consolidated_PowerBI__c,Available_Reports__c, (SELECT id,Fields_On_Detail_Page__c,Fields_On_Edit_Page__c,Name,Object_Name__c,Parent_Object_Setting__c,Precedence__c,Profile_Name__c,Section_Color__c,Section_Label__c,Section_Api_Name__c,Section_Logo__c FROM Section_Settings__r ORDER BY Precedence__c) FROM CA_Personalized_Object_Setting__c WHERE Profile_Name__c=:profileName and Object_Name__c='CA_Main_Event__c'  LIMIT 1];
        
        if(existingSettings.size()>0){
            system.debug('existingSettings==='+existingSettings[0].id);
        }else{
            throw new AuraHandledException('No Existing settings detected for this profile. Please check with your system admin'); 
        }
        return (existingSettings.get(0));
    }
}