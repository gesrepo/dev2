global with sharing class NMTMetadataController {
    
    public List<NMTLayoutWrapper> metadataLayouts {get; set;}
    public List<NMTLayoutWrapper> metadataLayoutsAux = new List<NMTLayoutWrapper>();
    public String showHide { get; set; }
    public String showHideRetry { get; set; }
    public String showHideRemote { get; set; }
    public Integer OffsetSize = 0;
    public Integer QueryLimit = NAMConfigs.getMetadataPageSize();
    public String sucessComumunityGroupURL {get; set;}
    public String appExchangeURL {get; set;}
    public String version {get{
        return NAMUtils.PACKAGE_VERSION_NAME;
    } set;}
    public String isPendingNotes {get{
        if(NAMUtils.isPendingNotesToBeConverted()){
            return 'display: inline; color: #C23934';
        }
        return 'display: none;';
    } set;}
    public String isPendingFiles {get{
        if(NAMUtils.isPendingAttachmentsToBeConverted()){
            return 'display: inline; color: #C23934';
        }
        return 'display: none;';
    } set;}
    public Boolean notesNotEnabled {get; set;}
    
    //Code to set the remote setting
    public String Host {get;set;}
    public String RemoteSettingResponse {get;set;}
    public Boolean RemoteSettingConnectionWarning {get;set;}
    /**
* @description the error message we get when we try to do a request to Tooling API
*/
    public String RemoteSettingConnectionWarningMessage {get;set;}
    
    //we retrive layouts. MetaDataType & MetaDataItem used to create the xml to retrive metadata (retrieveMetadata method) 
    public NMTMetadataController() {
        showHide = 'slds-hide';
        showHideRetry = 'slds-hide';
        sucessComumunityGroupURL = NAMUtils.SUCCESS_COMMUNITY_GROUP_URL;
        appExchangeURL = NAMUtils.APP_EXCHANGE_URL;
        showHideRemote = '';
        metadataLayouts = new List<NMTLayoutWrapper>();
        checkRemoteSetting();
        if(!RemoteSettingConnectionWarning){
            PageLayout(QueryLimit,OffsetSize);
            showHide = '';
            showHideRemote = 'slds-hide';
        }
        notesNotEnabled = !NAMUtils.isEnhancedNotesEnabled();
    }
    
    /**
* description: this method is used to get the layouts metadata by its names
*/
    public void newPageLayouts(String jsonStr){
        List<String> layoutsFullNameAux = new List<String>(); 
        List<String> layoutsNameAux = new List<String>(); 
        //parse the JSON
        NMTMetadataLayout.Layout2 r = NMTMetadataLayout.parse(jsonStr);
        List<NMTMetadataLayout.Records> records = r.records;
        List<String> results = new List<String>();
        for(NMTMetadataLayout.Records record: records){
            String text = '';
            String tempText = record.EntityDefinitionId;
            // First, instantiate a new Pattern object "MyPattern"
            Pattern MyPattern = Pattern.compile('([a-zA-Z0-9]{18}?|[a-zA-Z0-9]{15}?)');
            
            // Then instantiate a new Matcher object "MyMatcher"
            Matcher MyMatcher = MyPattern.matcher(tempText);
            
            //if the Entity Definition Id is an Id then we look for the object name
            if(MyMatcher.matches()&& record.EntityDefinition!=null){
                text+=record.EntityDefinition.DeveloperName+'__c';
            }
            else{
                text+=tempText;
            }
            text+='-';
            text+=record.Name;
            layoutsNameAux.add(record.Name);
            layoutsFullNameAux.add(text.replace('&', '%26').replace('(', '%28').replace(')', '%29').replace('\'', '%29'));                
        }
        Integer count = 0;
        List<String> just10FullName = new List<String>();
        List<String> just10Name = new List<String>();
        while(count<layoutsFullNameAux.size()){
            //we can only extract metadata every 10 records
            if(just10FullName.size()<10){
                just10FullName.add(layoutsFullNameAux.get(count));
                just10Name.add(layoutsNameAux.get(count));
                count++;
            }else{
                metadataLayoutsRetrive(just10FullName, just10Name);
                //clean the list
                just10FullName = new List<String>();
                just10Name = new List<String>();
                
                
                //add the new value
                just10FullName.add(layoutsFullNameAux.get(count));
                just10Name.add(layoutsNameAux.get(count));
                count++;
            }
        }
        if(just10FullName.size() > 0){
            metadataLayoutsRetrive(just10FullName, just10Name);
        }
        metadataLayouts = metadataLayoutsAux;
    }
    
    /**
* description: this method calls tooling API to get Page Layouts attributes
*/
    public void PageLayout(Integer limitQuery,Integer Offset){
        //for test environments
        if (test.isRunningTest()) {
            Test.setMock(HTTPCalloutMock.class, new NMTRetrieveMetadataMock());
        }
        HttpRequest req=new HttpRequest();
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.setHeader('content-Type','application/json');
        string domainUrl=URL.getSalesforceBaseUrl().toExternalForm();
        
        //in the endpoint we specify a query with a green list because there are some objects that can't have one or more of the related lists
        req.setEndpoint(domainUrl+'/services/data/v'+NAMUtils.API_VERSION+'/tooling/query/?q=Select+EntityDefinitionId,+EntityDefinition.DeveloperName,+Name+from+Layout+Where+(NOT+EntityDefinition.QualifiedApiName+LIKE+\'ContractLineItem\')+AND+(NOT+EntityDefinition.QualifiedApiName+LIKE+\'%25NAM%25__c\')+AND+(NOT+EntityDefinition.QualifiedApiName+LIKE+\'OpportunityLineItem\')+AND+(EntityDefinition.QualifiedApiName+LIKE+\'%25__c\'+OR+EntityDefinition.QualifiedApiName+LIKE+\'Lead%25\'+OR+EntityDefinition.QualifiedApiName+LIKE+\'Account%25\'+OR+EntityDefinition.QualifiedApiName+LIKE+\'Asset\'+OR+EntityDefinition.QualifiedApiName+LIKE+\'Contact%25\'+OR+EntityDefinition.QualifiedApiName+LIKE+\'Opportunity\'+OR+EntityDefinition.QualifiedApiName+LIKE+\'Contract%25\'+OR+EntityDefinition.QualifiedApiName+LIKE+\'Order\'+OR+EntityDefinition.QualifiedApiName+LIKE+\'Metric\'+OR+EntityDefinition.QualifiedApiName+LIKE+\'Campaign\'+OR+EntityDefinition.QualifiedApiName+LIKE+\'Case\'+OR+EntityDefinition.QualifiedApiName+LIKE+\'Solution\'+OR+EntityDefinition.QualifiedApiName+LIKE+\'Product2\'+OR+EntityDefinition.QualifiedApiName+LIKE+\'Task\'+OR+EntityDefinition.QualifiedApiName+LIKE+\'Event\'+OR+EntityDefinition.QualifiedApiName+LIKE+\'Entitlement\'+OR+EntityDefinition.QualifiedApiName+LIKE+\'ServiceContract\'+OR+EntityDefinition.QualifiedApiName+LIKE+\'Quote\'+OR+EntityDefinition.QualifiedApiName+LIKE+\'Goal\')+order+by+Name+limit+'+limitQuery+'+OFFSET+'+Offset);
        req.setMethod('GET');
        Http h=new Http();
        HttpResponse res=h.send(req);
        List<String> texts = new List<String>();
        
        if(res.getStatusCode()==200){
            //use the response to retrieve Page Layouts
            newPageLayouts(res.getBody());
        }
    }
    
    /**
* description: this method is used to retrieve the metadata of the page layouts
*/
    public void metadataLayoutsRetrive(List<String> fullNames, List<String> names){
        List<Metadata.Metadata> components = Metadata.Operations.retrieve(
            Metadata.MetadataType.Layout, fullNames);
        
        for(Metadata.Metadata temp:components) { 
            Boolean notesRelatedList  = false;
            Boolean filesRelatedList = false;
            Boolean alreadyHaveRelatedList = false;
            Metadata.Layout layout = (Metadata.Layout)temp;
            Metadata.RelatedListItem[] lists = layout.relatedLists;
            if(lists!=null){
                //find the related lists associated to the page layout
                for(Metadata.RelatedListItem relatedList:lists){
                    if(relatedList.relatedList.contains('RelatedContentNoteList')){
                        notesRelatedList = true;
                    }
                    if(relatedList.relatedList.contains('RelatedAttachmentList')){
                        alreadyHaveRelatedList = true;
                    }
                    if(relatedList.relatedList.contains('RelatedFileList')){
                        filesRelatedList = true;
                    }  
                    if(relatedList.relatedList.contains('RelatedNoteList')){
                        alreadyHaveRelatedList = true;
                    } 
                }
            }else{
                //if there are no lists add an empty array
                lists = new Metadata.RelatedListItem[]{};
                    }
            String fullName = layout.fullName;
            String name = fullName.split('-').get(1).replace('%26', '&').replace('%28', '(').replace('%29', ')');
            //create the LayoutWrapper
            NMTLayoutWrapper lw = new NMTLayoutWrapper(name, fullName, alreadyHaveRelatedList, notesRelatedList, filesRelatedList);
            metadataLayoutsAux.add(lw);
        }
    }
    
    //remote action called from page to add metadata to layouts
    //sObjectsWrapperAsJson String with all the objects selected info
    @RemoteAction
    global static void addMetadataRemote(String objectNames, String relatedList) {
        if(objectNames != ''){  
            List<String> fullNames = new List<String>();
            objectNames = objectNames.removeEnd(',');
            String[] objectsArray = objectNames.split(',');
            for(String objectLayout : objectsArray){
                fullNames.add(objectLayout);
            }
            
            Integer count = 0;
            List<String> just10FullName = new List<String>();
            while(count<fullNames.size()){
                //we can only deploy metadata every 10 records
                if(just10FullName.size()<10){
                    just10FullName.add(fullNames.get(count));
                    count++;
                }else{
                    //deploy the metadata
                    metadataLayoutsModification(just10FullName, relatedList, 'ADD');
                    //clean the list
                    just10FullName = new List<String>();
                    
                    
                    //add the new value
                    just10FullName.add(fullNames.get(count));
                    count++;
                }
            }
            if(just10FullName.size() > 0){
                //deploy the metadata
                metadataLayoutsModification(just10FullName, relatedList, 'ADD');
            }
        }  
    }
    
    //remote action called from page to remove metadata to layouts
    //sObjectsWrapperAsJson String with all the objects selected info
    @RemoteAction
    global static void removeMetadataRemote(String objectNames, String relatedList) {
        if(objectNames != ''){  
            List<String> fullNames = new List<String>();
            objectNames = objectNames.removeEnd(',');
            String[] objectsArray = objectNames.split(',');
            for(String objectLayout : objectsArray){
                fullNames.add(objectLayout);
            }
            
            Integer count = 0;
            List<String> just10FullName = new List<String>();
            while(count<fullNames.size()){
                //we can only deploy metadata every 10 records
                if(just10FullName.size()<10){
                    just10FullName.add(fullNames.get(count));
                    count++;
                }else{
                    //deploy the metadata
                    metadataLayoutsModification(just10FullName, relatedList, 'REMOVE');
                    //clean the list
                    just10FullName = new List<String>();
                    
                    
                    //add the new value
                    just10FullName.add(fullNames.get(count));
                    count++;
                }
            }
            if(just10FullName.size() > 0){
                //deploy the metadata
                metadataLayoutsModification(just10FullName, relatedList, 'REMOVE');
            }
        }  
    }
    
    /**
* description: this method is used to deploy the metadata of the page layouts
*/
    public static void metadataLayoutsModification(List<String> fullNames, String relatedListLayout, String action){ 
        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
        NMTDeployCallback callback = new NMTDeployCallback();
        //retrieve the metadata
        List<Metadata.Metadata> components = Metadata.Operations.retrieve(
            Metadata.MetadataType.Layout, fullNames);
        for(Metadata.Metadata temp:components) { 
            Metadata.Layout layout = (Metadata.Layout)temp;
            Metadata.RelatedListItem[] lists = layout.relatedLists;
            Metadata.RelatedListItem[] newlists = new List<Metadata.RelatedListItem>();
            //to add notes related list
            if (relatedListLayout.equals('Notes')){
                Boolean alreadyHaveRelatedList = false;
                //check if the page layout already have notes related list
                if(lists!=null && action.equals('ADD')){
                    for(Metadata.RelatedListItem relatedList:lists){
                        if(relatedList.relatedList.contains('RelatedContentNoteList')){
                            alreadyHaveRelatedList = true;
                        }
                        if(layout.fullName.contains('Goal')){
                            system.debug('layout.fullName: ' + layout.fullName);
                            if(!relatedList.relatedList.contains('OpenGoalRelatedMetricList')
                               && !relatedList.relatedList.contains('CompletedGoalRelatedMetricList')
                               && !relatedList.relatedList.contains('RelatedParentGoalLinkList')
                               && !relatedList.relatedList.contains('RelatedSubgoalLinkList')){
                                   newlists.add(relatedList);
                               }
                            
                        } else{
                            newlists.add(relatedList);
                        }
                    }
                }
                if(!alreadyHaveRelatedList){
                    Metadata.RelatedListItem newItem = new Metadata.RelatedListItem();
                    newItem.relatedList = 'RelatedContentNoteList';
                    newLists.add(newItem);
                }
            }//to add files related list 
            else if (relatedListLayout.equals('Files')) {
                Boolean alreadyHaveRelatedList = false;
                //check if the page layout already have files related list
                if(lists!=null && action.equals('ADD')){
                    for(Metadata.RelatedListItem relatedList:lists){
                        if(relatedList.relatedList.contains('RelatedFileList')){
                            alreadyHaveRelatedList = true;
                        }
                        if(layout.fullName.contains('Goal')){
                            system.debug('layout.fullName: ' + layout.fullName);
                            if(!relatedList.relatedList.contains('OpenGoalRelatedMetricList')
                               && !relatedList.relatedList.contains('CompletedGoalRelatedMetricList')
                               && !relatedList.relatedList.contains('RelatedParentGoalLinkList')
                               && !relatedList.relatedList.contains('RelatedSubgoalLinkList')){
                                   newlists.add(relatedList);
                               }
                            
                        } else{
                            newlists.add(relatedList);
                        }
                    }
                }
                if(!alreadyHaveRelatedList){
                    Metadata.RelatedListItem newItem = new Metadata.RelatedListItem();
                    newItem.relatedList = 'RelatedFileList';
                    newLists.add(newItem);
                }
            } //to remove notes & attachments related list
            else {
                if(lists!=null){
                    for(Metadata.RelatedListItem relatedList:lists){
                        if(!relatedList.relatedList.contains('RelatedNoteList')&&!relatedList.relatedList.contains('RelatedAttachmentList')){
                            if(layout.fullName.contains('Goal')){
                                system.debug('layout.fullName: ' + layout.fullName);
                                if(!relatedList.relatedList.contains('OpenGoalRelatedMetricList')
                                   && !relatedList.relatedList.contains('CompletedGoalRelatedMetricList')
                                   && !relatedList.relatedList.contains('RelatedParentGoalLinkList')
                                   && !relatedList.relatedList.contains('RelatedSubgoalLinkList')){
                                       newlists.add(relatedList);
                                   }
                                
                            } else{
                                newlists.add(relatedList);
                            }
                        }
                    }
                    
                } 
            }
            system.debug('newlists: ' + newlists);
            layout.relatedLists = newlists;
            mdContainer.addMetadata(layout);
        }
        //in test environment we can't make a metadata deploy
        if(!Test.isRunningTest()){
            //enqueue metadata deploy
            Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback);
        }
    }
    
    public Boolean getDisableNext() { 
        if(!RemoteSettingConnectionWarning){
            return !NAMUtils.countLayouts(QueryLimit, QueryLimit+OffsetSize);
        }
        return true;
    }
    public Boolean getDisablePrevious() { 
        if(OffsetSize == 0){
            return true;
        } else {
            return false;
        }
    }
    
    public PageReference Previous() {
        OffsetSize -= QueryLimit;
        metadataLayouts = new List<NMTLayoutWrapper>();
        metadataLayoutsAux = new List<NMTLayoutWrapper>();
        PageLayout(QueryLimit,OffsetSize);
        return null;
    }
    public PageReference Next() {
        OffsetSize += QueryLimit;
        metadataLayouts = new List<NMTLayoutWrapper>();
        metadataLayoutsAux = new List<NMTLayoutWrapper>();
        PageLayout(QueryLimit,OffsetSize);
        return null;
    }
    
    public PageReference Refresh() {
        system.debug('Refresh');
        metadataLayouts = new List<NMTLayoutWrapper>();
        metadataLayoutsAux = new List<NMTLayoutWrapper>();
        PageLayout(QueryLimit,OffsetSize);
        return null;
    }
    
    
    
    /**
* @description checks if we have created the remote setting to be able to do callouts
*/
    public void checkRemoteSetting(){
        // Get Host Domain
        //  Host = ApexPages.currentPage().getHeaders().get('Host');
        Host = URL.getSalesforceBaseUrl().toExternalForm();
        // Attempt to connect to the Tooling API
        RemoteSettingConnectionWarning = false;
        if(!NAMRollupService.checkRemoteSetting()){ 
            RemoteSettingConnectionWarning = true;
            try {
                NAMRollupService.checkRemoteSettingForCallouts();
            } catch (System.CalloutException e) {
                RemoteSettingConnectionWarningMessage = e.getMessage();
            }
        }
    }
    
    
    
}