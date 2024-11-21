public class TaskFieldToGOTFieldMap{
    
    public static Map<String, String> mapTFMGOTAPINames; 
    
    public TaskFieldToGOTFieldMap(){}
    
    public static Map<String, String> loadMap(){
        mapTFMGOTAPINames = new Map<String, String>();
        
        mapTFMGOTAPINames.put('Budget_Code__c', 'Budget_Code__c');
        mapTFMGOTAPINames.put('Completion_Date_Time__c', 'Completion_Date_Time__c');
        mapTFMGOTAPINames.put('Delivery_Area__c', 'Delivery_Location__c');
        mapTFMGOTAPINames.put('File_Reference_Link_Folder__c', 'File_Reference_Link__c');
        mapTFMGOTAPINames.put('Onsite_Contact_Person__c', 'Onsite_Contact_Person_Other__c'); // mapped to new field on 24Apr19
        //mapTFMGOTAPINames.put('Onsite_Contact_Person__c', 'Onsite_Contact__c');
        mapTFMGOTAPINames.put('Removal_Date_Time__c', 'Removal_Date_Time__c');
        mapTFMGOTAPINames.put('Special_Instructions_Client_Remarks__c', 'Special_Instructions_Client_Remarks__c'); //Show_Management_Field__c
        mapTFMGOTAPINames.put('User_Item_Description__c', 'User_Item_Description__c');
        mapTFMGOTAPINames.put('Installation_Delivery_Date_Time__c', 'Delivery_Date_Time__c');
        
        
        //The below were commented originally
        mapTFMGOTAPINames.put('Onsite_Contact_Person_Number__c', 'Onsite_Contact_Person_Number_Other__c'); // mapped to new field on 24Apr19
        mapTFMGOTAPINames.put('Background__c', 'GOT_Background__c');
        mapTFMGOTAPINames.put('Copy_Placement__c', 'GOT_Copy_Placement__c');
        mapTFMGOTAPINames.put('Booth_Area_Discount__c', 'Booth_Area_Discount__c');
        mapTFMGOTAPINames.put('Installation_Method__c', 'Installation_Method__c');
        mapTFMGOTAPINames.put('Outdoors__c', 'Outdoors__c');
        mapTFMGOTAPINames.put('Price__c', 'Price__c');
        mapTFMGOTAPINames.put('Save_Signs__c', 'Save_Signs__c');
        mapTFMGOTAPINames.put('Sign_Copy__c', 'Sign_Copy_Plain__c');//Sign_Copy__c
        mapTFMGOTAPINames.put('Sign_Title__c', 'Sign_Title__c');
        mapTFMGOTAPINames.put('Sign_Type__c', 'GOT_Sign_Type__c');
        mapTFMGOTAPINames.put('Sign_Type_Other__c', 'GOT_Sign_Type_Other__c');
        mapTFMGOTAPINames.put('Single_Double_Sided__c', 'GOT_Single_Double_Sided__c');
        mapTFMGOTAPINames.put('User__c', 'User_Name__c');
        mapTFMGOTAPINames.put('Connect2_Show__c', 'Connect2_Show_Number__c');
        mapTFMGOTAPINames.put('Copy_Placement__c', 'GOT_Copy_Placement__c');
       // mapTFMGOTAPINames.put('Default_Completion_Date_Time__c', 'Formula_Completion_Date_Time__c');
      //  mapTFMGOTAPINames.put('Default_Installation_Delivery_Date_Time__c', 'Formula_Delivery_Date_Time__c');
      //  mapTFMGOTAPINames.put('Default_Removal_Date_Time__c', 'Formula_Removal_Date_Time__c');
        mapTFMGOTAPINames.put('Client_Layout_Notes__c', 'Client_Layout_Notes__c'); //Layout__c
        
        return mapTFMGOTAPINames;
    }
    
}