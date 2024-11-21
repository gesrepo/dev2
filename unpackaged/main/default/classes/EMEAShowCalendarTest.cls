@isTest
public class EMEAShowCalendarTest {
    
    
    //@isTest(SeeAllData=true)
    @isTest()
    static void test_EMEAShowCalendar()
    {
        Opportunity op1 = CreateOpportunity();
        Product2 prod = CreateProduct();
        PricebookEntry pbEntry = CreatePricebookEntry(prod);
        OpportunityLineItem opLI1 = CreateOpportunityLineItem(op1, pbEntry, prod);
        
        system.debug('Test Opportunity: ' + op1);
        
        Test.startTest();
        EMEAShowCalendar showCal = new EMEAShowCalendar(null);
        
        system.debug('Period Mapping: ' + showCal.periodsMap);
        
        showCal.search();
        
        system.debug('Shows: ' + showCal.show);
        
        
        PageReference pr = showCal.excel();
        PageReference pr2 = showCal.print();
        showCal.clear();
        
        Test.stopTest();
    }
    
    
    static Opportunity CreateOpportunity()
    {
        Id opRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('EMEA - Exhibition').getRecordTypeId();
        
        
        Opportunity op1 = new Opportunity();
        op1.RecordTypeId = opRT;
        op1.Name = 'Test opportunity';
        op1.stageName = 'CR';
        op1.Show_Open_Date__c = Date.today();
        op1.closeDate = Date.today() + 1;
        
        
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