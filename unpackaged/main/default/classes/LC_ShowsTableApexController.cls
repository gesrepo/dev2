public with sharing class  LC_ShowsTableApexController {
    
    
    @AuraEnabled
    public static List<GC_Connect2_Show__c> getShows() {
        List<GC_Connect2_Show__c> shows =
            [SELECT Id, Name, Show_End_Date__c  ,Show_Start_Date__c,Show_Name__c, Opportunity_Name__c,Facility__c,FormulaShowDates__c,  Job_Number__c,Facility_Address__c, Facility_lk__r.Name
             FROM GC_Connect2_Show__c WHERE Job_Number__c!=null AND Show_End_Date__c>TODAY order by Show_Start_Date__c asc  LIMIT 2000];
        system.debug('shows=='+shows.size());
        return shows;
    } 
    
    @AuraEnabled
    public static List<GC_Connect2_Show__c> getrecords(string searchname,string searchfacility) {
        searchname= string.isNotBlank(searchname)?searchname.normalizeSpace():searchname;
        searchfacility= string.isNotBlank(searchfacility)?searchfacility.normalizeSpace():searchfacility;
        String searchKey = '%' + searchname + '%';
        String searchfacilitykey = '%' + searchfacility + '%';
        List<GC_Connect2_Show__c> showsdetail =
            [SELECT Id, Name, Show_End_Date__c  ,Show_Start_Date__c,FormulaShowDates__c,Show_Name__c, Opportunity_Name__c,Facility__c, Job_Number__c,Facility_Address__c
             FROM GC_Connect2_Show__c WHERE Job_Number__c!=null AND (Show_Name__c Like:searchKey OR Facility__c  Like:searchfacilitykey  )  ];
        system.debug('shows=='+showsdetail);
        return showsdetail;
    } 
    
    
    @AuraEnabled 
    public static user fetchUser(){
        User u = [select id,FirstName from User where id =: userInfo.getUserId()];
        return u;
    }
    
    @AuraEnabled
    public static List<AS_Tile__c> getTilesForShowTeamMember(String projectNumber1) {
        List<AS_Tile__c> allowedTiles = new List<AS_Tile__c>();
        try{
            if(System.Label.LC_AtShowOverride.contains(UserInfo.getProfileId())){
                allowedTiles= [SELECT id, Name, Image_Link__c FROM AS_Tile__c WHERE ( Is_Active__c = TRUE AND Image_Link__c!=null)];
            }else{
                GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c();
                String jobNumber = '';
                stm= [SELECT id, Name, Tiles_Access__c FROM GC_Show_Team_Member__c WHERE User__c=:UserInfo.getUserId() AND Connect2_Show__r.Job_Number__c=:projectNumber1 LIMIT 1];
                string[] accessGivenForTiles = stm.Tiles_Access__c.split(';');
                //system.debug('accessGivenForTiles=='+accessGivenForTiles);
                allowedTiles= [SELECT id, Name, Image_Link__c FROM AS_Tile__c WHERE  (Is_Active__c = TRUE AND name IN :accessGivenForTiles)];
                //system.debug('allowedTiles=='+allowedTiles);
            }
            
        }catch(exception e){
            system.debug('error=='+e.getMessage()+e.getStackTraceString());
            
            allowedTiles = new List<AS_Tile__c>();
        }
        
        return allowedTiles;
    }
    
    @AuraEnabled
    public static boolean overRidePermissions() {
        return(System.Label.LC_AtShowOverride.contains(UserInfo.getProfileId())); 
    }
    
    @AuraEnabled
    public static string saveNewSTM(GC_Show_Team_Member__c newSTM) {
        try{
            upsert newSTM;
            return null;
        }catch(exception e){
            string errorMessage= e.getMessage();
            system.debug(errorMessage);
            return errorMessage ;
        }
    }
    
    //method to be called to maintain the current show on every page
    @AuraEnabled
    public static GC_Connect2_Show__c returnCurrentShow(String projectNumber) {
        GC_Connect2_Show__c currentShow =[SELECT Id, Name, Show_End_Date__c ,Show_Start_Date__c,Show_Name__c, Opportunity_Name__c,Facility__c, Job_Number__c
                                          FROM GC_Connect2_Show__c WHERE Job_Number__c=:projectNumber];
        return currentShow;
    }
    
    @AuraEnabled
    public static string getExpoCadURL(String projectNumber) {
        system.debug('projectNumber'+projectNumber);
        return LC_IntegrationsApexController.setExpoCadURL(projectNumber);
    }
    
    
    @AuraEnabled
    public static string checkUsersPermission() {
        //Profile userProfile= [select id, name from profile where Id = :userInfo.getUserId()];
        system.debug('userInfo.getProfileId()'+userInfo.getProfileId());
        string profileId= userInfo.getProfileId();
        if(System.Label.LC_ProfilesToCreateSTM.contains(userInfo.getProfileId()) || System.Label.LC_ProfilesToCreateSTM.contains(profileId.left(15))){
            return 'canCreateSTM';
        }else{
            throw new AuraHandledException('Please consult your Account Manager');
        }
        
    }
    
    @AuraEnabled
    public static List<GC_Order__c> getRelatedOrders(String projectNumber) {
        List<GC_Order__c> orders =
            [SELECT Id, Name, Booth_Area__c  ,Order_Area_Description__c,Delivery_Date_Time__c, Completion_Date_Time__c,Removal_Date_Time__c, Order_Number__c,Status__c
             FROM GC_Order__c WHERE Connect2_Show__r.Job_Number__c=:projectNumber order by LastModifiedDate desc];
        //system.debug('shows=='+shows.size());
        //String x=LC_IntegrationsApexController.getSessionIDWithLogin();
        return orders;
    }
    
    @AuraEnabled
    public static List<String> getUserSessionID() {
        List<String> results= new List<String>();
        string apiSsn= LC_IntegrationsApexController.getSessionIDWithLogin();
        //system.debug('apiSsn==='+apiSsn);
        string userSsn= LC_IntegrationsApexController.getUserSessionID();
        results.add(userSsn);
        results.add(apiSsn);
        return results;
    }
 /*   
    @AuraEnabled
    public static List<TreeGridDataWrapper> getUserprojectId(string projectNumber, string sessionId) {   
        List<TreeGridDataWrapper> results=new List<TreeGridDataWrapper>();        
        Integer ShowOccrProjectId=0;
        //String sessionId='';
        try{
            //sessionId= LC_IntegrationsApexController.getSessionIDWithLogin();
            if(Test.isRunningTest()){
                Test.setMock(WebServiceMock.class, new Show_ViadComV2_Mock()); 
            }
            Show_ViadComV2.BasicHttpBinding_IShowService showServiceObj= new Show_ViadComV2.BasicHttpBinding_IShowService();
            Show_ViadComV2.ArrayOfShowOccurrenceSummary ArrayOfShowOccurSummaryObj= showServiceObj.SearchShowOccurrences(sessionId,projectNumber,null,null,null,null);
            for(Show_ViadComV2.ShowOccurrenceSummary singleShowOccurence: ArrayOfShowOccurSummaryObj.ShowOccurrenceSummary){
                for(Show_ViadComV2.ShowProjectSummary               singleShowProjSum:singleShowOccurence.ShowProjects.ShowProjectSummary){
                    if(singleShowProjSum.ProjectNumber==projectNumber){
                        ShowOccrProjectId= singleShowProjSum.ShowOccrProjectId;
                    }
                }
            }
            if(Test.isRunningTest()){
                Test.setMock(WebServiceMock.class, new wwwViadComV1_allMockImpl()); 
            }
            //System.debug('ShowOccrProjectId==='+ShowOccrProjectId);
            wwwViadComV1_all.BasicHttpBinding_IExhibitorService exServiceObj= new wwwViadComV1_all.BasicHttpBinding_IExhibitorService();
            wwwViadComV1_all.ArrayOfExhibitorSummary arrayOfExhibitorSummaryObj= exServiceObj.SearchExhibitorsByShowProject(sessionId,ShowOccrProjectId ,null,null,null);
            for(wwwViadComV1_all.ExhibitorSummary singleExhibitorSummary : arrayOfExhibitorSummaryObj.ExhibitorSummary){
                if(singleExhibitorSummary.Booths.BoothSummary!=Null){
                    for(wwwViadComV1_all.BoothSummary singleBoothSummary : singleExhibitorSummary.Booths.BoothSummary){
                            TreeGridDataWrapper singleBoothSummaryWrapper= new TreeGridDataWrapper(singleBoothSummary);
                        	results.add(singleBoothSummaryWrapper);
						
                    }
                }
                
            }
        }catch(exception e){
            system.debug('sessionId==='+sessionId);
            system.debug('error is==='+e.getMessage());
            system.debug('error @==='+e.getStackTraceSTring());
            
        }
        return results;
    }
    
    @AuraEnabled
    public static List<TreeGridDataWrapper> getExhibitorOrders(List<integer> customerBoothdIds, string applicationSessionId){
        List<TreeGridDataWrapper> wrapperObj= new List<TreeGridDataWrapper>();
        system.debug('customerBoothdIds==='+customerBoothdIds);
        try{
            //String applicationSessionId= LC_IntegrationsApexController.getSessionIDWithLogin();
            //schemasMicrosoftCom200310Serializat_v1.ArrayOfint listOfCustomerBoothIds = new schemasMicrosoftCom200310Serializat_v1.ArrayOfint();
            Show_MicrosoftCom200310Serializat.ArrayOfint listOfCustomerBoothIds= new Show_MicrosoftCom200310Serializat.ArrayOfint();
            listOfCustomerBoothIds.int_x= new List<Integer>();
            for(integer i=0; i<=customerBoothdIds.size()-1;i++){
                listOfCustomerBoothIds.int_x.add(customerBoothdIds[i]);
            }
            Summ_wwwViadComV1.BasicHttpBinding_IOrderService  serviceObject = new Summ_wwwViadComV1.BasicHttpBinding_IOrderService ();
            wwwViadComDataV3_v1.ArrayOfOrderCompositeSummary ArrayOfOrderCompositeSummary=serviceObject.GetBoothOrderSummaries(applicationSessionId,listOfCustomerBoothIds,null);
            for(wwwViadComDataV3_v1.OrderCompositeSummary OrderCompositeSummary:ArrayOfOrderCompositeSummary.OrderCompositeSummary){
                system.debug('OrderCompositeSummary.OrderHeaderSummary==='+OrderCompositeSummary.OrderHeaderSummary);
                TreeGridDataWrapper exInforWrap= new TreeGridDataWrapper(OrderCompositeSummary);
                wrapperObj.add(exInforWrap);
            }
            
        }catch(exception e){
            system.debug(e.getMessage());
            system.debug('applicationSessionId==='+applicationSessionId);
        }
        //system.debug('wrapperObj'+wrapperObj);
        return wrapperObj;
    }
    
    @AuraEnabled
    public static Map<String,List<TreeGridDataWrapper>> getExhibitorOrdersMap(List<integer> customerBoothdIds, string applicationSessionId){
		Map<String,List<TreeGridDataWrapper>> resultingMap= new Map<String,List<TreeGridDataWrapper>>();
		List<TreeGridDataWrapper> currentGridOrders= getExhibitorOrders(customerBoothdIds, applicationSessionId);
		if(currentGridOrders!=null){
			for(TreeGridDataWrapper singleOrderWrapper:currentGridOrders){
				if(!resultingMap.containsKey(singleOrderWrapper.parentIdType)){
					resultingMap.put(singleOrderWrapper.parentIdType, new List<TreeGridDataWrapper>());
				}
				resultingMap.get(singleOrderWrapper.parentIdType).add(singleOrderWrapper);
			}
		}
		return resultingMap;
	}
    
    public class orderExhibitorInfoWrapper {
        @AuraEnabled public String CustomerBoothId;        
        @AuraEnabled public String id_Type;        
        @AuraEnabled public String OrderStatus;        
        @AuraEnabled public String OrderType;

        public orderExhibitorInfoWrapper(wwwViadComDataV3_v1.OrderCompositeSummary OrderCompositeSummary){
            this.CustomerBoothId    = (OrderCompositeSummary.OrderHeaderSummary.CustomerBoothId!= null ? string.valueOf(OrderCompositeSummary.OrderHeaderSummary.CustomerBoothId): '');
            this.id_Type    = (OrderCompositeSummary.OrderHeaderSummary.OrderNumber!= null ? string.valueOf(OrderCompositeSummary.OrderHeaderSummary.OrderNumber)+'_OrderSum': '');
            this.OrderStatus    = (OrderCompositeSummary.OrderHeaderSummary.OrderStatus!= null ? OrderCompositeSummary.OrderHeaderSummary.OrderStatus: '');
            this.OrderType      = (OrderCompositeSummary.OrderHeaderSummary.OrderType!= null ? OrderCompositeSummary.OrderHeaderSummary.OrderType: '');
            
        }
    }
	
	public class BoothSummaryWrapper {
		@AuraEnabled public string id_Type;        
        @AuraEnabled public String OperationsZone;        
        @AuraEnabled public String ServiceZone;        
        @AuraEnabled public Integer ShowOccrProjectId;
		@AuraEnabled public List<orderExhibitorInfoWrapper> boothOrders;
		
		public BoothSummaryWrapper(wwwViadComV1_all.BoothSummary singleBoothSummary){
			this.id_Type= string.valueOf(singleBoothSummary.CustomerBoothId)+'_Booth';
			this.OperationsZone=string.isNotBlank(singleBoothSummary.OperationsZone)?singleBoothSummary.OperationsZone:'';
			this.ServiceZone=string.isNotBlank(singleBoothSummary.ServiceZone)?singleBoothSummary.ServiceZone:'';
			this.ShowOccrProjectId=singleBoothSummary.ShowOccrProjectId;
			this.boothOrders= new List<orderExhibitorInfoWrapper>();
		}
	}
    
    public class TreeGridDataWrapper {
		@AuraEnabled public string id_Type;
		@AuraEnabled public string column1;
		@AuraEnabled public string column2; 
		@AuraEnabled public string column3; 
		@AuraEnabled public string column4; 
		@AuraEnabled public string parentIdType;
		@AuraEnabled public List<TreeGridDataWrapper> children;
		
		public TreeGridDataWrapper(wwwViadComV1_all.BoothSummary singleBoothSummary){
			this.id_Type= string.valueOf(singleBoothSummary.CustomerBoothId)+'_Booth';
			this.column1=string.isNotBlank(singleBoothSummary.OperationsZone)?singleBoothSummary.OperationsZone:'';
			this.column2=string.isNotBlank(singleBoothSummary.ServiceZone)?singleBoothSummary.ServiceZone:'';
			this.column4=(singleBoothSummary.ShowOccrProjectId!=null)? string.valueOf(singleBoothSummary.ShowOccrProjectId):'';
			this.children= new List<TreeGridDataWrapper>();
		}
		
		public TreeGridDataWrapper(wwwViadComDataV3_v1.OrderCompositeSummary OrderCompositeSummary){
			this.id_Type    = (OrderCompositeSummary.OrderHeaderSummary.OrderNumber!= null ? string.valueOf(OrderCompositeSummary.OrderHeaderSummary.OrderNumber)+'_OrderSum': '');
            this.parentIdType    = (OrderCompositeSummary.OrderHeaderSummary.CustomerBoothId!= null ? string.valueOf(OrderCompositeSummary.OrderHeaderSummary.CustomerBoothId)+'_Booth': '');
            this.column1    = (OrderCompositeSummary.OrderHeaderSummary.CustomerBoothId!= null ? string.valueOf(OrderCompositeSummary.OrderHeaderSummary.CustomerBoothId): '');
            this.column2    = (OrderCompositeSummary.OrderHeaderSummary.OrderStatus!= null ? OrderCompositeSummary.OrderHeaderSummary.OrderStatus: '');
            this.column3      = (OrderCompositeSummary.OrderHeaderSummary.OrderType!= null ? OrderCompositeSummary.OrderHeaderSummary.OrderType: '');
            this.children= new List<TreeGridDataWrapper>();
        }
		
		public TreeGridDataWrapper(String orderCompSummaryHeader){
			this.id_Type    = '';
            this.column1    = 'Customer Booth Id';
            this.column2    = 'Order Status';
            this.column3      = 'Order Type';
        }
	}
    */
}