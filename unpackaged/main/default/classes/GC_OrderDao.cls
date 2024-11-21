/**
* @author Ethos Solutions - www.ethos.com
* @description DAO for GES Order
* 2016-04-13 : Original Version
**/
public with sharing class GC_OrderDao extends GC_BaseDao {
    
     //@TestVisible
    private static final GC_OrderDao Dao = new GC_OrderDao();
    // @TestVisible
    private static Set<String> relatedFields;

   //  @TestVisible
     private GC_OrderDao() {
        super('GC_Order__c');
        relatedFields = new Set<String> {
            'Connect2_Show__r.Name',
            'Connect2_Show__r.Job_Number__c',
            'Connect2_Show__r.Show_Name__c',
            'Connect2_Show__r.FormulaShowDates__c',
            'Owner.Name',
            '(Select Id, Name, BodyLength, Description from Attachments)' //added for SAL 517-518 @rksinha
        };
        addFields(relatedFields);
    }

    public static GC_OrderDao getInstance() {
        return Dao;
    }

    public GC_Order__c getOrderById(String orderId) {
        return (GC_Order__c)getSObjectById(orderId);
    }
    public List<GC_Order__c> getOrderByIds(Set<String> orderIds) {
        return (List<GC_Order__c>)getSObjectByIdSet('Id', orderIds);
    }
    public List<GC_Order__c> getByConnect2ShowId(String showId) {
        return Database.query(getSelect('Connect2_Show__c = :showId', 'Name', null));
    }
    public List<GC_Order__c> getByConnect2ShowId(String showId, String orderBy) {
        return Database.query(getSelect('Connect2_Show__c = :showId', orderBy, null));
    }
}