global with sharing class VatNumberValidator {
    private static string GetAuthenticatedSessionId(string userName, string pwd){
        
        SOP_wwwViadComSecurityV2.AppSessionInfo sessionInfo;
        
        System.debug('Username: ' + userName + ', password: ' + pwd);
        try{
            sessionInfo = SOP_APIIntegration.authenticate(userName, pwd);
        }
        catch(exception e){
            system.debug('*********************ERROR: '+e.getMessage());
        }
        if (sessionInfo != null) {
            system.debug(sessionInfo.SessionId);
            return sessionInfo.SessionId;
        }
        else {
            return null;
        }
    }
    
    webService static String ValidateVatNumber(string vatNumber) {
        if (vatNumber.length() == 0){
            return 'Please enter a Vat Number';
        }
        
        VatService.Registration reg = new VatService.Registration();
        // Get country code from vat number
        string countryCode = vatNumber.substring(0, 2);
        string vatNumberWithoutCountryCode = vatNumber.substring(3);
        VatService vat = new VatService();
        //#394590 Use new VAT Service API only if the country code is GB 04-04-2024 --- start
        if(countryCode == 'GB'){
            String result = vat.CheckVATRegistrationForUk(vatNumber.remove(countryCode));
            Map<String, Object> resMap = (Map<String, Object>) JSON.deserializeUntyped(result);
            if(resMap.containsKey('target')){
                Map<String, Object> resSuccessMap = (Map<String, Object>)resMap.get('target');
                resSuccessMap = getAddress(resSuccessMap);
                reg.Address = (String)resSuccessMap.get('addressCustom');
                reg.Name = (String)resSuccessMap.get('name');
            }else{
                reg.ErrorMessage = 'Invalid';
            }
        }
        //#394590 Use new VAT Service API only if the country code is GB 04-04-2024 --- end
        else{
            String result = vat.CheckVATRegistration(countryCode, vatNumber.remove(countryCode));
            Map<String, Object> resMap = (Map<String, Object>) JSON.deserializeUntyped(result);
            if(resMap.containsKey('valid') && (Boolean)resMap.get('valid')){
                reg.Address = (String)resMap.get('address');
                reg.Name = (String)resMap.get('name');
            }else
                reg.ErrorMessage = 'Invalid';
        }
        
        
        if (reg.ErrorMessage == null){
            string addressString = reg.Address;
            //#394590 added condition to avoid null pointer exception - old code : string cleanAddress = addressString.replaceAll('\r\n', ', '); 04-04-2024
            string cleanAddress = addressString != null? addressString.replaceAll('\r\n', ', ') : '';
            cleanAddress = cleanAddress.replaceAll('\n', ', ');
            cleanAddress = cleanAddress.replaceAll('\r', ', ');
            cleanAddress = cleanAddress.replaceAll('\t', ' ');
            string companyNameString = reg.Name;
            string vatNumberStatus = 'valid';
            string json = '{ \n "Address" : " ' + cleanAddress + '",\n "Name": "' + companyNameString + '", \n"Status": "valid" \n}';
            system.debug('Returned reg details are: ' + reg);
            system.debug(json);
            system.debug('Vat number ' + vatNumber + ' is valid.');
            return json;
        }
        
        system.debug('Vat number ' + vatNumber + ' is invalid.');
        return 'Invalid';
    }    
    
    //#394590 converting JSON response into address format - 04-04-2024
    public static Map<String, Object> getAddress(Map<String, Object> resSuccessMap){
        Map<String, Object> resAddressMap = (Map<String, Object>)resSuccessMap.get('address');
        if(resAddressMap != null){
            String address = resAddressMap.get('line1') != null ?resAddressMap.get('line1')+', ':'';
            address += resAddressMap.get('line2') != null ?resAddressMap.get('line2')+', ':'';
            address += resAddressMap.get('line3') != null ?resAddressMap.get('line3')+', ':'';
            address += resAddressMap.get('postcode') != null ?resAddressMap.get('postcode'):'';
            address = address.removeEnd(', ');
            resSuccessMap.put('addressCustom',address);
        }
        return resSuccessMap;
    }
    
}