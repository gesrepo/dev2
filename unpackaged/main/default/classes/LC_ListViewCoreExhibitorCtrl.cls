public class LC_ListViewCoreExhibitorCtrl {

    @AuraEnabled(cacheable=true)
    public static Exhibitorwrapper getShowOccurences(){
        Map<String, String> optionsShowOcc = new Map<String, String>();
        Map<String, String> optionsCountry = new Map<String, String>();

        List<CORE_EXHIBITOR__c> listCoreExhbitior = [SELECT Id, IsManualIntervention__c, Company_Name__c, Name, Occurrence_Id__c, Address1__c, Address_2__c, Address_3__c, Address_4__c,
                                                     Area_Code__c, City__c, Country__c, Phone__c, Postal_Code__c, provinence__c, State__c, Oracle_Key_Index__c, LastModifiedDate, 
                                                     Integration_Error_Message__c 
                                                     FROM CORE_EXHIBITOR__c 
                                                     WHERE Integration_Status__c = 'Failed'
                                                     AND Oracle_Interface_Status__c =  'N'
                                                     ORDER BY Occurrence_Id__c
                                                     LIMIT 2000];
        optionsShowOcc.put('All','All');
        optionsCountry.put('--None--','--None--');
        for (CORE_EXHIBITOR__c instCore : listCoreExhbitior ) {
            if(instCore.Occurrence_Id__c != null && !optionsShowOcc.containsKey(instCore.Occurrence_Id__c)){
                optionsShowOcc.put(instCore.Occurrence_Id__c,instCore.Occurrence_Id__c);
            }
            if(instCore.Country__c != null && !optionsCountry.containsKey(instCore.Country__c)){
                optionsCountry.put(instCore.Country__c,instCore.Country__c);
            }
        }
        Exhibitorwrapper exhWrp = new Exhibitorwrapper(optionsShowOcc,optionsCountry);
        return exhWrp;
    } 
    
    @AuraEnabled
    public static Exhibitorwrapper getExhibitorCountry(String showOccurence){
        Map<String, String> optionsShowOcc = new Map<String, String>();
        Map<String, String> optionsCountry = new Map<String, String>();
        optionsCountry.put('--None--','--None--');
        
        String status = 'Failed' ;
        String query = 'SELECT Id, Country__c'+
            +' FROM CORE_EXHIBITOR__c '+
            +' WHERE Integration_Status__c=\'' + String.escapeSingleQuotes(status)+'\''+
            +'   AND Oracle_Interface_Status__c In (\'N\')';  
        
        if(showOccurence != 'All' && !String.isBlank(showOccurence)){
            query = query+' AND Occurrence_Id__c LIKE \'%' + String.escapeSingleQuotes(showOccurence) + '%\'';
        }
        query = query+' limit 2000';
        List<CORE_EXHIBITOR__c> listCoreExhbitior = database.query(query);
        for (CORE_EXHIBITOR__c instCore : listCoreExhbitior ) {
            if(instCore.Country__c != null && !optionsCountry.containsKey(instCore.Country__c)){
                optionsCountry.put(instCore.Country__c,instCore.Country__c);
            }
        }
        Exhibitorwrapper exhWrp = new Exhibitorwrapper(optionsShowOcc,optionsCountry);
        return exhWrp;
    }
   
    
    @AuraEnabled
    public static List<CORE_EXHIBITOR__c> getCoreExhibitor(String showOccurence, String exhCountry, String searchKey){
        String searchInput = '\'%' + String.escapeSingleQuotes(searchKey) + '%\'';
        String status = 'Failed' ;
        String query = 'SELECT Id, Company_Name__c, Address1__c, Address_2__c, Address_3__c, City__c, State__c, Postal_Code__c, Country__c,Occurrence_Id__c,Integration_Error_Message__c'+
            +' FROM CORE_EXHIBITOR__c '+
            +' WHERE Integration_Status__c=\'' + String.escapeSingleQuotes(status)+'\''+
            +'   AND Oracle_Interface_Status__c In (\'N\')';  
        
        if(showOccurence != 'All' && !String.isBlank(showOccurence)){
            query = query+' AND Occurrence_Id__c LIKE \'%' + String.escapeSingleQuotes(showOccurence) + '%\'';
        }
        if(!String.isBlank(exhCountry) && exhCountry != '--None--'){
            query = query+' AND Country__c = \'' + String.escapeSingleQuotes(exhCountry)+ '\'';
        }
        if(!String.isBlank(searchInput)){
            query = query+' AND (Company_Name__c LIKE ' + searchInput + ' OR Address1__c LIKE ' + searchInput + ' OR Address_2__c LIKE '+searchInput + ' OR Address_3__c LIKE '+searchInput+ ' OR City__c LIKE '+searchInput + ' OR State__c LIKE '+searchInput + ' OR Postal_Code__c LIKE '+searchInput + ' OR Country__c LIKE '+searchInput +' )';
        }
        query = query+' limit 2000';
        List<CORE_EXHIBITOR__c> listCoreExhbitior = database.query(query);
        return listCoreExhbitior;
    }
    
    public class Exhibitorwrapper{
        @AuraEnabled
        public Map<String, String> showOccurance{get; set;}
        @AuraEnabled
        public Map<String, String> exhibitorCountry{get; set;}
        public Exhibitorwrapper(Map<String, String> showOcc, Map<String, String> exhCountry){
            this.showOccurance = showOcc;
            this.exhibitorCountry = exhCountry;
        }
    }
}