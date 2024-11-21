public with sharing class ICS_Competedcheck{

    public Static void CheckAllChildBoxes(Set<Id> icsID){
        List<Customer_Service_Inquiries_ICS__c> updateList = new List<Customer_Service_Inquiries_ICS__c>();
        Map<id,List<AR_Adjustments__c>> mapParentIDAndChild = new Map<id,List<AR_Adjustments__c>>();
        String queryForParentICS ='SELECT Id,Case_Approval_Status__c,  (SELECT ID, Completed_Transaction__c from ICS_Credit_Memo__r), (SELECT ID, Completed_Transaction__c from Payment_Transfer_ICS__r), (SELECT ID, Completed_Transaction__c from Charges__r), (SELECT ID, Completed_Transaction__c from Refunds_ICS__r),  (SELECT ID, Completed_Transaction__c from Receipt_Reversals__r), (SELECT ID, Completed_Transaction__c from AR_Adjustments_Approvals__r) from Customer_Service_Inquiries_ICS__c WHERE ID IN: icsID';
        // String queryForParentICS ='SELECT Id,Case_Approval_Status__c, (SELECT ID, Completed_Transaction__c from ICS_Credit_Memo__r) from Customer_Service_Inquiries_ICS__c WHERE ID IN: icsID';
        updateList= database.query(queryForParentICS);
        for(Customer_Service_Inquiries_ICS__c parent : updateList ){
                Integer countOfAllCheckBoxes=0;
                Integer counter=0;
                    
                    countOfAllCheckBoxes+= parent.AR_Adjustments_Approvals__r.size();
                        countOfAllCheckBoxes+= parent.Receipt_Reversals__r.size();
                        countOfAllCheckBoxes+= parent.ICS_Credit_Memo__r.size();
                        countOfAllCheckBoxes+= parent.Refunds_ICS__r.size();
                        countOfAllCheckBoxes+= parent.Charges__r.size();
            countOfAllCheckBoxes+= parent.Payment_Transfer_ICS__r.size();

            for(AR_Adjustments__c AR : parent.AR_Adjustments_Approvals__r){
                if(AR.Completed_Transaction__c==true)
                {
                 counter+=1;
                } 
             } 
                                                 
             for(Receipt_Reversals__c RR : parent.Receipt_Reversals__r){
                if(RR.Completed_Transaction__c==true)
                {
                 counter+=1;
                } 
             } 
                                                 
                for(Credit_Memo_ICS__c CM : parent.ICS_Credit_Memo__r){
                if(CM.Completed_Transaction__c==true)
                {
                 counter+=1;
                } 
             } 
        for(Refunds_ICS__c RF : parent.Refunds_ICS__r){
                if(RF.Completed_Transaction__c==true)
                {
                 counter+=1;
                } 
             } 
        for(Charges__c CH : parent.Charges__r){
                if(CH.Completed_Transaction__c==true)
                {
                 counter+=1;
                } 
             } 
        for(Payment_Transfer_ICS__c PT : parent.Payment_Transfer_ICS__r){
                if(PT.Completed_Transaction__c==true)
                {
                 counter+=1;
                } 
             } 
            if(countOfAllCheckBoxes==counter  && parent.Case_Approval_Status__c=='Case Approved'){
                parent.Case_Approval_Status__c='Case Closed';
            }
        }
        update updateList;
    }

}