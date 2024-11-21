@isTest
private class VatServiceTest {
    
    @isTest static void test_method_one() {
        insert new SOPService__c(Name = 'VatServiceEndpoint', URL__c = 'https://uatapi.viad.com/GES/v1/VatService.svc');
        
        VatService vserv = new VatService();
        
        VatService.Registration reg = new VatService.Registration();
        VatService.CheckVATRegistrationResponse_element rel = new VatService.CheckVATRegistrationResponse_element();
        VatService.CheckVATRegistration_element el = new VatService.CheckVATRegistration_element();
        
      SOPAuthentication__c newAuth = new SOPAuthentication__c();
      newAuth.Name = 'Login Credentials';
      newAuth.Password__c = 'lalalala';
      newAuth.Username__c = 'lalalala';
      insert newAuth;
       
      VatService.BasicHttpBinding_IVATService vat = new VatService.BasicHttpBinding_IVATService();
      try {
      vat.CheckVATRegistration('test','GB','608490336');
      }
      catch (Exception e) {}
 
    }
}