@isTest
Public Class MeetingRoomBrandEditTest{
    
    Public Static Testmethod void BrandEdit() {
        GES_Connect_Corporate_Accounts__c parentCongress = GC_TestUtils.getTestCongress();
        Meeting_Room__c  MeetingRoom= GC_TestUtils.getTestMeetingRoom();
        Brand__c brand= GC_TestUtils.getTestBrand();
        brand.Funding_Owner__c='Test';
        brand.Meeting_Room__c =MeetingRoom.id;
        upsert brand;       
        Test.setCurrentPageReference(new PageReference('Page.MeetingRoomBrandEdit'));
        System.currentPageReference().getParameters().put('congid',MeetingRoom.Congress__c);    
        System.currentPageReference().getParameters().put('mrid',MeetingRoom.id);
        System.currentPageReference().getParameters().put('brandid',brand.Id);    
        System.currentPageReference().getParameters().put('mrName',MeetingRoom.Name);
        MeetingRoomBrandEdit eBrandCTRL= new MeetingRoomBrandEdit();
        eBrandCTRL.MeetingRoomBrandSave();
        eBrandCTRL.BrandCancel();
        eBrandCTRL.cancelOperation();
        eBrandCTRL.getbr();
        eBrandCTRL.changeBrandCatandBusUnit();
    }
}