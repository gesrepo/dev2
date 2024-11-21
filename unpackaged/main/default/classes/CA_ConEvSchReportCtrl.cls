/* Created By : Birlasoft Ltd.-Vaishali
 * Created on : 14/05/2020
 * Description : This class is used in lightning component CA_ConEvSchReport.cmp. 
 *               To fetch information for consolidated Event Schedule Report. */

public without sharing class CA_ConEvSchReportCtrl {
    
    // get required settings to load the page
    @AuraEnabled(cacheable=true)
    public static CA_Personalized_Object_Setting__c fetchSettings(){
        return (CA_ExhibitScheduleReportCtrl.fetchSettings());
    }
    
    // set columns for page and csv
   @AuraEnabled (cacheable=true)
    public static List<CA_ExhibitScheduleReportCtrl.CA_ExSchRepColumns> fetchCols(string colSetStr){
        return CA_ExhibitScheduleReportCtrl.fetchCols(colSetStr);
    }
    
    //Get data to dispaly in report
    @AuraEnabled(cacheable=true)
    public static List<CA_ConEvSchRepWrapper> runReport(string recTypeId){

        List<CA_ConEvSchRepWrapper> repRecords= new List<CA_ConEvSchRepWrapper>();
        Map<string,List<CA_Exhibit__c>> eventToEhibitList= new Map<string,List<CA_Exhibit__c>>();
        Map<string,List<CA_Event__c>> eventToActEvList= new Map<string,List<CA_Event__c>>();
        Map<string,List<CA_Meeting_Planning__c>> eventToMPlanningList= new Map<string,List<CA_Meeting_Planning__c>>();
        Map<string,List<CA_Meeting_Room__c>> eventToMRoomList= new Map<string,List<CA_Meeting_Room__c>>();
        Map<string,List<CA_Membership__c>> eventToMembershipList= new Map<string,List<CA_Membership__c>>();
        Map<string,List<CA_Sporting_Event__c>> eventToSportingEvList= new Map<string,List<CA_Sporting_Event__c>>();
        Map<string,List<CA_Sponsorship__c>> eventToSponsorshipList= new Map<string,List<CA_Sponsorship__c>>();
        Map<string,List<CA_Speaking_Engagement__c>> eventToSpeakEngList= new Map<string,List<CA_Speaking_Engagement__c>>();
        Map<String,List<CA_Product__c>> eventToprodList = new Map<String,List<CA_Product__c>>();
        Set<CA_Main_Event__c> eventSet = new Set<CA_Main_Event__c>();
        string profileName='';
        
        User comUser = [select id,Name,profile.name,IsPortalEnabled FROM User Where id =: userInfo.getUserId()];
        if(System.Label.CA_ProfileOverride.contains(profileName)){
            profileName=System.Label.CA_ProfileImpersonation;
        }else if(System.Label.CA_SysAdminProfile.contains(profileName)){
            profileName=System.Label.CA_DevProfile;
        }else{
            profileName=comUser.profile.name;
        }
        
        string exFields='id,Event__c,Event_Manager__c,Activity_Level__c,GES_Project_Number__c, Exhibit_Name__c, GES_Project_Manager__c,  GES_Account_Manager__c, GES_Account_Executive__c,Booth_Length__c, Booth_Width__c, Booth_Number__c, Event__r.GES_Account_Manager__c,';
        
        string evtFields='id,Event__c,Event_Manager__c,Activity_Level__c,GES_Project_Number__c,Event_Name__c, GES_Project_Manager__c, GES_Account_Manager__c, GES_Account_Executive__c,Event__r.GES_Account_Manager__c,   Product__c,';
        
        string mpFields='id,Event__c,Event_Manager__c,GES_Project_Number__c, GES_Project_Manager__c,  GES_Account_Manager__c, GES_Account_Executive__c,Event__r.GES_Account_Manager__c,';
        
        string mrFields='id,Event__c,Event_Manager__c,Activity_Level__c,GES_Project_Number__c, GES_Project_Manager__c,  GES_Account_Manager__c, GES_Account_Executive__c,Event__r.GES_Account_Manager__c,Meeting_Room_Name__c,Product__c,';
        
        string msFields='id,Event__c,Membership_Name__c,GES_Account_Manager__c,GES_Account_Executive__c, CC_Project_Manager__c,Event__r.GES_Account_Manager__c,';
        
        string seFields='id,Event__c,Event_Manager__c,Activity_Level__c,GES_Project_Manager__c,GES_Account_Manager__c, GES_Account_Executive__c,Speaking_Engagement_Type__c,Event__r.GES_Account_Manager__c,';
        
        string spFields='id,Event__c,Event_Manager__c,Activity_Level__c, GES_Project_Manager__c,Product__c, GES_Account_Manager__c, GES_Account_Executive__c,Event__r.GES_Account_Manager__c,';
        
        string speFields='id,Event__c,Sporting_event_Name__c,GES_Account_Manager__c,GES_Account_Executive__c, Event__r.GES_Account_Manager__c,';
        
        for(sObject singleAct:fetchRecords('CA_Exhibit__c',exFields,false,recTypeId)){
            CA_Exhibit__c ex= (CA_Exhibit__c)singleAct; 
            if(!eventToEhibitList.containsKey(ex.Event__c)){
                eventToEhibitList.put(ex.Event__c, new List<CA_Exhibit__c>());
            }
            eventToEhibitList.get(ex.Event__c).add(ex);
            
            if(!eventToprodList.containsKey(ex.Event__c)){
                eventToprodList.put(ex.Event__c, new List<CA_Product__c>());
            }
            eventToprodList.get(ex.Event__c).addAll(ex.CA_Products__r);
            eventSet.add(ex.Event__r);
        }
        
        for(sObject singleAct:fetchRecords('CA_Event__c',evtFields,false,recTypeId)){
            CA_Event__c ex= (CA_Event__c)singleAct;
            if(!eventToActEvList.containsKey(ex.Event__c)){
                eventToActEvList.put(ex.Event__c, new List<CA_Event__c>());
            }
            eventToActEvList.get(ex.Event__c).add(ex);
            
            if(!eventToprodList.containsKey(ex.Event__c)){
                eventToprodList.put(ex.Event__c, new List<CA_Product__c>());
            }
            eventToprodList.get(ex.Event__c).addAll(ex.CA_Products__r);
            eventSet.add(ex.Event__r);
        }
        
        for(sObject singleAct:fetchRecords('CA_Meeting_Planning__c',mpFields,false,recTypeId)){
            CA_Meeting_Planning__c ex= (CA_Meeting_Planning__c)singleAct;
            if(!eventToMPlanningList.containsKey(ex.Event__c)){
                eventToMPlanningList.put(ex.Event__c, new List<CA_Meeting_Planning__c>());
            }
            eventToMPlanningList.get(ex.Event__c).add(ex);
            
            if(!eventToprodList.containsKey(ex.Event__c)){
                eventToprodList.put(ex.Event__c, new List<CA_Product__c>());
            }
            eventToprodList.get(ex.Event__c).addAll(ex.CA_Products__r);
            eventSet.add(ex.Event__r);
        }
        
        for(sObject singleAct:fetchRecords('CA_Meeting_Room__c',mrFields,false,recTypeId)){
            CA_Meeting_Room__c ex= (CA_Meeting_Room__c)singleAct;
            if(!eventToMRoomList.containsKey(ex.Event__c)){
                eventToMRoomList.put(ex.Event__c, new List<CA_Meeting_Room__c>());
            }
            eventToMRoomList.get(ex.Event__c).add(ex);
            
            if(!eventToprodList.containsKey(ex.Event__c)){
                eventToprodList.put(ex.Event__c, new List<CA_Product__c>());
            }
            eventToprodList.get(ex.Event__c).addAll(ex.CA_Products__r);
            eventSet.add(ex.Event__r);
        }
        for(sObject singleAct:fetchRecords('CA_Membership__c',msFields,false,recTypeId)){
            CA_Membership__c ex= (CA_Membership__c)singleAct;
            if(!eventToMembershipList.containsKey(ex.Event__c)){
                eventToMembershipList.put(ex.Event__c, new List<CA_Membership__c>());
            }
            eventToMembershipList.get(ex.Event__c).add(ex);
            
            if(!eventToprodList.containsKey(ex.Event__c)){
                eventToprodList.put(ex.Event__c, new List<CA_Product__c>());
            }
            eventToprodList.get(ex.Event__c).addAll(ex.CA_Products__r);
            eventSet.add(ex.Event__r);
        }
        for(sObject singleAct:fetchRecords('CA_Speaking_Engagement__c',seFields,false,recTypeId)){
            CA_Speaking_Engagement__c ex= (CA_Speaking_Engagement__c)singleAct;
            if(!eventToSpeakEngList.containsKey(ex.Event__c)){
                eventToSpeakEngList.put(ex.Event__c, new List<CA_Speaking_Engagement__c>());
            }
            eventToSpeakEngList.get(ex.Event__c).add(ex);
            
            if(!eventToprodList.containsKey(ex.Event__c)){
                eventToprodList.put(ex.Event__c, new List<CA_Product__c>());
            }
            eventToprodList.get(ex.Event__c).addAll(ex.CA_Products__r);
            eventSet.add(ex.Event__r);
        }
        for(sObject singleAct:fetchRecords('CA_Sponsorship__c',spFields,false,recTypeId)){
            CA_Sponsorship__c ex= (CA_Sponsorship__c)singleAct;
            if(!eventToSponsorshipList.containsKey(ex.Event__c)){
                eventToSponsorshipList.put(ex.Event__c, new List<CA_Sponsorship__c>());
            }
            eventToSponsorshipList.get(ex.Event__c).add(ex);
            
            if(!eventToprodList.containsKey(ex.Event__c)){
                eventToprodList.put(ex.Event__c, new List<CA_Product__c>());
            }
            eventToprodList.get(ex.Event__c).addAll(ex.CA_Products__r);
            eventSet.add(ex.Event__r);
        }
        for(sObject singleAct:fetchRecords('CA_Sporting_Event__c',speFields,false,recTypeId)){
            CA_Sporting_Event__c ex= (CA_Sporting_Event__c)singleAct;
            if(!eventToSportingEvList.containsKey(ex.Event__c)){
                eventToSportingEvList.put(ex.Event__c, new List<CA_Sporting_Event__c>());
            }
            eventToSportingEvList.get(ex.Event__c).add(ex);
            
            if(!eventToprodList.containsKey(ex.Event__c)){
                eventToprodList.put(ex.Event__c, new List<CA_Product__c>());
            }
            eventToprodList.get(ex.Event__c).addAll(ex.CA_Products__r);
            eventSet.add(ex.Event__r);
        }
        
        for(CA_Main_Event__c event : eventSet){
            List<CA_Product__c> prodList = new List<CA_Product__c>();
            String actTypeStr='';
            String eventManagerStr ='';
            String accManagerStr ='';
            
            if(eventToSportingEvList.containsKey(event.Id)){
                for(CA_Sporting_Event__c sEvent : eventToSportingEvList.get(event.Id)){
                    accManagerStr += (string.isNotBlank(sEvent.GES_Account_Manager__c)&&!eventManagerStr.contains(sEvent.GES_Account_Manager__c)) ? sEvent.GES_Account_Manager__c+', ':'';
                }
                actTypeStr += (actTypeStr.contains('Sporting Event'))?'':'Sporting Event, ';
                
            }
            if(eventToEhibitList.containsKey(event.Id)){
                for(CA_Exhibit__c sEvent : eventToEhibitList.get(event.Id)){
                    eventManagerStr += (string.isNotBlank(sEvent.Event_Manager__c)&&!eventManagerStr.contains(sEvent.Event_Manager__c)) ? sEvent.Event_Manager__c+', ':'';
                    accManagerStr += (string.isNotBlank(sEvent.GES_Account_Manager__c)&&!eventManagerStr.contains(sEvent.GES_Account_Manager__c)) ? sEvent.GES_Account_Manager__c+', ':'';
                }
                actTypeStr += (actTypeStr.contains('Exhibit'))?'':'Exhibit, ';
            }
            if(eventToActEvList.containsKey(event.Id)){
                for(CA_Event__c sEvent : eventToActEvList.get(event.Id)){
                    eventManagerStr += (string.isNotBlank(sEvent.Event_Manager__c)&&!eventManagerStr.contains(sEvent.Event_Manager__c)) ? sEvent.Event_Manager__c+', ':'';
                    accManagerStr += (string.isNotBlank(sEvent.GES_Account_Manager__c)&&!eventManagerStr.contains(sEvent.GES_Account_Manager__c)) ? sEvent.GES_Account_Manager__c+', ':'';
                }
                actTypeStr += (actTypeStr.contains('Event'))?'':'Event, ';
            }
            if(eventToMPlanningList.containsKey(event.Id)){
                for(CA_Meeting_Planning__c sEvent : eventToMPlanningList.get(event.Id)){
                    eventManagerStr += (string.isNotBlank(sEvent.Event_Manager__c)&&!eventManagerStr.contains(sEvent.Event_Manager__c)) ? sEvent.Event_Manager__c+', ':'';
                    accManagerStr += (string.isNotBlank(sEvent.GES_Account_Manager__c)&&!eventManagerStr.contains(sEvent.GES_Account_Manager__c)) ? sEvent.GES_Account_Manager__c+', ':'';
                }
                actTypeStr += (actTypeStr.contains('Meeting Planning'))?'':'Meeting Planning, ';
            }
            if(eventToMRoomList.containsKey(event.Id)){
                for(CA_Meeting_Room__c sEvent : eventToMRoomList.get(event.Id)){
                    eventManagerStr += (string.isNotBlank(sEvent.Event_Manager__c)&&!eventManagerStr.contains(sEvent.Event_Manager__c)) ? sEvent.Event_Manager__c+', ':'';
                    accManagerStr += (string.isNotBlank(sEvent.GES_Account_Manager__c)&&!eventManagerStr.contains(sEvent.GES_Account_Manager__c)) ? sEvent.GES_Account_Manager__c+', ':'';
                }
                actTypeStr += (actTypeStr.contains('Meeting Room'))?'':'Meeting Room, ';
            }
            if(eventToMembershipList.containsKey(event.Id)){
                for(CA_Membership__c sEvent : eventToMembershipList.get(event.Id)){
                    accManagerStr += (string.isNotBlank(sEvent.GES_Account_Manager__c)&&!eventManagerStr.contains(sEvent.GES_Account_Manager__c)) ? sEvent.GES_Account_Manager__c+', ':'';
                }
                actTypeStr += (actTypeStr.contains('Membership'))?'':'Membership, ';
            }
            if(eventToSponsorshipList.containsKey(event.Id)){
                for(CA_Sponsorship__c sEvent : eventToSponsorshipList.get(event.Id)){
                    eventManagerStr += (string.isNotBlank(sEvent.Event_Manager__c)&&!eventManagerStr.contains(sEvent.Event_Manager__c)) ? sEvent.Event_Manager__c+', ':'';
                    accManagerStr += (string.isNotBlank(sEvent.GES_Account_Manager__c)&&!eventManagerStr.contains(sEvent.GES_Account_Manager__c)) ? sEvent.GES_Account_Manager__c+', ':'';
                }
                actTypeStr += (actTypeStr.contains('Sponsorship'))?'':'Sponsorship, ';
            }
            if(eventToSpeakEngList.containsKey(event.Id)){
                for(CA_Speaking_Engagement__c sEvent : eventToSpeakEngList.get(event.Id)){
                    eventManagerStr += (string.isNotBlank(sEvent.Event_Manager__c)&&!eventManagerStr.contains(sEvent.Event_Manager__c)) ? sEvent.Event_Manager__c+', ':'';
                    accManagerStr += (string.isNotBlank(sEvent.GES_Account_Manager__c)&&!eventManagerStr.contains(sEvent.GES_Account_Manager__c)) ? sEvent.GES_Account_Manager__c+', ':'';
                }
                actTypeStr += (actTypeStr.contains('Speaking Engagement'))?'':'Speaking Engagement, ';
            }
            if(eventToprodList.containsKey(event.Id)){
                prodList.addAll(eventToprodList.get(event.Id));
            }
            
            //Craete records to be deisplayed in the report using wrapper class
            CA_ConEvSchRepWrapper row = new CA_ConEvSchRepWrapper(prodList,actTypeStr,event,eventManagerStr, accManagerStr);
            repRecords.add(row);
                
        }
        
        
        return repRecords;
    }
    
    
    // function to actually fetch all the records without worrying about the object name
    @AuraEnabled (cacheable=true)
    public static List<sObject> fetchRecords(string actApiName,string actFields,Boolean isCanc, string evtRecTyp) {
        // get product fields
        string prodFields='(select Product_Name__c,Product_Team_Contact__c,Business_Unit__c,Product_Category__c, Therapeutic_Area__c,Business_Unit_Pharma__c,Fiber_Business_Unit__c,Booth_Space_Costs_Actual__c,GES_Costs_Actual__c,Event_Costs_Actual__c,Meeting_Room_Costs_Actual__c,Meeting_Room_Services_Cost_Actual__c,Meeting_Planning_Costs_Actual__c,Sponsorship_Costs_Actual__c,Speaking_Engagement_Costs_Actual__c,Meeting_Room_Services_Costs_Estimated__c,Meeting_Planning_Costs_Estimated__c,Sponsorship_Costs_Estimated__c,Booth_Space_Costs_Estimated__c,GES_Costs_Estimated__c,Meeting_Room_Costs_Estimated__c,Event_Costs_Estimated__c,Speaking_Engagement_Costs_Estimated__c from CA_Products__r)';
        //get main event fields
        string eventFields='Event__r.Name,Event__r.Event_Level__c,Event__r.Name_of_Event__c,Event__r.Event_Cancelled__c,Event__r.Event_Acronym__c, Event__r.GES_Supported_Event__c,Event__r.No_of_HCP_s_in_Attendance__c, Event__r.Event_Start_Date__c, Event__r.Event_End_Date__c, Event__r.Shipping_City__c,Event__r.Shipping_State_Province__c, Event__r.Shipping_Country__c, Event__r.Name_of_the_Facility__c,Event__r.GES_Meeting_Planner__c, Event__r.Exhibit_Hours_Day_1__c,Event__r.Exhibit_Hours_Day_2__c,Event__r.Exhibit_Hours_Day_3__c, Event__r.Exhibit_Hours_Day_4__c ,Event__r.GES_Account_Executive__c,Event__r.Congress_Type__c, Event__r.Event_Website__c,Event__r.US_Ex_US__c,Event__r.Event_Notes__c,Event__r.Status__c,Event__r.Housing_Logistics_Vendor__c,';
        
        string whereClause='Event__r.RecordTypeId = :evtRecTyp';
        
        string query='SELECT '+actFields;
        query+=eventFields;
        query+=prodFields;
        query+=' FROM '+actApiName;
        query+=' WHERE '+whereClause;
        query+=' ORDER BY Event__r.Event_Start_Date__c ';
        query+=' LIMIT 10000';
        List<sObject> records=Database.query(query);
        return records;
    }
    
   
    //Wrapper used to display data in report
    public class CA_ConEvSchRepWrapper{

        @AuraEnabled public String activity {get; set;}      
        @AuraEnabled public String bsUnit {get; set;}
        @AuraEnabled public String loc {get; set;}
        @AuraEnabled public String products {get; set;}
        @AuraEnabled public String tpArea {get; set;}
        @AuraEnabled public String eventMgr {get; set;}
        @AuraEnabled public String eventName {get; set;}
        @AuraEnabled public String CongrStDate {get; set;}
        @AuraEnabled public String CongrEndDate {get; set;}
        @AuraEnabled public String evCancelled {get; set;}
        @AuraEnabled public String totEstCost {get; set;}
        @AuraEnabled public String totActCost {get; set;}
        @AuraEnabled public String eventStatus {get; set;}
        @AuraEnabled public String accMgr {get; set;}
        @AuraEnabled public String eventEndDate {get; set;}
        @AuraEnabled public String eventStDate {get; set;}
                 
        public CA_ConEvSchRepWrapper(List<CA_Product__c> prList, String actTypeStr, CA_Main_Event__c event, String eventManagerStr, String accountManagerStr){
            
            Decimal actCost = 0.00; 
            Decimal estCost = 0.00;
            this.products='';
            this.bsUnit='';
            this.tpArea='';
            this.eventMgr = eventManagerStr.removeEnd(', ');
            this.activity = actTypeStr.removeEnd(', ');
            this.accMgr = accountManagerStr.removeEnd(', ');
            
            // prepare product fields
            if(prList.size()>0){
                for(CA_Product__c sp:prList){
                    this.products+= (string.isNotBlank(sp.Product_Name__c)&&!this.products.contains(sp.Product_Name__c)) ? sp.Product_Name__c+', ':'';
                    this.bsUnit+= (string.isNotBlank(sp.Business_Unit__c)&&!this.bsUnit.contains(sp.Business_Unit__c)) ? sp.Business_Unit__c+', ':'';
                    this.tpArea+= (string.isNotBlank(sp.Therapeutic_Area__c)&&!this.tpArea.contains(sp.Therapeutic_Area__c)) ? sp.Therapeutic_Area__c+', ':'';
                    
                    //Total Actual and Estimated Cost Calculation
                    if(sp.Booth_Space_Costs_Actual__c != null && sp.Booth_Space_Costs_Estimated__c != null){
                        actCost += sp.Booth_Space_Costs_Actual__c;
                        estCost += sp.Booth_Space_Costs_Estimated__c;
                    }
                    if(sp.GES_Costs_Actual__c != null && sp.GES_Costs_Estimated__c != null){
                        actCost += sp.GES_Costs_Actual__c;
                        estCost += sp.GES_Costs_Estimated__c;
                    }
                    if(sp.Meeting_Room_Costs_Actual__c != null && sp.Meeting_Room_Costs_Estimated__c != null){
                        actCost += sp.Meeting_Room_Costs_Actual__c;
                        estCost += sp.Meeting_Room_Costs_Estimated__c;
                    }
                    if(sp.Event_Costs_Actual__c != null && sp.Event_Costs_Estimated__c != null){
                        actCost += sp.Event_Costs_Actual__c;
                        estCost += sp.Event_Costs_Estimated__c;
                    }
                    if(sp.Meeting_Room_Services_Cost_Actual__c != null && sp.Meeting_Room_Services_Costs_Estimated__c != null){
                        actCost += sp.Meeting_Room_Services_Cost_Actual__c;
                        estCost += sp.Meeting_Room_Services_Costs_Estimated__c;
                    }
                    if(sp.Meeting_Planning_Costs_Actual__c != null && sp.Meeting_Planning_Costs_Estimated__c != null){
                        actCost += sp.Meeting_Planning_Costs_Actual__c;
                        estCost += sp.Meeting_Planning_Costs_Estimated__c;
                    }
                    if(sp.Sponsorship_Costs_Actual__c != null && sp.Sponsorship_Costs_Estimated__c != null){
                        actCost += sp.Sponsorship_Costs_Actual__c;
                        estCost += sp.Sponsorship_Costs_Estimated__c;
                    }
                    if(sp.Speaking_Engagement_Costs_Actual__c != null && sp.Speaking_Engagement_Costs_Estimated__c != null){
                        actCost += sp.Speaking_Engagement_Costs_Actual__c;
                        estCost += sp.Speaking_Engagement_Costs_Estimated__c;
                    }
                }
                this.products=this.products.removeEnd(', ');
                this.bsUnit=this.bsUnit.removeEnd(', ');
                this.tpArea=this.tpArea.removeEnd(', ');
                if(actCost>0){
                	this.totActCost = '$'+String.valueOf(actCost);
                }
                else{
                    this.totActCost = '$'+String.valueOf(estCost);  
                }
                this.totEstCost = '$'+String.valueOf(estCost);
            }
            
            if(event.Name_of_Event__c!=null){
                    this.eventName= string.valueOf(event.Name_of_Event__c);                
            }else{
                this.eventName='';
            }
                
            if(event.Event_End_Date__c!=null){
                List<String> tmp = string.valueOf(event.Event_End_Date__c).split('-');
                this.CongrEndDate=tmp[1]+'/'+tmp[2].removeEnd(' 00:00:00')+'/'+tmp[0]; 
                this.eventEndDate= tmp[1]+'/'+tmp[2].removeEnd(' 00:00:00')+'/'+tmp[0]; 
            }
            
            if(event.Event_Start_Date__c!=null){
                List<String> tmp = string.valueOf(event.Event_Start_Date__c).split('-');
                this.CongrStDate=tmp[1]+'/'+tmp[2].removeEnd(' 00:00:00')+'/'+tmp[0]; 
                this.eventStDate= tmp[1]+'/'+tmp[2].removeEnd(' 00:00:00')+'/'+tmp[0]; 
            }
            
            String tempVal=(string) string.valueOf(event.Event_Cancelled__c);
            this.evCancelled=string.isNotBlank(tempVal)?tempVal.toUpperCase():'';
            
            tempVal=(string) event.Shipping_City__c;
            this.loc=string.isNotBlank(tempVal)?tempVal:'';   
            
            tempVal=(string) event.Shipping_State_Province__c;
            this.loc+=string.isNotBlank(tempVal)?', '+tempVal:'';  
            
            tempVal=(string) event.Status__c;
            this.eventStatus=string.isNotBlank(tempVal)?tempVal:'';
            
        }
    }
}