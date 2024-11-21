/**
  * @author Andy Evans
  * @date 5/5/2014
  * @description This is a copy of the controller for the incident report entry page for customization purposes.
  * @author Paul Battisson
  * @date 26/4/2012
  * @description This is the controller for the incident report entry page. The page is a sites page allowing you to report an incident orf a certain type.
  */

public class WebIncidentReportController_Custom {

    public Claims__Incident_Report__c report {get; set;}
    public List<Selectoption> incidentTypes {get; private set;}
    public String logoURL {get; private set;}
    public String selectedType {get; set;}
    public List<String> attachments {get; private set;}
    public Attachment attach {get; set;}
    public Map<Id, String> typeMap {get; private set;}
    private WebIncidentReportController_Custom controller;
    private ApexPages.standardController stdController;
    public String recordTypeName {get; private set;}
    public Boolean notSubmitted {get; private set;}
    public String searchString {get; set;}
    public List<Claims__Incident_Report__c> availableReports {get; private set;}
    public String selectedReport {get; set;}
    public String selectedAction {get; set;}

    /**
    * @author       Swathi Dhoddusamy
    * @date         31/05/2016
    * @description  Constructor
    **/
    public WebIncidentReportController_Custom() {
        notSubmitted = false;
        searchString = '';

        report = new Claims__Incident_Report__c();
        typeMap = new Map<Id, String>();
        generateIncidentTypes();
        Document[] docs = [Select Id, DeveloperName  from Document where DeveloperName = 'GES_Logo'];
        if (docs.size() == 1) {
            logoURL =  '/servlet/servlet.FileDownload?file=' + docs[0].Id;
        } else {
            logoURL = '';
        }
    }

    /**
    * @author       Swathi Dhoddusamy
    * @date         31/05/2016
    * @description  Search incidents
    **/
    public Pagereference searchIncidents() {
        searchString = String.escapeSingleQuotes(searchString);
        searchString.replace(' ', '');

        if (! searchString.startsWith('IR-')) {
            //error on invalid ID format.
            this.report = null;
            this.recordTypeName = null;
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'Invalid ID format.'));
            return null;
        }

        Schema.DescribeSObjectResult objDes  = Claims__Incident_Report__c.SObjectType.getDescribe();

        Map<String, Schema.SObjectField> fieldMap = objDes.fields.getMap();
        List<String> fdNames = new List<String>();

        for (String fd : fieldMap.keySet()) {
            if (fd.equalsIgnoreCase('Name') || fd.equalsIgnoreCase('Id') || fd.endsWith('__c')) {
                fdNames.add(fd);
            }
        }
        String queryStr = 'SELECT RecordTypeId, RecordType.Name, ' + String.join(fdNames, ',');
        queryStr += ' FROM Claims__Incident_Report__c WHERE Name = :searchString';

        availableReports = Database.query(queryStr);

        if (availableReports.size() > 0) {
            this.report = availableReports[0];
            this.recordTypeName = availableReports[0].RecordType.Name;
        } else {
            this.report = null;
            this.recordTypeName = null;
        }
        return null;
    }

    /**
    * @author       Swathi Dhoddusamy
    * @date         31/05/2016
    * @description  Constructor taking standard controller as a parameter
    **/
    public WebIncidentReportController_Custom(ApexPages.standardController controller) {
        this();
        this.stdController = controller;
        Claims__Incident_Report__c incidentReport = (Claims__Incident_Report__c)this.stdController.getRecord();
        this.report.recordTypeId = incidentReport.recordTypeId;
        this.recordTypeName = SchemaHelper.getRecordTypeInfosById(Claims__Incident_Report__c.sObjectType.getDescribe().getName(), (Id)incidentReport.recordTypeId);
    }

    /**
    * @author       Swathi Dhoddusamy
    * @date         05/03/2018 - Nikhil (updated)
    * @description  Get the list of incident record types
    **/
    private void generateIncidentTypes() {
        incidentTypes = new List<Selectoption>();
        incidentTypes.add(new Selectoption('--None--', '--None--'));
        typeMap.put(null, '');
        for (RecordType recordType : [Select r.SobjectType, r.Name, r.Id, r.DeveloperName From RecordType r where SobjectType = :String.ValueOf(Claims__Incident_Report__c.SObjectType) AND IsActive = true]) {
            if (recordType.DeveloperName != Constants.INCIDENT_INPROGRESS_RT) {
                if (RecordType.name != Constants.CLAIM_WORKERS_COMPENSATION_RECORDTYPE) {
                    incidentTypes.add(new Selectoption((String)recordType.Id, recordType.Name));
                    typeMap.put(recordType.Id, recordType.Name);
                }
            }
        }
    }

    /**
    * @author       Swathi Dhoddusamy
    * @date         31/05/2016
    * @description  Method to set the record type name after the record type is chosen from the list on the page
    **/
    public void setRecordTypeName() {
        if (!String.isBlank(this.selectedType) && selectedType != '--None--') {
            this.recordTypeName =
                SchemaHelper.getRecordTypeInfosById(Claims__Incident_Report__c.sObjectType.getDescribe().getName(),
                                                    (Id)this.selectedType);
            this.report.recordTypeId = (Id)this.selectedType;
        } else {
            recordTypeName = null;
        }
    }

    /**
    * @author       Swathi Dhoddusamy
    * @date         31/05/2016
    * @description  Method to return the controller
    **/
    public WebIncidentReportController_Custom getController() {
        if (this.controller == null) {
            this.controller = this;
        }
        return this.controller;
    }

    /**
    * @author       Swathi Dhoddusamy
    * @date         31/05/2016
    * @description  returns true if the selected record type is a motor type
    **/
    public Boolean getIsMotor() {
        return typeMap.get(selectedType) == System.Label.Motor;
    }

    /**
    * @author       Swathi Dhoddusamy
    * @date         31/05/2016
    * @description  returns true if the selected record type is a motor type
    **/
    public boolean getIsTheft() {
        return typeMap.get(selectedType) == System.Label.Theft;
    }

    /**
    * @author       Swathi Dhoddusamy
    * @date         31/05/2016
    * @description  Save the incident report
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
    public Pagereference saveWithouSubmission() {
        notSubmitted = true;
        PageReference pg = saveIncident();
        return pg;
    }

    /**
    * @date         13/02/2017
    * @description  Helper method for saving incident.
    **/
    private Pagereference saveIncident() {
        try {
            report.RecordTypeId = (Id)selectedType;

            if (this.stdController != null) {
                Claims__Incident_Report__c incidentReport = (Claims__Incident_Report__c)this.stdController.getRecord();
                report.recordTypeId = incidentReport.recordTypeId;
            }
            report.In_Progress_Report__c = notSubmitted;
            // update first name
            report.Claims__Report_Completed_By__c = !String.isBlank(report.Preparer_Full_Name__c) ? report.Preparer_Full_Name__c : 'Test';
            report.Claims__First_Name__c = !String.isBlank(report.Preparer_Full_Name__c)
                                           && report.Preparer_Full_Name__c.split(' ').size() > 0 ? splitString(0, 1, report.Preparer_Full_Name__c) : 'Test';
            report.Claims__Last_Name__c = !String.isBlank(report.Preparer_Full_Name__c)
                                          && report.Preparer_Full_Name__c.split(' ').size() > 1 ? splitString(1, report.Preparer_Full_Name__c.split(' ').size(),
                                                  report.Preparer_Full_Name__c) : 'Test';
            report.Claims__Email__c = report.Preparer_Email_Address__c;
            report.Status__c = System.Label.New;
            if (this.recordTypeName == Constants.CLAIM_MOTOR_VEHICLE_RECORDTYPE) report.Claims__Date_Reported__c = System.today();
            upsert report;

            if (this.stdController != null) {
                return new ApexPages.StandardController(report).view();
            }
        } catch (Exception e) {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return null;
        }
        attach = new Attachment();
        attachments = new List<String>();
        return Page.WebIncidentReportAttach;
    }

    /**
    * @author       Swathi Dhoddusamy
    * @description  Split Strings
    **/
    private String splitString(Integer startIndex, Integer endIndex, String fullName) {
        List<String> namesList = new List<String>();
        for (Integer i = startIndex; i < endIndex; i++) {
            namesList.add(fullName.split(' ')[i]);
        }
        return String.join(namesList, ' ');
    }

    /**
    * @author       Swathi Dhoddusamy
    * @date         31/05/2016
    * @description  Save the attachments related to the incident report
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
    * @author       Swathi Dhoddusamy
    * @date         31/05/2016
    * @description  return the webreport thanks page
    **/
    public Pagereference submitReport() {
        if (!Apexpages.hasMessages()) {
            notSubmitted = false;
            return Page.webincidentreportthanks;
        } else {
            return null;
        }
    }

    /**
    * @date         13/02/2017
    * @description  return the webreport thanks page with message "not submitted".
    **/
    public Pagereference saveWithouSubmitReport() {
        if (!Apexpages.hasMessages()) {
            notSubmitted = true;
            List<Claims__Incident_Report__c> reports = [SELECT Id, Name
                                                        FROM Claims__Incident_Report__c
                                                        WHERE Id = :report.Id];
            if (reports.size() > 0) {
                report = reports[0];
            }
            return Page.webincidentreportthanks;
        } else {
            return null;
        }
    }
}