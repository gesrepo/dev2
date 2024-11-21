public class BatchableDNBIDRCallOutOnCoreExihibitor implements Database.Batchable<sObject>, Database.AllowsCallOuts
{
    public BatchableDNBIDRCallOutOnCoreExihibitor()
    {
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator([SELECT Id, Company_Name__c,Address1__c, Address_2__c,Address_3__c,Address_4__c,Counter__c,City__c, State__c, Postal_Code__c, Country__c
                                         FROM CORE_EXHIBITOR__c 
                                         WHERE Integration_Status__c = null
                                         AND Oracle_Interface_Status__c =  'N']);
    }
    
    public void execute(Database.BatchableContext BC, List<CORE_EXHIBITOR__c> scope)
    {
        DNBIDRDUNSCallout.AuthorizationResponse aResp = DNBIDRDUNSCallout.getAuthToken();
        system.debug('aResp..!'+aResp); 
        
        list<CORE_EXHIBITOR__c> coreExhibitsToUpdate = new list<CORE_EXHIBITOR__c>();
        list<APEXLog__c> logsToInsert = new list<APEXLog__c>();
        if(aResp.isError)
        {
            //log error
            APEXLog__c log = new APEXLog__c(); 
            log.ClassName__c = 'BatchableDNBIDRCallOutOnCoreExihibitor';
            log.Message__c = aResp.message;
            log.StackTrace__c = '';
            log.Method__c = 'execute_authcallout';      
            log.RecordId_Data__c = aResp.payload;                       
            logsToInsert.add(log);
            
            for(CORE_EXHIBITOR__c ch : scope)
            {
                ch.Integration_Status__c = 'Failed';
                ch.Integration_Error_Message__c = aResp.message;
                coreExhibitsToUpdate.add(ch);
            }
        }
        else
        {
            //do callout            
            for(CORE_EXHIBITOR__c ch : scope)
            {
                DNBIDRDUNSCallout.DNBIDRDUNSCalloutResponse dResp = DNBIDRDUNSCallout.getDUNSResponse(ch, aResp.access_token);
                system.debug('dResp..!'+dResp);
                if(dResp.isError)
                {
                    APEXLog__c log = new APEXLog__c(); 
                    log.ClassName__c = 'BatchableDNBIDRCallOutOnCoreExihibitor';
                    log.Message__c = dResp.message;
                    log.StackTrace__c = '';
                    log.Method__c = 'execute_dunscallout';      
                    log.RecordId_Data__c = dResp.payload;                       
                    logsToInsert.add(log);
                    
                    ch.Integration_Status__c = 'Failed';
                    if(dResp.message == 'No Match found for the given input criteria'){
                        ch.Oracle_Interface_Status__c = 'P';
                    }
                    ch.Integration_Error_Message__c = dResp.message;
                    coreExhibitsToUpdate.add(ch);
                }
                else
                {
                    ch.DUNS_Number__c = dResp.dunsNumber;
                    ch.Match_Confidence__c = dResp.confidenceCode;                    
                    ch.Company_Name__c = dResp.cleanseAndStandardizeInformation.standardizedName;
                    ch.Address1__c = dResp.cleanseAndStandardizeInformation.standardizedAddress.streetAddress.line1;
                    ch.Address_2__c = dResp.cleanseAndStandardizeInformation.standardizedAddress.streetAddress.line2;
                    ch.City__c = dResp.cleanseAndStandardizeInformation.standardizedAddress.addressLocality.name;
                    ch.Country__c = dResp.cleanseAndStandardizeInformation.standardizedAddress.addressCountry.isoAlpha2Code;
                                        
                    if(ch.Country__c == 'US'){
                        ch.State__c = dResp.cleanseAndStandardizeInformation.standardizedAddress.addressRegion.abbreviatedName;
                    }else {
                        ch.State__c = dResp.cleanseAndStandardizeInformation.standardizedAddress.addressRegion.name;
                    }
                    list<String> postalCodes = new list<String>();
                    if(String.isNotBlank(dResp.cleanseAndStandardizeInformation.standardizedAddress.postalCode)){
                        postalCodes.add(dResp.cleanseAndStandardizeInformation.standardizedAddress.postalCode);
                    }
                    if(String.isNotBlank(dResp.cleanseAndStandardizeInformation.standardizedAddress.postalCodeExtension)){
                        postalCodes.add(dResp.cleanseAndStandardizeInformation.standardizedAddress.postalCodeExtension);
                    }
                    if(!postalCodes.isEmpty()){
                        ch.Postal_Code__c = String.join(postalCodes, '-');
                    }
                    
                    ch.Integration_Status__c = 'Success';
                    ch.Oracle_Interface_Status__c = 'P';
                    ch.IsManualIntervention__c = false;
                    coreExhibitsToUpdate.add(ch);
                }
            }            
        }
        if(aResp.mode == 'INSERT')
        {
            Auth_Token__c token = new Auth_Token__c();
            token.Auth_Token__c = aResp.access_token;
            token.Name = 'DNBIDR';
            insert token;
        }
        else if(aResp.mode == 'UPDATE')
        {
            list<Auth_Token__c> tokens = [SELECT Id, Name, Auth_Token__c, LastModifiedDate
                                          FROM Auth_Token__c 
                                          WHERE Name = 'DNBIDR'];
            for(Auth_Token__c token : tokens)
            {
                token.Auth_Token__c = aResp.access_token;
            }
            update tokens;
        }
        if(!coreExhibitsToUpdate.isEmpty()){
            update coreExhibitsToUpdate;
        }
        if(!logsToInsert.isEmpty()){
            insert logsToInsert;
        }                
        
        
        Integer wLimit = 2000;        //2000 will apply if there is no value in label
        if(String.isNotBlank(Label.DNBIDRAPI_TPS_Limit)){
            wLimit = Integer.valueOf(Label.DNBIDRAPI_TPS_Limit);
        }
        
        //Delay for 2s
        Long startTime = DateTime.now().getTime();
        Long finishTime = DateTime.now().getTime();
        
        while((finishTime - startTime) < wLimit) {        
            finishTime = DateTime.now().getTime();
        }
    }
    
    public void finish(Database.BatchableContext BC)
    {
    }
}