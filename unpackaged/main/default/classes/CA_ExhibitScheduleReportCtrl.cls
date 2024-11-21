public without sharing class CA_ExhibitScheduleReportCtrl{
    
    // method to run the report at page load
    @AuraEnabled(cacheable=true)
    public static List<CA_ExSchRepWrapper> runReport(string recTypeId){
        //recTypeId='0121W000000IjDdQAK';
        system.debug('Inside ru Report apex class method');
        Map<string,List<CA_ExSchRepWrapper>> mapAct2Event= new Map<string,List<CA_ExSchRepWrapper>>();
        string profileName='';
        Map<string,string>objLblMap= new Map<string,string>();
        User comUser = [select id,Name,profile.name,IsPortalEnabled FROM User Where id =: userInfo.getUserId()];
        if(System.Label.CA_ProfileOverride.contains(profileName)){
            profileName=System.Label.CA_ProfileImpersonation;
        }else if(System.Label.CA_SysAdminProfile.contains(profileName)){
            profileName=System.Label.CA_DevProfile;
        }else{
            profileName=comUser.profile.name;
        }
        for(CA_Personalized_Object_Setting__c objSet:[SELECT id,name,Object_Name__c,Object_Label__c FROM CA_Personalized_Object_Setting__c WHERE Profile_Name__c=:profileName]){
            objLblMap.put(objSet.Object_Name__c,objSet.Object_Label__c);
        }
        List<CA_ExSchRepWrapper> repRecords= new List<CA_ExSchRepWrapper>();
        
        string exFields='id,Event__c,Event_Manager__c,Activity_Level__c,GES_Project_Number__c, Exhibit_Name__c, GES_Project_Manager__c,  GES_Account_Manager__c, GES_Account_Executive__c,Booth_Length__c, Booth_Width__c, Booth_Number__c, Event__r.GES_Account_Manager__c,';
        
        string evtFields='id,Event__c,Event_Manager__c,Activity_Level__c,GES_Project_Number__c,Event_Name__c, GES_Project_Manager__c, GES_Account_Manager__c, GES_Account_Executive__c,Event__r.GES_Account_Manager__c,   Product__c,';
        
        string mpFields='id,Event__c,Event_Manager__c,GES_Project_Number__c, GES_Project_Manager__c,  GES_Account_Manager__c, GES_Account_Executive__c,Event__r.GES_Account_Manager__c,';
        
        string mrFields='id,Event__c,Event_Manager__c,Activity_Level__c,GES_Project_Number__c, GES_Project_Manager__c,  GES_Account_Manager__c, GES_Account_Executive__c,Event__r.GES_Account_Manager__c,Meeting_Room_Name__c,Product__c,';
        
        string msFields='id,Event__c,Membership_Name__c,GES_Account_Manager__c,GES_Account_Executive__c, CC_Project_Manager__c,Event__r.GES_Account_Manager__c,';
        
        string seFields='id,Event__c,Event_Manager__c,Activity_Level__c,GES_Project_Manager__c,GES_Account_Manager__c, GES_Account_Executive__c,Speaking_Engagement_Type__c,Event__r.GES_Account_Manager__c,';
        
        string spFields='id,Event__c,Event_Manager__c,Activity_Level__c, GES_Project_Manager__c,Product__c, GES_Account_Manager__c, GES_Account_Executive__c,Event__r.GES_Account_Manager__c,';
        
        string speFields='id,Event__c,Sporting_event_Name__c,GES_Account_Manager__c,GES_Account_Executive__c, Event__r.GES_Account_Manager__c,';
        
        List<sObject> actRecords=fetchRecords('CA_Exhibit__c',exFields,false,recTypeId);
        for(sObject singleAct:actRecords){
            CA_Exhibit__c ex= (CA_Exhibit__c)singleAct;         
            CA_ExSchRepWrapper row= new CA_ExSchRepWrapper(singleAct,ex.CA_Products__r,objLblMap.get('CA_Exhibit__c'));
            if(!mapAct2Event.containsKey(ex.Event__c)){
                mapAct2Event.put(ex.Event__c, new List<CA_ExSchRepWrapper>());
            }
            mapAct2Event.get(ex.Event__c).add(row);
        }
        for(sObject singleAct:fetchRecords('CA_Event__c',evtFields,false,recTypeId)){
            CA_Event__c ex= (CA_Event__c)singleAct;
            CA_ExSchRepWrapper row= new CA_ExSchRepWrapper(singleAct,ex.CA_Products__r,objLblMap.get('CA_Event__c'));
            if(!mapAct2Event.containsKey(ex.Event__c)){
                mapAct2Event.put(ex.Event__c, new List<CA_ExSchRepWrapper>());
            }
            mapAct2Event.get(ex.Event__c).add(row);
        }
        for(sObject singleAct:fetchRecords('CA_Meeting_Planning__c',mpFields,false,recTypeId)){
            CA_Meeting_Planning__c ex= (CA_Meeting_Planning__c)singleAct;
            CA_ExSchRepWrapper row= new CA_ExSchRepWrapper(singleAct,ex.CA_Products__r,objLblMap.get('CA_Meeting_Planning__c'));
            if(!mapAct2Event.containsKey(ex.Event__c)){
                mapAct2Event.put(ex.Event__c, new List<CA_ExSchRepWrapper>());
            }
            mapAct2Event.get(ex.Event__c).add(row);
        }
        for(sObject singleAct:fetchRecords('CA_Meeting_Room__c',mrFields,false,recTypeId)){
            CA_Meeting_Room__c ex= (CA_Meeting_Room__c)singleAct;
            CA_ExSchRepWrapper row= new CA_ExSchRepWrapper(singleAct,ex.CA_Products__r,objLblMap.get('CA_Meeting_Room__c'));
            if(!mapAct2Event.containsKey(ex.Event__c)){
                mapAct2Event.put(ex.Event__c, new List<CA_ExSchRepWrapper>());
            }
            mapAct2Event.get(ex.Event__c).add(row);
        }
        for(sObject singleAct:fetchRecords('CA_Membership__c',msFields,false,recTypeId)){
            CA_Membership__c ex= (CA_Membership__c)singleAct;
            CA_ExSchRepWrapper row= new CA_ExSchRepWrapper(singleAct,ex.CA_Products__r,objLblMap.get('CA_Membership__c'));
            if(!mapAct2Event.containsKey(ex.Event__c)){
                mapAct2Event.put(ex.Event__c, new List<CA_ExSchRepWrapper>());
            }
            mapAct2Event.get(ex.Event__c).add(row);
        }
        for(sObject singleAct:fetchRecords('CA_Speaking_Engagement__c',seFields,false,recTypeId)){
            CA_Speaking_Engagement__c ex= (CA_Speaking_Engagement__c)singleAct;
            CA_ExSchRepWrapper row= new CA_ExSchRepWrapper(singleAct,ex.CA_Products__r,objLblMap.get('CA_Speaking_Engagement__c'));
            if(!mapAct2Event.containsKey(ex.Event__c)){
                mapAct2Event.put(ex.Event__c, new List<CA_ExSchRepWrapper>());
            }
            mapAct2Event.get(ex.Event__c).add(row);
        }
        for(sObject singleAct:fetchRecords('CA_Sponsorship__c',spFields,false,recTypeId)){
            CA_Sponsorship__c ex= (CA_Sponsorship__c)singleAct;
            CA_ExSchRepWrapper row= new CA_ExSchRepWrapper(singleAct,ex.CA_Products__r,objLblMap.get('CA_Sponsorship__c'));
            if(!mapAct2Event.containsKey(ex.Event__c)){
                mapAct2Event.put(ex.Event__c, new List<CA_ExSchRepWrapper>());
            }
            mapAct2Event.get(ex.Event__c).add(row);
        }
        for(sObject singleAct:fetchRecords('CA_Sporting_Event__c',speFields,false,recTypeId)){
            CA_Sporting_Event__c ex= (CA_Sporting_Event__c)singleAct;
            CA_ExSchRepWrapper row= new CA_ExSchRepWrapper(singleAct,ex.CA_Products__r,objLblMap.get('CA_Sporting_Event__c'));
            if(!mapAct2Event.containsKey(ex.Event__c)){
                mapAct2Event.put(ex.Event__c, new List<CA_ExSchRepWrapper>());
            }
            mapAct2Event.get(ex.Event__c).add(row);
        }
        
        // group rows by main event id so that all activities of an event will show accordingly
        for(string key:mapAct2Event.keySet()){
            //system.debug('key==='+key);
            repRecords.addAll(mapAct2Event.get(key));
            //system.debug('list size==='+mapAct2Event.get(key).size());
        }
        
        return repRecords;
    }
    
    // get required settings to load the page
    @AuraEnabled(cacheable=true)
    public static CA_Personalized_Object_Setting__c fetchSettings(){
        User comUser = [select id,Name,profile.name,IsPortalEnabled FROM User Where id =: userInfo.getUserId()];
        String profileName=comUser.profile.name;
        If (Test.isRunningTest()){profileName='GC BMS Profile';}
        return (CA_ApexUtils.getHomeTableSettings(profileName,'CA_Main_Event__c',false));
    }
    
    // set columns for page and csv
    @AuraEnabled (cacheable=true)
    public static List<CA_ExSchRepColumns> fetchCols(string colSetStr){
        List<CA_ExSchRepColumns> colList= new List<CA_ExSchRepColumns>();
        
        if(string.isNotBlank(colSetStr)){
            CA_ExSchRepColWrap colSet=(CA_ExSchRepColWrap)JSON.deserialize(colSetStr, CA_ExSchRepColWrap.class);
            for(string k:colSet.colMap.keySet()){
                CA_ExSchRepColumns col= new CA_ExSchRepColumns();
                col.label=colSet.colMap.get(k);
                col.fieldName=k;
                colList.add(col);
            }
        }
        return colList;
    }
    
    
    // function to actually fetch all the records without worrying about the object name
    @AuraEnabled (cacheable=true)
    public static List<sObject> fetchRecords(string actApiName,string actFields,Boolean isCanc, string evtRecTyp) {
        // get product fields
        string prodFields='(select Product_Name__c,Product_Team_Contact__c,Business_Unit__c,Product_Category__c, Therapeutic_Area__c,Business_Unit_Pharma__c,Fiber_Business_Unit__c from CA_Products__r where Cancelled__c =: isCanc)';
        //get main event fields
        string eventFields='Event__r.Name,Event__r.Event_Level__c,Event__r.Name_of_Event__c,Event__r.Event_Acronym__c, Event__r.GES_Supported_Event__c,Event__r.No_of_HCP_s_in_Attendance__c, Event__r.Event_Start_Date__c, Event__r.Event_End_Date__c, Event__r.Shipping_City__c,Event__r.Shipping_State_Province__c, Event__r.Shipping_Country__c, Event__r.Name_of_the_Facility__c,Event__r.GES_Meeting_Planner__c, Event__r.Exhibit_Hours_Day_1__c,Event__r.Exhibit_Hours_Day_2__c,Event__r.Exhibit_Hours_Day_3__c, Event__r.Exhibit_Hours_Day_4__c ,Event__r.GES_Account_Executive__c,Event__r.Congress_Type__c, Event__r.Event_Website__c,Event__r.US_Ex_US__c,Event__r.Event_Notes__c,Event__r.Status__c,Event__r.Housing_Logistics_Vendor__c,';
        
        string whereClause='Cancelled__c =: isCanc AND Event__r.RecordTypeId = :evtRecTyp';
        
        
        string query='SELECT '+actFields;
        query+=eventFields;
        query+=prodFields;
        query+=' FROM '+actApiName;
        query+=' WHERE '+whereClause;
        query+=' ORDER BY Event__r.Event_Start_Date__c ';
        query+=' LIMIT 10000';
        //system.debug('query==='+query);
        List<sObject> records=Database.query(query);
        return records;
    }
    
    // wrapper classes required to run the report 
    public class CA_ExSchRepFilters{
        @AuraEnabled public Date stDate {get; set;}
        @AuraEnabled public Date endDate {get; set;}
        @AuraEnabled public string recTypeId {get; set;}
        @AuraEnabled public string buName {get; set;}
        @AuraEnabled public string prodName {get; set;}
        @AuraEnabled public string contName {get; set;}
        @AuraEnabled public string buCategory {get; set;}
        @AuraEnabled public string tpArea {get; set;}
        
        public CA_ExSchRepFilters(){
            
        }
    }
    
    public class CA_ExSchRepWrapper{

        @AuraEnabled public String id {get; set;}
        @AuraEnabled public String accExec {get; set;}
        @AuraEnabled public String accMgr {get; set;}    
        @AuraEnabled public String actLevel {get; set;} 
        @AuraEnabled public String actType {get; set;}      
        @AuraEnabled public String bsUnit {get; set;}
        @AuraEnabled public String bTeamCon {get; set;}
        @AuraEnabled public String btType {get; set;}
        @AuraEnabled public String btLen {get; set;}
        @AuraEnabled public String btNum {get; set;}
        @AuraEnabled public String btWid {get; set;}
        @AuraEnabled public String buCat {get; set;}
        @AuraEnabled public String city {get; set;}
        @AuraEnabled public String country {get; set;}
        @AuraEnabled public String eventAcronym {get; set;}
        @AuraEnabled public String eventEndDate {get; set;}
        @AuraEnabled public String eventLead {get; set;}
        @AuraEnabled public String eventLevel {get; set;}
        @AuraEnabled public String eventMgr {get; set;}
        @AuraEnabled public String eventName {get; set;}
        @AuraEnabled public String eventNotes {get;set;}
        @AuraEnabled public String eventStatus {get; set;}
        @AuraEnabled public String eventStDate {get; set;}
        @AuraEnabled public String eventType {get; set;}
        @AuraEnabled public String eventWeb {get; set;}
        @AuraEnabled public String exHrs {get; set;}
        @AuraEnabled public String facility {get;set;}
        @AuraEnabled public String gesSupportString {get; set;}
        @AuraEnabled public String hlVendor {get; set;}
        @AuraEnabled public String idSuper {get; set;} 
        @AuraEnabled public String loc {get; set;}
        @AuraEnabled public String mPlanner {get; set;} 
        @AuraEnabled public String numOfHcp {get; set;}
        @AuraEnabled public String onSiStaff {get;set;} //need to be done
        @AuraEnabled public String products {get; set;}
        @AuraEnabled public String projMgr {get; set;} 
        @AuraEnabled public String projNum {get; set;}
        @AuraEnabled public String state{get;set;}
        @AuraEnabled public String tpArea {get; set;}
        @AuraEnabled public String usEx {get; set;}
        @AuraEnabled public String CongrStDate {get; set;}
        @AuraEnabled public String CongrEndDate {get; set;}
        
        public CA_ExSchRepWrapper(sObject act, List<CA_Product__c>prList, string actType){
            
            system.debug('## inside wrapper class');
            // prepare product fields for each activity
            this.products='';
            this.buCat='';
            this.bsUnit='';
            this.tpArea='';
            this.bTeamCon='';
            if(prList.size()>0){
                for(CA_Product__c sp:prList){
                    this.products+= (string.isNotBlank(sp.Product_Name__c)&&!this.products.contains(sp.Product_Name__c)) ? sp.Product_Name__c+', ':'';
                    this.buCat+= (string.isNotBlank(sp.Product_Category__c)&&!this.buCat.contains(sp.Product_Category__c)) ? sp.Product_Category__c+', ':'';
                    this.bsUnit+= (string.isNotBlank(sp.Business_Unit__c)&&!this.bsUnit.contains(sp.Business_Unit__c)) ? sp.Business_Unit__c+', ':'';
                    this.tpArea+= (string.isNotBlank(sp.Therapeutic_Area__c)&&!this.tpArea.contains(sp.Therapeutic_Area__c)) ? sp.Therapeutic_Area__c+', ':'';
                    this.bTeamCon+= (string.isNotBlank(sp.Product_Team_Contact__c)&&!this.tpArea.contains(sp.Product_Team_Contact__c)) ? sp.Product_Team_Contact__c+', ':'';
                }
                this.products=this.products.removeEnd(', ');
                this.buCat=this.buCat.removeEnd(', ');
                this.bsUnit=this.bsUnit.removeEnd(', ');
                this.tpArea=this.tpArea.removeEnd(', ');
                this.bTeamCon=this.bTeamCon.removeEnd(', ');
            }
            
            //prepare main event fields         
            
            if(act.getSobject('Event__r').get('Name_of_Event__c')!=null){
                this.eventName= string.valueOf(act.getSobject('Event__r').get('Name_of_Event__c'));                
            }else{
                this.eventName='';
            }
            
            if(act.getSobject('Event__r').get('Event_End_Date__c')!=null){
                List<String> tmp = string.valueOf(act.getSobject('Event__r').get('Event_End_Date__c')).split('-');
                this.eventEndDate= tmp[1]+'/'+tmp[2].removeEnd(' 00:00:00')+'/'+tmp[0];  
                this.CongrEndDate=tmp[1]+'/'+tmp[2].removeEnd(' 00:00:00')+'/'+tmp[0];  
            }else{
                this.eventEndDate='';
            }
            
            if(act.getSobject('Event__r').get('Event_Start_Date__c')!=null){
                List<String> tmp = string.valueOf(act.getSobject('Event__r').get('Event_Start_Date__c')).split('-');
                this.eventStDate= tmp[1]+'/'+tmp[2].removeEnd(' 00:00:00')+'/'+tmp[0]; 
                this.CongrStDate=tmp[1]+'/'+tmp[2].removeEnd(' 00:00:00')+'/'+tmp[0]; 
                
            }else{
                this.eventStDate='';
            }
            
            //*****Exhibit Hrs
            string tempVal=(string) act.getSobject('Event__r').get('Exhibit_Hours_Day_1__c');
            string exHrsConsolidate=(string) act.getSobject('Event__r').get('Exhibit_Hours_Day_1__c');
            if(string.isNotBlank(tempVal)){ 
                this.exHrs='Exhibit Hours Day 1 : '+tempVal; 
                exHrsConsolidate='Exhibit Hours Day 1 : '+tempVal; 
            }else{
                this.exHrs='';
            }
            tempVal=(string) act.getSobject('Event__r').get('Exhibit_Hours_Day_2__c');
            if(string.isNotBlank(tempVal)){         
                this.exHrs=', Exhibit Hours Day 2 : '+tempVal;
                exHrsConsolidate=exHrsConsolidate + ', Exhibit Hours Day 2 : '+tempVal;
            }
            tempVal=(string) act.getSobject('Event__r').get('Exhibit_Hours_Day_3__c');
            if(string.isNotBlank(tempVal)){         
                this.exHrs=', Exhibit Hours Day 3 : '+tempVal; 
                exHrsConsolidate=exHrsConsolidate +', Exhibit Hours Day 3 : '+tempVal;
            }
            tempVal=(string) act.getSobject('Event__r').get('Exhibit_Hours_Day_4__c');
            if(string.isNotBlank(tempVal)){         
                this.exHrs=', Exhibit Hours Day 4 : '+tempVal;
                exHrsConsolidate=exHrsConsolidate +', Exhibit Hours Day 4 : '+tempVal;
            }
            this.exHrs=string.isNotBlank(exHrsConsolidate)?exHrsConsolidate:''; //string.isNotBlank(tempVal)?tempVal:'';
            //*****Exhibit Hrs
            
            tempVal=(string) act.getSobject('Event__r').get('Event_Acronym__c');
            
            this.eventAcronym=string.isNotBlank(tempVal)?tempVal:'';                
            
            tempVal=(string) act.getSobject('Event__r').get('Event_Level__c');
            this.eventLevel=string.isNotBlank(tempVal)?tempVal:'';
            
            tempVal=(string) act.getSobject('Event__r').get('Congress_Type__c');
            this.eventType=string.isNotBlank(tempVal)?tempVal:'';
            
            tempVal=string.valueOf(act.getSobject('Event__r').get('No_of_HCP_s_in_Attendance__c'));
            this.numOfHcp=string.isNotBlank(tempVal)?tempVal:'';
            
            tempVal=(string) act.getSobject('Event__r').get('Event_Website__c');
            this.eventWeb=string.isNotBlank(tempVal)?tempVal:'';
            
            tempVal=(string) string.valueOf(act.getSobject('Event__r').get('GES_Supported_Event__c'));
            this.gesSupportString=string.isNotBlank(tempVal)?tempVal:'';
            
            tempVal=(string) act.getSobject('Event__r').get('Name_of_the_Facility__c');
            this.facility=string.isNotBlank(tempVal)?tempVal:'';
            
            this.loc='';
            
            tempVal=(string) act.getSobject('Event__r').get('Shipping_City__c');
            this.city=string.isNotBlank(tempVal)?tempVal:'';
            this.loc=string.isNotBlank(tempVal)?tempVal:'';
            
            tempVal=(string) act.getSobject('Event__r').get('Shipping_State_Province__c');
            this.state=string.isNotBlank(tempVal)?tempVal:'';
            this.loc+=string.isNotBlank(tempVal)?(', '+tempVal):'';
            
            tempVal=(string) act.getSobject('Event__r').get('Shipping_Country__c');
            this.country=string.isNotBlank(tempVal)?tempVal:'';
            //system.debug('this.country==='+this.country);
            //system.debug('tempVal==='+tempVal); 
            
            if(!String.isBlank(tempVal)){
                if(tempVal!= 'United States' && tempVal != 'US' && tempVal != 'USA'){
                    this.loc+= ', '+tempVal;
                }
            }
            
            tempVal=(string) act.getSobject('Event__r').get('US_Ex_US__c');
            this.usEx=string.isNotBlank(tempVal)?tempVal:'';
            
            tempVal=(string) act.getSobject('Event__r').get('Event_Notes__c');
            this.eventNotes=string.isNotBlank(tempVal)?tempVal:'';
            
            tempVal=(string) act.getSobject('Event__r').get('Status__c');
            this.eventStatus=string.isNotBlank(tempVal)?tempVal:'';
            
            tempVal=(string) act.getSobject('Event__r').get('Housing_Logistics_Vendor__c');
            this.hlVendor=string.isNotBlank(tempVal)?tempVal:'';

            /* **** set activity fields ***** */
            this.eventLead='';
            try{
                tempVal=(string) act.get('Congress_Lead__c');
                this.eventLead=string.isNotBlank(tempVal)?tempVal:'';
            }catch(exception e){}
            try{
                tempVal=(string) act.get('Event_Lead__c');
                this.eventLead=string.isNotBlank(tempVal)?tempVal:'';
            }catch(exception e){}
            
            try{
                this.actLevel=string.isNotBlank((string) act.get('Activity_Level__c'))?(string) act.get('Activity_Level__c'):'';
            }catch(exception e){
                this.actLevel='';
            }
            
            try{
                this.accMgr=string.isNotBlank((string) act.get('GES_Account_Manager__c'))?(string) act.get('GES_Account_Manager__c'):'';
            }catch(exception e){
                this.accMgr='';
            }
            
            try{
                this.accExec=string.isNotBlank((string) act.get('GES_Account_Executive__c'))?(string) act.get('GES_Account_Executive__c'):'';
            }catch(exception e){
                this.accExec='';
            }
            
            try{
                this.eventMgr=string.isNotBlank((string) act.get('Event_Manager__c'))?(string) act.get('Event_Manager__c'):'';
            }catch(exception e){
                this.eventMgr='';
            }
            try{
                this.btType=string.isNotBlank(string.valueOf(act.get('Exhibit_Space_Type__c')))?string.valueOf(act.get('Exhibit_Space_Type__c')):'';
            }catch(exception e){
                this.btType='';
            }
            try{
                this.btLen=string.isNotBlank(string.valueOf(act.get('Booth_Length__c')))?string.valueOf(act.get('Booth_Length__c')):'';
            }catch(exception e){
                this.btLen='';
            }
            try{
                this.projNum=string.isNotBlank(string.valueOf(act.get('GES_Project_Number__c')))?string.valueOf(act.get('GES_Project_Number__c')):'';
            }catch(exception e){
                this.projNum='';
            }
            try{
                this.btWid=string.isNotBlank(string.valueOf(act.get('Booth_Width__c')))?string.valueOf(act.get('Booth_Width__c')):'';
            }catch(exception e){
                this.btWid='';
            }
            try{
                this.btNum=string.isNotBlank((string) act.get('Booth_Number__c'))?(string) act.get('Booth_Number__c'):'';
            }catch(exception e){
                this.btNum='';
            }
            
            try{
                this.idSuper=string.isNotBlank((string) act.get('I_D_Supervisor__c'))?(string) act.get('I_D_Supervisor__c'):(string.isNotBlank((string) act.get('I_D_Name_Other__c'))?(string) act.get('I_D_Name_Other__c'):'');
            }catch(exception e){
                this.idSuper='';
            }
            try{
                this.mPlanner=string.isNotBlank((string) act.get('GES_Meeting_Planner__c'))?(string) act.get('GES_Meeting_Planner__c'):'';
            }catch(exception e){
                this.mPlanner='';
            }
            try{
                this.projMgr=string.isNotBlank((string) act.get('GES_Project_Manager__c'))?(string) act.get('GES_Project_Manager__c'):'';
            }catch(exception e){
                this.projMgr='';
            }           
            
            
            this.actType=actType;
            this.id=(string) act.get('id');
            
        }

    }
    
    public class CA_ExSchRepColWrap{
        @AuraEnabled public Map<string,string> colMap{get;set;}
        public CA_ExSchRepColWrap(){
            this.colMap=new Map<string,string>();
        }
    }
    
    public class CA_ExSchRepColumns{
        @AuraEnabled public string label {get; set;}
        @AuraEnabled public string fieldName {get; set;}
        @AuraEnabled public string type {get; set;}
        @AuraEnabled public string sortable {get; set;}
        
        public CA_ExSchRepColumns(){
            this.type='text';
            this.sortable='true';
        }
    }

}