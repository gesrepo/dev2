public class DiscountController
{
    
    public Discount__c varDiscount{get; set;}
    public string boothId{get;set;}
    public string showId{get;set;}
    public string discountId{get;set;}
    public string  sessionId{get;set;}
    public List<Discount__c> finalDiscount{get; set;}
    public List<SelectOption> LOBoptions {get;set;}
    
    
    public DiscountController(ApexPages.standardController stdController){
        
        boothId = ApexPages.currentPage().getParameters().get('Id'); 
        discountId= ApexPages.currentPage().getParameters().get('discountId');
        sessionId = TestBoothAreaSubmission.SessionLogin();
        
        varDiscount = new Discount__c();
        finalDiscount = new List<Discount__c> ();
        LOBoptions = new List<SelectOption>();
        String jobNo=null;
        
        if(boothId!=NULL && discountId==NULL)
            
        {
            Booth_Area__c parentBooth=[select id,BoothID_Area__c,  Connect2_Show__c, Connect2_Show__r.Job_Number__c from Booth_Area__c where id= :boothId Limit 1];
            
            varDiscount.Booth_Area__c =parentBooth.Id;
            varDiscount.BoothAreaID__c= parentBooth.BoothID_Area__c;
            showId= parentBooth.Connect2_Show__c;
            system.debug(showId+'-------------showId');
            //varDiscount.LineOfBusiness__c=dc.LineOfBusiness__c;
            /*string sessionId=discountSubmissionGateway.SessionLogin();
            set <String> tempLOB=discountSubmissionGateway.showAllLOB(sessionId,parentBooth.Connect2_Show__r.Job_Number__c);
            system.debug('fetched LOB are' +tempLOB);
            for(String LOB:tempLOB){
            LOBoptions.add(new SelectOption(String.valueOf(LOB),String.valueOf(LOB)));
                }
            system.debug(varDiscount);  */
            
            if(varDiscount.Apply_To_All__c ==TRUE)
            {
                List<Booth_Area__c> associatedBooths =[select id, BoothID_Area__c,  Connect2_Show__c from Booth_Area__c where Connect2_Show__c= :showId ];
                Discount__c discount = new Discount__c ();
                for (Booth_Area__c booth: associatedBooths){
                    discount.Booth_Area__c =booth.Id;
                    discount.BoothAreaID__c= booth.BoothID_Area__c;
                    discount.Discount__c= varDiscount.Discount__c;
                    finalDiscount.add(discount);
                }
            }
            
            else
                finalDiscount.add(varDiscount);
            
            
        }
        
        if(boothId!=NULL && discountId!=NULL)
            
        {
            Discount__c dc= [select id, name, Apply_To_All__c, Booth_Area__c,Booth_Area__r.BoothID_Area__c, Booth_Area__r.Connect2_Show__c, Discount__c, DiscountId__c, LineOfBusiness__c from Discount__c where id= :discountId];
            varDiscount.Booth_Area__c= boothId;
            varDiscount.BoothAreaID__c= dc.Booth_Area__r.BoothID_Area__c;
            Booth_Area__c parentBooth=[select id,BoothID_Area__c,  Connect2_Show__c, Connect2_Show__r.Job_Number__c from Booth_Area__c where id= :boothId Limit 1];
            varDiscount.LineOfBusiness__c=dc.LineOfBusiness__c;
            varDiscount.Apply_To_All__c= dc.Apply_To_All__c;
            varDiscount.Discount__c= dc.Discount__c;
            varDiscount.DiscountId__c= dc.DiscountId__c;
            showId= dc.Booth_Area__r.Connect2_Show__c;
            system.debug('showId==='+showId);
            /* string sessionId=discountSubmissionGateway.SessionLogin();
set <String> tempLOB=discountSubmissionGateway.showAllLOB(sessionId,parentBooth.Connect2_Show__r.Job_Number__c);
system.debug('fetched LOB are' +tempLOB);
for(String LOB:tempLOB){
LOBoptions.add(new SelectOption(String.valueOf(LOB),String.valueOf(LOB)));
} */
            
            if(varDiscount.Apply_To_All__c ==TRUE)
            {
                List<Booth_Area__c> associatedBooths =[select id, BoothID_Area__c,  Connect2_Show__c from Booth_Area__c where Connect2_Show__c= :showId ];
                Discount__c discount = new Discount__c ();
                for (Booth_Area__c booth: associatedBooths){
                    discount.Booth_Area__c =booth.Id;
                    discount.BoothAreaID__c= booth.BoothID_Area__c;
                    finalDiscount.add(discount);
                }
            }
            else
                finalDiscount.add(varDiscount);
            
        }
    }
    
    public pageReference discountSubmission(){
  
        for(Discount__c disc:finalDiscount)
        {
            if(disc!=NULL){
                
                discountSubmissionGateway.submitDiscount(sessionId,disc);
            }
        }
        RefreshBoothArea.refreshMethod(showId);
        Pagereference pr=new Pagereference('/'+showId);
        pr.setredirect(true);
        return pr;
        
    }
    
    
    public pageReference discountUpdate(){ 
        //string sessionId = TestBoothAreaSubmission.SessionLogin();
        for(Discount__c disc: finalDiscount)
        {   
            if (disc!=NULL && varDiscount.Apply_To_All__c==TRUE){
                if(Test.isRunningTest()) {
                    Test.setMock(WebServiceMock.class, new DiscountWebServiceMock('SubmitDiscount'));
                }
                discountSubmissionGateway.submitDiscount(sessionId,disc);
            }
            else if(disc!=NULL && varDiscount.Apply_To_All__c ==FALSE){
                if(Test.isRunningTest()) {
                    Test.setMock(WebServiceMock.class, new DiscountWebServiceMock('UpdateDiscount'));
                }
                discountSubmissionGateway.updateDiscount(sessionId,disc);
            }
        }
        
        RefreshBoothArea.refreshMethod(showId);
        Pagereference pr=new Pagereference('/'+showId);
        pr.setredirect(true);
        return pr;
    }
    
    public pageReference discountDelete(){ 
        //string sessionId=TestBoothAreaSubmission.SessionLogin();
        if(varDiscount!=NULL){
            
            discountSubmissionGateway.deleteDiscount(sessionId,varDiscount);
        }
        RefreshBoothArea.refreshMethod(showId);
        Pagereference pr=new Pagereference('/'+showId);
        pr.setredirect(true);
        return pr;
        
    }   
    
    
    
}