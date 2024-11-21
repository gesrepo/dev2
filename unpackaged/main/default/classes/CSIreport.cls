public class CSIreport{   
    public string congid{get;set;} 
    public GES_Connect_Corporate_Accounts__c ges { get; set; }
    public GES_Connect_Corporate_Accounts__c TEC {get; set;}
    public Decimal totalEstimatedCost {get;set;}
    public List<exhibitListWrapper> dispWrapper{get;set;}
    public List<sponListWrapper> sponWrapper{get;set;}
    public List<prodtrListWrapper> prdtrWrapper{get;set;}
    public List<sypmListWrapper> syWrapper{get;set;}
    public List<mtrmListWrapper> MtrmWrapper{get;set;}
    public List<AggregateResult> sumbrand{get;set;}
    //public List<summaryExhibit> sumExhibitList{get;set;}
    public String location{get;set;}
    public String location1{get;set;}
    public String currSymbol{get;set;}
    public String Association1{get;set;}
    public String Association2{get;set;}
    public Boolean showHousingRequiredFields{get;set;}
    public Boolean sameCurrency{get;set;}
    public Boolean isSameCurrency{get;set;}
    List<String> args = new String[]{'0','number','###,###,##0.00'};
        public Decimal  BoothEstCost{get;set;}
    public Decimal  ExhibitEstCost{get;set;}
    public Decimal  SponEstCost{get;set;}
    public Decimal  PrdEstCost{get;set;}
    public Decimal  symEstCost{get;set;}
    public Decimal  MtrmEstCost{get;set;}
    public Decimal  GESMREstCost{get;set;}
    public Date  enteredDate{get;set;}
    
    public CSIreport(ApexPages.StandardController controller){
        sameCurrency = false;
        isSameCurrency = true;
        showHousingRequiredFields = false;
        totalEstimatedCost = 0;
        TEC = new GES_Connect_Corporate_Accounts__c();
        TEC.Total_Estimated_Cost__c = 0.00;
        TEC.Total_Booth_Estimated_Cost__c = 0.00;
        TEC.Total_Cost__c = 0.00;
        TEC.Total_Meeting_Room_Estimated_Cost__c = 0.00;
        TEC.Total_Product_Theater_Estimated_Cost__c =0.00;
        TEC.Total_Symposia_Estimated_Cost__c = 0.00;
        ges=new GES_Connect_Corporate_Accounts__c();  
        dispWrapper = new List<exhibitListWrapper>();
        sponWrapper= new List<sponListWrapper>();
        prdtrWrapper= new List<prodtrListWrapper>();
        syWrapper= new List<sypmListWrapper>();
        MtrmWrapper= new List<mtrmListWrapper>();
        //sumExhibitList=new List<summaryExhibit>();
        BoothEstCost=0.00;
        ExhibitEstCost=0.00;
        SponEstCost=0.00;
        PrdEstCost=0.00;
        symEstCost=0.00;
        MtrmEstCost=0.00;
        GESMREstCost=0.00;
        String dateFormat= 'yyyy-MM-dd HH:mm:ss';
        String status1= 'Created';
        String status2= 'Updated';
        String status3= 'N/C';
        String dateFormat2= 'M/d/yyyy';
        String userTimeZone= UserInfo.getTimeZone().getID();
        String userDate =System.currentPageReference().getParameters().get('userDate');
        System.debug('userDate==='+userDate);
        enteredDate = date.valueOf(userDate);
        System.debug('enteredDate==='+enteredDate);
        congid =System.currentPageReference().getParameters().get('Id'); 
        if(String.isNotBlank(congid))   {  
            ges=[Select id,Name_of_Congress__c,Acronym_of_Congress__c,Total_Estimated_Cost__c,Total_Symposia_Estimated_Cost__c,Total_Product_Theater_Estimated_Cost__c,Total_Meeting_Room_Estimated_Cost__c,Total_Cost__c,Total_Booth_Estimated_Cost__c,CurrencyIsoCode,Congress_Website__c,Shipping_City__c,Shipping_State_Province__c,Congress_Level__c,Shipping_Country__c,Association_Name__c,Secretariat_Name__c,Association_Contact_Name__c,
                 Secretariat_Contact_Name__c,Association_Email__c,Secretariat_Contact_Email__c,Association_phone__c,Total_No_of_Rooms_Req__c,Secretariat_Contact_Phone__c,Exhibit_Close_Date__c,Exhibit_Open_Date__c, 
                 Number_of_rooms_to_Secure__c,Housing_Required_PL__c,Brand_1__c,Brand_2__c,Brand_3__c,Brand_4__c,Brand_5__c,Number_of_Rooms_Requested_1__c,Number_of_Rooms_Requested_2__c,Number_of_Rooms_Requested_3__c,Number_of_Rooms_Requested_4__c,Number_of_Rooms_Requested_5__c from GES_Connect_Corporate_Accounts__c where id=:congid ];
            
            If(ges.Housing_Required_PL__c == 'Yes'){
                showHousingRequiredFields = True;
            }
        }
        TEC.CurrencyIsoCode = ges.CurrencyIsoCode;
        
        for(Brand__c brand : [SELECT Id,Name,CurrencyISOCode FROM Brand__c WHERE Canceled__c = FALSE AND GES_Connect_Corporate_Accounts__c =:congid]){
            system.debug('------------------------>>>>>>>>>>>'+ges.CurrencyIsoCode );
            system.debug(brand.CurrencyIsoCode);
            if(ges.CurrencyIsoCode == brand.CurrencyIsoCode && isSameCurrency == true){
                system.debug('currency is different');
                sameCurrency = true;
            }
            else{
                sameCurrency = false;
                isSameCurrency = false;
            } 
        }
        
        system.debug('------->>>>>' + sameCurrency);
        if(sameCurrency == true){
            if(ges.CurrencyIsoCode=='GBP'){
                currSymbol='£';
            }else if(ges.CurrencyIsoCode=='CAD'){
                currSymbol='C$';
            }else if(ges.CurrencyIsoCode=='EUR'){
                currSymbol='€';
            }else if(ges.CurrencyIsoCode=='HKD'){
                currSymbol='HK$';
            }else if(ges.CurrencyIsoCode=='SGD'){
                currSymbol='S$';
            }else if(ges.CurrencyIsoCode=='CHF'){
                currSymbol='SFr';
            }else if(ges.CurrencyIsoCode=='AED'){
                currSymbol='AED';
            }else if(ges.CurrencyIsoCode=='JPY'){
                currSymbol='JPY';
            }else if(ges.CurrencyIsoCode=='DKK'){
                currSymbol='DKK';
            }else{
                currSymbol='$';
            }
        }
        else{
            currSymbol='$';
        }
        location= '';
        if(ges.Shipping_City__c!=null && ges.Shipping_City__c!='' ){
            location = ges.Shipping_City__c;
        }
        if(ges.Shipping_City__c!=''){
            location+= ', ';
        }
        if(ges.Shipping_State_Province__c!=null && ges.Shipping_State_Province__c!='' ){
            location += ges.Shipping_State_Province__c;
        }
        location1= '';
        location1+=(ges.Shipping_Country__c!= null ? ges.Shipping_Country__c: '');
        
        Association1='';
        if(ges.Association_Email__c!=null && ges.Association_Email__c!='' ){
            Association1 = ges.Association_Email__c;
        }
        
        Association2='';
        if(ges.Association_phone__c!=null && ges.Association_phone__c!='' ){
            Association2 = ges.Association_phone__c;
        }
        List<Exhibit__c> exhibitList = new List<Exhibit__c>();
        dispWrapper = new List<exhibitListWrapper>();
        if(sameCurrency == false){
            exhibitList = [Select Exhibit_Name__c,Activity_Level__c,GES_Congress_Manager__c,Congress_Lead__c,(select Id,Brand_Name__c,Cost_Center__c,Funding_Provider_Region__c,Brand_Team_Contact__c,Contact_Not_Listed__c,convertCurrency(Booth_Space_Cost_Actual__c),convertCurrency(Exhibit_Costs_Actual__c),convertCurrency(Sponsorship_Costs_Actual__c),convertCurrency(Product_Theater_Costs_Actual__c),convertCurrency(Symposia_Actual_Cost__c),convertCurrency(Meeting_Room_Actual_Cost__c),convertCurrency(MR_Services_Actual_Costs__c),Company_Code__c ,Name,Congress_Lead__c, LastModifiedDate, CreatedDate, Funding_Provider_Department__c from Brand_Instance__r where Canceled__c = FALSE), LastModifiedDate, CreatedDate, notes__c,CSI_Form_Notes__c from Exhibit__c where Activity_Type_Exhibit_Instance_c__c=:congid AND Canceled__c = FALSE ];
        }
        else{
            exhibitList = [Select Exhibit_Name__c,Activity_Level__c,GES_Congress_Manager__c,Congress_Lead__c,(select Id,Brand_Name__c,Cost_Center__c,Funding_Provider_Region__c,Brand_Team_Contact__c,Contact_Not_Listed__c,Booth_Space_Cost_Actual__c,Exhibit_Costs_Actual__c,Sponsorship_Costs_Actual__c,Product_Theater_Costs_Actual__c,Symposia_Actual_Cost__c,Meeting_Room_Actual_Cost__c,MR_Services_Actual_Costs__c,Company_Code__c ,Name,Congress_Lead__c, LastModifiedDate, CreatedDate, Funding_Provider_Department__c from Brand_Instance__r where Canceled__c = FALSE), LastModifiedDate, CreatedDate, notes__c,CSI_Form_Notes__c from Exhibit__c where Activity_Type_Exhibit_Instance_c__c=:congid AND Canceled__c = FALSE ];
        }
        //system.debug('exhibitList++++'+exhibitList);
        system.debug('exhibitList.size()++++'+exhibitList.size());
        
        if(exhibitList.size()>0)
        {          
            for(Exhibit__c ex: exhibitList)
            {
                List<brandWrapper> brands = new List<brandWrapper>();
                if(ex.Brand_Instance__r.size()>0)
                {
                    for(Brand__c br:ex.Brand_Instance__r)
                    {
                        brandWrapper b= new brandWrapper(br, enteredDate,dateFormat2,dateFormat,userTimeZone);
                        brands.add(b);
                        BoothEstCost +=(br.Booth_Space_Cost_Actual__c!= null ? br.Booth_Space_Cost_Actual__c: 0);
                        TEC.Total_Booth_Estimated_Cost__c += (br.Booth_Space_Cost_Actual__c!= null ? br.Booth_Space_Cost_Actual__c: 0);
                        ExhibitEstCost +=(br.Exhibit_Costs_Actual__c!= null ? br.Exhibit_Costs_Actual__c: 0);
                    }
                }
                String status;
                String lastModifiedDate;
                lastModifiedDate = ex.LastModifiedDate.format(dateFormat2, userTimeZone);
                Date crdt= date.valueOf(ex.CreatedDate.format(dateFormat,userTimeZone ));
                Date lmdt= date.valueOf(ex.LastModifiedDate.format(dateFormat, userTimeZone));
                //system.debug('crdt==='+crdt);
                //system.debug('lastModifiedDate==='+lastModifiedDate);
                //system.debug('lmdt==='+lmdt);
                
                if(lmdt>=enteredDate && crdt >= enteredDate){
                    status =status1;
                }else if(lmdt >=enteredDate && crdt < enteredDate){
                    status = status2;
                } else{
                    status =status3;
                }               
                
                
                //system.debug('List of Data'+Brand+'+++++'+BrandName+'+++++'+BotspEstimatedCost+'+++++'+ExEstimatedCost);        
                dispWrapper.Add(new exhibitListWrapper(ex.Exhibit_Name__c,                                                       
                                                       ex.GES_Congress_Manager__c,
                                                       ex.Congress_Lead__c,
                                                       ex.Activity_Level__c,
                                                       ex.CSI_Form_Notes__c,                                                       
                                                       brands,
                                                       status,
                                                       lastModifiedDate
                                                      ));                                                 
                
                
            }
            totalEstimatedCost += BoothEstCost ;
            TEC.Total_Estimated_Cost__c += BoothEstCost;
            //totalEstimatedCost += ExhibitEstCost;
            system.debug('dispWrapperList++++'+dispWrapper);
        }
        List<Sponsorship__c> sponList = new List<Sponsorship__c>();
        if(sameCurrency == false){
            sponList=[select Sponsorship_Name__c,Activity_Level__c,Sponsorship_Notes__c,GES_Congress_Manager__c,Congress_Lead__c,(select Brand_Name__c,Cost_Center__c,Funding_Provider_Region__c,Company_Code__c,
                                                                                                                                  Brand_Team_Contact__c,Contact_Not_Listed__c,convertCurrency(Booth_Space_Cost_Actual__c),convertCurrency(Exhibit_Costs_Actual__c),convertCurrency(Sponsorship_Costs_Actual__c),convertCurrency(Product_Theater_Costs_Actual__c),convertCurrency(Symposia_Actual_Cost__c),convertCurrency(Meeting_Room_Actual_Cost__c),convertCurrency(MR_Services_Actual_Costs__c), Congress_Lead__c, LastModifiedDate, CreatedDate, Funding_Provider_Department__c from Brand__r where Canceled__c = FALSE), LastModifiedDate, CreatedDate from Sponsorship__c where Sponsorship__c=:congid AND Canceled__c = FALSE];
        }
        else{ 
            sponList=[select Sponsorship_Name__c,Activity_Level__c,Sponsorship_Notes__c,GES_Congress_Manager__c,Congress_Lead__c,(select Brand_Name__c,Cost_Center__c,Funding_Provider_Region__c,Company_Code__c,
                                                                                                                                  Brand_Team_Contact__c,Contact_Not_Listed__c,Booth_Space_Cost_Actual__c,Exhibit_Costs_Actual__c,Sponsorship_Costs_Actual__c,Product_Theater_Costs_Actual__c,Symposia_Actual_Cost__c,Meeting_Room_Actual_Cost__c,MR_Services_Actual_Costs__c, Congress_Lead__c, LastModifiedDate, CreatedDate, Funding_Provider_Department__c from Brand__r where Canceled__c = FALSE), LastModifiedDate, CreatedDate from Sponsorship__c where Sponsorship__c=:congid AND Canceled__c = FALSE];
            
        }
        //system.debug('sponList++++'+sponList);
        //system.debug('sponList.size()++++'+sponList.size());
        
        if(sponList.size()>0)
        {            
            
            for(Sponsorship__c sp: sponList)
            {
                List<brandWrapper> brands = new List<brandWrapper>();
                if(sp.Brand__r.size()>0)
                {
                    
                    for(Brand__c br:sp.Brand__r)
                    {
                        brandWrapper b= new brandWrapper(br, enteredDate,dateFormat2,dateFormat,userTimeZone);
                        brands.add(b);
                        SponEstCost +=(br.Sponsorship_Costs_Actual__c!= null ? br.Sponsorship_Costs_Actual__c: 0);
                        TEC.Total_Cost__c +=(br.Sponsorship_Costs_Actual__c!= null ? br.Sponsorship_Costs_Actual__c: 0);
                    }  
                }
                String status;
                String lastModifiedDate;
                lastModifiedDate = sp.LastModifiedDate.format(dateFormat2, userTimeZone);
                Date crdt= date.valueOf(sp.CreatedDate.format(dateFormat,userTimeZone ));
                Date lmdt= date.valueOf(sp.LastModifiedDate.format(dateFormat, userTimeZone));
                //system.debug('crdt==='+crdt);
                //system.debug('lastModifiedDate==='+lastModifiedDate);
                //system.debug('lmdt==='+lmdt);
                
                if(lmdt>=enteredDate && crdt >= enteredDate){
                    status =status1;
                }else if(lmdt >=enteredDate && crdt < enteredDate){
                    status = status2;
                } else{
                    status =status3;
                }      
                
                sponWrapper.Add(new sponListWrapper(sp.Sponsorship_Name__c,
                                                    sp.GES_Congress_Manager__c,
                                                    sp.Congress_Lead__c,
                                                    sp.Activity_Level__c,
                                                    sp.Sponsorship_Notes__c,
                                                    brands,
                                                    status,
                                                    lastModifiedDate));      
                
                
            }
            totalEstimatedCost += SponEstCost;
            TEC.Total_Estimated_Cost__c += SponEstCost;
            //system.debug('dispWrapperList++++'+sponWrapper);
        }
        List<Product_Theater__c> prdtrList = new List<Product_Theater__c>();
        if(sameCurrency ==false){
            prdtrList=[Select Product_Theater_Name__c,Activity_Level__c,Product_Theater_Notes__c,Requested_Product_Theater_Date_and_Time__c,GES_Congress_Manager__c,Congress_Lead__c,(select Name,Brand_Name__c,Cost_Center__c,Funding_Provider_Region__c,Company_Code__c,Brand_Team_Contact__c,Contact_Not_Listed__c,convertCurrency(Booth_Space_Cost_Actual__c),convertCurrency(Exhibit_Costs_Actual__c),convertCurrency(Sponsorship_Costs_Actual__c),convertCurrency(Product_Theater_Costs_Actual__c),convertCurrency(Symposia_Actual_Cost__c),convertCurrency(Meeting_Room_Actual_Cost__c),convertCurrency(MR_Services_Actual_Costs__c), Congress_Lead__c, LastModifiedDate, CreatedDate, Funding_Provider_Department__c from Brand__r where Canceled__c = FALSE) , LastModifiedDate, CreatedDate from Product_Theater__c where Congress__c=:congid AND Canceled__c = FALSE];
        }
        else{
            prdtrList=[Select Product_Theater_Name__c,Activity_Level__c,Product_Theater_Notes__c,Requested_Product_Theater_Date_and_Time__c,GES_Congress_Manager__c,Congress_Lead__c,(select Name,Brand_Name__c,Cost_Center__c,Funding_Provider_Region__c,Company_Code__c,Brand_Team_Contact__c,Contact_Not_Listed__c,Booth_Space_Cost_Actual__c,Exhibit_Costs_Actual__c,Sponsorship_Costs_Actual__c,Product_Theater_Costs_Actual__c,Symposia_Actual_Cost__c,Meeting_Room_Actual_Cost__c,MR_Services_Actual_Costs__c, Congress_Lead__c, LastModifiedDate, CreatedDate, Funding_Provider_Department__c from Brand__r where Canceled__c = FALSE ), LastModifiedDate, CreatedDate from Product_Theater__c where Congress__c=:congid AND Canceled__c = FALSE];
        }
        //system.debug('prdtrList++++'+prdtrList);
        system.debug('prdtrList.size()++++'+prdtrList.size());
        
        if(prdtrList.size()>0)
        {            
            
            String onlyDate='';
            String onlyTime='';
            for(Product_Theater__c pd: prdtrList)
            {   
                List<brandWrapper> brands = new List<brandWrapper>();
                if(pd.Brand__r.size()>0)
                {
                    
                    for(Brand__c br:pd.Brand__r)
                    {
                        brandWrapper b= new brandWrapper(br, enteredDate,dateFormat2,dateFormat,userTimeZone);
                        brands.add(b);
                        PrdEstCost+= (br.Product_Theater_Costs_Actual__c!= null ? br.Product_Theater_Costs_Actual__c: 0);
                        TEC.Total_Product_Theater_Estimated_Cost__c += (br.Product_Theater_Costs_Actual__c!= null ? br.Product_Theater_Costs_Actual__c: 0);
                    }  
                }
                
                String dt= '';
                if(pd.Requested_Product_Theater_Date_and_Time__c!=null)
                {
                    dt=pd.Requested_Product_Theater_Date_and_Time__c.format('h:mm a');
                    onlydate= String.valueOf(pd.Requested_Product_Theater_Date_and_Time__c.format('M/d/yyyy'));
                    onlyTime= String.valueOf(pd.Requested_Product_Theater_Date_and_Time__c.format('h:mm a')); 
                }
                
                String status;
                String lastModifiedDate;
                lastModifiedDate = pd.LastModifiedDate.format(dateFormat2, userTimeZone);
                Date crdt= date.valueOf(pd.CreatedDate.format(dateFormat,userTimeZone ));
                Date lmdt= date.valueOf(pd.LastModifiedDate.format(dateFormat, userTimeZone));
                //system.debug('crdt==='+crdt);
                //system.debug('lastModifiedDate==='+lastModifiedDate);
                //system.debug('lmdt==='+lmdt);
                
                if(lmdt>=enteredDate && crdt >= enteredDate){
                    status =status1;
                }else if(lmdt >=enteredDate && crdt < enteredDate){
                    status = status2;
                } else{
                    status =status3;
                }      
                
                prdtrWrapper.Add(new prodtrListWrapper(pd.Product_Theater_Name__c,pd.GES_Congress_Manager__c,
                                                       pd.Congress_Lead__c,pd.Activity_Level__c,pd.Requested_Product_Theater_Date_and_Time__c,pd.Product_Theater_Notes__c,
                                                       onlyDate, onlyTime,brands, status, lastModifiedDate));        
                
                
            }
            totalEstimatedCost += PrdEstCost;
            TEC.Total_Estimated_Cost__c += PrdEstCost;
            
            system.debug('prdtrWrapperList++++'+prdtrWrapper);
        }
        List<Symposia__c> symList = new List<Symposia__c>();
        
        if(sameCurrency == false){
            symList=[Select Name,Symposia_Name__c,Activity_Level__c,Symposium_Notes__c,Requested_Symposium_Date_and_Time__c,GES_Congress_Manager__c,Congress_Lead__c,(select Name,Brand_Name__c,Cost_Center__c,Funding_Provider_Region__c,Company_Code__c,Brand_Team_Contact__c,Contact_Not_Listed__c,convertCurrency(Booth_Space_Cost_Actual__c),convertCurrency(Exhibit_Costs_Actual__c),convertCurrency(Sponsorship_Costs_Actual__c),convertCurrency(Product_Theater_Costs_Actual__c),convertCurrency(Symposia_Actual_Cost__c),convertCurrency(Meeting_Room_Actual_Cost__c),convertCurrency(MR_Services_Actual_Costs__c), Congress_Lead__c, LastModifiedDate, CreatedDate, Funding_Provider_Department__c from Brand__r where Canceled__c = FALSE), LastModifiedDate, CreatedDate from Symposia__c where Congress__c=:congid AND Canceled__c = FALSE];
        }
        else{
            symList=[Select Name,Symposia_Name__c,Activity_Level__c,Symposium_Notes__c,Requested_Symposium_Date_and_Time__c,GES_Congress_Manager__c,Congress_Lead__c,(select Name,Brand_Name__c,Cost_Center__c,Funding_Provider_Region__c,Company_Code__c,Brand_Team_Contact__c,Contact_Not_Listed__c,Booth_Space_Cost_Actual__c,Exhibit_Costs_Actual__c,Sponsorship_Costs_Actual__c,Product_Theater_Costs_Actual__c,Symposia_Actual_Cost__c,Meeting_Room_Actual_Cost__c,MR_Services_Actual_Costs__c, Congress_Lead__c, LastModifiedDate, CreatedDate, Funding_Provider_Department__c from Brand__r where Canceled__c = FALSE), LastModifiedDate, CreatedDate from Symposia__c where Congress__c=:congid AND Canceled__c = FALSE];
        }
        // system.debug('symList++++'+symList);
        system.debug('symList.size()++++'+symList.size());
        
        if(symList.size()>0)
        {            
            String onlyDate='';
            String onlyTime='';
            for(Symposia__c sy: symList)
            {
                List<brandWrapper> brands = new List<brandWrapper>();
                if(sy.Brand__r.size()>0)
                {
                    
                    for(Brand__c br:sy.Brand__r)
                    {
                        brandWrapper b= new brandWrapper(br, enteredDate,dateFormat2,dateFormat,userTimeZone);
                        brands.add(b);
                        symEstCost+= (br.Symposia_Actual_Cost__c!= null ? br.Symposia_Actual_Cost__c: 0);
                        TEC.Total_Symposia_Estimated_Cost__c += (br.Symposia_Actual_Cost__c!= null ? br.Symposia_Actual_Cost__c: 0);
                    }  
                }
                String dt= '';
                
                if(sy.Requested_Symposium_Date_and_Time__c!=null)
                {
                    dt=sy.Requested_Symposium_Date_and_Time__c.format('h:mm a');
                    onlydate= String.valueOf(sy.Requested_Symposium_Date_and_Time__c.format('M/d/yyyy'));
                    onlyTime= String.valueOf(sy.Requested_Symposium_Date_and_Time__c.format('h:mm a'));
                }              
                String status;
                String lastModifiedDate;
                lastModifiedDate = sy.LastModifiedDate.format(dateFormat2, userTimeZone);
                Date crdt= date.valueOf(sy.CreatedDate.format(dateFormat,userTimeZone ));
                Date lmdt= date.valueOf(sy.LastModifiedDate.format(dateFormat, userTimeZone));
                //system.debug('crdt==='+crdt);
                //system.debug('lastModifiedDate==='+lastModifiedDate);
                //system.debug('lmdt==='+lmdt);
                
                if(lmdt>=enteredDate && crdt >= enteredDate){
                    status =status1;
                }else if(lmdt >=enteredDate && crdt < enteredDate){
                    status = status2;
                } else{
                    status =status3;
                }     
                
                syWrapper.Add(new sypmListWrapper(sy.Symposia_Name__c,sy.GES_Congress_Manager__c,
                                                  sy.Congress_Lead__c,sy.Activity_Level__c,sy.Symposium_Notes__c,
                                                  sy.Requested_Symposium_Date_and_Time__c,
                                                  onlyDate, onlyTime,brands, status, lastModifiedDate));        
            }
            totalEstimatedCost += symEstCost;
            TEC.Total_Estimated_Cost__c += symEstCost;
            system.debug('syWrapper++++'+syWrapper);
        }
        List<Meeting_Room__c> mtrmList = new List<Meeting_Room__c>();
        if(sameCurrency == false){
            mtrmList=[Select Name,Meeting_Room_Name__c,Activity_Level__c,Meeting_Room_Notes__c,GES_Congress_Manager__c,Congress_Lead__c,(select Name,Brand_Name__c,Cost_Center__c,Funding_Provider_Region__c,Company_Code__c,
                                                                                                                                         Brand_Team_Contact__c,Contact_Not_Listed__c,convertCurrency(Booth_Space_Cost_Actual__c),convertCurrency(Exhibit_Costs_Actual__c),convertCurrency(Sponsorship_Costs_Actual__c),convertCurrency(Product_Theater_Costs_Actual__c),convertCurrency(Symposia_Actual_Cost__c),convertCurrency(Meeting_Room_Actual_Cost__c),convertCurrency(MR_Services_Actual_Costs__c), Congress_Lead__c, LastModifiedDate, CreatedDate, Funding_Provider_Department__c from Brand__r where Canceled__c = FALSE), LastModifiedDate, CreatedDate from Meeting_Room__c where Congress__c=:congid AND Canceled__c = FALSE];
            
        }
        else{
            mtrmList=[Select Name,Meeting_Room_Name__c,Activity_Level__c,Meeting_Room_Notes__c,GES_Congress_Manager__c,Congress_Lead__c,(select Name,Brand_Name__c,Cost_Center__c,Funding_Provider_Region__c,Company_Code__c,
                                                                                                                                         Brand_Team_Contact__c,Contact_Not_Listed__c,Booth_Space_Cost_Actual__c,Exhibit_Costs_Actual__c,Sponsorship_Costs_Actual__c,Product_Theater_Costs_Actual__c,Symposia_Actual_Cost__c,Meeting_Room_Actual_Cost__c,MR_Services_Actual_Costs__c, Congress_Lead__c, LastModifiedDate, CreatedDate, Funding_Provider_Department__c from Brand__r where Canceled__c = FALSE), LastModifiedDate, CreatedDate from Meeting_Room__c where Congress__c=:congid AND Canceled__c = FALSE]; 
        }
        system.debug('mtrmList++++'+mtrmList);
        system.debug('mtrmList.size()++++'+mtrmList.size());
        
        if(mtrmList.size()>0)
        {            
            
            for(Meeting_Room__c mtrm: mtrmList)
            {
                List<brandWrapper> brands = new List<brandWrapper>();
                if(mtrm.Brand__r.size()>0)
                {
                    
                    for(Brand__c br:mtrm.Brand__r)
                    {
                        brandWrapper b= new brandWrapper(br, enteredDate,dateFormat2,dateFormat,userTimeZone);
                        brands.add(b);
                        MtrmEstCost+= (br.Meeting_Room_Actual_Cost__c!= null ? br.Meeting_Room_Actual_Cost__c: 0);
                        TEC.Total_Meeting_Room_Estimated_Cost__c+= (br.Meeting_Room_Actual_Cost__c!= null ? br.Meeting_Room_Actual_Cost__c: 0);
                        GESMREstCost+= (br.MR_Services_Actual_Costs__c!= null ? br.MR_Services_Actual_Costs__c: 0);
                    }  
                }
                String status;
                String lastModifiedDate;
                lastModifiedDate = mtrm.LastModifiedDate.format(dateFormat2, userTimeZone);
                Date crdt= date.valueOf(mtrm.CreatedDate.format(dateFormat,userTimeZone ));
                Date lmdt= date.valueOf(mtrm.LastModifiedDate.format(dateFormat, userTimeZone));
                //system.debug('crdt==='+crdt);
                //system.debug('lastModifiedDate==='+lastModifiedDate);
                //system.debug('lmdt==='+lmdt);
                
                if(lmdt>=enteredDate && crdt >= enteredDate){
                    status =status1;
                }else if(lmdt >=enteredDate && crdt < enteredDate){
                    status = status2;
                } else{
                    status =status3;
                }     
                
                MtrmWrapper.Add(new mtrmListWrapper(mtrm.Meeting_Room_Name__c,mtrm.GES_Congress_Manager__c,mtrm.Congress_Lead__c,
                                                    mtrm.Activity_Level__c,mtrm.Meeting_Room_Notes__c, brands, status,lastModifiedDate)); 
                
            }
            totalEstimatedCost += MtrmEstCost;
            TEC.Total_Estimated_Cost__c += MtrmEstCost;
            //totalEstimatedCost += GESMREstCost;
            system.debug('MtrmWrapper++++'+MtrmWrapper);
        }
    } 
    
    public List<GES_Connect_Corporate_Accounts__c> geslst{get;set;}
    
    public PageReference save() 
    {
        return page.CSI_Report_ExcelDownload;        
    } 
    public class exhibitListWrapper {
        public String ExhibitName{get; set;}
        public String CongressManager{get; set;}
        public String CongressLead{get; set;}
        public String Level{get; set;} 
        public String Notes{get; set;}      
        public List<brandWrapper> brands{get; set;}  
        public String status{get; set;}
        public String lastModifiedDate{get; set;}
        
        
        public exhibitListWrapper(String ExhibitName,String CongressManager,String CongressLead,String Level, String Notes,List<brandWrapper> brands, String status, String lastModifiedDate) 
        {
            
            this.ExhibitName= ExhibitName;
            this.CongressManager=CongressManager;
            this.CongressLead=CongressLead;
            this.Level=Level;
            this.Notes = Notes;
            this.brands = brands;
            this.status= status;
            this.lastModifiedDate= lastModifiedDate;
            
            
        }
    }
    
    
    public class brandWrapper{ 
        public Brand__c brand{get; set;}
        public String status{get; set;}
        public String lastModifiedDate{get; set;}
        public brandWrapper(Brand__c brand, Date enteredDate, String dateFormat2, String dateFormat,String userTimeZone){
            this.brand= brand; 
            
            lastModifiedDate = brand.LastModifiedDate.format(dateFormat2, userTimeZone);
            Date crdt= date.valueOf(brand.CreatedDate.format(dateFormat,userTimeZone ));
            Date lmdt= date.valueOf(brand.LastModifiedDate.format(dateFormat, userTimeZone));            
            if(lmdt>=enteredDate && crdt >= enteredDate){
                status ='Created';
            }else if(lmdt >=enteredDate && crdt < enteredDate){
                status = 'Updated';
            } else{
                status ='N/C';
            }     
            
        }
    }
    
    public class sponListWrapper{
        
        public string SponName{get;set;}
        public String CongressManager{get; set;}
        public String CongressLead{get; set;}
        public String Level{get; set;}
        public String SponsorshipNotes{get; set;}
        public List<brandWrapper> brands{get; set;}
        public String status{get; set;}
        public String lastModifiedDate{get; set;}
        
        public sponListWrapper(string SponName,String CongressManager,String CongressLead,String Level,String SponsorshipNotes,List<brandWrapper> brands, String status, String lastModifiedDate){
            
            this.SponName= SponName;
            this.CongressManager=CongressManager;
            this.CongressLead=CongressLead;
            this.Level=Level;
            this.SponsorshipNotes=SponsorshipNotes;
            this.brands = brands;
            this.status= status;
            this.lastModifiedDate= lastModifiedDate;
            
        }
    }
    public class prodtrListWrapper{
        
        public string PrdtrName{get;set;}
        public String CongressManager{get; set;}
        public String CongressLead{get; set;}
        public String Level{get; set;}
        public Datetime RequestedProDateTime{get; set;}
        public String ProductTheaterNotes{get; set;}
        public String onlyDate{get;set;}
        public String onlyTime{get;set;}
        public List<brandWrapper> brands{get; set;}
        public String status{get; set;}
        public String lastModifiedDate{get; set;}
        
        public prodtrListWrapper(String PrdtrName,String CongressManager,String CongressLead,String Level,Datetime RequestedProDateTime,String ProductTheaterNotes,
                                 String onlyDate, String onlyTime,List<brandWrapper> brands, String status, String lastModifiedDate)
        {
            this.PrdtrName= PrdtrName;
            this.CongressManager=CongressManager;
            this.CongressLead=CongressLead;
            this.Level=Level;
            this.RequestedProDateTime=RequestedProDateTime;
            this.ProductTheaterNotes=ProductTheaterNotes;
            this.onlyDate= onlyDate;
            this.onlyTime= onlyTime;
            this.brands = brands;
            this.status=status;
            this.lastModifiedDate= lastModifiedDate;
        }
    }
    public class sypmListWrapper{
        
        public string SypmName{get;set;}
        public String CongressManager{get; set;}
        public String CongressLead{get; set;}
        public String Level{get; set;}
        public Datetime RequestedSymDateTime{get; set;}
        public String SymposiumNotes{get; set;}
        public String onlyDate{get;set;}
        public String onlyTime{get;set;}
        public List<brandWrapper> brands{get; set;}
        public String status{get; set;}
        public String lastModifiedDate{get; set;}
        
        public sypmListWrapper(string SypmName,String CongressManager,String CongressLead,String Level,String SymposiumNotes,
                               Datetime RequestedSymDateTime,String onlyDate, String onlyTime,List<brandWrapper> brands, String status, String lastModifiedDate)
        {
            this.SypmName= SypmName;
            this.CongressManager=CongressManager;
            this.CongressLead=CongressLead;
            this.Level=Level;
            this.RequestedSymDateTime=RequestedSymDateTime;
            this.SymposiumNotes=SymposiumNotes;
            this.onlyDate= onlyDate;
            this.onlyTime= onlyTime;
            this.brands = brands;
            this.status= status;
            this.lastModifiedDate= lastModifiedDate;
            
        }
    }
    public class mtrmListWrapper{
        public string MtrmName{get;set;}
        public String CongressManager{get; set;}
        public String CongressLead{get; set;}
        public String Level{get; set;}
        public String MeetingRoomNotes{get; set;}
        public List<brandWrapper> brands{get; set;}
        public String status{get; set;}
        public String lastModifiedDate{get; set;}
        
        public mtrmListWrapper(string MtrmName,String CongressManager,String CongressLead,String Level,String MeetingRoomNotes,
                               List<brandWrapper> brands, String status, String lastModifiedDate ){
                                   
                                   this.MtrmName= MtrmName;
                                   this.CongressManager=CongressManager;
                                   this.CongressLead=CongressLead;
                                   this.Level=Level;
                                   this.MeetingRoomNotes=MeetingRoomNotes;
                                   this.brands=brands;
                                   this.status= status;
                                   this.lastModifiedDate= lastModifiedDate;
                                   
                               }
    }
    
    
}