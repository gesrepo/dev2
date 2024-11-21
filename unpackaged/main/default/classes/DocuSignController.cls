public with sharing class DocuSignController {
    
    @AuraEnabled
    public static String createDocuSignEnvelope(Id agreementId) {
        // Fetch the Agreement object to get related fields
        Agreements__c agreement = [SELECT Id,If_no_credit_check_what_is_the_reason__c, Credit_Limit__c, CurrencyIsoCode, Contract_Credit_Payment_Terms__c, 
                                   Credit_Check_Required__c, Is_Repeat_Contract__c, Total_Contract_Value__c,Current_Shell_Scheme_Price_Per_SQM__c,
                                   Previous_Shell_Scheme_Price_Per_SQM__c,Shell_Scheme_Price_Change__c,Current_Carpet_Price_Per_SQM__c,Previous_Carpet_Price_Per_SQM__c,Carpet_Price_Change__c,
                                   Contact__c FROM Agreements__c WHERE Id = :agreementId LIMIT 1];
        
        // Retrieve the related Contact
        List<Contact> contacts = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Id = :agreement.Contact__c LIMIT 1];
        if(contacts.isEmpty())
            return 'No Contact';
        String note = ' Credit limit is ' + (agreement.Credit_Limit__c != null?agreement.CurrencyIsoCode +' '+ String.valueOf(agreement.Credit_Limit__c):'');
        
        if (agreement.Credit_Check_Required__c == 'Yes')
            note += '. A credit check is required';
        else
            note += '. A credit check is not required - '+(agreement.If_no_credit_check_what_is_the_reason__c != null?String.valueOf(agreement.If_no_credit_check_what_is_the_reason__c):'');
        
        note += '.Payment terms: '+(agreement.Contract_Credit_Payment_Terms__c != null?String.valueOf(agreement.Contract_Credit_Payment_Terms__c):'');
        if(agreement.Is_Repeat_Contract__c)
            note += '.Shell scheme price is '+(agreement.Current_Shell_Scheme_Price_Per_SQM__c!=null?agreement.CurrencyIsoCode +' '+ String.valueOf(agreement.Current_Shell_Scheme_Price_Per_SQM__c):'')+' per SQM ('+(agreement.Previous_Shell_Scheme_Price_Per_SQM__c != null?agreement.CurrencyIsoCode +' '+ String.valueOf(agreement.Previous_Shell_Scheme_Price_Per_SQM__c):'')+' last year) a change of '+(agreement.Shell_Scheme_Price_Change__c != null?String.valueOf(agreement.Shell_Scheme_Price_Change__c):'')+'%25. Carpet price is '+(agreement.Current_Carpet_Price_Per_SQM__c != null?agreement.CurrencyIsoCode +' '+ String.valueOf(agreement.Current_Carpet_Price_Per_SQM__c):'')+' per SQM ('+(agreement.Previous_Carpet_Price_Per_SQM__c != null?agreement.CurrencyIsoCode +' '+ String.valueOf(agreement.Previous_Carpet_Price_Per_SQM__c):'')+' last year) a change of '+(agreement.Carpet_Price_Change__c != null?String.valueOf(agreement.Carpet_Price_Change__c):'')+'%25.';
        else
            note += '.This is a new contract.';
        note += 'Total contract value: '+(agreement.Total_Contract_Value__c!=null?String.valueOf(agreement.Total_Contract_Value__c):'')+'.';
        note=note.replaceAll(';','.').replaceAll(',','.');
        String CRL = '';
        if(agreement.Total_Contract_Value__c <= 375000)
            CRL= 'Email~nmuhammed@ges.com;FirstName~Graham;LastName~Archer;Role~Signer 2;RoutingOrder~2;RecipientNote~';
        else
            CRL= 'Email~nmuhammed@ges.com;FirstName~Jason;LastName~Stead;Role~Signer 2;RoutingOrder~2;RecipientNote~';
        
        CRL=CRL+note +',Email~' + contacts[0].Email + ';FirstName~' + contacts[0].FirstName + ';LastName~' + contacts[0].LastName + ';Role~Signer 3;RoutingOrder~3,;LoadDefaultContacts~0';
        PageReference vfPage = Page.dsfs__DocuSign_CreateEnvelope;  // 'MyVisualforcePage' is the name of your Visualforce page
        vfPage.getParameters().put('DSEID', '0');
        vfPage.getParameters().put('SourceID', agreementId);
        vfPage.getParameters().put('CRL', CRL);
        vfPage.getParameters().put('LA', '1');
        String url = vfPage.getUrl();
        system.debug(url);
        
        return url;
    }
}