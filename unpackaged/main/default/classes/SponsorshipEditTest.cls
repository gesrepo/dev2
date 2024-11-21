@isTest
Public Class SponsorshipEditTest{
    Public Static Testmethod void SponsorshipEdit(){    
        GES_Connect_Corporate_Accounts__c cong = new GES_Connect_Corporate_Accounts__c();
        Sponsorship__c spon= GC_TestUtils.getTestSponsorship();        
        
        ApexPages.StandardController sc=new ApexPages.StandardController(cong);   
        Test.setCurrentPageReference(new PageReference('Page.Sponsorshipedit'));
        System.currentPageReference().getParameters().put('sponid',spon.id); 
        System.currentPageReference().getParameters().put('congid',spon.Sponsorship__c  );      
        SponsorshipEdit sped=new SponsorshipEdit(sc);
        sped.SponsorshipSave();
        sped.sponsorshipCancel();
        sped.cancelOperation();
        sped.getsp();    
        sped.geta();
    }


    Public Static Testmethod void SponsorshipNew()
    {          
        GES_Connect_Corporate_Accounts__c parentCongress = GC_TestUtils.getTestCongress();
        Sponsorship__c sponsorship = new Sponsorship__c();
        sponsorship.Sponsorship_Name__c = 'Test Sponsonsorship for Devs';
        sponsorship.Activity_Level__c = '1';
        sponsorship.Sponsorship__c = parentCongress.Id;     
        sponsorship.CurrencyIsoCode = 'USD';       
        sponsorship.GES_Congress_Manager__c='n/a';
        sponsorship.Congress_Lead__c='n/a';
        sponsorship.GES_Account_Manager__c='n/a';
        ApexPages.StandardController sc=new ApexPages.StandardController(parentCongress);   
        Test.setCurrentPageReference(new PageReference('Page.Sponsorshipedit'));
        SponsorshipEdit sped=new SponsorshipEdit(sc);
        sped.sp= sponsorship;
        sped.SponsorshipSave();
        sped.sp.Canceled__c =true;
        sped.cancelOperation();
    }
    
    Public Static Testmethod void SponsorshipClone(){    
        GES_Connect_Corporate_Accounts__c cong = new GES_Connect_Corporate_Accounts__c();
        Sponsorship__c spon= GC_TestUtils.getTestSponsorship();        
        
        ApexPages.StandardController sc=new ApexPages.StandardController(cong);   
        Test.setCurrentPageReference(new PageReference('Page.Sponsorshipedit'));
        System.currentPageReference().getParameters().put('sponid',spon.id); 
        System.currentPageReference().getParameters().put('congid',spon.Sponsorship__c  );
        System.currentPageReference().getParameters().put('toClone','true');    
        SponsorshipEdit sped=new SponsorshipEdit(sc);
        sped.SponsorshipSave();
        
    }
}