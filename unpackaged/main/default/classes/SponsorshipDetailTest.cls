@isTest
Public Class SponsorshipDetailTest{
Public Static Testmethod void SponsorshipDetail()
{          
    Sponsorship__c sp=new Sponsorship__c();            
    SponsorshipDetail spdt=new SponsorshipDetail();
    spdt.SponsorshipNewBrand();
    spdt.sponsorSave();
    spdt.sponsorcancel();     
    spdt.getsp();
   // spdt.newBrand(); 
    spdt.BrandList();
    spdt.SponsorData();
    spdt.CongressDetail();
}
}