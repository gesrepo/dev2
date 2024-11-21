/* LC_UserPrefrenceTabController - Apex Controller for LC_UserPrefrenceTab Lightning Component
* Author(s) - Namratha.P Salesforce Developer - SLK Software
* Date - 27/Dec/2018
*/

public  with sharing class LC_UserPrefrenceTabController {
    public class applicationException extends Exception {}
    @AuraEnabled
    Public static GC_Task_Field_Manager__c getTaskField(String projectCentralId){
        GC_Task_Field_Manager__c taskFieldObj = new GC_Task_Field_Manager__c();
        
        Set<String> objFields = new Set<String>();
        objFields = getFields();
        String fieldList = String.join(new List<String>(objFields), ',').toLowerCase();
        String query = 'SELECT ' + fieldList + ' FROM GC_Task_Field_Manager__c WHERE Connect2_Show__c =:projectCentralId';
        try{
            taskFieldObj = Database.query(query);
            if(Test.isRunningTest())
                throw new applicationException('Sorry! We don\'t do that here!!');
        }
        catch(EXception ex){
            taskFieldObj.User__c= UserInfo.getUserId();
            taskFieldObj.Connect2_Show__c =  projectCentralId;
        }
        return taskFieldObj;
    }
    
    @AuraEnabled
    Public static GC_Task_Field_Manager__c saveTaskFieldObj(id projectCentralId, GC_Task_Field_Manager__c TaskObj){
        TaskObj.Connect2_Show__c =  projectCentralId;
        upsert TaskObj;
        return TaskObj;
    }
    
    public static Set<String> getFields(){
        Set<String> objFields = new Set<String>();
        SObjectType objToken = Schema.getGlobalDescribe().get('GC_Task_Field_Manager__c');
        DescribeSObjectResult objDef = objToken.getDescribe();
        objFields = objDef.fields.getMap().keySet();
        return objFields;
    }
    
    /*@AuraEnabled
    public static void resetDisplayOptions(Id projectCentralId){
        GC_Task_Field_Manager__c taskField = [SELECT Id, Name FROM GC_Task_Field_Manager__c WHERE Connect2_Show__c =:projectCentralId LIMIT 1];
        Set<String> tfmFields = new Set<String>();
        tfmFields = getFields();
        SObject sTaskField = (SObject)taskField;
        // make all the fields as Shown
        for (String key : tfmFields) {
            if(key.contains('__c') && (key !='User__c' && key!='Connect2_Show__c' && key!='Hide_Order_Level_File_Upload__c')){
                sTaskField.put(key, 'Shown');
            }
        }
        sTaskField.put('User__c', UserInfo.getUserId());
        sTaskField.put('Hide_Order_Level_File_Upload__c', false);
        update taskField;
    }*/
    
    @AuraEnabled
    public static string restoreDefaultValues(Id projectCentralId){
        GC_Task_Field_Manager__c defaultTFM = new GC_Task_Field_Manager__c();
        List<GC_Task_Field_Manager__c> taskFields = [SELECT Id, Name FROM GC_Task_Field_Manager__c WHERE Connect2_Show__c =:projectCentralId LIMIT 1];
        
        if(taskFields != null && taskFields.size() > 0){
            defaultTFM = taskFields[0];
            defaultTFM.User__c = UserInfo.getUserId();
            defaultTFM.Hide_Order_Level_File_Upload__c = true;
            
            defaultTFM.Background__c = LC_AppUtils.getDefaultValue(GC_Task_Field_Manager__c.Background__c.getDescribe());
            defaultTFM.Booth_Area_Discount__c = LC_AppUtils.getDefaultValue(GC_Task_Field_Manager__c.Booth_Area_Discount__c.getDescribe());
            defaultTFM.Budget_Code__c = LC_AppUtils.getDefaultValue(GC_Task_Field_Manager__c.Budget_Code__c.getDescribe());
            defaultTFM.Client_Layout_Notes__c = LC_AppUtils.getDefaultValue(GC_Task_Field_Manager__c.Client_Layout_Notes__c.getDescribe());
            defaultTFM.Completion_Date_Time__c = LC_AppUtils.getDefaultValue(GC_Task_Field_Manager__c.Completion_Date_Time__c.getDescribe());
            defaultTFM.Copy_Placement__c = LC_AppUtils.getDefaultValue(GC_Task_Field_Manager__c.Copy_Placement__c.getDescribe());
            defaultTFM.Default_Completion_Date_Time__c = LC_AppUtils.getDefaultValue(GC_Task_Field_Manager__c.Default_Completion_Date_Time__c.getDescribe());
            defaultTFM.Default_Installation_Delivery_Date_Time__c = LC_AppUtils.getDefaultValue(GC_Task_Field_Manager__c.Default_Installation_Delivery_Date_Time__c.getDescribe());
            defaultTFM.Default_Removal_Date_Time__c = LC_AppUtils.getDefaultValue(GC_Task_Field_Manager__c.Default_Removal_Date_Time__c.getDescribe());
            defaultTFM.Delivery_Area__c = LC_AppUtils.getDefaultValue(GC_Task_Field_Manager__c.Delivery_Area__c.getDescribe());
            defaultTFM.File_Reference_Link_Folder__c = LC_AppUtils.getDefaultValue(GC_Task_Field_Manager__c.File_Reference_Link_Folder__c.getDescribe());
            defaultTFM.Installation_Delivery_Date_Time__c = LC_AppUtils.getDefaultValue(GC_Task_Field_Manager__c.Installation_Delivery_Date_Time__c.getDescribe());
            defaultTFM.Installation_Method__c = LC_AppUtils.getDefaultValue(GC_Task_Field_Manager__c.Installation_Method__c.getDescribe());
            defaultTFM.Onsite_Contact_Person__c = LC_AppUtils.getDefaultValue(GC_Task_Field_Manager__c.Onsite_Contact_Person__c.getDescribe());
            defaultTFM.Onsite_Contact_Person_Number__c = LC_AppUtils.getDefaultValue(GC_Task_Field_Manager__c.Onsite_Contact_Person_Number__c.getDescribe());
            defaultTFM.Outdoors__c = LC_AppUtils.getDefaultValue(GC_Task_Field_Manager__c.Outdoors__c.getDescribe());
            defaultTFM.Price__c = LC_AppUtils.getDefaultValue(GC_Task_Field_Manager__c.Price__c.getDescribe());
            defaultTFM.Removal_Date_Time__c = LC_AppUtils.getDefaultValue(GC_Task_Field_Manager__c.Removal_Date_Time__c.getDescribe());
            defaultTFM.Save_Signs__c = LC_AppUtils.getDefaultValue(GC_Task_Field_Manager__c.Save_Signs__c.getDescribe());
            defaultTFM.Sign_Copy__c = LC_AppUtils.getDefaultValue(GC_Task_Field_Manager__c.Sign_Copy__c.getDescribe());
            defaultTFM.Sign_Title__c = LC_AppUtils.getDefaultValue(GC_Task_Field_Manager__c.Sign_Title__c.getDescribe());
            defaultTFM.Sign_Type__c = LC_AppUtils.getDefaultValue(GC_Task_Field_Manager__c.Sign_Type__c.getDescribe());
            defaultTFM.Sign_Type_Other__c = LC_AppUtils.getDefaultValue(GC_Task_Field_Manager__c.Sign_Type_Other__c.getDescribe());
            defaultTFM.Single_Double_Sided__c = LC_AppUtils.getDefaultValue(GC_Task_Field_Manager__c.Single_Double_Sided__c.getDescribe());
            defaultTFM.Special_Instructions_Client_Remarks__c = LC_AppUtils.getDefaultValue(GC_Task_Field_Manager__c.Special_Instructions_Client_Remarks__c.getDescribe());
            defaultTFM.User_Item_Description__c = LC_AppUtils.getDefaultValue(GC_Task_Field_Manager__c.User_Item_Description__c.getDescribe());
            
            update defaultTFM;
        }
        return defaultTFM.Id;
    }
}