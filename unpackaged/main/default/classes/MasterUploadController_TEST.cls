@isTest
private class MasterUploadController_TEST {

    static testMethod void myUnitTest() {
    	Account acct = new Account(name='the account', BillingCountry='US',phone='555-555-5555', BillingStreet='666 wacker',BillingState='MD',BillingCity='Baltimore', BillingPostalCode='20888-4444');
		insert acct;
		
    	Opportunity o = new Opportunity(
    		Name = 'test',
			amount=1,
			//recordTypeId = rtID, 
			CloseDate = System.today().addYears(1),
			stageName = 'Meeting Scheduled',
			accountid=  acct.Id
			//Show_Occurrence__c = showOccuranceID
		);
    	insert o;
    	
    	Contact c = new Contact(
    		firstName = 'test',
    		lastName = 'test',
    		AccountId = acct.Id
    	);
		insert c;
    	
        Booth_Upload__c bu = new Booth_Upload__c(
        	Opportunity__c = o.Id,
        	Organiser__c = acct.Id,
        	Status__c = 'Test'
        );
    	insert bu;
    	
    	Booth_Staging__c bs = new Booth_Staging__c(
    		Booth_Upload__c = bu.Id,
            Company__c = 'Vertiba',
            First_Name__c = 'Lucian',
            Last_Name__c = 'Ciobanu',
            Stand_Number__c = '123',
            Post_Zip_Code__c = '00000'
    	);
    	insert bs;
    	
    	Oracle_Show_Booth__c osb = new Oracle_Show_Booth__c(
    		Name = '123',
    		Account__c = acct.Id,
    		Show_Occurrence__c = o.Id
    	);
    	insert osb;
    	
    	Oracle_Show_Booth_Contact__c bc = new Oracle_Show_Booth_Contact__c(
    		Oracle_Show_Booth__c = osb.Id,
    		Contact__c = c.Id
    	);
    	insert bc;
    	    	
    	test.startTest();
    	PageReference pageRef = Page.MasterUploadPage;
    	Test.setCurrentPageReference(pageRef);

        ApexPages.StandardController sc = new ApexPages.standardController(bu);
        ApexPages.currentPage().getParameters().put('Id', bu.Id);

        MasterUploadController controller = new MasterUploadController(sc);
        /*
        controller.BoothStagingWrapper w = new MasterUploadController.BoothStagingWrapper();
        controller.BoothStagingWrapper.account = acct;
    	controller.BoothStagingWrapper.booth = osb;
    	controller.BoothStagingWrapper.boothContact = bc;
    	controller.BoothStagingWrapper.staging = bs;
    	controller.contact = c;
    	wcontroller.putInTheEmail();
    	*/
    	controller.confirmRecords();
    	//controller.confirmalert();
    	controller.gotoImportBuddy();
    	controller.RedirectIfNotFound();
    	controller.saveRecords();
        test.stopTest();
    }
}