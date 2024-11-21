@isTest
public class SQR_wwwViadComV1_Mock implements WebServiceMock {
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
            if(request instanceOf  SQR_wwwViadComV1.ResubmitOrder_element){
                response.put('response_x',new SQR_wwwViadComV1.ResubmitOrderResponse_element());
            }
            else if(request instanceOf  SQR_wwwViadComV1.ReleaseHold_element){
                response.put('response_x',new SQR_wwwViadComV1.ReleaseHoldResponse_element());
            }
            else if(request instanceOf  SQR_wwwViadComV1.ApplyHold_element){
                response.put('response_x',new SQR_wwwViadComV1.ApplyHoldResponse_element());
            }
            else if(request instanceOf  SQR_wwwViadComV1.GetProjectOrders_element){
                response.put('response_x',new SQR_wwwViadComV1.GetProjectOrdersResponse_element());
            }
            else if(request instanceOf  SQR_wwwViadComV1.GetHeldShowOrders_element){
                response.put('response_x',new SQR_wwwViadComV1.GetHeldShowOrdersResponse_element());
            }
            else if(request instanceOf  SQR_wwwViadComV1.GetOrderByOrderHeaderId_element){
                response.put('response_x',new SQR_wwwViadComV1.GetOrderByOrderHeaderIdResponse_element());
            }
            else if(request instanceOf  SQR_wwwViadComV1.GetHeldProjectOrders_element){
                response.put('response_x',new SQR_wwwViadComV1.GetHeldProjectOrdersResponse_element());
            }
            else if(request instanceOf  SQR_wwwViadComV1.GetHeldBoothOrders_element){
                response.put('response_x',new SQR_wwwViadComV1.GetHeldBoothOrdersResponse_element());
            }
            else if(request instanceOf  SQR_wwwViadComV1.SubmitCreditCardInformation_element){
                response.put('response_x',new SQR_wwwViadComV1.SubmitCreditCardInformationResponse_element());
            }
            else if(request instanceOf  SQR_wwwViadComV1.GetShowOrders_element){
                response.put('response_x',new SQR_wwwViadComV1.GetShowOrdersResponse_element());
            }
            else if(request instanceOf  SQR_wwwViadComV1.SubmitOrder_element){
                response.put('response_x',new SQR_wwwViadComV1.SubmitOrderResponse_element());
            }
            else if(request instanceOf  SQR_wwwViadComV1.CancelOrder_element){
                response.put('response_x',new SQR_wwwViadComV1.CancelOrderResponse_element());
            }
            else if(request instanceOf  SQR_wwwViadComV1.GetOrderAndSqrCounts_element){
                response.put('response_x',new SQR_wwwViadComV1.GetOrderAndSqrCountsResponse_element());
            }
            else if(request instanceOf  SQR_wwwViadComV1.GetShowCustomerOrders_element){
                response.put('response_x',new SQR_wwwViadComV1.GetShowCustomerOrdersResponse_element());
            }
            else if(request instanceOf  SQR_wwwViadComV1.GetBoothOrders_element){
                response.put('response_x',new SQR_wwwViadComV1.GetBoothOrdersResponse_element());
            }
            else if(request instanceOf  SQR_wwwViadComV1.GetOrderPaymentInformation_element){
                response.put('response_x',new SQR_wwwViadComV1.GetOrderPaymentInformationResponse_element());
            }
            else if(request instanceOf  SQR_wwwViadComV1.GetHeldProjectOrdersByStatus_element){
                response.put('response_x',new SQR_wwwViadComV1.GetHeldProjectOrdersByStatusResponse_element());
            }
            else if(request instanceOf  SQR_wwwViadComV1.GetHeldShowCustomerOrders_element){
                response.put('response_x',new SQR_wwwViadComV1.GetHeldShowCustomerOrdersResponse_element());
            }
        }
}