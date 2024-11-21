public with sharing class OpportunityListContExt {

    public Show__C theShow {get;set;}
	public Map<String,Set<String>> recordTypes {get;set;}
	public List<Opportunity> oppList {get;set;}
	public List<OppWrapper> oppWrapList {get;set;}
	
    private transient List<Opportunity> allOppListPrivate;
	public List<Opportunity> allOppList {
        get {
            if (allOppListPrivate == null) {
                String selectString = 'select name, id, facility_city__c, recordtypeid, ownerid, Sales_Person__c , amount, owner.name, account.name, probability,Prime_Contractor__c, accountid, Stagename, Show_Name__c, GBMSProjectStatus__c, GBMS_Show_ID__c,  Occurrence_City__c, Show_Occurrence__c, Show_Occurrence__r.name,  Show_Occurrence__r.Occurrence_City__c, Facility__c,Facility__r.billingcity  from opportunity where ' ;
	 			String allOppQuery = selectString+ parentFilterString;
                allOppListPrivate = Database.query(allOppQuery);
            }
            return allOppListPrivate;
        }
    }
	private Map<ID, String> rtToLOBMapping{get;set;}
	public Class OppWrapper { 
		public boolean directlyRelated {get; set;}
		public Opportunity opp {get; set;}
		public String lob {get; set;}
    //    public String FacilityCity {get; set;}		
	}
	
	//filter fields  - required and set from the parent record
	private String parentID; // show, opp or account
	private String parentFieldID; //corresponding field
	private Set<ID> parentOppIDs;//parent oppIDS
	
	
	private String parentFilterString; // full parent filterString;
	
	//user selected filterfields
	private Set <String> rtIDFilter; //current recordtypes we are filtering by
	
	public String stage {get;set;}
	public String selectedOppID {get;set;}
	
	public String selectedAcctID {get;set;} 
	public String selectedUserID {get;set;}
	public String selectedLOB {get;set;} 
	public String selectedFacilityCity {get;set;} 
	
	
	public List<String> selectedAcctIDs {get;set;}// multiselect account filter
	
	
	 private String sortExp;
     public String sortDirection {get;set;}
	 public String sortExpression  {
	     get{ return sortExp; }
	     set {
	       //if the column is clicked on then switch between Ascending and Descending modes
	       if (value == sortExp)
	         sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
	       else
	         sortDirection = 'ASC';
	       sortExp = value;
	     }
	   }
	
	
	public List<SelectOption> getLOB() {
		List<SelectOption> options = new List<SelectOption>();
 	 	options.add(new SelectOption('','All'));
 	 	List<String> orderedSet = new List<String>(recordTypes.keyset());
 	 	orderedSet.sort();
 	 	for(String key:orderedSet){
 	 		options.add(new SelectOption(key,key));
 	 		
 	 	}
 	 	
 	 	return options;

	}
	

	public void readConfig(){
		
		List<LOB__c> lobs = LOB__c.getall().values();
		
		Map<String,Set<String>> rtConfig = new  Map<String,Set<String>>();
		rtToLOBMapping= new Map<ID,String>();
		for (LOB__c lob : lobs){
			Set<String> valueSet = rtConfig.get(lob.Picklist_value__c);
			if (valueSet==null) {
				valueSet =  new Set<String>();
				rtConfig.put(lob.Picklist_value__c,valueSet);
			}
			valueSet.add(lob.RTDevName__c);
			ID rtID = RecordTypeUtil.getRecordTypeIDByDevName('Opportunity',lob.RTDevName__c);
			rtToLOBMapping.put(rtID,lob.Picklist_value__c);
		}
	
		recordTypes=  new Map<String,Set<String>>();	
		for (String key:rtConfig.keySet())		 {
			
			Set<String> devNames = rtConfig.get(key);
			Set<String> rtIDs = 	new Set<String> ();
			
			for (String devName:devNames){
				
				ID rtID = RecordTypeUtil.getRecordTypeIDByDevName('Opportunity',devName);
				
				rtIDs.add(String.valueOf(rtID)); 

			}
			recordTypes.put(key,rtIDs);
		}
			
		
	}
	
	public OpportunityListContExt(ApexPages.StandardController stdController) {
        SObject theSObject = stdController.getRecord();
        
       	Schema.sObjectType type = stdController.getRecord().getSObjectType().getDescribe().getsObjectType();
       	parentID = theSObject.id;
       	
        If (Account.sObjectType ==type ) {
        	parentFieldId = 'accountid';
        	getParentOpps();
        }
        If (Opportunity.sObjectType ==type ) {
        	parentFieldId = 'Show_Occurrence__c';
        	parentFilterString = parentFieldId + ' = :parentID';
        }
        If (Show__c.sObjectType ==type ) {
         	theShow = [select id,name from Show__C where id=:theSObject.id];
        	parentFieldId = 'Show_Name__c';
        	getParentOpps();
        }
        readConfig();
        sortDirection = 'DESC';
        sortExp = 'name';
      	counter = 0;
    	recNum=0;
    	limits = 10;
    	stage='All';
    
    	searchresult();        
    }
    
    /*
    private String buildURL(String projId, String equipID, String scopeID) {
		VisualForceUtil vfUtil = new VisualForceUtil('Opportunity');
		
		String url = sppiTestFieldUtil.editUrl;//'/a38/e?';		
		If (Show__c.sObjectType ==type ) {
         	theShow = [select id,name from Show__C where id=:theSObject.id];
        	parentFieldId = 'Show_Name__c';
        	String paramname = vfUtil.getParamNameFromApiName('Equipment__c');
			String lkupParam = vfUtil.getParamNameFromApiName('Equipment__c',true);
     	
			url+=paramname+'='+EncodingUtil.urlEncode(name,'UTF-8') +'&'+lkupParam+'='+equipId;
		}
		
		return url;
	
	}*/
    
    public integer counter {get;set;}
	public integer recNum {get;set;} // fix this later
	public Integer limits {get;set;}
		 
	public List<SelectOption> getStages() {
 	 	List<SelectOption> options = new List<SelectOption>();
 	 	options.add(new SelectOption('','All'));
 	 	
 	 	options.add(new SelectOption('Open','Open'));
 	 	
 	 	options.add(new SelectOption('Won','Won'));
 	 	options.add(new SelectOption('Lost','Lost'));
 	 	return options;
  	}
    
  	private void getParentOpps(){
  		String filter = parentFieldId + ' = :parentID'; 
  		
  		String query = 'select id from opportunity where '+filter;
		
		List<Opportunity> parentOpps = Database.query(query);
		parentOppIDs= new Set<ID>();
  		for (Opportunity opp:parentOpps) {
  			parentOppIDs.add(opp.id);
  		}
  		filter = ' (Show_Occurrence__c in :parentOppIDs or ' + parentFieldId + ' = :parentID)';
  		//filter = ' (Show_Occurrence__c in :parentOppIDs)';
  		
  		parentFilterString = filter;
  		
  	}
  		
	private String getFilterString(){
		String filter='';
		if (stage=='Open'){
			filter += ' and isClosed=false';
		}
		else if (stage=='Won'){
			filter += ' and isWon=true';	
		}
		else if(stage=='Lost'){
			filter += ' and isWon=false and isClosed=true ';

		}
		//filter by accountIDS
		
		if(selectedAcctID!=null && selectedAcctID!=''){
			filter += ' and accountID = :selectedAcctID ';
		}
        
		if(selectedUserID!=null && selectedUserID!=''){
			//filter += ' and Sales_Person__c = :selectedUserID ';
			filter += ' and OwnerID = :selectedUserID ';
			
		}
		if (selectedLOB!=null && selectedLOB!=''){
			
			rtIDFilter = recordTypes.get(selectedLOB);
			filter += ' and recordTypeID in: rtIDFilter';
		}
		if (selectedFacilityCity!=null && selectedFacilityCity!=''){
			
			filter += ' and Facility_City__c =: selectedFacilityCity';
		}
		
		return filter;		
	}
	//same thing as search result except we reset the pagination
	public void newSearchResult(){
		counter=  0;
		searchresult();
	}
	
	public void searchresult(){
		//filter parent id - this is the master filter
		//String filter = parentFieldId + ' = :parentID'; 
		String filter = parentFilterString; 
		//filter stage
	
		filter+=getFilterString();
		
		String countQuery = 'select count() from opportunity where '+filter;
		System.debug('thequery:' + countQuery);
		
		recNum = Database.countQuery(countQuery);

	 	String selectString = 'select name, id, facility_city__c, recordtypeid, ownerid, Sales_Person__c , amount, owner.name, account.name, probability,Prime_Contractor__c, accountid, Stagename, Show_Name__c, GBMSProjectStatus__c, GBMS_Show_ID__c,  Occurrence_City__c, Show_Occurrence__c, Show_Occurrence__r.name,  Show_Occurrence__r.Occurrence_City__c, Facility__c,Facility__r.billingcity  from opportunity where ' ;
	 	String query = selectString+filter ;

		if (sortExpression!=null) {
       		query+= ' order by '+ sortExpression  + ' ' + sortDirection;
		}
		query += ' LIMIT ' + limits; 
		query += ' OFFSET ' + counter; 
    	this.oppList= Database.query(query);
    	//all opps no limits and offsets
    	
    	//dropdowns not being filtered out
    	String allOppQuery = selectString+ parentFilterString; //+filter ;
    	
    	//this.allOppList= Database.query(allOppQuery);//used by dropdowns to get list of possible values
    	// Force recache of allOppList
    	allOppListPrivate = null;
    	List<Opportunity> cache = allOppList;
    	 
    	oppWrapList = new List<OppWrapper>();
    	for (Opportunity opp:oppList) {
    		OppWrapper oppWrap = new OppWrapper();
    		oppWrap.opp = opp;
    		oppWrap.lob =rtToLOBMapping.get(opp.recordTypeID);
            
            // This is equivalent to the Occurrence_City_AV__c field. It is split up here
            // for clarity. When there is no related show occurrence, the facility city 
            // is defined by the occurrence_city__c field (same as Facility__r.BillingCity).
            // When there is related show occurrence, grab the same field from the related
            // Opportunity. In the Visual Force page, sorty using the Occurrence_City_AV__c
            // column (as the Wrapper field FacilityCity does not exist on the opportunity object)
         /*   if (opp.Show_Occurrence__c != null) {
                oppWrap.FacilityCity = opp.Show_Occurrence__r.Occurrence_City__c;
            }
            else { 
                oppWrap.FacilityCity = opp.Occurrence_City__c;
            }*/
            
    		SObject sobjectOpp = opp;
    		
    		String stringValue= String.valueof(sobjectOpp.get(parentFieldID));
    		if (stringValue !=null && stringValue.equals(parentID)) {
    			oppWrap.directlyRelated=true;
    		}
    		oppWrapList.add(oppWrap);
    	}
	
	}
	
	public List<SelectOption> getAccounts() {
		
		
		Set<ID> ids=new Set<ID>();
		for(Opportunity opp :allOppList){
			ids.add(opp.accountid);
		}
		List<Account> accounts = [select id,name from account where id in :ids order by name];
 	 	List<SelectOption> options = new List<SelectOption>();
 	 	options.add(new SelectOption('','All'));
 	 	
        for (Account acct: accounts) {
                options.add(new SelectOption(acct.id, acct.name)); 
        }
 	 	
 	 	return options;
  	}
  	public List<SelectOption> getUsers() {
  		
		Set<ID> ids=new Set<ID>();
		for(Opportunity opp :allOppList){
			ids.add(opp.ownerid);
		}
		
		List<User> users = [select id,name from User where id in :ids order by name];
 	 	List<SelectOption> options = new List<SelectOption>();
 	 	options.add(new SelectOption('','All'));
 	 	
 	 	 
        for (User var: users) {
                options.add(new SelectOption(var.id, var.name)); 
        }
 	 	
 	 	return options;
  	}
  	public List<SelectOption> getFacilityCities() {
  		
		Set<String> cities=new Set<String>();
		for(Opportunity opp :allOppList){
			if (opp.Facility_City__c!=null)
				cities.add(opp.Facility_City__c);
		}
		
 	 	List<SelectOption> options = new List<SelectOption>();
 	 	options.add(new SelectOption('','All'));
 	 	
 	 	 
        for (String city: cities) {
                options.add(new SelectOption(city, city)); 
        }
 	 	
 	 	return options;
  	}
  	  	
  	public void deleteOpp(){
  		Opportunity opp = [select id from opportunity where id = :selectedOppID];
  		delete opp;
		newSearchResult();

   }
  	  	
  	////Navigation
  	
	public void nextbtn(){
		
	    this.counter += limits ;
	    searchresult();
	}
	 
	public void prvbtn(){
	    this.counter -= limits ;
	    searchresult();
	}
	
	public void fstbtn(){
	    this.counter = 0;
	    searchresult();
	}
	
	public void endbtn(){
		integer remainder = math.mod(recNum,limits);
		remainder = (remainder==0)? limits : remainder;
	    this.counter = recNum - remainder;
	    
	    searchresult();
	}
	
	public boolean getprv(){
	    if(counter == 0)
	        return true;
	    else
	        return false;
	}
	
	public boolean getnxt(){
		
	    if((limits+counter) >= recNum)
	        return true;
	    else
	        return false;
	}
    
}