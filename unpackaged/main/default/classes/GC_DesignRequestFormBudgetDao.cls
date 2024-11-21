/*************************************************************************
*
* PURPOSE: DAO for Design Request Form
*
* CLASS: DesignRequestFormDao
* CREATED: 12/4/2015 Ethos Solutions - www.ethos.com
* AUTHOR: Ben Faber
***************************************************************************/
public with sharing class GC_DesignRequestFormBudgetDao extends GC_BaseDao {

    private static final GC_DesignRequestFormBudgetDao DesignRequestFormBudgetDao = new GC_DesignRequestFormBudgetDao();
    private static Set<String> relatedFields;

    private GC_DesignRequestFormBudgetDao() {
        super('GC_Design_Request_Form_Budget__c');
    }

    public static GC_DesignRequestFormBudgetDao getInstance() {
        return DesignRequestFormBudgetDao;
    }

    public List<GC_Design_Request_Form_Budget__c> getByDrfId(String drfId) {
        return (List<GC_Design_Request_Form_Budget__c>)getSObjectByIdSet('Design_Request_Form__c', new Set<String> {drfId}, null, 'Name desc');
    }
}