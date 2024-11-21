/**************************************
Author          : Mohd Sajid
Release         : April 18, 2023
Created         : April 10, 2023
Functionality   : this class covers to wwwViadComV1_ExhibitorService
Itrack#   		: sfdc-202

Modification History:
Itrack#        Date                Author                         Change  
****************************************************************************

***********************************************************************************/

@isTest
public class wwwViadComV1_ExhibitorServiceTest {

    @isTest(SeeAllData=true)
    static  void wwwViadComV1_ExhibitorServiceMethodTest() {
        wwwViadComV1_ExhibitorService exhibitorService= new wwwViadComV1_ExhibitorService();
        wwwViadComV1_ExhibitorService.RegistrationChecklistStatusDetail rcsd = new wwwViadComV1_ExhibitorService.RegistrationChecklistStatusDetail();
        wwwViadComV1_ExhibitorService.Customer c = new wwwViadComV1_ExhibitorService.Customer();
        wwwViadComV1_ExhibitorService.QuestionnaireDetail qd= new wwwViadComV1_ExhibitorService.QuestionnaireDetail();
        wwwViadComV1_ExhibitorService.ArrayOfQuestionnaireDetail aqd = new wwwViadComV1_ExhibitorService.ArrayOfQuestionnaireDetail();
        wwwViadComV1_ExhibitorService.ExhibitorOrderTypeStatus eots= new wwwViadComV1_ExhibitorService.ExhibitorOrderTypeStatus();
        wwwViadComV1_ExhibitorService.EAC eac = new wwwViadComV1_ExhibitorService.EAC();
        wwwViadComV1_ExhibitorService.StatementSummary st= new wwwViadComV1_ExhibitorService.StatementSummary();
        wwwViadComV1_ExhibitorService.ShowInstanceChecklistItem si = new wwwViadComV1_ExhibitorService.ShowInstanceChecklistItem();
        wwwViadComV1_ExhibitorService.OrderProgressSummary op= new wwwViadComV1_ExhibitorService.OrderProgressSummary();
        wwwViadComV1_ExhibitorService.Booth bo= new wwwViadComV1_ExhibitorService.Booth();
        wwwViadComV1_ExhibitorService.ExhibitorListItem ex= new wwwViadComV1_ExhibitorService.ExhibitorListItem();
        wwwViadComV1_ExhibitorService.ExhibitorSummary exs= new wwwViadComV1_ExhibitorService.ExhibitorSummary();
        wwwViadComV1_ExhibitorService.Facility fc= new wwwViadComV1_ExhibitorService.Facility();
        wwwViadComV1_ExhibitorService.Questionnaire qu= new wwwViadComV1_ExhibitorService.Questionnaire();
        wwwViadComV1_ExhibitorService.BoothFlags bfl= new wwwViadComV1_ExhibitorService.BoothFlags();
        wwwViadComV1_ExhibitorService.ShowFormProgress sfp= new wwwViadComV1_ExhibitorService.ShowFormProgress();
        wwwViadComV1_ExhibitorService.ExhibitorInfo exh= new wwwViadComV1_ExhibitorService.ExhibitorInfo();
        wwwViadComV1_ExhibitorService.Certificate cr = new wwwViadComV1_ExhibitorService.Certificate();
        wwwViadComV1_ExhibitorService.RegistrationChecklistTask rsct= new wwwViadComV1_ExhibitorService.RegistrationChecklistTask();
        wwwViadComV1_ExhibitorService.PaymentTerms pt= new wwwViadComV1_ExhibitorService.PaymentTerms();
        wwwViadComV1_ExhibitorService.ThirdParty tp= new wwwViadComV1_ExhibitorService.ThirdParty();
        wwwViadComV1_ExhibitorService.Zone nn= new wwwViadComV1_ExhibitorService.Zone();
        wwwViadComV1_ExhibitorService.CreditCard cc= new wwwViadComV1_ExhibitorService.CreditCard();
        wwwViadComV1_ExhibitorService.ExhibitorChecklistStatus excs= new wwwViadComV1_ExhibitorService.ExhibitorChecklistStatus();
        wwwViadComV1_ExhibitorService.BoothSummary bs= new wwwViadComV1_ExhibitorService.BoothSummary();
        wwwViadComV1_ExhibitorService.BillingCategory bc= new wwwViadComV1_ExhibitorService.BillingCategory();
        
        wwwViadComV1_ExhibitorService.BasicHttpBinding_IExhibitorService basicClassVariable = new wwwViadComV1_ExhibitorService.BasicHttpBinding_IExhibitorService();
        
        
        Test.setMock(WebServiceMock.class, new wwwViadComV1_ExhibitorServiceMockImp());
        basicClassVariable.GetShowStatement('session34345dfdff',2342434);
        basicClassVariable.GetExhibitor('session34345dfdff',2342434);
        basicClassVariable.GetExhibitorOrderProgress('session34345dfdff','prj1234567');
        basicClassVariable.SearchExhibitorsByShowOccr('applicationSessionId', 1221222, 'criteria', 111111, 2222222);
        basicClassVariable.CreateExhibitorBooth('applicationSessionId', 'customerNumber', 'exhibitorName', 1111111, 'boothNumber', 10, 20, 30, 'status1', 'status2', 'status3', 'status4', 'status5', true, 'firstName', 'lastName', '3453454355', '5432333', 'test@test.com');
        basicClassVariable.ListStatementsByShowCustomer('applicationSessionId', 12121222);
        basicClassVariable.ListQuestionnairesByBooths('applicationSessionId', new schemasMicrosoftCom200310Serializat_ES.ArrayOfint(),true);
        basicClassVariable.GetExhibitorChangesByProject('applicationSessionId', 1111, Datetime.newInstance(2021, 4, 8));
        basicClassVariable.SearchExhibitorsByShowOccrAndZone('applicationSessionId', 11111, 'criteria', 'opsZone', 'svcZone', 11111, 22222);
        basicClassVariable.AddUpdateFlooringMissing('applicationSessionId', 111111, 'Username', new wwwViadComV1_ExhibitorService.ArrayOfBoothFlags());
        basicClassVariable.AddBoothContact('applicationSessionId', 111111, 'firstName', 'lastName', 'emailAddress@test.com', '234234324');
        basicClassVariable.SearchExhibitorListByShowProject( 'applicationSessionId', 11111, 'criteria', 11, 33333);
        basicClassVariable.SearchExhibitorsByShowProjectAndZone( 'applicationSessionId', 111111, 'criteria', 'opsZone', 'svcZone', 11, 222);
        basicClassVariable.SearchExhibitorListByShowOccr('applicationSessionId', 1111111, 'criteria',1, 500);
        basicClassVariable.GetExhibitorByBooth('session34345dfdff',1234567);
        basicClassVariable.ListStatementsByReferenceNumber('session34345dfdff',1234567);
        basicClassVariable.GetShowInstanceChecklistItems('session34345dfdff','prj1234567');
        
        basicClassVariable.SearchExhibitorsByShowProject( 'applicationSessionId', 111111, 'criteria', 111, 33333);
        basicClassVariable.GetExhibitorFormProgress( 'applicationSessionId', 'projectNumber');
        basicClassVariable.GetAllQuestionnaireDetails( 'appSessionId', new schemasMicrosoftCom200310Serializat_ES.ArrayOfint());
        basicClassVariable.EmailShowStatements( 'applicationSessionId', new schemasMicrosoftCom200310Serializat_ES.ArrayOfint() , new schemasMicrosoftCom200310Serializat_ES.ArrayOfstring() , new schemasMicrosoftCom200310Serializat_ES.ArrayOfstring(), new schemasMicrosoftCom200310Serializat_ES.ArrayOfstring() , 'subject', 'htmlMessage', 'textMessage');
        basicClassVariable.AddUpdateNSL( 'applicationSessionId', 111111, 'UserName', new wwwViadComV1_ExhibitorService.ArrayOfBoothFlags());
        basicClassVariable.AddShowSiteContact( 'applicationSessionId', new wwwViadComV1_ExhibitorService.CustomerContact());
        basicClassVariable.ListStatementsByCustomerNumbers( 'applicationSessionId', new schemasMicrosoftCom200310Serializat_ES.ArrayOfint());
        basicClassVariable.UpdateShowSiteContact( 'applicationSessionId', new wwwViadComV1_ExhibitorService.CustomerContact());
        basicClassVariable.GetExhibitorChecklistStatus( 'applicationSessionId', 'projectNumber');
        basicClassVariable.ListStatementsByCustomerNumber( 'applicationSessionId', 'customerNumber');
        basicClassVariable.GetExhibitorChangesAll( 'applicationSessionId',Datetime.newInstance(2021, 4, 8));
        basicClassVariable.ListStatementsByProject( 'applicationSessionId', 111111, 9999);
        basicClassVariable.GetExhibitorOrderTypeStatus( 'applicationSessionId', 'projectNumber', Datetime.newInstance(2021, 4, 8),Datetime.newInstance(2021, 4, 8));
        basicClassVariable.GetRegistrationChecklistTaskDetails( 'applicationSessionId', 1111);
        basicClassVariable.GetShowsiteBoothFlagsByProject( 'applicationSessionId', 1111);
        basicClassVariable.ListQuestionnairesByShowCustomer( 'applicationSessionId', 111, true);
        basicClassVariable.GetQuestionnaireDetailSummary( 'appSessionId', new schemasMicrosoftCom200310Serializat_ES.ArrayOfint());
        basicClassVariable.GetExhibitorsByProject( 'applicationSessionId', 111111);
        basicClassVariable.GetShowsiteBoothFlagsByZone( 'applicationSessionId', 11111, 'Zone', true);
        basicClassVariable.GetRegistrationChecklistTasks( 'applicationSessionId', 11111);
        basicClassVariable.AddUpdateNoSignsOfLife( 'applicationSessionId', 111111, 'BoothNumber', true, 'UserName');
        basicClassVariable.AddUpdateFlooringMissingNSL( 'applicationSessionId', 11111, 'BoothNumber', true, 'Username');
        
        
    }
}