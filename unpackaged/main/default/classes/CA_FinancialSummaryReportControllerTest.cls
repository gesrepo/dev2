@isTest
public class CA_FinancialSummaryReportControllerTest{ 

 @testSetup
    public static void testsetupMethod(){
        CA_Personalized_Object_Setting__c perSetObj01 = LC_TestUtils.insertMainEventPersonSetObj();
        CA_Main_Event__c mainEvent = LC_TestUtils.insertMainEvent();
          RecordType mainEventRT = [Select Id, SobjectType, Name From RecordType WHERE Name = 'CA Connect Event Merck' and SobjectType = 'CA_Main_Event__c' limit 1];
        CA_Personalized_Object_Setting__c perSetObj = new CA_Personalized_Object_Setting__c();
        perSetObj.Available_Tiles__c = 'Analytics;Congresses;Files';
        perSetObj.Object_Label__c = 'Congress';
        perSetObj.Object_Name__c = 'CA_Main_Event__c';
        perSetObj.Profile_Name__c = 'GC Merck';
        perSetObj.Field_Label_Map__c = '{"apiToFieldSettings":{"Connect2_Show_Lookup__c":{"isRequired":false,"isReadOnly":false,"displayLabel":"Connect2 Show","dataType":"REFERENCE"},"Hotel_4_Country__c":{"isRequired":false,"isReadOnly":false,"displayLabel":"Country","dataType":"STRING"},"Hotel_3_Country__c":{"isRequired":false,"isReadOnly":false,"displayLabel":"Country","dataType":"STRING"},"Hotel_2_Country__c":{"isRequired":false,"isReadOnly":false,"displayLabel":"Country","dataType":"STRING","Name_of_Event__c":{"isRequired":true,"isReadOnly":false,"displayLabel":"Name of Congress","dataType":"STRING"}}}}';
        perSetObj.Number_Of_Sections__c = 2; 
        perSetObj.Record_Type_ID__c = mainEventRT.Id;
        perSetObj.Save_Button_Label__c = 'Save Congress';
        perSetObj.Table_Columns__c = 'Name_of_Event__c,Event_Acronym__c,Event_Start_Date__c,Event_End_Date__c,Event_Cancelled__c';
        perSetObj.Delete_Children__c = false;
        perSetObj.Object_Color__c = '#903e3e00';
        perSetObj.Run_Trigger__c = false;
        perSetObj.Create_Button_Label__c = 'Create';
        perSetObj.Error_Message__c = 'Error Message';
        perSetObj.Global_Button_Style__c = 'Color : white;';
        perSetObj.Save_Button_Label__c = 'Save';
        perSetObj.Success_Message__c = 'Record was Saved';
        perSetObj.Search_Filters__c = 'Name';
        perSetObj.Customer_Logo__c = '';
        insert perSetObj;
		
		
		 List<CA_Product__c> products =new List<CA_Product__c>();
        
        CA_Event__c parentEvent  = new CA_Event__c();
        parentEvent.Event__c= mainEvent.Id;
        parentEvent.Event_Name__c='test event';
        insert parentEvent;
        CA_Product__c tempProd= new CA_Product__c();
        tempProd.CA_Event__c=parentEvent.Id;
        tempProd.Event__c=mainEvent.Id;
        products.add(tempProd);
        
        CA_Exhibit__c parentEx  = new CA_Exhibit__c();
        parentEx.Event__c= mainEvent.Id;
        parentEx.Exhibit_Name__c='test exhibit';
        insert parentEx;
        CA_Product__c tempProd2= new CA_Product__c();
        tempProd2.Exhibit__c=parentEx.Id;
        tempProd2.Event__c=mainEvent.Id;
        products.add(tempProd2);
        
        CA_Meeting_Planning__c parentMP  = new CA_Meeting_Planning__c();
        parentMP.Event__c= mainEvent.Id;
        parentMP.Meeting_Planning_Name__c='test exhibit';
        insert parentMP;
        CA_Product__c tempProd3= new CA_Product__c();
        tempProd3.Meeting_Planning__c=parentMP.Id;
        tempProd3.Event__c=mainEvent.Id;
        products.add(tempProd3);


        CA_Meeting_Room__c parentMR  = new CA_Meeting_Room__c();
        parentMR.Event__c= mainEvent.Id;
        parentMR.Meeting_Room_Name__c='test exhibit';
        insert parentMR;
        CA_Product__c tempProd4= new CA_Product__c();
        tempProd4.Meeting_Room__c=parentMR.Id;
        tempProd4.Event__c=mainEvent.Id;
        products.add(tempProd4);

        CA_Speaking_Engagement__c parentSE  = new CA_Speaking_Engagement__c();
        parentSE.Event__c= mainEvent.Id;
        parentSE.Speaking_Engagement_Name__c='test exhibit';
        insert parentSE;
        CA_Product__c tempProd5= new CA_Product__c();
        tempProd5.Speaking_Engagement__c=parentSE.Id;
        tempProd5.Event__c=mainEvent.Id;
        products.add(tempProd5);
        
        CA_Sponsorship__c parentSP  = new CA_Sponsorship__c();
        parentSP.Event__c= mainEvent.Id;
        parentSP.Sponsorship_Name__c='test exhibit';
        insert parentSP;
        CA_Product__c tempProd6= new CA_Product__c();
        tempProd6.Sponsorship__c=parentSP.Id;
        tempProd6.Event__c=mainEvent.Id;
        products.add(tempProd6);
        
        insert products;
    }
   
    @isTest
    public static void testFromComponent(){
		CA_Main_Event__c mainEventId = [SELECT Id, Name FROM CA_Main_Event__c WHERE Name_of_Event__c = 'Test Event'];
		CA_FinancialSummaryReportController.getExhibitDetails(mainEventId.Id);
    }
        @isTest
    public static void testFromVFPDownload(){
		CA_Main_Event__c mainEventId = [SELECT Id, Name FROM CA_Main_Event__c WHERE Name_of_Event__c = 'Test Event'];
		CA_FinancialSummaryReportController.getExhibitDetails(mainEventId.Id);
		
		Test.setCurrentPageReference(new PageReference('Page.CA_FinancialSummaryExcelDownload'));
        System.currentPageReference().getParameters().put('recordId', mainEventId.id);
        ApexPages.StandardController sc=new ApexPages.StandardController(mainEventId);
        CA_FinancialSummaryReportController gtFscr=new CA_FinancialSummaryReportController(sc); 
    }
}