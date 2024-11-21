/**
     * SLK Software Services.
     *
     * @category  controller
     * @author    rahul sinha  
     * @createdDate- March 12th, 2019
     *Contains all methods which are there for a booth area in SFDC side 
     */

Public With Sharing class PC_BoothAreaController{
    public Id referredToShowId{get;set;} 
    public string returnToUrl{get;set;}
    public string returnToBAUrl{get;set;}
    
    public PC_BoothAreaController(ApexPages.StandardSetController StandardSetController){
        referredToShowId=apexpages.currentpage().getparameters().get('id');
        if(UserInfo.getUiThemeDisplayed() == 'Theme3'){
            returnToUrl=System.Label.GC_Label_ClassicSFDC+'GC_Connect2ShowView?id='+referredToShowId;
            //returnToUrl=System.Label.GC_Label_ClassicSFDC+'GC_Connect2ShowView?id='+referredToShowId;
        }else if(UserInfo.getUiThemeDisplayed() == 'Theme4d'){
            returnToUrl= System.Label.PC_Label_Lightning+'/r/GC_Connect2_Show__c/'+referredToShowId+'/view';
            //returnToUrl= System.Label.PC_Label_Lightning+'/r/GC_Connect2_Show__c/'+referredToShowId+'/view';
        }else{
            returnToUrl='https://ges--lightning.cs17.my.salesforce.com/home/home.jsp';
        }
        system.debug('currentURL==='+Apexpages.currentPage().getUrl());
    }
    
    public  PC_BoothAreaController (ApexPages.StandardController controller){
        referredToShowId=apexpages.currentpage().getparameters().get('id');
        if(UserInfo.getUiThemeDisplayed() == 'Theme3'){
            returnToUrl=System.Label.GC_Label_ClassicSFDC+'GC_Connect2ShowView?id='+referredToShowId;
            //returnToUrl=System.Label.GC_Label_ClassicSFDC+'GC_Connect2ShowView?id='+referredToShowId;
        }else if(UserInfo.getUiThemeDisplayed() == 'Theme4d'){
            returnToUrl= System.Label.PC_Label_Lightning+'/r/GC_Connect2_Show__c/'+referredToShowId+'/view';
            //returnToUrl= System.Label.PC_Label_Lightning+'/r/GC_Connect2_Show__c/'+referredToShowId+'/view';
        }else{
            returnToUrl='https://ges--lightning.cs17.my.salesforce.com/home/home.jsp';
        }
    }
    
    //class to send a response to the component
    public class PC_BoothAreaWrapper{
        /*@AuraEnabled Booth_Area__c currentBoothArea{get;set;}
        @AuraEnabled String errorMessage{get;set;}
        @AuraEnabled String sessionId{get;set;}
        @AuraEnabled String facilityId{get;set;}
        @AuraEnabled List<string> showOrganizers{get;set;}
        @AuraEnabled List<string> operationZones{get;set;}*/  //Amarab 04/30/2021 Apex property can’t have a private or protected access modifier.
        
        @AuraEnabled public Booth_Area__c currentBoothArea{get;set;}
        @AuraEnabled public String errorMessage{get;set;}
        @AuraEnabled public String sessionId{get;set;}
        @AuraEnabled public String facilityId{get;set;}
        @AuraEnabled public List<string> showOrganizers{get;set;}
        @AuraEnabled public List<string> operationZones{get;set;}
        public PC_BoothAreaWrapper(){
            this.currentBoothArea= null;
            this.errorMessage=null;
            this.sessionId=null;
            this.showOrganizers=new List<string>(); 
            this.operationZones= new List<string>();
        }
    }
    
    //Create a session before making a callout in order to avoid the uncommitted work pending error
    @AuraEnabled
    public static void getCoreSessionID(){
        GC_Core_Session__c tempSessionObj= new GC_Core_Session__c();
        try{
            tempSessionObj=LC_CoreUtils.getSessionID();
        }catch(exception e){
            asyncGetCoreSessionID();
            system.debug(e.getMessage()+e.getStackTraceString());
            throw new AuraHandledException('Session ID not generated in CORE ' + e.getMessage()); 
        }
    }

    @AuraEnabled
    public static string performLoginToCore(){
        GC_Core_Session__c tempSessionObj= new GC_Core_Session__c();
        try{
            tempSessionObj=LC_CoreUtils.loginToCore();
        }catch(exception e){
            asyncLoginToCore();
            system.debug(e.getMessage()+e.getStackTraceString());
            throw new AuraHandledException('User Login Failed in CORE ' + e.getMessage()); 
        }
        return tempSessionObj.Core_Application_Session_ID__c;
    }

    // method to intialize the variable for create/edit/delete functionality
    @AuraEnabled
    Public static PC_BoothAreaWrapper initializeBoothAre(String recordId, String showId){
        PC_BoothAreaWrapper resultObj= new PC_BoothAreaWrapper();
        List<GC_Connect2_Show__c> parentShow;
        try{
            List<Booth_Area__c> tempRecordList=[SELECT Id,Name,BoothID_Area__c,Job_Number__c,Completion_Date_time__c, Deleteable__c,Editable__c,Operations__c ,ShowOccrCustomerId__c,Removal_Date_time__c,ShowToCustomer__c,Zone_Id__c,FacilityId__c,Delivery_Date_time__c,Delivery_Location__c,Display_Sequence__c,Connect2_Show__c,Connect2_Show__r.Facility_ID__c,Connect2_Show__r.Job_Number__c,GroupOrdersByCategory__c,GroupOrdersByParent__c,Zone__c FROM Booth_Area__c WHERE Id=:recordId];

            if(string.isNotBlank(showId)){
                parentShow=[select id,Facility_ID__c,Job_Number__c from GC_Connect2_Show__c where Id=:showId Limit 1];
            }else if(string.isNotBlank(recordId)){
                parentShow=[select id,Facility_ID__c,Job_Number__c from GC_Connect2_Show__c where Id=:tempRecordList[0].Connect2_Show__c Limit 1];
            }else{
                throw new AuraHandledException('No Show Found:'); 
            }
            if(parentShow.size()==0){
                parentShow=[select id,Facility_ID__c,Job_Number__c from GC_Connect2_Show__c where Id=:tempRecordList[0].Connect2_Show__c Limit 1];
            }
            system.debug('parentShow=='+parentShow);

            if(tempRecordList.size()>0){
               resultObj.currentBoothArea=tempRecordList[0]; 
            }else{
                resultObj.currentBoothArea= new Booth_Area__c();
            }
            
            if(parentShow.size()>0){
                resultObj.facilityId=parentShow[0].Facility_ID__c;
                resultObj.currentBoothArea.Connect2_Show__c=parentShow[0].Id;
            }

            //make the user login to CORE to checke his/her access
            // GC_Core_Session__c tempSessionObj=GC_CoreUtils.loginToCore(); // Commented and got the session through the soql
            GC_Core_Session__c tempSessionObj = [SELECT Id, Core_Application_Session_ID__c, Is_Logged_In__c, Core_Application_Session_Error_Message__c, Core_Application_Login_Error_Message__c, User_ID__c, Core_Application_Login_Expiration__c, Core_Application_Session_Expiration__c FROM GC_Core_Session__c WHERE OwnerId = :UserInfo.getUserId() order by LastModifiedDate desc limit 1];
            resultObj.sessionId= tempSessionObj.Core_Application_Session_ID__c;

            //get project details from CORE to populate the values on Edit Form
            wwwViadComV2.ShowProject ShowProject = new wwwViadComV2.ShowProject();
            wwwViadComV2.BasicHttpBinding_IShowOrganizerService BasicHttpBinding_IShowOrganizerService = new wwwViadComV2.BasicHttpBinding_IShowOrganizerService();
            system.debug('parentShow[0]=='+parentShow[0]);
            system.debug('tempSessionObj =='+ tempSessionObj);
            ShowProject=BasicHttpBinding_IShowOrganizerService.GetProjectByProjectNumber(tempSessionObj.Core_Application_Session_ID__c,parentShow[0].Job_Number__c);
            Decimal max_displaySeq=0.00;
            if(ShowProject.BoothAreas!=null && ShowProject.BoothAreas.BoothArea!=null){
                for(wwwViadComV2.BoothArea singleBoothArea:ShowProject.BoothAreas.BoothArea){
                    max_displaySeq=(max_displaySeq < singleBoothArea.DisplaySequence)?singleBoothArea.DisplaySequence:max_displaySeq;
                }
                max_displaySeq+=10;
            }
            resultObj.currentBoothArea.Display_Sequence__c=(string.isNotBlank(resultObj.currentBoothArea.Display_Sequence__c))?resultObj.currentBoothArea.Display_Sequence__c:string.valueOf(max_displaySeq);

            List<string> tempShowOrganizers= new List<string>();
            Integer counter=0;
            if(ShowProject.ShowOrganizers!=null && ShowProject.ShowOrganizers.ShowOrganizer!=null){
                for(wwwViadComV2.ShowOrganizer singleShowOrganizer:ShowProject.ShowOrganizers.ShowOrganizer){
                    if(!resultObj.showOrganizers.Contains(singleShowOrganizer.CustomerName +' -'+singleShowOrganizer.ShowOccrCustomerId)){
                        resultObj.showOrganizers.add(singleShowOrganizer.CustomerName +' -'+singleShowOrganizer.ShowOccrCustomerId);
                    }
                    if(resultObj.showOrganizers.size()>1 && counter==0 && singleShowOrganizer.ShowOccrCustomerId==resultObj.currentBoothArea.ShowOccrCustomerId__c){
                        string tempVal=resultObj.showOrganizers[0];
                        resultObj.showOrganizers.add(0,singleShowOrganizer.CustomerName +' -'+singleShowOrganizer.ShowOccrCustomerId);
                        if(!resultObj.showOrganizers.Contains(tempVal)){
                            resultObj.showOrganizers.add(tempVal);
                        }
                        counter=1;
                    }
                }
            }

            Set<string> tempOperationZones= new Set<string>();
            if(ShowProject.OperationsZones!=null && ShowProject.OperationsZones.string_x!=null){
                for(string singleOpZone:ShowProject.OperationsZones.string_x){
                    if(!resultObj.operationZones.Contains(singleOpZone)){
                        resultObj.operationZones.add(singleOpZone);
                    }
                }
            }

            if(ShowProject.Facility!=null){
                resultObj.currentBoothArea.FacilityId__c=(ShowProject.Facility.FacilityId!=null)?String.valueOf(ShowProject.Facility.FacilityId):'';
            }
            system.debug('resultObj.currentBoothArea.FacilityId__c==='+resultObj.currentBoothArea.FacilityId__c);
        }catch(exception e){
            asyncLoginToCore();
            resultObj.errorMessage=e.getMessage(); 
            system.System.debug(e.getMessage()+'---'+e.getStackTraceString());
        }
        return resultObj;
    }

    @AuraEnabled
    Public static Id saveBoothArea(Booth_Area__c boothArea, String userSessionId){
        //boothArea.Zone_Id__c=boothArea.Zone__c;
        //TestBoothAreaSubmission.submitBoothAreaLightning(userSessionId,boothArea);
        system.debug('boothArea'+boothArea);
        try{
            wwwViadComV2.BoothArea webSvcBoothArea = convertSFBoothAreaToWebSvcBA(boothArea);
            wwwViadComV2.BasicHttpBinding_IShowOrganizerService submitReq = new wwwViadComV2.BasicHttpBinding_IShowOrganizerService();
            wwwViadComV2.BoothArea resultingBoothArea= new wwwViadComV2.BoothArea();
            system.debug('boothArea.Delivery_Location__c==='+boothArea.Delivery_Location__c);
            system.debug('webSvcBoothArea.DeliveryLocation==='+webSvcBoothArea.DeliveryLocation);
            
            if(string.isNotBlank(boothArea.Id)){
                resultingBoothArea=submitReq.UpdateBoothArea(userSessionId, webSvcBoothArea);
            }else{
                resultingBoothArea=submitReq.SubmitBoothArea(userSessionId, webSvcBoothArea);
                //resultingBoothArea=TestBoothAreaSubmission.submitBoothAreaLight(userSessionId,boothArea);
            }
            system.debug('resultingBoothArea.DeliveryLocation==='+resultingBoothArea.DeliveryLocation);
            boothArea.BoothID_Area__c= (resultingBoothArea.BoothAreaId!=null) ? string.valueOf(resultingBoothArea.BoothAreaId) : '';
            upsert boothArea; 
        }catch(exception e){
            system.debug(e.getMessage()+e.getStackTraceString());
            throw new AuraHandledException('Error while saving Booth Area in CORE ' + e.getMessage()); 
        }
        return boothArea.id;
    }

    //method to convert DateTime fields to go through web services
    public static DateTime convertTimeToOracle(DateTime dt) {
        try {
            DateTime newDt = DateTime.newInstanceGmt(dt.Year(), dt.Month(), dt.Day(),dt.Hour(), dt.Minute(), dt.Second());    
            //TimeZone tz = TimeZone.getTimeZone('GMT');
            //newDt = newDt.addSeconds(-tz.getOffset(DateTime.now()) / 1000);
            return newDt;
        }
        catch (Exception e) {
            return null;
        }
    }

    //Method to convert the sfdc booth area fields to the booth area fields defined by the services
    public static wwwViadComV2.BoothArea convertSFBoothAreaToWebSvcBA(Booth_Area__c localBoothArea){
        wwwViadComV2.BoothArea webSvcBoothArea = new wwwViadComV2.BoothArea();
        webSvcBoothArea.Area = localBoothArea.Name;
        webSvcBoothArea.CompletionDateTime =convertLocaleDTInToWebSvcDT(localBoothArea.Completion_Date_time__c);
        webSvcBoothArea.DeliveryDateTime =convertLocaleDTInToWebSvcDT(localBoothArea.Delivery_Date_time__c);
        webSvcBoothArea.ShowOccrCustomerId = Integer.ValueOf(localBoothArea.ShowOccrCustomerId__c);
        webSvcBoothArea.DeliveryLocation =localBoothArea.Delivery_Location__c;
        webSvcBoothArea.DisplaySequence =Integer.ValueOf(localBoothArea.Display_Sequence__c);
        webSvcBoothArea.FacilityId =Integer.ValueOf(localBoothArea.FacilityId__c);
        webSvcBoothArea.RemovalDateTime =convertLocaleDTInToWebSvcDT(localBoothArea.Removal_Date_time__c);
        webSvcBoothArea.ShowToCustomer = localBoothArea.ShowToCustomer__c;
        webSvcBoothArea.ZoneId = localBoothArea.Zone__c;
        webSvcBoothArea.GroupOrdersByCategory=localBoothArea.GroupOrdersByCategory__c;
        webSvcBoothArea.GroupOrdersByParent=true;
        webSvcBoothArea.Operations=string.valueOf(localBoothArea.Operations__c);
        if(string.isNotBlank(localBoothArea.BoothID_Area__c)){
            webSvcBoothArea.BoothAreaId=Integer.valueOf(localBoothArea.BoothID_Area__c);
        }
        return webSvcBoothArea;
    }

    @AuraEnabled
    public static void getBoothAreasFromCore(String parentShowId){
        try{
            //get the job number for which we need the booth areas
            List<GC_Connect2_Show__c> showList=[select id,Name,Job_Number__c from GC_Connect2_Show__c WHERE id=:parentShowId];
            GC_Core_Session__c tempSessionObj;
            if(showList.size()>0){
                //make the user login to CORE to checke his/her access
                if(Test.isRunningTest()){
                    tempSessionObj=[SELECT Id, Core_Application_Session_ID__c, Is_Logged_In__c, Core_Application_Session_Error_Message__c, Core_Application_Login_Error_Message__c, User_ID__c, Core_Application_Login_Expiration__c, Core_Application_Session_Expiration__c FROM GC_Core_Session__c WHERE OwnerId = :UserInfo.getUserId() order by LastModifiedDate desc limit 1];
                }else{
                    tempSessionObj=LC_CoreUtils.loginToCore();
                }            
                
                wwwViadComV2.BasicHttpBinding_IShowOrganizerService showRequest=new wwwViadComV2.BasicHttpBinding_IShowOrganizerService();
                wwwViadComV2.ShowProject ShowProject=showRequest.GetProjectByProjectNumber(tempSessionObj.Core_Application_Session_ID__c,showList[0].Job_Number__c);

                //get Existing Booth Areas in sfdc for the show 
                List<Booth_Area__c> boothAreaList=[SELECT id,BoothID_Area__c, Connect2_Show__c,Completion_Date_time__c,Delivery_Date_time__c,Delivery_Location__c,FacilityId__c,Removal_Date_time__c,ShowOccrCustomerId__c,Zone__c,Display_Sequence__c,Operations__c,Editable__c,Deleteable__c,GroupOrdersByCategory__c,(SELECT id, name,Apply_To_All__c,Booth_Area__c,BoothAreaID__c,Discount__c,DiscountId__c,LineOfBusiness__c FROM Discounts__r) FROM Booth_Area__c  WHERE Connect2_Show__c=:parentShowId];

                //map the booths and discounts to their Core Ids
                Map<string,Booth_Area__c> mapBoothAreasToIDs= new Map<string,Booth_Area__c>(); 
                map<Decimal,Discount__c> mapDiscountsToIDs= new map<Decimal,Discount__c>();

                for(Booth_Area__c tempLocalBoothArea:boothAreaList){
                    if(!mapBoothAreasToIDs.containskey(tempLocalBoothArea.BoothID_Area__c)){
                        mapBoothAreasToIDs.put(tempLocalBoothArea.BoothID_Area__c,tempLocalBoothArea);
                    }
                    for(Discount__c tempLOcalDicount:tempLocalBoothArea.Discounts__r){
                        if(!mapDiscountsToIDs.containskey(tempLOcalDicount.DiscountId__c)){
                            mapDiscountsToIDs.put(tempLOcalDicount.DiscountId__c,tempLOcalDicount);
                        }
                    }
                }

                //create a list of all booth areas which are not there in sfdc
                List<Booth_Area__c>loacalBAtoBeCreated= new List<Booth_Area__c>();
                Map<Decimal,wwwViadComV2.BoothAreaDiscount> mapWebSvcDiscToIDs= new Map<Decimal,wwwViadComV2.BoothAreaDiscount>();
                //System.debug('ShowProject--->'+ShowProject);
                for(wwwViadComV2.BoothArea tempWebSvcBoothArea:ShowProject.BoothAreas.BoothArea){
                    if(mapBoothAreasToIDs.containskey(string.ValueOf(tempWebSvcBoothArea.BoothAreaId))){
                        Booth_Area__c tempLocalBAToUpdate= mapBoothAreasToIDs.get(string.ValueOf(tempWebSvcBoothArea.BoothAreaId));
                        String tempLocalBoothAreaID= tempLocalBAToUpdate.id;
                        tempLocalBAToUpdate= convertWebSvcBAtoLocal(tempWebSvcBoothArea,parentShowId);
                        tempLocalBAToUpdate.id=tempLocalBoothAreaID;
                        loacalBAtoBeCreated.add(tempLocalBAToUpdate);
                    }else{
                        Booth_Area__c tempLocalBAToCreate=convertWebSvcBAtoLocal(tempWebSvcBoothArea,parentShowId);
                        loacalBAtoBeCreated.add(tempLocalBAToCreate);
                    }
                    if(tempWebSvcBoothArea.Discounts!=null){
                        for(wwwViadComV2.BoothAreaDiscount tempWebSvcDiscount:tempWebSvcBoothArea.Discounts.BoothAreaDiscount){
                            if(!mapWebSvcDiscToIDs.containskey(tempWebSvcDiscount.DiscountId)){
                                mapWebSvcDiscToIDs.put(tempWebSvcDiscount.DiscountId,tempWebSvcDiscount);
                            }
                        }
                    }
                }

                //Update or Insert the Booth Areas in SFDC 
                if(loacalBAtoBeCreated.size()>0){
                    upsert loacalBAtoBeCreated;
                    for(Booth_Area__c tempLocalBoothArea: loacalBAtoBeCreated){
                        if(!mapBoothAreasToIDs.containskey(tempLocalBoothArea.BoothID_Area__c)){
                            mapBoothAreasToIDs.put(tempLocalBoothArea.BoothID_Area__c,tempLocalBoothArea);
                        }
                    }
                }

                // Start the same with Discounts 
                List<Discount__c> localDiscountsToBeCreated= new List<Discount__c>();
                for(Decimal tempWebSvcDiscountId: mapWebSvcDiscToIDs.keySet()){
                    if(mapDiscountsToIDs.containskey(tempWebSvcDiscountId)){
                        Discount__c tempLocalDiscountToUpdate=mapDiscountsToIDs.get(tempWebSvcDiscountId);
                        String tempLOcalDicountID=tempLocalDiscountToUpdate.id;
                        tempLocalDiscountToUpdate=convertWebSvcDiscounttoLocal(mapWebSvcDiscToIDs.get(tempWebSvcDiscountId),tempLocalDiscountToUpdate.Booth_Area__c);
                        tempLocalDiscountToUpdate.id=tempLOcalDicountID;
                        localDiscountsToBeCreated.add(tempLocalDiscountToUpdate);
                    }else{
                        wwwViadComV2.BoothAreaDiscount tempWebSvcDiscount =mapWebSvcDiscToIDs.get(tempWebSvcDiscountId);
                        Discount__c tempLocalDiscountToCreate=convertWebSvcDiscounttoLocal(tempWebSvcDiscount,mapBoothAreasToIDs.get(string.valueOf(tempWebSvcDiscount.BoothAreaId)).id);
                        localDiscountsToBeCreated.add(tempLocalDiscountToCreate);
                    }
                } 
                if(localDiscountsToBeCreated.size()>0){
                    upsert localDiscountsToBeCreated;
                }
            }

        }catch(exception e){
            system.debug('error is'+e.getMessage()+e.getStackTraceString());
            throw new AuraHandledException('Error getting Booth Areas from Core' + e.getMessage()); 
        }
    }

    //method to convert web services Booth Area to SFDC Booth Area
    public static Booth_Area__c convertWebSvcBAtoLocal(wwwViadComV2.BoothArea webSvcBoothArea, string parentShowId){
        Booth_Area__c sfdcBoothArea=new Booth_Area__c();
        sfdcBoothArea.Name= (string.isNotBlank((webSvcBoothArea.Area))) ? webSvcBoothArea.Area:'Undefined' ;
        sfdcBoothArea.BoothID_Area__c=string.valueOf(webSvcBoothArea.BoothAreaId);
        /*code start-1261: corrected the external time*/
        //sfdcBoothArea.Completion_Date_time__c= webSvcBoothArea.CompletionDateTime;
        //sfdcBoothArea.Delivery_Date_time__c=webSvcBoothArea.DeliveryDateTime;
        sfdcBoothArea.Completion_Date_time__c= LC_CoreUtils.convertExternalDateTime(webSvcBoothArea.CompletionDateTime);
        sfdcBoothArea.Delivery_Date_time__c=LC_CoreUtils.convertExternalDateTime(webSvcBoothArea.DeliveryDateTime);
        /*code end-1261*/
        sfdcBoothArea.Delivery_Location__c=webSvcBoothArea.DeliveryLocation;
        sfdcBoothArea.FacilityId__c=string.valueOf(webSvcBoothArea.FacilityId);
        sfdcBoothArea.Removal_Date_time__c=LC_CoreUtils.convertExternalDateTime(webSvcBoothArea.RemovalDateTime);
        sfdcBoothArea.ShowOccrCustomerId__c=webSvcBoothArea.ShowOccrCustomerId;
        sfdcBoothArea.Zone__c=webSvcBoothArea.ZoneId;
        sfdcBoothArea.Display_Sequence__c=string.ValueOf(webSvcBoothArea.DisplaySequence);
        sfdcBoothArea.Operations__c=webSvcBoothArea.Operations;
        sfdcBoothArea.Connect2_Show__c=parentShowId;
        sfdcBoothArea.Editable__c=webSvcBoothArea.Editable;
        sfdcBoothArea.Deleteable__c=webSvcBoothArea.Deleteable;
        sfdcBoothArea.GroupOrdersByCategory__c=webSvcBoothArea.GroupOrdersByCategory;
        return sfdcBoothArea;
    }

    //method to convert web services Discount to SFDC Discounts
    public static Discount__c convertWebSvcDiscounttoLocal(wwwViadComV2.BoothAreaDiscount bothAreaDiscount, String localBoothAreaId){
        Discount__c newDiscount = new Discount__c();
        newDiscount.Discount__c=string.valueof(bothAreaDiscount.Percentage);
        newDiscount.LineOfBusiness__c=bothAreaDiscount.LineOfBusiness;
        if(bothAreaDiscount.ApplyToAllBoothAreas==null){
            newDiscount.Apply_To_All__c= false;
        }else{
            newDiscount.Apply_To_All__c= true;
        }
        newDiscount.DiscountId__c = bothAreaDiscount.DiscountId;
        system.debug('newDiscount.Apply_To_All__c=='+newDiscount.Apply_To_All__c);
        newDiscount.Booth_Area__c = localBoothAreaId;
        newDiscount.BoothAreaID__c=string.valueOf(bothAreaDiscount.BoothAreaId);
        return newDiscount;
    }

    //method to convert the datetime to GMT including the DST 
    public static DateTime convertLocaleDTInToWebSvcDT(DateTime localDt){
        try {
            TimeZone tz = UserInfo.getTimeZone();
            Integer offset=0;
            offset=tz.getOffset(localDt);
            localDt.addSeconds((-1*offset)/1000); //gives the GMT dateTime
            DateTime newDt = DateTime.newInstanceGmt(localDt.Year(), localDt.Month(), localDt.Day(),localDt.Hour(), localDt.Minute(), localDt.Second());    
            return newDt;
        }catch (Exception e) {
                return null;
        }
    }
    
    @future(callout=true)
    public static void asyncGetCoreSessionID(){
        GC_Core_Session__c tempSessionObj= new GC_Core_Session__c();
        try{
            tempSessionObj=LC_CoreUtils.getSessionID();
        }catch(exception e){
            //system.debug(e.getMessage()+e.getStackTraceString());
            //throw new AuraHandledException('Session ID not generated in CORE ' + e.getMessage()); 
        }
    }
    
    @future(callout=true)
    public static void asyncLoginToCore(){
        GC_Core_Session__c tempSessionObj= new GC_Core_Session__c();
        try{
            tempSessionObj=LC_CoreUtils.loginToCore();
        }catch(exception e){
            system.debug(e.getMessage()+e.getStackTraceString());
            //throw new AuraHandledException('User Login Failed in CORE ' + e.getMessage()); 
        }
    }
    
    @AuraEnabled
    public static string finalDeleteBoothArea(String boothAreaID){
        string returnURL;
        try{
            string userSessionId;           
            if(Test.isRunningTest()){
                    GC_Core_Session__c tempSessionObj=[SELECT Id, Core_Application_Session_ID__c, Is_Logged_In__c, Core_Application_Session_Error_Message__c, Core_Application_Login_Error_Message__c, User_ID__c, Core_Application_Login_Expiration__c, Core_Application_Session_Expiration__c FROM GC_Core_Session__c WHERE OwnerId = :UserInfo.getUserId() order by LastModifiedDate desc limit 1];
                userSessionId = tempSessionObj.Core_Application_Session_ID__c;  
                }else{
                    userSessionId = performLoginToCore();
                } 
            
            List<Booth_Area__c> tempRecordList=[SELECT Id,Name,BoothID_Area__c,Job_Number__c,Completion_Date_time__c, Deleteable__c,Editable__c,Operations__c ,ShowOccrCustomerId__c,Removal_Date_time__c,ShowToCustomer__c,Zone_Id__c,FacilityId__c,Delivery_Date_time__c,Delivery_Location__c,Display_Sequence__c,Connect2_Show__c,Connect2_Show__r.Facility_ID__c,Connect2_Show__r.Job_Number__c,GroupOrdersByCategory__c,GroupOrdersByParent__c,Zone__c FROM Booth_Area__c WHERE Id=:boothAreaID];
            if(tempRecordList.size()>0){
                string tempParentShowId=tempRecordList[0].Connect2_Show__c;
                wwwViadComV2.BasicHttpBinding_IShowOrganizerService submitReq = new wwwViadComV2.BasicHttpBinding_IShowOrganizerService();
                wwwViadComV2.BoothArea resultingBoothArea=submitReq.DeleteBoothArea(userSessionId, Integer.ValueOf(tempRecordList[0].BoothID_Area__c));
                if(resultingBoothArea!=null){
                    delete tempRecordList[0];
                    if(UserInfo.getUiThemeDisplayed() == 'Theme3'){
                        returnURL=System.Label.GC_Label_ClassicSFDC+'GC_Connect2ShowView?id='+tempParentShowId;
                    }else if(UserInfo.getUiThemeDisplayed() == 'Theme4d'){
                        returnURL= System.Label.PC_Label_Lightning+'/r/GC_Connect2_Show__c/'+tempParentShowId+'/view';
                    }else{
                        returnURL='https://ges--lightning.cs17.my.salesforce.com/home/home.jsp';
                    }
                }else{
                    throw new AuraHandledException('Error while deleting Booth Area in CORE.Please chekc with the system admin. Thank you.');
                }
            }else{
                throw new AuraHandledException('No Booth Areas found with this ID');
            }
        }catch(exception e){
            system.debug(e.getMessage()+'==='+e.getStackTraceString());
            throw new AuraHandledException('Error while deleting Booth Area in CORE ' + e.getMessage()); 
        }
        return returnURL;
    }
    
    /*code start-1261: Fixed Uncommitted work pending to move method (refreshBoothAreasFromCore) into Future call, added by Sajid on 09/07/23*/
    @AuraEnabled    
    public static void refreshBoothAreasFromCore(String parentShowId){
        try{
            //get the job number for which we need the booth areas
            List<GC_Connect2_Show__c> showList=[select id,Name,Job_Number__c from GC_Connect2_Show__c WHERE id=:parentShowId];
            GC_Core_Session__c tempSessionObj;
            if(showList.size()>0){
                //make the user login to CORE to checke his/her access
                if(Test.isRunningTest()){
                    tempSessionObj=[SELECT Id, Core_Application_Session_ID__c, Is_Logged_In__c, Core_Application_Session_Error_Message__c, Core_Application_Login_Error_Message__c, User_ID__c, Core_Application_Login_Expiration__c, Core_Application_Session_Expiration__c FROM GC_Core_Session__c WHERE OwnerId = :UserInfo.getUserId() order by LastModifiedDate desc limit 1];
                }else{
                    tempSessionObj=LC_CoreUtils.loginToCore();
                } 
                asyncRefreshBoothAreasFromCore(parentShowId,tempSessionObj.Core_Application_Session_ID__c,showList[0].Job_Number__c);
            }
        }catch(exception e){
            system.debug('error is'+e.getMessage()+e.getStackTraceString());
            throw new AuraHandledException('Error getting Booth Areas from Core' + e.getMessage()); 
        }
    }
    
    @future(callout=true)
    public static void asyncRefreshBoothAreasFromCore(String parentShowId, String sessionId, String jobNumber){
        try{      
            
            wwwViadComV2.BasicHttpBinding_IShowOrganizerService showRequest=new wwwViadComV2.BasicHttpBinding_IShowOrganizerService();
            wwwViadComV2.ShowProject ShowProject=showRequest.GetProjectByProjectNumber(sessionId,jobNumber);
            
            //get Existing Booth Areas in sfdc for the show 
            List<Booth_Area__c> boothAreaList=[SELECT id,BoothID_Area__c, Connect2_Show__c,Completion_Date_time__c,Delivery_Date_time__c,Delivery_Location__c,FacilityId__c,Removal_Date_time__c,ShowOccrCustomerId__c,Zone__c,Display_Sequence__c,Operations__c,Editable__c,Deleteable__c,GroupOrdersByCategory__c,(SELECT id, name,Apply_To_All__c,Booth_Area__c,BoothAreaID__c,Discount__c,DiscountId__c,LineOfBusiness__c FROM Discounts__r) FROM Booth_Area__c  WHERE Connect2_Show__c=:parentShowId];
            
            //map the booths and discounts to their Core Ids
            Map<string,Booth_Area__c> mapBoothAreasToIDs= new Map<string,Booth_Area__c>(); 
            map<Decimal,Discount__c> mapDiscountsToIDs= new map<Decimal,Discount__c>();
            
            for(Booth_Area__c tempLocalBoothArea:boothAreaList){
                if(!mapBoothAreasToIDs.containskey(tempLocalBoothArea.BoothID_Area__c)){
                    mapBoothAreasToIDs.put(tempLocalBoothArea.BoothID_Area__c,tempLocalBoothArea);
                }
                for(Discount__c tempLOcalDicount:tempLocalBoothArea.Discounts__r){
                    if(!mapDiscountsToIDs.containskey(tempLOcalDicount.DiscountId__c)){
                        mapDiscountsToIDs.put(tempLOcalDicount.DiscountId__c,tempLOcalDicount);
                    }
                }
            }
            
            //create a list of all booth areas which are not there in sfdc
            List<Booth_Area__c>loacalBAtoBeCreated= new List<Booth_Area__c>();
            Map<Decimal,wwwViadComV2.BoothAreaDiscount> mapWebSvcDiscToIDs= new Map<Decimal,wwwViadComV2.BoothAreaDiscount>();
            //System.debug('ShowProject--->'+ShowProject);
            for(wwwViadComV2.BoothArea tempWebSvcBoothArea:ShowProject.BoothAreas.BoothArea){
                if(mapBoothAreasToIDs.containskey(string.ValueOf(tempWebSvcBoothArea.BoothAreaId))){
                    Booth_Area__c tempLocalBAToUpdate= mapBoothAreasToIDs.get(string.ValueOf(tempWebSvcBoothArea.BoothAreaId));
                    String tempLocalBoothAreaID= tempLocalBAToUpdate.id;
                    tempLocalBAToUpdate= convertWebSvcBAtoLocal(tempWebSvcBoothArea,parentShowId);
                    tempLocalBAToUpdate.id=tempLocalBoothAreaID;
                    loacalBAtoBeCreated.add(tempLocalBAToUpdate);
                }else{
                    Booth_Area__c tempLocalBAToCreate=convertWebSvcBAtoLocal(tempWebSvcBoothArea,parentShowId);
                    loacalBAtoBeCreated.add(tempLocalBAToCreate);
                }
                if(tempWebSvcBoothArea.Discounts!=null){
                    for(wwwViadComV2.BoothAreaDiscount tempWebSvcDiscount:tempWebSvcBoothArea.Discounts.BoothAreaDiscount){
                        if(!mapWebSvcDiscToIDs.containskey(tempWebSvcDiscount.DiscountId)){
                            mapWebSvcDiscToIDs.put(tempWebSvcDiscount.DiscountId,tempWebSvcDiscount);
                        }
                    }
                }
            }
            
            //Update or Insert the Booth Areas in SFDC 
            if(loacalBAtoBeCreated.size()>0){
                upsert loacalBAtoBeCreated;
                for(Booth_Area__c tempLocalBoothArea: loacalBAtoBeCreated){
                    if(!mapBoothAreasToIDs.containskey(tempLocalBoothArea.BoothID_Area__c)){
                        mapBoothAreasToIDs.put(tempLocalBoothArea.BoothID_Area__c,tempLocalBoothArea);
                    }
                }
            }
            
            // Start the same with Discounts 
            List<Discount__c> localDiscountsToBeCreated= new List<Discount__c>();
            for(Decimal tempWebSvcDiscountId: mapWebSvcDiscToIDs.keySet()){
                if(mapDiscountsToIDs.containskey(tempWebSvcDiscountId)){
                    Discount__c tempLocalDiscountToUpdate=mapDiscountsToIDs.get(tempWebSvcDiscountId);
                    String tempLOcalDicountID=tempLocalDiscountToUpdate.id;
                    tempLocalDiscountToUpdate=convertWebSvcDiscounttoLocal(mapWebSvcDiscToIDs.get(tempWebSvcDiscountId),tempLocalDiscountToUpdate.Booth_Area__c);
                    tempLocalDiscountToUpdate.id=tempLOcalDicountID;
                    localDiscountsToBeCreated.add(tempLocalDiscountToUpdate);
                }else{
                    wwwViadComV2.BoothAreaDiscount tempWebSvcDiscount =mapWebSvcDiscToIDs.get(tempWebSvcDiscountId);
                    Discount__c tempLocalDiscountToCreate=convertWebSvcDiscounttoLocal(tempWebSvcDiscount,mapBoothAreasToIDs.get(string.valueOf(tempWebSvcDiscount.BoothAreaId)).id);
                    localDiscountsToBeCreated.add(tempLocalDiscountToCreate);
                }
            } 
            if(localDiscountsToBeCreated.size()>0){
                upsert localDiscountsToBeCreated;
            }
            
        }catch(exception e){
            system.debug('error is'+e.getMessage()+e.getStackTraceString());
            throw new AuraHandledException('Error getting Booth Areas from Core' + e.getMessage()); 
        }
    }
    /*code End-1261, added by Sajid on 09/07/23 */
}