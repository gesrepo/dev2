/**
* @author Ethos Solutions - www.ethos.com
* @description DAO for GES Order Task
* 2016-04-13 : Original Version
**/
public with sharing class GC_GESOrderTaskDao extends GC_BaseDao {

    private static final GC_GESOrderTaskDao GESOrderTaskDao = new GC_GESOrderTaskDao();
    private static Set<String> relatedFields;

    public GC_GESOrderTaskDao() {
        super('GC_GES_Order_Task__c');
        relatedFields = new Set<String> {
            'Onsite_Contact_Person__r.Name',
            'Previous_Revision__r.Name',
            'SA_Venue_Location__r.Name',
            'Department__r.Name',
            'Order__r.Connect2_Show__c',
            'Order__r.Connect2_Show__r.Job_Number__c',
            'Order__r.Connect2_Show__r.Name',
            'Order__r.Connect2_Show__r.Opportunity_Name__c',        //FOR SAL-421 to disply oppty name
            'Order__r.Order_Area_Description__c',
            'Material__r.Name',
            'Parent_GEM_Structure__r.Name',
            'Order__r.Name',
            'Order__r.Show_Name__c',
            'Owner.Name',
            'LastModifiedBy.Name',
            'CreatedBy.Name',                                       //FOR SAL-421 to disply created by and LMB names
            'Onsite_Contact__r.Name',
            '(Select Id, ParentId, Title, IsNote from NotesAndAttachments)',
            '(Select Id, Name, BodyLength, Description from Attachments)',
            '(select id,ContentDocumentId  from ContentDocumentLinks)'
        };
        addFields(relatedFields);
    }

    public static GC_GESOrderTaskDao getInstance() {
        return GESOrderTaskDao;
    }

    public GC_GES_Order_Task__c getGESOrderTaskById(String gesId) {
        return (GC_GES_Order_Task__c)getSObjectById(gesId);
    }

    public List<GC_GES_Order_Task__c> getByConnect2ShowId(String showId) {
        return Database.query(getSelect('Order__r.Connect2_Show__c = :showId', '', null));
    }

    public List<GC_GES_Order_Task__c> getByConnect2ShowId(String showId, String orderBy) {
        return Database.query(getSelect('Order__r.Connect2_Show__c = :showId', orderBy, null));
    }

    public List<GC_GES_Order_Task__c> getByGesOrderId(String orderId) {
        return Database.query(getSelect('Order__c = :orderId', 'Name', null));
    }

    public List<GC_GES_Order_Task__c> getByGesOrderIdAndExcludeStatus(String orderId, String excludedStatus) {
        return Database.query(getSelect('Order__c = :orderId AND Status__c != :excludedStatus', 'Name', null));
    }

    public List<GC_GES_Order_Task__c> getByGesOrderIdDesc(String orderId) {
        return Database.query(getSelect('Order__c = :orderId', 'Name desc', null));
    }

    public List<GC_GES_Order_Task__c> getByWhere(String whereClause) {
        return Database.query(getSelect(whereClause, 'Name', null));
    }

    public List<GC_GES_Order_Task__c> getGesOrderTaskByOrderSet(Set<String> orderIds) {
        return (List<GC_GES_Order_Task__c>)getSObjectByIdSet('Order__c', orderIds);
    }

    public List<GC_GES_Order_Task__c> getGesOrderTaskOrderByOrderSet(Set<String> orderIds) {
        return (List<GC_GES_Order_Task__c>)getSObjectByIdSet('Order__c', orderIds, null, 'Item_Template__c');
    }
    
    public List<GC_GES_Order_Task__c> getGesOrderTaskOrderByStatus(Set<String> orderIds,String whereClause) {
        return (List<GC_GES_Order_Task__c>)getSObjectByIdSet('Order__c', orderIds, whereClause, 'Item_Template__c');
    }

    public List<GC_GES_Order_Task__c> getGESOrderTaskByIds(Set<String> gesIds) {
        return (List<GC_GES_Order_Task__c>)getSObjectByIdSet('Id', gesIds);
    }
    
    public List<GC_GES_Order_Task__c> getGESItemsByIdAndExcludeStatus(Set<String> itemIds, String excludedStatus) {
        return Database.query(getSelect('Id IN :itemIds AND Status__c != :excludedStatus', 'Name', null));
    }
}