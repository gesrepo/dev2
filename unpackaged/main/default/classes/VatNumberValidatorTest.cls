@isTest
private class VatNumberValidatorTest {
    

    @isTest static void test_method_one() {

      insert new SOPService__c(Name = 'VatServiceEndpoint', URL__c = 'https://uatapi.viad.com/GES/v1/VatService.svc');
          
      SOPAuthentication__c auth = new SOPAuthentication__c();
                 
      VatNumberValidator sapII = new VatNumberValidator();
        
      insert new SOPService__c(Name = 'Default', URL__c = 'https://uatapi.viad.com/GES/v2/SOPService.svc');
            
      auth.Name = 'Login Credentials';
      auth.Password__c = 'sf4GFK@)GJSv674hS/gfht4K{L';
      auth.Username__c = 'Vertiba';
      insert auth;
             
      VatNumberValidator.ValidateVatNumber('test');
      VatNumberValidator.ValidateVatNumber('');
      VatNumberValidator.ValidateVatNumber('GB830914636');
  
    }
}