public with sharing class RedirectFlowController {
    
    public Flow.Interview.Case_Create_Case_from_BoothContact createFromBC {get;set;}
    public Flow.Interview.Case_Raise_Case_from_Booth createFromB {get;set;}
    public Flow.Interview.EMEA_Case_From_Exhibition_Opportunity createFromOpty {get;set;}
    public Oracle_Show_Booth_Contact__c thisBC {get;set;}
    
    public RedirectFlowController(apexPages.standardController standardController){

    }
    
    public RedirectFlowController(){
        
    }
    
    public pageReference redirectCaseFromBC{
        get{
            String caseId;
            try{
            caseId = (String)createFromBC.getVariableValue('newCase'); //this will return a null value if not in try/catch - resolution not yet found
            }
            catch(exception e){}
            UpdateCaseToYes(caseId);
            PageReference pageRef = Page.UpdateCase;//new PageReference('/' + caseId);
            pageRef.getParameters().put('id', caseId);
            pageRef.setRedirect(true);
            return pageRef;
        }
        set{ 
            //not setting this value as of now
        }
    }
    
    public pageReference redirectCaseFromB{
        get{
            String caseId;
            try{
            caseId = (String)createFromB.getVariableValue('newCase'); //this will return a null value if not in try/catch - resolution not yet found
            }
            catch(exception e){}
            UpdateCaseToYes(caseId);
            PageReference pageRef = Page.UpdateCase;//new PageReference('/' + caseId);
            pageRef.getParameters().put('id', caseId);
            pageRef.setRedirect(true);
            return pageRef;
        }
        set{ 
            //not setting this value as of now
        }
    }
    
    public pageReference redirectCaseFromOpty{
        get{
            String caseId;
            try{
            caseId = (String)createFromOpty.getVariableValue('newCase'); //this will return a null value if not in try/catch - resolution not yet found
            }
            catch(exception e){}
            UpdateCaseToYes(caseId);
            PageReference pageRef = Page.UpdateCase;//new PageReference('/' + caseId);
            pageRef.getParameters().put('id', caseId);
            pageRef.setRedirect(true);
            return pageRef;
        }
        set{ 
            //not setting this value as of now
        }
    }
    
    private void UpdateCaseToYes(String caseId) {
        try {
            System.debug(caseId);
            Case c = [SELECT Id FROM Case WHERE Id = :caseId];
            c.GES_Type__c = 'General Event Enquiry/Other';
            c.Priority = 'Low Priority';
            c.Status = 'Open';
            c.Customer_Type__c = 'Exhibitor';
            c.Show_Status__c = 'Showsite (Build)';
            c.Origin = 'Showsite';
            update c;
        } catch(Exception ex) {
            System.debug(ex);
        }
    }

}