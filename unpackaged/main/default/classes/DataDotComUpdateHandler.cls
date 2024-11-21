// *****************************************************************************
// CLASS: DataDotComUpdateHandler
// *****************************************************************************
// Author: Vertiba / Andu Andrei, Marian Iovi(Modified)
// Description: Handler class for AccountAll trigger.
//
//              Whenever an Account is created/updated,
//              if it has at least three non-blank fields out of the following four
//              (Name, Website, Phone, City),
//              hit data.com and query for updated company info
//              and then update the Account with that data
// *****************************************************************************


// Handler class for the data.com update trigger
public class DataDotComUpdateHandler {

    /*public static Set<Id> gatedIds { get {
        if (gatedIds == null) gatedIds = new Set<Id>();
        return gatedIds;
    } set; }
    
    // Main entry point for handler class from trigger
    public static void runHandler(Boolean isAfter, Boolean isInsert, Boolean isUpdate,
                                  Map<Id, sObject> newMap, Map<Id, sObject> oldMap) {
        if (isAfter && (isInsert || isUpdate)) {
            List<Account> accountsToUpdate = accountsToUpdate(isUpdate, newMap, oldMap);
        	if (accountsToUpdate.size() > 0) updateAccounts(accountsToUpdate);
        }
    }
    
    // Filter a list of Accounts down to those that should be updated from data.com
    public static List<Account> accountsToUpdate(Boolean isUpdate,
                                                 Map<Id, sObject> newMap, Map<Id, sObject> oldMap) {
        List<Account> accountsToProcess = new List<Account>();
        
        for (Id accId : newMap.keySet()) {
            if (gatedIds.contains(accId)) continue;
            
            Account newAcc = (Account)newMap.get(accId);
                    
            if (newAcc.Source_Exhibitor_Upload__c != true) continue;
            
            if ((
                (String.isBlank(newAcc.Name) ? 0 : 1) +
                (String.isBlank(newAcc.Website) ? 0 : 1) +
                (String.isBlank(newAcc.Phone) ? 0 : 1) +
                (String.isBlank(newAcc.BillingCity) ? 0 : 1)
            ) < 3) continue;
            
            if (isUpdate) {
                Account oldAcc = (Account)oldMap.get(accId);
                if (oldAcc.Name == newAcc.Name && oldAcc.Website == newAcc.Website &&
                    oldAcc.Phone == newAcc.Phone && oldAcc.BillingCity == newAcc.BillingCity) continue;
            }
            
            accountsToProcess.add(newAcc);
        }
        
        return accountsToProcess;
    }*/
    
    // Update a list of Accounts from data.com
    public static void updateAccounts(List<Account> accounts, String s) {
        // Covert the Account data into wrapper classes, which are then further JSON-ified,
    	// since we can only pass primitive data types (not sObjects) to @future methods
        List<String> jsonAccounts = new List<String>();
        for (Account a : accounts) {
        	jsonAccounts.add(JSON.serialize(new AccountWrapper(a)));
        }
        updateAccounts(jsonAccounts, s);
    }

    //web callout that hits data.com and updates a list of Accounts
    //@future (callout=true)
    public static void updateAccounts(List<String> jsonAccounts, String sessionId) {
        // Create a list of fields to write to the JSON string.
        List<String> fieldslist = new List<String> {
			'AnnualRevenue', 
            'City', 
            'CompanyId', 
            'Country', 
            'Description', 
            'DunsNumber', 
            'Fax', 
            'Industry', 
            'IsInactive', 
            'NaicsCode', 
            'NaicsDesc', 
            'Name', 
            'NumberOfEmployees', 
            'Ownership', 
            'Phone', 
            'Sic', 
            'SicDesc', 
            'State', 
            'Street', 
            'TickerSymbol', 
            'TradeStyle', 
            'Website', 
            'YearStarted', 
            'Zip', 
            'Site'
        };
        
        // Create a JSON generator object
        JSONGenerator gen = JSON.createGenerator(true);
        
        // open the JSON generator
        gen.writeStartObject();
        gen.writeFieldName('entities');
        gen.writeStartArray();
        
		// Set of Account Ids to be requeried
        Set<Id> accountIds = new Set<Id>();

        // write content
        AccountWrapper aw;
        for (String ja : jsonAccounts) {
			gen.writeStartObject();
            aw = (AccountWrapper)JSON.deserialize(ja, AccountWrapper.class);
            accountIds.add(aw.id);
            
            gen.writeFieldName('attributes');
            gen.writeStartObject();
            gen.writeStringField('type', 'DatacloudCompany');
            gen.writeEndObject(); 
            gen.writeStringField('Name', aw.name);
            if (!String.isBlank(aw.city)) {
            	gen.writeStringField('City', aw.city);
            }
            if (!String.isBlank(aw.phone)) {
                gen.writeStringField('Phone', aw.phone);
            }
            if (!String.isBlank(aw.website)) {
                gen.writeStringField('Website', aw.website);         
            }

			gen.writeEndObject(); 
        }
        
        // close the JSON generator
        gen.writeEndArray();
        gen.writeObjectField('fields', fieldslist);
        gen.writeEndObject(); 
         
        // create a string from the JSON generator
        String jsonOrders = gen.getAsString();
        System.debug('***jsonOrders: '+ jsonOrders);
        // create an HTTPrequest object    
        HttpRequest req = new HttpRequest();
        
        // set up the HTTP request with a method, endpoint, header, and body
        req.setMethod('POST');
        req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() +
                        '/services/data/v38.0/match/DatacloudMatchEngine/DatacloudCompany/');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'OAuth ' + sessionId);
        req.setBody(jsonOrders);
        
        // create a new HTTP object
        Http http = new Http();
        
        // create a new HTTP response for receiving the remote response then use it to send the configured HTTPrequest
        HTTPResponse res = http.send(req);
        
        // Deserialize the JSON response
		System.debug('***res.getBody(): '+ res.getBody());
        List<DDCResponse> ddcResponseArray = (List<DDCResponse>)JSON.deserialize(res.getBody(), List<DDCResponse>.class);
		//DDCResponse ddcResponse = ddcResponseArray[0];
        
        // Do not proceed if there was an error
        //if (ddcResponse.errorCode != 0 || ddcResponse.errorMessage != null) return;
        
        // The list of entities obtained by deserializing the JSON data returned by the fulfillment service.
        //List<DDCRecord> ddcRecords = ddcResponse.matchRecords;
        
        // If there were no matches, return
        //if (ddcRecords.size() == 0) return;
        
        // Requery the Account records
       	List<Account> accounts = [
            SELECT
            	Id, Name, BillingCity, Phone, Website,
            	NumberOfEmployees, Sic, SicDesc, NaicsCode, NaicsDesc, YearStarted, DunsNumber, Tradestyle
            FROM Account
            WHERE Id IN :accountIds
        ];

		System.debug('**accounts: ' + accounts);

		for(Account acc: accounts) {
			acc.Exhibitor_onDataCom__c = false;
            acc.CleanStatus = 'NotFound';
		}

        // Parse list of returned entries from data.com and match them against existing Accounts
        List<Account> accountsToUpdate = new List<Account>();
		for(DDCResponse ddcResponse : ddcResponseArray){
			for (DDCRecord ddcRecord : ddcResponse.matchRecords) {
				DDCEntity ddc = ddcRecord.entity;
				if (!String.isBlank(ddc.Name) && ddc.Name != 'null') {
					Account foundAcc;
					for (Account a : accounts) {
                        integer matched = 0;
						if (a.Name == ddc.Name)
                            matched++;
                        if (a.Website == ddc.Website)
                            matched++;
                        if (a.Phone == ddc.Phone)
                            matched++;
                        if (a.BillingCity == ddc.City)
                            matched++;
                        if (matched >= 2)
						{
							foundAcc = a;
							break;
						}
					}
                
					if (foundAcc != null) {
						foundAcc.NumberOfEmployees = Integer.valueOf(ddc.NumberOfEmployees);
						foundAcc.Sic = String.valueOf(ddc.Sic);
						foundAcc.SicDesc = String.valueOf(ddc.SicDesc);
						foundAcc.Website = String.valueOf(ddc.Website);
						foundAcc.NaicsCode = String.valueOf(ddc.NaicsCode);
						foundAcc.NaicsDesc = String.valueOf(ddc.NaicsDesc);
						foundAcc.YearStarted = String.valueOf(ddc.YearStarted);
						foundAcc.DunsNumber = String.valueOf(ddc.DunsNumber);
						foundAcc.Tradestyle = String.valueOf(ddc.TradeStyle);
						foundAcc.BillingStreet = String.valueOf(ddc.Street);
						foundAcc.BillingCity = String.valueOf(ddc.City);
						foundAcc.BillingState = String.valueOf(ddc.State);
						foundAcc.BillingPostalCode = String.valueOf(ddc.Zip);
						foundAcc.BillingCountry = String.valueOf(ddc.Country);
                        foundAcc.CleanStatus = 'Matched';
                    }
				}
			}
		}

		// If any changes were made, update the Account records        
		if (accounts.size() > 0) {
            update accounts;
        }
    }
    
    
    
    // Wrapper class for Account
    public class AccountWrapper {
        public String id {set; get;}
        public String name {set; get;}
        public String city {set; get;}
        public String phone {set; get;}
        public String website {set; get;}
    
        public AccountWrapper(Account a) {
            this.id = a.Id;
            this.name = a.Name;
            this.city = a.BillingCity;
            this.phone = a.Phone;
            this.website = a.Website;
        }
    }
    
    // Wrapper class for a DDC response
    public class DDCResponse {
        public Integer errorCode {get; set;}
        public String errorMessage {get; set;}
        public List<DDCRecord> matchRecords {get; set;}
    }
    
    // Wrapper class for a DDC record
    public class DDCRecord {
        public DDCEntity entity {get; set;}
    }
    
    // Wrapper class for a DDC entity
    public class DDCEntity {
        public String City {get; set;}
		public String State {get; set;}
		public String Street {get; set;}
		public String Zip {get; set;}
		public String Country {get; set;}
        public String DunsNumber {get; set;}
        public String NaicsCode {get; set;}
        public String NaicsDesc {get; set;}
        public String Name {get; set;}
        public String NumberOfEmployees {get; set;}
        public String Phone {get; set;}
        public String Sic {get; set;}
        public String SicDesc {get; set;}
        public String TradeStyle {get; set;}
        public String Website {get; set;}
        public String YearStarted {get; set;}
    }
    
}