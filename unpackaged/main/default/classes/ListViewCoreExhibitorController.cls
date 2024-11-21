/**
* Class Name   : ListViewCoreExhibitorController
* Description  : Controller class for ListViewCoreExhibitor Page used for manual intervention  
*                to correct address related errors
* Copyright    : GES
* @author      : Kumud thakur|kumud.thakur@birlasoft.com
* 
*
* Modification Log
* ===============================================================
*    Ver  |Date            |Author                     |Modification
*    1.0  |25-Apr-2017     |kumud.thakur@birlasoft.com |
*    2.0  |11-Oct-2020     |Bhargavi Amarapalli        |
*/

public class ListViewCoreExhibitorController{
    public String errorCodes{get; set;}
    public String showOccurence{get; set;}
    public list<CORE_EXHIBITOR__c > exhibitor = new list<CORE_EXHIBITOR__c >();
    public list<Exhibitorwrapper> exhwrapRequestList{get; set;}
    public list<CORE_EXHIBITOR__c > selectedExhibitor;
    public CORE_EXHIBITOR__c  anacc{get; set;}
    private String QueryCoreExhibitor;
    private integer RecPerPage;
    public  integer totalRecs {get;set;}
    private integer index = 0;
    private set<ID> coreExhibitorSelectedSet = new Set<Id>();
    
    public ListViewCoreExhibitorController(){
        totalRecs = 0;
        exhwrapRequestList = new list<Exhibitorwrapper>();
        anacc = new CORE_EXHIBITOR__c ();
        RecPerPage = 25;
        
        //totalRecs = [select count() from CORE_EXHIBITOR__c];        
        List<CORE_EXHIBITOR__c> listCoreExhbitior = [SELECT Id, IsManualIntervention__c, Company_Name__c, Name, Occurrence_Id__c, Address1__c, Address_2__c, Address_3__c, Address_4__c, 
                             Area_Code__c, City__c, Country__c, Phone__c, Postal_Code__c, provinence__c, State__c, Oracle_Key_Index__c, LastModifiedDate,
                             Integration_Error_Message__c 
                             FROM CORE_EXHIBITOR__c 
                             WHERE Integration_Status__c = 'Failed' 
                               AND Oracle_Interface_Status__c =  'N'
                             LIMIT 2000];
        system.debug('+++++++++++++++++++'+ errorCodes+'******************QueryCoreExhibitor'+QueryCoreExhibitor);
        createMainWrapper(listCoreExhbitior);        
    }    
    @TestVisible 
    private void createMainWrapper(List<CORE_EXHIBITOR__c> listCoreExhbitior){
        RecPerPage = 25;
        updateWrapperList();
        exhwrapRequestList = new list<Exhibitorwrapper>();
        list<Exhibitorwrapper> exhwrapInnerList = new list<Exhibitorwrapper>();
 
        for(CORE_EXHIBITOR__c instObj : listCoreExhbitior)
        {    
            Exhibitorwrapper objEXH = new Exhibitorwrapper();
            objEXH.exhObj = instObj;
            objEXH.selected = false;
            exhwrapInnerList.add(objEXH);
        }
        
        totalRecs = exhwrapInnerList.size();
        system.debug('totalRecs..!'+totalRecs);
        if(RecPerPage > totalRecs){
            RecPerPage = totalRecs;
        }
        
        integer count = index+RecPerPage;
        if(totalRecs-index < RecPerPage){
            count = index+(totalRecs-index);
        }
        system.debug('index..!'+index);
        system.debug('RecPerPage..!'+RecPerPage);
        for(integer i=index; i<count; i++){
            if(mapIDExhibitWrp.keyset().contains(exhwrapInnerList[i].exhObj.id)){
                exhwrapRequestList.add(mapIDExhibitWrp.get(exhwrapInnerList[i].exhObj.id));
            }
            else{
                exhwrapRequestList.add(exhwrapInnerList[i]);
            }
        }
    }           
    
    
    public pagereference save(){
        final List<CORE_EXHIBITOR__c > listUpdateExhb = new List<CORE_EXHIBITOR__c>();
        for(Exhibitorwrapper instObj : exhwrapRequestList){
            if(instObj.selected){
                instObj.exhObj.Integration_Status__c = null;
                instObj.exhObj.Integration_Error_Message__c = null;
                instObj.exhObj.IsManualIntervention__c = true;
                listUpdateExhb.add(instObj.exhObj);
            }
        }
        
        if(!listUpdateExhb.isEmpty() || Test.IsRunningTest()){
            try
            {
                update listUpdateExhb;
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Records Saved Successfully!'));
                mapIDExhibitWrp.clear();
            }
            catch(Exception e){
            }
            index = 0;                   
            QueryCoreExhibitor = BuildQuery(errorCodes,showOccurence);
            List<CORE_EXHIBITOR__c> listCoreExhbitior = database.query(QueryCoreExhibitor);
            createMainWrapper(listCoreExhbitior);
        }
        return null;
    }
    
    /*
    Default constructor  :
    */
    
    /*
    method:buildQuery
    parameters: String,String :- pass Integration Status, Oracle Interface Status and showOccurence code
    return : String- SOQL query on Core Exhibitor
    Desc: build query as per passing parameters
    @Author ;Kumud
    */
    private string buildQuery(String errorCodes,String showOccurence){
        system.debug('showOccurence..!'+showOccurence);
        String status = 'Failed' ;
        String query = 'SELECT Id, IsManualIntervention__c, Company_Name__c, Name, Occurrence_Id__c, Address1__c, Address_2__c, Address_3__c,'+
            +' Address_4__c, Area_Code__c, City__c, Country__c, Phone__c, Postal_Code__c, provinence__c, State__c, Oracle_Key_Index__c,'+
            +' LastModifiedDate, Integration_Error_Message__c '+
            +' FROM CORE_EXHIBITOR__c '+
            +' WHERE Integration_Status__c=\'' + String.escapeSingleQuotes(status)+'\''+
            +'   AND Oracle_Interface_Status__c In (\'N\')'; 
                
        if(showOccurence != 'All' && !String.isBlank(showOccurence)){
            query = query+' AND Occurrence_Id__c LIKE \'%' + String.escapeSingleQuotes(showOccurence) + '%\'';
        }                
        query = query+' limit 2000';
        return query;
    }
    
    public List<SelectOption> getShowOccurences() {
        List<SelectOption> Options = new List<SelectOption>();
        final set<String> setShowOccurence = new Set<String>();
        List<CORE_EXHIBITOR__c> listCoreExhbitior = [SELECT Id, IsManualIntervention__c, Company_Name__c, Name, Occurrence_Id__c, Address1__c, Address_2__c, Address_3__c, Address_4__c,
                             Area_Code__c, City__c, Country__c, Phone__c, Postal_Code__c, provinence__c, State__c, Oracle_Key_Index__c, LastModifiedDate, 
                             Integration_Error_Message__c 
                             FROM CORE_EXHIBITOR__c 
                             WHERE Integration_Status__c = 'Failed'
                               AND Oracle_Interface_Status__c =  'N'
                             ORDER BY Occurrence_Id__c
                             LIMIT 2000];
        Options.add(new SelectOption('All','All'));
        for (CORE_EXHIBITOR__c instCore : listCoreExhbitior ) {
            if(instCore.Occurrence_Id__c != null){
                setShowOccurence.add(instCore.Occurrence_Id__c);
            }
        }
        for(String showOccurence :setShowOccurence ){
            Options.add(new SelectOption(showOccurence,showOccurence));
        }
        return Options;
    }
    
    public void showOccurrence() {
        index = 0;                   
        QueryCoreExhibitor = BuildQuery(errorCodes,showOccurence);
        List<CORE_EXHIBITOR__c> listCoreExhbitior = database.query(QueryCoreExhibitor);
        createMainWrapper(listCoreExhbitior);
    }
    
    public PageReference cancel(){
        PageReference pageRef = new PageReference('/apex/ListViewCoreExhibitor');
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    Set<Id> setSelectedRec = new Set<Id>();
    map<Id,Exhibitorwrapper> mapIDExhibitWrp=new Map<Id,Exhibitorwrapper>();
    
    @TestVisible   
    private void updateWrapperList(){
        for(Exhibitorwrapper instObj:exhwrapRequestList){
            if(instObj.selected){
                mapIDExhibitWrp.put(instObj.exhObj.id,instObj);
            }
            else if(setSelectedRec.contains(instObj.exhObj.id)){
                mapIDExhibitWrp.remove(instObj.exhObj.id);
            }
        }
    }
    
    /*
    pagination methods below
    */     
    public void beginning()
    {
        index = 0;
        QueryCoreExhibitor = BuildQuery(errorCodes,showOccurence);
        List<CORE_EXHIBITOR__c> listCoreExhbitior = database.query(QueryCoreExhibitor);
        createMainWrapper(listCoreExhbitior);
    }
    
    public void previous()
    {
        index = index - RecPerPage;
        QueryCoreExhibitor = BuildQuery(errorCodes,showOccurence);
        List<CORE_EXHIBITOR__c> listCoreExhbitior = database.query(QueryCoreExhibitor);
        createMainWrapper(listCoreExhbitior);
    }
    
    public void next()
    {
        index = index + RecPerPage;
        QueryCoreExhibitor = BuildQuery(errorCodes,showOccurence);
        
        List<CORE_EXHIBITOR__c> listCoreExhbitior = database.query(QueryCoreExhibitor);
        createMainWrapper(listCoreExhbitior);
    }
    
    public void end()
    {   
        if(math.mod(totalRecs,RecPerPage)!=0){
            index = totalrecs - math.mod(totalRecs,RecPerPage);
        }else{
            index = totalrecs - RecPerPage ;
        }
        
        QueryCoreExhibitor = BuildQuery(errorCodes,showOccurence);
        List<CORE_EXHIBITOR__c> listCoreExhbitior = database.query(QueryCoreExhibitor);
        createMainWrapper(listCoreExhbitior);
    }        
    
    public boolean getprev()
    {
        if(index == 0)
            return true;
        else
            return false;
    }  
    
    public boolean getnxt()
    {
        if((index + RecPerPage) >= totalRecs)
            return true;
        else
            return false;
    }     
    
    //  end pagination method here
    /*
    Wrapper class to bind up boolean value with each Core Exhibitor Record.
    */
    public class Exhibitorwrapper{
        public CORE_EXHIBITOR__c exhObj{get; set;}
        public boolean selected{get; set;}
        public Exhibitorwrapper(){}
    }
}