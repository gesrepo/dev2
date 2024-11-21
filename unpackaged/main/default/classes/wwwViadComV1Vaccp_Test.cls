@isTest
public class wwwViadComV1Vaccp_Test { 
    public static testMethod void testmethod1() {
     	ACCC1_wwwViadComV1.SubmitPaymentCollectionResponse_element SubmitPaymentCollection = new ACCC1_wwwViadComV1.SubmitPaymentCollectionResponse_element();
        ACCC1_wwwViadComV1.UpdatePaymentCollection_element UpdatePaymentCollection = new ACCC1_wwwViadComV1.UpdatePaymentCollection_element();
        ACCC1_wwwViadComV1.UpdatePaymentCollectionResponse_element UpdatePaymentCollectionResponse = new ACCC1_wwwViadComV1.UpdatePaymentCollectionResponse_element();
        ACCC1_wwwViadComV1.RequestPaymentCollection_element RequestPaymentCollection = new ACCC1_wwwViadComV1.RequestPaymentCollection_element();
        ACCC1_wwwViadComV1.GetPaymentCollection_element GetPaymentCollection = new ACCC1_wwwViadComV1.GetPaymentCollection_element();
        ACCC1_wwwViadComV1.RequestPaymentCollectionResponse_element RequestPaymentCollectionResponse = new ACCC1_wwwViadComV1.RequestPaymentCollectionResponse_element();
        ACCC1_wwwViadComV1.RequestPaymentCollectionMinimal_element RequestPaymentCollectionMinimal = new ACCC1_wwwViadComV1.RequestPaymentCollectionMinimal_element();
        ACCC1_wwwViadComV1.SubmitPaymentCollection_element SubmitPaymentCollection_Element = new ACCC1_wwwViadComV1.SubmitPaymentCollection_element();        
        ACCC1_wwwViadComV1.GetPaymentCollectionResponse_element GetPaymentCollectionResponse = new ACCC1_wwwViadComV1.GetPaymentCollectionResponse_element();
        ACCC1_wwwViadComV1.RequestPaymentCollectionMinimalResponse_element RequestPaymentCollectionMinimalResponse = new ACCC1_wwwViadComV1.RequestPaymentCollectionMinimalResponse_element();
        ACCC1_wwwViadComV1.FileCreditCardResponse_element FileCreditCard = new ACCC1_wwwViadComV1.FileCreditCardResponse_element();
		
		ACCC1_wwwViadComV1.PaymentCollectionInfo PaymentCollectionInfo = new ACCC1_wwwViadComV1.PaymentCollectionInfo();              
        ACCC1_wwwViadComV1.BasicHttpBinding_IPaymentCollectionService BasicHttpBinding_IPaymentCollectionService = new ACCC1_wwwViadComV1.BasicHttpBinding_IPaymentCollectionService();
		Test.setMock(WebServiceMock.class, new wwwViadComV1Vaccp_Mock());
		BasicHttpBinding_IPaymentCollectionService.GetPaymentCollection('207958e2-54ef-46f8-94c4-f8a88c56563b', 'e6271912-d82f-4513-9248-68849f42a44e');
        ACCC1_wwwViadComV1.BasicHttpBinding_IPaymentCollectionService bt = new ACCC1_wwwViadComV1.BasicHttpBinding_IPaymentCollectionService();
                   
        String x=bt.RequestPaymentCollectionMinimal('207958e2-54ef-46f8-94c4-f8a88c56563b','1001','SLK','GES','soniya.gopu@slkgroup.com',1000);
        String x1=bt.RequestPaymentCollection('207958e2-54ef-46f8-94c4-f8a88c56563b','1001','SLK','GES','soniya.gopu@slkgroup.com',1000,'Show1','test','soniya.gopu@slkgroup.com','');
         //String x2=bt.FileCreditCard('207958e2-54ef-46f8-94c4-f8a88c56563b','',10,'');
		
		
		bt.UpdatePaymentCollection('207958e2-54ef-46f8-94c4-f8a88c56563b','e6271912-d82f-4513-9248-68849f42a44e','SLK','GES','soniya.gopu@slkgroup.com',1000,'1001','2001','Show1','test','soniya.gopu@slkgroup.com','',false,true);
    }  
}