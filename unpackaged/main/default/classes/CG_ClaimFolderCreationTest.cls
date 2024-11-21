@isTest
public class CG_ClaimFolderCreationTest {
    
    static testMethod void testingClaimInsert(){    
        test.startTest();
        Claims__Claim__c claim1 = new Claims__Claim__c();
        Id recordTypeIdWorkersCompensation = Schema.SObjectType.Claims__Claim__c.getRecordTypeInfosByName().get('Workers Compensation').getRecordTypeId();
        Id recordTypeIdBodilyInjury = Schema.SObjectType.Claims__Claim__c.getRecordTypeInfosByName().get('Bodily Injury').getRecordTypeId();

        claim1.RecordTypeId = recordTypeIdWorkersCompensation;
        insert claim1;
        
        Claims__Claim__c claim2 = new Claims__Claim__c();
        claim2.RecordTypeId = recordTypeIdBodilyInjury;
        insert claim2;
        
        CG_ClaimFolderCreationHandler.createFoldersOnAllClaims();  
        test.stopTest();
    }
}