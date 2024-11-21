Public class discountSubmissionGateway 
{
    public static string DiscountSubmission() 
    {
        string ApplicationID = 'GES Connect';
        String ApplicationKey = '%{Q\\eGh4N-QDs!wx';
        string companyId;
        string languageId;
        /**
* Start App Session
**/if(Test.isRunningTest()) {
            Test.setMock(WebServiceMock.class, new DiscountWebServiceMock('DiscountSubmission'));
        }
        wwwViadComSecurityV2.BasicHttpBinding_IAuthenticationService s = new wwwViadComSecurityV2.BasicHttpBinding_IAuthenticationService();
        wwwViadComSecurityV2.AppSessionInfo a = s.StartAppSession(ApplicationID, ApplicationKey, companyId, languageId);
        String applicationSessionId = a.sessionID;
        String AppSessionID = a.sessionID;
        String Email= UserInfo.getUserEmail();  //curent user email 'ldrummond@ges.com';
        Boolean RetrieveSecurityGroups = true;
        /**
*User Login Without Password  
**/
        wwwViadComSecurityV2.BasicHttpBinding_IAuthenticationService req = new wwwViadComSecurityV2.BasicHttpBinding_IAuthenticationService();
        wwwViadComSecurityV2.AppSessionInfo userLogin = req.UserLoginWithoutPassword(AppSessionID, Email, RetrieveSecurityGroups);
        return a.sessionID;
    }
         
    public static void submitDiscount(String sessionID, Discount__c sfDiscount )
    {
        string AppSessionID = sessionId;
        wwwViadComV2.BoothAreaDiscount bd = new wwwViadComV2.BoothAreaDiscount();
        bd.ApplyToAllBoothAreas= Boolean.valueOf(sfDiscount.Apply_To_All__c);
        bd.Percentage= Decimal.valueOf(sfDiscount.Discount__c);
        bd.BoothAreaId= Integer.valueOf(sfDiscount.BoothAreaID__c);
        bd.LineOfBusiness =sfDiscount.LineOfBusiness__c;
        system.debug('Submit Value of checkbox is' + bd);
        wwwViadComV2.BasicHttpBinding_IShowOrganizerService submitReq = new wwwViadComV2.BasicHttpBinding_IShowOrganizerService();
        wwwViadComV2.BoothAreaDiscount b = submitReq.SubmitBoothAreaDiscount(AppSessionID, bd);
    }
    
    public static void updateDiscount(String sessionID, Discount__c sfDiscount )
    {
        string AppSessionID = sessionId;
        wwwViadComV2.BoothAreaDiscount bd = new wwwViadComV2.BoothAreaDiscount();
        bd.ApplyToAllBoothAreas= Boolean.valueOf(sfDiscount.Apply_To_All__c);
        system.debug('Value of checkbox is' + sfDiscount.Apply_To_All__c);
        bd.Percentage= Decimal.valueOf(sfDiscount.Discount__c);
        bd.BoothAreaId= Integer.valueOf(sfDiscount.BoothAreaID__c);
        bd.LineOfBusiness =sfDiscount.LineOfBusiness__c;
        bd.DiscountId =Integer.valueOf(sfDiscount.DiscountId__c);
        wwwViadComV2.BasicHttpBinding_IShowOrganizerService submitReq = new wwwViadComV2.BasicHttpBinding_IShowOrganizerService();
        wwwViadComV2.BoothAreaDiscount b = submitReq.UpdateBoothAreaDiscount(AppSessionID, bd);
    }
    
    public  static void deleteDiscount(string sessionId,Discount__c sfDiscount){
        string AppSessionID=sessionId;
        wwwViadComV2.BoothAreaDiscount bc1=new wwwViadComV2.BoothAreaDiscount();
        Integer discountID =Integer.ValueOf(sfDiscount.DiscountId__c);
        wwwViadComV2.BasicHttpBinding_IShowOrganizerService deleteDisc=new wwwViadComV2.BasicHttpBinding_IShowOrganizerService();
        wwwViadComV2.BoothAreaDiscount b =deleteDisc.DeleteBoothAreaDiscount(AppSessionID,discountID);
    }
    
    
  /*  public static set<String> showAllLOB(string sessionId,string Projectnumber){
        set<String> allLOB=new set<String>(); 
        string AppSessionID = sessionId;
        
// GetBoothareaDiscounts
        
        
        wwwViadComV2.BasicHttpBinding_IShowOrganizerService showRequest=new wwwViadComV2.BasicHttpBinding_IShowOrganizerService();
        wwwViadComV2.ShowProject s2=showRequest.GetProjectByProjectNumber(AppSessionID,projectNumber);
        wwwViadComV2.ArrayOfBoothArea BoothAreas =s2.BoothAreas;
        list<wwwViadComV2.BoothArea> boothInformation=new list<wwwViadComV2.BoothArea>();
        list<Booth_Area__c> boothList=new List<Booth_Area__c>();
        boothInformation=BoothAreas.BoothArea;
        
        for(wwwViadComV2.BoothArea c:boothInformation){
            
            wwwViadComV2.ArrayOfBoothAreaDiscount baDiscounts= c.Discounts;
            system.debug('ArrayOfBoothAreaDiscount baDiscount is' +baDiscounts);
            if(baDiscounts != null){
                list<wwwViadComV2.BoothAreaDiscount> discountInfo=new list<wwwViadComV2.BoothAreaDiscount>();
                discountInfo= baDiscounts.BoothAreaDiscount;
                system.debug('discountInfo is' +discountInfo);
                for(wwwViadComV2.BoothAreaDiscount disc: discountInfo)
                {
                    allLOB.add(disc.LineOfBusiness);
                }
            }  
        }
        system.debug('all lob is' +allLOB);
        
        return allLOB;
    }*/
}