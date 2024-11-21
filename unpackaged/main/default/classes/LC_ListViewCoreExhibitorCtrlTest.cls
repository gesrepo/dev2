@isTest
public class LC_ListViewCoreExhibitorCtrlTest {
    
    static  testMethod void controllertest1() 
    {
    
        MelissaSetting__c setting = new MelissaSetting__c();
        setting.Name = 'Melissa Manual Intervention';
        setting.Value__c = 'AE01';
        insert setting;                
        
        List<CORE_EXHIBITOR__c> coreexh= new List<CORE_EXHIBITOR__c>();
        CORE_EXHIBITOR__c core = new CORE_EXHIBITOR__c();
        core.Oracle_Key_Index__c='12345';
        core.Oracle_Interface_Status__c='N';
        core.Data_Com_Integration_Status__c='Success';
        core.Country__c='US';
        core.Melissa_Results__c='AE01';
        core.IsManualIntervention__c=false;
        core.Melissa_Integration_Status__c='Success';
        core.Occurrence_Id__c='341894';
        core.Counter__c=4;
        core.Integration_Status__c = 'Failed';
        coreexh.add(core);
        insert coreexh;
        
        LC_ListViewCoreExhibitorCtrl.getShowOccurences();
        LC_ListViewCoreExhibitorCtrl.getExhibitorCountry('341894');
        LC_ListViewCoreExhibitorCtrl.getCoreExhibitor('341894','','');
        
    }

}