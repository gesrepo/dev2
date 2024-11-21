/**
* The class contains the methods used to create Tasks in Wrike after an Event is Created in SFDC
*
* @author  Rahul Sinha
* @version 1.0
* @since   09-10-2019
*/

/* using without sharing so that the class can be called appropriately*/
public without sharing class GT_WrikeHandler{
    public enum TaskType {Backlog, Milestone, Planned}
    //the overall method of creating tasks in wrike
    @future (callout=true)
    public static void createTaskInWrike(set<Id> createdEventIds){
        List<GT_Event__c> createdEventList=[SELECT id, name, RecordTypeId, Event_Start_Date__c,Event_End_Date__c,Congress_Start_Date__c,Congress_End_Date__c,Event_Acronym__c,Congress_Acronym__c,Wrike_Folder_ID__c,Wrike_Project_ID__c,Wrike_Integration_Messages__c FROM GT_Event__c WHERE id IN :createdEventIds];
        for(GT_Event__c createdEvent:createdEventList){
            string parentFolderId=null;
            string eventFolderId=null;
            string eventProjectId=null;
            map<string,string> parentFolderMap=null;
            try{
                //1. get parent year folder in the wrike space
                string year= (createdEvent.Event_Start_Date__c!=null)?string.valueOf(createdEvent.Event_Start_Date__c.year()):string.valueOf(createdEvent.Congress_Start_Date__c.year());
                parentFolderMap= GT_WrikeApiMethods.getParentFolderIdInSpace(createdEvent.RecordTypeId,year,createdEvent.id);
                parentFolderId = (parentFolderMap!=null)?parentFolderMap.get(year):null;
                
                //2. create the subfolder for the Event in the Parent Folder
                List<GT_Wrike_Integration_Setting__c>relevantWrikeSetting=[SELECT id, authorization_key__c,permanent_access_token__c, event_record_type_id__c,folder_map__c,wrike_space_id__c,Project_Template_ID__c FROM  GT_Wrike_Integration_Setting__c WHERE event_record_type_id__c=:createdEvent.RecordTypeId];
                if(relevantWrikeSetting.size()>0){
                    map<string,string> tempFolderMap= new map<string,string>();
                    string tempAcronym= string.isNotBlank(createdEvent.Event_Acronym__c)?createdEvent.Event_Acronym__c:createdEvent.Congress_Acronym__c;
                    tempAcronym+=year;
                    if(string.isNotBlank(createdEvent.Wrike_Folder_ID__c)){
                        eventFolderId=createdEvent.Wrike_Folder_ID__c;
                        system.debug('Wrike Folder exists==='+eventFolderId);
                    }else{
                        eventFolderId= GT_WrikeApiMethods.createYearFolderInSpace(parentFolderId, EncodingUtil.urlEncode(tempAcronym, 'UTF-8'), tempFolderMap,relevantWrikeSetting.get(0).authorization_key__c,relevantWrikeSetting.get(0).permanent_access_token__c,null,createdEvent.id);
                        createdEvent.Wrike_Folder_ID__c=eventFolderId;
                        system.debug('Wrike Folder Created==='+eventFolderId);
                    }
                    
                    //3. Copy Template project in the folder created in the previous step
                    
                    if(string.isNotBlank(createdEvent.Wrike_Project_ID__c)){
                        eventProjectId=createdEvent.Wrike_Project_ID__c;
                    }else{
                        string rescheduleDateStr=(createdEvent.Event_Start_Date__c!=null)?getFormattedDate(createdEvent.Event_Start_Date__c -182):getFormattedDate(createdEvent.Congress_Start_Date__c-182);
                        eventProjectId=GT_WrikeApiMethods.copyTemplateProject(relevantWrikeSetting.get(0).Project_Template_ID__c,eventFolderId,EncodingUtil.urlEncode(tempAcronym+' Tasks', 'UTF-8'),EncodingUtil.urlEncode(rescheduleDateStr, 'UTF-8'),relevantWrikeSetting.get(0).authorization_key__c,relevantWrikeSetting.get(0).permanent_access_token__c,createdEvent.id);
                        createdEvent.Wrike_Project_ID__c=eventProjectId;
                    }
                    
                    //4. Get the later scheduled tasks in the project created above
                    set<string> taskTitles= new set<string>();
                    taskTitles.add('SHOW CLOSE');
                    taskTitles.add('Score Cards to client');
                    taskTitles.add('Final invoice and Variance Report to Exhibit Lead');
                    taskTitles.add('Client to provide payment to GES');
                    List<GT_WrikeTaskQueryResponse.Data> neededTasks=GT_WrikeApiMethods.getAllTasksInFolder(eventProjectId,taskTitles,relevantWrikeSetting.get(0).authorization_key__c,relevantWrikeSetting.get(0).permanent_access_token__c,createdEvent.id);

                    //5. Correct the dates of the tasks recievved from the previous step
                    for(GT_WrikeTaskQueryResponse.Data singleTask:neededTasks){
                        GT_WrikeApiObject.TaskDatesObj dates=new GT_WrikeApiObject.TaskDatesObj();
                        dates.type='Planned';
                        dates.duration=1;
                        string planDateStr='';
                        if(singleTask.title.containsIgnoreCase('SHOW CLOSE')){
                            planDateStr=(createdEvent.Event_End_Date__c!=null)?getFormattedDate(createdEvent.Event_End_Date__c):getFormattedDate(createdEvent.Congress_End_Date__c);                      
                        }
                        if(singleTask.title.containsIgnoreCase('Score Cards')){
                            planDateStr=(createdEvent.Event_End_Date__c!=null)?getFormattedDate(createdEvent.Event_End_Date__c+10):getFormattedDate(createdEvent.Congress_End_Date__c+10);
                        }
                        if(singleTask.title.containsIgnoreCase('Final invoice')){
                            planDateStr=(createdEvent.Event_End_Date__c!=null)?getFormattedDate(createdEvent.Event_End_Date__c+60):getFormattedDate(createdEvent.Congress_End_Date__c+60);                               
                        }
                        if(singleTask.title.containsIgnoreCase('Client to provide')){
                            planDateStr=(createdEvent.Event_End_Date__c!=null)?getFormattedDate(createdEvent.Event_End_Date__c+90):getFormattedDate(createdEvent.Congress_End_Date__c+90);                           
                        }
                        dates.start=planDateStr;
                        dates.due=planDateStr;
                        string modParams= json.serialize(dates);
                        //call api to modify the task
                        GT_WrikeApiMethods.modifyTask(singleTask.id,modParams,relevantWrikeSetting.get(0).authorization_key__c,relevantWrikeSetting.get(0).permanent_access_token__c,createdEvent.id);
                    }
                    
                    //6. update record with details of wrike folder and project IDs
                    database.update(createdEvent,false);
                    GT_WrikeApiObject.FolderMapObj tempFolderMapObj= new GT_WrikeApiObject.FolderMapObj();
                    tempFolderMapObj.folderMap=parentFolderMap;
                    relevantWrikeSetting.get(0).folder_map__c=json.serialize(tempFolderMapObj);
                    database.update(relevantWrikeSetting,false);
                }else{
                    system.debug('No wrike settings found for this record type: '+createdEvent.RecordTypeId);
                }               
            }catch(exception e){
                system.debug(e.getStackTraceString()+' gave bad response==='+e.getMessage());
                createdEvent.Wrike_Integration_Messages__c=e.getStackTraceString()+' gave bad response==='+e.getMessage();
                Database.DMLOptions dml = new Database.DMLOptions();
                dml.allowFieldTruncation = true;
                dml.optAllOrNone = false;
                database.update(createdEvent,dml);
            }
        }
    }
    
    //get date as a 'yyyy-MM-dd' string
    public static string getFormattedDate(date needToBeConvertedDate){
        string resultDateString=string.valueOf(needToBeConvertedDate.year())+'-';
        resultDateString+=  (needToBeConvertedDate.month()>=10)?string.valueOf(needToBeConvertedDate.month())+'-':'0'+string.valueOf(needToBeConvertedDate.month())+'-';
        resultDateString+=  (needToBeConvertedDate.day()>=10)?string.valueOf(needToBeConvertedDate.day()):'0'+string.valueOf(needToBeConvertedDate.day());
        return resultDateString;
    }
}