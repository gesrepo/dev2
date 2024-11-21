/**
* The class contains the methods used to make callouts to Wrike APIs 
*
* @author  Rahul Sinha
* @version 1.0
* @since   09-04-2019
*/

/* using without sharing so that the class can be called appropriately even by a portal user*/
public without sharing class GT_WrikeApiMethods{
    public static final string WRIKEENDPOINT=System.Label.GT_Wrike_Endpoint;
    public static final string GETMETHOD='GET';
    public static final string POSTMETHOD='POST';
    public static final string PUTMETHOD='PUT';
    
    public static Map<string,string> mapOfAPICallsToEndpoints= new Map<string,string>{
        'GetSpaces' => '/api/v4/spaces',
        'GetFolderTreeBySpaceID'=>'/api/v4/spaces/SPACE_ID/folders',
        'CreateYearFolder'=>'/api/v4/folders/SPACE_ID/folders',
        'CreateTaskInProject'=>'/api/v4/folders/PROJECT_ID/tasks',
        'CopyFolder'=>'/api/v4/copy_folder/TEMPLATE_ID',
        'QueryTasks'=>'/api/v4/folders/FOLDER_ID/tasks',
        'ModifyTask'=>'/api/v4/tasks/TASK_ID'
    };
    
/* Method to get all spaces in wrike  */
        @future (callout=true)
    public static void getAllSpacesInfo(String eventRecTypeId, string eventRecordId){
        List<GT_Wrike_Integration_Setting__c> relevantWrikeSetting =[SELECT id, authorization_key__c,permanent_access_token__c, event_record_type_id__c,folder_map__c,Wrike_Space_Id__c FROM  GT_Wrike_Integration_Setting__c WHERE event_record_type_id__c=:eventRecTypeId];
        
        HttpResponse httpResponseObj = doCallout(WRIKEENDPOINT+mapOfAPICallsToEndpoints.get('GetSpaces'),relevantWrikeSetting.get(0).authorization_key__c,relevantWrikeSetting.get(0).permanent_access_token__c, GETMETHOD, null,null,eventRecordId);
        if(httpResponseObj.getStatusCode()==200){
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(httpResponseObj.getBody());
            //system.debug('results==='+results);
            List<Object> allSpaces = (List<Object>) results.get('data');
            for (Object singleSpace: allSpaces) {
                system.debug('singleSpace=='+singleSpace);
            }
        }else{
            system.debug('httpResponseObj==='+httpResponseObj);
        }

    }
    
/* method to search (and create a folder if no folder exists for that year) in wrike*/
    public static map<string,string> getParentFolderIdInSpace(String eventRecTypeId, String year, string eventRecordId){
        string folderId=null;
        string spaceId=null;
        map<string,string> tempFolderMap = new map<string,string>();
        // check if a folder with the year already exists in the metadata folder map
        List<GT_Wrike_Integration_Setting__c>relevantWrikeSetting=[SELECT id, authorization_key__c,permanent_access_token__c, event_record_type_id__c,folder_map__c,wrike_space_id__c FROM  GT_Wrike_Integration_Setting__c WHERE event_record_type_id__c=:eventRecTypeId];
        if(relevantWrikeSetting.size()>0){
            spaceId=relevantWrikeSetting.get(0).wrike_space_id__c;
            if(string.isNotBlank(relevantWrikeSetting.get(0).folder_map__c)){
                GT_WrikeApiObject.FolderMapObj tempFolderMapObj= new GT_WrikeApiObject.FolderMapObj();
                tempFolderMapObj= (GT_WrikeApiObject.FolderMapObj)JSON.deserialize(relevantWrikeSetting.get(0).folder_map__c,GT_WrikeApiObject.FolderMapObj.class);
                tempFolderMap=tempFolderMapObj.FolderMap;
            }
            if(tempFolderMap.containsKey(year)){
                folderId= tempFolderMap.get(year);
            }else{
                //use project=false in endpoint so that it will return only folders and not any projects
                //use descendants=false in endPoint to avoid getting all folders. Only year folders would be coming 
                HttpResponse httpResponseObj = doCallout(WRIKEENDPOINT+mapOfAPICallsToEndpoints.get('GetFolderTreeBySpaceID').replace('SPACE_ID', spaceId)+'?project=false&descendants=false',relevantWrikeSetting.get(0).authorization_key__c,relevantWrikeSetting.get(0).permanent_access_token__c, GETMETHOD, null,null,eventRecordId);
                if(httpResponseObj.getStatusCode()==200){
                    GT_WrikeFolderSearchRespObj recievedResponse=GT_WrikeFolderSearchRespObj.parse(httpResponseObj.getBody());
                    List<GT_WrikeFolderSearchRespObj.Data> allFolders = recievedResponse.data;
                    for (GT_WrikeFolderSearchRespObj.Data singleFolder: allFolders) {
                        system.debug('singleFolder=='+singleFolder);
                        if(singleFolder.title==year){                       
                            folderId=singleFolder.id;
                        }
                        if(!tempFolderMap.containsKey(singleFolder.title)){
                            tempFolderMap.put(singleFolder.title,singleFolder.id);
                        }
                    }
                    if(string.isBlank(folderId)){
                        folderId=createYearFolderInSpace(spaceId,year,tempFolderMap,relevantWrikeSetting.get(0).authorization_key__c,relevantWrikeSetting.get(0).permanent_access_token__c,null,eventRecordId);
                        tempFolderMap.put(year,folderId);
                    }
                }else{
                    system.debug('httpResponseObj==='+httpResponseObj);
                }
            }
        }else{
            return null;
        }
        return tempFolderMap;
    }
    
    /* method to cerate a year folder or a project sub folder if it is not present in the wrike space*/
    public static string createYearFolderInSpace(string spaceId, string year, map<string,string> tempFolderMap, String AUTHKEY, String ACCTKN, string projectParams,string eventRecordId){
        string folderId=null;
        HttpResponse httpResponseObj=null;
        string params='Folder Created Through Integration For '+year+'In Parent ID '+spaceId;
        String encodedUrl = EncodingUtil.urlEncode(params, 'UTF-8');
        if(string.isNotBlank(projectParams)){
            httpResponseObj =doCallout(WRIKEENDPOINT+mapOfAPICallsToEndpoints.get('CreateYearFolder').replace('SPACE_ID', spaceId)+'?title='+year+'&description='+encodedUrl+'&project='+projectParams,AUTHKEY,ACCTKN, POSTMETHOD, null,null,eventRecordId);
        }else{
            httpResponseObj =doCallout(WRIKEENDPOINT+mapOfAPICallsToEndpoints.get('CreateYearFolder').replace('SPACE_ID', spaceId)+'?title='+year+'&description='+encodedUrl,AUTHKEY,ACCTKN, POSTMETHOD, null,null,eventRecordId);
        }
        if(httpResponseObj.getStatusCode()==200){
            GT_WrikeFolderCreateRespObj createdFolderDetails= GT_WrikeFolderCreateRespObj.parse(httpResponseObj.getBody());
            List<GT_WrikeFolderCreateRespObj.Data> allFolders = createdFolderDetails.data;
            for (GT_WrikeFolderCreateRespObj.Data singleFolder: allFolders) {
                system.debug('singleFolder=='+singleFolder);
                if(singleFolder.title==year){
                    folderId=singleFolder.id;
                }
                if(!tempFolderMap.containsKey(singleFolder.title)){
                    tempFolderMap.put(singleFolder.title,singleFolder.id);
                }
            }
        }else{
            system.debug('httpResponseObj==='+httpResponseObj);
        }
        return folderId;
    }
    
    /* public static void createTaskInProject(string projectId,string title,map<string,string> paramsMap,string AUTHKEY,string ACCTKN,string eventRecordId){
        string endPoint=WRIKEENDPOINT+mapOfAPICallsToEndpoints.get('CreateTaskInProject').replace('PROJECT_ID', projectId);
        string params;
        for(string key:paramsMap.keySet()){
            params+='&'+key+'='+paramsMap.get(key);
        }
        endPoint+='?title='+EncodingUtil.urlEncode(title, 'UTF-8')+params;
        HttpResponse httpResponseObj=doCallout(endPoint,AUTHKEY,ACCTKN,POSTMETHOD,null,null,eventRecordId);
        if(httpResponseObj.getStatusCode()!=200){
            system.debug('httpResponseObj==='+httpResponseObj);
        }
    }   */
    
    /* method to copy a wrike project and place it under the newly created event folder*/
    public static string copyTemplateProject(string templateId,string evtFolderId, string title,string rescheduleDate,string AUTHKEY,string ACCTKN,string eventRecordId){
        string projectId=null;
        string endPoint=WRIKEENDPOINT+mapOfAPICallsToEndpoints.get('CopyFolder').replace('TEMPLATE_ID', templateId);
        endPoint+='?parent='+evtFolderId+'&title='+title;
        endPoint+='&rescheduleDate='+rescheduleDate;
        HttpResponse httpResponseObj=doCallout(endPoint,AUTHKEY,ACCTKN,POSTMETHOD,null,null,eventRecordId);
        if(httpResponseObj.getStatusCode()!=200){
            system.debug('httpResponseObj==='+httpResponseObj);
            //log the response in the event
        }else{
            GT_WrikeFolderCreateRespObj createdFolderDetails= GT_WrikeFolderCreateRespObj.parse(httpResponseObj.getBody());
            List<GT_WrikeFolderCreateRespObj.Data> allProjects = createdFolderDetails.data;
            for (GT_WrikeFolderCreateRespObj.Data singleProject: allProjects) {
                projectId=singleProject.id;
            }
        }
        return projectId;
    }
    
    /*Method to query tasks from the folder*/
    public static List<GT_WrikeTaskQueryResponse.Data> getAllTasksInFolder(string folderId,set<string>taskTitles,string AUTHKEY,string ACCTKN,string eventRecordId){
        List<GT_WrikeTaskQueryResponse.Data> laterTasks= new List<GT_WrikeTaskQueryResponse.Data>();
        string endPoint=WRIKEENDPOINT+mapOfAPICallsToEndpoints.get('QueryTasks').replace('FOLDER_ID', folderId);
        HttpResponse httpResponseObj=doCallout(endPoint,AUTHKEY,ACCTKN,GETMETHOD,null,null,eventRecordId);
        if(httpResponseObj.getStatusCode()!=200){
            system.debug('httpResponseObj==='+httpResponseObj);
            //log the response in the event
        }else{
            GT_WrikeTaskQueryResponse allTaskDetails= GT_WrikeTaskQueryResponse.parse(httpResponseObj.getBody());
            List<GT_WrikeTaskQueryResponse.Data> allTasks = allTaskDetails.data;
            for (GT_WrikeTaskQueryResponse.Data singleTask: allTasks) {
                
                if(taskTitles.contains(singleTask.title)){
                    laterTasks.add(singleTask);
                    system.debug('singleTask.title=='+singleTask.title);
                }
            }
        }
        return laterTasks;
    }
    
    /* method to modify task in wrike */
    public static void modifyTask(string taskId,string dateStr,string AUTHKEY,string ACCTKN,string eventRecordId){
        string endPoint=WRIKEENDPOINT+mapOfAPICallsToEndpoints.get('ModifyTask').replace('TASK_ID',taskId);
        endPoint+='?dates='+dateStr;
        HttpResponse httpResponseObj=doCallout(endPoint,AUTHKEY,ACCTKN,PUTMETHOD,null,null,eventRecordId);
    }
    
/* method to make a callout*/
    public static HttpResponse doCallout(string endPoint, string authKey, string accessToken, string method, string body, integer timeout,string eventRecordId){
        HttpResponse httpResponseObj;
        HttpRequest httpRequestObj = new HttpRequest();
        //try{
            Http httpObj = new Http();
            
            httpRequestObj.setEndPoint(endPoint);
            httpRequestObj.setHeader(authKey,accessToken);
            httpRequestObj.setMethod(method);
            if(timeout!=null){
                httpRequestObj.setTimeout(timeout);
            }           
            httpResponseObj=httpObj.send(httpRequestObj);
            //system.debug('httpRequestObj==='+httpRequestObj);

        return httpResponseObj;
    }
    
/* method to log the bad response callout error in the record itself*/
    /*public static void logErrorInEvent(string badResponse,string methodName,string eventRecordId){
        GT_Event__c createdEvent=[SELECT id, name, Wrike_Integration_Messages__c FROM GT_Event__c WHERE id=:eventRecordId]; 
        createdEvent.Wrike_Integration_Messages__c=methodName+' gave bad response==='+badResponse;
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.allowFieldTruncation = true;
        dml.optAllOrNone = false;
        database.update(createdEvent,dml);
    }*/
}