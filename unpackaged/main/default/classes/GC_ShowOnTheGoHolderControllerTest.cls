/**
* @author Ethos Solutions - www.ethos.com
* @description Test code for the Show On The Go Holder controller
* 2016-04-13 : Original Version
**/
@isTest
public class GC_ShowOnTheGoHolderControllerTest {
    
    public static testMethod void selectTasks() {
        
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        
        //GC_Order__c order = new GC_Order__c();
        //order.Connect2_Show__c = show.Id;
        //insert order;
        
        User usr = [SELECT Id, Name FROM User WHERE Id = :userinfo.getUserId() LIMIT 1];
        
        GC_Order__c order = new GC_Order__c();
        order.Connect2_Show__c = show.Id;
        order.Order_Area_Description__c = 'testing';
        order.Booth_Area__c='Bangalore';
        insert order;
        
        GC_Show_Attribute__c GCshow=new GC_Show_Attribute__c();
        GCshow.Connect2_Show__c =show.Id;
        GCshow.name='test';
        insert GCshow;
        
        GC_GES_Order_Task__c got = new GC_GES_Order_Task__c();
        got.Order__c = order.Id;
        got.Delivery_Location__c = 'testing';
        got.Department__c=GCshow.id;
        insert got;
        
        GC_Vendor_Order_Task__c vot = new GC_Vendor_Order_Task__c();
        vot.Order__c = order.Id;
        vot.Vendor__c=usr.Id;
        insert vot ;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(show);
        ApexPages.currentPage().getParameters().put('initialOrderByQuery' , 'Order_Number__c');
        
        GC_OrderHolder orderHolder = new GC_OrderHolder(order);
        orderHolder.selected = true;
        List<GC_OrderHolder> holderList = new List<GC_OrderHolder>();
        holderList.add(orderHolder);
        
        GC_ShowOnTheGoHolderController cont = new GC_ShowOnTheGoHolderController(sc);
        cont.orderHolders = holderList;
        cont.signOrderOpt='false';
        cont.workOrderOpt='false';
        cont.pdfByLocation = true;
        PageReference pr;
        pr = cont.itemsSelected();
        GC_Core_Interface_Log__c ilog = [select Id, Name from GC_Core_Interface_Log__c];
        //System.assertEquals(pr.getUrl() , ('/apex/GC_ShowOnTheGoPDF?urlParamsId=' + ilog.Id+'&signOrderOpt='+cont.signOrderOpt+'&workOrderOpt='+cont.workOrderOpt));
        //System.assertEquals(pr.getUrl() , ('/apex/GC_ShowOnTheGoPDF?urlParamsId=' + ilog.Id));
        
        cont.Username=new List<String>();
        cont.searchString = 'test';
        
        cont.getDateString(Date.today());
        cont.modifiedDateFrom = (Date.today());
        cont.modifiedDateTo = (Date.today());
        cont.createdDateFrom = (Date.today());
        cont.createdDateTo = (Date.today());
        cont.showDateDelivery = (Date.today());
        cont.showDateRemoval = (Date.today());
        cont.showDateCompletion = (Date.today()); 
        cont.onsiteContactPerson = new List<String>();
        cont.onsiteContactPersonOther = new List<String>();
        cont.searchString = 'test';
        cont.deliveryLocation = 'US';
        cont.department ='Graphics';
        cont.searchResults();
        cont.Username.add('Rahul Sinha');
        cont.SavePDFFilter();
        cont.resetSearch();
        cont.itemsSelectedtoExportCSV();
        cont.performSort();
        List<String> st = new  List<String>();
        st.add('element');
        cont.filterString(st);
    }
}