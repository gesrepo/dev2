/**
* @author Ethos Solutions - www.ethos.com
* @description Controller class for Design Element
* 2016-04-13 : Original Version
**/
public with sharing class GC_DESaveController {
    public GC_Design_Element__c de {get; private set;}

    public GC_DESaveController(ApexPages.StandardController sc) {
        if (!Test.isRunningTest()) {
            sc.addFields(new LIST<String> {'Status__c'});
            //sc.addFields(new LIST<String> {'Detailer_Approver__c'});  //Amarab 04062021 SAL-1243 Replacing old Designer/Detailer Approver1 field with new field
            sc.addFields(new LIST<String> {'Contact_Designer_Detailer_Approver1__c'});
        }
        de = (GC_Design_Element__c)sc.getRecord();
        if (de.Status__c == 'New') {
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.Info, 'Design Element Task has been saved but not submitted.  Status: ' + de.Status__c));
        }

        /*if ((GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_CREATIVE_DIRECTOR) || GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_TRAFFIC_ADMIN)) && String.isBlank(de.Detailer_Approver__c)) {
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.Warning, 'Task does not have a Detailer assigned.  Please assign a detailer before approving.'));
        }*/  //Amarab 04062021 SAL-1243 check removed as assignment is now managed in Workfront 
    }
}