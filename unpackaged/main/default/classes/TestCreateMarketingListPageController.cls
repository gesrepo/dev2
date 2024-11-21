@isTest
private class TestCreateMarketingListPageController{

	@isTest
    static void createMarketingListPageController_Test()
    {   
		//Test converage for the myPage visualforce page
		//Create Test Data First
		
		//Create User (for Owner)
		ID OwnerId = UserInfo.getUserId();
		
		//Create User Sales Person
		ID SalesRepId = UserInfo.getUserId();
		
		//Create Facility
		Account Facility = new Account();
		Facility.Sales_Person__c = SalesRepId;
		Facility.Name = 'MyTestFacilityName';
		Facility.Type = 'Hotel';
		Facility.GES_Status__c = 'Preferred';
		Facility.LMS_Facility_ID__c = 'ABCFAC';
		Facility.BillingStreet = '950 Grier Dr';
		Facility.BillingCity = 'Las Vegas';
		Facility.BillingPostalCode = '89119';
		Facility.BillingState = 'Nevada';
		Facility.BillingCountry = 'US';
		Facility.RecordTypeId = '012400000005NYN';
		
		//Create Account
		Account Exhibitor = new Account();
		Exhibitor.Sales_Person__c = SalesRepId;
		Exhibitor.Name = 'MyTestExhibitorName';
		Exhibitor.Phone = '7022631500';
		Exhibitor.BillingStreet = '950 Grier Dr';
		Exhibitor.BillingCity = 'Las Vegas';
		Exhibitor.BillingPostalCode = '89119';
		Exhibitor.BillingState = 'Nevada';
		Exhibitor.BillingCountry = 'US';
		Exhibitor.RecordTypeId = '0124000000012Ob';
				
		//Create Show
		Show__c Show = new Show__c();
		Show.Sales_Person__c = SalesRepId;
		Show.Account__c = Exhibitor.Id;
		Show.Name ='MyTestShow';
		Show.Show_Type__c = 'Food Sector';
		//Commenting this field as this field is being removed from "Show" object per RFC-001155
		//Show.Show_Function_Type__c = 'I:Independent Organizer';
		Show.Show_ID__c = '123456';
	     
		//Create ShowOccurrence
		Opportunity ShowOcc = new Opportunity();
	   
		ShowOcc.OwnerId = OwnerId;
		ShowOcc.Sales_Person__c = SalesRepId;
		ShowOcc.Sales_Location__c = '520- Miami, Orlando, Tampa';
		ShowOcc.Name = 'MyTestShow001';
		ShowOcc.Prime_Contractor__c = null;
		ShowOcc.Production_Location__c = '710- Chicago, Cleveland, Milwaukee, St. Louis';
		ShowOcc.Facility__c = Facility.Id;
		ShowOcc.StageName = 'OF';
		ShowOcc.Amount = 1000;
		ShowOcc.Type = 'ITYFTY';
		ShowOcc.New_Repeat__c = 'New';
		ShowOcc.Frequency__c = 'B1';
		ShowOcc.Job_Number_Status__c = 'Open';
		ShowOcc.AccountId = Exhibitor.Id;
		ShowOcc.Show_Name__c = Show.Id;
		
		Date OpenDate = Date.newInstance(2010,12,1);
		Date CloseDate = Date.newInstance(2010,12,2);
		
		ShowOcc.Show_Open_Date__c = OpenDate;
		ShowOcc.Show_Close_Date__c = CloseDate;
		ShowOcc.CloseDate = CloseDate;
		
		database.insert(ShowOcc);
		
		//Create Leads
		List<Lead> ListOfLeads = new List<Lead>();
		Lead[] InsertLeads = new Lead[200];
		Integer Count = 0;
		
		for(Integer i=0; i<201;i++)
		{
			Lead MyLead = new Lead();
			MyLead.FirstName = 'TestFirstName' + String.valueof(i);
			MyLead.LastName = 'TestLastName' + String.valueof(i);
			MyLead.Email = 'testemail' + String.valueof(i) + '@test.com';
			MyLead.Company = 'TestCompany';
			MyLead.Phone = '7029630102';
			MyLead.Street = '950 Grier Dr';
			MyLead.City = 'Las Vegas';
			MyLead.State = 'Nevada';
			MyLead.PostalCode = '89119';
			MyLead.Country = 'US';
			
			MyLead.Active_Source_Code__c = 'TESTSOURCECODE001';
			
			InsertLeads[Count] = MyLead;
			
			if (Count == 199)
			{
				Database.insert(InsertLeads, false);
				
				for(Lead lead: InsertLeads)
					ListOfLeads.add(lead.clone(true,true));
				
				Count = -1;
				InsertLeads = new Lead[1];
			}
			
			Count++;
		}
		
		
		Database.insert(InsertLeads, false);
	   
		for(Lead lead: InsertLeads)
			ListOfLeads.add(lead.clone(true,true));	   
	   
	   
		//Create Contacts
		List<Contact> ListOfContacts = new List<Contact>();
		Contact[] InsertContacts = new Contact[200];
		Count = 0;
		
		for(Integer i=0; i<201;i++)
		{
			Contact MyCon = new Contact();
			MyCon.FirstName = 'TestFirstName' + String.valueof(i);
			MyCon.LastName = 'TestLastName' + String.valueof(i);
			MyCon.Email = 'testemail' + String.valueof(i) + '@test.com';
			MyCon.Active_Source_Code__c = 'TESTSOURCECODE001';
			
			InsertContacts[Count] = MyCon;
			
			if (Count == 199)
			{
				Database.insert(InsertContacts, false);
				
				for(Contact con: InsertContacts)
					ListOfContacts.add(con.clone(true,true));				
				
				Count = -1;
				InsertContacts = new Contact[1];
			}
			
			Count++;
		}
		
		
		Database.insert(InsertContacts, false);	
		
		for(Contact con: InsertContacts)
			ListOfContacts.add(con.clone(true,true));			
		
		
		PageReference pageRef = Page.CreateMarketingSourceList;
	    Test.setCurrentPageReference(pageRef);
	
	    // create an instance of the controller
	    CreateMarketingListPageController PageController = new CreateMarketingListPageController ();
	    
	    //Call methods/properties of the controller in all possible scenarios
	    //to get the best coverage.
	    
	    Test.StartTest();
	    
	    //Get Controller Name
	    String ControllerName = PageController.getName();
	    System.assertEquals('CreateMarketingListPageController', ControllerName);
	    
	    //Invoke Save() method before Source Code and Show Id are set. This will test the
	    //the outer try{} catch{} block
	    //PageController.Save();        
	   
	    //Get Marketing Source List before it is explicitly intialized
	    //this will test the instantiation in the getMarketingSourceList() getter method
	    PageController.getMarketingSourceList();
	    
	    //Invoke Save() method before Source Code and Show Id are set. This will test the
	    //first if() block in the method
	    PageController.Save();
	    
	    //Set Source Code
	    PageController.setSourceCode('TESTSOURCECODE001');
	    String SourceCode = PageController.getSourceCode();
	    System.assertEquals('TESTSOURCECODE001',SourceCode);  
	    
	    //Invoke Save() method after Source Code is set, but before Show Id is set. This will test the
	    //else if() block in the method which tests for null or blank Show Id
	    PageController.Save();              
	    
	    //Set Marketing Source List
	    Marketing_Source_List__c Msl = new Marketing_Source_List__c();
	    Msl.Show_Occurrence__c = ShowOcc.Id;
	    
	    PageController.setMarketingSourceList(Msl);
	    
	    //Get Marekting Source List
	    System.assertEquals(PageController.getMarketingSourceList(), Msl);
	    
	    //Get Show Id
	    String ShowId = PageController .getShowId();
	    System.assertEquals(ShowOcc.Id, ShowId);
	    
	    //Cannot test these private methods
	    //Integer LeadCount = PageController.AssociateLeads(SourceCode, ShowId);
	    //Integer ConCount = PageController.AssociateContacts(SourceCode, ShowId);
	    
	    //Invoke the save method
	    PageReference ReturnedPageRef = PageController.save();
	    PageReference NullPageRef = new ApexPages.StandardController(PageController.getMarketingSourceList()).view();
	    System.assert(NullPageRef.getUrl() == ReturnedPageRef.getUrl());
	    
	    Test.StopTest();
           
    }

}