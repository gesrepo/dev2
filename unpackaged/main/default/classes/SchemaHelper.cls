/**
* @author       Thiyagarajan Selvaraj
* @date         19/05/2016
* @description  Helper class to get the schema
**/
public with sharing class SchemaHelper {
	
	/**
	* @author       Thiyagarajan Selvaraj
	* @date         19/05/2016
	* @description  Method used to get the list of fields from the field set
	**/
	public static List<String> getFieldsFromFieldsSet(String objectName, String fieldSetName){
        List<String> fieldsList = new List<String>();
        
        // Loop through fields list and get the field path 
        if (!String.isBlank(objectName) && !String.isBlank(fieldSetName) && Schema.getGlobalDescribe().get(objectName).getDescribe().fieldsets.getMap().containsKey(fieldSetName)){
            for (Schema.FieldSetMember riskField : Schema.getGlobalDescribe().get(objectName).getDescribe().fieldsets.getMap().get(fieldSetName).getFields()){
                fieldsList.add(riskField.getFieldPath());
            }
        }
        return fieldsList;
    }


    /**
    * @author       Thiyagarajan Selvaraj
    * @date         19/05/2016
    * @description  Method to get the reference value
    **/
    public static List<Schema.sObjectType> getReference(String objectName, String fieldName){
        return Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(fieldName).getDescribe().getReferenceTo();
    }

    /**
    * @author       Thiyagarajan Selvaraj
    * @date         19/05/2016
    * @description  Method to get the reference value
    **/
    public static String getRecordTypeInfosById(String objectName, Id recordTypeId){
        if(Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosById().containsKey(recordTypeId)){
            return Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosById().get(recordTypeId).getName();
        }
        return '';
    }

    /**
    * @author       Thiyagarajan Selvaraj
    * @date         21/06/2016
    * @description  Method to get the record type Id by label
    **/
    public static Id getRecordTypeInfosByName(String objectName, String recordTypeLabel){
        if(Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosByName().containsKey(recordTypeLabel)){
            return Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();
        }
        return null;
    }

    /**
    * @author       Dean Gelder
    * @date         21/01/2019
    * @description  Method to get the record type Id by developer name
    **/
    public static Id getRecordTypeInfosByDeveloperName(String objectName, String recordTypeLabel){
        if(Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosByDeveloperName().containsKey(recordTypeLabel)){
            return Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosByDeveloperName().get(recordTypeLabel).getRecordTypeId();
        }
        return null;
    }

    /**
    * @author       Thiyagarajan Selvaraj
    * @date         19/05/2016
    * @description  Method to get the field type
    **/
    public static String getSOAPType(String objectName, String fieldName){
        return String.valueOf(Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(fieldName).getDescribe().getSOAPType()).toLowerCase();
    }
}