@isTest
Public Class CongressTest{
    Public Static Testmethod void CongressTest()
    {
        GC_Connect2_Show__c cgs=new GC_Connect2_Show__c();   
        cgs.Show_Start_Date__c=Date.parse('3/4/2015');
        cgs.Show_End_Date__c=Date.parse('3/4/2015');
        //cgs.Opportunity_Id__c='01234';
        insert cgs;
        GES_Connect_Corporate_Accounts__c  gca=new GES_Connect_Corporate_Accounts__c();  
        gca.Name_of_Congress__c='Test';
        gca.Shipping_Street_c__c='Bangalore';
        gca.Show_Name__c=cgs.id;
        gca.Secretariat_Same_as_Association__c =true;
        gca.Secretariat_Contact_Email__c = 'reachrksinha@gmail.com';
        gca.Secretariat_Contact_Name__c= 'aAssociation_Contact_Name__c';
        gca.Secretariat_Contact_Phone__c='9789944733';
        gca.Secretariat_Name__c='aAssociation_Name__c';
        gca.Association_Contact_Name__c='2.0 Health';
        gca.Association_Name__c='Test';
        gca.Housing_Logistics_Vendor__c = 'BCD Travel';
        gca.Number_of_rooms_to_Secure__c = 3;
        gca.Number_of_rooms_Secured__c = 3;
        gca.Housing_Required_PL__c = 'No';
        gca.Shipping_Country__c='Afghanistan';
        insert gca;    
        
        system.debug('Test Show Name'+gca.Show_Name__c);
        Test.setCurrentPageReference(new PageReference('Page.Congress'));
        Test.setCurrentPageReference(new PageReference('Page.GC_Community_ShowCongress'));
        System.currentPageReference().getParameters().put('congressid',gca.id);
        ApexPages.StandardController sc=new ApexPages.StandardController(gca);
        Congress cng=new Congress(sc);
        
        cng.congid=  gca.id; //'987654678';    
        GES_Connect_Corporate_Accounts__c gotA=cng.geta();
        
        cng.updateDate();
        cng.updateCancelledDate();
        
        Account testFacility = new Account ();
        //testFacility.RecordType.DeveloperName ='Facility';
        testFacility.name='testFacility';
        testFacility.type='Hotel';
        testFacility.LMS_Facility_ID__c='1111';
        //testFacility.CurrencyIsoCode='USD - U.S. Dollar';
        
        insert testFacility;
        
        gotA.Facility_Name_Account__c=testFacility.id;
        cng.Congressedit();        
        cng.cancelAction();
        cng.getSaveTitle();
        cng.getCancelTitle(); 
        cng.copyAssociationValues();
        cng.showHousingRequiredFields();
        
        gca.Secretariat_Same_as_Association__c =false;
        upsert gca;
        system.debug('Test Show Name'+gca.Show_Name__c);
        GC_Connect2_Show__c  gests=[SELECT Show_Name__c,Show_Start_Date__c,Show_End_Date__c,Exhibitor_Move_In_Date2__c,Opportunity_Id__c,Exhibitor_Move_Out_Date2__c FROM GC_Connect2_Show__c WHERE id= :gca.Show_Name__c];
        system.debug('Test show Name'+gests);
        
        
        
        
        Account ac=new Account();
        ac.Name='show';
        ac.BillingStreet='ster';
        ac.BillingCity='city';
        ac.BillingState='BillingState';
        ac.BillingCountry='BillingCountry';
        ac.BillingPostalCode='BillingPostalCode';
        insert ac;
        
        cng.copyAssociationValues();
        cng.onFacilitySelect();
        cng.showHousingLogisticVendorOtherField();
        
        Account ac1=new Account();
        ac1.Name='show';
        ac1.BillingStreet='ster';
        ac1.BillingCity='city';
        ac1.BillingState='BillingState';
        ac1.BillingCountry='BillingCountry';
        ac1.BillingPostalCode='BillingPostalCode';
        id ab = Schema.SObjectType.account.getRecordTypeInfosByName().get('Facility').getRecordTypeId();
        ac1.recordtypeid=ab;
        insert ac1;
        
        Show__c sh=new Show__c();
        sh.Name='shows';
        sh.Show_Type__c='Medical & Healthcare';
        sh.Job_Classification__c='Congress';
        sh.Account__c=ac.id;
        sh.Website__c='www.google.com';
        sh.Show_ID__c='AMAPMR';
        sh.CurrencyIsoCode='';
        //sh.Sales_Person__c='';
        insert sh;
        /*-----*/ 
        Opportunity conOpt=new Opportunity();
        conOpt.Show_Open_Date__c=Date.parse('3/4/2015');
        conOpt.Show_Close_Date__c=Date.parse('3/4/2015');
        conOpt.AccountId=ac.id;
        conOpt.StageName='CR';
        conOpt.CurrencyIsoCode='';
        conOpt.Prime_Contractor__c=ac.id;
        conOpt.CloseDate=Date.parse('3/4/2015');
        conOpt.Name='Test';    
        conOpt.Facility__c=ac1.id;
        // conOpt.SHOW_Servi_Centre__c=sh.Account__r.Name;
        //conOpt.Show_Name__c='';
        insert conOpt;
        cgs.Opportunity_Id__c=conOpt.id;
        update cgs;
        
        GC_Connect2_Show__c  connShow= [SELECT Name, Opportunity_Id__c FROM GC_Connect2_Show__c WHERE Id = : gca.Show_Name__c];
        //  Opportunity ExhbOpp = [SELECT id,Show_Name__r.Name, Show_Name__r.Show_ID__c, Facility__r.Name, Facility__r.BillingStreet, Facility__r.BillingCity, Facility__r.BillingState, Facility__r.BillingCountry, Facility__r.BillingPostalCode, Show_Open_Date__c, Show_Close_Date__c FROM Opportunity WHERE Id = : connShow.Opportunity_Id__c];
        //system.debug('Test opportunity Name'+ExhbOpp );
        cng.fetchConnect2ShowDetails();
    }
    
    public static testMethod void popupTest() {
        Account testFacility = new Account ();
        //testFacility.RecordType.DeveloperName ='Facility';
        testFacility.name='testFacility';
        testFacility.type='Hotel';
        testFacility.LMS_Facility_ID__c='1111';
        //testFacility.CurrencyIsoCode='USD - U.S. Dollar';
        
        insert testFacility;
        PageReference pageRef = Page.CongressFacilityPopup;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('facilityName', 'testFacility');
        Congress con = new Congress();
        con.runQuery();
    }
}