/*Class to provide utility or helper functions used for Lightning Component development*/
//Author: Karthik Nagaraj
public with sharing class LC_AppUtils {
    
    static public String validateId(String Idparam) {
        String id = String.escapeSingleQuotes(Idparam);
        if((id.length() == 15 || id.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', id)) {
            return id;
        }
        else 
            throw new AuraHandledException('Invalid Salesforce Id');
    }
    public static String getOrderIdForGOT(String taskId) {
        GC_GES_Order_Task__c[] orderTasks = [SELECT Id, Order__c FROM GC_GES_Order_Task__c WHERE Id =: taskId LIMIT 1];
        if(orderTasks.size() > 0)
            return String.valueOf(orderTasks[0].Order__c);
        else
            return '';
    }
    public static GC_Order__c getShowIdforOrder(String orderId){
        orderId = validateId(orderId);
        GC_Order__c[] orders = [SELECT Id, Completion_Date_Time__c, Delivery_Date_Time__c, Removal_Date_Time__c, Connect2_Show__c, Booth_Area_ID__c FROM GC_Order__c WHERE Id =: orderId LIMIT 1];
        if(orders[0] != NULL)
            return orders[0];
        else 
            return new GC_Order__c();
    }
    
    public static boolean isCommunity(){
        Id siteId = Site.getSiteId();
        if (siteId != null)
            return true;
        
        return false;
    }
    
    public static String getDefaultValue(Schema.DescribeFieldResult pickValues){
        List <Schema.PicklistEntry> bgPickVals = pickValues.getPicklistValues();
        string defaultPLValue = 'Shown';
        for (Schema.PicklistEntry av: bgPickVals) {
            if (av.isDefaultValue())
                defaultPLValue =  av.getValue();
        }
        return defaultPLValue;
    }
    
    public static GC_Task_Field_Manager__c getDefaultTaskFields(){
        
        GC_Task_Field_Manager__c defaultTFM = new GC_Task_Field_Manager__c();
        defaultTFM.Hide_Order_Level_File_Upload__c = true;        
        defaultTFM.Background__c = getDefaultValue(GC_Task_Field_Manager__c.Background__c.getDescribe());
        defaultTFM.Booth_Area_Discount__c = getDefaultValue(GC_Task_Field_Manager__c.Booth_Area_Discount__c.getDescribe());
        defaultTFM.Budget_Code__c = getDefaultValue(GC_Task_Field_Manager__c.Budget_Code__c.getDescribe());
        defaultTFM.Client_Layout_Notes__c = getDefaultValue(GC_Task_Field_Manager__c.Client_Layout_Notes__c.getDescribe());
        defaultTFM.Completion_Date_Time__c = getDefaultValue(GC_Task_Field_Manager__c.Completion_Date_Time__c.getDescribe());
        defaultTFM.Copy_Placement__c = getDefaultValue(GC_Task_Field_Manager__c.Copy_Placement__c.getDescribe());
        defaultTFM.Default_Completion_Date_Time__c = getDefaultValue(GC_Task_Field_Manager__c.Default_Completion_Date_Time__c.getDescribe());
        defaultTFM.Default_Installation_Delivery_Date_Time__c = getDefaultValue(GC_Task_Field_Manager__c.Default_Installation_Delivery_Date_Time__c.getDescribe());
        defaultTFM.Default_Removal_Date_Time__c = getDefaultValue(GC_Task_Field_Manager__c.Default_Removal_Date_Time__c.getDescribe());
        defaultTFM.Delivery_Area__c = getDefaultValue(GC_Task_Field_Manager__c.Delivery_Area__c.getDescribe());
        defaultTFM.File_Reference_Link_Folder__c = getDefaultValue(GC_Task_Field_Manager__c.File_Reference_Link_Folder__c.getDescribe());
        defaultTFM.Installation_Delivery_Date_Time__c = getDefaultValue(GC_Task_Field_Manager__c.Installation_Delivery_Date_Time__c.getDescribe());
        defaultTFM.Installation_Method__c = getDefaultValue(GC_Task_Field_Manager__c.Installation_Method__c.getDescribe());
        defaultTFM.Onsite_Contact_Person__c = getDefaultValue(GC_Task_Field_Manager__c.Onsite_Contact_Person__c.getDescribe());
        defaultTFM.Onsite_Contact_Person_Number__c = getDefaultValue(GC_Task_Field_Manager__c.Onsite_Contact_Person_Number__c.getDescribe());
        defaultTFM.Outdoors__c = getDefaultValue(GC_Task_Field_Manager__c.Outdoors__c.getDescribe());
        defaultTFM.Price__c = getDefaultValue(GC_Task_Field_Manager__c.Price__c.getDescribe());
        defaultTFM.Removal_Date_Time__c = getDefaultValue(GC_Task_Field_Manager__c.Removal_Date_Time__c.getDescribe());
        defaultTFM.Save_Signs__c = getDefaultValue(GC_Task_Field_Manager__c.Save_Signs__c.getDescribe());
        defaultTFM.Sign_Copy__c = getDefaultValue(GC_Task_Field_Manager__c.Sign_Copy__c.getDescribe());
        defaultTFM.Sign_Title__c = getDefaultValue(GC_Task_Field_Manager__c.Sign_Title__c.getDescribe());
        defaultTFM.Sign_Type__c = getDefaultValue(GC_Task_Field_Manager__c.Sign_Type__c.getDescribe());
        defaultTFM.Sign_Type_Other__c = getDefaultValue(GC_Task_Field_Manager__c.Sign_Type_Other__c.getDescribe());
        defaultTFM.Single_Double_Sided__c = getDefaultValue(GC_Task_Field_Manager__c.Single_Double_Sided__c.getDescribe());
        defaultTFM.Special_Instructions_Client_Remarks__c = getDefaultValue(GC_Task_Field_Manager__c.Special_Instructions_Client_Remarks__c.getDescribe());
        defaultTFM.User_Item_Description__c = getDefaultValue(GC_Task_Field_Manager__c.User_Item_Description__c.getDescribe());
        
        return defaultTFM;
    }
    
    public static GC_GES_Order_Task__c copyGOTFields(GC_GES_Order_Task__c got){
        if(got != null){
            if(String.isBlank(got.Client_Layout_Notes__c) && !String.isBlank(got.Layout__c)){
                got.Client_Layout_Notes__c = copyRichTextToLong(got.Layout__c);
            }
            if(String.isBlank(got.Sign_Copy_Plain__c) && !String.isBlank(got.Sign_Copy__c)){
                got.Sign_Copy_Plain__c = copyRichTextToLong(got.Sign_Copy__c);
            }
            if(String.isBlank(got.Special_Instructions_Client_Remarks__c) && !String.isBlank(got.Show_Management_Field__c)){
                got.Special_Instructions_Client_Remarks__c = copyRichTextToLong(got.Show_Management_Field__c);
            }
           return got;
        }
        else 
            return new GC_GES_Order_Task__c();
    }
    
    public static String copyRichTextToLong(string rTF){
        string lTF = '';
        lTF = rTF;
        lTF = lTF.replaceAll('<br[^>]+>', '\n');
        lTF = lTF.replaceAll('<[^>]+>',' ');
        lTF = lTF.replaceAll('&#39;', '\'');
        lTF = lTF.replaceAll('&quot;', '"');
        lTF = lTF.replaceAll('&amp;', '&');
        return lTF;
    }
}