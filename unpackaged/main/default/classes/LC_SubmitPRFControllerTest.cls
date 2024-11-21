@isTest
public class LC_SubmitPRFControllerTest {

    static testMethod void submitPRFTest1(){
        
        Account a = new Account();
        a.name = 'test account';
        a.recordTypeId = [select Id from RecordType where Name = 'Firm' and SobjectType = 'Account'].id;
        insert a;
        
        Test.startTest();
        
        Opportunity opp = new Opportunity();
        opp.name = 'test opp';
        opp.stagename = 'LO';
        opp.closedate = Date.today()+10;
        opp.Show_Close_Date__c = Date.Today()+10;
        opp.Show_End_Date_Time__c = Date.Today()+15; 
        opp.RecordTypeId = [select Id from RecordType where Name = 'E&D - Projects' and SobjectType = 'Opportunity'].id;
        opp.amount = 20000;
        opp.Prime_Contractor__c = a.id;
        opp.PRFRequest_Type__c = 'test';
        opp.ED_Opportunity_Owner__c = 'Test Abc';
        insert opp;
        LC_SubmitPRFController.updateOpportunity(opp.Id);
        
        Test.stopTest();
 
    }
    
     static testMethod void submitPRFTest2(){
        
        Account a = new Account();
        a.name = 'test account';
        a.recordTypeId = [select Id from RecordType where Name = 'Firm' and SobjectType = 'Account'].id;
        insert a;
        
        Test.startTest();
        
        Opportunity opp = new Opportunity();
        opp.name = 'test opp';
        opp.stagename = 'LO';
        opp.closedate = Date.today()+10;
        opp.Show_Close_Date__c = Date.Today()+10;
        opp.Show_End_Date_Time__c = Date.Today()+15; 
        opp.RecordTypeId = [select Id from RecordType where Name = 'E&D - Projects' and SobjectType = 'Opportunity'].id;
        opp.amount = 20000;
        opp.Prime_Contractor__c = a.id;
        insert opp;
        LC_SubmitPRFController.updateOpportunity(opp.Id);
        
        Test.stopTest();
        
    }
}