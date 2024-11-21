@isTest
public with sharing class CA_TestDataFactory{

    public static CA_Main_Event__c getMainEvent(String recTypeName){
        if(string.isBlank(recTypeName)){
            recTypeName='BMS Main Event';
        }
        RecordType mainEventRT = [Select Id, SobjectType, Name From RecordType WHERE Name =:recTypeName  and SobjectType = 'CA_Main_Event__c' limit 1];
        CA_Main_Event__c mainEventObj = new CA_Main_Event__c();
        mainEventObj.Name_of_Event__c = 'TestMainEvent';
        mainEventObj.Event_Acronym__c = 'TE';
        mainEventObj.Event_Cancelled__c=False;
        mainEventObj.RecordTypeId = mainEventRT.Id;
        insert mainEventObj;
        return mainEventObj;
        
    }
    
    public static CA_Personalized_Object_Setting__c getPersonSetObj(string recTypeName, string objName, string profile){
        if(string.isBlank(recTypeName)){
            recTypeName='BMS Main Event';
        }
        if(string.isBlank(objName)){
            objName='CA_Main_Event__c';
        }
        if(string.isBlank(profile)){
            profile='GC BMS Profile';
        }
        RecordType mainEventRT = [Select Id, SobjectType, Name From RecordType WHERE Name =:recTypeName and SobjectType =:objName limit 1];
        CA_Personalized_Object_Setting__c perSetObj = new CA_Personalized_Object_Setting__c();
        perSetObj.Available_Tiles__c = 'Analytics;Congresses;Files';
        perSetObj.Object_Label__c = 'Congress';
        perSetObj.Object_Name__c = objName;
        perSetObj.Profile_Name__c = profile;
        perSetObj.Field_Label_Map__c = '{"apiToFieldSettings":{"Connect2_Show_Lookup__c":{"isRequired":false,"isReadOnly":false,"displayLabel":"Connect2 Show","dataType":"REFERENCE"},"Hotel_4_Country__c":{"isRequired":false,"isReadOnly":false,"displayLabel":"Country","dataType":"STRING"},"Hotel_3_Country__c":{"isRequired":false,"isReadOnly":false,"displayLabel":"Country","dataType":"STRING"},"Hotel_2_Country__c":{"isRequired":false,"isReadOnly":false,"displayLabel":"Country","dataType":"STRING","Name_of_Event__c":{"isRequired":true,"isReadOnly":false,"displayLabel":"Name of Congress","dataType":"STRING"}}}}';
        perSetObj.Number_Of_Sections__c = 5; 
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
        perSetObj.ExSchRep_Column_Map__c ='{"colMap":{"usEx":"usEx","id":"id","tpArea":"Theraputic Area","state":"state","projNum":"GES Project Num","projMgr":"projMgr","products":"Brands","onSiStaff":"onSiStaff","numOfHcp":"numOfHcp","mPlanner":"mPlanner","loc":"Location","idSuper":"idSuper","hlVendor":"hlVendor","gesSupportString":"gesSupportString","facility":"facility","exHrs":"exHrs","eventWeb":"eventWeb","eventType":"Congress Type","eventStDate":"Exhibit Open Date","eventStatus":"eventStatus","eventNotes":"eventNotes","eventName":"Congress Name","eventMgr":"GES Congress Manager","eventLevel":"Level","eventLead":"GES Congress Lead","eventEndDate":"Exhibit Close Date","eventAcronym":"Acronym","country":"country","city":"city","buCat":"buCat","btWid":"Booth Width","btNum":"Booth No.","btLen":"Booth Length","bTeamCon":"bTeamCon","bsUnit":"Business Unit","actType":"Activity Type","actLevel":"actLevel","accMgr":"GES Account Manager","accExec":"GES Account Executive","gesSupport":"gesSupport"}}';
        perSetObj.ExSchReport_CSV_Cols__c= 'projNum,eventName,eventAcronym,eventStDate,eventEndDate,loc,eventType,eventLevel,actType,products,btLen,btWid,btNum,eventMgr,accMgr,accExec,eventLead';
        perSetObj.ExSchRep_All_Columns__c='projNum,eventName,eventAcronym,eventStDate,eventEndDate,loc,eventType,eventLevel,actType,products';
        insert perSetObj;
        return perSetObj;
    }
    
    public static List<CA_Manager__c> getContacts(){
        List<CA_Manager__c> corpAccMgr= new List<CA_Manager__c>();
        corpAccMgr.add(new CA_Manager__c(Email__c='ilenia.casarotto@bms.com',First_Name__c='Ilenia',Last_Name__c='Casarotto',Phone__c='+44(0)1895 523688'));
        corpAccMgr.add(new CA_Manager__c(Email__c='dbullock@ges.com',First_Name__c='Deana',Last_Name__c='Bullock',Phone__c='(781) 844-9131'));
        corpAccMgr.add(new CA_Manager__c(Email__c='mmulvey@ges.com',First_Name__c='Mike',Last_Name__c='Mulvey',Phone__c='(617) 852-3593'));
        corpAccMgr.add(new CA_Manager__c(Email__c='rmarsh@ges.com',First_Name__c='Reta',Last_Name__c='Marsh',Phone__c='(859) 283-8727'));
        corpAccMgr.add(new CA_Manager__c(Email__c='bradfinstrom@gmail.com',First_Name__c='Brad',Last_Name__c='Finstrom',Phone__c='(815) 687-4234'));
        
        insert corpAccMgr;
        return corpAccMgr;
    }
    
    public static CA_Event__c getEventWithProduct(string recTypeName,string mainEventId){
        RecordType recType = [Select Id, SobjectType, Name From RecordType WHERE Name =:recTypeName  and SobjectType = 'CA_Event__c' limit 1];
        CA_Event__c parentEvent  = new CA_Event__c();
        parentEvent.Event__c= mainEventId;
        parentEvent.Event_Name__c='Event From Data Factory';
        parentEvent.GES_Account_Executive__c='Bullock, Deana';
        parentEvent.GES_Account_Manager__c='Marsh, Reta';
        parentEvent.GES_Project_Manager__c='Mulvey, Mike';
        parentEvent.I_D_Supervisor__c='Finstrom, Brad';
        parentEvent.recordTypeId=recType.id;
        insert parentEvent;
        CA_Product__c tempProd= new CA_Product__c();
        tempProd.CA_Event__c=parentEvent.Id;
        tempProd.Event__c=mainEventId;
        insert tempProd;
        return parentEvent;
    }
    
    public static CA_Exhibit__c  getExhibit(string recTypeName,string mainEventId){
        RecordType recType = [Select Id, SobjectType, Name From RecordType WHERE Name =:recTypeName  and SobjectType = 'CA_Exhibit__c' limit 1];
        CA_Exhibit__c  parentEvent  = new CA_Exhibit__c ();
        parentEvent.Event__c= mainEventId;
        parentEvent.Exhibit_Name__c='Exhibit From Data Factory';
        parentEvent.GES_Account_Executive__c='Bullock, Deana';
        parentEvent.GES_Account_Manager__c='Marsh, Reta';
        parentEvent.GES_Project_Manager__c='Mulvey, Mike';
        parentEvent.I_D_Supervisor__c='Finstrom, Brad';
        parentEvent.recordTypeId=recType.id;
        insert parentEvent;
        CA_Product__c tempProd= new CA_Product__c();
        tempProd.Exhibit__c=parentEvent.Id;
        tempProd.Event__c=mainEventId;
        insert tempProd;
        return parentEvent;
    }
    
    public static CA_Sponsorship__c  getSponsorship(string recTypeName,string mainEventId){
        RecordType recType = [Select Id, SobjectType, Name From RecordType WHERE Name =:recTypeName  and SobjectType = 'CA_Sponsorship__c' limit 1];
        CA_Sponsorship__c  parentEvent  = new CA_Sponsorship__c ();
        parentEvent.Event__c= mainEventId;
        parentEvent.Sponsorship_Name__c='SPON From Data Factory';
        parentEvent.GES_Account_Executive__c='Bullock, Deana';
        parentEvent.GES_Account_Manager__c='Marsh, Reta';
        parentEvent.GES_Project_Manager__c='Mulvey, Mike';
        parentEvent.I_D_Supervisor__c='Finstrom, Brad';
        parentEvent.recordTypeId=recType.ID;
        insert parentEvent;
        CA_Product__c tempProd= new CA_Product__c();
        tempProd.Sponsorship__c=parentEvent.Id;
        tempProd.Event__c=mainEventId;
        insert tempProd;
        return parentEvent;
    }
    
    public static CA_Meeting_Planning__c  getMeetingPlanning(string recTypeName,string mainEventId){
        RecordType recType = [Select Id, SobjectType, Name From RecordType WHERE Name =:recTypeName  and SobjectType = 'CA_Meeting_Planning__c' limit 1];
        CA_Meeting_Planning__c  parentEvent  = new CA_Meeting_Planning__c ();
        parentEvent.Event__c= mainEventId;
        parentEvent.Meeting_Planning_Name__c='MPL From Data Factory';
        parentEvent.GES_Account_Manager__c='Marsh, Reta';
        parentEvent.GES_Project_Manager__c='Kelly, Alexa';
        parentEvent.GES_Account_Executive__c='Bullock, Deana';
        parentEvent.I_D_Supervisor__c='Storm, Kari';
        parentEvent.Event_Manager__c='Curtin, Nadine';
        parentEvent.recordTypeId=recType.ID;
        insert parentEvent;
        CA_Product__c tempProd= new CA_Product__c();
        tempProd.Meeting_Planning__c=parentEvent.Id;
        tempProd.Event__c=mainEventId;
        insert tempProd;
        return parentEvent;
    }
    
    public static CA_Meeting_Room__c  getMeetingRoom(string recTypeName,string mainEventId){
        RecordType recType = [Select Id, SobjectType, Name From RecordType WHERE Name =:recTypeName  and SobjectType = 'CA_Meeting_Room__c' limit 1];
        CA_Meeting_Room__c  parentEvent  = new CA_Meeting_Room__c ();
        parentEvent.Event__c= mainEventId;
        parentEvent.Meeting_Room_Name__c='MPL From Data Factory';
        parentEvent.GES_Account_Manager__c='Marsh, Reta';
        parentEvent.GES_Account_Executive__c='Bullock, Deana';
        parentEvent.GES_Project_Manager__c='Mulvey, Mike';
        parentEvent.I_D_Supervisor__c='Finstrom, Brad';
        parentEvent.recordTypeId=recType.ID;
        insert parentEvent;
        CA_Product__c tempProd= new CA_Product__c();
        tempProd.Meeting_Room__c=parentEvent.Id;
        tempProd.Event__c=mainEventId;
        insert tempProd;
        return parentEvent;
    }
    
    public static CA_Membership__c  getMembershipRecord(string mainEventId){
        CA_Membership__c  parentEvent  = new CA_Membership__c ();
        parentEvent.Event__c= mainEventId;
        parentEvent.Membership_Name__c='MPL From Data Factory';
        parentEvent.GES_Account_Manager__c='Stephanie Specht';
        parentEvent.GES_Account_Executive__c='John Boy';
        parentEvent.CC_Project_Manager__c='Lisa Gebhart';
        insert parentEvent;
        CA_Product__c tempProd= new CA_Product__c();
        tempProd.Membership__c=parentEvent.Id;
        tempProd.Event__c=mainEventId;
        insert tempProd;
        return parentEvent;
    }
    
    public static CA_Speaking_Engagement__c  getSpeakingEngadgement(string recTypeName,string mainEventId){
        RecordType recType = [Select Id, SobjectType, Name From RecordType WHERE Name =:recTypeName  and SobjectType = 'CA_Speaking_Engagement__c' limit 1];
        CA_Speaking_Engagement__c  parentEvent  = new CA_Speaking_Engagement__c ();
        parentEvent.Event__c= mainEventId;
        parentEvent.Speaking_Engagement_Type__c='Keynote speaker';
        parentEvent.GES_Account_Executive__c='Debbie Boncek';
        parentEvent.GES_Account_Manager__c='Alita Mathews';
        //parentEvent.GES_Project_Manager__c='Ferraro, Antonio';
        //Id recTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CA Speaking Engagement BMS').getRecordTypeId();
        parentEvent.recordTypeId=recType.ID;
        insert parentEvent;
        CA_Product__c tempProd= new CA_Product__c();
        tempProd.Speaking_Engagement__c=parentEvent.Id;
        tempProd.Event__c=mainEventId;
        insert tempProd;
        return parentEvent;
    }
    
    public static CA_Sporting_Event__c  getSportingEvent(string mainEventId){
        CA_Sporting_Event__c  parentEvent  = new CA_Sporting_Event__c ();
        parentEvent.Event__c= mainEventId;
        parentEvent.Sporting_event_Name__c='SPON From Data Factory';
        //parentEvent.GES_Account_Executive__c='Bullock, Deana';
        parentEvent.GES_Account_Manager__c='Stephanie Specht';
        //parentEvent.GES_Project_Manager__c='Mulvey, Mike';
        insert parentEvent;
        CA_Product__c tempProd= new CA_Product__c();
        tempProd.Sporting_Event__c=parentEvent.Id;
        tempProd.Event__c=mainEventId;
        insert tempProd;
        return parentEvent;
    }
    
    public static CA_Manager__c getManager(String FirstName, String LastName){
        CA_Manager__c manager = new CA_Manager__c();
        manager.Email__c = 'test@test.com';
        manager.First_Name__c = FirstName;
        manager.Last_Name__c = LastName;
        insert manager;
        return manager;
    }
}