@isTest
public class GC_PageUtil_Test 
{
    public static testMethod void testMethod1() 
    {
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        show.Job_Number__c = '1';
        update show;
        
        GC_Show_Attribute__c sa = new GC_Show_Attribute__c();
        sa.Name_Unique__c = 'Test Attribute';
        sa.Connect2_Show__c = show.Id;
        sa.RecordTypeId = GC_TestUtils.getRecordType('GC_Show_Attribute__c').get('Venue Location').Id;
        sa.Name = 'Test Venue';
        insert sa;
        
        GC_Show_Attribute__c sa2 = new GC_Show_Attribute__c();
        sa2.Connect2_Show__c = show.Id;
        sa2.RecordTypeId = GC_TestUtils.getRecordType('GC_Show_Attribute__c').get('Material').Id;
        sa2.Name = 'Test Material';
        insert sa2;
        
        GC_Order__c order = new GC_Order__c();
        order.Connect2_Show__c = show.Id;
        order.Booth_Area__c  = 'Area';
        order.Booth_Area_ID__c = '1390259';
        insert order;
        
        GC_GES_Order_Task__c got = new GC_GES_Order_Task__c();
        got.Order__c = order.Id;
        got.Item_Category_ID__c = '1896';
        got.Item_Number__c = '300004';
        got.Description__c = 'Test Item Description';
        got.Item_Template__c = 'Basic';
        got.QuantityNum__c = 1;
        got.UOM__c = 'EA';
        got.Status__c = 'Approved';
        got.Show_Management_Field__c = 'Yes';
        got.File_Reference_Link__c = 'link';
        got.Completion_Date_Time__c = DateTime.Now();
        got.Removal_Date_Time__c = DateTime.Now();
        got.Delivery_Date_Time__c = DateTime.Now();
        got.Price__c = '11.59';
        got.New_Price__c = 12;
        got.SA_Venue_Location__c = sa.Id;
        got.Description__c = 'test Desciption';
        got.Invoice_Remarks__c = 'test remarks';
        got.Production_Remarks__c = 'test remarks';
        got.Item_Type_Remarks__c = 'test remarks';
        got.Show_Site_Remarks__c = 'test show site remarks';
        
        
        GC_GES_Order_Task__c got1 = new GC_GES_Order_Task__c();
        got1.Order__c = order.Id;
        got1.Item_Category_ID__c = '1896';
        got1.Item_Number__c = '300004';
        got1.Description__c = 'Test Item Description';
        got1.Item_Template__c = 'Graphics';
        got1.GOT_Single_Double_Sided__c = 'Double';
        got1.QuantityNum__c = 1;
        got1.Status__c = 'Approved';
        got1.Sign_Title__c = 'test sign';
        got1.Show_Management_Field__c = 'Yes';
        got1.File_Reference_Link__c = 'link';
        got1.Layout__c = 'test layout';
        got1.Sign_Copy__c = 'test copy';
        got1.Installation_Method__c = 'test installation method';
        got1.GOT_Sign_Type__c = 'sign type test';
        got1.GOT_Copy_Placement__c = 'copy placement';
        got1.Material__c = sa2.Id;
        got1.Save_Signs__c = 'yes';
        got1.GOT_Background__c = 'test background';
        
        
        GC_GES_Order_Task__c got2 = new GC_GES_Order_Task__c();
        got2.Order__c = order.Id;
        got2.Item_Category_ID__c = '1896';
        got2.Item_Number__c = '300004';
        got2.Description__c = 'Test Item Description';
        got2.Item_Template__c = 'Custom Graphics';
        got2.GOT_Single_Double_Sided__c = 'Single';
        got2.Sign_Length__c = 20;
        got2.Sign_Width__c = 15;
        got2.QuantityNum__c = 1;
        got2.Status__c = 'Approved';
        got2.Show_Management_Field__c = 'Yes';
        got2.File_Reference_Link__c = 'link';
        got2.Sign_Title__c = 'test sign';
        got2.Show_Management_Field__c = 'Yes';
        got2.File_Reference_Link__c = 'link';
        got2.Layout__c = 'test layout';
        got2.Sign_Copy__c = 'test copy';
        got2.Installation_Method__c = 'test installation method';
        got2.GOT_Sign_Type__c = 'sign type test';
        got2.GOT_Copy_Placement__c = 'copy placement';
        got2.Material__c = sa2.Id;
        got2.Save_Signs__c = 'yes';
        got2.GOT_Background__c = 'test background';
        
        GC_GES_Order_Task__c got3 = new GC_GES_Order_Task__c();
        got3.Order__c = order.Id;
        got3.Item_Category_ID__c = '1896';
        got3.Item_Number__c = '300004';
        got3.Description__c = 'Test Item Description';
        got3.Item_Template__c = 'Carpet';
        got3.Electrical_Ordered__c = false;
        got3.Electrical_Under__c = false;
        got3.UOM__c = 'EA';
        got3.QuantityNum__c = 1;
        got3.Status__c = 'Approved';
        got3.Show_Management_Field__c = 'Yes';
        got3.File_Reference_Link__c = 'link';
        
        GC_GES_Order_Task__c got4 = new GC_GES_Order_Task__c();
        got4.Order__c = order.Id;
        got4.Item_Category_ID__c = '1896';
        got4.Item_Number__c = '300004';
        got4.Description__c = 'Test Item Description';
        got4.Item_Template__c = 'Custom Carpet';
        got4.Electrical_Ordered__c = true;
        got4.Electrical_Under__c = true;
        got4.UOM__c = 'SF';
        got4.Carpet_Length__c = 10;
        got4.QuantityNum__c = 200;
        got4.Status__c = 'Approved';
        got4.Show_Management_Field__c = 'Yes';
        got4.File_Reference_Link__c = 'link';
        
        GC_GES_Order_Task__c got5 = new GC_GES_Order_Task__c();
        got5.Order__c = order.Id;
        got5.Status__c = 'New';
        
        insert got;
        insert got1;
        insert got2;
        insert got3;
        insert got4;
        insert got5;
        
       
        
        GC_PageUtil.getParam('test');
        GC_PageUtil.setParam('test','test1');
        GC_PageUtil.AddDeveloperMessage('test','test');
        GC_PageUtil.AddDeveloperMessage('test');
        GC_PageUtil.AddInfoMessage('test');
        GC_PageUtil.AddErrorMessage('test');
        GC_PageUtil.AddWarningMessage('test');
        GC_PageUtil.AddFatalMessage('test');
        GC_PageUtil.AddConfirmMessage('test');
        GC_PageUtil.IsLightningUI();
        GC_PageUtil.IsClassicUI();
        GC_PageUtil.CheckApexDomain();
        GC_PageUtil.cloneTask(got4);
        GC_PageUtil.cloneOrder(order); 
        GC_PageUtil.validateGesTask(got3);
        
    }
    
   public static testMethod void testMethod2(){
        
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        show.Job_Number__c = '1';
        update show;
        
        GC_Order__c order = new GC_Order__c();
        order.Connect2_Show__c = show.Id;
        order.Booth_Area__c  = 'Area';
        order.Booth_Area_ID__c = '1390259';
        insert order;
        
        Profile testProfile = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User testUser = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = testProfile.Id,TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1230@testorg.com');
        insert testUser;
        
        GC_GES_Order_Task__c task = new GC_GES_Order_Task__c();
        task.Order__c = order.Id;
        task.Item_Category_ID__c = '1896';
        task.Item_Number__c = '300004';
        task.Description__c = 'Test Item Description';
        task.Item_Template__c = 'Custom Carpet';
        task.Electrical_Ordered__c = true;
        task.Electrical_Under__c = true;
        task.UOM__c = 'SF';
        task.Carpet_Length__c = 10;
        task.QuantityNum__c = 200;
        task.Status__c = 'Approved';
        task.Show_Management_Field__c = 'Yes';
        task.File_Reference_Link__c = 'link';
        task.OwnerId = testUser.id;
        
        insert task;
        
        GC_PageUtil.exportToCSV(order.Id,true);
        GC_PageUtil.getFieldData('Owner.Name',task,true);
        
        List<GC_GES_Order_Task__c> testTaskList = new List<GC_GES_Order_Task__c>();
       	Set<Id> testTaskIdSet = new Set<Id>(); 
        
        
        for(Integer i=0 ; i<3 ; i++){
            GC_GES_Order_Task__c testTask = new GC_GES_Order_Task__c();
            testTask.Order__c = order.Id;
            testTask.Item_Category_ID__c = '1896';
            testTask.Item_Number__c = '300004';
            testTask.Description__c = 'Test Item Description';
            testTask.Item_Template__c = 'Custom Carpet';
            testTask.Electrical_Ordered__c = true;
            testTask.Electrical_Under__c = true;
            testTask.UOM__c = 'SF';
            testTask.Carpet_Length__c = 10 + i;
            testTask.QuantityNum__c = 200;
            testTask.Status__c = 'Approved';
            testTask.Show_Management_Field__c = 'Yes';
            testTask.File_Reference_Link__c = 'link';
            
            testTaskIdSet.add(testTask.Id);
            testTaskList.add(testTask);
        }
        insert testTaskList;
        
        Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');

        ContentVersion cv = new ContentVersion();
        cv.title = 'test content trigger';      
        cv.PathOnClient ='test';           
        cv.VersionData =beforeblob;          
        insert cv;         

      /*  ContentVersion testContent = [SELECT  ContentDocumentId FROM ContentVersion where Id = :cv.Id];

        
        List<contentdocumentlink> contentDocumentLinkList = new List<contentdocumentlink>();
        
        for(GC_GES_Order_Task__c testTask : testTaskList){
            contentdocumentlink contentLink = new contentdocumentlink();
            contentLink.LinkedEntityId=testTask.Id;
            contentLink.ShareType= 'V';   
            contentLink.Visibility = 'AllUsers';
            contentlink.ContentDocumentId=testcontent.ContentDocumentId;
            
            contentDocumentLinkList.add(contentLink);
        }
        insert contentDocumentLinkList;
        
        GC_PageUtil.cloneTaskFiles(testTaskIdSet);*/
    }
    public static testMethod void testMethod3(){
        
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        show.Job_Number__c = '1';
        update show;
        
        GC_Order__c order = new GC_Order__c();
        order.Connect2_Show__c = show.Id;
        order.Booth_Area__c  = 'Area';
        order.Booth_Area_ID__c = '1390259';
        insert order;
        
        Profile testProfile = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User testUser = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = testProfile.Id,TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1230@testorg.com');
        insert testUser;
        
        GC_GES_Order_Task__c task = new GC_GES_Order_Task__c();
        task.Order__c = order.Id;
        task.Item_Category_ID__c = '1896';
        task.Item_Number__c = ' ';
        task.Description__c = 'Test Item Description';
        task.Item_Template__c = 'Custom Graphics';
        task.Electrical_Ordered__c = true;
        task.Electrical_Under__c = true;
        task.UOM__c = 'SF';
        task.Carpet_Length__c = 10;
        task.QuantityNum__c = 200;
        task.Status__c = 'Approved';
        task.Show_Management_Field__c = 'Yes';
        task.File_Reference_Link__c = 'link';
        task.OwnerId = testUser.id;
        task.Sign_Length__c=10.0;
        insert task;
        
        GC_PageUtil.validateGesTask(task);
        GC_PageUtil.exportToCSV(order.Id,true);
        GC_PageUtil.getFieldData('Owner.Name',task,true);
        
        List<GC_GES_Order_Task__c> testTaskList = new List<GC_GES_Order_Task__c>();
       	Set<Id> testTaskIdSet = new Set<Id>(); 
        
        
        for(Integer i=0 ; i<3 ; i++){
            GC_GES_Order_Task__c testTask = new GC_GES_Order_Task__c();
            testTask.Order__c = order.Id;
            testTask.Item_Category_ID__c = '1896';
            testTask.Item_Number__c = '300004';
            testTask.Description__c = 'Test Item Description';
            testTask.Item_Template__c = 'Custom Graphics';
            testTask.Electrical_Ordered__c = true;
            testTask.Electrical_Under__c = true;
            testTask.UOM__c = 'SF';
            testTask.Carpet_Length__c = 10 + i;
            testTask.QuantityNum__c = 200;
            testTask.Status__c = 'Approved';
            testTask.Show_Management_Field__c = 'Yes';
            testTask.File_Reference_Link__c = 'link';
            testTask.Sign_Length__c=10.0;
            testTaskIdSet.add(testTask.Id);
            testTaskList.add(testTask);
            
        }
        insert testTaskList;
        
         GC_GES_Order_Task__c task1 = new GC_GES_Order_Task__c();
        task1.Order__c = order.Id;
        task1.Item_Category_ID__c = '1896';
        task1.Item_Number__c = '30005';
        task1.Description__c = 'Test Item Description';
        task1.Item_Template__c = ' ';
        task1.Electrical_Ordered__c = true;
        task1.Electrical_Under__c = true;
        task1.UOM__c = 'SF';
        task1.Carpet_Length__c = 10;
        task1.QuantityNum__c = 200;
        task1.Status__c = 'Approved';
        task1.Show_Management_Field__c = 'Yes';
        task1.File_Reference_Link__c = 'link';
        task1.OwnerId = testUser.id;
        task1.Sign_Length__c=10.0;
        insert task1;
        
        GC_PageUtil.validateGesTask(task1);
       
          GC_GES_Order_Task__c task2 = new GC_GES_Order_Task__c();
        task2.Order__c = order.Id;
        task2.Item_Category_ID__c = '1896';
        task2.Item_Number__c = '30005';
        task2.Description__c = 'GRAPHICS FOR GEM STRUCTURE';
        task2.Item_Template__c = ' Custom Graphics';
        task2.Electrical_Ordered__c = true;
        task2.Electrical_Under__c = true;
        task2.UOM__c = 'SF';
        task2.QuantityNum__c = 200;
        task2.Status__c = 'Approved';
        task2.Show_Management_Field__c = 'Yes';
        task2.File_Reference_Link__c = 'link';
        task2.OwnerId = testUser.id;
        task2.Sign_Length__c=10.0;
        insert task2;
        
        GC_PageUtil.validateGesTask(task2);
       
         GC_GES_Order_Task__c task3 = new GC_GES_Order_Task__c();
        task3.Order__c = order.Id;
        task3.Item_Category_ID__c = '1896';
        task3.Item_Number__c = '30005';
        task3.Description__c = 'GRAPHICS FOR GEM STRUCTURE';
        task3.Item_Template__c = 'Carpet';
        task3.Electrical_Ordered__c = true;
        task3.Electrical_Under__c = true;
        task3.UOM__c = 'SF';
        task3.QuantityNum__c = null;
        task3.Status__c = 'Approved';
        task3.Show_Management_Field__c = 'Yes';
        task3.File_Reference_Link__c = 'link';
        task3.OwnerId = testUser.id;
        task3.Sign_Length__c=10.0;
        insert task3;
        
        GC_PageUtil.validateGesTask(task3);
    }
 /*   public static testMethod void testMethod4(){
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        show.Job_Number__c = '1';
        update show;
        
        GC_Show_Attribute__c sa = new GC_Show_Attribute__c();
        sa.Name_Unique__c = 'Test Attribute';
        sa.Connect2_Show__c = show.Id;
        sa.RecordTypeId = GC_TestUtils.getRecordType('GC_Show_Attribute__c').get('Venue Location').Id;
        sa.Name = 'Test Venue';
        insert sa;
        
        GC_Show_Attribute__c sa2 = new GC_Show_Attribute__c();
        sa2.Connect2_Show__c = show.Id;
        sa2.RecordTypeId = GC_TestUtils.getRecordType('GC_Show_Attribute__c').get('Material').Id;
        sa2.Name = 'Test Material';
        insert sa2;
        
        GC_Order__c order = new GC_Order__c();
        order.Connect2_Show__c = show.Id;
        order.Booth_Area__c  = 'Area';
        order.Booth_Area_ID__c = '1390259';
        insert order;
        
         Map<String, User> portalUsers = GC_TestUtils.getPortalUsers();
        User vendor = portalUsers.get('GC Community Vendor');
        
        GC_Vendor_Order_Task__c vot = new GC_Vendor_Order_Task__c();
        vot.Order__c = order.Id;
        vot.Vendor__c = vendor.Id;
        vot.Vendor_Instructions__c = 'Do This';
        vot.Status__c = 'New';
        
        insert vot;
        
           GC_PageUtil.cloneTask(vot);
        
    }*/
    
  
}