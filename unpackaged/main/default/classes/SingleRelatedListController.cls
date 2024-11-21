public without sharing class SingleRelatedListController {
    public static final String FIELDS_PARAM = 'fields';
    public static final String NUMBER_OF_RECORDS_PARAM = 'numberOfRecords';
    public static final String RECORD_ID_PARAM = 'recordId';
    public static final String SOBJECT_API_NAME_PARAM = 'sobjectApiName';
    public static final String SOBJECT_LABEL_PARAM = 'sobjectLabel';
    public static final String SOBJECT_LABEL_PLURAL_PARAM = 'sobjectLabelPlural';
    public static final String PARENT_RELATIONSHIP_API_NAME_PARAM = 'parentRelationshipApiName';
    public static final String RELATED_FIELD_API_NAME_PARAM = 'relatedFieldApiName';
    public static final String SORTED_DIRECTION_PARAM = 'sortedDirection';
    public static final String SORTED_BY_PARAM = 'sortedBy';
    public static final String RECORDS_PARAM = 'records';
    public static final String ICON_NAME_PARAM = 'iconName';
    
    @AuraEnabled
    public static Object getMainEventId(String activityObject, String activityId){
        String activityQueryString = 'SELECT Id, Event__c FROM ' + activityObject + ' WHERE Id = ' + '\'' + activityId + '\''; 
        system.debug('activityQueryString====' + activityQueryString);
        List<Object> activityObjectRec = Database.query(activityQueryString);
        system.debug('activityObjectRec====' + activityObjectRec);
        return activityObjectRec[0];
    }
    
    @InvocableMethod(label='Get Account Names' description='Returns the list of account names corresponding to the specified account IDs.')
    public static void getMainEvent(List<String> activityObject){
        
    }
    
    @AuraEnabled
    public static String initData(String jsonData){
        Map<String, Object> requestMap = (Map<String, Object>)JSON.deserializeUntyped(jsonData);  
        Map<String, Object> responseMap = new Map<String, Object>();
        responseMap.put(RECORDS_PARAM, getRecords(jsonData));
        
        String sobjectApiName = (String)requestMap.get(SOBJECT_API_NAME_PARAM);
        system.debug('sobjectApiName'+sobjectApiName);
        responseMap.put(ICON_NAME_PARAM, getIconName(sobjectApiName));
        String recordId = (String)requestMap.get(RECORD_ID_PARAM);
        responseMap.put(PARENT_RELATIONSHIP_API_NAME_PARAM, getParentRelationshipName(recordId, sobjectApiName));
        
        Schema.SObjectType sobjectType = Schema.getGlobalDescribe().get(sobjectApiName);
        Schema.DescribeSObjectResult sobjectDescribe = sobjectType.getDescribe();
        responseMap.put(SOBJECT_LABEL_PARAM, sobjectDescribe.getLabel());
        responseMap.put(SOBJECT_LABEL_PLURAL_PARAM, sobjectDescribe.getLabelPlural());
        return JSON.serialize(responseMap);
    }
    
    @AuraEnabled
    public static List<Sobject> getRecords(String jsonData){
        Map<String, Object> root = (Map<String, Object>)JSON.deserializeUntyped(jsonData);  
        String fields = (String)root.get(FIELDS_PARAM);
        Integer numberOfRecords = (Integer)root.get(NUMBER_OF_RECORDS_PARAM);
        String recordId = (String)root.get(RECORD_ID_PARAM);
        String relatedFieldApiName = (String)root.get(RELATED_FIELD_API_NAME_PARAM);
        String sobjectApiName = (String)root.get(SOBJECT_API_NAME_PARAM);        
        String orderBy = (String)root.get(SORTED_BY_PARAM) + ' ' + (String)root.get(SORTED_DIRECTION_PARAM);        
        
        String query = 'Select '+fields+' From '+sobjectApiName+' WHERE ' +relatedFieldApiName+ '= :recordId ORDER BY ' +orderBy+' Limit :numberOfRecords';
        return Database.query(String.escapeSingleQuotes(query));
    }
    
    private static String getParentRelationshipName(Id recordId, String parentSobjectName){
        Schema.DescribeSObjectResult descrRes = recordId.getSObjectType().getDescribe();
        String name;
        for (Schema.ChildRelationship cr: descrRes.getChildRelationships()){ 
            if(cr.getChildSObject().getDescribe().getName() == parentSobjectName){
                name = cr.getRelationshipName();
                break;
            }
        }
        return name;
    }
    
    @AuraEnabled
    public static Boolean deleteRecord(Id recordId){
        Boolean flag=false;
        String objectType = recordId.getSObjectType().getDescribe().getName();
        
        //condition added by rsinha for Customer Connect Community
        if(objectType.containsIgnoreCase('CA_')){
            CA_RecordBannerApexController.deleteRecord(recordId);
            return true;
        }
        Sobject sobj = recordId.getSObjectType().newSObject(recordId);
        if( objectType != 'GT_Brand__c'){
            String brandQueryString = 'SELECT Id, Name, Event__c, Exhibit__c, 	Meeting_Planning__c,Meeting_Room__c, Membership__c, Registration_Attend_Only__c, Speaking_Engagement__c, Sponsorship__c,Sporting_Event__c FROM GT_Brand__c WHERE ';
            switch on objectType {
                when 'GT_Exhibit__c' {
                    brandQueryString += ' Exhibit__c =' + '\'' + recordId + '\'';
                }
                when 'GT_Event_RL__c' {
                    brandQueryString += ' Event__c =' + '\'' + recordId + '\'';
                }
                when 'GT_Meeting_Room__c' {
                    brandQueryString += ' Meeting_Room__c =' + '\'' + recordId + '\'';
                }
                when 'GT_Meeting_Planning__c' {
                    brandQueryString += ' Meeting_Planning__c =' + '\'' + recordId + '\'';
                }
                when 'GT_Sporting_Event__c' {
                    brandQueryString += ' Sporting_Event__c =' + '\'' + recordId + '\'';
                }
                when 'GT_Membership__c' {
                    brandQueryString += ' Membership__c =' + '\'' + recordId + '\'';
                }
                when 'GT_Sponsorship__c' {
                    brandQueryString += ' Sponsorship__c =' + '\'' + recordId + '\'';
                }
                when 'GT_Speaking_Engagement__c' {
                    brandQueryString += ' Speaking_Engagement__c =' + '\'' + recordId + '\'';
                }
                when 'GT_Reg_Attend_Only__c' {
                    brandQueryString += ' Registration_Attend_Only__c =' + '\'' + recordId + '\'';
                }
            }
            //String queryString = brandQueryString + whereCondition;
            system.debug('???????????????' + brandQueryString);
            List<GT_Brand__c> relatedBrandRecords = Database.Query(brandQueryString);        
            List<Database.DeleteResult> deleteBrandRecordsResult = new List<Database.DeleteResult>();
            try{
                if(relatedBrandRecords.size() > 0){
                    deleteBrandRecordsResult = Database.delete(relatedBrandRecords, true); 
                }                
                Database.DeleteResult result= Database.delete(sobj, true);
                if(relatedBrandRecords.size() > 0){
                    flag= (deleteBrandRecordsResult[0].isSuccess() && result.isSuccess());
                }
                else{
                    flag= (result.isSuccess());
                }
            }catch(DmlException e){
                //throw newAurhadledexception
            }
            return flag;
        }
        else{
            Database.DeleteResult result = Database.delete(sobj, true);
            return result.isSuccess();
        }
    }   

    

    @AuraEnabled
    public static String getIconName(String sobjectApiName){
        String iconName;
        List<Schema.DescribeTabSetResult> tabSetDesc = Schema.DescribeTabs();
        List<Schema.DescribeTabResult> tabDesc = new List<Schema.DescribeTabResult>();
        List<Schema.DescribeIconResult> iconDesc = new List<Schema.DescribeIconResult>();
        
        for(Schema.DescribeTabSetResult tsr : tabSetDesc) { 
            tabDesc.addAll(tsr.getTabs()); 
        }
        
        for(Schema.DescribeTabResult tr : tabDesc) {
            if( sobjectApiName == tr.getSobjectName() ) {
                if( tr.isCustom() ) {
                    iconDesc.addAll(tr.getIcons());
                } else {
                    iconName = 'standard:' + sobjectApiName.toLowerCase();
                }
            }
        }
        for (Schema.DescribeIconResult ir : iconDesc) {
            if (ir.getContentType() == 'image/svg+xml'){
                iconName = 'custom:' + ir.getUrl().substringBetween('custom/','.svg').substringBefore('_');
                break;
            }
        }
        system.debug('iconName'+iconName);
        return iconName;
    }   
    
    
    @AuraEnabled
    public Static String getProfileName(){
        id userId = userinfo.getProfileId();
        LIST<profile> ProfileName = new LIST<profile>();
        ProfileName = [select Name from profile where id = :userId LIMIT 1];
        system.debug(ProfileName[0].Name);
        Return ProfileName[0].Name;
    }
    
    @AuraEnabled
    public static string relatedObjectNameToQuery(Id recordId){
        string objectNameToReturn=String.valueOf(recordId.getSObjectType());  
        if(objectNameToReturn == 'GT_Event__c'){
            objectNameToReturn='GT_Event__c';
        }
        if(objectNameToReturn == 'GT_Exhibit__c'){
            objectNameToReturn='Exhibit__c';
        }
        if(objectNameToReturn == 'GT_Sponsorship__c'){
            objectNameToReturn='Sponsorship__c';
        }
        if(objectNameToReturn == 'GT_Meeting_Room__c'){
            objectNameToReturn='Meeting_Room__c';
        }
        /*if(objectNameToReturn == 'GT_Product_Theater__c'){
objectNameToReturn='Product_Theater__c';
}
if(objectNameToReturn == 'GT_Symposia__c'){
objectNameToReturn='Symposia__c';
}*/
        if(objectNameToReturn == 'GT_Speaking_Engagement__c'){
            objectNameToReturn='Speaking_Engagement__c';
        }
        if(objectNameToReturn == 'GT_Brand__c'){
            objectNameToReturn='GT_Brand__c';
        }
        if(objectNameToReturn == 'GT_Meeting_Planning__c'){
            objectNameToReturn='Meeting_Planning__c';
        }
        if(objectNameToReturn == 'GT_Event_RL__c'){
            objectNameToReturn='Event__c';
        }
        return objectNameToReturn;
    }
    
    @AuraEnabled
    public static Date exhibitOpenDateOfCOngress(string recordId){
        GT_Event__c event=[select Id,Exhibit_Open_Date__c from GT_Event__c where id=:recordId];
        return event.Exhibit_Open_Date__c;
    }
    
    @AuraEnabled
    public static String getSObjectName(string activityRecordId){
        return (String)Id.valueOf(activityRecordId).getSObjectType().getDescribe().getName();
    }
    
    @AuraEnabled
    public static CA_BannerSettings getPerObjSettings(string recId, String objectName){
        CA_BannerSettings settingsObj= new CA_BannerSettings();
        User currentUser = [select id,Name,profile.name,IsPortalEnabled FROM User Where id =: userInfo.getUserId()];
        CA_Personalized_Object_Setting__c mainObjSet = CA_ApexUtils.getHomeTableSettings(currentUser.profile.name, 'CA_Main_Event__c', false);
        CA_Personalized_Object_Setting__c perObjSet=CA_ApexUtils.getHomeTableSettings(currentUser.profile.name, objectName, false);
        if(String.isNotBlank(perObjSet.Object_Label__c))
        settingsObj.objLabel = perObjSet.Object_Label__c;
        if(String.isNotBlank(perObjSet.Global_Button_Style__c))
        settingsObj.buttonStyle = perObjSet.Global_Button_Style__c;
        if(String.isNotBlank(perObjSet.Table_Columns__c))
        settingsObj.tabelColumns = perObjSet.Table_Columns__c;
        if(String.isNotBlank(perObjSet.Field_Label_Map__c))
        settingsObj.fieldLabelMap = perObjSet.Field_Label_Map__c;
        if(String.isNotBlank(perObjSet.Create_Button_Label__c))
        settingsObj.newButtonLabel=perObjSet.Create_Button_Label__c;
        return settingsObj;
    }
    
    public class CA_BannerSettings{
        @AuraEnabled
        public string objLabel{get;set;}
        @AuraEnabled
        public string buttonStyle{get;set;}
        @AuraEnabled
        public String tabelColumns{get;set;}
        @AuraEnabled
        public String fieldLabelMap{get;set;}
        @AuraEnabled
        public String newButtonLabel{get;set;}
        
        public CA_BannerSettings(){
            this.objLabel='Congress';
            this.buttonStyle='background-color: rgb(75, 202, 129);border-color: rgb(75, 202, 129);';
            this.tabelColumns = 'Name,Cancellation_Date__c';
            this.newButtonLabel='New';
        }
        
    }
    
}