/**
* @author       Thiyagarajan Selvaraj
* @date         21/06/2016
* @description  Apex struture to create claim party
**/
public with sharing class ClaimParty {

	public String claimPartyName {get; set;}
	public Id recordTypeId {get; set;}
	public String fieldName {get; set;}
	public String fieldValue {get; set;}
	private String fieldType {get; set;}
	public Set<String> claimPartiesList {get; set;}
	public Map<String, String> fieldValuesMap {get; set;}
	
	/**
	* @author       Thiyagarajan Selvaraj
	* @date         21/06/2016
	* @description  Constructor
	**/
	public ClaimParty(String claimPartyName, String recordTypeLabel, String fieldName, String fieldValue, Set<String> claimPartiesList, Map<String, String> fieldValuesMap) {
		this.claimPartyName = claimPartyName;
		this.recordTypeId = SchemaHelper.getRecordTypeInfosByName(Claims__Claim_Party__c.sObjectType.getDescribe().getName(),recordTypeLabel);
		this.fieldName = fieldName;
		this.fieldValue = fieldValue;
		this.fieldType = !String.isBlank(fieldName) ? SchemaHelper.getSOAPType(Claims__Incident_Report__c.sObjectType.getDescribe().getName(),fieldName) : '';
		this.claimPartiesList = claimPartiesList;
		this.fieldValuesMap = fieldValuesMap;
	}

	/**
	* @author       Thiyagarajan Selvaraj
	* @date         21/06/2016
	* @description  Constructor
	**/
	public ClaimParty(String claimPartyName, String recordTypeLabel, String fieldName, String fieldValue, Set<String> claimPartiesList) {
		this.claimPartyName = claimPartyName;
		this.recordTypeId = SchemaHelper.getRecordTypeInfosByName(Claims__Claim_Party__c.sObjectType.getDescribe().getName(),recordTypeLabel);
		this.fieldName = fieldName;
		this.fieldValue = fieldValue;
		this.fieldType = !String.isBlank(fieldName) ? SchemaHelper.getSOAPType(Claims__Incident_Report__c.sObjectType.getDescribe().getName(),fieldName) : '';
		this.claimPartiesList = claimPartiesList;
	}

	/**
	* @author       Thiyagarajan Selvaraj
	* @date         21/06/2016
	* @description  check the incident report value match with the given value
	**/
	public Boolean checkIncidentRecordValue(Claims__Incident_Report__c incidentRecord) {
		if(!String.isBlank(this.fieldName) && !String.isBlank(this.fieldValue) && this.fieldType == Constants.STRING_VALUE){
			return (String)incidentRecord.get(fieldName) == this.fieldValue;
		}else if(!String.isBlank(this.fieldName) && this.fieldType == Constants.BOOLEAN_VALUE){
			return (Boolean)incidentRecord.get(fieldName);
		}
		return true;
	}
}