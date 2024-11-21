global with sharing  class RefreshBoothArea {
    webService static void refreshMethod(string ShowId){
        GC_Connect2_Show__c cs=[select id,Name,Job_Number__c from GC_Connect2_Show__c WHERE ID=:ShowId];
        string ApplicationID='GES Connect';
        String ApplicationKey = '%{Q\\eGh4N-QDs!wx';
        string companyId;
        string languageId;
        /**
         * For Getting session id
        **/
        if(Test.isRunningTest()) {
            Test.setMock(WebServiceMock.class, new BoothAreaWebServiceMock('SessionLogin'));
        }
        wwwViadComSecurityV2.BasicHttpBinding_IAuthenticationService s=new wwwViadComSecurityV2.BasicHttpBinding_IAuthenticationService();
        wwwViadComSecurityV2.AppSessionInfo a=s.StartAppSession(ApplicationID,ApplicationKey,companyId,languageId);
        String applicationSessionId=a.sessionID;
        string projectNumber=cs.Job_Number__c; 
        String AppSessionID=a.sessionID;
        String Email=UserInfo.getUserEmail();
        system.debug('Email: ' + Email);
        Boolean RetrieveSecurityGroups=true;
        wwwViadComSecurityV2.BasicHttpBinding_IAuthenticationService req=new wwwViadComSecurityV2.BasicHttpBinding_IAuthenticationService();
        try{
            wwwViadComSecurityV2.AppSessionInfo userLogin=req.UserLoginWithoutPassword(AppSessionID,Email,RetrieveSecurityGroups);
        }catch(exception ex){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'User account is invalid');
            ApexPages.addMessage(myMsg); 
        }
        /**
         * GetBootharea
         **/
        if(Test.isRunningTest()) {
            Test.setMock(WebServiceMock.class, new BoothAreaWebServiceMock('GetProjectByProjectNumber'));
        }
        wwwViadComV2.BasicHttpBinding_IShowOrganizerService showRequest=new wwwViadComV2.BasicHttpBinding_IShowOrganizerService();
        wwwViadComV2.ShowProject s2=showRequest.GetProjectByProjectNumber(applicationSessionId,projectNumber);
        wwwViadComV2.ArrayOfBoothArea BoothAreas =s2.BoothAreas;
        list<wwwViadComV2.BoothArea> boothInformation=new list<wwwViadComV2.BoothArea>();
        list<Booth_Area__c> boothList=new List<Booth_Area__c>();
        boothInformation=BoothAreas.BoothArea;
        
        set<integer> boothAreaId=new set<integer>();
        List<Booth_Area__c> bcList=[select id,BoothID_Area__c from Booth_Area__c  where Connect2_Show__c=:ShowId];
        if(!bcList.isEmpty()){
            delete bcList;
        }
         
        Map<String, wwwViadComV2.ArrayOfBoothAreaDiscount> mapBothAreaDiscount = new Map<String, wwwViadComV2.ArrayOfBoothAreaDiscount>();
        List<Discount__c> listDiscountToInsert = new List<Discount__c>();
        for(wwwViadComV2.BoothArea c:boothInformation){
             Booth_Area__c bo=new Booth_Area__c();
                bo.Name=c.Area;
                bo.BoothID_Area__c=string.valueOf(c.BoothAreaId);
                bo.Completion_Date_time__c= GC_CoreUtils.convertExternalDateTime(c.CompletionDateTime);
                bo.Delivery_Date_time__c=GC_CoreUtils.convertExternalDateTime(c.DeliveryDateTime);
                bo.Delivery_Location__c=c.DeliveryLocation;
                bo.FacilityId__c=string.valueOf(c.FacilityId);
                bo.Removal_Date_time__c=GC_CoreUtils.convertExternalDateTime(c.RemovalDateTime);
                bo.ShowOccrCustomerId__c=c.ShowOccrCustomerId;
                bo.Zone_Id__c=c.ZoneId;
                bo.Delivery_Location__c=c.DeliveryLocation;
                bo.Display_Sequence__c=string.ValueOf(c.DisplaySequence);
                bo.Operations__c=c.Operations;
                bo.Connect2_Show__c=ShowId;
                bo.Editable__c=c.Editable;
                bo.Deleteable__c=c.Deleteable;
                bo.GroupOrdersByCategory__c=c.GroupOrdersByCategory;

                
            if(Test.isRunningTest()) {
                Test.setMock(WebServiceMock.class, new DiscountWebServiceMock('SubmitDiscount'));
            }  
            if(c.Discounts != null) {
                wwwViadComV2.ArrayOfBoothAreaDiscount listDiscount = c.Discounts;
                //system.debug('listDiscount==='+listDiscount);
                  mapBothAreaDiscount.put(bo.BoothID_Area__c, listDiscount);
            }
            boothList.add(bo);
        }
        if(!boothList.isEmpty()){
              Insert boothList;
        } 
        for(Booth_Area__c bo : boothList) {
            if(mapBothAreaDiscount.get(bo.BoothID_Area__c) != null) {
                wwwViadComV2.ArrayOfBoothAreaDiscount listDiscount = mapBothAreaDiscount.get(bo.BoothID_Area__c);
                for(wwwViadComV2.BoothAreaDiscount bothAreaDiscount : listDiscount.BoothAreaDiscount) {
                 // system.debug('bothAreaDiscount==='+bothAreaDiscount.DiscountId);
                  Discount__c newDiscount = new Discount__c();
                  newDiscount.Discount__c=string.valueof(bothAreaDiscount.Percentage);
                    newDiscount.LineOfBusiness__c=bothAreaDiscount.LineOfBusiness;
                    
                    if(bothAreaDiscount.ApplyToAllBoothAreas==null)
                   newDiscount.Apply_To_All__c= false;
                       else
                   newDiscount.Apply_To_All__c= true;
                   
                   
                   newDiscount.DiscountId__c = bothAreaDiscount.DiscountId;
                   newDiscount.Booth_Area__c = bo.id;
                   listDiscountToInsert.add(newDiscount);
                }
            }
        }
        //system.debug('>>>>listDiscountToInsert>>>'+listDiscountToInsert);
        if(listDiscountToInsert.size() > 0) {
            insert listDiscountToInsert;
        }
    }
}