global class BatchPastDueAdvancePaymentAlert implements Database.Batchable<SObject>, Database.Stateful {
/*
Author : Scott Fawcett
Date   : Apr 30, 2010

Description
-----------
Batch Apex to put identify records that require 30 day payment notice and send emails.

History
-------
Apr 30, 2010 - Initial Version

*/
public String query; 
public String email;
public Boolean sendWrapUpEmail;
	
global database.querylocator start(Database.BatchableContext BC){return Database.getQueryLocator(query);}
	
	public Integer count = 0;
	
	global void execute(Database.BatchableContext BC, Sobject[] scope){
		
		Set<String> invalidOppRTs = new Set<String>();
		invalidOppRTs.add('E&D - Projects');
		invalidOppRTs.add('E&D - Projects - Proposal');
		invalidOppRTs.add('E&D - Projects - Read Only');
		invalidOppRTs.add('E&D - Projects Public');
		
		Map<Id,RecordType> OppRTMap = new Map<Id, RecordType> ([SELECT ID FROM RecordType WHERE 
																SObjectType = 'Opportunity' AND Name NOT IN : invalidOppRTs]);
		
		Set<String> validStages = new Set<String>();
		validStages.add('CR');
		validStages.add('CV');

		System.debug('scope size is : ' + scope.size());
		
		if (scope.size() > 0) {		
			List<Advance_Payment__c> apToUpdate = new List<Advance_Payment__c>();
			for (Sobject s: scope) {
				Advance_Payment__c ap1 = (Advance_Payment__c)s;		
				System.debug('RecordTypeId : ' + ap1.Show_Occurrence__r.RecordTypeId);
				System.debug('Stage : ' + ap1.Show_Occurrence__r.StageName);	
				if (OppRTMap.containsKey(ap1.Show_Occurrence__r.RecordTypeId) && validStages.contains(ap1.Show_Occurrence__r.StageName)) {
					ap1.sentPastDueNotice__c = true;
					apToUPdate.add(ap1);
				}
			}
			count = apToUpdate.size();
			if (!apToUpdate.isEmpty())
				update apToUpdate;
		} else
			count = 0;	
			System.debug('update Count is : ' + count);
	}

	global void finish(Database.BatchableContext BC){
		
		if (sendWrapUpEmail) {
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			mail.setToAddresses(new String[] {email});
			mail.setReplyTo('admin@ges.com');
			mail.setSenderDisplayName('Salesforce Admin');
			mail.setSubject('Advance Payment Past Due Notice Alert');
			mail.setPlainTextBody('The Batch Process has marked ' + count + ' records for email notification via the workflow.');
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });	
		}	
	}
}