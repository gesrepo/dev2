public class CongressSummaryReport
{   
    public string congid{get;set;} 
    public GES_Connect_Corporate_Accounts__c geslst{get;set;} 
    public List<exhibitListWrapper> dispWrapper{get;set;}
    public List<sponListWrapper> sponWrapper{get;set;}
    public List<prodtrListWrapper> prdtrWrapper{get;set;}
    public List<sypmListWrapper> syWrapper{get;set;}
    public List<mtrmListWrapper> MtrmWrapper{get;set;}
    public List<AggregateResult> sumbrand{get;set;}
    public List<summaryExhibit> sumExhibitList{get;set;}   
    public CongressSummaryReport(ApexPages.StandardController controller)
    {
        dispWrapper = new List<exhibitListWrapper>();
        sponWrapper= new List<sponListWrapper>();
        prdtrWrapper= new List<prodtrListWrapper>();
        syWrapper= new List<sypmListWrapper>();
        MtrmWrapper= new List<mtrmListWrapper>();
        sumExhibitList=new List<summaryExhibit>();
        
        congid =System.currentPageReference().getParameters().get('id');         
        geslst=[Select id,Name_of_Congress__c,Congress_Website__c, Acronym_of_Congress__c,Exhibit_Close_Date__c,Exhibit_Open_Date__c,Congress_Start_Date__c,Congress_End_Date__c,Facility_Name__c,Shipping_Street__c,Shipping_City__c,Shipping_State_Province__c,Shipping_Zip_Postal_Code__c,Shipping_Country__c,Exhibit_Date_Day1__c,Exhibit_Hours_Open_Day_1__c,Exhibit_Hours_Close_Day_1__c,Exhibit_Date_Day_2__c,Exhibit_Hours_Open_Day_2__c,Exhibit_Hours_Close_Day_2__c,Exhibit_Date_Day_3__c,Exhibit_Hours_Open_Day_3__c,Exhibit_Hours_Close_Day_3__c,Exhibit_Date_Day_4__c,Exhibit_Hours_Open_Day_4__c,Exhibit_Hours_Close_Day_4__c,Housing_Opens__c,Housing_Deadline__c,Number_of_rooms_to_Secure__c,Number_of_rooms_Secured__c,Hotel_1_Name__c,Hotel_1_cancellation_date__c,Hotel_1_cancellation_policy__c,Hotel_1_room_rate__c,Hotel_2_Name__c,Hotel_2_cancellation_date__c,Hotel_2_cancellation_policy__c,Hotel_2_room_rate__c,Hotel_3_Name__c,Hotel_3_cancellation_date__c,Hotel_3_cancellation_policy__c,Hotel_3_room_rate__c from GES_Connect_Corporate_Accounts__c where id=:congid ];
       dispWrapper = new List<exhibitListWrapper>();
        List<Exhibit__c> exhibitList = [Select Name,Exhibit_Name__c,Booth_Length__c,Booth_Width__c,Booth_Number__c,Canceled__c,(select Name,Brand_Name__c,Booth_Space_Cost_Actual__c,Booth_Space_Cost_Estimated__c,Exhibit_Costs_Actual__c,
                                       Exhibit_Costs_Estimated__c from Brand_Instance__r) from Exhibit__c where Activity_Type_Exhibit_Instance_c__c=:congid];
        if(exhibitList.size()>0)
        {
            String Brand= '';
            String BrandName= '';           
            
            for(Exhibit__c ex: exhibitList)
            {
                  if(ex.Brand_Instance__r.size() > 0)
                {                
                    for(Brand__c br:ex.Brand_Instance__r)
                    {                        
                        Brand+= br.Name+',';
                        BrandName+= br.Brand_Name__c+',';                        
                        
                    }
                 }                
                Brand= Brand.replace('null',''); 
                BrandName= BrandName.replace('null',''); 
                Brand=Brand.removeEnd(',');
                BrandName= BrandName.removeEnd(',');
                dispWrapper.Add(new exhibitListWrapper(ex.Name,
                                                       ex.Exhibit_Name__c,                                                      
                                                       ex.Booth_Length__c,
                                                       ex.Booth_Width__c,
                                                       ex.Booth_Number__c,
                                                       ex.Canceled__c,
                                                       BrandName));                                                 
            Brand= '';
            BrandName= '';
            
            }
            system.debug('dispWrapperList++++'+dispWrapper);
        }
         List<Sponsorship__c> sponList=[select Name,Sponsorship_Name__c,Canceled__c,(select Name,Brand_Name__c,Sponsorship_Costs_Actual__c,Sponsorship_Costs_Estimated__c from Brand__r) from Sponsorship__c where Sponsorship__c=:congid];
        system.debug('sponList++++'+sponList);
        system.debug('sponList.size()++++'+sponList.size());
       
        if(sponList.size()>0)
        {            
            String BrandspName= '';
            
            for(Sponsorship__c sp: sponList)
            {
                  if(sp.Brand__r.size() > 0)
                {
                    for(Brand__c bd:sp.Brand__r)
                    {
                        BrandspName+= bd.Brand_Name__c+',';                        
                               }
                    
                }                
                  
                 BrandspName= BrandspName.replace('null','');  
           
                BrandspName=BrandspName.removeEnd(',');
               
                sponWrapper.Add(new sponListWrapper(sp.Name,sp.Sponsorship_Name__c,sp.Canceled__c,BrandspName));        
            BrandspName= '';
                      
            }
            system.debug('dispWrapperList++++'+sponWrapper);
        }
        List<Product_Theater__c> prdtrList=[Select Name,Product_Theater_Name__c,Product_Theater_Time__c,Product_Theater_Location__c,Canceled__c,(select Name,Brand_Name__c,Product_Theater_Costs_Actual__c,Product_Theater_Costs_Estimated__c from Brand__r) from Product_Theater__c where Congress__c=:congid];
        system.debug('sponList++++'+sponList);
        system.debug('sponList.size()++++'+sponList.size());
       
        if(prdtrList.size()>0)
        {            
            String BrandpdName= '';
            for(Product_Theater__c pd: prdtrList)
            {
                  if(pd.Brand__r.size() > 0)
                {
                    for(Brand__c bnd : pd.Brand__r)
                    {
                        BrandpdName+= bnd.Brand_Name__c+',';                        
                    }
                    
                }                
              
                BrandpdName= BrandpdName.replace('null','');                   
              BrandpdName=BrandpdName.removeEnd(',');
               prdtrWrapper.Add(new prodtrListWrapper(pd.Name,pd.Product_Theater_Name__c,pd.Product_Theater_Time__c,pd.Product_Theater_Location__c,pd.Canceled__c,BrandpdName));        
            BrandpdName= '';
                       
            }
            system.debug('prdtrWrapperList++++'+prdtrWrapper);
        }
         List<Symposia__c> symList=[Select Name,Symposia_Name__c,Symposium_Time__c,Symposium_Location__c,Canceled__c, (select Name,Brand_Name__c,Symposia_Actual_Cost__c,Symposia_Estimated_Cost__c from Brand__r) from Symposia__c where Congress__c=:congid];
        system.debug('symList++++'+symList);
        system.debug('symList.size()++++'+symList.size());
       
        if(symList.size()>0)
        {            
            String BrandsyName= '';
            for(Symposia__c sy: symList)
            {
                  if(sy.Brand__r.size() > 0)
                {
                    for(Brand__c bnds : sy.Brand__r)
                    {
                        BrandsyName+= bnds .Brand_Name__c+',';                        
                            }
                   
                }                
               
                BrandsyName= BrandsyName.replace('null','');                   
                BrandsyName=BrandsyName.removeEnd(',');
                syWrapper.Add(new sypmListWrapper(sy.Name,sy.Symposia_Name__c,sy.Symposium_Time__c,sy.Symposium_Location__c,sy.Canceled__c,BrandsyName));        
            BrandsyName= '';
                      
            }
            system.debug('syWrapper++++'+syWrapper);
        }
        List<Meeting_Room__c> mtrmList=[Select Name,Meeting_Room_Name__c,Meeting_Room_Time__c,Meeting_Room_Number__c,Canceled__c,(select Name,Brand_Name__c from Brand__r) from Meeting_Room__c where Congress__c=:congid];
        system.debug('mtrmList++++'+mtrmList);
        system.debug('mtrmList.size()++++'+mtrmList.size());
       
        if(mtrmList.size()>0)
        {            
            String BrandmtrmName= '';
            for(Meeting_Room__c mtrm: mtrmList)
            {
                  if(mtrm.Brand__r.size() > 0)
                {
                    for(Brand__c bndst : mtrm.Brand__r)
                    {
                        BrandmtrmName+= bndst .Brand_Name__c+',';                        
                    }
                    
                }               
               
                BrandmtrmName= BrandmtrmName.replace('null','');                   
               
                 BrandmtrmName=BrandmtrmName.removeEnd(',');
                                                      
                MtrmWrapper.Add(new mtrmListWrapper(mtrm.Name,mtrm.Meeting_Room_Name__c,mtrm.Meeting_Room_Time__c,mtrm.Meeting_Room_Number__c,mtrm.Canceled__c,BrandmtrmName));        
            BrandmtrmName= '';
                        
            }
            system.debug('MtrmWrapper++++'+MtrmWrapper);
        }
    } 
    public PageReference back() 
   {
        return page.ReportsList;
        
    }  
    public PageReference save() 
   {
        return page.CongressSummaryReportExcelDownload;        
   } 
   public class exhibitListWrapper {
        public String ExhibitId{get; set;}
        public String ExhibitName{get; set;}
        public String Brand{get; set;}
       public boolean Cancelled{get; set;}
        public String BoothNumber{get; set;}
        public Decimal Boothlength{get; set;}
        public Decimal BoothWidth{get; set;}
        
        public exhibitListWrapper (String ExhibitId,String ExhibitName,Decimal Boothlength,Decimal BoothWidth,String BoothNumber,boolean Cancelled,String Brand) 
        {
            this.ExhibitId= ExhibitId;
            this.ExhibitName= ExhibitName;
            this.BoothNumber= BoothNumber;
            this.Brand= Brand;
            this.Boothlength=Boothlength;
            this.BoothWidth=BoothWidth;
            this.cancelled= cancelled;
            
        }
    }
    public class sponListWrapper{
        public string SponId{get;set;}
        public string SponName{get;set;}
        public string BrandName{get;set;}
        public Boolean cancelled{get; set;}
        public sponListWrapper(string SponId,string SponName,Boolean cancelled,string BrandName){
            this.SponId= SponId;
            this.SponName= SponName;
            this.BrandName= BrandName;
            this.cancelled= cancelled;
                    
        }
    }
    public class prodtrListWrapper{
        public string PrdtrId{get;set;}
        public string PrdtrName{get;set;}
        public string BrandName{get;set;}
        public string ProductTheaterLocation {get;set;}
        public Datetime ProductTheaterDateandTime{get;set;}
        public Boolean cancelled{get; set;}
        public prodtrListWrapper(string PrdtrId,string PrdtrName,Datetime ProductTheaterDateandTime,string ProductTheaterLocation,Boolean cancelled,string BrandName){
            this.PrdtrId= PrdtrId;
            this.PrdtrName= PrdtrName;
            this.BrandName= BrandName;
            this.ProductTheaterDateandTime= ProductTheaterDateandTime;
            this.ProductTheaterLocation= ProductTheaterLocation;
            this.cancelled= cancelled;
                        
        }
    }
    public class sypmListWrapper{
        public string SypmId{get;set;}
        public string SypmName{get;set;}
        public string BrandName{get;set;}
        public datetime SymposiaDateandTime{get;set;}
        public string SymposiaLocation{get;set;}
        public Boolean cancelled{get; set;}
        public sypmListWrapper(string SypmId,string SypmName,datetime SymposiaDateandTime,string SymposiaLocation,Boolean cancelled,string BrandName){
            this.SypmId= SypmId;
            this.SypmName= SypmName;
            this.BrandName= BrandName;
            this.SymposiaDateandTime= SymposiaDateandTime;
            this.SymposiaLocation= SymposiaLocation;
            this.cancelled= cancelled;
                       
        }
    }
    public class mtrmListWrapper{
        public string MtrmId{get;set;}
        public string MtrmName{get;set;}
        public string BrandName{get;set;}
        public datetime MeetingRoomDateandTime{get;set;}
        public string MeetingRoomNumber{get;set;}
        public Boolean cancelled{get; set;}
        
        public mtrmListWrapper(string MtrmId,string MtrmName,datetime MeetingRoomDateandTime,string MeetingRoomNumber,Boolean cancelled,string BrandName){
            this.MtrmId= MtrmId;
            this.MtrmName= MtrmName;
            this.BrandName= BrandName;
            this.MeetingRoomNumber= MeetingRoomNumber;
            this.MeetingRoomDateandTime= MeetingRoomDateandTime;
            this.cancelled= cancelled;
                       
        }
    }
     public class summaryExhibit
    {
        public Double  BoothEstCost{get;set;}
        public Double  BoothActCost{get;set;}
        public Double ExhibitEstCost{get;set;}
        public Double ExhibitActCost{get;set;}
        public Double  SponEstCost{get;set;}
        public Double  SponActCost{get;set;}
        public Double  PrdEstCost{get;set;}
        public Double  PrdActCost{get;set;}
        public Double  symEstCost{get;set;}
        public Double  symActCost{get;set;}
        public Double  MtrmEstCost{get;set;}
        public Double  MtrmActCost{get;set;}
        public summaryExhibit(AggregateResult ar)
        {
            BoothEstCost= (Double)ar.get('boothestimated');
            BoothActCost= (Double)ar.get('boothactual');
            ExhibitEstCost= (Double)ar.get('exhibitEstimate');
            ExhibitActCost=(Double)ar.get('exhibitactual');
            SponEstCost=(Double)ar.get('sponestcost');
            SponActCost=(Double)ar.get('sponactcost');
            PrdEstCost= (Double)ar.get('prdest');
            PrdActCost= (Double)ar.get('prdact'); 
            symEstCost= (Double)ar.get('syest');
            symActCost= (Double)ar.get('syact'); 
            MtrmEstCost= (Double)ar.get('metest');
            MtrmActCost= (Double)ar.get('mtact'); 
        }
    }
     public list<summaryExhibit> getResults(){
        list<summaryExhibit> lstResult = new list<summaryExhibit>();
        for(AggregateResult ar : sumbrand){
            summaryExhibit objwc = new summaryExhibit(ar);
            lstResult.add(objwc);
        }
        return lstResult;
    }   
}