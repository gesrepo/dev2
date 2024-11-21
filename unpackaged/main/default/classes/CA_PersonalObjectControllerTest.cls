@isTest
public class CA_PersonalObjectControllerTest {
    
    @testSetup
    public static void testsetupMethod(){
        LC_TestUtils.insertMainEventPersonSetObj();
    }
    
    
    @isTest
    public static void testMethod1(){
        //User currentUser = [select id,Name,profile.name,IsPortalEnabled FROM User Where id =: userInfo.getUserId()];
        CA_PersonalObjectController.getFields('CA_Main_Event__c','GC BMS Profile');
        CA_PersonalObjectController.getFields('CA_Meeting_Room__c','GC BMS Profile');
        CA_PersonalObjectController.FieldWrapper fieldWrapper = new CA_PersonalObjectController.FieldWrapper('Connect2_Show_Lookup__c',false,false,'Connect2 Show', 'REFERENCE');
        CA_PersonalObjectController.FieldWrapper fieldWrapper2 = new CA_PersonalObjectController.FieldWrapper('Name_of_Event__c',false,false,'Name of Congress','STRING');
        CA_PersonalObjectController.FieldSettings fieldSettings = new CA_PersonalObjectController.FieldSettings(true,true,'Created By ID','REFERENCE');
        CA_PersonalObjectController.FieldSettingStorageObj fieldSettingStorageObj = new CA_PersonalObjectController.FieldSettingStorageObj();
        List<CA_PersonalObjectController.FieldWrapper>fws= new List<CA_PersonalObjectController.FieldWrapper>();
        fws.add(fieldWrapper);
        fws.add(fieldWrapper2);
        CA_Personalized_Object_Setting__c perSetObj = [SELECT Id,Name,Field_Label_Map__c,Files_Link__c,Graphic_Proofing_Link__c,Ordering_Link__c,Tasks_Link__c,Available_Reports__c,Analytics_Link__c,Delete_Children__c,Logo__c,Number_Of_Sections__c,Object_Color__c,Object_Label__c,Object_Name__c,Profile_Name__c,Home_Page_Style__c,Run_Trigger__c,Available_Tiles__c,Create_Button_Label__c,Error_Message__c,Global_Button_Style__c,Record_Type_ID__c,Save_Button_Label__c,Success_Message__c,Search_Filters__c,Table_Columns__c,Customer_Logo__c FROM CA_Personalized_Object_Setting__c WHERE Object_Name__c = 'CA_Main_Event__c' AND Profile_Name__c = 'GC BMS Profile'];
       // CA_PersonalObjectController.updateFields(fws,perSetObj,'Congresses');
       CA_PersonalObjectController.updateFields(fws,perSetObj,'Congresses','Exhibit Schedule Report');
        
    }
}