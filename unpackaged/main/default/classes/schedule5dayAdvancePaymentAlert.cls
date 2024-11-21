global class schedule5dayAdvancePaymentAlert implements Schedulable{
/*
Author : Scott Fawcett
Date   : Apr 29, 2010

Description
-----------
Schedulable job to fire Batch5dayAdvancePaymentAlert Apex Class.

History
-------
Apr 29, 2010 - Initial Version

*/
	global void execute(SchedulableContext sc) {
		
		DateTime d0Days = DateTime.now();
		DateTime d5Days = DateTime.now().addDays(5);
		String sd0Days = d0Days.formatGmt('yyyy-MM-dd');
		String sd5Days = d5Days.formatGmt('yyyy-MM-dd');
		
		Batch5dayAdvancePaymentAlert b5 = new Batch5dayAdvancePaymentAlert();
		b5.email = 'sfawcett@astadia.com';
		b5.sendWrapUpEmail = false;
		String query = 'SELECT sent5dayNotice__c, Show_Occurrence__r.StageName, Show_Occurrence__r.RecordTypeID';
		query+= ' FROM Advance_Payment__c WHERE sent5dayNotice__c = false';
		query+= ' AND Date_Paid__c = null AND Advance_Payment_Due_Date__c <=' + sd5Days;
		// if the query should "look" into the past, this line should be commented out.
		query+= ' AND Advance_Payment_Due_Date__c >= ' + sd0Days;
		b5.query = query;
		Database.executeBatch(b5);

	}
}