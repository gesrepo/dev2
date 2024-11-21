public class GC_DesignElement_EditController {
    public boolean isEdit {get; set;}
    //public boolean isDETThere {get; set;}
    public GC_Design_Element__c designElement{get;set;}
    public Boolean checkFlagForDeliverable{get; set;}
    string showRevTemp= '';
    public String showCity = '';
    public String cityCode='';
    public GC_DesignElement_EditController(ApexPages.StandardController stdController){
        String id= ApexPages.currentPage().getParameters().get('id');
        String drfId= ApexPages.currentPage().getParameters().get('drfId');
        if(String.isNotBlank(id)){
            isEdit = true;
            designElement=[SELECT id, name,LOC1__c, LOC2__c, LOC3__c, LOC4__c,LOC5__c,LOC6__c,LOC7__c,
                           LOC8__c,LOC9__c,LOC10__c,Date_Assigned__c,Requested_Due_Date__c,Status__c,Estimated_Design_Hours__c,
                           Task_Type__c,Design_Request_Form__c, Design_Element__c, Task_Description__c,Requester__c,
                           Deliverable__c,Rework__c,Deliverable_Other__c, Unit_Budget_Structure_and_Graphics__c, 
                           Submit_Date__c, Active__c, Task_Instruction__c, Revision__c,  Previous_Task_Instructions__c, 
                           //Account_Manager__c, Detailer_Approver__c, Secondary_Account_Manager__c, Detailer_Approver2__c, 
                           //Amarab 04062021 SAL-1243 Replacing old Designer/Detailer Approver1 field with new field
                           Account_Manager__c, Contact_Designer_Detailer_Approver1__c, Secondary_Account_Manager__c, Detailer_Approver2__c, 
                           Creative_Director_Approvers__c, Detailer_Approver3__c, Traffic_Administrator_Approver__c, 
                           Detailer_Approver4__c, Detailer_Approver5__c, Designer_Notes__c, Metal_Color__c, Fill_Panel_Description__c,
                           Fast_Track__c,Fast_Track_Justification__c, Requestor_Shared_Files_Link__c, Director_of_Account_Manager__c, Justification_For_Deliverable__c, Connect2_Show__c, Show_Revenue__c
                           FROM GC_Design_Element__c where id =:id];
                           //SAL-1293 - DRF is no longer exist, updated showRevTemp - 12/22/23 - Sajid
                           //showRevTemp= string.isNotBlank(designElement.Design_Request_Form__r.FormulaShowRevenue__c) ? designElement.Design_Request_Form__r.FormulaShowRevenue__c : '0' ;
                           showRevTemp= string.isNotBlank(designElement.Show_Revenue__c) ? designElement.Show_Revenue__c : '0' ;
        }else{
            designElement= new GC_Design_Element__c();
            if(String.isNotBlank(drfId)){
                designElement.Design_Request_Form__c=drfId;
                
                //DET DAM Approver
                GC_Design_Request_Form__c drf= [Select id, FormulaCityCode__c, FormulaShowJobNumber__c, RecordType_Name__c, Connect2_Show__c,FormulaShowRevenue__c from GC_Design_Request_Form__c WHERE id=:drfId];
                showRevTemp = string.isNotBlank(drf.FormulaShowRevenue__c) ? drf.FormulaShowRevenue__c: '0';
                cityCode = String.isNotBlank(drf.FormulaShowJobNumber__c) ? drf.FormulaShowJobNumber__c.substringBefore('-'): '12345';
                String recordTypeName = String.isNotBlank(drf.RecordType_Name__c) ? drf.RecordType_Name__c: '';
                String query = 'SELECT id, User_ID__c, City_Code__c FROM GC_DETDAMApprover__mdt where City_Code__c LIKE \'%' ;
                List<GC_DETDAMApprover__mdt> damApprovers= Database.query(query+ cityCode + '%\'');
                //system.debug('damApprovers==='+damApprovers);
                //system.debug('cityCode==='+cityCode);
                
                for(GC_DETDAMApprover__mdt damApprover: damApprovers){
                    List<String> allCityCodes = damApprover.City_Code__c.split(',');
                    if(allCityCodes.contains(cityCode)){
                        designElement.Director_of_Account_Manager__c= damApprover.User_ID__c;
                    }
                }
                
                //DET CD Approver
                //
                try{
                    GC_Design_Request_Form__c parentDRF =[SELECT id, Connect2_Show__r.Opportunity_Id__c, Connect2_Show__r.Opportunity_Name__c FROM GC_Design_Request_Form__c WHERE id=:designElement.Design_Request_Form__c];
                    Opportunity parentOppty =[SELECT id, Account.Name, Account.BillingCity, Production_Location__c from Opportunity WHERE id=:parentDRF.Connect2_Show__r.Opportunity_Name__c LIMIT 1 ];
                    showCity = parentOppty.Account.BillingCity;
                    system.debug('show city =========' + showCity);
                }catch(exception e){
                    system.debug(e.getStackTraceString());
                    system.debug(e.getMessage());
                }
                
                if(drf.RecordType_Name__c =='RFP (Exhibition or Event)'){
                    String query1 = 'SELECT id, User_ID__c, Record_Type_Name__c  FROM GC_DETCDApprover__mdt where Record_Type_Name__c LIKE \'%' + recordTypeName + '%\'';
                    List<GC_DETCDApprover__mdt> cdApprovers = Database.query(query1);
                    for(GC_DETCDApprover__mdt cdApprover: cdApprovers){
                        if(cdApprover.Record_Type_Name__c.equals(recordTypeName)){
                            designElement.Creative_Director_Approvers__c = cdApprover.User_ID__c;
                        }
                    }
                }
                else{
                    if(showCity.equalsIgnoreCase('cleveland')){
                        cityCode = showCity;
                    }
                    String query1 = 'SELECT id, User_ID__c, City_Code__c FROM GC_DETCDApprover__mdt where City_Code__c LIKE \'%' + cityCode + '%\'';
                    
                    List<GC_DETCDApprover__mdt> cdApprovers= Database.query(query1);
                    for(GC_DETCDApprover__mdt cdApprover: cdApprovers){
                        List<String> allCityCodes = cdApprover.City_Code__c.split(',');
                        system.debug('allCityCodes==='+allCityCodes);
                        if(allCityCodes.contains(cityCode)){
                            designElement.Creative_Director_Approvers__c= cdApprover.User_ID__c;
                            system.debug('User_ID__c==='+cdApprover.User_ID__c);
                        }
                    }
                }
                
                //DET TA Approver
                String queryTAAs = 'SELECT id, User_ID__c, City_Code__c FROM GC_DET_TAApprover__mdt where City_Code__c LIKE \'%' + cityCode + '%\'';
                List<GC_DET_TAApprover__mdt> tAApprovers = Database.query(queryTAAs);
                for(GC_DET_TAApprover__mdt tAApprover: tAApprovers){
                    List<String> allCityCodes = tAApprover.City_Code__c.split(',');
                    if(allCityCodes.contains(cityCode)){
                        designElement.Traffic_Administrator_Approver__c= tAApprover.User_ID__c;
                    }
                }
            }
            designElement.Requester__c= UserInfo.getUserId();
            designElement.Account_Manager__c= UserInfo.getUserId();
            isEdit = false;
        }
    }
    public GC_DesignElement_EditController(){
        isEdit = false;
    }
    public void changeMode(){
        isEdit = true;
    }
    public PageReference saveRecord(){
        try{
            upsert designElement;
            PageReference pr = Page.GC_DesignElementCustom;
            pr.getParameters().put('id',designElement.id);
            return pr;
        }catch(exception e){
            system.debug('error=='+e.getMessage()+e.getStackTraceString());
            return null;
        }
    }
    
    public PageReference cancelAndBack(){
        try{
            //SAL-1293 - retrun to the Element task record - 12/20/23 - Sajid
            //String baseURL= URL.getSalesforceBaseUrl().toExternalForm()+'/'+ designElement.Design_Request_Form__c;
            //String baseURL= URL.getSalesforceBaseUrl().toExternalForm()+'/'+ designElement.Id; // method getSalesforceBaseUrl is removed from api version 59, so replaced with by getOrgDomainURL()
            String baseURL= URL.getOrgDomainURL().toExternalForm()+'/'+ designElement.Id;
            PageReference pr = new PageReference(baseURL);
            return pr;
        }catch(exception e){
            system.debug('error=='+e.getMessage()+e.getStackTraceString());
            return null;
        }
    }
  //adding detailing condition and fixing deliverable check to correct field 1/29/2019 -CB  
    public PageReference checkandValidate(){
        Double showRevenue = Double.ValueOf(showRevTemp);
        if(showRevenue<= 200000.00){
            if (designElement.Task_Type__c=='Detailing'){
            checkFlagForDeliverable = false;
            }else{
            checkFlagForDeliverable = true;}
        }
    else if (showRevenue> 200000.00 && showRevenue <= 500000.00 && designElement.Design_Element__c!='Design Style Guide')
    {
            checkFlagForDeliverable = true;
            }
    else{
            checkFlagForDeliverable = false;
        }
        
        return null;
    }
}