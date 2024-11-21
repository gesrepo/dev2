@isTest
Public Class MeetingRoomBrandDetailTest{
Public Static Testmethod void MeetingRoomBrandDetail()
{          
   Brand__c b =new Brand__c();
    b.Sponsorship_Costs_Estimated__c=325;
    b.Funding_Owner__c='Test';
    b.Brand_Category__c='Tests';
    b.Brand_Name__c='Test';
    b.Business_Unit__c='EM';
    insert b;
    Test.setCurrentPageReference(new PageReference('Page.MeetingRoomBrandDetail'));
    System.currentPageReference().getParameters().put('mrnbrandid',b.id);
    ApexPages.StandardController sc = new ApexPages.standardController(b);
    MeetingRoomBrandDetail mrbd = new MeetingRoomBrandDetail();    
    mrbd.BrandSave();
    mrbd.BrandCancel();
    mrbd.getbr();   
   
}
}