@isTest
private class MasterUploadControllerTest {
	@isTest static void test_method_one() {
		Profile profile1 = [SELECT Id FROM Profile WHERE Name='Standard User']; 
		User testUser = new User(
	   	ProfileId = profile1.Id,
	    Username ='DarkKnight@test.com',
	   	Alias = 'batman',
	   	Email='bruce.wayne@wayneenterprises.com',
	   	EmailEncodingKey='UTF-8',
	   	Firstname='Bruce',
	   	Lastname='Wayne',
	   	LanguageLocaleKey='en_US',
	   	LocaleSidKey='en_US',
	   	TimeZoneSidKey='America/Chicago'
	   	);
		insert(testUser);

		Opportunity op1 = new Opportunity();
		op1.Name = 'opp1';
		op1.stageName = 'oppStage';
		op1.closeDate = Date.today();
		insert op1;
		Booth_Upload__c bu = new Booth_Upload__c();
		bu.Opportunity__c = op1.id;
		insert bu;
		Booth_Staging__c b = new Booth_Staging__c();
		b.Booth_Upload__c = bu.id;
		b.Status__c = 'New';
		insert b;

		ApexPages.StandardController sc = new ApexPages.StandardController(bu);
		system.currentPageReference().getParameters().put('Id', bu.Id);
		MasterUploadController muc = new MasterUploadController(sc);
		muc.resetAlerts();
		muc.gotoImportBuddy();
		muc.isdeleting();
		muc.saveRecords();
		try {
			muc.CancelBatch();
		} catch (Exception e) {
			system.debug(e);
		}
		try {
			muc.CheckBatch();
		} catch(Exception e) {
			system.debug(e);
		}
		try {
			muc.confirmRecords();	
		} catch(Exception e){
			system.debug(e);
		}
		try	{
			muc.RedirectIfNotFound();
		} catch(Exception e) {
			system.debug(e);
		}
		Integer i = muc.noPages;
		muc.firstPage();
		muc.lastPage();
		muc.currentPage = 4;
		muc.previousPage();
		muc.currentPage = -4;
		muc.nextPage();
	}
    
    @isTest public static void test_for_Lightning() {
        List<Booth_Staging__c> bsList = new List<Booth_Staging__c>();
        Opportunity op1 = new Opportunity();
		op1.Name = 'opp1';
		op1.stageName = 'oppStage';
		op1.closeDate = Date.today();
		insert op1;
		Booth_Upload__c bu = new Booth_Upload__c();
		bu.Opportunity__c = op1.id;
		insert bu;
		Booth_Staging__c bs_good = new Booth_Staging__c();
		bs_good.Booth_Upload__c = bu.id;
		bs_good.Status__c = 'New';
        bsList.add(bs_good);
        Booth_Staging__c bs_bad = new Booth_Staging__c();
		bs_bad.Booth_Upload__c = bu.id;
		bs_bad.Status__c = 'NONE';
		bs_bad.Post_Zip_Code__c = '323423423412342134';
        bsList.add(bs_bad);
        MasterUploadController.createStageRecords(bsList,new List<String>{'Test'});
        Test.startTest();
		MasterUploadController.sendEmailAfterFileUpload('TestHeading1,TestHeading2 \n Test1,Test2',true,bu.id);
		Test.stopTest();
        MasterUploadController.getAllColumnsDetail('Booth_Staging__c');
        MasterUploadController.showStageData('["Status__c","Name","Company__c","Country__c","Agency_Email__c","Agency_Contact__c"]','Booth_Staging__c',bu.id);
        String batchId = MasterUploadController.runTheBatch(bu.id);
        MasterUploadController.checkRunningBatchStatus(bu.id,batchId);
        MasterUploadController.deleteBsRecords([SELECT Id from Booth_Staging__c where Booth_Upload__c =: bu.id]);
        MasterUploadController.checkRunningBatchStatus(bu.id,batchId);
    }
}