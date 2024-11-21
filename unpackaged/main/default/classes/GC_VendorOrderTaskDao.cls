/**
* @author Ethos Solutions - www.ethos.com
* @description DAO for Vendor Order Tasks
* 2016-04-13 : Original Version
**/
public with sharing class GC_VendorOrderTaskDao extends GC_BaseDao {
    private static final GC_VendorOrderTaskDao VendorOrderTaskDao = new GC_VendorOrderTaskDao();
    private static Set<String> relatedFields;

    public GC_VendorOrderTaskDao() {
        super('GC_Vendor_Order_Task__c');
        relatedFields = new Set<String> {
            'Order__r.Connect2_Show__r.Name',
            'Order__r.Connect2_Show__r.FormulaShowDates__c',
            'Order__r.Name',
            'Order__r.Show_Name__c',
            'Vendor__r.Name',
            'Vendor2__r.Name',
            'Vendor3__r.Name',
            'Vendor4__r.Name',
            'Vendor5__r.Name',
            'Vendor__r.Email',
            'Vendor2__r.Email',
            'Vendor3__r.Email',
            'Vendor4__r.Email',
            'Vendor5__r.Email',
            'Service_Type__r.Name',
            'Service_Type2__r.Name',
            'Service_Type3__r.Name',
            'Service_Type4__r.Name',
            'Service_Type5__r.Name',
            'GESOrderTask1__r.Name',
            'GESOrderTask2__r.Name',
            'GESOrderTask3__r.Name',
            'GESOrderTask4__r.Name',
            'GESOrderTask5__r.Name',
            'GESOrderTask1__r.Description__c',
            'GESOrderTask2__r.Description__c',
            'GESOrderTask3__r.Description__c',
            'GESOrderTask4__r.Description__c',
            'GESOrderTask5__r.Description__c',
            'GESOrderTask1__r.Status__c',
            'GESOrderTask2__r.Status__c',
            'GESOrderTask3__r.Status__c',
            'GESOrderTask4__r.Status__c',
            'GESOrderTask5__r.Status__c',
            'SA_Venue_Location_Ven__r.Name',
            'Owner.Name',
            '(Select Id, ParentId, Title, IsNote from NotesAndAttachments)',
            '(Select Id, Name, BodyLength, Description from Attachments)',
            '(select id,ContentDocumentId  from ContentDocumentLinks)'
        };


        addFields(relatedFields);
    }
    public static GC_VendorOrderTaskDao getInstance() {
        return VendorOrderTaskDao;
    }

    public GC_Vendor_Order_Task__c getVendorOrderTaskById(String votId) {
        return (GC_Vendor_Order_Task__c)getSObjectById(votId);
    }

    public GC_Vendor_Order_Task__c getVendorOrderTaskById1(String votId) {
        return (GC_Vendor_Order_Task__c)getSObjectById1(votId);
    }

    public List<GC_Vendor_Order_Task__c> getByConnect2ShowId(String showId) {
        return Database.query(getSelect('Order__r.Connect2_Show__c = :showId', '', null));
    }

    public List<GC_Vendor_Order_Task__c> getByGesOrderId(String orderId) {
        return Database.query(getSelect('Order__c = :orderId', '', null));
    }
    public List<GC_Vendor_Order_Task__c> getVendorOrderTaskByOrderSet(Set<String> orderIds) {
        return (List<GC_Vendor_Order_Task__c>)getSObjectByIdSet('Order__c', orderIds);
    }

    public List<GC_Vendor_Order_Task__c> getVendorOrderTaskByStatus(Set<String> orderIds,String whereClause) {
        return (List<GC_Vendor_Order_Task__c>)getSObjectByIdSet('Order__c', orderIds, whereClause, null);
    }
    
    public List<GC_Vendor_Order_Task__c> getVendorOrderTaskByIds(Set<String> votIds) {
        return (List<GC_Vendor_Order_Task__c>)getSObjectByIdSet('Id', votIds);
    }

    public sObject getSObjectById1(String recordId) {
        if (recordId == null) {
            return null;    //---Prevent null error if no records returned;
        }
        String query = 'select Name,SelectAllOrderTasks__c,CreatedDate,Vendor_Instructions__c,Order__r.Connect2_Show__r.Name,Order__r.Connect2_Show__r.FormulaShowDates__c,Order__r.Name,Order__r.Show_Name__c,Vendor__r.Name,Vendor2__r.Name,Vendor3__r.Name,Vendor4__r.Name,Vendor5__r.Name,Vendor__r.Email,Vendor2__r.Email,Vendor3__r.Email,Vendor4__r.Email,Vendor5__r.Email,Service_Type__r.Name,Service_Type2__r.Name,Service_Type3__r.Name,Service_Type4__r.Name,Service_Type5__r.Name,GESOrderTask1__r.Name,GESOrderTask2__r.Name,GESOrderTask3__r.Name,GESOrderTask4__r.Name,GESOrderTask5__r.Name,GESOrderTask1__r.Description__c,GESOrderTask2__r.Description__c,GESOrderTask3__r.Description__c,GESOrderTask4__r.Description__c,GESOrderTask5__r.Description__c,GESOrderTask1__r.Status__c,GESOrderTask2__r.Status__c,GESOrderTask3__r.Status__c,GESOrderTask4__r.Status__c,GESOrderTask5__r.Status__c,Owner.Name,SA_Venue_Location_Ven__r.Name,Delivery_Location_Ven__c,Delivery_Date_Time_Ven__c,Completion_Date_Time_Ven__c,Removal_Date_Time_Ven__c,Status__c,Submitted_Date__c,(Select Id, ParentId, Title, IsNote from NotesAndAttachments),(Select Id, Name, BodyLength, Description from Attachments) from GC_Vendor_Order_Task__c  where id = ' + quote(recordId);
        return (SObject)Database.query(query);
    }
}