/*************************************************************************
*
* PURPOSE: DAO for Design Elements
*
* CLASS: DesignElementDao
* CREATED: 12/4/2015 Ethos Solutions - www.ethos.com
* AUTHOR: Zack Smith
***************************************************************************/
public with sharing class GC_DesignElementDao extends GC_BaseDao {

    private static final GC_DesignElementDao DesignElementDao = new GC_DesignElementDao();
    private static Set<String> relatedFields;

    private GC_DesignElementDao() {
        super('GC_Design_Element__c');
        relatedFields = new Set<String> {
            'Design_Request_Form__r.Connect2_Show__c',
            'Design_Request_Form__r.Status__c'
            //'Design_Request_Form__r.Show_Close_Date__c'
        };
        addFields(relatedFields);
    }

    public static GC_DesignElementDao getInstance() {
        return DesignElementDao;
    }

    public GC_Design_Element__c getDesignElementById(String deId) {
        return (GC_Design_Element__c)getSObjectById(deId);
    }

    public List<GC_Design_Element__c> getDesignElementByIds(Set<String> ids) {
        return (List<GC_Design_Element__c>)getSObjectByIdSet('Id', ids);
    }

    public List<GC_Design_Element__c> getDesignElementByIds(Set<Id> ids) {
        Set<String> idStrs = (Set<String>)JSON.deserialize(JSON.serialize(ids), Set<String>.class);
        return (List<GC_Design_Element__c>)getSObjectByIdSet('Id', idStrs);
    }
}