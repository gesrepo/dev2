/**
* @author       Nikhil Vedi
* @date         05/03/2018
**/
public class WorkersCompensationController {

	public ApexPages.standardController stdController {get; set;}
	public Boolean hasIncidentCreated {get; set;}
	public Claims__Incident_Report__c report {get; set;}
	public String selectedType {get; set;}
	public Boolean notSubmitted {get; private set;}
	public Attachment attach {get; set;}
	public List<String> attachments {get; private set;}


	/**
	* @description  Constructor.
	**/
	public WorkersCompensationController(ApexPages.standardController controller) {
		this.stdController = controller;
		Claims__Incident_Report__c incidentReport =
		    (Claims__Incident_Report__c)this.stdController.getRecord();
	}

	/**
	* @date         13/04/2018
	* @description  Save the incident report.
	**/
	public Pagereference Save() {
		notSubmitted = false;
		PageReference pg = saveIncident();
		return pg;
	}

	/**
	* @date         13/02/2017
	* @description  Save incident as "In Progress".
	**/
	public Pagereference saveWithoutSubmission() {
		notSubmitted = true;
		PageReference pg = saveIncident();
		return pg;
	}

	/**
	* @date         13/02/2017
	* @description  Helper method for saving incident.
	**/
	private Pagereference saveIncident() {
		Claims__Incident_Report__c incident = (Claims__Incident_Report__c)stdController.getRecord();

		try {
			this.report = incident;
			incident.recordTypeId = getRecordTypeIdByName(constants.WORKERSCOMPENSATION);
			
			//required fields not wanted on layout
			String fullName = incident.Claims__Report_Completed_By__c;
			incident.Claims__First_Name__c = fullName.substringBefore(' ');
            incident.Claims__Last_Name__c = fullName.substringAfter(' ');

			incident.In_Progress_Report__c = notSubmitted;
			insert incident;
			if (incident.Id != null) {
				hasIncidentCreated = true;
			}

		} catch (Exception ex) {
			System.debug(ex.getMessage());
			Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
		}
		attach = new Attachment();
		attachments = new List<String>();
		return Page.WebSupervisorReportAttach;
	}

	/**
	* @date         13/04/2018
	* @description  Save the attachments related to the incident report.
	**/
	public Pagereference saveAttachment() {
		try {
			attach.ParentId = report.Id;
			insert attach;
		} catch (Exception e) {
			Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage()));
			return null;
		}
		attachments.add(attach.Name);
		attach = new Attachment();
		return null;
	}

	/**
	* @date         13/04/2018
	* @description  return the Workers Comp Thanks Page thanks page.
	**/
	public Pagereference submitReport() {
		if (!Apexpages.hasMessages()) {
			notSubmitted = false;
			return Page.WorkersCompThanks;
		} else {
			return null;
		}
	}

	/**
	* @description  return the Workers Comp Thanks Page with message "not submitted".
	**/
	public Pagereference saveWithoutSubmitReport() {
		if (!Apexpages.hasMessages() && report != null && report.Id != null) {
			notSubmitted = true;
			List<Claims__Incident_Report__c> reports = [SELECT Id, Name
			        									FROM Claims__Incident_Report__c
			        									WHERE Id = :report.Id];
			if (reports.size() > 0) {
				report = reports[0];
			}
			return Page.WorkersCompThanks;
		} else {
			return null;
		}
	}

	/**
	* @description  Get Record type by Name.
	**/
	private Id getRecordTypeIdByName(String rtName) {
		if (! String.isBlank(rtName)) {
			RecordType[] rts = [SELECT Id FROM RecordType
			                    WHERE developerName =
			                        :rtName AND sObjectType = 'Claims__Incident_Report__c'];
			if (! rts.isEmpty()) {
				return rts[0].Id;
			}
		}
		return null;
	}
}