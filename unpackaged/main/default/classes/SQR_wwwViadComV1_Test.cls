@isTest
public class SQR_wwwViadComV1_Test {
    public static testMethod void testMethods(){
        SQR_wwwViadComV1.ResubmitOrder_element  ResubmitOrder=new  SQR_wwwViadComV1.ResubmitOrder_element();
        SQR_wwwViadComV1.ResubmitOrderResponse_element   ResubmitOrderResponse=new  SQR_wwwViadComV1.ResubmitOrderResponse_element();
        SQR_wwwViadComV1.ReleaseHold_element   ReleaseHold=new  SQR_wwwViadComV1.ReleaseHold_element();
        SQR_wwwViadComV1.ReleaseHoldResponse_element    ReleaseHoldResponse=new  SQR_wwwViadComV1.ReleaseHoldResponse_element();
        SQR_wwwViadComV1.ApplyHold_element   ApplyHold=new  SQR_wwwViadComV1.ApplyHold_element();
        SQR_wwwViadComV1.ApplyHoldResponse_element    ApplyHoldResponse=new  SQR_wwwViadComV1.ApplyHoldResponse_element();
        SQR_wwwViadComV1.GetProjectOrders_element   GetProjectOrders=new  SQR_wwwViadComV1.GetProjectOrders_element();
        SQR_wwwViadComV1.GetProjectOrdersResponse_element    GetProjectOrdersResponse=new  SQR_wwwViadComV1.GetProjectOrdersResponse_element();
        SQR_wwwViadComV1.GetHeldShowOrders_element   GetHeldShowOrders=new  SQR_wwwViadComV1.GetHeldShowOrders_element ();
        SQR_wwwViadComV1.GetHeldShowOrdersResponse_element   GetHeldShowOrdersResponse=new  SQR_wwwViadComV1.GetHeldShowOrdersResponse_element();
        SQR_wwwViadComV1.GetOrderByOrderHeaderId_element   GetOrderByOrderHeaderId=new  SQR_wwwViadComV1.GetOrderByOrderHeaderId_element();
        SQR_wwwViadComV1.GetOrderByOrderHeaderIdResponse_element    GetOrderByOrderHeaderIdResponse=new  SQR_wwwViadComV1.GetOrderByOrderHeaderIdResponse_element();
        SQR_wwwViadComV1.GetHeldProjectOrders_element   GetHeldProjectOrders=new  SQR_wwwViadComV1.GetHeldProjectOrders_element();
        SQR_wwwViadComV1.GetHeldProjectOrdersResponse_element    GetHeldProjectOrdersResponse=new  SQR_wwwViadComV1.GetHeldProjectOrdersResponse_element();
        SQR_wwwViadComV1.GetHeldBoothOrders_element    GetHeldBoothOrders=new  SQR_wwwViadComV1.GetHeldBoothOrders_element ();
        SQR_wwwViadComV1.GetHeldBoothOrdersResponse_element    GetHeldBoothOrdersResponse=new  SQR_wwwViadComV1.GetHeldBoothOrdersResponse_element();
        SQR_wwwViadComV1.SubmitCreditCardInformation_element   SubmitCreditCardInformation=new  SQR_wwwViadComV1.SubmitCreditCardInformation_element();
        SQR_wwwViadComV1.SubmitCreditCardInformationResponse_element    SubmitCreditCardInformationResponse=new  SQR_wwwViadComV1.SubmitCreditCardInformationResponse_element();
        SQR_wwwViadComV1.GetShowOrders_element    GetShowOrders=new  SQR_wwwViadComV1.GetShowOrders_element();
        SQR_wwwViadComV1.GetShowOrdersResponse_element     GetShowOrdersResponse=new  SQR_wwwViadComV1.GetShowOrdersResponse_element();
        SQR_wwwViadComV1.SubmitOrder_element    SubmitOrder=new  SQR_wwwViadComV1.SubmitOrder_element();
        SQR_wwwViadComV1.SubmitOrderResponse_element     SubmitOrderResponse=new  SQR_wwwViadComV1.SubmitOrderResponse_element();
        SQR_wwwViadComV1.CancelOrder_element    CancelOrder_element=new  SQR_wwwViadComV1.CancelOrder_element();
        SQR_wwwViadComV1.CancelOrderResponse_element     CancelOrderResponse=new  SQR_wwwViadComV1.CancelOrderResponse_element();
        SQR_wwwViadComV1.GetOrderAndSqrCounts_element     GetOrderAndSqrCounts=new  SQR_wwwViadComV1.GetOrderAndSqrCounts_element();
        SQR_wwwViadComV1.GetOrderAndSqrCountsResponse_element      GetOrderAndSqrCountsResponse=new  SQR_wwwViadComV1.GetOrderAndSqrCountsResponse_element();
        SQR_wwwViadComV1.GetShowCustomerOrders_element     GetShowCustomerOrders=new  SQR_wwwViadComV1.GetShowCustomerOrders_element();
        SQR_wwwViadComV1.GetShowCustomerOrdersResponse_element      GetShowCustomerOrdersResponse=new  SQR_wwwViadComV1.GetShowCustomerOrdersResponse_element();
        SQR_wwwViadComV1.GetBoothOrders_element     GetBoothOrders=new  SQR_wwwViadComV1.GetBoothOrders_element();
        SQR_wwwViadComV1.GetBoothOrdersResponse_element      GetBoothOrdersResponse=new  SQR_wwwViadComV1.GetBoothOrdersResponse_element();
        SQR_wwwViadComV1.GetOrderPaymentInformation_element      GetOrderPaymentInformation=new  SQR_wwwViadComV1.GetOrderPaymentInformation_element();
        SQR_wwwViadComV1.GetOrderPaymentInformationResponse_element       GetOrderPaymentInformationResponse=new  SQR_wwwViadComV1.GetOrderPaymentInformationResponse_element();
        SQR_wwwViadComV1.GetHeldProjectOrdersByStatus_element      GetHeldProjectOrdersByStatus=new  SQR_wwwViadComV1.GetHeldProjectOrdersByStatus_element();
        SQR_wwwViadComV1.GetHeldProjectOrdersByStatusResponse_element       GetHeldProjectOrdersByStatusResponse=new  SQR_wwwViadComV1.GetHeldProjectOrdersByStatusResponse_element();
        SQR_wwwViadComV1.GetHeldShowCustomerOrders_element      GetHeldShowCustomerOrders=new  SQR_wwwViadComV1.GetHeldShowCustomerOrders_element();
        SQR_wwwViadComV1.GetHeldShowCustomerOrdersResponse_element       GetHeldShowCustomerOrdersResponse=new  SQR_wwwViadComV1.GetHeldShowCustomerOrdersResponse_element();
        SQR_wwwViadComV1.BasicHttpBinding_IOrderService  serviceObj= new SQR_wwwViadComV1.BasicHttpBinding_IOrderService();
        Test.setMock(WebServiceMock.class, new SQR_wwwViadComV1_Mock());
        serviceObj.ResubmitOrder('applicationSessionId',new SQR_wwwViadComDataV1.UpdateOrderPaymentRequest());
        serviceObj.ReleaseHold('applicationSessionId',10,'comments');
        serviceObj.ApplyHold('applicationSessionId',10,1);
        serviceObj.GetProjectOrders('applicationSessionId',10,'opsZone','serviceZone',10);   
        serviceObj.GetHeldShowOrders('applicationSessionId',100,10,'opsZone','serviceZone',2); 
        serviceObj.GetOrderByOrderHeaderId('applicationSessionId',15,10);
        serviceObj.GetHeldProjectOrders('applicationSessionId',100,10,'opsZone','serviceZone',100);
        serviceObj.GetHeldBoothOrders('applicationSessionId',new SQR_schemasMicrosoftCom200310Arr.ArrayOfint(),10,20);
        serviceObj.SubmitCreditCardInformation('applicationSessionId',new SQR_wwwViadComDataV1.CreditCardSubmission());
        serviceObj.GetShowOrders('applicationSessionId',10,'opsZone','serviceZone',200);
        serviceObj.SubmitOrder('applicationSessionId',new SQR_wwwViadComDataV1.CreateOrderRequest());
        serviceObj.CancelOrder('applicationSessionId',10,'cancelReason');
        serviceObj.GetOrderAndSqrCounts('applicationSessionId',10); 
        serviceObj.GetShowCustomerOrders('applicationSessionId',10,15);
        serviceObj.GetBoothOrders('applicationSessionId',new SQR_schemasMicrosoftCom200310Arr.ArrayOfint(),17);
        serviceObj.GetOrderPaymentInformation('applicationSessionId',10);
        serviceObj.GetHeldProjectOrdersByStatus('applicationSessionId',10,15,'orderStatus',18);
        serviceObj.GetHeldShowCustomerOrders('applicationSessionId',15,10,100);
    }
    
}