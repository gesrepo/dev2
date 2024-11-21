/**************************************
Author          : Mohd Sajid
Release         : April 18, 2023
Created         : April 10, 2023
Functionality   : this class creats test data for wwwViadComV1_ExhibitorServiceTest
Itrack#   		: sfdc-202

Modification History:
Itrack#        Date                Author                         Change  
****************************************************************************

***********************************************************************************/

@isTest
public class wwwViadComV1_ExhibitorServiceMockImp implements WebServiceMock{
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
            
            
            if(request instanceOf wwwViadComV1_ExhibitorService.GetShowStatement_element) {
                wwwViadComV1_ExhibitorService.GetShowStatementResponse_element response_x= new wwwViadComV1_ExhibitorService.GetShowStatementResponse_element();
                response_x.GetShowStatementResult = 'AddShowSiteContact'; 
                Map<String, wwwViadComV1_ExhibitorService.GetShowStatementResponse_element> response_map_x = new Map<String, wwwViadComV1_ExhibitorService.GetShowStatementResponse_element>();
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            
            if(request instanceOf wwwViadComV1_ExhibitorService.GetExhibitor_element) {
                wwwViadComV1_ExhibitorService.GetExhibitorResponse_element response_x= new wwwViadComV1_ExhibitorService.GetExhibitorResponse_element();
                response_x.GetExhibitorResult = new wwwViadComV1_ExhibitorService.Exhibitor();
                Map<String, wwwViadComV1_ExhibitorService.GetExhibitorResponse_element> response_map_x = new Map<String, wwwViadComV1_ExhibitorService.GetExhibitorResponse_element>();
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
			
			if(request instanceOf wwwViadComV1_ExhibitorService.GetExhibitorOrderProgress_element) {
                wwwViadComV1_ExhibitorService.GetExhibitorOrderProgressResponse_element response_x= new wwwViadComV1_ExhibitorService.GetExhibitorOrderProgressResponse_element();
                response_x.GetExhibitorOrderProgressResult = new wwwViadComV1_ExhibitorService.ShowInstanceOrderProgress();
                response_x.GetExhibitorOrderProgressResult.ExhibitorsWithoutOrders = new wwwViadComV1_ExhibitorService.ArrayOfExhibitorInfo();
                response_x.GetExhibitorOrderProgressResult.ExhibitorsWithoutOrders.ExhibitorInfo = new List<wwwViadComV1_ExhibitorService.ExhibitorInfo>();    
                Map<String, wwwViadComV1_ExhibitorService.GetExhibitorOrderProgressResponse_element> response_map_x = new Map<String, wwwViadComV1_ExhibitorService.GetExhibitorOrderProgressResponse_element>();
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }

            if(request instanceOf wwwViadComV1_ExhibitorService.SearchExhibitorsByShowOccr_element) {
                wwwViadComV1_ExhibitorService.SearchExhibitorsByShowOccrResponse_element response_x= new wwwViadComV1_ExhibitorService.SearchExhibitorsByShowOccrResponse_element();
                response_x.SearchExhibitorsByShowOccrResult = new wwwViadComV1_ExhibitorService.ArrayOfExhibitorSummary();
                Map<String, wwwViadComV1_ExhibitorService.SearchExhibitorsByShowOccrResponse_element> response_map_x = new Map<String, wwwViadComV1_ExhibitorService.SearchExhibitorsByShowOccrResponse_element>();
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            
            if(request instanceOf wwwViadComV1_ExhibitorService.CreateExhibitorBooth_element) {
                wwwViadComV1_ExhibitorService.CreateExhibitorBoothResponse_element response_x= new wwwViadComV1_ExhibitorService.CreateExhibitorBoothResponse_element();
                response_x.CreateExhibitorBoothResult = new wwwViadComV1_ExhibitorService.Exhibitor();
                Map<String, wwwViadComV1_ExhibitorService.CreateExhibitorBoothResponse_element> response_map_x = new Map<String, wwwViadComV1_ExhibitorService.CreateExhibitorBoothResponse_element>();
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            
            if(request instanceOf wwwViadComV1_ExhibitorService.ListStatementsByShowCustomer_element) {
                wwwViadComV1_ExhibitorService.ListStatementsByShowCustomerResponse_element response_x= new wwwViadComV1_ExhibitorService.ListStatementsByShowCustomerResponse_element();
                response_x.ListStatementsByShowCustomerResult = new wwwViadComV1_ExhibitorService.ArrayOfStatementSummary();
                Map<String, wwwViadComV1_ExhibitorService.ListStatementsByShowCustomerResponse_element> response_map_x = new Map<String, wwwViadComV1_ExhibitorService.ListStatementsByShowCustomerResponse_element>();
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            
            if(request instanceOf wwwViadComV1_ExhibitorService.ListQuestionnairesByBooths_element) {
                wwwViadComV1_ExhibitorService.ListQuestionnairesByBoothsResponse_element response_x= new wwwViadComV1_ExhibitorService.ListQuestionnairesByBoothsResponse_element();
                response_x.ListQuestionnairesByBoothsResult = new wwwViadComV1_ExhibitorService.ArrayOfQuestionnaire();
                Map<String, wwwViadComV1_ExhibitorService.ListQuestionnairesByBoothsResponse_element> response_map_x = new Map<String, wwwViadComV1_ExhibitorService.ListQuestionnairesByBoothsResponse_element>();
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            
            if(request instanceOf wwwViadComV1_ExhibitorService.GetExhibitorChangesByProject_element) {
                wwwViadComV1_ExhibitorService.GetExhibitorChangesByProjectResponse_element response_x= new wwwViadComV1_ExhibitorService.GetExhibitorChangesByProjectResponse_element();
                response_x.GetExhibitorChangesByProjectResult = new wwwViadComV1_ExhibitorService.ArrayOfExhibitor();
                Map<String, wwwViadComV1_ExhibitorService.GetExhibitorChangesByProjectResponse_element> response_map_x = new Map<String, wwwViadComV1_ExhibitorService.GetExhibitorChangesByProjectResponse_element>();
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            
            if(request instanceOf wwwViadComV1_ExhibitorService.SearchExhibitorsByShowOccrAndZone_element) {
                wwwViadComV1_ExhibitorService.SearchExhibitorsByShowOccrAndZoneResponse_element response_x= new wwwViadComV1_ExhibitorService.SearchExhibitorsByShowOccrAndZoneResponse_element();
                response_x.SearchExhibitorsByShowOccrAndZoneResult = new wwwViadComV1_ExhibitorService.ArrayOfExhibitorSummary();
                Map<String, wwwViadComV1_ExhibitorService.SearchExhibitorsByShowOccrAndZoneResponse_element> response_map_x = new Map<String, wwwViadComV1_ExhibitorService.SearchExhibitorsByShowOccrAndZoneResponse_element>();
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            
            if(request instanceOf wwwViadComV1_ExhibitorService.AddUpdateFlooringMissing_element) {
                wwwViadComV1_ExhibitorService.AddUpdateFlooringMissingResponse_element response_x= new wwwViadComV1_ExhibitorService.AddUpdateFlooringMissingResponse_element();
                response_x.AddUpdateFlooringMissingResult = true;
                Map<String, wwwViadComV1_ExhibitorService.AddUpdateFlooringMissingResponse_element> response_map_x = new Map<String, wwwViadComV1_ExhibitorService.AddUpdateFlooringMissingResponse_element>();
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            
            if(request instanceOf wwwViadComV1_ExhibitorService.AddBoothContact_element) {
                wwwViadComV1_ExhibitorService.AddBoothContactResponse_element response_x= new wwwViadComV1_ExhibitorService.AddBoothContactResponse_element();
                response_x.AddBoothContactResult = true;
                Map<String, wwwViadComV1_ExhibitorService.AddBoothContactResponse_element> response_map_x = new Map<String, wwwViadComV1_ExhibitorService.AddBoothContactResponse_element>();
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            
            if(request instanceOf wwwViadComV1_ExhibitorService.SearchExhibitorListByShowProject_element) {
                wwwViadComV1_ExhibitorService.SearchExhibitorListByShowProjectResponse_element response_x= new wwwViadComV1_ExhibitorService.SearchExhibitorListByShowProjectResponse_element();
                response_x.SearchExhibitorListByShowProjectResult = new wwwViadComV1_ExhibitorService.ArrayOfExhibitorListItem();
                Map<String, wwwViadComV1_ExhibitorService.SearchExhibitorListByShowProjectResponse_element> response_map_x = new Map<String, wwwViadComV1_ExhibitorService.SearchExhibitorListByShowProjectResponse_element>();
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            
            if(request instanceOf wwwViadComV1_ExhibitorService.SearchExhibitorsByShowProjectAndZone_element) {
                wwwViadComV1_ExhibitorService.SearchExhibitorsByShowProjectAndZoneResponse_element response_x= new wwwViadComV1_ExhibitorService.SearchExhibitorsByShowProjectAndZoneResponse_element();
                response_x.SearchExhibitorsByShowProjectAndZoneResult = new wwwViadComV1_ExhibitorService.ArrayOfExhibitorSummary();
                Map<String, wwwViadComV1_ExhibitorService.SearchExhibitorsByShowProjectAndZoneResponse_element> response_map_x = new Map<String, wwwViadComV1_ExhibitorService.SearchExhibitorsByShowProjectAndZoneResponse_element>();
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            
            if(request instanceOf wwwViadComV1_ExhibitorService.SearchExhibitorListByShowOccr_element) {
                wwwViadComV1_ExhibitorService.SearchExhibitorListByShowOccrResponse_element response_x= new wwwViadComV1_ExhibitorService.SearchExhibitorListByShowOccrResponse_element();
                response_x.SearchExhibitorListByShowOccrResult = new wwwViadComV1_ExhibitorService.ArrayOfExhibitorListItem();
                Map<String, wwwViadComV1_ExhibitorService.SearchExhibitorListByShowOccrResponse_element> response_map_x = new Map<String, wwwViadComV1_ExhibitorService.SearchExhibitorListByShowOccrResponse_element>();
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            
            if(request instanceOf wwwViadComV1_ExhibitorService.GetExhibitorByBooth_element) {
                wwwViadComV1_ExhibitorService.GetExhibitorByBoothResponse_element response_x= new wwwViadComV1_ExhibitorService.GetExhibitorByBoothResponse_element();
                response_x.GetExhibitorByBoothResult = new wwwViadComV1_ExhibitorService.Exhibitor();
                Map<String, wwwViadComV1_ExhibitorService.GetExhibitorByBoothResponse_element> response_map_x = new Map<String, wwwViadComV1_ExhibitorService.GetExhibitorByBoothResponse_element>();
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            
            if(request instanceOf wwwViadComV1_ExhibitorService.ListStatementsByReferenceNumber_element) {
                wwwViadComV1_ExhibitorService.ListStatementsByReferenceNumberResponse_element response_x= new wwwViadComV1_ExhibitorService.ListStatementsByReferenceNumberResponse_element();
                response_x.ListStatementsByReferenceNumberResult = new wwwViadComV1_ExhibitorService.ArrayOfStatementSummary();
                Map<String, wwwViadComV1_ExhibitorService.ListStatementsByReferenceNumberResponse_element> response_map_x = new Map<String, wwwViadComV1_ExhibitorService.ListStatementsByReferenceNumberResponse_element>();
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            
            if(request instanceOf wwwViadComV1_ExhibitorService.GetShowInstanceChecklistItems_element) {
                wwwViadComV1_ExhibitorService.GetShowInstanceChecklistItemsResponse_element response_x= new wwwViadComV1_ExhibitorService.GetShowInstanceChecklistItemsResponse_element();
                response_x.GetShowInstanceChecklistItemsResult = new wwwViadComV1_ExhibitorService.ArrayOfShowInstanceChecklistItem();
                Map<String, wwwViadComV1_ExhibitorService.GetShowInstanceChecklistItemsResponse_element> response_map_x = new Map<String, wwwViadComV1_ExhibitorService.GetShowInstanceChecklistItemsResponse_element>();
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            
            if(request instanceOf wwwViadComV1_ExhibitorService.SearchExhibitorsByShowProject_element) {
                wwwViadComV1_ExhibitorService.SearchExhibitorsByShowProjectResponse_element response_x= new wwwViadComV1_ExhibitorService.SearchExhibitorsByShowProjectResponse_element();
                response_x.SearchExhibitorsByShowProjectResult = new wwwViadComV1_ExhibitorService.ArrayOfExhibitorSummary();
                Map<String, wwwViadComV1_ExhibitorService.SearchExhibitorsByShowProjectResponse_element> response_map_x = new Map<String, wwwViadComV1_ExhibitorService.SearchExhibitorsByShowProjectResponse_element>();
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            
            if(request instanceOf wwwViadComV1_ExhibitorService.GetExhibitorFormProgress_element) {
                wwwViadComV1_ExhibitorService.GetExhibitorFormProgressResponse_element response_x= new wwwViadComV1_ExhibitorService.GetExhibitorFormProgressResponse_element();
                response_x.GetExhibitorFormProgressResult = new wwwViadComV1_ExhibitorService.ShowFormProgressStatus();
                Map<String, wwwViadComV1_ExhibitorService.GetExhibitorFormProgressResponse_element> response_map_x = new Map<String, wwwViadComV1_ExhibitorService.GetExhibitorFormProgressResponse_element>();
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            
            if(request instanceOf wwwViadComV1_ExhibitorService.GetAllQuestionnaireDetails_element) {
                wwwViadComV1_ExhibitorService.GetAllQuestionnaireDetailsResponse_element response_x= new wwwViadComV1_ExhibitorService.GetAllQuestionnaireDetailsResponse_element();
                response_x.GetAllQuestionnaireDetailsResult = new wwwViadComV1_ExhibitorService.ArrayOfRegistrationChecklistTaskDetails();
                Map<String, wwwViadComV1_ExhibitorService.GetAllQuestionnaireDetailsResponse_element> response_map_x = new Map<String, wwwViadComV1_ExhibitorService.GetAllQuestionnaireDetailsResponse_element>();
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            
            if(request instanceOf wwwViadComV1_ExhibitorService.EmailShowStatements_element) {
                wwwViadComV1_ExhibitorService.EmailShowStatementsResponse_element response_x= new wwwViadComV1_ExhibitorService.EmailShowStatementsResponse_element();
                Map<String, wwwViadComV1_ExhibitorService.EmailShowStatementsResponse_element> response_map_x = new Map<String, wwwViadComV1_ExhibitorService.EmailShowStatementsResponse_element>();
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            
            if(request instanceOf wwwViadComV1_ExhibitorService.AddUpdateNSL_element) {
                wwwViadComV1_ExhibitorService.AddUpdateNSLResponse_element response_x= new wwwViadComV1_ExhibitorService.AddUpdateNSLResponse_element();
                response_x.AddUpdateNSLResult = true;
                Map<String, wwwViadComV1_ExhibitorService.AddUpdateNSLResponse_element> response_map_x = new Map<String, wwwViadComV1_ExhibitorService.AddUpdateNSLResponse_element>();
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            
            if(request instanceOf wwwViadComV1_ExhibitorService.AddShowSiteContact_element) {
                wwwViadComV1_ExhibitorService.AddShowSiteContactResponse_element response_x= new wwwViadComV1_ExhibitorService.AddShowSiteContactResponse_element();
                response_x.AddShowSiteContactResult = 111111;
                Map<String, wwwViadComV1_ExhibitorService.AddShowSiteContactResponse_element> response_map_x = new Map<String, wwwViadComV1_ExhibitorService.AddShowSiteContactResponse_element>();
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            
            if(request instanceOf wwwViadComV1_ExhibitorService.ListStatementsByCustomerNumbers_element) {
                wwwViadComV1_ExhibitorService.ListStatementsByCustomerNumbersResponse_element response_x= new wwwViadComV1_ExhibitorService.ListStatementsByCustomerNumbersResponse_element();
                response_x.ListStatementsByCustomerNumbersResult = new wwwViadComV1_ExhibitorService.ArrayOfStatementSummary();
                Map<String, wwwViadComV1_ExhibitorService.ListStatementsByCustomerNumbersResponse_element> response_map_x = new Map<String, wwwViadComV1_ExhibitorService.ListStatementsByCustomerNumbersResponse_element>();
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            
            if(request instanceOf wwwViadComV1_ExhibitorService.UpdateShowSiteContact_element) {
                wwwViadComV1_ExhibitorService.UpdateShowSiteContactResponse_element response_x= new wwwViadComV1_ExhibitorService.UpdateShowSiteContactResponse_element();
                response_x.UpdateShowSiteContactResult = true;
                Map<String, wwwViadComV1_ExhibitorService.UpdateShowSiteContactResponse_element> response_map_x = new Map<String, wwwViadComV1_ExhibitorService.UpdateShowSiteContactResponse_element>();
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            
            if(request instanceOf wwwViadComV1_ExhibitorService.GetExhibitorChecklistStatus_element) {
                wwwViadComV1_ExhibitorService.GetExhibitorChecklistStatusResponse_element response_x= new wwwViadComV1_ExhibitorService.GetExhibitorChecklistStatusResponse_element();
                response_x.GetExhibitorChecklistStatusResult = new wwwViadComV1_ExhibitorService.ArrayOfExhibitorChecklistStatus();
                Map<String, wwwViadComV1_ExhibitorService.GetExhibitorChecklistStatusResponse_element> response_map_x = new Map<String, wwwViadComV1_ExhibitorService.GetExhibitorChecklistStatusResponse_element>();
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            
            if(request instanceOf wwwViadComV1_ExhibitorService.ListStatementsByCustomerNumber_element) {
                wwwViadComV1_ExhibitorService.ListStatementsByCustomerNumberResponse_element response_x= new wwwViadComV1_ExhibitorService.ListStatementsByCustomerNumberResponse_element();
                response_x.ListStatementsByCustomerNumberResult = new wwwViadComV1_ExhibitorService.ArrayOfStatementSummary();
                Map<String, wwwViadComV1_ExhibitorService.ListStatementsByCustomerNumberResponse_element> response_map_x = new Map<String, wwwViadComV1_ExhibitorService.ListStatementsByCustomerNumberResponse_element>();
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            
            if(request instanceOf wwwViadComV1_ExhibitorService.GetExhibitorChangesAll_element) {
                wwwViadComV1_ExhibitorService.GetExhibitorChangesAllResponse_element response_x= new wwwViadComV1_ExhibitorService.GetExhibitorChangesAllResponse_element();
                response_x.GetExhibitorChangesAllResult = new wwwViadComV1_ExhibitorService.ArrayOfExhibitor();
                Map<String, wwwViadComV1_ExhibitorService.GetExhibitorChangesAllResponse_element> response_map_x = new Map<String, wwwViadComV1_ExhibitorService.GetExhibitorChangesAllResponse_element>();
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            
            if(request instanceOf wwwViadComV1_ExhibitorService.ListStatementsByProject_element) {
                wwwViadComV1_ExhibitorService.ListStatementsByProjectResponse_element response_x= new wwwViadComV1_ExhibitorService.ListStatementsByProjectResponse_element();
                response_x.ListStatementsByProjectResult = new wwwViadComV1_ExhibitorService.ArrayOfStatementSummary();
                Map<String, wwwViadComV1_ExhibitorService.ListStatementsByProjectResponse_element> response_map_x = new Map<String, wwwViadComV1_ExhibitorService.ListStatementsByProjectResponse_element>();
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            
            if(request instanceOf wwwViadComV1_ExhibitorService.GetExhibitorOrderTypeStatus_element) {
                wwwViadComV1_ExhibitorService.GetExhibitorOrderTypeStatusResponse_element response_x= new wwwViadComV1_ExhibitorService.GetExhibitorOrderTypeStatusResponse_element();
                response_x.GetExhibitorOrderTypeStatusResult = new wwwViadComV1_ExhibitorService.ArrayOfExhibitorOrderTypeStatus();
                Map<String, wwwViadComV1_ExhibitorService.GetExhibitorOrderTypeStatusResponse_element> response_map_x = new Map<String, wwwViadComV1_ExhibitorService.GetExhibitorOrderTypeStatusResponse_element>();
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            
            if(request instanceOf wwwViadComV1_ExhibitorService.GetRegistrationChecklistTaskDetails_element) {
                wwwViadComV1_ExhibitorService.GetRegistrationChecklistTaskDetailsResponse_element response_x= new wwwViadComV1_ExhibitorService.GetRegistrationChecklistTaskDetailsResponse_element();
                response_x.GetRegistrationChecklistTaskDetailsResult = new wwwViadComV1_ExhibitorService.RegistrationChecklistTaskDetails();
                Map<String, wwwViadComV1_ExhibitorService.GetRegistrationChecklistTaskDetailsResponse_element> response_map_x = new Map<String, wwwViadComV1_ExhibitorService.GetRegistrationChecklistTaskDetailsResponse_element>();
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            if(request instanceOf wwwViadComV1_ExhibitorService.GetShowsiteBoothFlagsByProject_element) {
                wwwViadComV1_ExhibitorService.GetShowsiteBoothFlagsByProjectResponse_element response_x= new wwwViadComV1_ExhibitorService.GetShowsiteBoothFlagsByProjectResponse_element();
                response_x.GetShowsiteBoothFlagsByProjectResult = new wwwViadComV1_ExhibitorService.ArrayOfBoothFlags();
                Map<String, wwwViadComV1_ExhibitorService.GetShowsiteBoothFlagsByProjectResponse_element> response_map_x = new Map<String, wwwViadComV1_ExhibitorService.GetShowsiteBoothFlagsByProjectResponse_element>();
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            
            if(request instanceOf wwwViadComV1_ExhibitorService.ListQuestionnairesByShowCustomer_element) {
                wwwViadComV1_ExhibitorService.ListQuestionnairesByShowCustomerResponse_element response_x= new wwwViadComV1_ExhibitorService.ListQuestionnairesByShowCustomerResponse_element();
                response_x.ListQuestionnairesByShowCustomerResult = new wwwViadComV1_ExhibitorService.ArrayOfQuestionnaire();
                Map<String, wwwViadComV1_ExhibitorService.ListQuestionnairesByShowCustomerResponse_element> response_map_x = new Map<String, wwwViadComV1_ExhibitorService.ListQuestionnairesByShowCustomerResponse_element>();
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            
            if(request instanceOf wwwViadComV1_ExhibitorService.GetQuestionnaireDetailSummary_element) {
                wwwViadComV1_ExhibitorService.GetQuestionnaireDetailSummaryResponse_element response_x= new wwwViadComV1_ExhibitorService.GetQuestionnaireDetailSummaryResponse_element();
                response_x.GetQuestionnaireDetailSummaryResult = new wwwViadComV1_ExhibitorService.QuestionnaireDetailSummary();
                Map<String, wwwViadComV1_ExhibitorService.GetQuestionnaireDetailSummaryResponse_element> response_map_x = new Map<String, wwwViadComV1_ExhibitorService.GetQuestionnaireDetailSummaryResponse_element>();
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            
            if(request instanceOf wwwViadComV1_ExhibitorService.GetExhibitorsByProject_element) {
                wwwViadComV1_ExhibitorService.GetExhibitorsByProjectResponse_element response_x= new wwwViadComV1_ExhibitorService.GetExhibitorsByProjectResponse_element();
                response_x.GetExhibitorsByProjectResult = new wwwViadComV1_ExhibitorService.ArrayOfExhibitor();
                Map<String, wwwViadComV1_ExhibitorService.GetExhibitorsByProjectResponse_element> response_map_x = new Map<String, wwwViadComV1_ExhibitorService.GetExhibitorsByProjectResponse_element>();
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            
            if(request instanceOf wwwViadComV1_ExhibitorService.GetShowsiteBoothFlagsByZone_element) {
                wwwViadComV1_ExhibitorService.GetShowsiteBoothFlagsByZoneResponse_element response_x= new wwwViadComV1_ExhibitorService.GetShowsiteBoothFlagsByZoneResponse_element();
                response_x.GetShowsiteBoothFlagsByZoneResult = new wwwViadComV1_ExhibitorService.ArrayOfBoothFlags();
                Map<String, wwwViadComV1_ExhibitorService.GetShowsiteBoothFlagsByZoneResponse_element> response_map_x = new Map<String, wwwViadComV1_ExhibitorService.GetShowsiteBoothFlagsByZoneResponse_element>();
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            
            if(request instanceOf wwwViadComV1_ExhibitorService.GetRegistrationChecklistTasks_element) {
                wwwViadComV1_ExhibitorService.GetRegistrationChecklistTasksResponse_element response_x= new wwwViadComV1_ExhibitorService.GetRegistrationChecklistTasksResponse_element();
                response_x.GetRegistrationChecklistTasksResult = new wwwViadComV1_ExhibitorService.ShowInstanceChecklistTasks();
                Map<String, wwwViadComV1_ExhibitorService.GetRegistrationChecklistTasksResponse_element> response_map_x = new Map<String, wwwViadComV1_ExhibitorService.GetRegistrationChecklistTasksResponse_element>();
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            
            if(request instanceOf wwwViadComV1_ExhibitorService.AddUpdateNoSignsOfLife_element) {
                wwwViadComV1_ExhibitorService.AddUpdateNoSignsOfLifeResponse_element response_x= new wwwViadComV1_ExhibitorService.AddUpdateNoSignsOfLifeResponse_element();
                response_x.AddUpdateNoSignsOfLifeResult = true;
                Map<String, wwwViadComV1_ExhibitorService.AddUpdateNoSignsOfLifeResponse_element> response_map_x = new Map<String, wwwViadComV1_ExhibitorService.AddUpdateNoSignsOfLifeResponse_element>();
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            }
            
            if(request instanceOf wwwViadComV1_ExhibitorService.AddUpdateFlooringMissingNSL_element) {
                wwwViadComV1_ExhibitorService.AddUpdateFlooringMissingNSLResponse_element response_x= new wwwViadComV1_ExhibitorService.AddUpdateFlooringMissingNSLResponse_element();
                response_x.AddUpdateFlooringMissingNSLResult = true;
                Map<String, wwwViadComV1_ExhibitorService.AddUpdateFlooringMissingNSLResponse_element> response_map_x = new Map<String, wwwViadComV1_ExhibitorService.AddUpdateFlooringMissingNSLResponse_element>();
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put( 'response_x', response_x);
            } 
        }
}