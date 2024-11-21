@isTest
Public Class MeetingRoomEditTest{
    Public Static Testmethod void MeetingRoomEdit(){   
        
        GES_Connect_Corporate_Accounts__c cong = new GES_Connect_Corporate_Accounts__c();      
        Meeting_Room__c mr=GC_TestUtils.getTestMeetingRoom();
        
        ApexPages.StandardController sc=new ApexPages.StandardController(cong);    
        Test.setCurrentPageReference(new PageReference('Page.MeetingRoomEdit'));
        System.currentPageReference().getParameters().put('mrid',mr.id); 
        System.currentPageReference().getParameters().put('congid',mr.Congress__c); 
        
     
        
        mr=[select id,Name,Meeting_Room_Name__c,GES_Project_Number__c,Activity_Level__c from Meeting_Room__c where id=:mr.id];
        MeetingRoomEdit mred=new MeetingRoomEdit(sc);
        mred.MeetingRoomSave();
        mred.meetingCancel();
        mred.cancelOperation();
        mred.getmr();    
        mred.geta();
    }
    Public Static Testmethod void MeetingRoomClone()
    {   
        
        GES_Connect_Corporate_Accounts__c cong = new GES_Connect_Corporate_Accounts__c();      
        Meeting_Room__c mr=GC_TestUtils.getTestMeetingRoom();
        
        ApexPages.StandardController sc=new ApexPages.StandardController(cong);    
        Test.setCurrentPageReference(new PageReference('Page.MeetingRoomEdit'));
        System.currentPageReference().getParameters().put('mrid',mr.id); 
        System.currentPageReference().getParameters().put('congid',mr.Congress__c); 
        System.currentPageReference().getParameters().put('toClone','true'); 
     
        
        mr=[select id,Name,Meeting_Room_Name__c,GES_Project_Number__c,Activity_Level__c from Meeting_Room__c where id=:mr.id];
        MeetingRoomEdit mred=new MeetingRoomEdit(sc);
        mred.MeetingRoomSave();
    }
    
    Public Static Testmethod void MeetingRoomNew()
    {   
        GES_Connect_Corporate_Accounts__c cong = new GES_Connect_Corporate_Accounts__c();      
        Meeting_Room__c mr=GC_TestUtils.getTestMeetingRoom();
        
        ApexPages.StandardController sc=new ApexPages.StandardController(cong);    
        Test.setCurrentPageReference(new PageReference('Page.MeetingRoomEdit'));
     
        
        mr=[select id,Name,Meeting_Room_Name__c,GES_Project_Number__c,Activity_Level__c from Meeting_Room__c where id=:mr.id];
        MeetingRoomEdit mred=new MeetingRoomEdit(sc);
        mred.mr=mr;
        mred.MeetingRoomSave();
        mred.mr=mr;
        mred.mr.Canceled__c =true;
        mred.cancelOperation();
    }
}