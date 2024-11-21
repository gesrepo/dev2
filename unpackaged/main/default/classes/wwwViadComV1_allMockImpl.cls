// Mock Web Services for wwwViadComV1_all
@isTest
public class wwwViadComV1_allMockImpl implements WebServiceMock {
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
            
            System.debug(LoggingLevel.INFO, 'wwwViadComV1_allMockImpl.doInvoke() - ' +
                         '\n request: ' + request +
                         '\n response: ' + response +
                         '\n endpoint: ' + endpoint +
                         '\n soapAction: ' + soapAction +
                         '\n requestName: ' + requestName +
                         '\n responseNS: ' + responseNS +
                         '\n responseName: ' + responseName +
                         '\n responseType: ' + responseType);
            
            if(request instanceOf wwwViadComV1_all.CreateExhibitorBooth_element) {
                response.put( 'response_x', new wwwViadComV1_all.CreateExhibitorBoothResponse_element());
            }
            else if(request instanceOf wwwViadComV1_all.EmailShowStatements_element) {
                response.put( 'response_x', new wwwViadComV1_all.EmailShowStatementsResponse_element());
            }
            else if(request instanceOf wwwViadComV1_all.GetExhibitor_element) {
                response.put( 'response_x', new wwwViadComV1_all.GetExhibitorResponse_element());
            }
            else if(request instanceOf wwwViadComV1_all.GetExhibitorByBooth_element) {
                response.put( 'response_x', new wwwViadComV1_all.GetExhibitorByBoothResponse_element());
            }
            else if(request instanceOf wwwViadComV1_all.GetExhibitorChangesAll_element) {
                response.put( 'response_x', new wwwViadComV1_all.GetExhibitorChangesAllResponse_element());
            }
            else if(request instanceOf wwwViadComV1_all.GetExhibitorChangesByProject_element) {
                response.put( 'response_x', new wwwViadComV1_all.GetExhibitorChangesByProjectResponse_element());
            }
            else if(request instanceOf wwwViadComV1_all.GetExhibitorChecklistStatus_element) {
                wwwViadComV1_all.GetExhibitorChecklistStatusResponse_element response_x = new wwwViadComV1_all.GetExhibitorChecklistStatusResponse_element();
                response_x.GetExhibitorChecklistStatusResult= new wwwViadComV1_all.ArrayOfExhibitorChecklistStatus();
                response_x.GetExhibitorChecklistStatusResult.ExhibitorChecklistStatus= new List<wwwViadComV1_all.ExhibitorChecklistStatus>();
                wwwViadComV1_all.ExhibitorChecklistStatus ex = new wwwViadComV1_all.ExhibitorChecklistStatus();
                ex.BoothNumber='123';
                ex.CompanyName='test CompanyName';
                ex.DateUpdated=date.Today();
                ex.ProjectCode='123456789';
                ex.ShowName='test ShowName';
                ex.Status='Yes';
                ex.Title='test Title';
                response_x.GetExhibitorChecklistStatusResult.ExhibitorChecklistStatus.add(ex);
                response.put( 'response_x', response_x);
                //response.put( 'response_x', new wwwViadComV1_all.GetExhibitorChecklistStatusResponse_element());
            }
            else if(request instanceOf wwwViadComV1_all.GetExhibitorFormProgress_element) {
                wwwViadComV1_all.ExhibitorFormProgress formValues = new wwwViadComV1_all.ExhibitorFormProgress();
                formValues.BoothNumber='111';
                formValues.CustomerName='ddd';
                formValues.CustomerNumber='fff';
                formValues.FormTitle='hhh';
                formValues.Submitted='hhhh';
                wwwViadComV1_all.ShowFormProgress formProgressValues = new wwwViadComV1_all.ShowFormProgress();
                formProgressValues.FormTitle='111';
                formProgressValues.ProjectNumber='ddd';
                formProgressValues.ShowName='fff';
                formProgressValues.Submitted=111;
                formProgressValues.Total=1111;
                wwwViadComV1_all.ArrayOfExhibitorFormProgress arrayFormProgress = new wwwViadComV1_all.ArrayOfExhibitorFormProgress();
                arrayFormProgress.ExhibitorFormProgress = new List<wwwViadComV1_all.ExhibitorFormProgress>();
                arrayFormProgress.ExhibitorFormProgress.add(formValues);
                wwwViadComV1_all.ArrayOfShowFormProgress  arrayShowFormProgress = new wwwViadComV1_all.ArrayOfShowFormProgress ();
                arrayShowFormProgress.ShowFormProgress = new List<wwwViadComV1_all.ShowFormProgress>();
                arrayShowFormProgress.ShowFormProgress.add(formProgressValues);
                wwwViadComV1_all.ShowFormProgressStatus progressStatus = new wwwViadComV1_all.ShowFormProgressStatus();
                progressStatus.ExhibitorFormProgress = arrayFormProgress;
                progressStatus.ShowFormProgress = arrayShowFormProgress;
                wwwViadComV1_all.GetExhibitorFormProgressResponse_element arrayResponse = new wwwViadComV1_all.GetExhibitorFormProgressResponse_element();
                arrayResponse.GetExhibitorFormProgressResult = progressStatus;
                response.put( 'response_x', arrayResponse);
            }
            else if(request instanceOf wwwViadComV1_all.GetExhibitorOrderProgress_element) {
                wwwViadComV1_all.GetExhibitorOrderProgressResponse_element response_x = new wwwViadComV1_all.GetExhibitorOrderProgressResponse_element();
                Map<String, wwwViadComV1_all.GetExhibitorOrderProgressResponse_element> response_map_x = new Map<String, wwwViadComV1_all.GetExhibitorOrderProgressResponse_element>();
                response_x.GetExhibitorOrderProgressResult = new wwwViadComV1_all.ShowInstanceOrderProgress();
                response_x.GetExhibitorOrderProgressResult.ExhibitorsWithoutOrders = new wwwViadComV1_all.ArrayOfExhibitorInfo();
                response_x.GetExhibitorOrderProgressResult.ExhibitorsWithoutOrdersEmailList = new schemasMicrosoft0310Serializat_all.ArrayOfstring();
                response_x.GetExhibitorOrderProgressResult.ExhibitorsWithoutOrdersEmailList.string_x = new List<String>();
                response_x.GetExhibitorOrderProgressResult.OrderProgressSummary = new wwwViadComV1_all.OrderProgressSummary();
                //wwwViadComV1_all.ShowInstanceOrderProgress GetExhibitorOrderProgressResult= response_x.GetExhibitorOrderProgressResult;
                //  wwwViadComV1_all.ArrayOfExhibitorInfo ExhibitorsWithoutOrders= GetExhibitorOrderProgressResult.ExhibitorsWithoutOrders;
                //      List<wwwViadComV1_all.ExhibitorInfo> ExhibitorInfo=ExhibitorsWithoutOrders.ExhibitorInfo;
                wwwViadComV1_all.ExhibitorInfo ExhibitorInfo1= new wwwViadComV1_all.ExhibitorInfo();
                ExhibitorInfo1.Address='test Address';
                ExhibitorInfo1.City='test city';
                ExhibitorInfo1.CompanyName= 'test CompanyName';
                ExhibitorInfo1.Country='test Country';
                ExhibitorInfo1.CustomerNumber='test CustomerNumber';
                ExhibitorInfo1.EmailAddress='email@test.com';
                ExhibitorInfo1.FirstName='test FirstName';
                ExhibitorInfo1.LastName='test LastName';
                ExhibitorInfo1.PhoneNumber='9789944755';
                ExhibitorInfo1.PostalCode='560024';
                ExhibitorInfo1.State='test State';
                response_x.GetExhibitorOrderProgressResult.ExhibitorsWithoutOrders.ExhibitorInfo = new List<wwwViadComV1_all.ExhibitorInfo>();
                response_x.GetExhibitorOrderProgressResult.ExhibitorsWithoutOrders.ExhibitorInfo.add(ExhibitorInfo1);
                response_x.GetExhibitorOrderProgressResult.ExhibitorsWithoutOrdersEmailList.string_x.add('test1@email.com');
                response_x.GetExhibitorOrderProgressResult.ExhibitorsWithoutOrdersEmailList.string_x.add('test2@email.com');
                
                response_x.GetExhibitorOrderProgressResult.OrderProgressSummary.ExhbitorsWithOrdersCount=20;
                response_x.GetExhibitorOrderProgressResult.OrderProgressSummary.ExhibitorsCount=100;
                response_x.GetExhibitorOrderProgressResult.OrderProgressSummary.OrderDueDate= Date.Today();
                response_x.GetExhibitorOrderProgressResult.OrderProgressSummary.ProjectNumber= '123456789';
                response_x.GetExhibitorOrderProgressResult.OrderProgressSummary.ShowName='test show';
                response.put( 'response_x', response_x);
                // response.put( 'response_x', new wwwViadComV1_all.GetExhibitorOrderProgressResponse_element());
            }
            else if(request instanceOf wwwViadComV1_all.GetExhibitorOrderTypeStatus_element) {
                wwwViadComV1_all.GetExhibitorOrderTypeStatusResponse_element response_x = new wwwViadComV1_all.GetExhibitorOrderTypeStatusResponse_element();
                response_x.GetExhibitorOrderTypeStatusResult = new wwwViadComV1_all.ArrayOfExhibitorOrderTypeStatus();
                response_x.GetExhibitorOrderTypeStatusResult.ExhibitorOrderTypeStatus = new List<wwwViadComV1_all.ExhibitorOrderTypeStatus>();
                wwwViadComV1_all.ExhibitorOrderTypeStatus ex= new wwwViadComV1_all.ExhibitorOrderTypeStatus();
                ex.BoothNumber='123';
                ex.CompanyName='test CompanyName';
                ex.ItemType='test ItemType';
                ex.Ordered='yes';
                ex.ProjectCode='123456789';
                ex.ShowName='test ShowName';
                response_x.GetExhibitorOrderTypeStatusResult.ExhibitorOrderTypeStatus.add(ex);
                
                response.put( 'response_x', response_x);
                //response.put( 'response_x', new wwwViadComV1_all.GetExhibitorOrderTypeStatusResponse_element());
            }
            else if(request instanceOf wwwViadComV1_all.GetExhibitorsByProject_element) {
                response.put( 'response_x', new wwwViadComV1_all.GetExhibitorsByProjectResponse_element());
            }
            else if(request instanceOf wwwViadComV1_all.GetShowStatement_element) {
                response.put( 'response_x', new wwwViadComV1_all.GetShowStatementResponse_element());
            }
            else if(request instanceOf wwwViadComV1_all.ListQuestionnairesByBooths_element) {
                response.put( 'response_x', new wwwViadComV1_all.ListQuestionnairesByBoothsResponse_element());
            }
            else if(request instanceOf wwwViadComV1_all.ListQuestionnairesByShowCustomer_element) {
                response.put( 'response_x', new wwwViadComV1_all.ListQuestionnairesByShowCustomerResponse_element());
            }
            else if(request instanceOf wwwViadComV1_all.ListStatementsByCustomerNumber_element) {
                response.put( 'response_x', new wwwViadComV1_all.ListStatementsByCustomerNumberResponse_element());
            }
            else if(request instanceOf wwwViadComV1_all.ListStatementsByProject_element) {
                response.put( 'response_x', new wwwViadComV1_all.ListStatementsByProjectResponse_element());
            }
            else if(request instanceOf wwwViadComV1_all.ListStatementsByReferenceNumber_element) {
                response.put( 'response_x', new wwwViadComV1_all.ListStatementsByReferenceNumberResponse_element());
            }
            else if(request instanceOf wwwViadComV1_all.ListStatementsByShowCustomer_element) {
                response.put( 'response_x', new wwwViadComV1_all.ListStatementsByShowCustomerResponse_element());
            }
            else if(request instanceOf wwwViadComV1_all.SearchExhibitorListByShowOccr_element) {
                response.put( 'response_x', new wwwViadComV1_all.SearchExhibitorListByShowOccrResponse_element());
            }
            else if(request instanceOf wwwViadComV1_all.SearchExhibitorListByShowProject_element) {
                response.put( 'response_x', new wwwViadComV1_all.SearchExhibitorListByShowProjectResponse_element());
            }
            else if(request instanceOf wwwViadComV1_all.SearchExhibitorsByShowOccr_element) {
                response.put( 'response_x', new wwwViadComV1_all.SearchExhibitorsByShowOccrResponse_element());
            }
            else if(request instanceOf wwwViadComV1_all.SearchExhibitorsByShowOccrAndZone_element) {
                response.put( 'response_x', new wwwViadComV1_all.SearchExhibitorsByShowOccrAndZoneResponse_element());
            }
            else if(request instanceOf wwwViadComV1_all.SearchExhibitorsByShowProject_element) {
                response.put( 'response_x', new wwwViadComV1_all.SearchExhibitorsByShowProjectResponse_element());
            }
            else if(request instanceOf wwwViadComV1_all.SearchExhibitorsByShowProjectAndZone_element) {
                response.put( 'response_x', new wwwViadComV1_all.SearchExhibitorsByShowProjectAndZoneResponse_element());
            }
            else if(request instanceOf  wwwViadComSecurityV2Vaccc.StartAppSession_element) {
                System.debug('StartAppSession_element');
                wwwViadComSecurityV2Vaccc.AppSessionInfo sessionInfo = new wwwViadComSecurityV2Vaccc.AppSessionInfo();
                sessionInfo.SessionID = '1111111111111111111';
                wwwViadComSecurityV2Vaccc.StartAppSessionResponse_element sessionId = new wwwViadComSecurityV2Vaccc.StartAppSessionResponse_element();
                sessionId.StartAppSessionResult = sessionInfo;
                response.put( 'response_x', sessionId);
            }
            else if(request instanceOf  wwwViadComV1_all.GetShowInstanceChecklistItems_element ) {
                System.debug('GetShowInstanceChecklistItemsResponse_element');
                wwwViadComV1_all.GetShowInstanceChecklistItemsResponse_element response_x = new wwwViadComV1_all.GetShowInstanceChecklistItemsResponse_element();
                response_x.GetShowInstanceChecklistItemsResult = new wwwViadComV1_all.ArrayOfShowInstanceChecklistItem();
                
                wwwViadComV1_all.ArrayOfShowInstanceChecklistItem showInstanceChecklistItems = new wwwViadComV1_all.ArrayOfShowInstanceChecklistItem();
                showInstanceChecklistItems.ShowInstanceChecklistItem = new List<wwwViadComV1_all.ShowInstanceChecklistItem>();
                
                wwwViadComV1_all.ShowInstanceChecklistItem sil = new wwwViadComV1_all.ShowInstanceChecklistItem();
                sil.ChecklistGroup = 'Test';
                sil.ChecklistGroupId = 1;
                sil.DueDate = DateTime.Now();
                sil.FormName = 'Test Form';
                sil.FormType = 'Test Type';
                sil.Progress = 1;
                sil.ProjectNumber = '123456789';
                sil.ShowInstanceChecklistId = 1;
                sil.Submitted  = 1;
                sil.Total = 1000;
                showInstanceChecklistItems.ShowInstanceChecklistItem.add(sil);
                
                response_x.GetShowInstanceChecklistItemsResult = showInstanceChecklistItems;
                response.put( 'response_x', response_x);
            }
            else if(request instanceOf  wwwViadComV1_all.GetRegistrationChecklistTasks_element ) {
                
                wwwViadComV1_all.GetRegistrationChecklistTasksResponse_element response_x = new wwwViadComV1_all.GetRegistrationChecklistTasksResponse_element();
                
                response_x.GetRegistrationChecklistTasksResult = new wwwViadComV1_all.ShowInstanceChecklistTasks();
                wwwViadComV1_all.ShowInstanceChecklistTasks checkListTasks = new wwwViadComV1_all.ShowInstanceChecklistTasks();
                checkListTasks.RegistrationChecklistTasks = new wwwViadComV1_all.ArrayOfRegistrationChecklistTask();
                checkListTasks.RegistrationChecklistTasks.RegistrationChecklistTask = new List<wwwViadComV1_all.RegistrationChecklistTask>();
                
                wwwViadComV1_all.RegistrationChecklistTask rct = new wwwViadComV1_all.RegistrationChecklistTask ();
                rct.ExhibitorName = 'Test Exhibitor';
                rct.RegistrationChecklistTaskId = 1;
                rct.Status = 'Test status';
                rct.SubmittedOn = DateTime.now();
                rct.UpdatedOn = DateTime.now();
                checkListTasks.RegistrationChecklistTasks.RegistrationChecklistTask.add(rct);
                
                checkListTasks.ShowInstanceChecklistItem = new wwwViadComV1_all.ShowInstanceChecklistItem();
                wwwViadComV1_all.ShowInstanceChecklistItem sil = new wwwViadComV1_all.ShowInstanceChecklistItem();
                sil.ChecklistGroup = 'Test';
                sil.ChecklistGroupId = 1;
                sil.DueDate = DateTime.Now();
                sil.FormName = 'Test Form';
                sil.FormType = 'Test Type';
                sil.Progress = 1;
                sil.ProjectNumber = '123456789';
                sil.ShowInstanceChecklistId = 1;
                sil.Submitted  = 1;
                sil.Total = 1000;
                checkListTasks.ShowInstanceChecklistItem = sil;
                
                response_x.GetRegistrationChecklistTasksResult = checkListTasks;
                response.put( 'response_x', response_x);
            }
            else if(request instanceOf  wwwViadComV1_all.GetRegistrationChecklistTaskDetails_element ) {
                
                wwwViadComV1_all.GetRegistrationChecklistTaskDetailsResponse_element response_x =new wwwViadComV1_all.GetRegistrationChecklistTaskDetailsResponse_element();
                
                response_x.GetRegistrationChecklistTaskDetailsResult = new wwwViadComV1_all.RegistrationChecklistTaskDetails();
                wwwViadComV1_all.RegistrationChecklistTaskDetails regChkListTaskDtls = new wwwViadComV1_all.RegistrationChecklistTaskDetails();
                regChkListTaskDtls.RegistrationChecklistStatusDetails = new wwwViadComV1_all.ArrayOfRegistrationChecklistStatusDetail();
                wwwViadComV1_all.ArrayOfRegistrationChecklistStatusDetail arrRegChkLstStsDtls = new wwwViadComV1_all.ArrayOfRegistrationChecklistStatusDetail();
                
                arrRegChkLstStsDtls.RegistrationChecklistStatusDetail = new List<wwwViadComV1_all.RegistrationChecklistStatusDetail>();
                wwwViadComV1_all.RegistrationChecklistStatusDetail regChkListStsDetail = new wwwViadComV1_all.RegistrationChecklistStatusDetail();
                regChkListStsDetail.Id = 1;
                regChkListStsDetail.Label = 'Test Label';
                regChkListStsDetail.Value = 'Test Value';
                arrRegChkLstStsDtls.RegistrationChecklistStatusDetail.add(regChkListStsDetail);
                response_x.GetRegistrationChecklistTaskDetailsResult = regChkListTaskDtls;
                
                response.put( 'response_x', new wwwViadComV1_all.GetRegistrationChecklistTaskDetailsResponse_element());
            }
            else if(request instanceOf  wwwViadComV1_all.GetAllQuestionnaireDetails_element) {
                
                wwwViadComV1_all.GetAllQuestionnaireDetailsResponse_element response_x = new wwwViadComV1_all.GetAllQuestionnaireDetailsResponse_element();
                response_x.GetAllQuestionnaireDetailsResult = new  wwwViadComV1_all.ArrayOfRegistrationChecklistTaskDetails();
                wwwViadComV1_all.ArrayOfRegistrationChecklistTaskDetails checkListTaskDetails = new wwwViadComV1_all.ArrayOfRegistrationChecklistTaskDetails();
                checkListTaskDetails.RegistrationChecklistTaskDetails = new List<wwwViadComV1_all.RegistrationChecklistTaskDetails>();
                
                wwwViadComV1_all.RegistrationChecklistTaskDetails regCheckListTaskDetails = new wwwViadComV1_all.RegistrationChecklistTaskDetails();
                regCheckListTaskDetails.RegistrationChecklistStatusDetails = new wwwViadComV1_all.ArrayOfRegistrationChecklistStatusDetail();
                wwwViadComV1_all.ArrayOfRegistrationChecklistStatusDetail arrClSDetails = new wwwViadComV1_all.ArrayOfRegistrationChecklistStatusDetail();
                
                arrClSDetails.RegistrationChecklistStatusDetail = new List<wwwViadComV1_all.RegistrationChecklistStatusDetail>();
                
                wwwViadComV1_all.RegistrationChecklistStatusDetail regChkListStsDetail = new wwwViadComV1_all.RegistrationChecklistStatusDetail();
                regChkListStsDetail.Id = 1;
                regChkListStsDetail.Label = 'Test Label';
                regChkListStsDetail.Value = 'Test Value';
                arrClSDetails.RegistrationChecklistStatusDetail.add(regChkListStsDetail);
                
                regCheckListTaskDetails.RegistrationChecklistStatusDetails = arrClSDetails;
                regCheckListTaskDetails.RegistrationChecklistTask = new wwwViadComV1_all.RegistrationChecklistTask();
                wwwViadComV1_all.RegistrationChecklistTask rct = new wwwViadComV1_all.RegistrationChecklistTask();
                
                rct.ExhibitorName = 'Test Exhibitor';
                rct.RegistrationChecklistTaskId = 1;
                rct.Status = 'Test Status';
                rct.SubmittedOn = DateTime.Now();
                rct.UpdatedOn = DateTime.Now();
                
                checkListTaskDetails.RegistrationChecklistTaskDetails.add(regCheckListTaskDetails);
                response_x.GetAllQuestionnaireDetailsResult = checkListTaskDetails;
                response.put( 'response_x', response_x);
            }
            else if(request instanceOf  wwwViadComV1_all.GetAllQuestionnaireDetails_element){
                wwwViadComV1_all.GetQuestionnaireDetailSummaryResponse_element response_x = new wwwViadComV1_all.GetQuestionnaireDetailSummaryResponse_element();
                response_x.GetQuestionnaireDetailSummaryResult= new wwwViadComV1_all.QuestionnaireDetailSummary();
                response_x.GetQuestionnaireDetailSummaryResult.Details= new wwwViadComV1_all.ArrayOfQuestionnaireDetailValues();
                response_x.GetQuestionnaireDetailSummaryResult.QuestionnaireLabels= new schemasMicrosoft0310Serializat_all.ArrayOfstring();
                response_x.GetQuestionnaireDetailSummaryResult.QuestionnaireLabels.string_x= new List<string>();
                response_x.GetQuestionnaireDetailSummaryResult.QuestionnaireLabels.string_x.add('Label 1');
                response_x.GetQuestionnaireDetailSummaryResult.QuestionnaireLabels.string_x.add('Label 2');
                response_x.GetQuestionnaireDetailSummaryResult.QuestionnaireLabels.string_x.add('Label 3');
                response_x.GetQuestionnaireDetailSummaryResult.Details.QuestionnaireDetailValues= new List<wwwViadComV1_all.QuestionnaireDetailValues>();
                wwwViadComV1_all.QuestionnaireDetailValues tempVal= new wwwViadComV1_all.QuestionnaireDetailValues();
                tempVal.QuestionnaireValues= new schemasMicrosoft0310Serializat_all.ArrayOfstring();
                tempVal.QuestionnaireValues.string_x = new List<string>();
                tempVal.QuestionnaireValues.string_x.add('Value 1');
                tempVal.QuestionnaireValues.string_x.add('Value 2');
                tempVal.QuestionnaireValues.string_x.add('Value 3');
                tempVal.RegistrationChecklistTaskId=111;
                wwwViadComV1_all.QuestionnaireDetailValues tempVal2= new wwwViadComV1_all.QuestionnaireDetailValues();
                tempVal2.QuestionnaireValues= new schemasMicrosoft0310Serializat_all.ArrayOfstring();
                tempVal2.QuestionnaireValues.string_x = new List<string>();
                tempVal2.QuestionnaireValues.string_x.add('Value 4');
                tempVal2.QuestionnaireValues.string_x.add('Value 5');
                tempVal2.QuestionnaireValues.string_x.add('Value 6');
                tempVal2.RegistrationChecklistTaskId=222;
                response_x.GetQuestionnaireDetailSummaryResult.Details.QuestionnaireDetailValues.add(tempVal);
                response_x.GetQuestionnaireDetailSummaryResult.Details.QuestionnaireDetailValues.add(tempVal2);
                response.put( 'response_x', response_x);
            }
        }
}