@isTest
public class RollUpSummaryTest {

    public static testMethod void TestRollUp() {
        Id parentRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Field Security-LPM').getRecordTypeId();
        Id childRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('US - Housing').getRecordTypeId();
        
        Opportunity parent = new Opportunity();
        parent.Name = 'Lucian245973';
        parent.RecordTypeId = parentRecTypeId;
        parent.StageName = 'PO';
        parent.CloseDate = Date.today();
        parent.New_Repeat__c = 'New';
        parent.Amount = 1000;
        insert parent;
        
        Opportunity child = new Opportunity();
        child.Name = 'Lucian245973';
        child.RecordTypeId = childRecTypeId;
        child.Show_Occurrence__c = parent.Id;
        child.StageName = 'CR';
        child.CloseDate = Date.today();
        child.Amount = 1000;
        insert child;
        
        Test.startTest();
        
        parent = [SELECT LOB_Contracting_Count_US__c FROM Opportunity WHERE Id = :parent.Id];
        System.assertEquals(1, parent.LOB_Contracting_Count_US__c);
        
        TriggerOptimizationUtility.RollUpSummary_Handled = new Set<Id>();
        child.StageName = 'XX';
        update child;
        
        parent = [SELECT LOB_Contracting_Count_US__c FROM Opportunity WHERE Id = :parent.Id];
        System.assertEquals(0, parent.LOB_Contracting_Count_US__c);
        
        TriggerOptimizationUtility.RollUpSummary_Handled = new Set<Id>();
        delete child;
        
        parent = [SELECT LOB_Contracting_Count_US__c FROM Opportunity WHERE Id = :parent.Id];
        System.assertEquals(0, parent.LOB_Contracting_Count_US__c);
        
        Test.stopTest();
        
    }

}