/**
* @author Ethos Solutions - www.ethos.com
* @description Test code for the Show On The Go controller
* 2016-04-13 : Original Version
* Modified:31-07-2017
**/
@isTest
public class GC_ShowOnTheGoControllerTest {

    public static testMethod void getShowOnTheGoTest() {
     GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();

     /* Order Creation  */
        GC_Order__c order = new GC_Order__c();
        order.Connect2_Show__c = show.Id;
        insert order;
    /*GES Order TASK Creation */ 
        GC_GES_Order_Task__c got = new GC_GES_Order_Task__c();
        got.Order__c = order.Id;
        insert got;
    /*vendor order task creation  */
        GC_Vendor_Order_Task__c vot = new GC_Vendor_Order_Task__c();
        vot.Order__c = order.Id;
        insert vot;
        
        /* inserting files and attachments */
        Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');
        ContentVersion cv = new ContentVersion();
        cv.title = 'test content trigger';      
        cv.PathOnClient ='test';           
        cv.VersionData =beforeblob;          
        insert cv;
        
        ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=got.id;
        contentlink.ShareType= 'V';
        contentlink.ContentDocumentId=testcontent.ContentDocumentId;
        
        insert contentlink;

        
        GC_PageUtil.setParam('orderIds', order.Id);
    /* creating class Instance */
        GC_ShowOnTheGoController cont = new GC_ShowOnTheGoController();
        cont.gots.add(got);
        cont.vots.add(vot);
        cont.getBaseURL();
        cont.getBaseURLForDocs();
        /* calling the method */
        
        System.assertEquals(cont.orders.size() , 1);
        System.assertEquals(cont.orders.get(0).Connect2_Show__c , order.Connect2_Show__c);
        Set<Id> testIdSet = new set<Id>();
        testIdSet.add(got.id);
        Map<Id, List<Messaging.Emailfileattachment>> testMap = GC_EmailUtils.getFileAttchmentsForMultiple(testIdSet);
        List<Messaging.Emailfileattachment> allFiles= GC_EmailUtils.getFileAttchmentsForSingle(got.id);
        GC_EmailUtils.FileAttachmentsWrapper a = new GC_EmailUtils.FileAttachmentsWrapper();
        

    }
    
}