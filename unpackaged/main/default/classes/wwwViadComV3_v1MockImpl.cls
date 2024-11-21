@isTest
public class wwwViadComV3_v1MockImpl implements WebServiceMock {
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
       
        System.debug(LoggingLevel.INFO, 'wwwViadComV3_v1MockImpl.doInvoke() - ' +
            '\n request: ' + request +
            '\n response: ' + response +
            '\n endpoint: ' + endpoint +
            '\n soapAction: ' + soapAction +
            '\n requestName: ' + requestName +
            '\n responseNS: ' + responseNS +
            '\n responseName: ' + responseName +
            '\n responseType: ' + responseType);

        if(request instanceOf wwwViadComV3_v1.ProcessShowOrgOrder_element) {
            response.put( 'response_x', new wwwViadComV3_v1.ProcessShowOrgOrderResponse_element());
        }
        else if(request instanceOf wwwViadComV3_v1.ProcessShowOrgOrderBatch_element) {
            response.put( 'response_x', new wwwViadComV3_v1.ProcessShowOrgOrderBatchResponse_element());
        }
      
        else if(request instanceOf wwwViadComV3_v1.ListShowElectricalOrdersAsXML_element) {
            response.put( 'response_x', new wwwViadComV3_v1.ListShowElectricalOrdersAsXMLResponse_element());
        }
         
         else if(request instanceOf wwwViadComV3_v1.GetPaymentRestrictions_element) {
            response.put( 'response_x', new wwwViadComV3_v1.GetPaymentRestrictionsResponse_element());
        } 
                
         else if(request instanceOf wwwViadComV3_v1.GetOrderByOrderHeaderId_element) {
            response.put( 'response_x', new wwwViadComV3_v1.GetOrderByOrderHeaderIdResponse_element());
        } 
                
          else if(request instanceOf wwwViadComV3_v1.GetShowCustomerOrders_element) {
            response.put( 'response_x', new wwwViadComV3_v1.GetShowCustomerOrdersResponse_element());
        }      
          else if(request instanceOf wwwViadComV3_v1.GetHeldShowCustomerOrders_element) {
            response.put( 'response_x', new wwwViadComV3_v1.GetHeldShowCustomerOrdersResponse_element());
        } 
          else if(request instanceOf wwwViadComV3_v1.GetOrderPaymentInformation_element) {
            response.put( 'response_x', new wwwViadComV3_v1.GetOrderPaymentInformationResponse_element());
        } 
           else if(request instanceOf wwwViadComV3_v1.GetHeldProjectOrdersByStatus_element) {
            response.put( 'response_x', new wwwViadComV3_v1.GetHeldProjectOrdersByStatusResponse_element());
        } 
           else if(request instanceOf wwwViadComV3_v1.ApplyHold_element) {
            response.put( 'response_x', new wwwViadComV3_v1.ApplyHoldResponse_element());
        } 
            else if(request instanceOf wwwViadComV3_v1.GetProjectOrders_element) {
            response.put( 'response_x', new wwwViadComV3_v1.GetProjectOrdersResponse_element());
        } 
             else if(request instanceOf wwwViadComV3_v1.ReleaseHold_element) {
            response.put( 'response_x', new wwwViadComV3_v1.ReleaseHoldResponse_element());
        } 
             else if(request instanceOf wwwViadComV3_v1.GetHeldShowOrders_element) {
            response.put( 'response_x', new wwwViadComV3_v1.GetHeldShowOrdersResponse_element());
        } 
            else if(request instanceOf wwwViadComV3_v1.GetHeldProjectOrders_element) {
            response.put( 'response_x', new wwwViadComV3_v1.GetHeldProjectOrdersResponse_element());
        }
            else if(request instanceOf wwwViadComV3_v1.GetAddToOrderChoices_element) {
            response.put( 'response_x', new wwwViadComV3_v1.GetAddToOrderChoicesResponse_element());
        } 
            else if(request instanceOf wwwViadComV3_v1.GetShowOrders_element) {
            response.put( 'response_x', new wwwViadComV3_v1.GetShowOrdersResponse_element());
        } 
             else if(request instanceOf wwwViadComV3_v1.CancelOrder_element) {
            response.put( 'response_x', new wwwViadComV3_v1.CancelOrderResponse_element());
        } 
           else if(request instanceOf wwwViadComV3_v1.GetOrderAndSqrCounts_element) {
            response.put( 'response_x', new wwwViadComV3_v1.GetOrderAndSqrCountsResponse_element());
        } 
           
  }
}