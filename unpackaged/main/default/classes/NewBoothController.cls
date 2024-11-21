public class NewBoothController {
    public Booth_Area__c bo {get;set;}
    public string showName {get;set;}
    public string facilityId {get;set;}
    public string id{get;set;}
    public string Newbooth{get;set;}
    public boolean flag {get;set;}
    public List<SelectOption> options {get;set;}
    public List<SelectOption> zoneOptions {get;set;}
    public boolean isdirectLoad {get;set;}
    public string  showId{get;set;}
    public boolean NewIdentify{get;set;}
    public string  sessionId{get;set;}
    public boolean newBoothId{get;set;}
    public string newId{get;set;}
    public string boothId{get;set;}
    public String varFacilityId{get;set;}
    public NewBoothController (ApexPages.StandardController controller) {
        boothId=ApexPages.currentPage().getParameters().get('BoothId');
        newId=ApexPages.currentPage().getParameters().get('Id');
        sessionId=TestBoothAreaSubmission.SessionLogin();
        newBoothId=true;
        options=new List<SelectOption>();
        zoneOptions=new List<SelectOption>();
        bo =new Booth_Area__c();
        GC_Connect2_Show__c varShow=[select id,Facility_ID__c,Job_Number__c from GC_Connect2_Show__c where Id=:newId Limit 1];
        varFacilityId=varShow.Facility_ID__c;
        if(newId!=null && boothId==null){
            system.debug(showName );
            
            system.debug('>>>>>>>>>>>>>'+varShow.Id);
            
            /* Display Sequence  */
            //system.debug('sessionId>>>>>>>>>>>>>'+sessionId);
            //system.debug('varShow.Job_Number__c>>>>>>>>>>>>>'+varShow.Job_Number__c);
            
            decimal x= TestBoothAreaSubmission.GetDispalySequence(sessionId,varShow.Job_Number__c);
            decimal y=x+10;
            //displaying all Zones as a picklist
            set <String> opZones=TestBoothAreaSubmission.getOperationZones();
            system.debug('opZones==='+opZones);
            for(String str:opZones){
                zoneOptions.add(new SelectOption(String.valueOf(str),String.valueOf(str)));
                
            }
            /*ShowOccurCustomerId */
            //set <Integer> ShowccurSet=TestBoothAreaSubmission.showOccurCustomerDispaly(sessionId,varShow.Job_Number__c);
            set<String> ShowOrganizersList = TestBoothAreaSubmission.getCustomerDetails();
            
            //system.debug('ShowOrganizersList==='+ShowOrganizersList);
            
            for(String s:ShowOrganizersList){
                options.add(new SelectOption(String.valueOf(s.substringAfterLast('-')),String.valueOf(s)));
                system.debug('s.substringAfterLast===='+s.substringAfterLast('-'));
            }
            bo.Display_Sequence__c=string.ValueOF(y);
            bo.Connect2_Show__c=varShow.Id;
            bo.FacilityId__c=String.valueOf(TestBoothAreaSubmission.getFacilityId());
            bo.Job_Number__c=varShow.Job_Number__c;
            
            showId=varShow.Id;
            flag=true;
            isdirectLoad=false;
            system.debug('bo used at new creation===='+bo);
            
        }
        else if(boothId!=null && newId!=null) {
            
            isdirectLoad=true;
            flag=false;
            Booth_Area__c cs=[select id,Name,BoothID_Area__c,Job_Number__c,Completion_Date_time__c, Deleteable__c,Editable__c,Operations__c ,ShowOccrCustomerId__c,Removal_Date_time__c,ShowToCustomer__c,Zone_Id__c,FacilityId__c,Delivery_Date_time__c,Delivery_Location__c,Display_Sequence__c,Connect2_Show__c,Connect2_Show__r.Facility_ID__c,Connect2_Show__r.Job_Number__c,GroupOrdersByCategory__c,GroupOrdersByParent__c from Booth_Area__c where id=:boothId Limit 1];
            system.debug('cs-------' + cs);
            showId=cs.Connect2_Show__c;
            bo.Name=cs.Name;
            bo.BoothID_Area__c=cs.BoothID_Area__c;
            bo.Connect2_Show__c=cs.Connect2_Show__c;
            bo.Job_Number__c=cs.Connect2_Show__r.Job_Number__c;
            bo.Completion_Date_time__c=cs.Completion_Date_time__c;
            bo.Removal_Date_time__c=cs.Removal_Date_time__c;
            bo.ShowToCustomer__c=cs.ShowToCustomer__c;
            bo.Zone_Id__c=cs.Zone_Id__c;
            bo.ShowOccrCustomerId__c=cs.ShowOccrCustomerId__c;
            bo.FacilityId__c=cs.FacilityId__c;
            bo.Delivery_Date_time__c=cs.Delivery_Date_time__c;
            bo.Delivery_Location__c=cs.Delivery_Location__c;
            bo.Display_Sequence__c =cs.Display_Sequence__c ;
            bo.Operations__c=cs.Operations__c;
            bo.Deleteable__c=cs.Deleteable__c; 
            bo.Editable__c=cs.Editable__c;
            bo.GroupOrdersByCategory__c = cs.GroupOrdersByCategory__c;
            bo.GroupOrdersByParent__c = cs.GroupOrdersByParent__c;
            system.debug('bo===='+bo);
            
        }
    }
    
    public pagereference  oracleSubmission(){
        if(bo!=null){
            string sessionId=TestBoothAreaSubmission.SessionLogin();
               system.debug('booth area on submission-------' + bo);
            TestBoothAreaSubmission.submitBoothArea(sessionId,bo);
        }
        RefreshBoothArea.refreshMethod(newId);
        Pagereference pr=new Pagereference('/'+showId);
        pr.setredirect(true);
        return pr;
    }
    public Pagereference oracleUpdate(){
        if(bo!=null){
            sessionId=TestBoothAreaSubmission.SessionLogin();
            TestBoothAreaSubmission.updataBooth(sessionId, bo);
        }
        RefreshBoothArea.refreshMethod(newId);
        Pagereference pr=new Pagereference('/'+newId);
        pr.setredirect(true);
        return pr;
    }
    public Pagereference  oracleDelete(){
        string newid=showId;
        if(bo!=null){
            string sessionId=TestBoothAreaSubmission.SessionLogin();
            TestBoothAreaSubmission.DeleteBoothArea(sessionId,bo);
        }
        RefreshBoothArea.refreshMethod(newId);
        Pagereference pr=new Pagereference('/'+newId);
        pr.setredirect(true);
        return pr;
        
    }
    
}