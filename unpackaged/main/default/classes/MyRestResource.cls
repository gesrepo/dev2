@RestResource(urlMapping='/Account/*')
global without sharing class MyRestResource {
    @HttpGet
    global static String getRecord() {
        RestRequest req = RestContext.request;
        String projectNum= req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        
        //system.debug('projectNumber==='+projectNum);
        
        Integer ShowOccrProjectId=0;
        String sessionId='';
        String integrationUserId= System.Label.LC_LC_IntegrationUserId;
        UpSQR_MicrosoftCom200310Serializat.ArrayOfstring listServiceCategory = new UpSQR_MicrosoftCom200310Serializat.ArrayOfstring();
        listServiceCategory.string_x = new List<String>();
        //listServiceCategory.string_x.add('7');
        listServiceCategory.string_x = System.Label.PC_LabelForServiceCategories.split(',');
        Map<String,String> mapBoothNumToCusBoothId = new Map<String,String>();
        LookUpsWrapper wrappedLookUps= (LookUpsWrapper)JSON.deserialize(System.Label.GC_Core_Lookup,LookUpsWrapper.class);
        
        try{
            //sessionId= LC_IntegrationsApexController.getSessionIDWithLogin();
            List<GC_Core_Session__c> existingSession = [SELECT Id, Core_Application_Session_ID__c, Is_Logged_In__c, Core_Application_Session_Error_Message__c, Core_Application_Login_Error_Message__c, User_ID__c, Core_Application_Login_Expiration__c, Core_Application_Session_Expiration__c FROM GC_Core_Session__c WHERE OwnerId = :integrationUserId order by LastModifiedDate desc];
            sessionId=existingSession[0].Core_Application_Session_ID__c;
            if(Test.isRunningTest()){
                Test.setMock(WebServiceMock.class, new Show_ViadComV2_Mock()); 
            }
            Show_ViadComV2.BasicHttpBinding_IShowService showServiceObj= new Show_ViadComV2.BasicHttpBinding_IShowService();
            Show_ViadComV2.ArrayOfShowOccurrenceSummary ArrayOfShowOccurSummaryObj= showServiceObj.SearchShowOccurrences(sessionId,projectNum,null,null,null,null);
            //System.debug('ArrayOfShowOccurSummaryObj'+ArrayOfShowOccurSummaryObj);
            for(Show_ViadComV2.ShowOccurrenceSummary singleShowOccurence: ArrayOfShowOccurSummaryObj.ShowOccurrenceSummary){
                for(Show_ViadComV2.ShowProjectSummary singleShowProjSum:singleShowOccurence.ShowProjects.ShowProjectSummary){
                    ShowOccrProjectId= singleShowProjSum.ShowOccrProjectId;
                }
            }
            if(Test.isRunningTest()){
                Test.setMock(WebServiceMock.class, new wwwViadComV1_allMockImpl()); 
            }
            wwwViadComV1_all.BasicHttpBinding_IExhibitorService exServiceObj= new wwwViadComV1_all.BasicHttpBinding_IExhibitorService();
            wwwViadComV1_all.ArrayOfExhibitorSummary arrayOfExhibitorSummaryObj= exServiceObj.SearchExhibitorsByShowProject(sessionId,ShowOccrProjectId ,null,null,null);
            for(wwwViadComV1_all.ExhibitorSummary singleExhibitorSummary : arrayOfExhibitorSummaryObj.ExhibitorSummary){
                for(wwwViadComV1_all.BoothSummary singleBoothSummary : singleExhibitorSummary.Booths.BoothSummary){
                    if(!mapBoothNumToCusBoothId.containsKey(string.valueOf(singleBoothSummary.CustomerBoothId))){
                        mapBoothNumToCusBoothId.put(string.valueOf(singleBoothSummary.CustomerBoothId),singleBoothSummary.BoothNumber);
                    }
                }
            }
            
            del_schemasMicrosoftCom200310Serializat.ArrayOfint list_CustomerBoothIds = new del_schemasMicrosoftCom200310Serializat.ArrayOfint();
            list_CustomerBoothIds.int_x = new List<Integer>();
            list_CustomerBoothIds.int_x.add(1992438);
            
           if(Test.isRunningTest()){
                Test.setMock(WebServiceMock.class, new UpSQR_ViadComV2_Mock()); 
            } 
            UpSQR_ViadComV2.BasicHttpBinding_ISqrService serviceObj= new UpSQR_ViadComV2.BasicHttpBinding_ISqrService();
            UpSQR_ViadComDataV2.ArrayOfSqrHeader arrayOfSqrHeaderObj= new UpSQR_ViadComDataV2.ArrayOfSqrHeader();
            arrayOfSqrHeaderObj= serviceObj.GetSqrHeaders(sessionId,null,null,null, ShowOccrProjectId, null,null,null,null,null,null,null,listServiceCategory);
        
            //system.debug('arrayOfSqrSummary==='+arrayOfSqrSummary);
            List<SQRSummaryWrapper>resultWrapper= new List<SQRSummaryWrapper>();
            SQRSumWrapperMap finalResult = new SQRSumWrapperMap();
            finalResult.listOfSQRSummaryWrapper= new  List<SQRSummaryWrapper>();
            
            if(arrayOfSqrHeaderObj.SqrHeader.size()>0){
                for(UpSQR_ViadComDataV2.SqrHeader singleSQRSummary: arrayOfSqrHeaderObj.SqrHeader){
                    
                    SQRSummaryWrapper singleSQRSummaryWrapper = new SQRSummaryWrapper(singleSQRSummary, wrappedLookUps.lookUpMap.get(singleSQRSummary.Priority),wrappedLookUps.lookUpMap.get(singleSQRSummary.ServiceCategory));
                   // system.debug('singleSQRSummary.ServiceCategory==='+singleSQRSummary.ServiceCategory);
                   // system.debug('wrappedLookUps.lookUpMap.get(singleSQRSummary.ServiceCategory)==='+wrappedLookUps.lookUpMap.get(singleSQRSummary.ServiceCategory));
                    
                    string key='';
                    //System.debug('mapBoothNumToCusBoothId'+mapBoothNumToCusBoothId);
                   // System.debug('singleSQRSummaryWrapper.CustomerBoothId'+singleSQRSummaryWrapper.CustomerBoothId);
                    if(mapBoothNumToCusBoothId.containsKey(singleSQRSummaryWrapper.CustomerBoothId)){
                        key=mapBoothNumToCusBoothId.get(singleSQRSummaryWrapper.CustomerBoothId);
                        if(!finalResult.mapCusBoothIdToSQR.containsKey(key)){
                            finalResult.mapCusBoothIdToSQR.put(key,new List<SQRSummaryWrapper>());
                        }
                        finalResult.mapCusBoothIdToSQR.get(key).add(singleSQRSummaryWrapper);
                    }
                    
                }
                
            }
            String jsonResponseString = JSON.serialize(finalResult);
            return jsonResponseString;
        }catch(exception e){
            system.debug('error is==='+e.getMessage());
            system.debug('error @==='+e.getStackTraceSTring());
            return 'Issue with WebServices. Please check with System Admin'+'=='+e.getStackTraceSTring()+'=='+e.getMessage();
            
        }
    }
    
    public class SQRSumWrapperMap{
        public List<SQRSummaryWrapper> listOfSQRSummaryWrapper{get; set;}
        Map<string, List<SQRSummaryWrapper>> mapCusBoothIdToSQR{get;set;} 
        public SQRSumWrapperMap(){
            this.mapCusBoothIdToSQR= new Map<string, List<SQRSummaryWrapper>>();
        }
    }
    
    public class SQRSummaryWrapper{
        public string CustomerBoothId {get; set;}
        public string LastUpdateDate {get; set;}
        public string CreationDate {get; set;}
        public string Priority {get; set;}
        public string ServiceCategory {get; set;}
        
        
        //public SQRSummaryWrapper(SQRSer_wwwViadComDataV1.SqrSummary singleSQRSummary ){
        public SQRSummaryWrapper(UpSQR_ViadComDataV2.SqrHeader singleSQRSummary, String Priority, String serviceCategory ){
            this.CustomerBoothId = singleSQRSummary.CustomerBoothId!=null ? string.valueOf(singleSQRSummary.CustomerBoothId):'';
            this.ServiceCategory = string.isNotBlank(serviceCategory) ? ServiceCategory:'';
            this.Priority = string.isNotBlank(Priority) ? Priority:'';
            this.CreationDate = singleSQRSummary.CreationDate.DateTime_x!=null ? (singleSQRSummary.CreationDate.DateTime_x).format():'';
            this.LastUpdateDate = singleSQRSummary.LastUpdateDate.DateTime_x!=null ? (singleSQRSummary.LastUpdateDate.DateTime_x).format():'';
        }
    } 
    public class LookUpsWrapper{
        public map<string,string>lookUpMap{get;set;}
        
        public LookUpsWrapper(){
            this.lookUpMap= new map<string,string>();
        }
    }
}