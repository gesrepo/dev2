@isTest
public class wwwViadComV2_SQRMockImpl implements WebServiceMock
{
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
            
            System.debug(LoggingLevel.INFO, 'wwwViadComV2_SQRMockImpl.doInvoke() - ' +
                         '\n request: ' + request +
                         '\n response: ' + response +
                         '\n endpoint: ' + endpoint +
                         '\n soapAction: ' + soapAction +
                         '\n requestName: ' + requestName +
                         '\n responseNS: ' + responseNS +
                         '\n responseName: ' + responseName +
                         '\n responseType: ' + responseType);
            
            
            if(request instanceOf wwwViadComV2_SQR.GetSqrDetails_element) {
                wwwViadComV2_SQR.GetSqrDetailsResponse_element response_x= new wwwViadComV2_SQR.GetSqrDetailsResponse_element();
                response_x.GetSqrDetailsResult = new wwwViadComDataV2_SQR.ArrayOfSqr();
                response_x.GetSqrDetailsResult.sqr= new List<wwwViadComDataV2_SQR.Sqr>();
                wwwViadComDataV2_SQR.Sqr sqr = new wwwViadComDataV2_SQR.Sqr();
                sqr.Cause='Cause';
                sqr.Comments='Comments';
                sqr.CreatedBy='CreatedBy';
                //sqr.CreationDate=date.today();
                sqr.CreationSystem='CreationSystem';
                sqr.CustomerBoothId=10;
                sqr.CustomerNotes='CustomerNotes';
                sqr.Description='Description';
                sqr.EmailPreference=true;
                sqr.ExternalSyncId='ExternalSyncId';
                sqr.InternalOnlyFlag=true;
                sqr.ItemCategory='ItemCategory';
                //sqr.LastUpdateDate=date.today();
                sqr.LastUpdatedBy='LastUpdatedBy';
                sqr.LineOfBusiness='LineOfBusiness';
                sqr.OrderHeaderId=11;
                sqr.OrderLineId=12;
                sqr.OrderType='OrderType';
                sqr.PhonePreference=true;
                sqr.Priority='Priority';
                sqr.ProblemType='ProblemType';
                sqr.ServiceCategory='ServiceCategory';
                sqr.ServiceTrackingFlag=true;
                sqr.ShowOccrProjectId=13;
                sqr.SmsPreference=false;
                sqr.Source='Source';
                sqr.SqrContactEmail='test@email.com';
                sqr.SqrContactName='SqrContactName';
                sqr.SqrContactPhone='9789944733';
                sqr.SqrContactSms='SqrContactSms';
                sqr.SqrHeaderId=14;
                sqr.SqrHistoryId=15;
                //sqr.SqrOrderLines;
                sqr.Status='Status';
                Map<String, wwwViadComV2_SQR.GetSqrDetailsResponse_element> response_map_x = new Map<String, wwwViadComV2_SQR.GetSqrDetailsResponse_element>();
                response_map_x.put('response_x', response_x);
                
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            if(request instanceOf wwwViadComV2_SQR.GetSqrTally_element) {
                wwwViadComV2_SQR.GetSqrTallyResponse_element response_x = new wwwViadComV2_SQR.GetSqrTallyResponse_element();
                Map<String, wwwViadComV2_SQR.GetSqrTallyResponse_element> response_map_x = new Map<String, wwwViadComV2_SQR.GetSqrTallyResponse_element>();
                response_x.GetSqrTallyResult = new wwwViadComDataV2_SQR.ArrayOfSqrTally();
                response_x.GetSqrTallyResult.SqrTally = new List<wwwViadComDataV2_SQR.SqrTally>();
                /*response_x.applicationSessionId='test applicationSessionId';
response_x.showOccrId=123;
response_x.showOccrProjectId=456;
response_x.opsZone='test opsZone';
response_x.serviceZone='test serviceZone';
response_x.serviceTrackingFlag=true;
response_x.isNsc=true;	*/
                response_map_x.put('response_x', response_x);
                
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            if(request instanceOf wwwViadComV2_SQR.GetSqrSummary_element) {
                wwwViadComV2_SQR.GetSqrSummaryResponse_element response_x = new wwwViadComV2_SQR.GetSqrSummaryResponse_element();
                Map<String, wwwViadComV2_SQR.GetSqrSummaryResponse_element> response_map_x = new Map<String, wwwViadComV2_SQR.GetSqrSummaryResponse_element>();
                response_x.GetSqrSummaryResult= new wwwViadComDataV2_SQR.ArrayOfSqrSummary();
                response_x.GetSqrSummaryResult.SqrSummary= new List<wwwViadComDataV2_SQR.SqrSummary>();
                response_map_x.put('response_x', response_x);
                
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            if(request instanceOf wwwViadComV2_SQR.GetSqrDefaults_element) {
                wwwViadComV2_SQR.GetSqrDefaultsResponse_element  response_x = new wwwViadComV2_SQR.GetSqrDefaultsResponse_element ();
                Map<String, wwwViadComV2_SQR.GetSqrDefaultsResponse_element > response_map_x = new Map<String, wwwViadComV2_SQR.GetSqrDefaultsResponse_element >();
                response_x.GetSqrDefaultsResult=new wwwViadComDataV2_SQR.SqrDefaults ();
                
                
                response_map_x.put('response_x', response_x);                
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
                //response.put( 'response_x', new wwwViadComV2_SQR.GetSqrDefaultsResponse_element());
            }
            if(request instanceOf wwwViadComV2_SQR.GetSimpleSqrs_element) {
                wwwViadComV2_SQR.GetSimpleSqrsResponse_element response_x = new wwwViadComV2_SQR.GetSimpleSqrsResponse_element();
                Map<String, wwwViadComV2_SQR.GetSimpleSqrsResponse_element> response_map_x = new Map<String, wwwViadComV2_SQR.GetSimpleSqrsResponse_element>();
                response_x.GetSimpleSqrsResult=new wwwViadComDataV2_SQR.ArrayOfSimpleSqr();
                
                response_map_x.put('response_x', response_x);                
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            if(request instanceOf wwwViadComV2_SQR.UpdateSqr_element) {
                wwwViadComV2_SQR.UpdateSqrResponse_element  response_x = new wwwViadComV2_SQR.UpdateSqrResponse_element ();
                Map<String, wwwViadComV2_SQR.UpdateSqrResponse_element > response_map_x = new Map<String, wwwViadComV2_SQR.UpdateSqrResponse_element >();
                response_x.UpdateSqrResult=999;
                response_map_x.put('response_x', response_x);                
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            if(request instanceOf wwwViadComV2_SQR.SubmitSimpleSqr_element) {
                wwwViadComV2_SQR.SubmitSimpleSqrResponse_element  response_x = new wwwViadComV2_SQR.SubmitSimpleSqrResponse_element ();
                Map<String, wwwViadComV2_SQR.SubmitSimpleSqrResponse_element > response_map_x = new Map<String, wwwViadComV2_SQR.SubmitSimpleSqrResponse_element >();
                response_x.SubmitSimpleSqrResult=888;
                response_map_x.put('response_x', response_x);                
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            if(request instanceOf wwwViadComV2_SQR.SubmitSqr_element) {
                wwwViadComV2_SQR.SubmitSqrResponse_element  response_x = new wwwViadComV2_SQR.SubmitSqrResponse_element ();
                Map<String, wwwViadComV2_SQR.SubmitSqrResponse_element > response_map_x = new Map<String, wwwViadComV2_SQR.SubmitSqrResponse_element >();
                response_x.SubmitSqrResult=777;
                response_map_x.put('response_x', response_x);                
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            if(request instanceOf wwwViadComV2_SQR.SubmitMultiItemSqr_element) {
                wwwViadComV2_SQR.SubmitMultiItemSqrResponse_element   response_x = new wwwViadComV2_SQR.SubmitMultiItemSqrResponse_element  ();
                Map<String, wwwViadComV2_SQR.SubmitMultiItemSqrResponse_element  > response_map_x = new Map<String, wwwViadComV2_SQR.SubmitMultiItemSqrResponse_element  >();
                response_x.SubmitMultiItemSqrResult=666;
                response_map_x.put('response_x', response_x);                
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            if(request instanceOf wwwViadComV2_SQR.GetSqrProblems_element) {
                wwwViadComV2_SQR.GetSqrProblemsResponse_element    response_x = new wwwViadComV2_SQR.GetSqrProblemsResponse_element();
                Map<String, wwwViadComV2_SQR.GetSqrProblemsResponse_element> response_map_x = new Map<String, wwwViadComV2_SQR.GetSqrProblemsResponse_element>();
                response_x.GetSqrProblemsResult=new wwwViadComDataV2_SQR.ArrayOfLookupList();
                response_map_x.put('response_x', response_x);                
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            } 
            
        }        
}