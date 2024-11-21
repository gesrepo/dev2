@isTest
public class LC_Connect2ShowCloneControllerTest {
    
    @testSetup public static void setup() {
        User adminUser = GC_TestUtils.createUser('System Administrator','adminuser','test');
        User testUser = new User();
        system.runAs(adminUser){
            testUser = GC_TestUtils.createUser('GC Account Manager','Bhargavi','Amarapalli');
        }
        Opportunity testOppo = GC_TestUtils.getTestOpportunity();
            
        GC_Connect2_Show__c newShow = new GC_Connect2_Show__c();
        newShow.Opportunity_Name__c = testOppo.Name;
        newShow.Opportunity_Id__c = testOppo.Id;
        newShow.Show_Name__c = 'test show';
        newShow.Job_Number__c = '12345';
        newShow.Show_Start_Date__c = Date.today();
        newShow.Show_End_Date__c = Date.today();
        newShow.Exhibit_Hall_Hours_Day_1__c = '5:00 PM To 8:00 PM';
        newShow.Exhibit_Hall_Hours_Day_2__c = '7:00 AM To 6:30 PM';
        newShow.Exhibit_Hall_Hours_Day_3__c = '8:00 AM To 4:00 PM';
        newShow.Exhibit_Hall_Hours_Day_4__c = '9:00 AM To 10:00 PM';
        newShow.Exhibit_Hall_Hours_Day_5__c = '9:00 AM To 10:00 PM';
        insert newShow;   
        
        ID recordTypeId;
        /* list<GC_Show_Attribute__c> showAttribute = [select id,name,recordTypeId from GC_Show_Attribute__c where recordType.Name =:'Department'];
		if(showAttribute != null && showAttribute.size() > 0){
              recordTypeId = showAttribute[0].recordTypeId; 
        }*/
        list<RecordType> showAttributerec = [select id from RecordType where sObjecttype ='GC_Show_Attribute__c' and DeveloperName=:'Department'];
        if(showAttributerec != null && showAttributerec.size() > 0){
              recordTypeId = showAttributerec[0].Id; 
        }
        
        GC_Show_Attribute__c attribute = new GC_Show_Attribute__c();
        attribute.RecordTypeId = recordTypeId;
        attribute.name='test attributes';
        attribute.Connect2_Show__c= newShow.id;
        insert attribute;
        
        GC_Show_Team_Member__c member = new GC_Show_Team_Member__c();
        member.user__c= testUser.id;
        member.Connect2_Show__c= newShow.id;
        member.Show_Role__c='Sales Manager';
        insert member;
        
    }
    @isTest
    public static void testMethod1() {
        
        GC_Connect2_Show__c show = [select id from GC_Connect2_Show__c where Show_Name__c='test show'];
        
        string showId = show.id;
        List<GC_Show_Team_Member__c> member=[select id from GC_Show_Team_Member__c where Connect2_Show__c=: showId];
        string memberId= member[0].id;
        GC_Show_Attribute__c attribute =[select id from GC_Show_Attribute__c where name='test attributes'];
        string  attributeId=attribute.id;
        LC_Connect2ShowCloneController.getAttributeAndMembersName(attributeId,showId,memberId);
        LC_Connect2ShowCloneController.cloneShowAttribute(attributeId,showId,memberId);
        LC_Connect2ShowCloneController.getShowAttributes(showId);
        LC_Connect2ShowCloneController.getShowTeamMembers(showId);
    }
}