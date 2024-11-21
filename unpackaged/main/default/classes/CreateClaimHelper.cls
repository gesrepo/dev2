/**
* @author       Thiyagarajan Selvaraj
* @date         19/05/2016
* @description  Helper class to create claim
**/
public with sharing class CreateClaimHelper {

    /**
    * @author       Thiyagarajan Selvaraj
    * @date         13/03/2018
    * @description  Create map for claim to client
    **/
    public static Map<String, String> claimToClientMap = new Map<String, String> {
        Constants.CLAIM_BODILY_INJURY_RECORDTYPE => Constants.CLIENT_BODILY_INJURY,
        Constants.CLAIM_MOTOR_VEHICLE_RECORDTYPE => Constants.CLIENT_MOTOR_VEHICLE,
        Constants.CLAIM_THEFT_RECORDTYPE => Constants.CLAIM_THEFT_RECORDTYPE,
        Constants.CLAIM_MISSING_RECORDTYPE => Constants.CLAIM_MISSING_RECORDTYPE,
        Constants.CLAIM_WORKERS_COMPENSATION_RECORDTYPE => Constants.CLAIM_WORKERS_COMPENSATION_RECORDTYPE,
        Constants.CLAIM_PROPERTY_DAMAGE_RECORDTYPE => Constants.CLAIM_PROPERTY_DAMAGE_RECORDTYPE,
        Constants.CLAIM_FACILITY_DAMAGE_RECORDTYPE => Constants.CLAIM_FACILITY_DAMAGE_RECORDTYPE
    };

    /**
    * @author       Thiyagarajan Selvaraj
    * @date         13/03/2018
    * @description  Check fields to query
    **/
    private static Set<String> additionalFieldsToQuery = new Set<String> {
        Claims__Incident_Report__c.sObjectType.fields.Are_there_any_witnesses_to_the_incident__c.getDescribe().getName(),
        Claims__Incident_Report__c.sObjectType.fields.Enter_Witness_2_Details__c.getDescribe().getName(),
        Claims__Incident_Report__c.sObjectType.fields.Enter_Witness_3_Details__c.getDescribe().getName(),
        'RecordTypeId',
        'RecordType.Name'
    };

    /**
    * @author       Thiyagarajan Selvaraj
    * @date         19/05/2016
    * @description  Method to get the from object fields
    **/
    private static List<String> getFromObjectFields(List<FieldMapping> fieldMappingList) {
        Set<String> fieldsList = new Set<String>(additionalFieldsToQuery);

        // Loop through fields list and get the from field
        for (FieldMapping mapping : fieldMappingList) {
            if (!String.isBlank(mapping.fromField)) fieldsList.add(mapping.fromField);
        }
        return new List<String>(fieldsList);
    }

    /**
    * @author       Thiyagarajan Selvaraj
    * @date         19/05/2016
    * @description  Method to get the to object fields from the mapping
    **/
    public static List<String> getToObjectFields(List<FieldMapping> fieldMappingList) {
        List<String> fieldsList = new List<String>();

        // Loop through fields list and get the from field
        for (FieldMapping mapping : fieldMappingList) {
            if (!String.isBlank(mapping.toField)) fieldsList.add(mapping.toField);
        }
        return fieldsList;
    }

    /**
    * @author       Thiyagarajan Selvaraj
    * @date         27/05/2016
    * @description  Method to get all the mapped incident report fields
    **/
    public static List<FieldMapping> getMappingFields(Map<String, List<FieldMapping>> fieldMappingsMap) {
        List<FieldMapping> fieldMappingsList = new List<FieldMapping>();

        // Loop through fields list and get the from field
        for (String mappingName : fieldMappingsMap.keySet()) {
            fieldMappingsList.addAll(fieldMappingsMap.get(mappingName));
        }
        return fieldMappingsList;
    }

    /**
    * @author       Thiyagarajan Selvaraj
    * @date         19/05/2016
    * @description  Method to get incident report records
    **/
    public static List<Claims__Incident_Report__c> getIncidentReportsList(List<FieldMapping> fieldMappingList,
            Id incidentReportId) {
        String soqlQuery = 'SELECT ' + String.join(getFromObjectFields(fieldMappingList), ',') + ' FROM '
                           + Claims__Incident_Report__c.sObjectType.getDescribe().getName()
                           + ' WHERE Id = \'' + incidentReportId + '\' LIMIT 1';
        return (List<Claims__Incident_Report__c>)SoqlHelper.fetchRecords(soqlQuery);
    }

    /**
    * @author       Thiyagarajan Selvaraj
    * @date         19/05/2016
    * @description  Method to get the claim records
    **/
    public static List<Claims__Claim__c> getClaims(List<String> claimFieldsList, Id claimId) {
        String soqlQuery = 'SELECT ' + String.join(claimFieldsList, ',') + ' FROM '
                           + Claims__Claim__c.sObjectType.getDescribe().getName()
                           + ' WHERE Id = \'' + claimId + '\' LIMIT 1';
        return (List<Claims__Claim__c>)SoqlHelper.fetchRecords(soqlQuery);
    }

    /**
    * @author       Thiyagarajan Selvaraj
    * @date         19/05/2016
    * @description  Method to update the claim from the incident report record
    **/
    public static void updateSObjectRecordFromIncidentReport(Claims__Incident_Report__c incidentReport,
            sObject sObjectRecord, List<FieldMapping> fieldMappingsList) {
                system.debug('incidentReport---------->'+incidentReport);
                system.debug('fieldMappingsList---------->'+fieldMappingsList);
        // Loop through field mappings and update the value
        for (FieldMapping mapping : fieldMappingsList) {
            if (incidentReport.get(mapping.fromField) != null) {
                sObjectRecord.put(mapping.toField, incidentReport.get(mapping.fromField));
            }
        }
    }

    /**
    * @author       Thiyagarajan Selvaraj
    * @date         19/05/2016
    * @description  Method to update claim value
    **/
    public static void updateClaim(Field field, String soqlQuery, Claims__Claim__c claim) {
        // Loop through field mappings and update the value
        List<sObject> recordsList = SoqlHelper.fetchRecords(soqlQuery);
        if (!recordsList.isEmpty() && recordsList.size() == 1) {
            claim.put(field.fieldName, recordsList[0].Id);
            if (field.fieldName != SObjectType.Claims__Claim__c.fields.Policy__c.Name) field.isReadOnly = true;
        } else {
            claim.put(field.fieldName, null);
            field.isReadOnly = false;
        }
    }

    /**
    * @author       Thiyagarajan Selvaraj
    * @date         19/05/2016
    * @description  Method to get claim basic fields
    **/
    public static List<Field> getClaimBasicInformationFields(Claims__Claim__c claim) {
        List<Field> fieldsList = new List<Field>();

        // Loop through fields
        for (String field : SchemaHelper.getFieldsFromFieldsSet(Claims__Claim__c.sObjectType.getDescribe().getName(),
                Constants.CLAIM_FIELD_SET)) {
            // if it is a client field
            if (field == SObjectType.Claims__Claim__c.fields.Claims__Client__c.Name) {
                fieldsList.add(new Field(field, Claims__Claim__c.sObjectType.getDescribe().getName(), claim));
            } else {
                fieldsList.add(new Field(field, Claims__Claim__c.sObjectType.getDescribe().getName(), claim));
            }
        }
        return fieldsList;
    }

    /**
    * @author       Thiyagarajan Selvaraj
    * @date         19/05/2016
    * @description  Method to get the claim party values for Body Injury type
    **/
    public static List<ClaimParty> getBodyInjuryClaimParties() {
        List<ClaimParty> claimPartiesList = new List<ClaimParty>();
        claimPartiesList.add(new ClaimParty(Constants.INJURED_PARTY, Constants.INJURED_PARTY, '', '',
                                            new Set<String> {Constants.INJURED_PARTY},
                                            new Map<String, String>()));
        claimPartiesList.add(new ClaimParty(Constants.WITNESSES, Constants.WITNESS_RECORD_TYPE_LABEL,
                                            Claims__Incident_Report__c.sObjectType.fields.Are_there_any_witnesses_to_the_incident__c.getDescribe().getName(),
                                            Constants.YES_VALUE,
                                            new Set<String> {Constants.WITNESSES},
                                            new Map<String, String> {Claims__Claim_Party__c.sObjectType.fields.Witness_Type__c.getDescribe().getName() => Constants.WITNESS}));
        return claimPartiesList;
    }

    /**
    * @author       Thiyagarajan Selvaraj
    * @date         24/05/2016
    * @description  Method to get the claim party values for Motor Vehicle type
    **/
    public static List<ClaimParty> getMotorVehicleClaimParties() {
        List<ClaimParty> claimPartiesList = new List<ClaimParty>();
        claimPartiesList.add(new ClaimParty(Constants.GES, Constants.GES, '', '',
                                            new Set<String> {Constants.INJURED_PARTY, Constants.GES},
                                            new Map<String, String>()));
        claimPartiesList.add(new ClaimParty(Constants.NON_GES, Constants.NON_GES, '', '',
                                            new Set<String> {Constants.NON_GES},
                                            new Map<String, String>()));
        claimPartiesList.add(new ClaimParty(Constants.WITNESSES, Constants.WITNESS_RECORD_TYPE_LABEL,
                                            Claims__Incident_Report__c.sObjectType.fields.Are_there_any_witnesses_to_the_incident__c.getDescribe().getName(), Constants.YES_VALUE,
                                            new Set<String> {Constants.WITNESSES},
                                            new Map<String, String> {Claims__Claim_Party__c.sObjectType.fields.Witness_Type__c.getDescribe().getName() => Constants.WITNESS}));
        return claimPartiesList;
    }


    /**
    * @author       Nikhil Vedi
    * @date         05/03/2018
    * @description  Method to get the claim party values for Property Damage type
    **/
    public static List<ClaimParty> getPropertyDamageClaimParties() {
       return new List<ClaimParty> {
            new ClaimParty(
                Constants.DAMAGE, 
                Constants.DAMAGE, 
                '', 
                '',
                new Set<String> { Constants.DAMAGE },
                new Map<String, String>()),
            new ClaimParty(
                Constants.WITNESSES, 
                Constants.WITNESS_RECORD_TYPE_LABEL,
                Claims__Incident_Report__c.sObjectType.fields.Are_there_any_witnesses_to_the_incident__c.getDescribe().getName(),
                Constants.YES_VALUE,
                new Set<String> { Constants.WITNESSES },
                new Map<String, String> {
                    Claims__Claim_Party__c.sObjectType.fields.Witness_Type__c.getDescribe().getName() => Constants.WITNESS
                    })
        };
    }

    /**
    * @description  Method to get the claim party values for Theft type
    **/
    public static List<ClaimParty> getTheftClaimParties() {
        return new List<ClaimParty> {
            new ClaimParty(
                Constants.WITNESSES,
                Constants.WITNESS_RECORD_TYPE_LABEL,
                Claims__Incident_Report__c.sObjectType.fields.Are_there_any_witnesses_to_the_incident__c.getDescribe().getName(),
                Constants.YES_VALUE,
                new Set<String> { Constants.WITNESSES },
                new Map<String, String> {
                    Claims__Claim_Party__c.sObjectType.fields.Witness_Type__c.getDescribe().getName() => Constants.WITNESS
                    })
        };
    }

    /**
    * @description  Method to get the claim party values for Missing type
    **/
    public static List<ClaimParty> getMissingClaimParties() {
        return new List<ClaimParty> {
            new ClaimParty(
                Constants.WITNESSES,
                Constants.WITNESS_RECORD_TYPE_LABEL,
                Claims__Incident_Report__c.sObjectType.fields.Are_there_any_witnesses_to_the_incident__c.getDescribe().getName(),
                Constants.YES_VALUE,
                new Set<String> { Constants.WITNESSES },
                new Map<String, String> {
                    Claims__Claim_Party__c.sObjectType.fields.Witness_Type__c.getDescribe().getName() => Constants.WITNESS
                    })
        };
    }

    /**
    * @author       Nikhil Vedi
    * @date         05/03/2018
    * @description  Method to get the claim party values for Facility Damage type
    **/
    public static List<ClaimParty> getFacilityDamageClaimParties() {
        List<ClaimParty> claimPartiesList = new List<ClaimParty>();
        claimPartiesList.add(new ClaimParty(Constants.DAMAGE, Constants.DAMAGE, '', '',
                                            new Set<String> {Constants.DAMAGE, Constants.DAMAGE},
                                            new Map<String, String>()));
        claimPartiesList.add(new ClaimParty(Constants.WITNESSES, Constants.WITNESS_RECORD_TYPE_LABEL,
                                            Claims__Incident_Report__c.sObjectType.fields.Are_there_any_witnesses_to_the_incident__c.getDescribe().getName(), Constants.YES_VALUE,
                                            new Set<String> {Constants.WITNESSES},
                                            new Map<String, String> {Claims__Claim_Party__c.sObjectType.fields.Witness_Type__c.getDescribe().getName() => Constants.WITNESS}));
        return claimPartiesList;
    }

    /**
    * @author       Nikhil Vedi
    * @date         05/03/2018
    * @description  Method to get the claim party values for Workers Compensation type
    **/
    public static List<ClaimParty> getWorkersCompensationClaimParties() {
        List<ClaimParty> claimPartiesList = new List<ClaimParty>();
        // claimPartiesList.add(new ClaimParty(Constants.WORKERSCOMPENSATION, Constants.CLAIM_WORKERS_COMPENSATION_RECORDTYPE, '', '',
        //                                     new Set<String> {Constants.WORKERSCOMPENSATION, Constants.WORKERSCOMPENSATION}, new Map<String, String>()));
        claimPartiesList.add(new ClaimParty(Constants.WITNESSES, Constants.WITNESS_RECORD_TYPE_LABEL, '', '',
                                            new Set<String> {Constants.WITNESSES},
                                            new Map<String, String> {Claims__Claim_Party__c.sObjectType.fields.Witness_Type__c.getDescribe().getName() => Constants.WITNESS}));
        return claimPartiesList;
    }
}