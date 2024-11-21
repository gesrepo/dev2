/**
* @author       Thiyagarajan Selvaraj
* @date         19/05/2016/ Updated - 13/03/2018 - Nikhil Vedi
* @description  Constants class used to track all fixed field items
**/
public with sharing class Constants {

    public static String INCIDENT_ID = 'incidentId';

    public static String CLAIM_FIELD_SET = 'Claim_Information';

    public static String CLAIM_BODILY_INJURY_RECORDTYPE = 'Bodily Injury';
    public static String CLAIM_MOTOR_VEHICLE_RECORDTYPE = 'Motor Vehicle';

    public static String CLAIM_FACILITY_DAMAGE_RECORDTYPE = 'Facility Damage';
    public static String CLAIM_PROPERTY_DAMAGE_RECORDTYPE = 'Property Damage';
    public static String CLAIM_WORKERS_COMPENSATION_RECORDTYPE = 'Workers Compensation';
    public static String CLAIM_THEFT_RECORDTYPE = 'Theft';
    public static String CLAIM_MISSING_RECORDTYPE = 'Missing';

    public static String INCLUDES = 'INCLUDES';
    public static String EQUALS = '=';


    public static String CLIENT_BODILY_INJURY = 'Bodily Injury';
    public static String CLIENT_MOTOR_VEHICLE = 'Motor Vehicle';

    public static String SELECTED_FIELD = 'selectedField';
    public static String INJURED_PARTY = 'Injured Party';
    public static String WITNESSES = 'Witnesses';
    public static String WITNESS_RECORD_TYPE_LABEL = 'Witness';
    public static String YES_VALUE = 'Yes';
    public static String TRUE_VALUE = 'true';
    public static String STRING_VALUE = 'string';
    public static String BOOLEAN_VALUE = 'boolean';
    public static String GES = 'GES';
    public static String DAMAGE = 'Damage';
    public static String THEFT = 'Theft';
    public static String MISSING = 'Missing';
    public static String WORKERSCOMPENSATION = 'Workers_Compensation';
    public static String NON_GES = 'NON-GES';
    public static String WITNESS = 'Witness';
    public static String POLICY_TYPE_FIELD_NAME = 'Claims__Policy_Type_Lookup__r.Name';
    public static String INCIDENT_INPROGRESS_RT = 'In_Progress';



    public static Map<String, Set<String>> addActionAndUpdateFieldsMap =
    new Map<String, Set<String>> {
        SObjectType.Claims__Claim__c.fields.Policy_Year__c.Name =>
        new Set<String>{SObjectType.Claims__Claim__c.fields.Policy__c.Name, SObjectType.Claims__Claim__c.fields.Policy_Cover__c.Name},
        SObjectType.Claims__Claim__c.fields.Policy__c.Name =>
        new Set<String>{SObjectType.Claims__Claim__c.fields.Policy_Cover__c.Name},
        SObjectType.Claims__Claim__c.fields.Claims__Client__c.Name =>
        new Set<String>()
    };

    public static Map<String, List<Field.FilterMapping>> filterMappingMap =
    new Map<String, List<Field.FilterMapping>> {
        SObjectType.Claims__Claim__c.fields.Claims__Client__c.Name =>
        new List<Field.FilterMapping>{
            new Field.FilterMapping(SObjectType.Claims__Client__c.fields.Type_of_Claim__c.Name, '',
            INCLUDES, '')
        },
        SObjectType.Claims__Claim__c.fields.Policy__c.Name =>
        new List<Field.FilterMapping>{
            new Field.FilterMapping(SObjectType.Claims__Policy__c.fields.Claims__Client__c.Name,
            SObjectType.Claims__Claim__c.fields.Claims__Client__c.Name, EQUALS, ''),
            new Field.FilterMapping(SObjectType.Claims__Policy__c.fields.Claims__Policy_Year__c.Name,
            SObjectType.Claims__Claim__c.fields.Policy_Year__c.Name, EQUALS, ''),
            new Field.FilterMapping(POLICY_TYPE_FIELD_NAME, '', EQUALS, '')
        },
        SObjectType.Claims__Claim__c.fields.Policy_Cover__c.Name =>
        new List<Field.FilterMapping>{
            new Field.FilterMapping(SObjectType.Claims__Policy_Detail__c.fields.Claims__Policy__c.Name,
            SObjectType.Claims__Claim__c.fields.Policy__c.Name, EQUALS, '')
        }
    };
}