/*************************************************************************
*
* PURPOSE: DAO for Design Request Form
*
* CLASS: DesignRequestFormDao
* CREATED: 12/4/2015 Ethos Solutions - www.ethos.com
* AUTHOR: Zack Smith
***************************************************************************/
public with sharing class GC_DesignRequestFormDao extends GC_BaseDao {

    private static final GC_DesignRequestFormDao DesignRequestFormDao = new GC_DesignRequestFormDao();
    private static Set<String> relatedFields;

    private GC_DesignRequestFormDao() {
        super('GC_Design_Request_Form__c');
    }

    public static GC_DesignRequestFormDao getInstance() {
        return DesignRequestFormDao;
    }

    public GC_Design_Request_Form__c getDesignRequestFormById(String drfId) {
        return (GC_Design_Request_Form__c)getSObjectById(drfId);
    }

    public List<GC_Design_Request_Form__c> getDesignRequestFormByIds(Set<String> drfIds) {
        return (List<GC_Design_Request_Form__c>)getSObjectByIdSet('Id', drfIds);
    }
}