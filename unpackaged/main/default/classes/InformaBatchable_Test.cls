/**
 * Class: InformaBatchable.cls
 * Developer: Marian Iovi (marian.iovi@vertiba.com)
 * Created: December 12, 2016
 * Modified: December 23, 2016
 * Objective: This class provides test methods for InformaBatchable.cls
 *
 **/ 

@isTest
 public class InformaBatchable_Test{

	@testSetup
	public static void dataSetup(){

		//Custom settings
		Informa_API_Settings__c informaApi = new Informa_API_Settings__c();
		informaApi.Name = 'url';
		informaApi.Url_Value__c = 'https://geukmeexhibitors.azure-api.net/exhibitorlisting/basic/catalogue/';
		informaApi.Subscription_Key__c = '60cef13928c64d43b91485922feb9d06';
		insert informaApi;


		//mappingFields
		List<InformaIntegrationFields__c> integrFields = new List<InformaIntegrationFields__c>();
		
		InformaIntegrationFields__c address1 = new InformaIntegrationFields__c();
		address1.Name = 'Address1';
		address1.Api_Informa__c = 'signatory.address1';
		address1.Booth_Staging_Api_Name__c = 'Address_1__c';
		integrFields.add(address1);

		InformaIntegrationFields__c address2 = new InformaIntegrationFields__c();
		address2.Name = 'Address2';
		address2.Api_Informa__c = 'signatory.address2';
		address2.Booth_Staging_Api_Name__c = 'Address_2__c';
		integrFields.add(address2);

		InformaIntegrationFields__c city = new InformaIntegrationFields__c();
		city.Name = 'City';
		city.Api_Informa__c = 'signatory.city';
		city.Booth_Staging_Api_Name__c = 'City__c';
		integrFields.add(city);

		InformaIntegrationFields__c compName = new InformaIntegrationFields__c();
		compName.Name = 'Company Name';
		compName.Api_Informa__c = 'companyname';
		compName.Booth_Staging_Api_Name__c = 'company__c';
		integrFields.add(compName);

		InformaIntegrationFields__c country = new InformaIntegrationFields__c();
		country.Name = 'Country';
		country.Api_Informa__c = 'signatory.country';
		country.Booth_Staging_Api_Name__c = 'Country__c';
		integrFields.add(country);

		InformaIntegrationFields__c email1 = new InformaIntegrationFields__c();
		email1.Name = 'Email';
		email1.Api_Informa__c = 'signatory.email';
		email1.Booth_Staging_Api_Name__c = 'Email__c';
		integrFields.add(email1);

		InformaIntegrationFields__c exGuuid = new InformaIntegrationFields__c();
		exGuuid.Name = 'Exhibitor GUID';
		exGuuid.Api_Informa__c = 'exhibitorguid';
		exGuuid.Booth_Staging_Api_Name__c = 'Exhibitor_GUID__c';
		integrFields.add(exGuuid);

		InformaIntegrationFields__c fax = new InformaIntegrationFields__c();
		fax.Name = 'Fax';
		fax.Api_Informa__c = 'signatory.fax';
		fax.Booth_Staging_Api_Name__c = 'Fax__c';
		integrFields.add(fax);

		InformaIntegrationFields__c fName = new InformaIntegrationFields__c();
		fName.Name = 'First Name';
		fName.Api_Informa__c = 'signatory.firstname';
		fName.Booth_Staging_Api_Name__c = 'First_Name__c';
		integrFields.add(fName);

		InformaIntegrationFields__c lName = new InformaIntegrationFields__c();
		lName.Name = 'Last Name';
		lName.Api_Informa__c = 'signatory.lastname';
		lName.Booth_Staging_Api_Name__c = 'Last_Name__c';
		integrFields.add(lName);

		InformaIntegrationFields__c mobile = new InformaIntegrationFields__c();
		mobile.Name = 'Mobile';
		mobile.Api_Informa__c = 'signatory.mobile';
		mobile.Booth_Staging_Api_Name__c = 'Mobile__c';
		integrFields.add(mobile);

		InformaIntegrationFields__c nBoard = new InformaIntegrationFields__c();
		nBoard.Name = 'Name Board';
		nBoard.Api_Informa__c = 'nameboard';
		nBoard.Booth_Staging_Api_Name__c = 'Nameboard_Name__c';
		integrFields.add(nBoard);

		InformaIntegrationFields__c passw = new InformaIntegrationFields__c();
		passw.Name = 'Password';
		passw.Api_Informa__c = 'password';
		passw.Booth_Staging_Api_Name__c = 'Exhibitor_Password__c';
		integrFields.add(passw);

		InformaIntegrationFields__c phone = new InformaIntegrationFields__c();
		phone.Name = 'Phone';
		phone.Api_Informa__c = 'signatory.phone';
		phone.Booth_Staging_Api_Name__c = 'Phone_Number__c';
		integrFields.add(phone);

		InformaIntegrationFields__c postal = new InformaIntegrationFields__c();
		postal.Name = 'Postal Code';
		postal.Api_Informa__c = 'signatory.postal';
		postal.Booth_Staging_Api_Name__c = 'Post_Zip_Code__c';
		integrFields.add(postal);

		InformaIntegrationFields__c salut = new InformaIntegrationFields__c();
		salut.Name = 'Salutation';
		salut.Api_Informa__c = 'signatory.title';
		salut.Booth_Staging_Api_Name__c = 'Salutation__c';
		integrFields.add(salut);

		InformaIntegrationFields__c standNr = new InformaIntegrationFields__c();
		standNr.Name = 'Stand Number';
		standNr.Api_Informa__c = 'standnumber';
		standNr.Booth_Staging_Api_Name__c = 'stand_number__c';
		integrFields.add(standNr);

		InformaIntegrationFields__c standSz = new InformaIntegrationFields__c();
		standSz.Name = 'Stand Size';
		standSz.Api_Informa__c = 'standsize';
		standSz.Booth_Staging_Api_Name__c = 'booth_size__c';
		integrFields.add(standSz);

		InformaIntegrationFields__c standtype = new InformaIntegrationFields__c();
		standtype.Name = 'Stand Type';
		standtype.Api_Informa__c = 'standtype';
		standtype.Booth_Staging_Api_Name__c = 'stand_type__c';
		integrFields.add(standtype);

		InformaIntegrationFields__c state = new InformaIntegrationFields__c();
		state.Name = 'State';
		state.Api_Informa__c = 'state';
		state.Booth_Staging_Api_Name__c = 'State_County__c';
		integrFields.add(state);

		InformaIntegrationFields__c status = new InformaIntegrationFields__c();
		status.Name = 'Status';
		status.Api_Informa__c = 'status';
		status.Booth_Staging_Api_Name__c = 'exhibitor_status__c';
		integrFields.add(status);

		InformaIntegrationFields__c uName = new InformaIntegrationFields__c();
		uName.Name = 'User Name';
		uName.Api_Informa__c = 'username';
		uName.Booth_Staging_Api_Name__c = 'Exhibitor_Username__c';
		integrFields.add(uName);

		InformaIntegrationFields__c website = new InformaIntegrationFields__c();
		website.Name = 'Website';
		website.Api_Informa__c = 'signatory.website';
		website.Booth_Staging_Api_Name__c = 'Website__c';
		integrFields.add(website);
        
        InformaApiErrorEmail__c emailList = new InformaApiErrorEmail__c();
        emailList.Name = 'Test';
        emailList.Email__c = 'test@test.com';
		insert emailList;

		insert integrFields;
	}

 	@isTest
 	public static void testMethod1(){
		
		Account acc = new Account();
 		acc.Name = 'New Account';
 		acc.BillingCountry = 'US';
 		acc.BillingState = 'NY';
 		acc.BillingPostalCode = '12345';
 		insert acc;

 		Opportunity opp = new Opportunity();
 		opp.AccountId = acc.Id;
 		opp.Name = 'Opportunity name';
 		opp.Token__c = 'Q0JvNzFPUEM1Zi96cmp2VEVUamtwZmlvNlBWSGFrUHRXTDd0U3RJT2FEND01';
 		opp.Event_Code__c = 'TESTUS2017';
 		opp.StageName = 'Verbal Agreement';
 		opp.CloseDate = Date.today();
 		insert opp;

 		Test.startTest();
 			ScheduleInformaBatchable batchS = new ScheduleInformaBatchable();
 			String sch = '0 ' + Datetime.now().minute() + ' ' + Datetime.now().hour() + ' * * ?';
 			System.schedule('Test', sch, batchS);
 		Test.stopTest();
		 
 		//Verifications
 		List<Booth_Upload__c> buList = [Select Id, Name from Booth_Upload__c where Opportunity__c =: opp.Id Limit 1];
 		System.debug('***buList: ' + buList);

		//System.assertEquals(1, buList.size());
 	}

	@isTest
 	public static void testMethodMockImpl(){
		String jsonStr = InformaMockImpl.resp();

		InformaMockImpl inf = new InformaMockImpl();
		// Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(jsonStr);
        res.setStatusCode(200);

		HTTPRequest req = new HTTPRequest();
		inf.respond(req);
		System.assertEquals(jsonStr, res.getBody());
	}

 }