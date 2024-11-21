/**
    @@ author rahul k sinha For SLK Software Services
    @@ original version 21-03-2018
    @@ description - used to create the Submit to Vendors functionality on the default view page of VOT task
**/

global class GC_VOTSubmitForApproval {
    webservice static Boolean submitRecord(Id votRecordId) {
        //String votId = ApexPages.currentPage().getParameters().get('votId');
        //String showId = ApexPages.currentPage().getParameters().get('showId');
        
        GC_Vendor_Order_Task__c vot = new GC_Vendor_Order_Task__c();
        GC_Connect2_Show__c show = new GC_Connect2_Show__c();
        try{
            vot= GC_VendorOrderTaskDao.getInstance().getVendorOrderTaskById(votRecordId);
            show=GC_Connect2ShowDao.getInstance().getConnect2ShowById(vot.Order__r.Connect2_Show__c);
        }catch(exception e){
            system.debug('error==='+ e.getStackTraceString());
            system.debug('error==='+ e.getMessage());
        }

        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();

        if (vot.Vendor__c != null) {
            emailMessages.add(GC_OrderUtils.generateVendorEmail(vot, vot.Vendor__c,show.Name+' - '+show.Show_Name__c,vot.Service_Type__r.Name));
        }

        if (vot.Vendor2__c != null) {
            emailMessages.add(GC_OrderUtils.generateVendorEmail(vot, vot.Vendor2__c,show.Name+' - '+show.Show_Name__c,vot.Service_Type2__r.Name));
        }

        if (vot.Vendor3__c != null) {
            emailMessages.add(GC_OrderUtils.generateVendorEmail(vot, vot.Vendor3__c,show.Name+' - '+show.Show_Name__c,vot.Service_Type3__r.Name));
        }

        if (vot.Vendor4__c != null) {
            emailMessages.add(GC_OrderUtils.generateVendorEmail(vot, vot.Vendor4__c,show.Name+' - '+show.Show_Name__c,vot.Service_Type4__r.Name));
        }

        if (vot.Vendor5__c != null) {
            emailMessages.add(GC_OrderUtils.generateVendorEmail(vot, vot.Vendor5__c,show.Name+' - '+show.Show_Name__c,vot.Service_Type5__r.Name));
        }

        //set allOrNone to false to allow non-error messages to be sent even if some fail
        try{
            Messaging.sendEmail(emailMessages, false);
            vot.Status__c = 'Sent';
            vot.Submitted_Date__c = Date.today();
            update vot;
            return true;
        }catch(exception e){
            system.debug('error==='+ e.getStackTraceString());
            system.debug('error==='+ e.getMessage());
            return false;
        }
        

    }
}