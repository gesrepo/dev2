public with Sharing class PC_BoothAreaDiscountController {
    
    public String DiscountRecordID{get; set;}
    public String returnToUrl{get; set;}
    
    public PC_BoothAreaDiscountController(ApexPages.StandardController StandardSetController){
        DiscountRecordID=apexpages.currentpage().getparameters().get('id');
        Discount__c disc=[select id,DiscountId__c, Booth_Area__c from Discount__c where id= :DiscountRecordID];
        if(UserInfo.getUiThemeDisplayed() == 'Theme3'){
            returnToUrl=System.Label.GC_Label_ClassicSFDC+'GC_Connect2ShowView?id='+disc.Booth_Area__c;
        }else if(UserInfo.getUiThemeDisplayed() == 'Theme4d'){
            returnToUrl= System.Label.PC_Label_Lightning+'/r/Booth_Area__c/'+disc.Booth_Area__c+'/view';
        }else{
            returnToUrl='https://ges--lightning.cs17.my.salesforce.com/home/home.jsp';
        }
    }
    
    //START-methods to get the sessionID and then login to Core
    @AuraEnabled
    public static void getCoreSessionID(){
        PC_BoothAreaController.getCoreSessionID();
    }
    
    @AuraEnabled
    public static string performLoginToCore(){
        return PC_BoothAreaController.performLoginToCore();
    }
    //END- methods to get the sessionID and then login to Core
    
    
    //START- method to be called when the discount is saved
    @AuraEnabled
    public static string discountSubmission(string boothId, string discountId,Boolean applyToAll,string discountValue,string lineOfBusiness, String sessionId){
        List<Discount__c> discountsTobeUpserted= new List<Discount__c>();
        try{    
            List<Booth_Area__c> parentBooth=[SELECT id,BoothID_Area__c,  Connect2_Show__c, Connect2_Show__r.Job_Number__c FROM Booth_Area__c WHERE id= :boothId];
            wwwViadComV2.BoothAreaDiscount webSvcDiscount = new wwwViadComV2.BoothAreaDiscount();
            webSvcDiscount.ApplyToAllBoothAreas= applyToAll;
            webSvcDiscount.Percentage= Decimal.valueOf(discountValue);
            webSvcDiscount.BoothAreaId= Integer.valueOf(parentBooth[0].BoothID_Area__c);
            webSvcDiscount.LineOfBusiness =lineOfBusiness;
            wwwViadComV2.BasicHttpBinding_IShowOrganizerService submitReq = new wwwViadComV2.BasicHttpBinding_IShowOrganizerService();
            wwwViadComV2.BoothAreaDiscount resultingWebSvcDiscount;
            if(string.isNotBlank(discountId)){
                List<Discount__c>existingDiscount=[SELECT id, name, DiscountId__c,Apply_To_All__c FROM Discount__c WHERE id=:discountId];
                webSvcDiscount.DiscountId =Integer.valueOf(existingDiscount[0].DiscountId__c);
                resultingWebSvcDiscount=submitReq.UpdateBoothAreaDiscount(sessionId, webSvcDiscount);
            }else {
                resultingWebSvcDiscount = submitReq.SubmitBoothAreaDiscount(sessionId, webSvcDiscount);
            }
            Discount__c tempLocalDiscount=PC_BoothAreaController.convertWebSvcDiscounttoLocal(resultingWebSvcDiscount,parentBooth[0].id);
            if(string.isNotBlank(discountId)){
                tempLocalDiscount.id= discountId;
            }
            tempLocalDiscount.Apply_To_All__c=applyToAll;
            discountsTobeUpserted.add(tempLocalDiscount);
            if(applyToAll){
                List<Booth_Area__c> allBoothAreasOfShow =[SELECT id, BoothID_Area__c,  Connect2_Show__c FROM Booth_Area__c WHERE Connect2_Show__c= :parentBooth[0].Connect2_Show__c];
                for(Booth_Area__c singleBoothArea:allBoothAreasOfShow){
                    if(singleBoothArea.Id!=tempLocalDiscount.Booth_Area__c){
                        Discount__c singleDiscount = new Discount__c ();
                        singleDiscount.Booth_Area__c = singleBoothArea.Id;
                        singleDiscount.BoothAreaID__c= singleBoothArea.BoothID_Area__c;
                        singleDiscount.Discount__c= discountValue;
                        singleDiscount.LineOfBusiness__c=lineOfBusiness;
                        discountsTobeUpserted.add(singleDiscount);
                    }
                }
            }
            if(!Test.isRunningTest()){
                if(discountsTobeUpserted.size()>0){
                    upsert discountsTobeUpserted;
               
                } 
            }
        }catch(exception e){
            //PC_BoothAreaController.asyncLoginToCore();
            system.debug('error at==='+e.getStackTraceString()+ e.getMessage());
            throw new AuraHandledException('Error Applying Discount'+ e.getMessage()); 
        }
        return discountsTobeUpserted[0].id;
    }
    
    @AuraEnabled
    public static void deleteRecordsFromCore(string discRecordId){
        string sessionId =performLoginToCore();
        try{
            
            wwwViadComV2.BasicHttpBinding_IShowOrganizerService submitReq = new wwwViadComV2.BasicHttpBinding_IShowOrganizerService();
            wwwViadComV2.BoothAreaDiscount webSvcDiscount = new wwwViadComV2.BoothAreaDiscount();
            
            if(string.isNotBlank(discRecordId)){
                Discount__c localDiscount=[select id,DiscountId__c from Discount__c where id= :discRecordId ];
                Integer discIdToBeDeletedInCore =Integer.valueOf(localDiscount.DiscountId__c);
                wwwViadComV2.BoothAreaDiscount resultingWebSvcDiscount= submitReq.DeleteBoothAreaDiscount(sessionId,discIdToBeDeletedInCore );
                if(!Test.isRunningTest()){
                    if(resultingWebSvcDiscount!=null){
                        delete localDiscount;
                    }
                }
            }
        }catch(exception e){
            system.debug('error at=='+e.getStackTraceString()+ e.getMessage());
            throw new AuraHandledException('Error Deleting Discount-'+e.getMessage());
        }
    }  
    @auraEnabled
    public static string getBoothIdForDiscount(string discId, string boothId){
        Discount__c booth = new Discount__c();
        try{            
            booth =[SELECT Id, Booth_Area__c from Discount__c where Id =:discId OR Booth_Area__c = :boothId LIMIT 1];
        }
        catch(Exception e){
            throw new AuraHandledException('Error Retrieving Discount-'+e.getMessage());
        }
        return booth.Booth_Area__c;
    }
}