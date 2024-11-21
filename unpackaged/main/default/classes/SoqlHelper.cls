/**
* @author       Thiyagarajan Selvaraj
* @date         19/05/2016
* @description   This class has soql utility methods
**/
public with sharing class SoqlHelper {
	
	/**
	* @author       Thiyagarajan Selvaraj
	* @date         19/05/2016
	* @description  Method to get the list of mapping between incident and claim
	**/
	public static List<Claims__Mapping__c> getMappingsList(String mappingFrom, String mappingTo){
		List<Claims__Mapping__c> mappingsList = [SELECT Id, Name, Claims__Name__c, Claims__From_Object__c, Claims__To_Object__c, Claims__Field_Mapping__c,
                                        			(SELECT Id, Name, Claims__Name__c, Claims__From_Object__c, Claims__To_Object__c, Claims__Field_Mapping__c FROM Claims__children__r)
                                     					FROM Claims__Mapping__c WHERE Claims__From_Object__c = :mappingFrom AND Claims__To_Object__c = :mappingTo LIMIT 1];
        return mappingsList;
	}


	/**
	* @author       Thiyagarajan Selvaraj
	* @date         19/05/2016
	* @description  Method to get the sobject record
	**/
	public static List<sObject> fetchRecords(String soqlQuery){
		return Database.query(soqlQuery);
	}
}