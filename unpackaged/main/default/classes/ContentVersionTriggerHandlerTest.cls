@isTest
public class ContentVersionTriggerHandlerTest {
    
    @isTest
    static void TestMehtod1() {
        Id recordTypeId = Schema.SObjectType.Quote__c.getRecordTypeInfosByDeveloperName().get('Logistics_Domestic').getRecordTypeId();
        
        Quote__c q = new Quote__c();
        
        q.RecordTypeId = recordTypeId;
        q.Quote_Subject__c = 'Roundtrip';
        q.Job_Code__c = 'JOB001';
        q.Origination_Street__c = '7000 Lindell Rd';
        q.Origination_City__c = 'Las Vegas';
        q.Origination_State__c = 'NV';
        insert q;

        ContentVersion contentVersion = new ContentVersion(
            Title          = 'a text',
            PathOnClient   = 'textinfo.snote',
            VersionData    = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        
        insert contentVersion;
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = q.Id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.ShareType = 'V';
        cdl.Visibility = 'AllUsers';
        insert cdl;
    }

}