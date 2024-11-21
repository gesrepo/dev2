@isTest
global class BatchableDataComWebServiceCallOutMock implements HttpCalloutMock {
        
    global HTTPResponse respond(HTTPRequest req) {

  
        // Create a fake response
        HttpResponse res = new HttpResponse();
        String response='{"Records":[{"AddressExtras":" ","AddressKey":"75204102727","AddressLine1":"2707 Cole Ave Apt 127","AddressLine2":" ","AddressTypeCode":"S","CarrierRoute":"C051","City":"Dallas","CityAbbreviation":"Dallas","CompanyName":" ","CountryCode":"US","CountryName":"United States of America","DeliveryIndicator":"U","DeliveryPointCheckDigit":"3","DeliveryPointCode":"27","EmailAddress":" ","MelissaAddressKey":"5746822871","MelissaAddressKeyBase":"5702627178","NameFull":" ","PhoneNumber":" ","PostalCode":"75204-1027","RecordExtras":" ","RecordID":"a784B0000008VWxQAM","Reserved":" ","Results":"AC01,AC13,AS01","State":"TX","StateName":"Texas","UTC":"-06:00","UrbanizationName":" "}],"TotalRecords":"1","TransmissionReference":"ges test string","TransmissionResults":" ","Version":"5.1.5"}';
        res.setHeader('Content-Type', 'application/json;charset=UTF-8');
        res.setBody(response);
        res.setHeader('Auth-Token', '3+yV8B+7iSTu7Oj4alK4/fJPY1a5VRhAre6jG5vx6kDTXMOENFWJqAIQpuYE8nOdLwDmQBdo=');
        res.setStatusCode(200);         
       return res;
    
}
}