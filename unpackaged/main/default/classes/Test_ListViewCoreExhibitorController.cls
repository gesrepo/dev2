/* Class Name: ListViewCoreExhibitorController 

    Author: Nehal Jain
    Created Date: 5/11/2017*/

@isTest
Public class Test_ListViewCoreExhibitorController
{
    static  testMethod void controllertest1() 
    {
    
        MelissaSetting__c setting = new MelissaSetting__c();
        setting.Name = 'Melissa Manual Intervention';
        setting.Value__c = 'AE01';
        insert setting;                
        
        List<CORE_EXHIBITOR__c> coreexh= new List<CORE_EXHIBITOR__c>();
        CORE_EXHIBITOR__c core = new CORE_EXHIBITOR__c();
        core.Oracle_Key_Index__c='12345';
        core.Oracle_Interface_Status__c='P';
        core.Data_Com_Integration_Status__c='Success';
        core.Country__c='US';
        core.Melissa_Results__c='AE01';
        core.IsManualIntervention__c=false;
        core.Melissa_Integration_Status__c='Success';
        core.Occurrence_Id__c='341894';
        core.Counter__c=4;
        coreexh.add(core);
        insert coreexh;
        
        ListViewCoreExhibitorController.Exhibitorwrapper wrap = new ListViewCoreExhibitorController.Exhibitorwrapper();        
        ListViewCoreExhibitorController listview = new ListViewCoreExhibitorController(); 
        
        listview.cancel();
        listview.save();
        listview.getShowOccurences();
        listview.showOccurrence();
        listview.updateWrapperList();
        listview.createMainWrapper(coreexh);
        listview.getprev();
        listview.getnxt();
        listview.beginning();
        listview.previous();
        listview.next();
        //listview.end();    
    }
}