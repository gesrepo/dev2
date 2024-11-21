@isTest
private class wwwViadComV2_SQRTest {
    @isTest(SeeAllData=true)
    static  void wwwViadComV2_SQRMethodsTest() {
        wwwViadComV2_SQR sqrVariable= new wwwViadComV2_SQR();
        wwwViadComV2_SQR.BasicHttpBinding_ISqrService basicClassVariable = new wwwViadComV2_SQR.BasicHttpBinding_ISqrService();
        
        Test.setMock(WebServiceMock.class, new wwwViadComV2_SQRMockImpl());
        wwwViadComDataV2_SQR.ArrayOfSqr result= basicClassVariable.GetSqrDetails('1234567890', 111);
        wwwViadComDataV2_SQR.ArrayOfSqrTally result2= basicClassVariable.GetSqrTally('1234567890',123,456,'opsZone','serviceZone',false,true); 
        schemasMicrosoftCom200310Serializat.ArrayOfint customerBoothIds = new schemasMicrosoftCom200310Serializat.ArrayOfint();
        customerBoothIds.int_x= new List<Integer>();
        customerBoothIds.int_x.add(111);
        wwwViadComDataV2_SQR.ArrayOfSqrSummary  result3= basicClassVariable.GetSqrSummary('1234567890',customerBoothIds,123,456,789,'status','opsZone','serviceZone','priority','erviceCategory',false,true); 
        wwwViadComDataV2_SQR.SqrDefaults result4= basicClassVariable.GetSqrDefaults('1234567890', 111, 'itemcode',222); 
        wwwViadComDataV2_SQR.ArrayOfSimpleSqr result5= basicClassVariable.GetSimpleSqrs('1234567890', customerBoothIds); 
        wwwViadComDataV2_SQR.SqrUpdateRequest sqrInfo= new wwwViadComDataV2_SQR.SqrUpdateRequest();
        Integer result6= basicClassVariable.UpdateSqr('1234567890', sqrInfo); 
        wwwViadComDataV2_SQR.SimpleSqrCreateRequest sqrInfo2 = new wwwViadComDataV2_SQR.SimpleSqrCreateRequest();
        Integer result7= basicClassVariable.SubmitSimpleSqr('1234567890', sqrInfo2); 
        wwwViadComDataV2_SQR.SqrCreateRequest  sqrInfo3 = new wwwViadComDataV2_SQR.SqrCreateRequest ();
        Integer result8= basicClassVariable.SubmitSqr('1234567890', sqrInfo3); 
        wwwViadComDataV2_SQR.SqrCreateMultiItemRequest sqrInfo4 = new wwwViadComDataV2_SQR.SqrCreateMultiItemRequest();
        Integer result9= basicClassVariable.SubmitMultiItemSqr('1234567890', sqrInfo4); 
        wwwViadComDataV2_SQR.ArrayOfLookupList result10 = basicClassVariable.GetSqrProblems('applicationSessionId',1234);
    }
}