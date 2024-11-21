/**
* @author       Thiyagarajan Selvaraj
* @date         19/05/2016
* @description  Controller to create claims
**/
public with sharing class CreateClaimController {


    private Id incidentReportId = ApexPages.currentPage().getParameters().get(Constants.INCIDENT_ID);

    private List<Claims__Incident_Report__c> incidentReportsList;

    private Map<String, List<FieldMapping>> fieldMappingsMap = new Map<String, List<FieldMapping>>();

    public Claims__Claim__c claim {get; set;}

    public Integer pageCounter {get; private set;}

    private ApexPages.standardController stdController;

    public List<Field> fieldsList {get; private set;}

    /**
    * @author       Thiyagarajan Selvaraj
    * @date         19/05/2016
    * @description  Constructor
    **/
    public CreateClaimController() {
        try {
            this.pageCounter = 1;
            // set up mappings
            setUpMappings();

            // initalize claim
            this.claim = new Claims__Claim__c();

            // check if incident report id is not null
            if (this.incidentReportId != null) {
                // get the incident reports
                this.incidentReportsList =
                    CreateClaimHelper.getIncidentReportsList(CreateClaimHelper.getMappingFields(this.fieldMappingsMap),
                         this.incidentReportId);

                // update claim
                if (!incidentReportsList.isEmpty()) {
                    CreateClaimHelper.updateSObjectRecordFromIncidentReport(this.incidentReportsList[0],(sObject)this.claim,
                    getFieldMappingList(Claims__Claim__c.sObjectType.getDescribe().getName()));
                    Map<String, Schema.RecordTypeInfo> claimTypes = Claims__Claim__c.sObjectType.getDescribe().getRecordTypeInfosByName();
                    String rtName = this.incidentReportsList[0].RecordType.Name;
                    this.claim.RecordTypeId = claimTypes.containsKey(rtName) ? claimTypes.get(rtName).getRecordTypeId() : null;
                }
                this.claim.Claims__Incident_Report__c = this.incidentReportId;

                // get basic claim information fields
                getBasicClaimInformationFields();
            }
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }
    }

    /**
    * @author       Thiyagarajan Selvaraj
    * @date         19/05/2016
    * @description  Constructor taking standard controller as a parameter
    **/
    public CreateClaimController(ApexPages.standardController controller) {
        this();
        this.stdController = controller;

        if (this.incidentReportId == null) {
            Claims__Claim__c claimRecord = (Claims__Claim__c)this.stdController.getRecord();
            this.claim.RecordTypeId = claimRecord.RecordTypeId;

            // get basic claim information fields
            getBasicClaimInformationFields();

            if (this.stdController.getId() != null) {
                Set<String> fieldsList = new Set<String>();
                fieldsList.addAll(SchemaHelper.getFieldsFromFieldsSet(Claims__Claim__c.sObjectType.getDescribe().getName(),
                                  Constants.CLAIM_FIELD_SET));
                fieldsList.addAll(getMappedFields());

                // Get claim records
                List<Claims__Claim__c> claimsList = CreateClaimHelper.getClaims(new List<String>(fieldsList),
                                                    (Id)this.stdController.getId());

                if (!claimsList.isEmpty()) {
                    this.claim = claimsList[0];
                }
            }
        }
    }

    /**
    * @author       Thiyagarajan Selvaraj
    * @date         19/05/2016
    * @description  Method to get the basic claim information fields
    **/
    @testVisible
    private List<Field> getBasicClaimInformationFields() {
        if(this.fieldsList == null || this.fieldsList.isEmpty()) {
             this.fieldsList = CreateClaimHelper.getClaimBasicInformationFields(this.claim);
        }
        return this.fieldsList;
    }

    /**
    * @author       Thiyagarajan Selvaraj
    * @date         19/05/2016
    * @description  Method to get the basic claim information fields
    **/
    public List<String> getMappedFields() {
        return CreateClaimHelper.getToObjectFields(getFieldMappingList(Claims__Claim__c.sObjectType.getDescribe().getName()));
    }

    /**
    * @author       Thiyagarajan Selvaraj
    * @date         19/05/2016
    * @description  Method to set up the mapping
    **/
    private void setUpMappings() {
        // Get the mappings
        List<Claims__Mapping__c> mappingsList =
            SoqlHelper.getMappingsList(Claims__Incident_Report__c.sObjectType.getDescribe().getName(), Claims__Claim__c.sObjectType.getDescribe().getName());

        // get field mappings
        if (!mappingsList.isEmpty()) {
            // Populate the map
            this.fieldMappingsMap.put(mappingsList[0].Claims__To_Object__c,
                                      (List<FieldMapping>)JSON.deserializeStrict(mappingsList[0].Claims__Field_Mapping__c, List<FieldMapping>.class));
            // add child mappings
            if (!mappingsList[0].Claims__children__r.isEmpty()) {
                for (Claims__Mapping__c mapping : mappingsList[0].Claims__children__r) {
                    this.fieldMappingsMap.put(mapping.Claims__Name__c,
                                              (List<FieldMapping>)JSON.deserializeStrict(mapping.Claims__Field_Mapping__c, List<FieldMapping>.class));
                }
            }
        }
    }

    /**
    * @author       Thiyagarajan Selvaraj
    * @date         19/05/2016
    * @description  Update the claim record when field value changes
    **/
    public PageReference updateClaim() {
        try {
            String fieldName = ApexPages.currentPage().getParameters().get(Constants.SELECTED_FIELD);

            // loop through fieldslist
            if (!String.isBlank(fieldName) &&
                    Constants.addActionAndUpdateFieldsMap.containsKey(fieldName) && !Constants.addActionAndUpdateFieldsMap.get(fieldName).isEmpty()) {
                for (Field field : this.fieldsList) {
                    if (Constants.addActionAndUpdateFieldsMap.get(fieldName).contains(field.fieldName)) {
                        CreateClaimHelper.updateClaim(field, field.createQuery(this.claim), this.claim);
                    }
                }
            }
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }
        return null;
    }

    /**
    * @author       Thiyagarajan Selvaraj
    * @date         19/05/2016
    * @description  Method to get the field mapping for the given type
    **/
    public List<FieldMapping> getFieldMappingList(String fieldMappingName) {
        return (this.fieldMappingsMap.containsKey(fieldMappingName)) ? 
            this.fieldMappingsMap.get(fieldMappingName) : new List<FieldMapping>();
    }

    /**
    * @author       Thiyagarajan Selvaraj
    * @date         19/05/2016
    * @description  Cancel the claim creation ß
    **/
    public PageReference cancel() {
        // incident report Id
        if (this.incidentReportId != null) {
            return new ApexPages.standardController(new Claims__Incident_Report__c(Id = this.incidentReportId)).view();
        } else if (this.incidentReportId == null && this.stdController.getId() != null) {
            return new ApexPages.standardController(new Claims__Claim__c(Id = this.stdController.getId())).view();
        }
        return new PageReference('/' + Claims__Claim__c.sObjectType.getDescribe().getKeyPrefix() + '/o').setRedirect(true);
    }

    /**
    * @author       Thiyagarajan Selvaraj
    * @date         19/05/2016
    * @description  Cancel the claim creation
    **/
    public PageReference save() {
        try {
            // update claim record type
            if (this.incidentReportsList != null && !this.incidentReportsList.isEmpty()
                    && !String.isBlank(this.incidentReportsList[0].RecordType.Name)) {
                this.claim.RecordTypeId =
                    Claims__Claim__c.sObjectType.getDescribe().getRecordTypeInfosByName().containsKey(this.incidentReportsList[0].RecordType.Name)
                    ? Claims__Claim__c.sObjectType.getDescribe().getRecordTypeInfosByName().get(this.incidentReportsList[0].RecordType.Name).getRecordTypeId() : null;
            } 

            upsert this.claim;

            cloneIncidentReportAttachments();

            // create injured party
            if (this.incidentReportsList != null && !this.incidentReportsList.isEmpty() && this.incidentReportId != null) {
                String compare = SchemaHelper.getRecordTypeInfosById(
                    Claims__Claim__c.sObjectType.getDescribe().getName(),
                    this.claim.recordTypeId);
                if (Constants.CLAIM_BODILY_INJURY_RECORDTYPE == compare) createBodilyInjuryClaimParties();
                if (Constants.CLAIM_MOTOR_VEHICLE_RECORDTYPE == compare) createMotorVehicleClaimParties();
                if (Constants.CLAIM_FACILITY_DAMAGE_RECORDTYPE == compare) createFacilityClaimParties();
                if (Constants.CLAIM_PROPERTY_DAMAGE_RECORDTYPE == compare) createPropertyClaimParties();
                if (Constants.CLAIM_THEFT_RECORDTYPE == compare) createTheftParties();
                if (Constants.CLAIM_MISSING_RECORDTYPE == compare) createMissingParties();
                if (Constants.CLAIM_WORKERS_COMPENSATION_RECORDTYPE == compare) createWorkersCompensationClaimParties();

            }
            return new PageReference('/' + this.claim.Id + '/e?retURL=' + this.claim.Id).setRedirect(true);
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }
        return null;
    }

    /**
    * @author       Nikhil Vedi
    * @date         05/03/2018
    * @description  Method to create Facilty Damage claim parties
    **/
    @testVisible
    private void createFacilityClaimParties() {
        List<Claims__Claim_Party__c> claimPartiesList = new List<Claims__Claim_Party__c>();

        // Loop through claim parties List
        for (ClaimParty claimParty : CreateClaimHelper.getFacilityDamageClaimParties()) {
            Claims__Claim_Party__c claimPartyRecord  = new Claims__Claim_Party__c(Name =
                        claimParty.claimPartyName, Claims__Claim__c = this.claim.Id, RecordTypeId = claimParty.recordTypeId);
            if (claimParty.checkIncidentRecordValue(this.incidentReportsList[0])) {
                for (String claimPartyName : claimParty.claimPartiesList) {
                    CreateClaimHelper.updateSObjectRecordFromIncidentReport(this.incidentReportsList[0],
                            (sObject)claimPartyRecord, getFieldMappingList(claimPartyName));
                }

                // update field values
                for (String fieldName : claimParty.fieldValuesMap.keySet()) {
                    claimPartyRecord.put(fieldName, claimParty.fieldValuesMap.get(fieldName));
                }
                claimPartiesList.add(claimPartyRecord);
            }
        }
        insert claimPartiesList;
    }

    /**
    * @author       Nikhil Vedi
    * @date         05/03/2018
    * @description  Method to create Property Damage claim parties
    **/
    @testVisible
    private void createPropertyClaimParties() {
        List<Claims__Claim_Party__c> claimPartiesList = new List<Claims__Claim_Party__c>();

        // Loop through claim parties List
        for (ClaimParty claimParty : CreateClaimHelper.getPropertyDamageClaimParties()) {
            Claims__Claim_Party__c claimPartyRecord  = new Claims__Claim_Party__c(Name =
                        claimParty.claimPartyName, Claims__Claim__c = this.claim.Id, RecordTypeId = claimParty.recordTypeId);
            if (claimParty.checkIncidentRecordValue(this.incidentReportsList[0])) {
                for (String claimPartyName : claimParty.claimPartiesList) {
                    CreateClaimHelper.updateSObjectRecordFromIncidentReport(this.incidentReportsList[0],
                            (sObject)claimPartyRecord, getFieldMappingList(claimPartyName));
                }

                // update field values
                for (String fieldName : claimParty.fieldValuesMap.keySet()) {
                    claimPartyRecord.put(fieldName, claimParty.fieldValuesMap.get(fieldName));
                }
                claimPartiesList.add(claimPartyRecord);
            }
        }
        if(!claimPartiesList.isEmpty()) insert claimPartiesList;
    }

    /**
    * @description  Method to create Theft claim parties
    **/
    @testVisible
    private void createTheftParties() {
        List<Claims__Claim_Party__c> claimPartiesList = new List<Claims__Claim_Party__c>();

        // Loop through claim parties List
        for (ClaimParty claimParty : CreateClaimHelper.getTheftClaimParties()) {
            Claims__Claim_Party__c claimPartyRecord  = new Claims__Claim_Party__c(Name =
                claimParty.claimPartyName, Claims__Claim__c = this.claim.Id, RecordTypeId = claimParty.recordTypeId);
            if (claimParty.checkIncidentRecordValue(this.incidentReportsList[0])) {
                for (String claimPartyName : claimParty.claimPartiesList) {
                    CreateClaimHelper.updateSObjectRecordFromIncidentReport(this.incidentReportsList[0],
                        (sObject)claimPartyRecord, getFieldMappingList(claimPartyName));
                }

                // update field values
                for (String fieldName : claimParty.fieldValuesMap.keySet()) {
                    claimPartyRecord.put(fieldName, claimParty.fieldValuesMap.get(fieldName));
                }
                claimPartiesList.add(claimPartyRecord);
            }
        }
        if(!claimPartiesList.isEmpty()) insert claimPartiesList;
    }

    /**
    * @description  Method to create Missing claim parties
    **/
    @testVisible
    private void createMissingParties() {
        List<Claims__Claim_Party__c> claimPartiesList = new List<Claims__Claim_Party__c>();

        // Loop through claim parties List
        for (ClaimParty claimParty : CreateClaimHelper.getTheftClaimParties()) {
            Claims__Claim_Party__c claimPartyRecord  = new Claims__Claim_Party__c(Name =
                        claimParty.claimPartyName, Claims__Claim__c = this.claim.Id, RecordTypeId = claimParty.recordTypeId);
            if (claimParty.checkIncidentRecordValue(this.incidentReportsList[0])) {
                for (String claimPartyName : claimParty.claimPartiesList) {
                    CreateClaimHelper.updateSObjectRecordFromIncidentReport(this.incidentReportsList[0],
                            (sObject)claimPartyRecord, getFieldMappingList(claimPartyName));
                }

                // update field values
                for (String fieldName : claimParty.fieldValuesMap.keySet()) {
                    claimPartyRecord.put(fieldName, claimParty.fieldValuesMap.get(fieldName));
                }
                claimPartiesList.add(claimPartyRecord);
            }
        }
        if(!claimPartiesList.isEmpty()) insert claimPartiesList;
    }

    /**
    * @author       Thiyagarajan Selvaraj
    * @date         19/05/2016
    * @description  Method to create bodily injury claim parties
    **/
    @testVisible
    private void createBodilyInjuryClaimParties() {
        List<Claims__Claim_Party__c> claimPartiesList = new List<Claims__Claim_Party__c>();

        // Loop through claim parties List
        for (ClaimParty claimParty : CreateClaimHelper.getBodyInjuryClaimParties()) {
            Claims__Claim_Party__c claimPartyRecord  = new Claims__Claim_Party__c(Name =
                        claimParty.claimPartyName, Claims__Claim__c = this.claim.Id, RecordTypeId = claimParty.recordTypeId);
            if (claimParty.checkIncidentRecordValue(this.incidentReportsList[0])) {
                for (String claimPartyName : claimParty.claimPartiesList) {
                    CreateClaimHelper.updateSObjectRecordFromIncidentReport(this.incidentReportsList[0],
                            (sObject)claimPartyRecord, getFieldMappingList(claimPartyName));
                }

                // update field values
                for (String fieldName : claimParty.fieldValuesMap.keySet()) {
                    claimPartyRecord.put(fieldName, claimParty.fieldValuesMap.get(fieldName));
                }
                claimPartiesList.add(claimPartyRecord);
            }
        }
        if(!claimPartiesList.isEmpty()) insert claimPartiesList;
    }

    /**
    * @author       Thiyagarajan Selvaraj
    * @date         19/05/2016
    * @description  Method to create motor vehicle claim parties
    **/
    @testVisible
    private void createMotorVehicleClaimParties() {
        List<Claims__Claim_Party__c> claimPartiesList = new List<Claims__Claim_Party__c>();

        // Loop through claim parties List
        for (ClaimParty claimParty : CreateClaimHelper.getMotorVehicleClaimParties()) {
            Claims__Claim_Party__c claimPartyRecord  =
                new Claims__Claim_Party__c(Name = claimParty.claimPartyName, Claims__Claim__c =
                                               this.claim.Id, RecordTypeId = claimParty.recordTypeId);
            if (claimParty.checkIncidentRecordValue(this.incidentReportsList[0])) {
                for (String claimPartyName : claimParty.claimPartiesList) {
                    CreateClaimHelper.updateSObjectRecordFromIncidentReport(this.incidentReportsList[0],
                            (sObject)claimPartyRecord, getFieldMappingList(claimPartyName));
                }
                // update field values
                for (String fieldName : claimParty.fieldValuesMap.keySet()) {
                    claimPartyRecord.put(fieldName, claimParty.fieldValuesMap.get(fieldName));
                }
                claimPartiesList.add(claimPartyRecord);
            }
        }
        if(!claimPartiesList.isEmpty()) insert claimPartiesList;
    }

    /**
    * @author       Nikhil Vedi
    * @date         08/03/2018
    * @description  Method to create Workers Compensation claim parties
    **/
    @testVisible
    private void createWorkersCompensationClaimParties() {
        List<Claims__Claim_Party__c> claimPartiesList = new List<Claims__Claim_Party__c>();

        // Loop through claim parties List
        for (ClaimParty claimParty : CreateClaimHelper.getWorkersCompensationClaimParties()) {
            Claims__Claim_Party__c claimPartyRecord  =
                new Claims__Claim_Party__c(Name = claimParty.claimPartyName, Claims__Claim__c = this.claim.Id, RecordTypeId = claimParty.recordTypeId);
            if (claimParty.checkIncidentRecordValue(this.incidentReportsList[0])) {
                for (String claimPartyName : claimParty.claimPartiesList) {
                    CreateClaimHelper.updateSObjectRecordFromIncidentReport(this.incidentReportsList[0],
                            (sObject)claimPartyRecord, getFieldMappingList(claimPartyName));
                }
                // update field values
                for (String fieldName : claimParty.fieldValuesMap.keySet()) {
                    claimPartyRecord.put(fieldName, claimParty.fieldValuesMap.get(fieldName));
                }
                claimPartiesList.add(claimPartyRecord);
            }
        }
        system.debug('DG TEST ' + claimPartiesList.size());
        system.debug('DG TEST ' + claimPartiesList[0].Witness_Type__c);
        if(!claimPartiesList.isEmpty()) insert claimPartiesList;
    }


    /**
    * @author       Jonathon Chambers
    * @date         03/01/2017
    * @description  Method to clone attachments from incident report onto created claim
    **/
    public void cloneIncidentReportAttachments() {
        // Copy Attachments over to new claims
        List<Attachment> atts = [SELECT Id, Name, Body, ParentId FROM Attachment WHERE ParentId = :this.incidentReportId];
        if (!atts.isEmpty()) {
            List<Attachment> clonedAtts = new List<Attachment>();
            for (Attachment a : atts) {
                clonedAtts.add(new Attachment(Name = a.Name, Body = a.Body, ParentId = this.claim.Id));
            }
            if (!clonedAtts.isEmpty()) {
                insert clonedAtts;
            }
        }
    }
}