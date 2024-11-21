@isTest
public class UpSQR_ViadComV2_Test {
    public static testMethod void testMethods(){
       /* UpSQR_ViadComV2.GetSqrDetails_element  GetSqrDetails =new UpSQR_ViadComV2.GetSqrDetails_element();
        UpSQR_ViadComV2.GetSqrDetailsResponse_element  GetSqrDetailsResponse =new UpSQR_ViadComV2.GetSqrDetailsResponse_element();
        UpSQR_ViadComV2.GetSqrTally_element GetSqrTally=new UpSQR_ViadComV2.GetSqrTally_element();
        UpSQR_ViadComV2.GetSqrTallyResponse_element GetSqrTallyResponse =new UpSQR_ViadComV2.GetSqrTallyResponse_element();
        UpSQR_ViadComV2.GetSqrSummary_element  GetSqrSummary=new UpSQR_ViadComV2.GetSqrSummary_element ();
        UpSQR_ViadComV2.GetSqrSummaryResponse_element  GetSqrSummaryResponse =new UpSQR_ViadComV2.GetSqrSummaryResponse_element();
        UpSQR_ViadComV2.GetSqrDefaults_element  GetSqrDefaults=new UpSQR_ViadComV2.GetSqrDefaults_element();
        UpSQR_ViadComV2.GetSqrDefaultsResponse_element  GetSqrDefaultsResponse =new UpSQR_ViadComV2.GetSqrDefaultsResponse_element();
        UpSQR_ViadComV2.GetSimpleSqrs_element  GetSimpleSqrs=new UpSQR_ViadComV2.GetSimpleSqrs_element();
        UpSQR_ViadComV2.GetSimpleSqrsResponse_element  GetSimpleSqrsResponse =new UpSQR_ViadComV2.GetSimpleSqrsResponse_element();
        UpSQR_ViadComV2.UpdateSqr_element  UpdateSqr=new UpSQR_ViadComV2.UpdateSqr_element();
        UpSQR_ViadComV2.UpdateSqrResponse_element  UpdateSqrResponse =new UpSQR_ViadComV2.UpdateSqrResponse_element();
        UpSQR_ViadComV2.SubmitSimpleSqr_element  SubmitSimpleSqr=new UpSQR_ViadComV2.SubmitSimpleSqr_element();
        UpSQR_ViadComV2.SubmitSimpleSqrResponse_element  SubmitSimpleSqrResponse =new UpSQR_ViadComV2.SubmitSimpleSqrResponse_element ();
        UpSQR_ViadComV2.SubmitSqr_element  SubmitSqr=new UpSQR_ViadComV2.SubmitSqr_element();
        UpSQR_ViadComV2.SubmitSqrResponse_element SubmitSqrResponse =new UpSQR_ViadComV2.SubmitSqrResponse_element();
	*/        
		UpSQR_ViadComV2.GetSqrHeaders_element  GetSqrHeaders=new UpSQR_ViadComV2.GetSqrHeaders_element ();
        UpSQR_ViadComV2.GetSqrHeadersResponse_element  GetSqrHeadersResponse =new UpSQR_ViadComV2.GetSqrHeadersResponse_element();
        /*
        UpSQR_ViadComV2.SubmitMultiItemSqr_element  SubmitMultiItemSqr=new UpSQR_ViadComV2.SubmitMultiItemSqr_element();
        UpSQR_ViadComV2.SubmitMultiItemSqrResponse_element  SubmitMultiItemSqrResponse =new UpSQR_ViadComV2.SubmitMultiItemSqrResponse_element();
        UpSQR_ViadComV2.GetSqrProblems_element   GetSqrProblems=new UpSQR_ViadComV2.GetSqrProblems_element();
        UpSQR_ViadComV2.GetSqrProblemsResponse_element   GetSqrProblemsResponse =new UpSQR_ViadComV2.GetSqrProblemsResponse_element();
		*/       
        UpSQR_ViadComV2.BasicHttpBinding_ISqrService serviceObj= new UpSQR_ViadComV2.BasicHttpBinding_ISqrService();

        Test.setMock(WebServiceMock.class, new UpSQR_ViadComV2_Mock());
         //  serviceObj.GetSqrHeaders('applicationSessionId',new  UpSQR_MicrosoftCom200310Serializat.ArrayOfint(),10,2,11,'status','opsZone','serviceZone','priority','serviceCategory',true,true);
       serviceObj.GetSqrHeaders('applicationSessionId',new UpSQR_MicrosoftCom200310Serializat.ArrayOfint(),10,10,10,'status','opsZone','serviceZone','priority','serviceCategory',true,true,new  UpSQR_MicrosoftCom200310Serializat.ArrayOfstring());
        /*
        serviceObj.GetSqrDetails('applicationSessionId',10); 
        serviceObj.GetSqrTally('applicationSessionId',10,2,'opsZone','serviceZone',true,true);
        serviceObj.GetSqrSummary('applicationSessionId',new UpSQR_MicrosoftCom200310Serializat.ArrayOfint(),10,10,10,'status','opsZone','serviceZone','priority','serviceCategory',true,true);
        serviceObj.GetSqrDefaults('applicationSessionId',10,'itemCode',10);
        serviceObj.GetSimpleSqrs('applicationSessionId',new  UpSQR_MicrosoftCom200310Serializat.ArrayOfint());
        serviceObj.UpdateSqr('applicationSessionId',new UpSQR_ViadComDataV2.SqrUpdateRequest());
        serviceObj.SubmitSimpleSqr('applicationSessionId',new UpSQR_ViadComDataV2.SimpleSqrCreateRequest());
        serviceObj.SubmitSqr('applicationSessionId',new UpSQR_ViadComDataV2.SqrCreateRequest());  
        serviceObj.SubmitMultiItemSqr('applicationSessionId',new UpSQR_ViadComDataV2.SqrCreateMultiItemRequest());
        serviceObj.GetSqrProblems('applicationSessionId',10);
       */ 
    }
}