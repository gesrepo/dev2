/***********************************
Emea_StandBatchUpload
	CreateStandUpload(string userId, string token, string showId, Emea_StandItemDetails[] stands) 

Test Harness
	EndPoint: /services/apexrest/v1/Emea_StandUpload/createBoothUpload
	PayLoad: 

{"userId":"dan.pascua@ges.com","token":"","showId":"0064000000iDqpu"
 "stands": [
{"CompanyName": "test company","FirstName": "fir","LastName": "las","City": "Solihull","PostZip_Code": "B99 9JJ","Email":"dan.pascua@ges.com","State_County": "West Midlands"},
{"CompanyName": "test company","FirstName": "fir","LastName": "las","City": "Solihull","Address_1" : "55 Somewhere","PostZip_Code": "B99 9JJ","Email":"dan.pascua@ges.com","Country" : "UK","State_County": "West Midlands"}
  ]
}
Resources:
	http://shancarter.github.io/mr-data-converter/
***********************************/

@RestResource(urlMapping='/v1/Emea_StandBatchUpload/*')
global with sharing class Emea_StandBatchUpload {

    global class Emea_BoothAPIUpload_Response{
        public string status;
        public string message;
        
        public integer numberOfStands;
        public integer numberOfInvalidItems;
        public integer numberOfItemsLoaded;
        
        //public Booth_API_Upload__c batchInfo;
        public List<Emea_StandItemDetails> invalidItems;    
        
        
        public Emea_BoothAPIUpload_Response(){
            message = '';
            status = '';
    	}
	}
    
    global class BatchUpload{
        public string userId;
        public string token;
        public string showId;
        Emea_StandItemDetails[] stands;
    }
    global class Emea_StandItemDetails  {
			public string CompanyName = '';
			public string FirstName = '';
			public string LastName = '';
			public string Email = '';
			public string Address_1 = '';
			public string Address_2 = '';
			public string Address_3 = '';
			//public string City = '';
			public string State_County = '';
			public string PostZip_Code = '';
			public string Country = '';
			public string Town = '';
			public string Fax = '';
			public string Stand_Number = '';
			public string Operational = '';
			public string Stand_Type = '';
			public decimal Booth_Size = 0;
			public string Booth_Width = '';
			public string Booth_Length = '';
			public string Phone_Number = '';
			//public string CurrencyIsoCode = '';
			public decimal Open_Sides = 0;
			public string WWW = '';
        	//public string Name= '';
            public string Errors = '';
        	public string Nameboard_Name = '';
        	public string Mobile = '';
        	public decimal Booth_Height = 0;
        	public string Vat_Number = '';
        	public string Service_Zone = '';
            }
    
    @HttpPost
    global static Emea_BoothAPIUpload_Response createBoothUpload(string userId, string token, string showId, List<Emea_StandItemDetails> stands){

        integer standCount;
        integer stagingItemCount;
        
        standCount = 0;
        stagingItemCount= 0;
        
        RestResponse res = RestContext.response;
        Emea_BoothAPIUpload_Response response = new Emea_BoothAPIUpload_Response();
        
        Booth_Upload_API_User__c[] users = [SELECT Id, User__c, User_Email__c, User_Password__c
											, Active__c, Organiser__r.id 
                                         FROM Booth_Upload_API_User__c WHERE User_Email__c = :userId];
        
        if(users.size() == 0 || users.get(0).User_Password__c != token) {
            system.debug('Users: ' + users.size());
            system.debug('User: ' + users.get(0));
             response.status = 'Error';
             response.message = 'Invalid user!';
            if (res != null)
            {
            	res.StatusCode = 401;		
            }
        }
        else {
            // Booth API Upload - header
            Booth_Upload_API_User__c user = users[0];
            Booth_API_Upload__c batchApi = new Booth_API_Upload__c();
            batchApi.API_User__c = user.Id;
            batchApi.Organiser__c = user.Organiser__c;
            batchApi.Opportunity__c = showId;
            
            // initialise counters
            batchApi.Batch_Count__c = 0;
            batchApi.Batch_Error_Count__c = 0;
            
            try{
                insert batchApi;		// save batch header

                //Booth Upload - header
                Booth_Upload__c boothUpload = new Booth_Upload__c();
                boothUpload.Opportunity__c = batchApi.Opportunity__c;
                boothUpload.Organiser__c = user.Organiser__c;
                boothUpload.Status__c = 'Incomplete';
                
                try{
                    insert boothUpload;		// save new Booth Upload
                    
                    batchApi.Process_Status__c = 'Loading';
                    update batchApi;		// update batch header with Booth Upload id

                    List<Booth_Upload_API_Staging__c> preStagingItems = new List<Booth_Upload_API_Staging__c>();
                    List<Booth_Upload_API_Staging__c> preStagingItemsSave = new List<Booth_Upload_API_Staging__c>();
                    integer preStagingCount = 0;
                    preStagingCount = 0;

                    for (Emea_StandItemDetails s : stands){
                        
                        Booth_Upload_API_Staging__c standInfo = new Booth_Upload_API_Staging__c();
                        standInfo.Address_1__c = s.Address_1;
                        standInfo.Address_2__c = s.Address_2;
                        standInfo.Address_3__c = s.Address_3;
                        standInfo.Booth_Length__c  = s.Booth_Length;
                        standInfo.Booth_Size__c = s.Booth_Size;
                        standInfo.Booth_Width__c = s.Booth_Width;
                        //standInfo.City__c = s.City;
                        standInfo.CompanyName__c  = s.CompanyName;
                        standInfo.Country__c = s.Country;
                        standInfo.First_Name__c = s.FirstName;
                        standInfo.Last_Name__c  = s.LastName;
                        standInfo.Post_Zip_Code__c = s.PostZip_Code;
                        standInfo.Booth_Upload_API__c = batchApi.Id;
                        standInfo.Agency_Email__c = s.Email;
                        standInfo.State_County__c = s.State_County;
                        standInfo.Town__c = s.Town;
                        standInfo.Fax__c	 = s.Fax;
                        standInfo.Stand_Number__c = s.Stand_Number;
                        standInfo.Operational__c = s.Operational;
                        standInfo.Stand_Type__c = s.Stand_Type;
                        standInfo.No_Open_Sides__c = s.Open_Sides;
                        standInfo.Agency_Phone__c = s.Phone_Number;
                        
                        standInfo.Nameboard_Name__c = s.Nameboard_Name;
						standInfo.Mobile__c = s.Mobile;
                        standInfo.Booth_Height__c = s.Booth_Height;
                        standInfo.Vat_Number__c = s.Vat_Number;
                        standInfo.Service_Zone__c = s.Service_Zone;
                        standInfo.WWW__c = s.WWW;

                        preStagingItems.add(standInfo);
                        standCount++;
                        
                        if(stagingItemCount++ == 100){		// bulk insert
                            processPreStagingItems(batchApi, boothUpload, preStagingItems);
                            preStagingItems.clear();
                        }
                    }
                    
                    if(stagingItemCount > 0) {
                        processPreStagingItems(batchApi, boothUpload, preStagingItems);
                        preStagingItems.clear();
                    }
                    
                    batchApi.Process_Status__c = 'Loaded';
                    batchApi.Booth_Upload__c = boothUpload.Id;
                    
                    update batchApi;			// update batch status
                    
                    if(stagingItemCount == 0){
                        Database.delete(boothUpload);	// no booth staging item saves, remove booth_upload
                    }
                    
                    //response.batchInfo = batchApi;
                    response.numberOfStands = standCount;
                    response.numberOfInvalidItems = (integer)(batchApi.Batch_Error_Count__c);
                    response.numberOfItemsLoaded = standCount - (integer)(batchApi.Batch_Error_Count__c);
                    
                    List<Booth_Upload_API_Invalid__c> invalidItems = [
                        SELECT 
                        	Address_1__c,
                            Address_2__c,
                            Address_3__c,
                            Booth_Height__c,
                            Booth_Length__c,
                            Booth_Size__c,
                            Booth_Width__c,
                            City__c,
                            Company_Name__c,
                            Country__c,
                            Email__c,
                            Errors__c,
                            Fax__c,
                            First_Name__c,
                            Last_Name__c,
                            Mobile__c,
                            Nameboard_Name__c,
                            Open_Sides__c,
                            No_Open_Sides__c,
                            Operational__c,
                            Agency_Phone__c,
                            Post_Zip_Code__c,
                            Service_Zone__c,
                            Stand_Number__c,
                            Stand_Type__c,
                            Vat_Number__c,
                            WWW__c,
                        	State_County__c
                        FROM 
                        	Booth_Upload_API_Invalid__c 
                        WHERE 
                        	Booth_Upload_API__c = :batchApi.Id
                    ];
                    
                    List<Emea_StandItemDetails> invalidItemsResponse = new List<Emea_StandItemDetails>();
                    for (Booth_Upload_API_Invalid__c i : invalidItems){
                        
                        Emea_StandItemDetails is = new Emea_StandItemDetails();
                        
                        is.Address_1 = i.Address_1__c;
                        is.Address_2 = i.Address_2__c;
                        is.Address_3 = i.Address_3__c;
                        is.Booth_Height = i.Booth_Height__c;
                        is.Booth_Length = i.Booth_Length__c;
                        is.Booth_Size = i.Booth_Size__c;
                        is.Booth_Width = i.Booth_Width__c;
                        is.CompanyName = i.Company_Name__c;
                        is.Country = i.Country__c;
                        is.Email = i.Email__c;
                        is.Errors = i.Errors__c;
                        is.Fax = i.Fax__c;
                        is.FirstName = i.First_Name__c;
                        is.LastName = i.Last_Name__c;
                        is.Mobile = i.Mobile__c;
                        is.Nameboard_Name = i.Nameboard_Name__c;
                        is.Open_Sides = i.No_Open_Sides__c;
                        is.Operational = i.Operational__c;
                        is.Phone_Number = i.Agency_Phone__c;
                        is.PostZip_Code = i.Post_Zip_Code__c;
                        is.Service_Zone = i.Service_Zone__c;
                        is.Stand_Number = i.Stand_Number__c;
                        is.Stand_Type = i.Stand_Type__c;
                        is.Vat_Number = i.Vat_Number__c;
                        is.WWW = i.WWW__c;          
                        is.Town = i.City__c;
                        is.State_County = i.State_County__c;
                        
                        invalidItemsResponse.add(is);
                    }
                    
                    response.invalidItems = invalidItemsResponse; //Emea_StandItemDetails_DTO(invalidItems);
                    
                } catch (DMLException e) {
                    response.status = 'Batch items could not be inserted.';
                    response.message = e.getMessage();
                    res.StatusCode = 400;
                }
                
            } catch (DMLException e) {
                response.status = 'Batch header could not be inserted.';
                response.message = e.getMessage();
                if (res != null)
                {
                	res.StatusCode = 400;
                }
            }
        }
        return response;
    }

    global static void processPreStagingItems(Booth_API_Upload__c batchApi
                                              , Booth_Upload__c boothUpload
                                              , List<Booth_Upload_API_Staging__c> preStagingItems){
        
        List<Booth_Upload_API_Invalid__c> invalidItems = new List<Booth_Upload_API_Invalid__c>();
        List<Booth_Staging__c> boothStagingItems = new List<Booth_Staging__c>();
        List<Booth_Upload_API_Staging__c> preStagingUpdateItems = new List<Booth_Upload_API_Staging__c>();
        
        List<Database.Saveresult> insertResults = Database.insert(preStagingItems, false);
                                                  
        for (Integer i = 0; i < insertResults.Size() ; i++) {
            batchApi.Batch_Count__c++;
            Booth_Upload_API_Staging__c si = preStagingItems[i];
            
            if(insertResults[i].isSuccess()) {
                // Create Booth Staging item
                Booth_Staging__c staging = new Booth_Staging__c();
                
                staging.Booth_Upload__c = boothUpload.Id;
                
                staging.Address_1__c = si.Address_1__c;
                staging.Address_2__c = si.Address_2__c; 
                staging.Address_3__c = si.Address_3__c;
                staging.City__c = si.Town__c;
                staging.State_County__c = si.State_County__c;
                staging.Post_Zip_Code__c = si.Post_Zip_Code__c;
                staging.Country__c = si.Country__c;
                staging.Booth_Length__c = si.Booth_Length__c;
                staging.Booth_Size__c = si.Booth_Size__c;
                staging.Booth_Width__c = si.Booth_Width__c;
                
                staging.Email__c = si.Agency_Email__c;
                staging.First_Name__c = si.First_Name__c;
                staging.Last_Name__c = si.Last_Name__c;
                staging.Company__c = si.CompanyName__c;
                staging.Phone_Number__c = si.Agency_Phone__c;
                staging.Fax__c	 = si.Fax__c;
                staging.Stand_Number__c = si.Stand_Number__c;
                staging.Operations_Zone__c = si.Operational__c;
                staging.Stand_Type__c = si.Stand_Type__c;
                staging.Open_Sides__c =  si.No_Open_Sides__c;
                staging.Website__c = si.WWW__c;
                
                staging.Nameboard_Name__c = si.Nameboard_Name__c;
				staging.Mobile__c = si.Mobile__c;
                staging.Booth_Height__c = si.Booth_Height__c;
                staging.Vat_Number__c = si.Vat_Number__c;
                staging.Service_Zone__c = si.Service_Zone__c;
                
                boothStagingItems.add(staging);
                preStagingUpdateItems.add(si);
               
                
            }
            else {
                // save invalid items
                Booth_Upload_API_Invalid__c	invalid_boothItem = new Booth_Upload_API_Invalid__c();
                
                invalid_boothItem.Booth_Upload_API__c = batchApi.Id;
 					
                invalid_boothItem.Company_Name__c = si.CompanyName__c;
                invalid_boothItem.Address_1__c = si.Address_1__c;
                invalid_boothItem.Address_2__c = si.Address_2__c; 
                invalid_boothItem.Address_3__c = si.Address_3__c;
                invalid_boothItem.City__c = si.Town__c;
                invalid_boothItem.Post_Zip_Code__c = si.Post_Zip_Code__c;
                invalid_boothItem.Country__c = si.Country__c;
                invalid_boothItem.Booth_Length__c = si.Booth_Length__c;
                invalid_boothItem.Booth_Size__c = si.Booth_Size__c;
                invalid_boothItem.Booth_Width__c = si.Booth_Width__c;
                invalid_boothItem.First_Name__c = si.First_Name__c;
                invalid_boothItem.Last_Name__c = si.Last_Name__c;
                invalid_boothItem.Email__c = si.Agency_Email__c;
                invalid_boothItem.Fax__c	 = si.Fax__c;
                invalid_boothItem.Stand_Number__c = si.Stand_Number__c;
                invalid_boothItem.Operational__c = si.Operational__c;
                invalid_boothItem.Stand_Type__c = si.Stand_Type__c;
                invalid_boothItem.No_Open_Sides__c = si.No_Open_Sides__c;
                invalid_boothItem.WWW__c= si.WWW__c;
                
                invalid_boothItem.Nameboard_Name__c = si.Nameboard_Name__c;
				invalid_boothItem.Mobile__c = si.Mobile__c;
                invalid_boothItem.Booth_Height__c = si.Booth_Height__c;
                invalid_boothItem.Vat_Number__c = si.Vat_Number__c;
                invalid_boothItem.Service_Zone__c = si.Service_Zone__c;
                invalid_boothItem.Agency_Phone__c = si.Agency_Phone__c;
                invalid_boothItem.State_County__c = si.State_County__c;

                for(Database.Error err : insertResults[i].getErrors()) {
                    if (String.isBlank(invalid_boothItem.Errors__c))
                    {
                        invalid_boothItem.Errors__c = err.getMessage();
                    }
                    else
                    {
                		invalid_boothItem.Errors__c = invalid_boothItem.Errors__c + '\n' + err.getMessage();
                    }
                }                

                invalidItems.add(invalid_boothItem);
                batchApi.Batch_Error_Count__c++;
            }
		}

			List<Database.Saveresult> insertInvalidResults = Database.insert(invalidItems,false);
            batchApi.Batch_Errors__c = insertInvalidResults.Size().format();
        
			for (Integer x = 0; x < insertInvalidResults.Size() ; x++) {
				for(Database.Error err : insertInvalidResults[x].getErrors()) {
                    if (String.isBlank(batchApi.Batch_Errors__c))
                    {
                        batchApi.Batch_Errors__c = err.getMessage();
                    }
                    else
                    {
						batchApi.Batch_Errors__c = batchApi.Batch_Errors__c + '\n' + err.getMessage();
                    }
				}                             
			}

		Database.insert(boothStagingItems,false);

		preStagingUpdateItems.clear();       

		update batchApi;        



    }
    
    // @HttpGet
    // global static Emea_BoothAPIUpload_Response getStandUpload(){

    //     Emea_BoothAPIUpload_Response response = new Emea_BoothAPIUpload_Response();
    //     RestResponse res = RestContext.response;
    //     RestRequest req = RestContext.request;
        
    //     string boothId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
    //     /*
    //     response.batchInfo = [SELECT Id, Organiser__c, Show__c, Process_Status__c ,
    //                                  ( SELECT Id, Company__c, First_Name__c, Last_Name__c, Address_1__c, Address_2__c
    //                                  , Address_3__c, City__c, Post_Zip_Code__c, Country__c, Has_Error__c, Errors__c
    //                                        FROM Booth_Upload__r
    //                                  )
    //                                  FROM Booth_API_Upload__c WHERE Id = :boothId];
    //     */
    //     if(response.batchInfo != null) {
    //         response.status = 'Success';
    //         response.message = '';
    //     }
    //     else {
    //         response.status = 'Error';
    //         response.message = 'No Stands have been loaded.';
    //         res.StatusCode = 404;
    //     }
    //     return response;
    // }
    
    /*
    global static List<Emea_StandItemDetails> Emea_StandItemDetails_DTO(List<Booth_Upload_API_Invalid__c> items){
        List<Emea_StandItemDetails> returnList = new List<Emea_StandItemDetails>();
        for (Booth_Upload_API_Invalid__c i : items){
            
            Emea_StandItemDetails err = new Emea_StandItemDetails();
            err.FirstName = i.First_Name__c;
            err.LastName = i.Last_Name__c;
            err.Email = i.Email__c;
            err.Address_1 = i.Address_1__c;
            err.Address_2 = i.Address_2__c;
            err.Address_3 = i.Address_3__c;
            //err.City = i.City__c;
            err.PostZip_Code =i.Post_Zip_Code__c;
            err.Country = i.Country__c;
            err.Booth_Size = i.Booth_Size__c;
            err.Booth_Width =i.Booth_Width__c;
            err.Booth_Length = i.Booth_Length__c;
            //err.Phone_Number =
            //err.Booth_id =
            //err.Booth_Upload =
            //err.CurrencyIsoCode =
            //err.Open_Sides =
            //err.Fax;
            //err.WWW;
            err.Errors = i.Errors__c;
            
            returnList.add(err);
        }
        return returnList;
    }
*/

 
}