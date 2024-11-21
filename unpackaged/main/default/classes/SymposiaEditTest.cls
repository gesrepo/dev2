@isTest
Public Class SymposiaEditTest{

    Public Static Testmethod void SymposiaEdit()
    {   
        GES_Connect_Corporate_Accounts__c cong = new GES_Connect_Corporate_Accounts__c();       
        Symposia__c exbt= GC_TestUtils.getTestSymposia();
        ApexPages.StandardController sc=new ApexPages.StandardController(cong);   
        Test.setCurrentPageReference(new PageReference('Page.SymposiaEdit'));
        System.currentPageReference().getParameters().put('symid',exbt.id); 
        System.currentPageReference().getParameters().put('congid',exbt.Congress__c); 
        SymposiaEdit Tebt=new SymposiaEdit(sc);
        Tebt.SymposiaSave();
        Tebt.symposiaCancel();
        Tebt.cancelOperation();        
        Tebt.getsy(); 
    }
    
    
    Public Static Testmethod void SymposiaClone()
    {          
        GES_Connect_Corporate_Accounts__c cong = new GES_Connect_Corporate_Accounts__c();       
        Symposia__c exbt= GC_TestUtils.getTestSymposia();
        ApexPages.StandardController sc=new ApexPages.StandardController(cong);   
        Test.setCurrentPageReference(new PageReference('Page.SymposiaEdit'));
        System.currentPageReference().getParameters().put('symid',exbt.id); 
        System.currentPageReference().getParameters().put('congid',exbt.Congress__c); 
        System.currentPageReference().getParameters().put('toClone','true'); 
        SymposiaEdit Tebt=new SymposiaEdit(sc);
        Tebt.SymposiaSave(); 
    }
    


}