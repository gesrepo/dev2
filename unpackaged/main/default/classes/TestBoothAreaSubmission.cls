Public class TestBoothAreaSubmission {
    
    public static Decimal varFacilityId=0;
    public static Decimal maxvalue=0;
    public static set<Integer> showOccurId=new set<Integer>(); 
    public static set<String> varZones=new set<String>(); 
    public static set<String> varShowOrganizersList=new set<String>(); 
    
    public static string SessionLogin() {
        string ApplicationID = 'GES Connect';
        String ApplicationKey = '%{Q\\eGh4N-QDs!wx';
        string companyId;
        string languageId;
        /**
* Start App Session
**/
        if(Test.isRunningTest()) {
            Test.setMock(WebServiceMock.class, new BoothAreaWebServiceMock('SessionLogin'));
        }
       
        wwwViadComSecurityV2.BasicHttpBinding_IAuthenticationService s = new wwwViadComSecurityV2.BasicHttpBinding_IAuthenticationService();
        wwwViadComSecurityV2.AppSessionInfo a = s.StartAppSession(ApplicationID, ApplicationKey, companyId, languageId);
        String applicationSessionId = a.sessionID;
        String AppSessionID = a.sessionID;
        String Email=UserInfo.getUserEmail(); //curent user email'ldrummond@ges.com';
        system.debug('Email: ' + Email);
        Boolean RetrieveSecurityGroups = true;
        /**
*User Login Without Password  
**/
        system.debug('AppSessionID==='+AppSessionID);
        system.debug('Email==='+Email);
        wwwViadComSecurityV2.BasicHttpBinding_IAuthenticationService req = new wwwViadComSecurityV2.BasicHttpBinding_IAuthenticationService();
        try{
            wwwViadComSecurityV2.AppSessionInfo userLogin=req.UserLoginWithoutPassword(AppSessionID,Email,RetrieveSecurityGroups);
        }catch(System.CalloutException ce){
            system.debug ('CalloutException caught');
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'User account doesn\'t exist in Core! Please contact System Admin.');
            ApexPages.addMessage(myMsg); 
            return null;
        }
        return a.sessionID;
    }
    Public static decimal GetDispalySequence(string sessionId,string Projectnumber){
        string AppSessionID = sessionId;
        system.debug('AppSessionID---'+ AppSessionID);
        system.debug('Projectnumber---'+ Projectnumber);
        /**
* GetBootharea
**/     
        if(Test.isRunningTest()) {
            Test.setMock(WebServiceMock.class, new BoothAreaWebServiceMock('GetProjectByProjectNumber'));
        }
        wwwViadComV2.ShowProject s2 = new wwwViadComV2.ShowProject();
        try
        {
            wwwViadComV2.BasicHttpBinding_IShowOrganizerService showRequest=new wwwViadComV2.BasicHttpBinding_IShowOrganizerService();
            s2=showRequest.GetProjectByProjectNumber(AppSessionID,projectNumber);
        }
        catch(System.CalloutException ce)
        {
            system.debug ('CalloutException caught');
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Job Number doesn\'t exist in Core! Please contact System Admin.');
            ApexPages.addMessage(myMsg); 
            return maxvalue;
        }
        //system.debug('ProjectS2---'+ s2);
        wwwViadComV2.ArrayOfBoothArea BoothAreas =s2.BoothAreas;
        //get the facility ID
        wwwViadComV2.Facility projectFacility = s2.Facility; 
        varFacilityId = projectFacility.FacilityId;
        // get the Operations Zone
        schemasMicrosoftCom200310Serializat.ArrayOfstring opZones= s2.OperationsZones;
        String [] zoneValues= opZones.string_x;
        for(String varString: zoneValues){
            varZones.add(varString);
        }
        // get the Customer Name and ShowOccrCustomerId     
        wwwViadComV2.ArrayOfShowOrganizer showOrganizers= s2.ShowOrganizers;
        wwwViadComV2.ShowOrganizer[] allShowOrganizers= showOrganizers.ShowOrganizer;
        for(wwwViadComV2.ShowOrganizer varShowOrganizer:allShowOrganizers){
            varShowOrganizersList.add(varShowOrganizer.CustomerName +' -'+varShowOrganizer.ShowOccrCustomerId);
        }
        
        list<wwwViadComV2.BoothArea> boothInformation=new list<wwwViadComV2.BoothArea>();
        list<Booth_Area__c> boothList=new List<Booth_Area__c>();
        boothInformation=BoothAreas.BoothArea;
        List<Decimal> dispalySeq=new List<Decimal>();
        for(wwwViadComV2.BoothArea c:boothInformation){
            dispalySeq.add(c.DisplaySequence);
            //showOccurId.add(c.ShowOccrCustomerId);
        }
        
        //system.debug('dispalySeq---'+ dispalySeq);
        /**
*Finding Max display Sequence
**/
        maxvalue = dispalySeq[0];
        For (integer i =0;i<dispalySeq.size();i++)
        {
            
            if( dispalySeq[i] > maxvalue)
                maxvalue =dispalySeq[i];             
        }    
        system.debug('maxvalue---'+ maxvalue);
        return maxvalue;
        
    }    
    public static set<Integer> showOccurCustomerDispaly(string sessionId,string Projectnumber){
        if(showOccurId.isEmpty())
        {   
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Show occurance does not exist in Core! Please check the show in core.');
            ApexPages.addMessage(myMsg);
        }          
            return showOccurId;
    }
    
    public static Decimal getFacilityID(){
        if(varFacilityId==0){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Facility ID for this show doesn\'t exist in Core! Please contact System Admin.');
            ApexPages.addMessage(myMsg); 
            return varFacilityId;
        }else{
            return varFacilityId;
        }
        
    }
    public static void submitBoothArea(string sessionId,Booth_Area__c bc) {
    system.debug('inside submitBoothArea-------');
        string AppSessionID = sessionId;
        wwwViadComV2.BoothArea bc1 = new wwwViadComV2.BoothArea();
        bc1.Area = bc.Name;
        bc1.CompletionDateTime =convertTimeToOracle(bc.Completion_Date_time__c);
        bc1.DeliveryDateTime =convertTimeToOracle(bc.Delivery_Date_time__c);
        /*String inputCustomer= String.ValueOf(bc.ShowOccrCustomerId__c);
        system.debug('inputCustomer===='+inputCustomer);
        
        String customerID=inputCustomer.substringAfterLast('-');
        system.debug('customerID===='+customerID);
        Integer varX= Integer.valueOf(customerID);
        system.debug('varX===='+varX);
        bc.ShowOccrCustomerId__c =varX;*/ 
        bc1.ShowOccrCustomerId = Integer.ValueOf(bc.ShowOccrCustomerId__c);
        bc1.DeliveryLocation =bc.Delivery_Location__c;
        bc1.DisplaySequence =Integer.ValueOf(bc.Display_Sequence__c);
        bc1.FacilityId =Integer.ValueOf(bc.FacilityId__c);
        bc1.RemovalDateTime =convertTimeToOracle(bc.Removal_Date_time__c);
        bc1.ShowToCustomer = bc.ShowToCustomer__c;
        bc1.ZoneId = bc.Zone_Id__c;
        bc1.GroupOrdersByCategory=bc.GroupOrdersByCategory__c;
        bc1.GroupOrdersByParent=true;
        /***Calling WSDL file for Submit Area **/
        wwwViadComV2.BasicHttpBinding_IShowOrganizerService submitReq = new wwwViadComV2.BasicHttpBinding_IShowOrganizerService();
        system.debug('GroupOrdersByCategory__c-------' + bc1.GroupOrdersByCategory);
        system.debug('GroupOrdersByParent-------' + bc1.GroupOrdersByParent);
        wwwViadComV2.BoothArea b = submitReq.SubmitBoothArea(AppSessionID, bc1);
       
        if(b!=null){
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'BoothArea has been submitted successfully to the Core');
            ApexPages.addMessage(myMsg);
        }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'BoothArea could not be submitted to the Core. Please contact System Admin');
            ApexPages.addMessage(myMsg);
        }
    }
    public static string updataBooth(string sessionId,Booth_Area__c bc){
    system.debug('update submitBoothArea-------');
        string AppSessionID=sessionId;
        wwwViadComV2.BoothArea bc1=new wwwViadComV2.BoothArea();
        
        bc1.Area=bc.Name;
        bc1.BoothAreaId=Integer.valueOf(bc.BoothID_Area__c);
        bc1.CompletionDateTime=convertTimeToOracle(bc.Completion_Date_time__c);
        bc1.DeliveryDateTime=convertTimeToOracle(bc.Delivery_Date_time__c);
        bc1.DisplaySequence =Integer.ValueOf(bc.Display_Sequence__c);
        bc1.ShowOccrCustomerId= Integer.ValueOf(bc.ShowOccrCustomerId__c);
        bc1.DeliveryLocation= bc.Delivery_Location__c;
        bc1.FacilityId= Integer.ValueOf(bc.FacilityId__c);
        bc1.RemovalDateTime=convertTimeToOracle(bc.Removal_Date_time__c);
        bc1.ShowToCustomer=bc.ShowToCustomer__c;
        bc1.ZoneId= bc.Zone_Id__c;
        bc1.Operations=bc.Operations__c;
        bc1.GroupOrdersByCategory = bc.GroupOrdersByCategory__c;
        bc1.GroupOrdersByParent = bc.GroupOrdersByParent__c;
          system.debug(' bc1.GroupOrdersByCategory ='+ bc1.GroupOrdersByCategory);
        if(Test.isRunningTest()) {
            Test.setMock(WebServiceMock.class, new BoothAreaWebServiceMock('UpdateBoothArea'));
        }
        wwwViadComV2.BasicHttpBinding_IShowOrganizerService updatebooth=new wwwViadComV2.BasicHttpBinding_IShowOrganizerService();
        wwwViadComV2.BoothArea b = updatebooth.UpdateBoothArea(AppSessionID, bc1);
        if(b!=null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'BoothArea has been updated successfully in the Core');
            ApexPages.addMessage(myMsg);
        }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'BoothArea could not be updated in the Core. Please contact System Admin');
            ApexPages.addMessage(myMsg);
        }
        return 'success';
    }
    
    public  static void DeleteBoothArea(string sessionId,Booth_Area__c bc){
        string AppSessionID=sessionId;
        wwwViadComV2.BoothArea bc1=new wwwViadComV2.BoothArea();
        Integer booth1 =Integer.ValueOf(bc.BoothID_Area__c);
        if(Test.isRunningTest()) {
            Test.setMock(WebServiceMock.class, new BoothAreaWebServiceMock('DeleteBoothArea'));
        }
        wwwViadComV2.BasicHttpBinding_IShowOrganizerService deletebooth=new wwwViadComV2.BasicHttpBinding_IShowOrganizerService();
        wwwViadComV2.BoothArea b = deletebooth.DeleteBoothArea(AppSessionID,booth1);
        if(b!=null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'BoothArea has been deleted successfully in the Core');
            ApexPages.addMessage(myMsg);
        }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'BoothArea could not be deleted in the Core. Please contact System Admin');
            ApexPages.addMessage(myMsg);
        }
    }
    public static set<String> getOperationZones(){
        if(varZones.isEmpty()){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Zones for this show doesn\'t exist in Core! Please contact System Admin.');
            ApexPages.addMessage(myMsg);
            
        }
        return varZones; 
        
    }
    public static set<String> getCustomerDetails(){
        if(varShowOrganizersList.isEmpty()){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Zones for this show doesn\'t exist in Core! Please contact System Admin.');
            ApexPages.addMessage(myMsg);
            
        }
        return varShowOrganizersList; 
        
    }
    
    public static DateTime convertTimeToOracle(DateTime dt) {
        try {
            DateTime newDt = DateTime.newInstanceGmt(dt.Year(), dt.Month(), dt.Day(),
                                                  dt.Hour(), dt.Minute(), dt.Second());
           
            //TimeZone tz = TimeZone.getTimeZone('GMT');
            //newDt = newDt.addSeconds(-tz.getOffset(DateTime.now()) / 1000);
            return newDt;
        }
        catch (Exception e) {
            return null;
        }
}

}