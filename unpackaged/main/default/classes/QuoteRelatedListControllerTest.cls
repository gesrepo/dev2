@isTest
public class QuoteRelatedListControllerTest {
	
    @isTest public static void testInit(){
        Account acc = new Account(Name = 'test');
        insert acc;
        Contact cnt = new Contact(LastName = 'test', AccountId = acc.Id);
        insert cnt;
        Case c = new Case(Subject = 'sub',CORE_SQR_ID__c = '1',GES_Type__c = 'Audio Visual',reason__c = 'test',Send_CORE_SQR_Status__c = 'In Process',AccountId=acc.Id, ContactId=cnt.Id);
        insert c;
        
        Map<String, Object> requestMap = new Map<String, Object>(); 
        requestMap.put(QuoteRelatedListController.FIELDS_PARAM, 'Id,Name,Quote_Subject__c,Order_Date__c,Complete_By__c,Type__c,Stage__c,Show__c,Account_Id__c,Total__c,OB_Total__c');
        requestMap.put(QuoteRelatedListController.RELATED_FIELD_API_NAME_PARAM, 'Related_Case__c');
        requestMap.put(QuoteRelatedListController.RECORD_ID_PARAM, c.Id);
        requestMap.put(QuoteRelatedListController.NUMBER_OF_RECORDS_PARAM, 1);
        requestMap.put(QuoteRelatedListController.SOBJECT_API_NAME_PARAM, 'Quote__c');
        requestMap.put(QuoteRelatedListController.SORTED_BY_PARAM, 'CreatedDate');
        requestMap.put(QuoteRelatedListController.SORTED_DIRECTION_PARAM, 'DESC');
		requestMap.put(QuoteRelatedListController.RELATED_OBJECT_API_NAME_PARAM, 'Case');
		requestMap.put(QuoteRelatedListController.PARENT_FIELDS_PARAM, 'Id,ContactId,AccountId');      
        
        String jsonData = QuoteRelatedListController.initData(JSON.serialize(requestMap));
        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(jsonData);
        List<Object> records = (List<Object>)responseMap.get(QuoteRelatedListController.RECORDS_PARAM);
        String iconName = (String)responseMap.get(QuoteRelatedListController.ICON_NAME_PARAM);
        QuoteRelatedListController.fetchRecordTypeValues();
    }
}