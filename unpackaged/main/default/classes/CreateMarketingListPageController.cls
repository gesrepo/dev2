public class CreateMarketingListPageController{

    transient string sourceCode;
    transient string showId;
    transient Marketing_Source_List__c marketingSourceList;
	static final integer BatchSize = 200; //Changed from 1000 to 200 as for loop batchsize governor limit is 200
    
    public CreateMarketingListPageController() {
    }
    
    public string getName() {
        return 'CreateMarketingListPageController';
    }
    
    public string getSourceCode() {
        if (sourceCode != null && sourceCode != '')
            sourceCode = sourceCode.toUpperCase();
        return sourceCode;
    }
    
    public void setSourceCode(string value) {
        sourceCode = value.toUpperCase();
    }
    
    public string getShowId() {
        return MarketingSourceList.Show_Occurrence__c;
    }
   
    public Marketing_Source_List__c getMarketingSourceList() {
        if (marketingSourceList == null)
            marketingSourceList = new Marketing_Source_List__c();
        return marketingSourceList;
    }
    
    public void setMarketingSourceList(Marketing_Source_List__c value) {
        marketingSourceList = value;
    }
    
    public PageReference Save() {
               
        try {
        
            string ActiveSourceCode = this.getSourceCode();
            string ActiveShowId = this.getShowId();
            
            if (ActiveSourceCode == null || ActiveSourceCode == '')
            {
                ApexPages.Message Msg = new ApexPages.Message(ApexPages.Severity.FATAL,'Please enter a Source Code.');
                ApexPages.addMessage(Msg);            
            }
            else if (ActiveShowId == null || ActiveShowId == '')
            {
                ApexPages.Message Msg = new ApexPages.Message(ApexPages.Severity.FATAL,'Please select a Show Occurrence.');
                ApexPages.addMessage(Msg);                 
            }
            else
            {
            	/*
                Integer ConCount = AssociateContacts(ActiveSourceCode, ActiveShowId);
                Integer LeadCount = AssociateLeads(ActiveSourceCode, ActiveShowId);
                ApexPages.Message Msg = new ApexPages.Message(ApexPages.Severity.INFO,'Processed ' + ConCount + ' Contact(s) and ' + LeadCount + ' Lead(s).');
                ApexPages.addMessage(Msg);             	
            	*/
            	
            	Integer ConCount = 0;
            	Integer LeadCount = 0;

               	ConCount = AssociateContacts(ActiveSourceCode, ActiveShowId);
          		LeadCount = AssociateLeads(ActiveSourceCode, ActiveShowId);

                ApexPages.Message Msg = new ApexPages.Message(ApexPages.Severity.INFO,'Processed ' + ConCount + ' Contact(s) and ' + LeadCount + ' Lead(s).');
                ApexPages.addMessage(Msg);                
            }
            
        }
        catch(Exception e)
        {
            ApexPages.addMessages(e);
        }
        
        PageReference p = new ApexPages.StandardController(marketingSourceList).view();
        p.setRedirect(true);
        
        return p;
    } 
    
    /*
    public PageReference Cancel() {
    
        String ObjectPrefix = Marketing_Source_List__c.sObjectType.getDescribe().getKeyPrefix();
              
        PageReference p = new PageReference('/'+ObjectPrefix);
        //p.setRedirect(true);
    
        return p;      
        
    }    
    */
    
    private Integer AssociateLeads(string sourceCode, string showId)
    {
        Integer Count = 0;
    	Integer BatchCount = 0;
    	Integer ErrorCount = 0;     
        
        /*
        *****************************************
        Updated By: Joy Varughese
        Updated: 2010-09-28
   		*****************************************
        Instead of creating the list upfront, create it inline. This approach minimizes use of heap.

    	Also, revise code to insert in batches instead of one at at time - design to handle governor limits
    	better. Create a List object to store the Marketing source Lists which need to be inserted and then
    	insert in batches to reduce the number of DMLs issued.
    		
    	*****************************************
    	*/ 
    	
    	List<Marketing_Source_List__c> ListOfMktSrcList = new List<Marketing_Source_List__c>();
    	
    	//Get list of Leads which do not already have a Marketing Source List entry for the given Source Code
        for (Lead lead : [Select Id from Lead Where Active_Source_Code__c = :sourceCode And Id Not In (Select Lead__c From Marketing_Source_List__c Where Source_Code__c = :sourceCode And Show_Occurrence__c = :showId)])
        {
            Marketing_Source_List__c MktSrc = new Marketing_Source_List__c();
            MktSrc.Source_Code__c = sourceCode;
            MktSrc.Lead__c = lead.Id;
            MktSrc.Show_Occurrence__c = showId;
            
            //Add object to list
            ListOfMktSrcList.add(MktSrc);
            
            BatchCount++;
            Count++;
            
            if (BatchCount == BatchSize)
            {           	           	
            	List<Database.Saveresult> InsertResults = Database.insert(ListOfMktSrcList, false);
                
                //Process any failures
                for(Database.Saveresult result: InsertResults)
                {
                	if (!result.isSuccess()){
                		ErrorCount++;
                	}
                }
                
                ListOfMktSrcList.Clear();
                BatchCount = 0;
            }
        }
        
        //If last batch has fewer than BatchSize rows, invoke insert one last time
        if (BatchCount > 0)
        {    	
            List<Database.Saveresult> InsertResults = Database.insert(ListOfMktSrcList, false);         
            
            //Process any failures
            for(Database.Saveresult result: InsertResults)
            {
            	if (!result.isSuccess()){
            		ErrorCount++;
            	}
            }
                            
            ListOfMktSrcList.Clear();
            BatchCount = 0;
        }         
        
        return Count;       
    }
    
    private Integer AssociateContacts(string sourceCode, string showId)
    {
        Integer Count = 0;
    	Integer BatchCount = 0;
    	Integer ErrorCount = 0; 
        
        /*
        *****************************************
        Updated By: Joy Varughese
        Updated: 2010-09-28
   		*****************************************
        Instead of creating the list upfront, create it inline. This approach minimizes use of heap.

    	Also, revise code to insert in batches instead of one at at time - design to handle governor limits
    	better. Create a List object to store the Marketing source Lists which need to be inserted and then
    	insert in batches to reduce the number of DMLs issued.
    		
    	*****************************************
    	*/ 
    	
    	List<Marketing_Source_List__c> ListOfMktSrcList = new List<Marketing_Source_List__c>();
    	
    	//Get list of Contacts who do not already has a Marketing Source List entry for the given Source Code
        for (Contact con : [Select Id from Contact Where Active_Source_Code__c = :sourceCode And Id Not In (Select Contact__c From Marketing_Source_List__c Where Source_Code__c = :sourceCode And Show_Occurrence__c = :showId)])
        {
            Marketing_Source_List__c MktSrc = new Marketing_Source_List__c();
            MktSrc.Source_Code__c = sourceCode;
            MktSrc.Contact__c = con.Id;
            MktSrc.Show_Occurrence__c = showId;
            
            //Add object to list
            ListOfMktSrcList.add(MktSrc);
            
            BatchCount++;
            Count++;
            
            if (BatchCount == BatchSize)
            {      	
                List<Database.Saveresult> InsertResults = Database.insert(ListOfMktSrcList, false);
                 
                //Process any failures
                for(Database.Saveresult result: InsertResults)
                {
                	if (!result.isSuccess()){
                		ErrorCount++;
                	}
                }
                
                ListOfMktSrcList.Clear();
                BatchCount = 0;
            }
        }
        
        //If last batch has fewer than BatchSize rows, invoke insert one last time
        if (BatchCount > 0)
        {        	
            List<Database.Saveresult> InsertResults = Database.insert(ListOfMktSrcList, false);
            	            
            //Process any failures
            for(Database.Saveresult result: InsertResults)
            {
            	if (!result.isSuccess()){
            		ErrorCount++;
            	}
            }
                            
            ListOfMktSrcList.Clear();
            BatchCount = 0;
        }         
        
        return Count;       
    }  
    
}