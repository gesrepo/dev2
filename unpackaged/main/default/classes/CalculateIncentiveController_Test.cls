@isTest
public without sharing class CalculateIncentiveController_Test
{ 
   
    
    static testMethod void testAggAndIncentCreation()
    {
    
    Profile p = [select id from profile where name='Standard User'];

            User u = new User(alias = 'test123', email='test123@noemail.com',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id, country='United States',
            timezonesidkey='America/Los_Angeles', username='tetsly45@gmail.com',Eligible_for_Incentives__c=true);
            insert u;
            Account acc=new Account();
            acc.name='Test';
            insert acc;
        Account a=[select id,name from account where name='Test'];
        //TestDataUtilityClass td=new TestdataUtilityClass();
         Opportunity opp=new Opportunity();
            opp.Name='Test';
            opp.PRF_Sent_to_CORE__c = false;
            opp.Processed_in_CORE__c = false;
            opp.Type  =  'Competitor CORE Show';
            opp.stagename='Prospecting';
            opp.CloseDate=date.today();
            insert opp;
        Opportunity op=[select id from Opportunity limit 1];
        Agreements__c agg=new Agreements__c();
        agg=new Agreements__c(Name='Test');
            agg.Sales_Person__c= u.Id;
            agg.Show_Occurrence__c=op.Id;
            agg.Smart_Sell__c=  'Yellow';
            agg.CurrencyIsoCode='USD';
            agg.Account__c=a.Id;
            agg.SalesRep1__c=u.Id;
            agg.Front_End_Percent__c=100;
            agg.Rep_1_Back_End_Percent__c=100;
            agg.AV_Opportunity__c=op.id;
            agg.Show_Occurrence_5__c=op.id;
            agg.AV_Opportunity_5__c=op.id;
            agg.Show_Occurrence_2__c=op.Id;
            agg.Show_Occurrence_3__c=op.Id;
            agg.Show_Occurrence_4__c=op.Id;
            agg.Show_Occurrence_6__c=op.Id;
            agg.AV_Opportunity_2__c=op.Id;
            agg.AV_Opportunity_3__c=op.Id;
            agg.AV_Opportunity_4__c=op.id;
            agg.AV_Opportunity_6__c=op.Id;
            insert agg;
        Agreements__c  aggId=[select id from Agreements__c where name='Test' limit 1];
        String opty=op.Id;
        String userIds=u.Id;
        
                
        Test.startTest();
        CalculateIncentiveController.createIncentives(aggId.Id);
        Test.stopTest();
        
    }
    
    static testMethod void testSalesRepmethod()
    {
    
    Profile p = [select id from profile where name='Standard User'];

            User u = new User(alias = 'test123', email='test123@noemail.com',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id, country='United States',
            timezonesidkey='America/Los_Angeles', username='tetsly45@gmail.com',Eligible_for_Incentives__c=true);
            insert u;
            Account acc=new Account();
            acc.name='Test';
            insert acc;
        Account a=[select id,name from account where name='Test'];
        //TestDataUtilityClass td=new TestdataUtilityClass();
         Opportunity opp=new Opportunity();
            opp.Name='Test';
            opp.PRF_Sent_to_CORE__c = false;
            opp.Processed_in_CORE__c = false;
            opp.Type  =  'Competitor CORE Show';
            opp.stagename='Prospecting';
            opp.CloseDate=date.today();
            insert opp;
        Opportunity op=[select id from Opportunity limit 1];
        Agreements__c agg=new Agreements__c();
        agg=new Agreements__c(Name='Test');
            agg.Sales_Person__c= u.Id;
            agg.Show_Occurrence__c=op.Id;
            agg.Smart_Sell__c=  'Yellow';
            agg.CurrencyIsoCode='USD';
            agg.Account__c=a.Id;
            agg.SalesRep1__c=u.Id;
            agg.Front_End_Percent__c=100;
            agg.Rep_1_Back_End_Percent__c=100;
            insert agg;
        Agreements__c  aggId=[select id from Agreements__c where name='Test' limit 1];
        String opty=op.Id;
        String userIds=u.Id;
        
                
        Test.startTest();
        CalculateIncentiveController.salesrep(opty,agg,userIdS,80.0,90.0);
        Test.stopTest();
        
    }
}