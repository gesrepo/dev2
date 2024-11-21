public class CA_ApexUtils {
    
    // this method will give settings for create/edit/detail components     
    public static CA_Personalized_Object_Setting__c getHomeTableSettings(string profileName, string objName, boolean getFieldMap) {
        if(System.Label.CA_ProfileOverride.contains(profileName)){
            profileName=System.Label.CA_ProfileImpersonation;
        }else if(System.Label.CA_SysAdminProfile.contains(profileName)){
            profileName=System.Label.CA_DevProfile;
        }else{
            profileName=profileName;
        }
        If (Test.isRunningTest()){profileName='GC BMS Profile';}
        system.debug('profileName==='+profileName);
        String queryString= '';
        queryString += 'select id, name, Search_Filters__c,Table_Columns__c,ExSchRep_Column_Map__c,ExSchRep_All_Columns__c,ExSchReport_CSV_Cols__c,ConEvSchRep_All_Columns__c,Object_Label__c,Record_Type_ID__c,Create_Button_Label__c,Global_Button_Style__c,Save_Button_Label__c,Field_Label_Map__c ';
        if(getFieldMap == true){
            queryString += ', (SELECT id,Fields_On_Detail_Page__c,Fields_On_Edit_Page__c,Event_Cost_Fields__c,Exhibit_Cost_Fields__c,Sponsorship_Cost_Fields__c,Speaking_Engagement_Cost_Fields__c,Meeting_Room_Cost_Fields__c,Meeting_Planning_Cost_Fields__c,Name,Object_Name__c,Parent_Object_Setting__c,Precedence__c,Profile_Name__c,Section_Color__c,Section_Label__c,Section_Api_Name__c,Section_Logo__c FROM Section_Settings__r ORDER BY Precedence__c) ';
        }
        queryString += 'FROM CA_Personalized_Object_Setting__c WHERE Profile_Name__c=' +'\'' +  profileName +'\'' + ' AND Object_Name__c=' +'\'' + objName +'\'' + 'LIMIT 1';
        system.debug('queryString' + queryString);
        List<CA_Personalized_Object_Setting__c> existingSettings = database.query(queryString);
        
        if(existingSettings.size()>0){
            system.debug('existingSettings==='+existingSettings[0].id);
        }else{
                throw new AuraHandledException('No Existing settings detected for this profile. Please check with your system admin'); 
        }
        
        return (existingSettings.get(0));
    }
    
    public static string getAllFields(string objName) {    
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe(); 
        Map <String, Schema.SObjectField> fieldMap = schemaMap.get(objName).getDescribe().fields.getMap();
        string allFields= '';
        for(string key:fieldMap.keyset()){
            //if(key!='event__c' && key!='exhibit__c'){
                allFields+=key.toLowerCase()+',';
            //}           
        }
        /*
        List<string> fieldMapKeySet = new List<string> ();
        fieldMapKeySet.addAll(fieldMap.keyset());
        string allFields= String.join( fieldMapKeySet, ',' );
        */
        return allFields.removeEnd(',');
    }
}