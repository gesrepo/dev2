@istest
public class LC_DesignElementTaskTestClass {
    @testsetup
    public static void testSetup(){
        /*Opportunity opp=LC_TestUtils.insertOpportunity();
        GC_Connect2_Show__c show=LC_TestUtils.insertShow(opp.Id,opp.Name);
        show.Show_End_Date__c = system.today().addDays(-10);
        update show;
        GC_Show_Attribute__c serviceAttribute=LC_TestUtils.insertServiceAttributes(show.Id);
        GC_Show_Team_Member__c member=LC_TestUtils.insertShowTeamMember(serviceAttribute.Id,show.Id);
        GC_Design_Request_Form__c requestForm=LC_TestUtils.insertDesignRequestForm(show.Id,member.Id);
        GC_Design_Element__c task=LC_TestUtils.insertDesignElementTask(requestForm.Id);*/
        
        GC_Connect2_Show__c show =  GC_TestUtils.getTestConnect2Show();
        show.Show_End_Date__c = system.today().addDays(-10);
        update show;
        User trafficAdmin = GC_TestUtils.createUser('GC Traffic Administrator', 'trafAd', 'ministrator');
        GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c(
                User__c = trafficAdmin.Id,
                Connect2_Show__c = show.Id,
                Show_Role__c = 'Traffic Administrator');
            insert stm;
        
       GC_Design_Request_Form__c requestForm=GC_TestUtils.getTestDRF(show.Id);
       GC_Design_Element__c task=LC_TestUtils.insertDesignElementTask(show.Id); 
    }
    @istest
    public static void testMethod1(){
        GC_Design_Element__c task =[select id from GC_Design_Element__c where Design_Element__c='EntranceForTest'];
        GC_Design_Request_Form__c requestForm=[select id from  GC_Design_Request_Form__c where Facility__c='testFacility'];
        User trafficAdmin = GC_TestUtils.createUser('GC Traffic Administrator', 'trafAd1', 'ministrator1');
        Test.startTest();
        LC_DesignElementTaskController.createRevision(task.id);
        System.runAs(trafficAdmin) {
            LC_DesignElementTaskController.determineAccountManagerPermissions(task.id);
            LC_DesignElementTaskController.getCanSubmitForApproval();
        }
        list<RecordType> requestFormRexcordType = new List<RecordType>();
        requestFormRexcordType= [select id from RecordType where sObjecttype ='GC_Design_Request_Form__c' and DeveloperName=:'Sold_Event'];
        LC_DesignElementTaskController.cloneRecord(task);
        LC_DesignElementTaskController.getDRFId(task.id);
        LC_DesignElementTaskController.getLookupValues(task.id);
        requestForm.RecordTypeId=requestFormRexcordType[0].id;
        update requestForm;
        
        LC_DesignElementTaskController.getLookupValues(task.id);
        LC_DesignElementTaskController.fetchManifestData(task.id);
        LC_DesignElementTaskController.onHold(task.id);
        LC_DesignElementTaskController.releaseHold(task.id);
        LC_DesignElementTaskController.setApprover(task.id);
        LC_DesignElementTaskController.cancelDesignElementTask(task.id);
        task.Status__c='Archived';
        update task;
        LC_DesignElementTaskController.setApprover(task.id);
        LC_DesignElementTaskController.setApprover(task.id);
        LC_DesignElementTaskController.onHold(task.id);
        LC_DesignElementTaskController.cancelDesignElementTask(task.id);
        
        Test.stopTest();
    }
    @istest
    public static void testMethod2(){
        GC_Design_Element__c task =[select id from GC_Design_Element__c where Design_Element__c='EntranceForTest'];
        GC_Design_Request_Form__c requestForm=[select id from  GC_Design_Request_Form__c where Facility__c='testFacility'];
        Test.startTest();
        
        LC_DesignElementTaskController.getUserPermission();
        LC_DesignElementTaskController.cancelDesignElementTask(task.id);
        LC_DesignElementTaskController.createRevision(task.id);
        task.Active__c=true;
        task.Status__c='On Hold/WFI';
        update task;
        LC_DesignElementTaskController.onHold(task.id);
        LC_DesignElementTaskController.setApprover(task.id);
        LC_DesignElementTaskController.cancelDesignElementTask(task.id);
        LC_DesignElementTaskController.createRevision(task.id);
        LC_DesignElementTaskController.closeDesignReqForm(requestForm.id);
        LC_DesignElementTaskController.onHold(task.id);
        GC_Connect2_Show__c show=[select Id,Show_End_Date__c from GC_Connect2_Show__c where Show_Name__c = 'test show' AND Job_Number__c = '12345'];
        show.Show_End_Date__c = system.today().addDays(10);
        show.Revenue__c='400000';
        update show;
        LC_DesignElementTaskController.getLookupValues(task.id);
        LC_DesignElementTaskController.closeDesignReqForm(requestForm.id);
        requestForm.Status__c='New';
        update requestForm;
        task.Status__c='Canceled';
        task.Is_On_Hold__c=false;
        update task;
        LC_DesignElementTaskController.releaseHold(task.id);
        LC_DesignElementTaskController.cancelDesignElementTask(task.id);
        LC_DesignElementTaskController.deleteManifestRecords(task.id);
        Test.stopTest();
    }
    @istest
    public static void testMethod3(){
        GC_Design_Element__c task =[select id from GC_Design_Element__c where Design_Element__c='EntranceForTest'];
        GC_Design_Request_Form__c requestForm=[select id from  GC_Design_Request_Form__c where Facility__c='testFacility'];
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u1 = new User(Alias = 'standt1',Country='United Kingdom',Email='demo1@randomdemodomain.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='abcTest@camfed.org');
        insert u1;
        System.runAs(u1){
            LC_DesignElementTaskController.getUserPermission();
            LC_DesignElementTaskController.getCanSubmitForApproval();
        }
        LC_DesignElementTaskController.deleteManifestRecords(task.id);
        Test.stopTest();
        
    }
    @isTest
    public static void closeDesignReqFormTest(){
        GC_Design_Element__c task =[select id from GC_Design_Element__c where Design_Element__c='EntranceForTest'];
        GC_Design_Request_Form__c requestForm=[select id from  GC_Design_Request_Form__c where Facility__c='testFacility'];
        User trafficAdmin = GC_TestUtils.createUser('GC Traffic Administrator', 'trafAd1', 'ministrator1');
        System.runAs(trafficAdmin) {
            LC_DesignElementTaskController.closeDesignReqForm(requestForm.id);
            LC_DesignElementTaskController.determineAccountManagerPermissions(task.id);
            LC_DesignElementTaskController.createRevision(task.Id);
            
            task.Active__c = true;
            update task;
            LC_DesignElementTaskController.createRevision(task.Id);
        }
    }
}