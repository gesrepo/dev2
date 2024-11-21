@isTest
public class wwwViadComV1Vaccp_Mock implements WebServiceMock{
     public void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType) {
       
        System.debug(LoggingLevel.INFO, 'CORE_SECURITY_IMPLMockImpl.doInvoke() - ' +
            '\n request: ' + request +
            '\n response: ' + response +
            '\n endpoint: ' + endpoint +
            '\n soapAction: ' + soapAction +
            '\n requestName: ' + requestName +
            '\n responseNS: ' + responseNS +
            '\n responseName: ' + responseName +
            '\n responseType: ' + responseType);
    
    
      		if(request instanceOf ACCC1_wwwViadComV1.UpdatePaymentCollection_element) {
           		 response.put( 'response_x', new ACCC1_wwwViadComV1.UpdatePaymentCollectionResponse_element());
       		 }
    		 if(request instanceOf ACCC1_wwwViadComV1.RequestPaymentCollection_element) {
            	response.put( 'response_x', new ACCC1_wwwViadComV1.RequestPaymentCollectionResponse_element());
      	    }
             if(request instanceOf ACCC1_wwwViadComV1.GetPaymentCollection_element) {
           		 response.put( 'response_x', new ACCC1_wwwViadComV1.GetPaymentCollectionResponse_element());
      	  }
            if(request instanceOf ACCC1_wwwViadComV1.RequestPaymentCollectionMinimal_element) {
           		 response.put( 'response_x', new ACCC1_wwwViadComV1.RequestPaymentCollectionMinimalResponse_element());
      	  }
               
     }
}