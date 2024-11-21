public class CongressFinancialSummaryReport
{   
    public string congid{get;set;} 
    public String currSymbol{get;set;}
    public Boolean sameCurrency{get;set;}
    public Boolean isSameCurrency{get;set;}
    
    public Decimal totalBoothSpaceEstimatedCost{get;set;}
    public Decimal totalExhibitEstimatedCost{get;set;}
    public Decimal totalBoothSpaceActualCost{get;set;}
    public Decimal totalExhibitActualCost{get;set;}
    public Decimal totalSponsorshipEstimatedCost{get;set;} 
    public Decimal totalSponsorshipActualCost{get;set;}
    public Decimal totalProductTheaterEstimatedCost{get;set;}
    public Decimal totalProductTheaterActualCost{get;set;}
    public Decimal totalSymposiaEstimatedCost{get;set;} 
    public Decimal totalSymposiaActualCost{get;set;}
    public Decimal totalMeetingRoomEstimatedCost{get;set;} 
    public Decimal totalMeetingRoomActualCost{get;set;}  
    public Decimal totalMeetingRoomServiceEstimatedCost{get;set;} 
    public Decimal totalMeetingRoomServiceActualCost{get;set;} 
    
    public Decimal totalEstimatedCost{get;set;} 
    public Decimal totalActualCost{get;set;}   
    
    
    
    public GES_Connect_Corporate_Accounts__c geslst{get;set;} 
    public List<exhibitListWrapper> dispWrapper{get;set;}
    public List<sponListWrapper> sponWrapper{get;set;}
    public List<prodtrListWrapper> prdtrWrapper{get;set;}
    public List<sypmListWrapper> syWrapper{get;set;}
    public List<mtrmListWrapper> MtrmWrapper{get;set;}
    public List<AggregateResult> sumbrand{get;set;}
    public List<summaryExhibit> sumExhibitList{get;set;}   
    public CongressFinancialSummaryReport(ApexPages.StandardController controller){
        
        sameCurrency = false;
        isSameCurrency = true;
        
        totalBoothSpaceEstimatedCost = 0.00;
        totalExhibitEstimatedCost = 0.00;
        totalBoothSpaceActualCost = 0.00;
        totalExhibitActualCost = 0.00;
        totalSponsorshipEstimatedCost = 0.00;
        totalSponsorshipActualCost = 0.00;
        totalProductTheaterEstimatedCost = 0.00;
        totalProductTheaterActualCost = 0.00;
        totalSymposiaEstimatedCost = 0.00;
        totalSymposiaActualCost = 0.00;
        totalMeetingRoomEstimatedCost = 0.00;
        totalMeetingRoomActualCost = 0.00;
        totalMeetingRoomServiceEstimatedCost = 0.00;
        totalMeetingRoomServiceActualCost = 0.00;
        
        totalEstimatedCost = 0.00;
        totalActualCost = 0.00;
        
        dispWrapper = new List<exhibitListWrapper>();
        sponWrapper= new List<sponListWrapper>();
        prdtrWrapper= new List<prodtrListWrapper>();
        syWrapper= new List<sypmListWrapper>();
        MtrmWrapper= new List<mtrmListWrapper>();
        sumExhibitList=new List<summaryExhibit>();
        
        congid =System.currentPageReference().getParameters().get('id');         
        geslst=[Select id,Name_of_Congress__c,CurrencyIsoCode,Congress_Website__c, Exhibit_Close_Date__c,Exhibit_Open_Date__c from GES_Connect_Corporate_Accounts__c where Congress_Cancelled__c = False AND id=:congid ];
        
        for(Brand__c brand : [SELECT Id,Name,CurrencyIsoCode FROM Brand__c WHERE Canceled__c = False AND GES_Connect_Corporate_Accounts__c =:congid]){
            system.debug('------------------------>>>>>>>>>>>'+geslst.CurrencyIsoCode);
            system.debug(brand.CurrencyIsoCode);
            if(geslst.CurrencyIsoCode == brand.CurrencyIsoCode && isSameCurrency == true){
                sameCurrency = true;
            }
            else{
                sameCurrency = false;
                isSameCurrency = false;
            }
            system.debug('------->>>>>' + sameCurrency);
        }
        
        system.debug('------->>>>>' + sameCurrency);
        if(sameCurrency == true){
            if(geslst.CurrencyIsoCode=='GBP'){
                currSymbol='£';
            }
            else if(geslst.CurrencyIsoCode=='CAD'){
                currSymbol='C$';
            }else if(geslst.CurrencyIsoCode=='EUR'){
                currSymbol='€';
            }else if(geslst.CurrencyIsoCode=='HKD'){
                currSymbol='HK$';
            }else if(geslst.CurrencyIsoCode=='SGD'){
                currSymbol='S$';
            }else if(geslst.CurrencyIsoCode=='CHF'){
                currSymbol='SFr';
            }else if(geslst.CurrencyIsoCode=='AED'){
                currSymbol='AED';
            }
            else if(geslst.CurrencyIsoCode=='JPY'){
                currSymbol='JPY';
            }
            else if(geslst.CurrencyIsoCode=='DKK'){
                currSymbol='DKK';
            }else{
                currSymbol='$';
            }
        }
        else{
            currSymbol='$';
        }
        
        dispWrapper = new List<exhibitListWrapper>();
        List<Exhibit__c> exhibitList = new List<Exhibit__c>();
        
        if(sameCurrency == false){
            system.Debug('??? inside exhibit' + samecurrency);
            exhibitList = [Select Name,Exhibit_Name__c,(select Name,Brand_Name__c,convertCurrency(Booth_Space_Cost_Actual__c),convertCurrency(Booth_Space_Cost_Estimated__c),convertCurrency(Exhibit_Costs_Actual__c),
                                                        convertCurrency(Exhibit_Costs_Estimated__c) from Brand_Instance__r WHERE Canceled__c = False) from Exhibit__c where Canceled__c = False AND Activity_Type_Exhibit_Instance_c__c=:congid];
        }
        else{
            exhibitList = [Select Name,Exhibit_Name__c,(select Name,Brand_Name__c,Booth_Space_Cost_Actual__c,Booth_Space_Cost_Estimated__c,Exhibit_Costs_Actual__c,
                                                        Exhibit_Costs_Estimated__c from Brand_Instance__r WHERE Canceled__c = False) from Exhibit__c where Canceled__c = False AND Activity_Type_Exhibit_Instance_c__c=:congid];
        }
        system.debug('exhibitList++++'+exhibitList);
        system.debug('exhibitList.size()++++'+exhibitList.size());
        
        sumbrand=[select Sum(Booth_Space_Cost_Actual__c)boothactual,sum(Booth_Space_Cost_Estimated__c)boothestimated,
                  Sum(Exhibit_Costs_Actual__c)exhibitactual,sum(Exhibit_Costs_Estimated__c)exhibitEstimate,
                  sum(Sponsorship_Costs_Estimated__c)sponestcost,sum(Sponsorship_Costs_Actual__c)sponactcost,
                  sum(Product_Theater_Costs_Estimated__c)prdest,sum(Product_Theater_Costs_Actual__c)prdact,
                  sum(Symposia_Estimated_Cost__c)syest,sum(Symposia_Actual_Cost__c)syact,sum(Meeting_Room_Estimated_Cost__c)metest,
                  sum(Meeting_Room_Actual_Cost__c)mtact,sum(MR_Services_Estimated_Costs__c)metSerest,
                  sum(MR_Services_Actual_Costs__c)mtSeract from Brand__c where Canceled__c = False AND GES_Connect_Corporate_Accounts__c=:congid];
        //system.debug('Aggregate Result List'+sumbrand);
        
        if(exhibitList.size()>0){
            String Brand= '';
            String BrandName= '';
            decimal BotspActualCost= 0.00;
            Decimal BotspEstimatedCost= 0.00;
            Decimal ExEstimatedCost= 0.00;
            Decimal ExActualCost= 0.00;
            for(Exhibit__c ex: exhibitList)
            {
                if(ex.Brand_Instance__r.size() > 0)
                {
                    for(Brand__c br:ex.Brand_Instance__r)
                    {
                        Brand+= br.Name+',';
                        BrandName+= br.Brand_Name__c+',';                        
                        BotspEstimatedCost += (br.Booth_Space_Cost_Estimated__c!= null ? br.Booth_Space_Cost_Estimated__c: 0);
                        BotspActualCost += (br.Booth_Space_Cost_Actual__c!= null ? br.Booth_Space_Cost_Actual__c: 0);
                        ExEstimatedCost += (br.Exhibit_Costs_Estimated__c != null ? br.Exhibit_Costs_Estimated__c : 0);
                        ExActualCost += (br.Exhibit_Costs_Actual__c!= null ? br.Exhibit_Costs_Actual__c: 0); 
                    }
                    totalBoothSpaceEstimatedCost += BotspEstimatedCost;
                    totalExhibitEstimatedCost += ExEstimatedCost;
                    totalBoothSpaceActualCost += BotspActualCost;
                    totalExhibitActualCost += ExActualCost;
                    
                    system.debug('List of Data'+Brand+'+++++'+BrandName+'+++++'+BotspActualCost+'+++++'+BotspEstimatedCost+'+++++'+ExEstimatedCost+'+++++'+ExActualCost);
                }                
                Brand= Brand.replace('null',''); 
                BrandName= BrandName.replace('null',''); 
                /* BotspActualCost= BotspActualCost.replace('null','0'); 
BotspEstimatedCost= BotspEstimatedCost.replace('null','0'); 
ExEstimatedCost= ExEstimatedCost.replace('null','0');            
ExActualCost= ExActualCost.replace('null','0'); */
                Brand=Brand.removeEnd(',');
                BrandName= BrandName.removeEnd(',');
                /* BotspActualCost= BotspActualCost.removeEnd(',');
BotspEstimatedCost= BotspEstimatedCost.removeEnd(',');
ExEstimatedCost= ExEstimatedCost.removeEnd(',');
ExActualCost= ExActualCost.removeEnd(',');      */
                system.debug('List of Data'+Brand+'+++++'+BrandName+'+++++'+BotspActualCost+'+++++'+BotspEstimatedCost+'+++++'+ExEstimatedCost+'+++++'+ExActualCost);        
                dispWrapper.Add(new exhibitListWrapper(ex.Name,
                                                       ex.Exhibit_Name__c,                                                      
                                                       BrandName,
                                                       BotspEstimatedCost,
                                                       BotspActualCost,
                                                       ExEstimatedCost,
                                                       ExActualCost));                                                 
                Brand= '';
                BrandName= '';
                BotspActualCost= 0.00;
                BotspEstimatedCost= 0.00;
                ExEstimatedCost= 0.00;
                ExActualCost= 0.00;
            }
            totalEstimatedCost = totalEstimatedCost + totalBoothSpaceEstimatedCost + totalExhibitEstimatedCost ;
            totalActualCost = totalActualCost + totalBoothSpaceActualCost + totalExhibitActualCost;
            system.debug('dispWrapperList++++'+dispWrapper);
        }
        List<Sponsorship__c> sponList = new List<Sponsorship__c>();
        
        if(sameCurrency == false){
            system.Debug('??? inside sponsorship' + samecurrency);
            sponList=[select Name,Sponsorship_Name__c,(select Name,Brand_Name__c,convertCurrency(Sponsorship_Costs_Actual__c),convertCurrency(Sponsorship_Costs_Estimated__c) from Brand__r WHERE Canceled__c = False) from Sponsorship__c where Canceled__c = False AND Sponsorship__c=:congid];
        }
        else{
            sponList=[select Name,Sponsorship_Name__c,(select Name,Brand_Name__c,Sponsorship_Costs_Actual__c,Sponsorship_Costs_Estimated__c from Brand__r WHERE Canceled__c = False) from Sponsorship__c where Canceled__c = False AND Sponsorship__c=:congid];
        }
        system.debug('sponList++++'+sponList);
        system.debug('sponList.size()++++'+sponList.size());
        
        if(sponList.size()>0)
        {            
            String BrandspName= '';
            Decimal SponEstimatedcost= 0.00;
            Decimal SponActualCost= 0.00;
            for(Sponsorship__c sp: sponList)
            {
                if(sp.Brand__r.size() > 0)
                {
                    for(Brand__c bd:sp.Brand__r)
                    {
                        BrandspName+= bd.Brand_Name__c+',';                        
                        SponEstimatedcost+= (bd.Sponsorship_Costs_Estimated__c != null ? bd.Sponsorship_Costs_Estimated__c : 0);
                        SponActualCost+=(bd.Sponsorship_Costs_Actual__c!= null ? bd.Sponsorship_Costs_Actual__c: 0);
                    }
                    totalSponsorshipEstimatedCost += SponEstimatedcost;
                    totalSponsorshipActualCost += SponActualCost;
                    
                    system.debug('List of Data'+BrandspName+'+++++'+SponEstimatedcost+'+++++'+SponActualCost);
                }                
                
                BrandspName= BrandspName.replace('null','');  
                /*  SponEstimatedcost= SponEstimatedcost.replace('null','0');                 
SponActualCost= SponActualCost.replace('null','0');   */
                BrandspName=BrandspName.removeEnd(',');
                /*     SponEstimatedcost= SponEstimatedcost.removeEnd(',');
SponActualCost= SponActualCost.removeEnd(',');          */         
                sponWrapper.Add(new sponListWrapper(sp.Name,sp.Sponsorship_Name__c,BrandspName,SponEstimatedcost,SponActualCost));        
                BrandspName= '';
                SponEstimatedcost= 0.00;
                SponActualCost= 0.00;            
            }
            totalEstimatedCost = totalEstimatedCost + totalSponsorshipEstimatedCost;
            totalActualCost = totalActualCost + totalSponsorshipActualCost;
            system.debug('dispWrapperList++++'+sponWrapper);
        }
        List<Product_Theater__c> prdtrList = new List<Product_Theater__c>();
        if(sameCurrency == false){
            system.Debug('??? inside productTheater' + samecurrency);
            prdtrList=[Select Name,Product_Theater_Name__c,(select Name,Brand_Name__c,convertCurrency(Product_Theater_Costs_Actual__c),convertCurrency(Product_Theater_Costs_Estimated__c) from Brand__r WHERE Canceled__c = False) from Product_Theater__c where Canceled__c = False AND Congress__c=:congid];
        }
        else{
            prdtrList=[Select Name,Product_Theater_Name__c,(select Name,Brand_Name__c,Product_Theater_Costs_Actual__c,Product_Theater_Costs_Estimated__c from Brand__r WHERE Canceled__c = False) from Product_Theater__c where Canceled__c = False AND Congress__c=:congid];
        }
        system.debug('sponList++++'+sponList);
        system.debug('sponList.size()++++'+sponList.size());
        
        if(prdtrList.size()>0)
        {            
            String BrandpdName= '';
            Decimal prdtrEstimatedcost=0.00;
            Decimal prdtrActualCost= 0.00;
            for(Product_Theater__c pd: prdtrList)
            {
                if(pd.Brand__r.size() > 0)
                {
                    for(Brand__c bnd : pd.Brand__r)
                    {
                        BrandpdName+= bnd.Brand_Name__c+',';                        
                        prdtrEstimatedcost+= (bnd.Product_Theater_Costs_Estimated__c != null ? bnd.Product_Theater_Costs_Estimated__c : 0);
                        prdtrActualCost+=(bnd.Product_Theater_Costs_Actual__c!= null ? bnd.Product_Theater_Costs_Actual__c: 0);
                    }
                    
                    totalProductTheaterEstimatedCost += prdtrEstimatedcost;
                    totalProductTheaterActualCost += prdtrActualCost;
                    
                    system.debug('List of Data'+BrandpdName+'+++++'+prdtrEstimatedcost+'+++++'+prdtrActualCost);
                }                
                // prdtrEstimatedcost= prdtrEstimatedcost.replace('null','0');  
                BrandpdName= BrandpdName.replace('null','');                   
                //  prdtrActualCost= prdtrActualCost.replace('null','0'); 
                BrandpdName=BrandpdName.removeEnd(',');
                //   prdtrEstimatedcost= prdtrEstimatedcost.removeEnd(',');
                //  prdtrActualCost= prdtrActualCost.removeEnd(',');                              
                prdtrWrapper.Add(new prodtrListWrapper(pd.Name,pd.Product_Theater_Name__c,BrandpdName,prdtrEstimatedcost,prdtrActualCost));        
                BrandpdName= '';
                prdtrEstimatedcost= 0.00;
                prdtrActualCost= 0.00;            
            }
            totalEstimatedCost = totalEstimatedCost + totalProductTheaterEstimatedCost;
            totalActualCost = totalActualCost + totalProductTheaterActualCost;
            system.debug('prdtrWrapperList++++'+prdtrWrapper);
        }
        List<Symposia__c> symList = new  List<Symposia__c>();
        if(sameCurrency == false){
            system.Debug('??? inside symposia' + samecurrency);
            symList=[Select Name,Symposia_Name__c,(select Name,Brand_Name__c,convertCurrency(Symposia_Actual_Cost__c),convertCurrency(Symposia_Estimated_Cost__c) from Brand__r WHERE Canceled__c = False) from Symposia__c where Canceled__c = False AND Congress__c=:congid];
        }
        else{
            symList=[Select Name,Symposia_Name__c,(select Name,Brand_Name__c,Symposia_Actual_Cost__c,Symposia_Estimated_Cost__c from Brand__r WHERE Canceled__c = False) from Symposia__c where Canceled__c = False AND Congress__c=:congid];
        }
        system.debug('symList++++'+symList);
        system.debug('symList.size()++++'+symList.size());
        
        if(symList.size()>0)
        {            
            String BrandsyName= '';
            Decimal syEstimatedcost= 0.00;
            Decimal syActualCost= 0.00;
            for(Symposia__c sy: symList)
            {
                if(sy.Brand__r.size() > 0)
                {
                    for(Brand__c bnds : sy.Brand__r)
                    {
                        BrandsyName+= bnds .Brand_Name__c+',';                        
                        syEstimatedcost+=(bnds .Symposia_Estimated_Cost__c!= null ? bnds .Symposia_Estimated_Cost__c: 0);
                        syActualCost+=(bnds .Symposia_Actual_Cost__c!= null ? bnds .Symposia_Actual_Cost__c: 0);
                    }
                    
                    totalSymposiaEstimatedCost += syEstimatedcost;
                    totalSymposiaActualCost += syActualCost;
                    
                    system.debug('List of Data'+BrandsyName+'+++++'+syEstimatedcost+'+++++'+syActualCost);
                }                
                // syEstimatedcost= syEstimatedcost.replace('null','0');  
                BrandsyName= BrandsyName.replace('null','');                   
                // syActualCost= syActualCost.replace('null','0');    
                BrandsyName=BrandsyName.removeEnd(',');
                //syEstimatedcost= syEstimatedcost.removeEnd(',');
                //syActualCost= syActualCost.removeEnd(',');                                    
                syWrapper.Add(new sypmListWrapper(sy.Name,sy.Symposia_Name__c,BrandsyName,syEstimatedcost,syActualCost));        
                BrandsyName= '';
                syEstimatedcost= 0.00;
                syActualCost= 0.00;            
            }
            totalEstimatedCost = totalEstimatedCost + totalSymposiaEstimatedCost;
            totalActualCost = totalActualCost + totalSymposiaActualCost;
            system.debug('syWrapper++++'+syWrapper);
        }
        List<Meeting_Room__c> mtrmList = new List<Meeting_Room__c>();
        if(sameCurrency == false){
            system.Debug('??? inside meeting room' + samecurrency);
            mtrmList=[Select Name,Meeting_Room_Name__c,(select Name,Brand_Name__c,convertCurrency(Meeting_Room_Estimated_Cost__c),convertCurrency(Meeting_Room_Actual_Cost__c),MR_Services_Actual_Costs__c,MR_Services_Estimated_Costs__c from Brand__r WHERE Canceled__c = False)  from Meeting_Room__c where Canceled__c = False AND Congress__c=:congid];
        }
        else{
            mtrmList=[Select Name,Meeting_Room_Name__c,(select Name,Brand_Name__c,Meeting_Room_Estimated_Cost__c,Meeting_Room_Actual_Cost__c,MR_Services_Actual_Costs__c,MR_Services_Estimated_Costs__c from Brand__r WHERE Canceled__c = False) from Meeting_Room__c where Canceled__c = False AND Congress__c=:congid];
        }
        system.debug('mtrmList++++'+mtrmList);
        system.debug('mtrmList.size()++++'+mtrmList.size());
        
        if(mtrmList.size()>0)
        {            
            String BrandmtrmName= '';
            Decimal mtrmEstimatedcost= 0.00;
            Decimal mtrmActualCost= 0.00;  
            Decimal mtrmSerEstimatedcost= 0.00;
            Decimal mtrmSerActualCost= 0.00;            
            for(Meeting_Room__c mtrm: mtrmList)
            {
                if(mtrm.Brand__r.size() > 0)
                {
                    for(Brand__c bndst : mtrm.Brand__r)
                    {
                        BrandmtrmName+= bndst .Brand_Name__c+',';                        
                        mtrmEstimatedcost+=(bndst .Meeting_Room_Estimated_Cost__c!= null ? bndst .Meeting_Room_Estimated_Cost__c: 0); 
                        mtrmActualCost+=(bndst .Meeting_Room_Actual_Cost__c != null ? bndst .Meeting_Room_Actual_Cost__c : 0); 
                        mtrmSerEstimatedcost+=(bndst .MR_Services_Estimated_Costs__c!= null ? bndst .MR_Services_Estimated_Costs__c: 0); 
                        mtrmSerActualCost+=(bndst .MR_Services_Actual_Costs__c != null ? bndst .MR_Services_Actual_Costs__c : 0); 
                    }
                    
                    totalMeetingRoomEstimatedCost += mtrmEstimatedcost;
                    totalMeetingRoomActualCost += mtrmActualCost;
                    totalMeetingRoomServiceEstimatedCost += mtrmSerEstimatedcost;
                    totalMeetingRoomServiceActualCost += mtrmSerActualCost;
                    
                    system.debug('List of Data'+BrandmtrmName+'+++++'+mtrmEstimatedcost+'+++++'+mtrmActualCost+'+++++'+mtrmSerEstimatedcost+'+++++'+mtrmSerActualCost);
                }               
                // mtrmEstimatedcost= mtrmEstimatedcost.replace('null','0');  
                BrandmtrmName= BrandmtrmName.replace('null','');                   
                //  mtrmActualCost= mtrmActualCost.replace('null','0');  
                BrandmtrmName=BrandmtrmName.removeEnd(',');
                //  mtrmEstimatedcost= mtrmEstimatedcost.removeEnd(',');
                //   mtrmActualCost= mtrmActualCost.removeEnd(',');                                               
                MtrmWrapper.Add(new mtrmListWrapper(mtrm.Name,mtrm.Meeting_Room_Name__c,BrandmtrmName,mtrmEstimatedcost,mtrmActualCost,mtrmSerEstimatedcost,mtrmSerActualCost));        
                BrandmtrmName= '';
                mtrmEstimatedcost= 0.00;
                mtrmActualCost= 0.00;
                mtrmSerEstimatedcost= 0.0;
                mtrmSerActualCost = 0.0;
            }
            totalEstimatedCost = totalEstimatedCost + totalMeetingRoomEstimatedCost + totalMeetingRoomServiceEstimatedCost;
            totalActualCost = totalActualCost + totalMeetingRoomActualCost + totalMeetingRoomServiceActualCost;
            system.debug('MtrmWrapper++++'+MtrmWrapper);
        }
    } 
    public PageReference back() 
    {
        return page.ReportsList;
        
    }  
    public PageReference save() 
    {
        return page.CongressFinancialSummaryExcelDownload;        
    } 
    public class exhibitListWrapper {
        public String ExhibitId{get; set;}
        public String ExhibitName{get; set;}
        public String Brand{get; set;}
        public Decimal BoothSpaceActualCost{get; set;}
        public Decimal BoothSpaceEstimatedCost{get; set;}
        public Decimal ExhibitCostActual{get; set;}
        public Decimal ExhibitCostEstimated{get; set;}
        public exhibitListWrapper (String ExhibitId,String ExhibitName,String Brand,Decimal BoothSpaceEstimatedCost,Decimal BoothSpaceActualCost,Decimal ExhibitCostEstimated,Decimal ExhibitCostActual) 
        {
            this.ExhibitId= ExhibitId;
            this.ExhibitName= ExhibitName;
            this.Brand= Brand;
            this.BoothSpaceActualCost=BoothSpaceActualCost;
            this.BoothSpaceEstimatedCost=BoothSpaceEstimatedCost;
            this.ExhibitCostActual= ExhibitCostActual;
            this.ExhibitCostEstimated= ExhibitCostEstimated;
        }
    }
    public class sponListWrapper{
        public string SponId{get;set;}
        public string SponName{get;set;}
        public string BrandName{get;set;}
        public Decimal BrandSponEstimatedCost{get;set;}
        public Decimal BrandSponActualCost{get;set;}
        public sponListWrapper(string SponId,string SponName,string BrandName,Decimal BrandSponEstimatedCost,Decimal BrandSponActualCost){
            this.SponId= SponId;
            this.SponName= SponName;
            this.BrandName= BrandName;
            this.BrandSponEstimatedCost=BrandSponEstimatedCost;
            this.BrandSponActualCost=BrandSponActualCost;            
        }
    }
    public class prodtrListWrapper{
        public string PrdtrId{get;set;}
        public string PrdtrName{get;set;}
        public string BrandName{get;set;}
        public Decimal PrdtrEstimatedCost{get;set;}
        public Decimal PrdtrActualCost{get;set;}
        public prodtrListWrapper(string PrdtrId,string PrdtrName,string BrandName,Decimal PrdtrEstimatedCost,Decimal PrdtrActualCost){
            this.PrdtrId= PrdtrId;
            this.PrdtrName= PrdtrName;
            this.BrandName= BrandName;
            this.PrdtrEstimatedCost=PrdtrEstimatedCost;
            this.PrdtrActualCost=PrdtrActualCost;            
        }
    }
    public class sypmListWrapper{
        public string SypmId{get;set;}
        public string SypmName{get;set;}
        public string BrandName{get;set;}
        public Decimal SypmEstimatedCost{get;set;}
        public Decimal SypmActualCost{get;set;}
        public sypmListWrapper(string SypmId,string SypmName,string BrandName,Decimal SypmEstimatedCost,Decimal SypmActualCost){
            this.SypmId= SypmId;
            this.SypmName= SypmName;
            this.BrandName= BrandName;
            this.SypmEstimatedCost=SypmEstimatedCost;
            this.SypmActualCost=SypmActualCost;            
        }
    }
    public class mtrmListWrapper{
        public string MtrmId{get;set;}
        public string MtrmName{get;set;}
        public string BrandName{get;set;}
        public Decimal MtrmEstimatedCost{get;set;}
        public Decimal MtrmActualCost{get;set;}
        public Decimal MtrmSerEstimatedCost{get;set;}
        public Decimal MtrmSerActualCost{get;set;}
        public mtrmListWrapper(string MtrmId,string MtrmName,string BrandName,Decimal MtrmEstimatedCost,Decimal MtrmActualCost,Decimal MtrmSerEstimatedCost,Decimal MtrmSerActualCost){
            this.MtrmId= MtrmId;
            this.MtrmName= MtrmName;
            this.BrandName= BrandName;
            this.MtrmEstimatedCost=MtrmEstimatedCost;
            this.MtrmActualCost=MtrmActualCost;  
            this.MtrmSerEstimatedCost=MtrmSerEstimatedCost;
            this.MtrmSerActualCost=MtrmSerActualCost;
        }
    }
    public class summaryExhibit
    {
        public Double  BoothEstCost{get;set;}
        public Double  BoothActCost{get;set;}
        public Double  ExhibitEstCost{get;set;}
        public Double  ExhibitActCost{get;set;}
        public Double  SponEstCost{get;set;}
        public Double  SponActCost{get;set;}
        public Double  PrdEstCost{get;set;}
        public Double  PrdActCost{get;set;}
        public Double  symEstCost{get;set;}
        public Double  symActCost{get;set;}
        public Double  MtrmEstCost{get;set;}
        public Double  MtrmActCost{get;set;}
        public Double  MtrmSerEstCost{get;set;}
        public Double  MtrmSerActCost{get;set;}
        public Double  TotalEstCost{get;set;}
        public Double  TotalActCost{get;set;}
        
        public summaryExhibit(AggregateResult ar){
            BoothEstCost=  (ar.get('boothestimated')!=null)?(Double)ar.get('boothestimated'):0.00;
            BoothActCost= (ar.get('boothactual')!=null)?(Double)ar.get('boothactual'):0.00;
            ExhibitEstCost= (ar.get('exhibitEstimate')!=null)?(Double)ar.get('exhibitEstimate'):0.00;
            ExhibitActCost=(ar.get('exhibitactual')!=null)?(Double)ar.get('exhibitactual'):0.00;
            SponEstCost=(ar.get('sponestcost')!=null)?(Double)ar.get('sponestcost'):0.00;
            SponActCost=(ar.get('sponactcost')!=null)?(Double)ar.get('sponactcost'):0.00;
            PrdEstCost= (ar.get('prdest')!=null)?(Double)ar.get('prdest'):0.00;
            PrdActCost= (ar.get('prdact')!=null)?(Double)ar.get('prdact'):0.00;
            symEstCost= (ar.get('syest')!=null)?(Double)ar.get('syest'):0.00;
            symActCost= (ar.get('syact')!=null)?(Double)ar.get('syact'):0.00;
            MtrmEstCost= (ar.get('metest')!=null)?(Double)ar.get('metest'):0.00;
            MtrmActCost= (ar.get('mtact')!=null)?(Double)ar.get('mtact'):0.00;
            MtrmSerEstCost= (ar.get('mtSeract')!=null)?(Double)ar.get('mtSeract'):0.00;
            MtrmSerActCost= (ar.get('boothactual')!=null)?(Double)ar.get('boothactual'):0.00;
            TotalEstCost= BoothEstCost+ExhibitEstCost+SponEstCost+PrdEstCost+symEstCost+MtrmEstCost+MtrmSerEstCost;
            TotalActCost= BoothActCost+ExhibitActCost+SponActCost+PrdActCost+symActCost+MtrmActCost+MtrmSerActCost;
        }
    }
    public list<summaryExhibit> getResults(){
        List<Brand__c> brandSize = [Select Id, Name FROM Brand__c WHERE Canceled__c = False AND GES_Connect_Corporate_Accounts__c=:congid];
        list<summaryExhibit> lstResult = new list<summaryExhibit>();
        if(brandSize.size() > 0){
            for(AggregateResult ar : sumbrand){
                summaryExhibit objwc = new summaryExhibit(ar);
                lstResult.add(objwc);
            }
        }
        return lstResult;
    }   
}