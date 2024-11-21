/* Class Name: ScheduledBatchableAccountHierarchySetup */

    

@isTest
public class Test_SchedBatchableAccountHierarchySetup{
static  testMethod void test1() {
        
        Test.startTest();
       
            ScheduledBatchableAccountHierarchySetup schdata = new ScheduledBatchableAccountHierarchySetup();
            String sch = '0 0 10 * * ?'; 
            system.schedule('ScheduledBatchableAccountHierarchySetup Class To Be Scheduled', sch, schdata);
             SchedulableContext ctx;
             schdata.execute(ctx);
    
      Test.stopTest();

    }
    }