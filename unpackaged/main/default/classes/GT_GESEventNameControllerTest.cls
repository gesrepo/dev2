@isTest
public class GT_GESEventNameControllerTest {
    
    Public Static Testmethod void testEpa(){
        GT_Event__c evt=new   GT_Event__c(Name_of_Event__c='Test');
        insert evt;
        GT_Exhibit__c exbt=new GT_Exhibit__c(Exhibit_Name__c='Test');
        exbt.GES_Connect_Event__c = evt.Id;
        insert exbt;
        GT_GESEventNameController.getGESEventName(evt.Id);
        GT_GESEventNameController.getGESEventName(exbt.Id);
        GT_GESEventNameController.getProfileName();
    }
}