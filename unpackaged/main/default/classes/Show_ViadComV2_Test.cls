@isTest
public class Show_ViadComV2_Test {
    public static testMethod void testMethods() {
        Show_ViadComV2.GetBoothZoneList_element GetBoothZoneList= new  Show_ViadComV2.GetBoothZoneList_element();
        Show_ViadComV2.GetBoothZoneListResponse_element GetBoothZoneListResponse=new  Show_ViadComV2.GetBoothZoneListResponse_element();
        Show_ViadComV2.SearchShowOccurrences_element SearchShowOccurrences= new  Show_ViadComV2.SearchShowOccurrences_element();
        Show_ViadComV2.SearchShowOccurrencesResponse_element SearchShowOccurrencesResponse=new  Show_ViadComV2.SearchShowOccurrencesResponse_element();
        Show_ViadComV2.GetShowNotes_element GetShowNotes= new  Show_ViadComV2.GetShowNotes_element();
        Show_ViadComV2.GetShowNotesResponse_element GetShowNotesResponse=new  Show_ViadComV2.GetShowNotesResponse_element();
        Show_ViadComV2.SearchShowProjects_element SearchShowProjects= new  Show_ViadComV2.SearchShowProjects_element();
        Show_ViadComV2.SearchShowProjectsResponse_element SearchShowProjectsResponse=new  Show_ViadComV2.SearchShowProjectsResponse_element();
        Show_ViadComV2.GetShowProject_element GetShowProject= new  Show_ViadComV2.GetShowProject_element();
        Show_ViadComV2.GetShowProjectResponse_element GetShowProjectResponse=new  Show_ViadComV2.GetShowProjectResponse_element();
        Show_ViadComV2.SetShowNote_element SetShowNote= new  Show_ViadComV2.SetShowNote_element();
        Show_ViadComV2.SetShowNoteResponse_element SetShowNoteResponse=new  Show_ViadComV2.SetShowNoteResponse_element();
        Show_ViadComV2.SearchActiveShowOccurrences_element SearchActiveShowOccurrences= new  Show_ViadComV2.SearchActiveShowOccurrences_element();
        Show_ViadComV2.SearchActiveShowOccurrencesResponse_element SearchActiveShowOccurrencesResponse=new  Show_ViadComV2.SearchActiveShowOccurrencesResponse_element();
        Show_ViadComV2.GetMultipleShowFeatureSchedules_element GetMultipleShowFeatureSchedules= new  Show_ViadComV2.GetMultipleShowFeatureSchedules_element();
        Show_ViadComV2.GetMultipleShowFeatureSchedulesResponse_element GetMultipleShowFeatureSchedulesResponse=new  Show_ViadComV2.GetMultipleShowFeatureSchedulesResponse_element();
        Show_ViadComV2.GetMultipleShowFeatureSchedule_element GetMultipleShowFeatureSchedule= new  Show_ViadComV2.GetMultipleShowFeatureSchedule_element();
        Show_ViadComV2.GetMultipleShowFeatureScheduleResponse_element GetMultipleShowFeatureScheduleResponse=new  Show_ViadComV2.GetMultipleShowFeatureScheduleResponse_element();
        Show_ViadComV2.GetShowFeatureSchedules_element GetShowFeatureSchedules= new  Show_ViadComV2.GetShowFeatureSchedules_element();
        Show_ViadComV2.GetShowFeatureSchedulesResponse_element GetShowFeatureSchedulesResponse=new  Show_ViadComV2.GetShowFeatureSchedulesResponse_element();
        Show_ViadComV2.SearchCoreShowProjects_element SearchCoreShowProjects= new  Show_ViadComV2.SearchCoreShowProjects_element();
        Show_ViadComV2.SearchCoreShowProjectsResponse_element SearchCoreShowProjectsResponse=new  Show_ViadComV2.SearchCoreShowProjectsResponse_element();
        Show_ViadComV2.GetShowProjectByProjectNumber_element  GetShowProjectByProjectNumber= new  Show_ViadComV2.GetShowProjectByProjectNumber_element();
        Show_ViadComV2.GetShowProjectByProjectNumberResponse_element  GetShowProjectByProjectNumberResponse=new  Show_ViadComV2.GetShowProjectByProjectNumberResponse_element();
        Show_ViadComV2.GetShowFeatureSchedule_element  GetShowFeatureSchedule= new  Show_ViadComV2.GetShowFeatureSchedule_element();
        Show_ViadComV2.GetShowFeatureScheduleResponse_element  GetShowFeatureScheduleResponse=new  Show_ViadComV2.GetShowFeatureScheduleResponse_element();
        Show_ViadComV2.SearchActiveShowProjects_element  SearchActiveShowProjects= new  Show_ViadComV2.SearchActiveShowProjects_element();
        Show_ViadComV2.SearchActiveShowProjectsResponse_element  SearchActiveShowProjectsResponse=new  Show_ViadComV2.SearchActiveShowProjectsResponse_element();
        Show_ViadComV2.ArrayOfShowProject ArrayOfShowProject=new Show_ViadComV2.ArrayOfShowProject(); 
        Show_ViadComV2.ArrayOfBoothArea ArrayOfBoothArea =new Show_ViadComV2.ArrayOfBoothArea();
        Show_ViadComV2.WeeklySchedule WeeklySchedule = new Show_ViadComV2.WeeklySchedule();
        Show_ViadComV2.GeoLocation Location = new  Show_ViadComV2.GeoLocation();
        Show_ViadComV2.PhoneSupport PhoneSupport =new Show_ViadComV2.PhoneSupport();
        Show_ViadComV2.ArrayOfShowScheduleGroup ArrayOfShowScheduleGroup=new Show_ViadComV2.ArrayOfShowScheduleGroup();
        Show_ViadComV2.ArrayOfNoteDetail ArrayOfNoteDetail =new Show_ViadComV2.ArrayOfNoteDetail();
        Show_ViadComV2.BoothArea BoothArea=new Show_ViadComV2.BoothArea();
        Show_ViadComV2.ShowOccurrence ShowOccurrence=new Show_ViadComV2.ShowOccurrence();
        Show_ViadComV2.ArrayOfShowSchedule ArrayOfShowSchedule =new Show_ViadComV2.ArrayOfShowSchedule();
        Show_ViadComV2.ArrayOfBoothZoneListItem ArrayOfBoothZoneListItem =new Show_ViadComV2.ArrayOfBoothZoneListItem();
        Show_ViadComV2.ViadImage ViadImage =new Show_ViadComV2.ViadImage();
        Show_ViadComV2.Note Note =new Show_ViadComV2.Note();
        Show_ViadComV2.NoteDetail NoteDetail =new Show_ViadComV2.NoteDetail();
        Show_ViadComV2.ShowSchedule ShowSchedule =new Show_ViadComV2.ShowSchedule();
        Show_ViadComV2.ProductionLocation ProductionLocation =new Show_ViadComV2.ProductionLocation();
        Show_ViadComV2.CoreShowProjectSummary CoreShowProjectSummary =new Show_ViadComV2.CoreShowProjectSummary();
        Show_ViadComV2.BoothZoneListItem BoothZoneListItem =new Show_ViadComV2.BoothZoneListItem();
        Show_ViadComV2.DailySchedule DailySchedule =new Show_ViadComV2.DailySchedule();
        Show_ViadComV2.ArrayOfCoreShowProjectSummary ArrayOfCoreShowProjectSummary =new Show_ViadComV2.ArrayOfCoreShowProjectSummary();
        Show_ViadComV2.ArrayOfNote ArrayOfNote =new Show_ViadComV2.ArrayOfNote();
        Show_ViadComV2.Facility Facility =new Show_ViadComV2.Facility();
        Show_ViadComV2.ShowScheduleGroup ShowScheduleGroup=new Show_ViadComV2.ShowScheduleGroup();
        Show_DatacontractOrg200407System testDatacontractOrg200407System = new Show_DatacontractOrg200407System ();
        Show_DatacontractOrg200407System.DateTimeOffset testDateTimeOffset=new Show_DatacontractOrg200407System.DateTimeOffset();
        Show_ViadComV2.BasicHttpBinding_IShowService showServiceObj= new Show_ViadComV2.BasicHttpBinding_IShowService();
       
        Test.setMock(WebServiceMock.class, new Show_ViadComV2_Mock());
        showServiceObj.GetBoothZoneList('Session001', 1);
        showServiceObj.SearchActiveShowOccurrences('S001','CR001',10,100);
        showServiceObj.GetShowNotes('S001',1,'Tag',true);
        showServiceObj.SearchShowProjects('S001','Criteria-1',Date.today(),Date.today()+4,Location,20,10,10);
        showServiceObj.GetShowProject('S001',100);
        showServiceObj.SetShowNote('S001',1,2,'Tag-1','Notes');
        showServiceObj.SearchShowOccurrences('applicationSessionId','criteria',null,null,null,null);
        showServiceObj.SearchActiveShowOccurrences('S001','Criteria',1,100);
        showServiceObj.GetMultipleShowFeatureSchedules('S001',new Show_MicrosoftCom200310Serializat.ArrayOfint());
        showServiceObj.GetMultipleShowFeatureSchedule('applicationSessionId',new Show_MicrosoftCom200310Serializat.ArrayOfint() ,'featureCode');
        showServiceObj.GetShowFeatureSchedules('S001',2);
        showServiceObj.SearchCoreShowProjects('S001','P001','Occ1','Show1');
        showServiceObj.GetShowProjectByProjectNumber('S001','P001');
        showServiceObj.GetShowFeatureSchedule('S001',2,'Cd001');
        showServiceObj.SearchActiveShowProjects('S001','Crieteria',new Show_ViadComV2.GeoLocation(),10,10,100);
        showServiceObj.GetShowOccurrence('applicationSessionId',10);
    }
    
}