@isTest
global class BatchableMelissaMockAccountSweep implements HttpCalloutMock {
   // global string accountId;
    global HTTPResponse respond(HTTPRequest req) {

        // Create a fake response
       // accountId='"'+accountId+'"';
        HttpResponse res = new HttpResponse();
        String response='{"Records":[{"AddressExtras":" ","AddressKey":"98121160411","AddressLine1":"2211 Alaskan Way","AddressLine2":" ","AddressTypeCode":"S","CarrierRoute":"C091","City":"Seattle","CityAbbreviation":"Seattle","CompanyName":" ","CountryCode":"US","CountryName":"United States of America","DeliveryIndicator":"B","DeliveryPointCheckDigit":"6","DeliveryPointCode":"11","EmailAddress":" ","MelissaAddressKey":"6249259384","MelissaAddressKeyBase":" ","NameFull":" ","PhoneNumber":" ","PostalCode":"98121-1604","RecordExtras":" ","RecordID":"0014000000dYyTJAA0","Reserved":" ","Results":"AS01","State":"WA","StateName":"Washington","UTC":"-08:00","UrbanizationName":" "}],"TotalRecords":"1","TransmissionReference":"ges test string","TransmissionResults":" ","Version":"5.1.5"}';
        system.debug('======='+response);
        res.setHeader('Content-Type', 'application/json');
        res.setBody(response);
        res.setHeader('Auth-Token', '3+yV8B+7iSTu7Oj4alK4/fJPY1a5VRhAre6jG5vx6kDTXMOENFWJqAIQpuYE8nOdLwDmQBdo='); 
        res.setStatusCode(200);         
       return res;
    
}
}