@isTest
global class BatchableMelissaCoreExhibitorCallOutMock implements HttpCalloutMock {
        
    
    global string coreExihibitorId;
    global HTTPResponse respond(HTTPRequest req) {

        coreExihibitorId='"'+coreExihibitorId+'"';
        // Create a fake response
        HttpResponse res = new HttpResponse();
        String response='{"Records":[{"AddressExtras":" ","AddressKey":"55044000000","AddressLine1":"29 West 64th St","AddressLine2":"Apt 5B","AddressTypeCode":"S","CarrierRoute":" ","City":"Lakeville","CityAbbreviation":"Lakeville","CompanyName":" ","CountryCode":"US","CountryName":"United States of America","DeliveryIndicator":"U","DeliveryPointCheckDigit":" ","DeliveryPointCode":" ","EmailAddress":" ","MelissaAddressKey":" ","MelissaAddressKeyBase":" ","NameFull":" ","PhoneNumber":" ","PostalCode":"55044","RecordExtras":" ","RecordID":'+coreExihibitorId+',"Reserved":" ","Results":"AE02","State":"MN","StateName":"Minnesota","UTC":"-06:00","UrbanizationName":" "}],"TotalRecords":"1","TransmissionReference":"ges test string","TransmissionResults":" ","Version":"5.1.5"}';
        res.setHeader('Content-Type', 'application/json');
        res.setBody(response);
        //res.setHeader('Auth-Token', '3+yV8B+7iSTu7Oj4alK4/fJPY1a5VRhAre6jG5vx6kDTXMOENFWJqAIQpuYE8nOdLwDmQBdo='); 
        res.setStatusCode(200);         
       return res;
    
}
}