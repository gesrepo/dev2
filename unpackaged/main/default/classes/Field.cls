/**
* @author       Thiyagarajan Selvaraj
* @date         20/05/2016
* @description  Field structure
**/
public with sharing class Field {
	
	public Boolean isReadOnly {get; set;}
	public String fieldName {get; set;}
	public String parentObjectName {get; private set;}
	public Boolean hasAction {get; private set;}
	public List<FilterMapping> filterMappingsList;

	/**
	* @author       Thiyagarajan Selvaraj
	* @date         20/05/2016
	* @description  Constructor
	**/
	public Field(String fieldName, String sObjectName,Claims__Claim__c claim){
		this.fieldName = fieldName;
		this.isReadOnly = false;
		this.hasAction = Constants.addActionAndUpdateFieldsMap.containsKey(fieldName);
		this.filterMappingsList = new List<FilterMapping>(Constants.filterMappingMap.containsKey(fieldName) ? Constants.filterMappingMap.get(fieldName) : new List<FilterMapping>());

		// if its a client
		if(this.fieldName == SObjectType.Claims__Claim__c.fields.Claims__Client__c.Name){
			this.filterMappingsList[0].fieldValue = SchemaHelper.getRecordTypeInfosById(Claims__Claim__c.sObjectType.getDescribe().getName(),claim.RecordTypeId);
		}

		// if its a policy
		if(this.fieldName == SObjectType.Claims__Claim__c.fields.Policy__c.Name){
			this.filterMappingsList[2].fieldValue = SchemaHelper.getRecordTypeInfosById(Claims__Claim__c.sObjectType.getDescribe().getName(),claim.RecordTypeId);
		}

		// get reference
		List<Schema.sObjectType> sObjectTypesList = SchemaHelper.getReference(sObjectName,this.fieldName);
		this.parentObjectName = (!sObjectTypesList.isEmpty() ? sObjectTypesList[0].getDescribe().getName() : '');

		// Set Read only
		if(fieldName == SObjectType.Claims__Claim__c.fields.Claims__Client__c.Name) CreateClaimHelper.updateClaim(this,createQuery(claim),claim);
	}

	/**
	* @author       Thiyagarajan Selvaraj
	* @date         20/05/2016
	* @description  Method to create soql query, limit it to 2 records - 
	* 				if the query retrieve only one record, make the related claim field read only on the page or make it as an input field
	**/
	public String createQuery(Claims__Claim__c claim){
		String soqlQuery = 'SELECT Id FROM '+this.parentObjectName+' '+(!this.filterMappingsList.isEmpty() ? ' WHERE ' : '');

		// Loop through filter mapping and create the soql filter
		String soqlFilter = '';
		for(FilterMapping filter : this.filterMappingsList){
			soqlFilter+=(!String.isBlank(soqlFilter) ? ' AND ' : '')+filter.getSoqlFilter(claim);
		}
		return soqlQuery+soqlFilter+' LIMIT 2';
	}


	/**
	* @author       Thiyagarajan Selvaraj
	* @date         20/05/2016
	* @description  Soql Filter
	**/
	public class FilterMapping{
		public String fieldToQuery;
		public String fieldToFetchValue;
		public String fieldOperator; 
		public String fieldValue;

		/**
		* @author       Thiyagarajan Selvaraj
		* @date         20/05/2016
		* @description  Constructor
		**/
		public FilterMapping(String fieldToQuery, String fieldToFetchValue, String fieldOperator, String fieldValue){
			this.fieldToQuery = fieldToQuery;
			this.fieldToFetchValue = fieldToFetchValue;
			this.fieldOperator = fieldOperator;
			this.fieldValue = fieldValue;
		}

		/**
		* @author       Thiyagarajan Selvaraj
		* @date         20/05/2016
		* @description  method to get the soqol filter
		**/
		public String getSoqlFilter(Claims__Claim__c claim){
			String soqlFilter = '';
			// check operator type
			if(this.fieldOperator == Constants.INCLUDES){
				soqlFilter = this.fieldToQuery+' INCLUDES(\''+(!String.isBlank(this.fieldValue) ? this.fieldValue : (!String.isBlank(this.fieldToFetchValue) && claim.get(this.fieldToFetchValue) != null ? claim.get(this.fieldToFetchValue) : ''))+'\')';
			}else if(this.fieldOperator == Constants.EQUALS){
				soqlFilter = this.fieldToQuery+' = \''+(!String.isBlank(this.fieldValue) ? this.fieldValue : (claim.get(this.fieldToFetchValue) != null ? claim.get(this.fieldToFetchValue) : ''))+'\'';
			}

			return soqlFilter;
		}
	}
}