global with sharing class GC_RegChkListTaskDtlsController {
    
    public Boolean isClassic{get; set;}
    public String showHeaderVal{get; set;}
    public String formName{get; set;}
    public String chkListId{get; set;}
    public String projectNumber{get; private set;}
    public String storedObjectId{get; private set;}
    public Integer regCkLtDtlId{get; private set;}
    public List<string> selectedTaskIds;
    public schemasMicrosoft0310Serializat_all.ArrayOfint listOfSelectedIds;
    public List<String>listOfLabels{get;set;}
    public GC_Connect2_Show__c parentShow;
    public String showName{get;set;}
    public String startDate{get;set;}
    public String endDate{get;set;}
    public String showYear{get;set;}
    private GC_Show_Team_Member__c teamMember;
    public wwwViadComV1_all.QuestionnaireDetailSummary QuestionnaireDetailSummary;
    public List<List<string>> allQuestionDetails{get;set;}
    
    public GC_RegChkListTaskDtlsController() {
        QuestionnaireDetailSummary= new wwwViadComV1_all.QuestionnaireDetailSummary();
        allQuestionDetails = new List<List<string>> ();
        QuestionnaireDetailSummary.QuestionnaireLabels= new schemasMicrosoft0310Serializat_all.ArrayOfstring();
        QuestionnaireDetailSummary.QuestionnaireLabels.string_x= new List<string>();
        projectNumber =  ApexPages.currentPage().getParameters().get('projectNumber');
        String tempId= ApexPages.currentPage().getParameters().get('id');
        formName= ApexPages.currentPage().getParameters().get('formName');
        system.debug('formName==='+formName);
        chkListId= ApexPages.currentPage().getParameters().get('chkListId');
        if(string.isBlank(formName)){
            formName='Unidentified Form';
        }
        parentShow=[SELECT id, Show_Name__c, Show_Start_Date__c, Show_End_Date__c FROM GC_Connect2_Show__c WHERE Job_Number__c=:projectNumber LIMIT 1];
        showName=string.isNotBlank(parentShow.Show_Name__c) ? parentShow.Show_Name__c:'';
        startDate=(parentShow.Show_Start_Date__c!=null)?parentShow.Show_Start_Date__c.format():'';
        endDate=(parentShow.Show_End_Date__c!=null)?parentShow.Show_End_Date__c.format():'';
        showYear= string.isNotBlank(startDate)? ('_'+ startDate.right(4)):'';
        String yourFileNameName  =formName+'_'+showName+showYear+'.pdf';
        Apexpages.currentPage().getHeaders().put( 'content-disposition', 'attachment; filename='+yourFileNameName );
        listOfSelectedIds= new schemasMicrosoft0310Serializat_all.ArrayOfint();
        listOfSelectedIds.int_x= new List<Integer>();
        if(String.isNotBlank(tempId)){
            regCkLtDtlId =  Integer.ValueOf(ApexPages.currentPage().getParameters().get('id'));
            selectedTaskIds = new List<string>();
            selectedTaskIds.add(tempId);
        }
        
        storedObjectId =  ApexPages.currentPage().getParameters().get('storedObjectId');

        if(String.isNotBlank(storedObjectId)){
            GC_Core_Interface_Log__c objectForStoredIds = [SELECT id,Message_Content__c from  GC_Core_Interface_Log__c WHERE id=:storedObjectId];
            if(String.isNotBlank(objectForStoredIds.Message_Content__c)){
                selectedTaskIds=(List<String>)System.JSON.deserialize(objectForStoredIds.Message_Content__c, List<String>.class);
            }            
        }
        for(String id: selectedTaskIds){
            listOfSelectedIds.int_x.add((integer.valueOf(id)));
        }

        teamMember = new GC_Show_Team_Member__c();
        String ntwrkId = Network.getNetworkId();
        //system.debug('ntwrkId==='+ntwrkId);
        if(ntwrkId==null){
            isClassic= true;
            showHeaderVal='true';
        }else{
            isClassic= false;
            showHeaderVal='false';
        }
        listOfLabels= new List<String>();
        RegistrationCheckListTaskDetails();
       
    }
    
    public PageReference MarkAsReadOnLoad(){
        
        ExhibitorOrderShowProgressController.markAsRead(projectNumber,selectedTaskIds,chkListId);
        return null;
    }
    /* Methods to be GetRegistrationCheckListTaskDetails report from here --report7*/
    
    public String RegistrationCheckListTaskDetails (){
        Boolean validationFlag = ExhibitorOrderShowProgressController.validateUser(projectNumber);
        String expressoSessionId= ExhibitorOrderShowProgressController.getExSessionID();
        if(validationFlag || test.isRunningTest()){
            try{
                wwwViadComV1_all.BasicHttpBinding_IExhibitorService IExhibitorServiceObject= new wwwViadComV1_all.BasicHttpBinding_IExhibitorService(); 
                QuestionnaireDetailSummary= IExhibitorServiceObject.GetQuestionnaireDetailSummary(expressoSessionId, listOfSelectedIds);
                    listOfLabels.addAll(QuestionnaireDetailSummary.QuestionnaireLabels.string_x);
                
                for(wwwViadComV1_all.QuestionnaireDetailValues QuestionnaireDetailValue: QuestionnaireDetailSummary.Details.QuestionnaireDetailValues){
                        List<string>tempVal= new List<string>();
                        if(QuestionnaireDetailValue.QuestionnaireValues.string_x.size()>0){
                            tempVal.addAll(QuestionnaireDetailValue.QuestionnaireValues.string_x);
                        }
                        allQuestionDetails.add(tempVal);
                    
                }
                
            }catch(exception e){
                system.debug('error message==='+e.getMessage()); 
                system.debug('error message==='+e.getStackTraceString()); 
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There is some issue with the web services. Please wait till it is fixed. Thank you!'));
                
            }
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please contact your GES Account Manager for Analytics access. Thank You!'));
        }
        //String jsonReportString = JSON.serialize(reportWrapper);

        return 'jsonReportString';
    }       
    
    /* Methods for GetRegistrationCheckListTaskDetails report till here --report7*/
}