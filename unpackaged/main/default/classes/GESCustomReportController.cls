global class GESCustomReportController{
    
    public Contact dummy {get; set;}
    public Contact dummy2 {get; set;}
    
    public class LineWrapper{
        public Opportunity exhOpportunity { get; set;}
        public List<Opportunity> avOpps { get; set;}
        public List<Opportunity> hsOpps { get; set;}
        public List<Opportunity> regOpps { get; set;}
        public string exhOpportunityShowName { get; set; }
        public string exhOpportunityPrimeContractorName { get; set; }
        
        public decimal totalAmount { get; set; }
        public void CalculateTotalAmount() {
            totalAmount = 0;
            if (exhOpportunity.Amount != null)
                totalAmount += exhOpportunity.Amount;
            for (Opportunity o : avOpps)
                if (o.Amount != null)
                    totalAmount += o.Amount;
            for (Opportunity o : hsOpps)
                if (o.Amount != null)
                    totalAmount += o.Amount;
            for (Opportunity o : regOpps)
                if (o.Amount != null)
                    totalAmount += o.Amount;
        }
        
        public LineWrapper (Opportunity ehxOpp){
            exhOpportunity = ehxOpp;
            exhOpportunityShowName = exhOpportunity.Show_Name__r.Name;
            exhOpportunityPrimeContractorName = exhOpportunity.Prime_Contractor__r.Name;
            avOpps = new List<Opportunity>();
            hsOpps = new List<Opportunity>();
            regOpps = new List<Opportunity>();
        }
    }
     
    public class FilterWrapper{
        public List<String> lob { get; set;}
        public List<String> stage { get; set;}
        public String fromDate { get; set;}
        public Date fromDateFinal { get; set; }
        public String toDate { get; set;}
        public Date toDateFinal { get; set; }
        public String provider { get; set;}
        public string providerFinal { get; set; }
        public double fromCurrency { get; set;}
        public double toCurrency { get; set;}
        public string location { get; set;}
        
        public Set<string> stageFinal { get; set; }
        public void setUsableValues() {
            // stages
            stageFinal = new Set<String>();
            if(stage != null){
                for(String s : stage){
                    if(s.equals('All Open')){
                        stageFinal.addAll(GESCustomReportController.getOpenStages());
                    } else if(s.equals('All Closed/Won')){
                        stageFinal.addAll(GESCustomReportController.getWonStages());
                    } else {
                        stageFinal.add(s);
                    }
                }
            }
            // from Date
            try {
                String[] strDate = fromDate.split('/');
                Integer myIntDate = integer.valueOf(strDate[1]);
                Integer myIntMonth = integer.valueOf(strDate[0]);
                Integer myIntYear = integer.valueOf(strDate[2]);
                fromDateFinal = Date.newInstance(myIntYear, myIntMonth, myIntDate);
            } catch (Exception ex) {
                fromDateFinal = null;
            }
            // to Date
            try {
                String[] strDate = toDate.split('/');
                Integer myIntDate = integer.valueOf(strDate[1]);
                Integer myIntMonth = integer.valueOf(strDate[0]);
                Integer myIntYear = integer.valueOf(strDate[2]);
                toDateFinal = Date.newInstance(myIntYear, myIntMonth, myIntDate);
            } catch (Exception ex) {
                toDateFinal = null;
            }
            // provider
            if (provider != null && provider != '') {
                providerFinal = '%' + provider + '%';
            } else {
                providerFinal = null;
            }
        }
    }
    
    
    public GESCustomReportController(){
        dummy = new Contact();
        dummy2 = new Contact();
    }
    
    public List<SelectOption> getMyCheckboxLOBs(){
        List<SelectOption> myOptions = new List<SelectOption>();
        myOptions.add(new selectOption('Exhibition','Exhibition')); 
        myOptions.add(new selectOption('AV','AV'));
        myOptions.add(new selectOption('Housing','Housing'));
        myOptions.add(new selectOption('Registration','Registration'));
        return myOptions;
    }
    
    public List<SelectOption> getMyCheckboxStages(){
        List<SelectOption> myOptions = new List<SelectOption>();
        myOptions.add(new selectOption('All Open', 'All Open'));
        myOptions.add(new selectOption('All Closed/Won', 'All Closed/Won'));
        for(String s : getOtherStages()){
            myOptions.add(new selectOption(s,s));
        }
        return myOptions;
    }
    
    public static Set<String> getOpenStages(){
        List<opportunitystage> oppStages = [select apiName from opportunitystage WHERE IsWon = FALSE AND IsClosed = FALSE];
        Set<String> returns = new Set<String>();
        for(opportunitystage o: oppStages){
            returns.add((String)o.apiName);
        }
        return returns;
    }
    
    public static Set<String> getWonStages(){
        List<opportunitystage> oppStages = [select apiName from opportunitystage WHERE IsWon = TRUE];
        Set<String> returns = new Set<String>();
        for(opportunitystage o: oppStages){
            returns.add((String)o.apiName);
        }
        return returns;
    }
    
    public static Set<String> getOtherStages(){
        List<opportunitystage> oppStages = [select apiName from opportunitystage WHERE IsWon = FALSE AND IsClosed = TRUE];
        Set<String> returns = new Set<String>();
        for(opportunitystage o: oppStages){
            returns.add((String)o.apiName);
        }
        // Manually added values
        returns.add('SL1');
        returns.add('SL3');
        returns.add('PO');
        returns.add('PS');
        return returns;
    }
    
    public class DataTablesResponse {
        public List<LineWrapper> data;
    }
    
    private static List<Custom_Report_Record_Type__mdt> recordTypeList;
    private static Set<String> GetRecordTypes(string lob) {
        if (recordTypeList == null) {
            recordTypeList = [SELECT LOB__c, Region__c, Record_Type__c FROM Custom_Report_Record_Type__mdt];
        }
        Set<String> toReturn = new Set<String>();
        for (Custom_Report_Record_Type__mdt recType : recordTypeList) {
            if (recType.LOB__c == lob) {
                toReturn.add(recType.Record_Type__c);
            }
        }
        return toReturn;
    }
    private static Set<String> GetRegionRecordTypes(string region) {
        if (recordTypeList == null) {
            recordTypeList = [SELECT LOB__c, Region__c, Record_Type__c FROM Custom_Report_Record_Type__mdt];
        }
        Set<String> toReturn = new Set<String>();
        for (Custom_Report_Record_Type__mdt recType : recordTypeList) {
            if (recType.Region__c == region) {
                toReturn.add(recType.Record_Type__c);
            }
        }
        return toReturn;
    }
    
    @RemoteAction
    public static DataTablesResponse getOpportunities(List<FilterWrapper> filters){
        Set<String> exhRecordTypes = GetRecordTypes('Exhibition');
        Set<String> AVRecordTypes = GetRecordTypes('AV');
        Set<String> housingRecordTypes = GetRecordTypes('Housing');
        Set<String> regRecordTypes = GetRecordTypes('Registration');
        Set<String> emeaRecordTypes = GetRegionRecordTypes('EMEA');
        Set<String> usRecordTypes = GetRegionRecordTypes('US');
        Set<Id> avExhRelatedOpps = new Set<Id>();
        Set<Id> hsExhRelatedOpps = new Set<Id>();
        Set<Id> regExhRelatedOpps = new Set<Id>();
        Set<Id> exhOppsIds = new Set<Id>();
        List<Opportunity> avOpps = new List<Opportunity>();
        List<Opportunity> exhOpps = new List<Opportunity>();
        List<Opportunity> hsOpps = new List<Opportunity>();
        List<Opportunity> regOpps = new List<Opportunity>();
        //Set<String> stages;
        Boolean avChecked = false;
        Boolean exhChecked = false;
        Boolean hsChecked = false;
        Boolean regChecked = false;
        
        FilterWrapper filter0;
        Set<String> filter0stageFinal;
        Date filter0fromDateFinal;
        Date filter0toDateFinal;
        string filter0providerFinal;
        double filter0fromCurrency;
        double filter0toCurrency;
        string filter0location;
        if (filters.size() > 0) {
            filter0 = filters[0];
            filter0.setUsableValues();
            filter0stageFinal = filter0.stageFinal;
            filter0fromDateFinal = filter0.fromDateFinal;
            filter0toDateFinal = filter0.toDateFinal;
            filter0providerFinal = filter0.providerFinal;
            filter0fromCurrency = filter0.fromCurrency;
            filter0toCurrency = filter0.toCurrency;
            filter0location = filter0.location;
        }
        FilterWrapper filter1;
        Set<String> filter1stageFinal;
        Date filter1fromDateFinal;
        Date filter1toDateFinal;
        string filter1providerFinal;
        double filter1fromCurrency;
        double filter1toCurrency;
        string filter1location;
        if (filters.size() > 1) {
            filter1 = filters[1];
            filter1.setUsableValues();
            filter1stageFinal = filter1.stageFinal;
            filter1fromDateFinal = filter1.fromDateFinal;
            filter1toDateFinal = filter1.toDateFinal;
            filter1providerFinal = filter1.providerFinal;
            filter1fromCurrency = filter1.fromCurrency;
            filter1toCurrency = filter1.toCurrency;
            filter1location = filter1.location;
        }
        FilterWrapper filter2;
        Set<String> filter2stageFinal;
        Date filter2fromDateFinal;
        Date filter2toDateFinal;
        string filter2providerFinal;
        double filter2fromCurrency;
        double filter2toCurrency;
        string filter2location;
        if (filters.size() > 2) {
            filter2 = filters[2];
            filter2.setUsableValues();
            filter2stageFinal = filter2.stageFinal;
            filter2fromDateFinal = filter2.fromDateFinal;
            filter2toDateFinal = filter2.toDateFinal;
            filter2providerFinal = filter2.providerFinal;
            filter2fromCurrency = filter2.fromCurrency;
            filter2toCurrency = filter2.toCurrency;
            filter2location = filter2.location;
        }
        FilterWrapper filter3;
        Set<String> filter3stageFinal;
        Date filter3fromDateFinal;
        Date filter3toDateFinal;
        string filter3providerFinal;
        double filter3fromCurrency;
        double filter3toCurrency;
        string filter3location;
        if (filters.size() > 3) {
            filter3 = filters[3];
            filter3.setUsableValues();
            filter3stageFinal = filter3.stageFinal;
            filter3fromDateFinal = filter3.fromDateFinal;
            filter3toDateFinal = filter3.toDateFinal;
            filter3providerFinal = filter3.providerFinal;
            filter3fromCurrency = filter3.fromCurrency;
            filter3toCurrency = filter3.toCurrency;
            filter3location = filter3.location;
        }

        String avQuery = 'select Name, Show_Occurrence__c, StageName, Amount, Owner.Name, Audio_Visual_Provider__c from Opportunity where RecordType.Name in : AVRecordTypes ';
        for (FilterWrapper filter : filters) {
            string filterCnt = '0';
            if (filter == filter1)
                filterCnt = '1';
            if (filter == filter2)
                filterCnt = '2';
            if (filter == filter3)
                filterCnt = '3';
            for(String s : filter.lob){
                if(s.equals('AV')){
                    avChecked = true;
                    if(filter.stageFinal.size() > 0){
                        avQuery += 'AND StageName in :filter' + filterCnt + 'stageFinal ';
                    }
                    
                    if(filter.fromDateFinal != null){
                        avQuery +='AND Show_Occurrence__r.Show_Close_Date__c >= :filter' + filterCnt + 'fromDateFinal ';
                    }
                    
                    if(filter.toDateFInal != null){
                        avQuery +='AND Show_Occurrence__r.Show_Close_Date__c <= :filter' + filterCnt + 'toDateFinal ';
                    }
                    
                    if(filter.providerFinal != null){
                        avQuery += 'AND Audio_Visual_Provider__c Like :filter' + filterCnt + 'providerFinal ';
                    }
                    
                    if(filter.fromCurrency != null && filter.fromCurrency != 0.0){
                        avQuery +='AND Amount >= :filter' + filterCnt + 'fromCurrency ';
                    }
                    
                    if(filter.toCurrency != null && filter.toCurrency != 0.0){
                        avQuery +='AND Amount <= :filter' + filterCnt + 'toCurrency ';
                    }
                    
                    if(filter.location == 'EMEA'){
                        avQuery +='AND RecordType.Name IN :emeaRecordTypes ';
                    }
                    if(filter.location == 'US'){
                        avQuery +='AND RecordType.Name IN :usRecordTypes ';
                    }
                    
                }
            }
        }
        if (avChecked) {
            System.debug(AVRecordTypes);
            System.debug(filter0stageFinal.contains('SL1'));
            System.debug(filter0fromDateFinal);
            System.debug(filter0toDateFinal);
            avOpps = Database.query(avQuery);
            for(Opportunity o : avOpps){
                System.debug(o.Id);
                avExhRelatedOpps.add(o.Show_Occurrence__c);
                exhOppsIds.add(o.Show_Occurrence__c);
            }
        }
        
        String hsQuery = 'select Name, Show_Occurrence__c, StageName, Amount, Owner.Name, Housing_Provider__c from Opportunity where RecordType.Name in : housingRecordTypes ';
        for (FilterWrapper filter : filters) {
            string filterCnt = '0';
            if (filter == filter1)
                filterCnt = '1';
            if (filter == filter2)
                filterCnt = '2';
            if (filter == filter3)
                filterCnt = '3';
            for(String s : filter.lob){
                if(s.equals('Housing')){
                    hsChecked = true;
                    
                    if(filter.stageFinal.size() > 0){
                        hsQuery += 'AND StageName in :filter' + filterCnt + 'stageFinal ';
                    }
                    
                    if(filter.fromDateFinal != null){
                        hsQuery +='AND Show_Occurrence__r.Show_Close_Date__c >= :filter' + filterCnt + 'fromDateFinal ';
                    }
                    
                    if(filter.toDateFinal != null){
                        hsQuery +='AND Show_Occurrence__r.Show_Close_Date__c <= :filter' + filterCnt + 'toDateFinal ';
                    }
                    
                    if(filter.providerFinal != null){
                        hsQuery += 'AND Housing_Provider__c Like :filter' + filterCnt + 'providerFinal ';
                    }
                    
                    if(filter.fromCurrency != null && filter.fromCurrency != 0.0){
                        hsQuery +='AND Amount >= :filter' + filterCnt + 'fromCurrency ';
                    }
                    
                    if(filter.toCurrency != null && filter.toCurrency != 0.0){
                        hsQuery +='AND Amount <= :filter' + filterCnt + 'toCurrency ';
                    }
                    
                    if(filter.location == 'EMEA'){
                        hsQuery +='AND RecordType.Name IN :emeaRecordTypes ';
                    }
                    if(filter.location == 'US'){
                        hsQuery +='AND RecordType.Name IN :usRecordTypes ';
                    }
                }
            }
        }
        if (hsChecked) {
            hsOpps = Database.query(hsQuery);
            for(Opportunity o : hsOpps){
                hsExhRelatedOpps.add(o.Show_Occurrence__c);
                exhOppsIds.add(o.Show_Occurrence__c);
            }
        }
        
        String regQuery = 'select Name, Show_Occurrence__c, StageName, Amount, Owner.Name, Registration_Provider__c from Opportunity where RecordType.Name in : regRecordTypes ';
        for (FilterWrapper filter : filters) {
            string filterCnt = '0';
            if (filter == filter1)
                filterCnt = '1';
            if (filter == filter2)
                filterCnt = '2';
            if (filter == filter3)
                filterCnt = '3';
            for(String s : filter.lob){
                if(s.equals('Registration')){
                    regChecked = true;
                    
                    if(filter.stageFinal.size() > 0){
                        regQuery += 'AND StageName in :filter' + filterCnt + 'stageFinal ';
                    }
                    
                    if(filter.fromDateFinal != null){
                        regQuery +='AND Show_Occurrence__r.Show_Close_Date__c >= :filter' + filterCnt + 'fromDateFinal ';
                    }
                    
                    if(filter.toDateFinal != null){
                        regQuery +='AND Show_Occurrence__r.Show_Close_Date__c <= :filter' + filterCnt + 'toDateFinal ';
                    }
                    
                    if(filter.providerFinal != null){
                        regQuery += 'AND Registration_Provider__c Like :filter' + filterCnt + 'providerFinal ';
                    }
                    
                    if(filter.fromCurrency != null && filter.fromCurrency != 0.0){
                        regQuery +='AND Amount >= :filter' + filterCnt + 'fromCurrency ';
                    }
                    
                    if(filter.toCurrency != null && filter.toCurrency != 0.0){
                        regQuery +='AND Amount <= :filter' + filterCnt + 'toCurrency ';
                    }
                    
                    if(filter.location == 'EMEA'){
                        regQuery +='AND RecordType.Name IN :emeaRecordTypes ';
                    }
                    if(filter.location == 'US'){
                        regQuery +='AND RecordType.Name IN :usRecordTypes ';
                    }
                    
                }
            }
        }
        if (regChecked) {
            regOpps = Database.query(regQuery);
            for(Opportunity o : regOpps){
                regExhRelatedOpps.add(o.Show_Occurrence__c);
                exhOppsIds.add(o.Show_Occurrence__c);
            }
        }
        
        
        system.debug(avOpps.size());
        system.debug(hsOpps.size());
        system.debug(regOpps.size());
        
        if (regChecked == true)
            exhOppsIds.retainAll(regExhRelatedOpps);
        if (avChecked == true)
            exhOppsIds.retainAll(avExhRelatedOpps);
        if (hsChecked == true)
            exhOppsIds.retainAll(hsExhRelatedOpps);
        
        String exhQuery = 'select Name, Account.Name, Show_Name__r.Name, StageName, Amount, Owner.Name, Prime_Contractor__r.Name from Opportunity where RecordType.Name in : exhRecordTypes ';
        if (avChecked || regChecked || hsChecked) {
            exhQuery += 'AND id in :exhOppsIds ';
        }
        for (FilterWrapper filter : filters) {
            string filterCnt = '0';
            if (filter == filter1)
                filterCnt = '1';
            if (filter == filter2)
                filterCnt = '2';
            if (filter == filter3)
                filterCnt = '3';
            for(String s : filter.lob){
                if(s.equals('Exhibition')){
                    
                    if(filter.stageFinal.size() > 0){
                        exhQuery += 'AND StageName in :filter' + filterCnt + 'stageFinal ';
                    }
                    
                    if(filter.fromDateFinal != null){
                        exhQuery +='AND Show_Close_Date__c >= :filter' + filterCnt + 'fromDateFinal ';
                    }
                    
                    if(filter.toDateFinal != null){
                        exhQuery +='AND Show_Close_Date__c <= :filter' + filterCnt + 'toDateFinal ';
                    }
                    
                    if(filter.providerFinal != null){
                        exhQuery += 'AND Prime_Contractor__r.Name Like :filter' + filterCnt + 'providerFinal ';
                    }
                    
                    if(filter.fromCurrency != null && filter.fromCurrency != 0.0){
                        exhQuery +='AND Amount >= :filter' + filterCnt + 'fromCurrency ';
                    }
                    
                    if(filter.toCurrency != null && filter.toCurrency != 0.0){
                        exhQuery +='AND Amount <= :filter' + filterCnt + 'toCurrency ';
                    }
                    
                    if(filter.location == 'EMEA'){
                        exhQuery +='AND RecordType.Name IN :emeaRecordTypes ';
                    }
                    if(filter.location == 'US'){
                        exhQuery +='AND RecordType.Name IN :usRecordTypes ';
                    }
                }
            }
        }
        system.debug(exhQuery);
        System.debug(exhRecordTypes.contains('Field Security-PS'));
        System.debug(exhOppsIds);
        System.debug(filter0stageFinal);
        System.debug(filter0fromDateFinal);
        System.debug(filter0toDateFinal);
        List<Opportunity> relatedExhOpps = Database.query(exhQuery);
        
        if(avChecked == false){
            avOpps = [select Name, Show_Occurrence__c, StageName, Amount, Owner.Name, Audio_Visual_Provider__c from Opportunity where Show_Occurrence__c in :relatedExhOpps AND RecordType.Name in : avRecordTypes];
        }
        
        if(hsChecked == false){
            hsOpps = [select Name, Show_Occurrence__c, StageName, Amount, Owner.Name, Housing_Provider__c from Opportunity where Show_Occurrence__c in :relatedExhOpps AND RecordType.Name in : housingRecordTypes];
        }
        
        if(regChecked == false){
            regOpps = [select Name, Show_Occurrence__c, StageName, Amount, Owner.Name, Registration_Provider__c from Opportunity where Show_Occurrence__c in :relatedExhOpps AND RecordType.Name in : regRecordTypes];
        }
        
        system.debug(avOpps.size());
        system.debug(hsOpps.size());
        system.debug(regOpps.size());
        
        Map<Id, LineWrapper> theMap = new Map<Id, LineWrapper>();
        
        for(Opportunity o : relatedExhOpps){
            theMap.put(o.Id, new LineWrapper(o));
        }
        
        for(Opportunity o : avOpps){
            if(theMap.containsKey(o.Show_Occurrence__c)){
                theMap.get(o.Show_Occurrence__c).avOpps.add(o);
            }
        }
        
        for(Opportunity o : hsOpps){
            if(theMap.containsKey(o.Show_Occurrence__c)){
                theMap.get(o.Show_Occurrence__c).hsOpps.add(o);
            }
        }
        
        for(Opportunity o : regOpps){
            if(theMap.containsKey(o.Show_Occurrence__c)){
                theMap.get(o.Show_Occurrence__c).regOpps.add(o);
            }
        }
        
         
        
        List<LineWrapper> wrapperList = new List<LineWrapper>();
        wrapperList.addAll(theMap.values());
        
        for (LineWrapper lw : wrapperList) {
            lw.CalculateTotalAmount();
        }
        
        DataTablesResponse resp = new DataTablesResponse();
        resp.data=wrapperList ;
        return resp;
    }
    
    @RemoteAction
    public static string getOpportunitiesExport(List<FilterWrapper> filters){
        DataTablesResponse resp = getOpportunities(filters);
        string exportStr = '"Account","Show","Exhb Opp","Exhb Stage","Exhb Provider","Exhb Revenue","Exhb Owner","AV Opp","AV Stage","AV Provider","AV Revenue","AV Owner","Housing Opp","Housing Stage","Housing Provider","Housing Revenue","Housing Owner","Reg Opp","Reg Stage","Reg Provider","Reg Revenue","Reg Owner","Total Amount"'; 
        for (LineWrapper lw : resp.data) {
            exportStr += '\n';
            exportStr += '"' + lw.exhOpportunity.Account.Name + '",';
            exportStr += '"' + lw.exhOpportunity.Show_Name__r.Name + '",';
            exportStr += '"' + lw.exhOpportunity.Name + '",';
            exportStr += '"' + lw.exhOpportunity.StageName + '",';
            if (lw.exhOpportunity.Prime_Contractor__r.Name != null)
                exportStr += '"' + lw.exhOpportunity.Prime_Contractor__r.Name + '",';
            else
                exportStr += '"",';
                if (lw.exhOpportunity.Amount != null)
                    exportStr += '"' + lw.exhOpportunity.Amount + '",';
                else
                    exportStr += '"",';
            exportStr += '"' + lw.exhOpportunity.Owner.Name + '",';
            
            // AV
            if (lw.avOpps.size() > 0) {
                exportStr += '"' + lw.avOpps[0].Name + '",';
                exportStr += '"' + lw.avOpps[0].StageName + '",';
                if (lw.avOpps[0].Audio_Visual_Provider__c != null)
                    exportStr += '"' + lw.avOpps[0].Audio_Visual_Provider__c + '",';
                else
                    exportStr += '"",';
                if (lw.avOpps[0].Amount != null)
                    exportStr += '"' + lw.avOpps[0].Amount + '",';
                else
                    exportStr += '"",';
                exportStr += '"' + lw.avOpps[0].Owner.Name + '",';
            } else {
                exportStr += '"","","","","",';
            }
            
            // Housing
            if (lw.hsOpps.size() > 0) {
                exportStr += '"' + lw.hsOpps[0].Name + '",';
                exportStr += '"' + lw.hsOpps[0].StageName + '",';
                if (lw.hsOpps[0].Housing_Provider__c != null)
                    exportStr += '"' + lw.hsOpps[0].Housing_Provider__c + '",';
                else
                    exportStr += '"",';
                if (lw.hsOpps[0].Amount != null)
                    exportStr += '"' + lw.hsOpps[0].Amount + '",';
                else
                    exportStr += '"",';
                exportStr += '"' + lw.hsOpps[0].Owner.Name + '",';
            } else {
                exportStr += '"","","","","",';
            }
            
            // Registration
            if (lw.regOpps.size() > 0) {
                exportStr += '"' + lw.regOpps[0].Name + '",';
                exportStr += '"' + lw.regOpps[0].StageName + '",';
                if (lw.regOpps[0].Registration_Provider__c != null) {
                    exportStr += '"' + lw.regOpps[0].Registration_Provider__c + '",';
                } else {
                    exportStr += '"",';
                }
                if (lw.regOpps[0].Amount != null)
                    exportStr += '"' + lw.regOpps[0].Amount + '",';
                else
                    exportStr += '"",';
                exportStr += '"' + lw.regOpps[0].Owner.Name + '",';
            } else {
                exportStr += '"","","","","",';
            }
            
            exportStr += '' + lw.totalAmount + '';
        }
        
        return exportStr;
    }
}