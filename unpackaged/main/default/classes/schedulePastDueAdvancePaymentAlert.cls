global class schedulePastDueAdvancePaymentAlert implements Schedulable{
/*
Author : Scott Fawcett
Date   : Apr 30, 2010

Description
-----------
Schedulable job to fire BatchPastDueAdvancePaymentAlert Apex Class.

History
-------
Apr 30, 2010 - Initial Version

*/
	global void execute(SchedulableContext sc) {
		
		DateTime d0Days = DateTime.now();
		String sd0Days = d0Days.formatGmt('yyyy-MM-dd');
		
		BatchPastDueAdvancePaymentAlert pd = new BatchPastDueAdvancePaymentAlert();
		pd.email = 'sfawcett@astadia.com';
		pd.sendWrapUpEmail = false;
		String query = 'SELECT sentPastDueNotice__c, sent30dayNotice__c, sent5dayNotice__c,';
		query+= ' Show_Occurrence__r.StageName, Show_Occurrence__r.RecordTypeID';
		query+= ' FROM Advance_Payment__c WHERE sent5dayNotice__c = false AND sentPastDueNotice__c = false';
		query+= ' AND sent30dayNotice__c = false AND Date_Paid__c = null AND Advance_Payment_Due_Date__c <' + sd0Days;
		pd.query = query;
		Database.executeBatch(pd);

	}
}