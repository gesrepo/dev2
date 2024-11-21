@isTest
public class SQRSer_wwwViadComV1_Test {
    public static testMethod void testMethods(){
        SQRSer_wwwViadComV1.GetSqrTally_element GetSqrTally=new SQRSer_wwwViadComV1.GetSqrTally_element();
        SQRSer_wwwViadComV1.GetSqrTallyResponse_element GetSqrTallyResponse=new  SQRSer_wwwViadComV1.GetSqrTallyResponse_element();
        SQRSer_wwwViadComV1.GetSqrSummary_element  GetSqrSummary=new SQRSer_wwwViadComV1.GetSqrSummary_element();
        SQRSer_wwwViadComV1.GetSqrSummaryResponse_element  GetSqrSummaryResponse=new  SQRSer_wwwViadComV1.GetSqrSummaryResponse_element();
        SQRSer_wwwViadComV1.GetSqrDefaults_element  GetSqrDefaults=new SQRSer_wwwViadComV1.GetSqrDefaults_element();
        SQRSer_wwwViadComV1.GetSqrDefaultsResponse_element GetSqrDefaultsResponse=new  SQRSer_wwwViadComV1.GetSqrDefaultsResponse_element();
        SQRSer_wwwViadComV1.GetSqrDetails_element  GetSqrDetails=new SQRSer_wwwViadComV1.GetSqrDetails_element();
        SQRSer_wwwViadComV1.GetSqrDetailsResponse_element  GetSqrDetailsResponse=new  SQRSer_wwwViadComV1.GetSqrDetailsResponse_element();
        SQRSer_wwwViadComV1.GetSimpleSqrs_element  GetSimpleSqrs=new SQRSer_wwwViadComV1.GetSimpleSqrs_element();
        SQRSer_wwwViadComV1.GetSimpleSqrsResponse_element GetSimpleSqrsResponse=new  SQRSer_wwwViadComV1.GetSimpleSqrsResponse_element();
        SQRSer_wwwViadComV1.SubmitSimpleSqr_element  SubmitSimpleSqr=new SQRSer_wwwViadComV1.SubmitSimpleSqr_element();
        SQRSer_wwwViadComV1.SubmitSimpleSqrResponse_element  SubmitSimpleSqrResponse=new  SQRSer_wwwViadComV1.SubmitSimpleSqrResponse_element();
        SQRSer_wwwViadComV1.UpdateSqr_element  UpdateSqr=new SQRSer_wwwViadComV1.UpdateSqr_element();
        SQRSer_wwwViadComV1.UpdateSqrResponse_element  UpdateSqrResponse=new  SQRSer_wwwViadComV1.UpdateSqrResponse_element();
        SQRSer_wwwViadComV1.SubmitSqr_element  SubmitSqr=new SQRSer_wwwViadComV1.SubmitSqr_element();
        SQRSer_wwwViadComV1.SubmitSqrResponse_element  SubmitSqrResponse=new  SQRSer_wwwViadComV1.SubmitSqrResponse_element();
        SQRSer_wwwViadComV1.GetSqrBoothInfo_element   GetSqrBoothInfo=new SQRSer_wwwViadComV1.GetSqrBoothInfo_element();
        SQRSer_wwwViadComV1.GetSqrBoothInfoResponse_element   GetSqrBoothInfoResponse=new  SQRSer_wwwViadComV1.GetSqrBoothInfoResponse_element();
        SQRSer_wwwViadComV1.GetSqrProblems_element   GetSqrProblems=new SQRSer_wwwViadComV1.GetSqrProblems_element();
        SQRSer_wwwViadComV1.GetSqrProblemsResponse_element   GetSqrProblemsResponse=new  SQRSer_wwwViadComV1.GetSqrProblemsResponse_element();
        SQRSer_wwwViadComV1.BasicHttpBinding_ISqrService   serviceObj= new SQRSer_wwwViadComV1.BasicHttpBinding_ISqrService ();
        Test.setMock(WebServiceMock.class, new SQRSer_wwwViadComV1_Mock());
        serviceObj.GetSqrTally('applicationSessionId',10,100,'opsZone','serviceZone',true,true);
        serviceObj.GetSqrSummary('applicationSessionId',new del_schemasMicrosoftCom200310Serializat.ArrayOfint(),100,200,300,'status','opsZone','serviceZone','priority','serviceCategory',true,false);
        serviceObj.GetSqrDefaults('applicationSessionId',10,'itemCode',100);
        serviceObj.GetSqrDetails('applicationSessionId',10);
        serviceObj.GetSimpleSqrs('applicationSessionId',new del_schemasMicrosoftCom200310Serializat.ArrayOfint());
        serviceObj.SubmitSimpleSqr('applicationSessionId',new SQRSer_wwwViadComDataV1.SimpleSqrCreateRequest());
        serviceObj.UpdateSqr('applicationSessionId',new SQRSer_wwwViadComDataV1.SqrUpdateRequest());
        serviceObj.SubmitSqr('applicationSessionId',new SQRSer_wwwViadComDataV1.SqrCreateRequest());
        serviceObj.GetSqrBoothInfo('applicationSessionId',10);
        serviceObj.GetSqrProblems('applicationSessionId',10);
    }
    
}