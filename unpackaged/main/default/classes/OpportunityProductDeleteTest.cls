@isTest
public class OpportunityProductDeleteTest {

    static testMethod void testMethod1()
    {
        Opportunity op1 = CreateOpportunity();
        Product2 prod = CreateProduct();
        PricebookEntry pbEntry = CreatePricebookEntry(prod);
        OpportunityLineItem opLI1 = CreateOpportunityLineItem(op1, pbEntry, prod);
        
        system.debug('Test Opportunity: ' + op1);
        
        //--- Start test
        
        Test.StartTest();
    
        PageReference pageRef = Page.OpportunityProducts_Delete; // VF page
  		pageRef.getParameters().put('id', String.valueOf(op1.Id));
  		Test.setCurrentPage(pageRef);

        ApexPages.StandardController sc = new ApexPages.StandardController(opLI1);
  		OpportunityProducts_CheckDelete testProductDelete = new OpportunityProducts_CheckDelete(sc);
  
  		testProductDelete.checkDelete(); 
    
        Test.StopTest();
        
        //--- End test 
       
    }
    
    static Opportunity CreateOpportunity()
    {
        Id opRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('EMEA - Poken and Visit').getRecordTypeId();
        
        
        Opportunity op1 = new Opportunity();
        op1.RecordTypeId = opRT;
        op1.Name = 'Test opportunity';
        op1.stageName = 'CR';
        op1.Show_Open_Date__c = Date.today();
        op1.closeDate = Date.today() + 1;
        op1.Amount = 100;
        
        insert op1;
        
        return op1;
    }
    
    static Product2 CreateProduct()
    {
        Product2 prod = new Product2(
            Name = 'Product X',
            ProductCode = 'Pro-X',
            isActive = true
        );
        insert prod;
        system.debug('Test Product2: ' + prod);
        return prod;
    }
    
    static PricebookEntry CreatePricebookEntry(Product2 prod)
    {
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pbEntry = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = prod.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert pbEntry;
        system.debug('Test PricebookEntry: ' + pbEntry);
        return pbEntry;
    }
    
    static OpportunityLineItem CreateOpportunityLineItem(Opportunity opp, PricebookEntry pbEntry, Product2 prod)
    {
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId = opp.Id,
            Quantity = 5,
            PricebookEntryId = pbEntry.Id,
            TotalPrice = 5 * pbEntry.UnitPrice
        );
        
        insert oli;
        
        system.debug('Test opportunity line item: ' + oli);
        
        return oli;
    }
}