@isTest
Public class accc_Batch_Scheduler_Test{
    
    public static List<Case> Caselist{set;get;}
    static testmethod void test1() {
        Account acc = TestDataUtil.CreateTestFacility(); 
         Account acc1 = TestDataUtil.CreateTestFirm(); 
        Contact con = TestDataUtil.CreateTestContact(acc1.Id);
        Show__c show = TestDataUtil.CreateTestShow(acc1.id);
        Opportunity opp = TestDataUtil.CreateTestSalesRepOpp(acc.Id, acc1.Id, show.Id);
        Oracle_Show_Booth__c booth = TestDataUtil.CreateTestBooth(acc1.Id, opp.id, '1111', show.Id);
        Case caseR = TestDataUtil.CreateTestCase(acc1.Id, booth.Id, con.Id, opp.Id);
        
        
        Activity_Log_ACCC__c varA= new Activity_Log_ACCC__c ();
        varA.Customer_Service_Inquiry_Case__c= caseR.id;
        varA.CC_Received_and_Validated__c =false;
        varA.Customer_Service_Inquiry_Case__c= caseR.id;
        varA.Payment_ID_Info__c= 'e6271912-d82f-4513-9248-68849f42a44e';
        varA.Session_ID_info__c ='207958e2-54ef-46f8-94c4-f8a88c56563b';
        varA.Contact_Email_Adress__c='soniya.gopu@slkgroup.com';        
        insert varA; 
        
        Test.startTest();
           Test.setMock(WebServiceMock.class, new acccValidatePatmentBatch_Mock());  
           acccValidatePatmentBatch bclass = new acccValidatePatmentBatch();
           Database.BatchableContext bc;
           // Database.executeBatch(d);
           Database.QueryLocator itrbl = bclass.start(bc);  //start() returns an iterable, in my case, a custom iterable. Note the casting
              Database.QueryLocatorIterator  itrator =  itrbl.iterator();  // continue simulation of start() by constructing the iterator
              List<Activity_Log_ACCC__c> aScopeList = new List<Activity_Log_ACCC__c> ();      // create scope for execute() by iterating against the result of the mocked callout
              while (itrator.hasNext()) {
                 aScopeList.add((Activity_Log_ACCC__c)itrator.next());
              }
              // Now invoke execute() w/ Account list built via mocked callout invoked by start()
              bClass.execute(bc,aScopeList);
             
              // Finally, invoke finish()
              bClass.finish(bc);   
        Test.stopTest();
       
    }
   
    //  Public void finish(Database.BatchableContext BC) {   
   // }
   
    
    static testmethod void test2() { 
        Test.startTest();
        Test.setMock(WebServiceMock.class, new acccValidatePatmentBatch_Mock()); 
        Datetime dt = Datetime.now().addMinutes(1);
        String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
        String jobId = System.schedule('acccValidatePatmentBatch', CRON_EXP, new accc_Batch_Scheduler() );   
        Test.stopTest();
    }
   
}