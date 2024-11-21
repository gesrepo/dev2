global class schedule30dayAdvancePaymentAlert implements Schedulable{
/*
Author : Scott Fawcett
Date   : Apr 29, 2010

Description
-----------
Schedulable job to fire Batch30dayAdvancePaymentAlert Apex Class.

History
-------
Apr 29, 2010 - Initial Version

*/
	global void execute(SchedulableContext sc) {
		
		DateTime d30Days = DateTime.now().addDays(30);
		DateTime d6Days = DateTime.now().addDays(6);
		String sd30Days = d30Days.formatGmt('yyyy-MM-dd');
		String sd6Days = d6Days.formatGmt('yyyy-MM-dd');
		
		Batch30dayAdvancePaymentAlert b30 = new Batch30dayAdvancePaymentAlert();
		b30.email = 'sfawcett@astadia.com';
		b30.sendWrapUpEmail = false;
		String query = 'SELECT sent30dayNotice__c, Show_Occurrence__r.StageName, Show_Occurrence__r.RecordTypeID';
		query+= ' FROM Advance_Payment__c WHERE sent30dayNotice__c = false';
		query+= ' AND Date_Paid__c = null AND Advance_Payment_Due_Date__c <=' + sd30Days;
		query+= ' AND Advance_Payment_Due_Date__c >= ' + sd6Days;
		b30.query = query;
		Database.executeBatch(b30);

	}
}