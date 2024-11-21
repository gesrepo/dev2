/*************************************************************************
*
* PURPOSE: DAO for Opportunities
*
* CLASS: OpportunityDao
* CREATED: 12/3/2014 Ethos Solutions - www.ethos.com
* AUTHOR: Ben Faber
***************************************************************************/
public with sharing class GC_OpportunityDao extends GC_BaseDao {

    private static final GC_OpportunityDao OpportunityDao = new GC_OpportunityDao();
    private static Set<String> relatedFields;

    private GC_OpportunityDao() {
        super('Opportunity');
        relatedFields = new Set<String> {
              'Owner.Email'  //Amarab 04/16/2021 SFDC-169 New Email Notification - Client Serv Manager
            , 'Facility__r.Name'
            , 'Facility__r.BillingStreet'
            , 'Facility__r.BillingCity'
            , 'Facility__r.BillingState'
            , 'Facility__r.BillingPostalCode'
            , 'Facility__r.BillingCountry'
            , 'Facility__r.Phone'
            , 'Show_Name__r.Name'
            , 'Show_Name__r.Show_ID__c'
            , 'Show_Name__r.Show_Type__c' //Amarab 06/24/2021 SAL-1255 Allow E&D record types to create Project Central show records
            , 'Show_Occurrence__r.Show_Name__r.Name'
            , 'Show_Occurrence__r.Show_Name__r.Show_ID__c'
            , 'Show_Occurrence__r.Show_Name__r.Show_Type__c'
            , 'Show_Occurrence__r.Show_Open_Date__c'
            , 'Show_Occurrence__r.Show_Close_Date__c'
            , 'Show_Occurrence__r.Production_Location__c'
            , 'Show_Occurrence__r.LMS_Facility_ID__c'          
            , 'Show_Occurrence__r.Facility__r.Id'
            , 'Show_Occurrence__r.Facility__r.Name'
            , 'Show_Occurrence__r.Facility__r.BillingStreet'
            , 'Show_Occurrence__r.Facility__r.BillingCity'
            , 'Show_Occurrence__r.Facility__r.BillingState'
            , 'Show_Occurrence__r.Facility__r.BillingPostalCode'
            , 'Show_Occurrence__r.Facility__r.BillingCountry'           
            , 'Non_Show__r.Name' 
            , 'Non_Show__r.Show_ID__c'
            , 'Non_Show__r.Show_Open__c'
            , 'Non_Show__r.Show_Close__c'
            , 'Non_Show__r.LMS_Facility_ID__c'
            , 'Non_Show__r.Facility__r.Id'
            , 'Non_Show__r.Facility__r.Name'
            , 'Non_Show__r.Facility__r.BillingStreet'
            , 'Non_Show__r.Facility__r.BillingCity'
            , 'Non_Show__r.Facility__r.BillingState'
            , 'Non_Show__r.Facility__r.BillingPostalCode'
            , 'Non_Show__r.Facility__r.BillingCountry'
            , 'Non_Show__r.Ship_To_Company__c'
            , 'Non_Show__r.Shipping_Street__c' 
            , 'Non_Show__r.Shipping_City__c' 
            , 'Non_Show__r.Shipping_State_Province__c' 
            , 'Non_Show__r.Shipping_Zip_Postal_Code__c' 
            , 'Non_Show__r.Shipping_Country__c' 
            , 'Non_Show__r.Production_Location__c'
        };
        addFields(relatedFields);
    }

    public static GC_OpportunityDao getInstance() {
        return OpportunityDao;
    }

    public Opportunity getOppById(String oppId) {
        return (Opportunity)getSObjectById(oppId);
    }

    public List<Opportunity> getByOppIds(Set<String> oppIds) {
        return (List<Opportunity>)getSObjectByIdSet('Id', oppIds);
    }
}