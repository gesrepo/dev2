@isTest
public class Show_ViadComV2_Mock  implements WebServiceMock{
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
            if(request instanceOf Show_ViadComV2.SearchShowOccurrences_element) {
                Show_ViadComV2.SearchShowOccurrencesResponse_element response_x=new Show_ViadComV2.SearchShowOccurrencesResponse_element();
                response_x.SearchShowOccurrencesResult=new Show_ViadComV2.ArrayOfShowOccurrenceSummary();
                response_x.SearchShowOccurrencesResult.ShowOccurrenceSummary=new List<Show_ViadComV2.ShowOccurrenceSummary>();
                Show_ViadComV2.ShowOccurrenceSummary testShowOccurrenceSummary= new Show_ViadComV2.ShowOccurrenceSummary();
                testShowOccurrenceSummary.ShowOccrCode='cd001';
                testShowOccurrenceSummary.ShowProjects=new Show_ViadComV2.ArrayOfShowProjectSummary();
                testShowOccurrenceSummary.ShowProjects.ShowProjectSummary=new List<Show_ViadComV2.ShowProjectSummary>();
                Show_ViadComV2.ShowProjectSummary testShowProjectSummary=new Show_ViadComV2.ShowProjectSummary();
                testShowProjectSummary.ShowOccrProjectId=5;  
                testShowOccurrenceSummary.ShowProjects.ShowProjectSummary.add(testShowProjectSummary);
                response_x.SearchShowOccurrencesResult.ShowOccurrenceSummary.add(testShowOccurrenceSummary);
                response.put('response_x',response_x);
            }
            else if(request instanceOf Show_ViadComV2.GetBoothZoneList_element ){
                response.put('response_x',new Show_ViadComV2.GetBoothZoneListResponse_element());
            }
            else if(request instanceOf Show_ViadComV2.GetShowNotes_element){
                response.put('response_x',new Show_ViadComV2.GetShowNotesResponse_element());
            }
            else if(request instanceOf Show_ViadComV2.SearchShowProjects_element){
                response.put('response_x',new Show_ViadComV2.SearchShowProjectsResponse_element());
            }
            else if(request instanceOf Show_ViadComV2.GetShowProject_element){
                response.put('response_x',new Show_ViadComV2.GetShowProjectResponse_element());
            }
            else if(request instanceOf Show_ViadComV2.SetShowNote_element){
                response.put('response_x',new Show_ViadComV2.SetShowNoteResponse_element());
            }
            else if(request instanceOf Show_ViadComV2.SearchActiveShowOccurrences_element ){
                response.put('response_x',new Show_ViadComV2.SearchActiveShowOccurrencesResponse_element());
            }
            else if(request instanceOf Show_ViadComV2.GetMultipleShowFeatureSchedules_element){
                response.put('response_x',new Show_ViadComV2.GetMultipleShowFeatureSchedulesResponse_element());
            }
            else if(request instanceOf Show_ViadComV2.GetMultipleShowFeatureSchedule_element){
                response.put('response_x',new Show_ViadComV2.GetMultipleShowFeatureScheduleResponse_element());
            }
            else if(request instanceOf Show_ViadComV2.GetShowFeatureSchedules_element){
                Show_ViadComV2.GetShowFeatureSchedulesResponse_element response_x=new Show_ViadComV2.GetShowFeatureSchedulesResponse_element();
                response_x.GetShowFeatureSchedulesResult=new Show_ViadComV2.ArrayOfShowFeatureSchedule();
                response.put('response_x',response_x);
            }
            else if(request instanceOf Show_ViadComV2.SearchCoreShowProjects_element){
                response.put('response_x',new Show_ViadComV2.SearchCoreShowProjectsResponse_element());
            }
            else if(request instanceOf Show_ViadComV2.GetShowProjectByProjectNumber_element){
                Show_ViadComV2.GetShowProjectByProjectNumberResponse_element response_x= new Show_ViadComV2.GetShowProjectByProjectNumberResponse_element(); 
                response_x.GetShowProjectByProjectNumberResult= new Show_ViadComV2.ShowProject();
                response_x.GetShowProjectByProjectNumberResult.ProjectNumber='12345';
                response.put('response_x',response_x);
            }
            else if(request instanceOf Show_ViadComV2.GetShowFeatureSchedule_element){
                Show_ViadComV2.GetShowFeatureScheduleResponse_element response_x=new  Show_ViadComV2.GetShowFeatureScheduleResponse_element();
                response_x.GetShowFeatureScheduleResult=new Show_ViadComV2.ShowFeatureSchedule();
                response.put('response_x',response_x);
                
            } 
            else if(request instanceOf Show_ViadComV2.SearchActiveShowProjects_element){
                Show_ViadComV2.SearchActiveShowProjectsResponse_element response_x =new Show_ViadComV2.SearchActiveShowProjectsResponse_element();
                response_x.SearchActiveShowProjectsResult=	new Show_ViadComV2.ArrayOfShowProjectSummary();
                response.put('response_x',response_x);
                
            }
            else if(request instanceOf Show_ViadComV2.GetShowOccurrence_element){
                Show_ViadComV2.GetShowOccurrenceResponse_element response_x =new  Show_ViadComV2.GetShowOccurrenceResponse_element();
                response.put('response_x',response_x);
                
            }
            
        }
    
}