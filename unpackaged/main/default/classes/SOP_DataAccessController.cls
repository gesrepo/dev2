public with sharing class SOP_DataAccessController {
    public String errorMsg {get;set;}
    public boolean showPopup {get;set;}
    public boolean renderParent {get;set;}
    public boolean renderChild {get;set;}
    public String selectedService {get;set;}
    public String parentId {get;set;}
    public Decimal subTotal {get;set;}
    public String currencySym {get;set;}

    public List<SOP_APIIntegration.EventCatalogueWrapper> catList {get; private set;}
    public List<SOP_APIIntegration.EventCatalogueItemWrapper> catItemList {get; private set;}
    public List<SOP_APIIntegration.orderHistoryWrapper> orderHistoryList {get; set;}
    public SOP_APIIntegration.orderSummaryWrapper thisOrder {get; set;}
    public List<SOP_VIAD_V2.CustomerOrder> orderList {get; set;}
    public List<SOP_APIIntegration.orderSummaryItemWrapper> osiList {get; set;}
    public Map<SOP_APIIntegration.orderSummaryItemWrapper, List<SOP_APIIntegration.orderSummaryItemWrapper>> catItemMap {get; private set;}
    //public List<Map<String, List<SOP_APIIntegration.EventCatalogueItemWrapper>>> sortCatItemsList {get; private set;}
    public Map<String, List<SOP_APIIntegration.EventCatalogueItemWrapper>> childMap {get; private set;}
    public List<SOP_APIIntegration.EventCatalogueItemWrapper> parentList {get; private set;}
    public List<SOP_APIIntegration.EventCatalogueItemWrapper> childList {get; private set;}
    
    public String caseId;
    public String acctId;
    public String sessionId;
    
    private String userName;
    private String pwd;
    
    private String requestType;
    private String objectId;
    private String eventId;
    private String sopInstance;
    private SOP_wwwViadComSecurityV2.AppSessionInfo sessionInfo;
    
    private Case thisCase;
    private Account thisAccount;
    
    public SOP_DataAccessController(apexPages.StandardController controller){
    	Case c;
    	try{
    		this.thisCase = (Case)controller.getRecord();
    		caseId = thisCase.Id;
	        c = [SELECT Id, AccountId, Show_Opportunity__r.SOP_Event_ID__c, Show_Opportunity__r.SOP_Instance__c FROM Case WHERE Id =: caseId];
	        eventId = String.valueOf(c.Show_Opportunity__r.SOP_Event_ID__c);
	        sopInstance = c.Show_Opportunity__r.SOP_Instance__c;
    	}
    	catch(exception e){
    		//Not being accessed from a Case Record
    	}
    	try{
    		this.thisAccount = (Account)controller.getRecord();
    	}
    	catch(exception ex){
    		//Not being accessed from an Account Record
    	}
    	renderParent = false;
        renderChild = false;
        showPopup = false;
        acctId = thisCase != null ? c.AccountId : thisAccount.Id;
        SOPAuthentication__c auth = SOPAuthentication__c.getValues('Login Credentials');
        userName = auth.Username__c;
        pwd = auth.Password__c;
        sopInstance = sopInstance == null ? 'UK' : sopInstance;
        if(sopInstance == 'UK'){
        	currencySym = 'GBP';
        }
        else if(sopInstance == 'ME'){
        	currencySym = 'Dhs';
        }
        else if(sopInstance == 'EU'){
        	currencySym = 'EUR';
        } 
    }
      
    public SOP_DataAccessController(){
     	renderParent = false;
        renderChild = false;
        showPopup = false;
        acctId = ApexPages.currentPage().getParameters().get('acctId');
        SOPAuthentication__c auth = SOPAuthentication__c.getValues('Login Credentials');
        userName = auth.Username__c;
        pwd = auth.Password__c;
        if(ApexPages.currentPage().getParameters().get('caseId') != '' && ApexPages.currentPage().getParameters().get('caseId') != null) {
            caseId = ApexPages.currentPage().getParameters().get('caseId');
            Case c = [SELECT Id, Show_Opportunity__r.SOP_Event_ID__c, Show_Opportunity__r.SOP_Instance__c FROM Case WHERE Id =: caseId];
            eventId = String.valueOf(c.Show_Opportunity__r.SOP_Event_ID__c);
            sopInstance = c.Show_Opportunity__r.SOP_Instance__c;
        }
        sopInstance = sopInstance == null ? 'UK' : sopInstance;
        if(sopInstance == 'UK'){
        	currencySym = 'GBP';
        }
        else if(sopInstance == 'ME'){
        	currencySym = 'Dhs';
        }
        else if(sopInstance == 'EU'){
        	currencySym = 'EUR';
        }
        //else if(apex)
     }
    
    private void authenticate(){
    	//if(!test.isRunningTest()){
    		try{
		        sessionInfo = SOP_APIIntegration.authenticate(userName, pwd);
		        sessionId = sessionInfo.SessionId;
    		}
    		catch(exception e){
    			system.debug('*********************ERROR: '+e.getMessage());
    		}
    	//}
    }
    
    public pageReference serviceRedirect(){
        PageReference pr;
        if(selectedService == '--None--'){
            //add error
            return null;
        }
        else if(selectedService == 'Order History'){
            pr = Page.ViewOrderHistory;
            pr.getParameters().put('acctId', acctId);
            if(thisCase != null){
            	pr.getParameters().put('caseId', caseId);
            }
        }
        else if(selectedService == 'Catalogues'){
            pr = Page.ViewCatalogues;
            pr.getParameters().put('acctId', acctId);
            pr.getParameters().put('caseId', caseId);
        }
        
        return pr;
    }
    
    public pageReference returnToSelect(){
        PageReference pr;
        if(caseId != null){
        	pr = Page.ViewSopData;
        	pr.getParameters().put('Id', caseId);
        }
        else{
        	pr = Page.ViewSopData_Account;
        	pr.getParameters().put('Id', acctId);
        }
        return pr;
    }
    
    public void getServiceOrderHistory(){
        if(orderHistoryList == null || orderHistoryList.isEmpty()){
            authenticate();
            orderHistoryList = new List<SOP_APIIntegration.orderHistoryWrapper>();
            orderHistoryList = SOP_APIIntegration.getServiceOrderHistory(sessionId, acctId);
        }
    }
    
    public void getEventCatalogues(){
        if(catList == null || catList.isEmpty()){
            authenticate();
            catList = new List<SOP_APIIntegration.EventCatalogueWrapper>();
            catList = SOP_APIIntegration.getEventCatalogRequest(sessionId, eventId, sopInstance);
        }
    }
    
    public void getEventCatalogueItems(String catNumber){
        if(catItemList == null || catItemList.isEmpty()){
            authenticate();
            catItemList = new List<SOP_APIIntegration.EventCatalogueItemWrapper>();
            catItemList = SOP_APIIntegration.getEventCatalogItemsRequest(sessionId, catNumber, sopInstance);
        }
    }
    
    public void showHidePopup(){
        showPopup =! showPopup;
        if(showPopup == true){
            if(sessionId == null){
                authenticate();
            }
            String num;
            if(ApexPages.currentPage().getParameters().get('orderNum') != null){
                num = ApexPages.currentPage().getParameters().get('orderNum');
                if(!orderHistoryList.isEmpty()){
                    SOP_APIIntegration.orderHistoryWrapper thisWrapper;
                    for(SOP_APIIntegration.orderHistoryWrapper o : orderHistoryList){
                        if(Integer.valueOf(num) == o.orderNo){
                            thisWrapper = o;
                            sopInstance = thisWrapper.Instance;
                            thisOrder = SOP_APIIntegration.getServiceOrderSummary(sessionId, o.orderNo, sopInstance);
                            osiList = SOP_APIIntegration.getServiceOrderItems(sessionId, sopInstance, thisOrder);
                            calcItems(osiList);
                            break;
                        }
                    }
                }
                else{
                    //no order history
                }
            }
            else if(ApexPages.currentPage().getParameters().get('catId') != null){
                num = ApexPages.currentPage().getParameters().get('catId');
                catItemList = new List<SOP_APIIntegration.EventCatalogueItemWrapper>();
                catItemList = SOP_APIIntegration.getEventCatalogItemsRequest(sessionId, num, sopInstance);              
                for(SOP_APIIntegration.EventCatalogueItemWrapper c : catItemList){
                    if(c.ParentId == null || c.ParentId.trim() == ''){
                        List<SOP_APIIntegration.EventCatalogueItemWrapper> childList = new List<SOP_APIIntegration.EventCatalogueItemWrapper>();
                        for(SOP_APIIntegration.EventCatalogueItemWrapper cc : catItemList){
                            if(cc.ID != c.ID && cc.ParentId == c.ID){
                                childList.add(cc);
                            }
                        }
                        if(childMap == null){
                            childMap = new Map<String, List<SOP_APIIntegration.EventCatalogueItemWrapper>>();
                        }
                        if(parentList == null){
                            parentList = new List<SOP_APIIntegration.EventCatalogueItemWrapper>();
                            renderParent = true;
                        }
                        parentList.add(c);
                        childMap.put(c.ID, childList);
                    }
                }
            }
        }
    }
    
    public void showCatalogueChildren(){
        parentId = ApexPages.currentPage().getParameters().get('parentId');
        for(String s : childMap.keySet()){
            if(s == parentId){
                childList = childMap.get(s);
                break;
            }
        }
        renderChild = true;
        renderParent = false;
    }
    
    public void showCatalogueParents(){
        renderChild = false;
        renderParent = true;
    }
    
    public void calcItems(List<SOP_APIIntegration.orderSummaryItemWrapper> items){
    	if(items != null && !items.isEmpty()){
    		subTotal = 0;
    		for(SOP_APIIntegration.orderSummaryItemWrapper i : items){
    			if(i.SubTotal == null){
    				i.SubTotal = 0;
    			}
    			subTotal += i.SubTotal;
    		}
    	}
    }
}