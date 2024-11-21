/*
*   @Description Controller for Incident Report portal for both Workers Compensation and General Loss portals
*/
public class IncidentReportPortalController {

    // Get portalType based in url.
    //check by rksinha. adding just this comment
    public String portalType {
        get {
            if (String.isBlank(portalType)) {
                String url1;
                if (Test.isRunningTest()) {
                    url1 = ApexPages.currentPage().getURL();
                } else {
                    url1 = URL.getcurrentrequestUrl().toexternalform();  
                }                
                if (url1.touppercase().contains(Label.Supervisor_Portal_Path)) {
                    portalType = Label.Supervisor_Portal_Path;
                }
                if (url1.touppercase().contains(Label.Incident_Portal_Path)) {
                    portalType = Label.Incident_Portal_Path;
                }
            }
            return portalType;
        }
        private set;
    }
    // Variable to accept selected action from portal page.
    public String selectedAction {get; set;} 
    // Search parameters returned from page.
    public String searchStringID {get; set;}
    public String searchStringName {get; set;}
    // Reports found with search criteria
    public List<Claims__Incident_Report__c> availableReports {get; set;}
    // Incident report being created/edited.
    public Claims__Incident_Report__c report {get; set;}
    // ID of report selected from list 
    public String selectedReportId {get; set;}
    // This controller used in components
    private IncidentReportPortalController controller;
    // Whether components are used in incident portal and 'New' page.
    public String compRoute {get; set;}

    public String selectedType {get; set;}
    public List<Selectoption> incidentTypes {get; private set;}
    public Boolean notSubmitted {get; private set;}
    public Boolean noReportsFound {get; private set;}

    private ApexPages.standardController stdController;
    public Attachment attach {
        get {
            if (attach == null) {
                attach = new Attachment();
            }
            return attach;
        }
        set;}
    public List<String> attachments {
        get {
            if (attachments == null) {
                attachments = new List<String>();
            }
            return attachments;
        }
        private set;}
    // *** 

    // Record type name - used to control portal specific processing.
    public String recordTypeName {get; private set;}
    
    // Lists of record types to search for Supervisor (Workers Compensation) portal
    private List<String> wcRecordTypes {
        get {
           if (wcRecordTypes==null || wcRecordTypes.isEmpty()) {
               wcRecordTypes = new List<String>{Label.Workers_Compensation_RT};
           }
           return wcRecordTypes;
        }
        private set;
    }
    // List of record types to search for GL portal.
    private List<String> glRecordTypes {
        get {
           if (glRecordTypes == null || glRecordTypes.isEmpty()) {
               glRecordTypes = new List<String>{Label.Bodily_Injury, Label.Motor_Vehicle, Label.Facility_Damage, Label.Property_Damage_RT, Label.Theft, Label.Missing};
           }
           return glRecordTypes;
        }
        private set;
    }
    // Variable assigned with list of record types to search based on portal type.
    private List<String> recordTypesToSearch {get; set;}

    // Variables to control display of sections on portal page
    public enum Stage {ACTION, CREATE, SEARCH, REPORTLIST, DETAIL, ATTACH, THANKS}
    public Stage currentStage {get; set;}
    // Getters to give page access to enum values.
    public Stage actionStage {
        get {
            return Stage.ACTION;
        }
        private set;
    } 
    public Stage createStage {
        get {
            return Stage.CREATE;
        }
        private set;
    } 
    public Stage searchStage {
        get {
            return Stage.SEARCH;
        }
        private set;
    }
    public Stage reportListStage {
        get {
            return Stage.REPORTLIST;
        }
        private set;
    }
    public Stage detailStage {
        get {
            return Stage.DETAIL;
        }
        private set;
    }
    public Stage attachStage {
        get {
            return Stage.ATTACH;
        }
        private set;
    }
    public Stage thanksStage {
        get {
            return Stage.THANKS;
        }
        private set;
    }

    /**
    *   @description  Controller for Incident Portal page.
    **/
    public IncidentReportPortalController() {

        notSubmitted = false;
        searchStringID = '';
        searchStringName = '';
        noReportsFound = false;

        incidentTypes = generateIncidentTypes();
        report = new Claims__Incident_Report__c();
        recordTypesToSearch = new List<String>();
        currentStage = Stage.ACTION;

    }

    /**
    * @description  Constructor.
    **/
    public IncidentReportPortalController (ApexPages.standardController controller) {

        this();
        this.stdController = controller;
        Claims__Incident_Report__c incidentReport = (Claims__Incident_Report__c)this.stdController.getRecord();
        this.report.recordTypeId = incidentReport.recordTypeId;
        this.recordTypeName = SchemaHelper.getRecordTypeInfosById(Claims__Incident_Report__c.sObjectType.getDescribe().getName(), (Id)incidentReport.recordTypeId);
   
    }

    /**
    *   @description Search functionality based on Incident Number OR Preparer Last Name.
    */
    public Pagereference searchIncidents() {

        String queryStr = '';

        searchStringID.replace(' ', '');
        searchStringName.replace(' ', '');

        if (! searchStringID.startsWith('IR-') && searchStringID != '') {
            //error on invalid ID format.
            this.report = new Claims__Incident_Report__c();
            // this.recordTypeName = null;
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, Label.Search_Invalid_ID_Format));
            return null;
        }

        if(searchStringID != '' && searchStringName != '') {
            //error on invalid ID format.
            this.report = new Claims__Incident_Report__c();
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, Label.Search_Parameter_Error));
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

        if(searchStringID != '') {
            queryStr = 'SELECT RecordTypeId, RecordType.Name, ' + String.join(fdNames, ',');
            queryStr += ' FROM Claims__Incident_Report__c WHERE Name = :searchStringID AND Record_Type_Name__c IN :recordTypesToSearch AND In_Progress_Report__c = True';
        }
        if(searchStringName != '') {
            String likeVal = '%' + String.escapeSingleQuotes(searchStringName);            
            queryStr = 'SELECT RecordTypeId, RecordType.Name, ' + String.join(fdNames, ',');
            queryStr += ' FROM Claims__Incident_Report__c WHERE Claims__Last_Name__c LIKE \'' + likeVal + '\' AND Record_Type_Name__c IN :recordTypesToSearch AND In_Progress_Report__c = True';
        }
		system.debug('Query::::'+queryStr);
        availableReports = Database.query(queryStr);

        if (availableReports.isEmpty()) {
            noReportsFound = true;
            return null;
        }

        if (availableReports.size() == 1) {
            this.report = availableReports[0];
            this.recordTypeName = availableReports[0].RecordType.Name;
            currentStage = Stage.DETAIL;
        }

        if (availableReports.size() > 1) {
            currentStage = Stage.REPORTLIST;
            this.report = new Claims__Incident_Report__c();
            this.recordTypeName = null;
        }

        return null;
    }

    /**
    *   @description When Incident selected from search list, set returned report and move to next stage.
    */
    public Pagereference incidentSelected() {

        for (Claims__Incident_Report__c report : availableReports) {
            if (report.Id == selectedReportId) {
                this.report = report;
                this.recordTypeName = report.RecordType.Name;
                break;
            }
        }
        currentStage = Stage.DETAIL;
        return null;
    }

    /**
    *   @description Return to select action stage.
    */
    public PageReference backToAction() {

        currentStage = Stage.ACTION;
        this.report = new Claims__Incident_Report__c();
        searchStringID = '';
        searchStringName = '';
        this.recordTypeName = null;
        selectedAction = null;
        noReportsFound = false;
        return null;

    }

    /*
    * @ Description Checks selected action and sets any required options based on selected action and portal type.
    */
    public PageReference actionSelected() {

        for (Stage st : Stage.values()) {
            if (selectedAction == st.name()) {
                currentStage = st;
            }
        }
        if ((currentStage == Stage.CREATE || currentStage == Stage.SEARCH) && portalType == Label.Supervisor_Portal_Path) {
            recordTypeName = Label.Workers_Compensation_RT;
            report.recordTypeId = SchemaHelper.getRecordTypeInfosByDeveloperName(Claims__Incident_Report__c.sObjectType.getDescribe().getName(), Label.Workers_Compensation_RT_Dev_Name);
            if (currentStage == Stage.SEARCH) {
                recordTypesToSearch.addall(wcRecordTypes);
            }
        }

        if ((currentStage == Stage.SEARCH) && portalType == Label.Incident_Portal_Path) {
            recordTypesToSearch.addall(glRecordTypes);
        }

        return null;
    }

    /**
    *   @description  Method to return the controller
    **/
    public IncidentReportPortalController getController() {
        if (this.controller == null) {
            this.controller = this;
        }
        return this.controller;
    }

    /**
    *   @description  Get the list of incident record types
    **/
    private List<Selectoption> generateIncidentTypes() {
        List<Selectoption> incTypes = new List<Selectoption>();
        incTypes.add(new Selectoption('--None--', '--None--'));
        for (RecordType recordType : [Select r.SobjectType, r.Name, r.Id, r.DeveloperName From RecordType r where SobjectType = :String.ValueOf(Claims__Incident_Report__c.SObjectType) AND IsActive = true]) {
            if (recordType.DeveloperName != Constants.INCIDENT_INPROGRESS_RT) {
                if (RecordType.name != Constants.CLAIM_WORKERS_COMPENSATION_RECORDTYPE) {
                    incTypes.add(new Selectoption((String)recordType.Id, recordType.Name));
                }
            }
        }
        return incTypes;
    }

    /**
    *   @description  Method to set the record type name after the record type is chosen from the list on the page
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
    *   @description  Save the incident report as Not "In Progress".
    **/
    public Pagereference Save() {
        notSubmitted = false;
        PageReference pg = saveIncident();
        return pg;
    }

    /**
    *   @description  Save incident as "In Progress".
    **/
    public Pagereference saveWithoutSubmission() {
        notSubmitted = true;
        PageReference pg = saveIncident();
        return pg;
    }

    /**
    *   @Description - Saves incident and returns to 'attach files' page if in portal or view record page if in back end.
    */
    private Pagereference saveIncident() {
        try {
            if (this.stdController != null) {
                Claims__Incident_Report__c incidentReport = (Claims__Incident_Report__c)this.stdController.getRecord();
                report.recordTypeId = incidentReport.recordTypeId;
            }
            report.In_Progress_Report__c = notSubmitted;
            // save required (but not entered) fields.
            report.Claims__Report_Completed_By__c = report.Claims__First_Name__c + ' '  + report.Claims__Last_Name__c;
            report.Status__c = Label.New;
            if (this.recordTypeName == Constants.CLAIM_MOTOR_VEHICLE_RECORDTYPE) report.Claims__Date_Reported__c = System.today();
            upsert report;

            if (this.stdController != null || compRoute == 'new') {
                return new ApexPages.StandardController(report).view();
            }
        } catch (Exception e) {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return null;
        }
        attach = new Attachment();
        attachments = new List<String>();
        currentStage = Stage.ATTACH;
        return null;
    }

    /**
    *   @description  Split Strings
    **/
    private String splitString(Integer startIndex, Integer endIndex, String fullName) {
        List<String> namesList = new List<String>();
        for (Integer i = startIndex; i < endIndex; i++) {
            namesList.add(fullName.split(' ')[i]);
        }
        return String.join(namesList, ' ');
    }

    /**
    *   @description  Save the attachments related to the incident report.
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
    *   @description Update the Incident 'In Progress' to false and return to show 'Thanks' message.
    **/
    public Pagereference submitReport() {

        if (!Apexpages.hasMessages() && report != null && report.Id != null) {
            try {
                notSubmitted = false;
                report.In_Progress_Report__c = notSubmitted;
                upsert report;
            } catch (Exception e) {
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                return null;
            }
            currentStage = Stage.THANKS;
            return null;                  
        } else {
            return null;
        }
    }

    /**
    *   @description  Return to show 'Thanks' message.
    **/
    public Pagereference saveWithoutSubmitReport() {

        currentStage = Stage.THANKS;
        return null;

    }
}