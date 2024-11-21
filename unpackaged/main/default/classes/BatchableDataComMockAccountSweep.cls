@isTest
global class BatchableDataComMockAccountSweep implements HttpCalloutMock {
    global string accountId;
    global HTTPResponse respond(HTTPRequest req) {

  
        // Create a fake response
        accountId='"'+accountId+'"';
        HttpResponse res = new HttpResponse();
        String response='{"Records":[{"AddressExtras":" ","AddressKey":"01730140208","AddressLine1":"8 Crosby Dr","AddressLine2":" ","AddressTypeCode":"S","CarrierRoute":"C012","City":"Bedford","CityAbbreviation":"Bedford","CompanyName":" ","CountryCode":"US","CountryName":"United States of America","DeliveryIndicator":"B","DeliveryPointCheckDigit":"4","DeliveryPointCode":"08","EmailAddress":" ","MelissaAddressKey":"4316181413","MelissaAddressKeyBase":" ","NameFull":" ","PhoneNumber":" ","PostalCode":"01730-1402","RecordExtras":" ","RecordID":'+accountId+',"Reserved":" ","Results":"AC08,AS01","State":"MA","StateName":"Massachusetts","UTC":"-05:00","UrbanizationName":" "}],"TotalRecords":"1","TransmissionReference":"ges test string","TransmissionResults":" ","Version":"5.1.5"}';
        system.debug('======='+response);
        res.setHeader('Content-Type', 'application/json');
        res.setBody(response);
        res.setHeader('Auth-Token', '3+yV8B+7iSTu7Oj4alK4/fJPY1a5VRhAre6jG5vx6kDTXMOENFWJqAIQpuYE8nOdLwDmQBdo='); 
        res.setStatusCode(200);         
       return res;
    
}
}