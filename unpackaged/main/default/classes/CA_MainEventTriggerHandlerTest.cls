@isTest
public class CA_MainEventTriggerHandlerTest {
   
    @isTest
    public static void CA_MainEventTriggerHandlerTest() {
       
    }
    
    @isTest
    public static void sectionSettingsTriggerTest() {
        CA_Personalized_Object_Setting__c parentObj = LC_TestUtils.insertMainEventPersonSetObj();
        CA_Section_Setting__c secSetting = new CA_Section_Setting__c();
        secSetting.Parent_Object_Setting__c= parentObj.Id;
        secSetting.Section_Label__c= 'Congress Details';
        secSetting.Object_Name__c = 'CA_Main_Event__c';
        secSetting.Profile_Name__c = 'GC BMS Profile' ;
        secSetting.Precedence__c = 1 ;
        secSetting.Fields_On_Detail_Page__c = 'Name_of_Event__c,Connect2_Show_Lookup__c,Event_Acronym__c,Event_Website__c,Event_Level__c,Event_Occurrence__c,Exhibit_Open_Date__c,Event_Start_Date__c,Exhibit_Close_Date__c, Event_End_Date__c';
        secSetting.Fields_On_Edit_Page__c =  'Name_of_Event__c,Connect2_Show_Lookup__c,Event_Acronym__c,Event_Website__c,Event_Level__c,Event_Occurrence__c,Exhibit_Open_Date__c,Event_Start_Date__c,Exhibit_Close_Date__c, Event_End_Date__c';
        insert secSetting;
        
        
    }
    @isTest
    public static void testCancel(){
        CA_Main_Event__c mainEve=CA_TestDataFactory.getMainEvent('BMS Main Event');
        
        List<CA_Product__c> products =new List<CA_Product__c>();
       
       
        CA_Event__c parentEvent  = new CA_Event__c();
        parentEvent.Event__c= mainEve.Id;
        parentEvent.Event_Name__c='test event';
        insert parentEvent;
        
        CA_Product__c tempProd= new CA_Product__c();
        tempProd.CA_Event__c=parentEvent.Id;
        tempProd.Event__c=mainEve.Id;
        products.add(tempProd);
        
        CA_Exhibit__c parentEx  = new CA_Exhibit__c();
        parentEx.Event__c= mainEve.Id;
        parentEx.Exhibit_Name__c='test exhibit';
        insert parentEx;
        
        CA_Product__c tempProd2= new CA_Product__c();
        tempProd2.Exhibit__c=parentEx.Id;
        tempProd2.Event__c=mainEve.Id;
        products.add(tempProd2);
        
        CA_Meeting_Planning__c parentMP  = new CA_Meeting_Planning__c();
        parentMP.Event__c= mainEve.Id;
        parentMP.Meeting_Planning_Name__c='test exhibit';
        insert parentMP;
        
        CA_Product__c tempProd3= new CA_Product__c();
        tempProd3.Meeting_Planning__c=parentMP.Id;
        tempProd3.Event__c=mainEve.Id;
        products.add(tempProd3);


        CA_Meeting_Room__c parentMR  = new CA_Meeting_Room__c();
        parentMR.Event__c= mainEve.Id;
        parentMR.Meeting_Room_Name__c='test exhibit';
        insert parentMR;
        
        CA_Product__c tempProd4= new CA_Product__c();
        tempProd4.Meeting_Room__c=parentMR.Id;
        tempProd4.Event__c=mainEve.Id;
        products.add(tempProd4);

        CA_Speaking_Engagement__c parentSE  = new CA_Speaking_Engagement__c();
        parentSE.Event__c= mainEve.Id;
        parentSE.Speaking_Engagement_Name__c='test exhibit';
        insert parentSE;
        
        CA_Product__c tempProd5= new CA_Product__c();
        tempProd5.Speaking_Engagement__c=parentSE.Id;
        tempProd5.Event__c=mainEve.Id;
        products.add(tempProd5);
        
        CA_Sponsorship__c parentSP  = new CA_Sponsorship__c();
        parentSP.Event__c= mainEve.Id;
        parentSP.Sponsorship_Name__c='test exhibit';
        insert parentSP;
        
        CA_Product__c tempProd6= new CA_Product__c();
        tempProd6.Sponsorship__c=parentSP.Id;
        tempProd6.Event__c=mainEve.Id;
        products.add(tempProd6);
        insert products;
        
        CA_Sporting_Event__c  spe  = new CA_Sporting_Event__c ();
        spe.Event__c= mainEve.Id;
        spe.Sporting_event_Name__c='SPON From Data Factory';
        spe.GES_Account_Manager__c='Stephanie Specht';
        insert spe;
        
        CA_Membership__c ms=new CA_Membership__c();
        ms.Event__c= mainEve.Id;
        ms.Membership_Name__c='MPL From Data Factory';
        ms.GES_Account_Manager__c='Stephanie Specht';
        ms.GES_Account_Executive__c='John Boy';
        ms.CC_Project_Manager__c='Lisa Gebhart';
        insert ms;
        
        mainEve.Event_Cancelled__c =true;
        mainEve.Event_Cancellation_Date__c=datetime.Now();
        mainEve.Reason_for_Cancellation__c='Product Owner Decision';
        update mainEve;
        
        mainEve.Event_Cancelled__c =false;
        update  mainEve;
        
        List<CA_Main_Event__c> mainEventId = [SELECT Id, Name,Event_Cancelled__c,Event_Cancellation_Date__c,Reason_for_Cancellation__c FROM CA_Main_Event__c WHERE Name_of_Event__c = 'TestMainEvent'];	
        CA_MainEventTriggerHandler.cancelActivities(mainEventId);
        
    }
  
}