/**
 * Class: DataDotComUpdateAccBatch_Test.cls
 * Developer: Marian Iovi (marian.iovi@vertiba.com)
 * Created: January 26, 2017
 * Modified: -
 * Objective This class provides test methods for DataDotComUpdateAccBatch.cls
 *
 *
 **/ 

@isTest
private class DataDotComUpdateAccBatch_Test {

	@isTest
	private static void testName() {
		List<Account> accounts = new List<Account>();
		Account acc1 = new Account();
		acc1.Name = 'Account1';
		acc1.BillingCountry = 'US';
		acc1.BillingState = 'US';
		acc1.BillingPostalCode = '1234';
		acc1.Source_Exhibitor_Upload__c = true;
		acc1.Exhibitor_onDataCom__c = true;
		accounts.add(acc1);

		Account acc2 = new Account();
		acc2.Name = 'Account1';
		acc2.BillingCountry = 'US';
		acc2.BillingState = 'US';
		acc2.BillingPostalCode = '1234';
		acc2.Source_Exhibitor_Upload__c = true;
		acc2.Exhibitor_onDataCom__c = true;
		accounts.add(acc2);
		
		Account acc3 = new Account();
		acc3.Name = 'Account1';
		acc3.BillingCountry = 'US';
		acc3.BillingState = 'US';
		acc3.BillingPostalCode = '1234';
		acc3.Source_Exhibitor_Upload__c = true;
		acc3.Exhibitor_onDataCom__c = true;
		accounts.add(acc3);

		insert accounts;

		InformaApiErrorEmail__c errEmail = new InformaApiErrorEmail__c();
		errEmail.Name = 'test';
		errEmail.Email__c = 'test@test.com';
		insert errEmail;

		System.Test.startTest();

		DataDotComUpdateAccBatch batch = new DataDotComUpdateAccBatch(UserInfo.getSessionId());
		batch.haveErr = true;
		Database.executeBatch(batch);

		System.Test.stopTest();
	}
}