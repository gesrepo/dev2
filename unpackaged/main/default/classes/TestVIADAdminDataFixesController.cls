/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestVIADAdminDataFixesController {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
               
        VIADAdminDataFixesController controler = new VIADAdminDataFixesController();
        
        String name = controler.getName();
        List<SelectOption> options = controler.getFixTypeOptions();

        PageReference ref;
        
        /*  
		// Start: Test Function "RFC001155_SetTypeFieldOfOpenActivities()" and "RFC001155_SetTypeFieldOfCompletedActivities"
        
        List<Task> Tasks = new List<Task>();
                     
        //Create Activity Records here
        for(Integer i=0; i<21; i++)
        {
        	Task myTask1 = new Task();
        	myTask1.OwnerId = UserInfo.getUserId();
        	myTask1.Type__c = null;
        	myTask1.Type = '';
        	myTask1.CurrencyIsoCode = 'USD';
        	myTask1.Priority = 'Low';
        	myTask1.status = 'In Progress';
        	
        	Tasks.add(myTask1);
        	
        	Task completedTask1 = new Task();
        	completedTask1.OwnerId = UserInfo.getUserId();
        	completedTask1.Type__c = null;
        	completedTask1.Type = '';
        	completedTask1.CurrencyIsoCode = 'USD';
        	completedTask1.Priority = 'Low';
        	completedTask1.status = 'Completed';
        	
        	Tasks.add(completedTask1);        	

        	Task myTask2 = new Task();
        	myTask2.OwnerId = UserInfo.getUserId();
        	myTask2.Type__c = null;
        	myTask2.Type = 'Phone';
        	myTask2.CurrencyIsoCode = 'USD';
        	myTask2.Priority = 'Low';
        	myTask2.status = 'In Progress';
        	
        	Tasks.add(myTask2);
        	
        	Task completedTask2 = new Task();
        	completedTask2.OwnerId = UserInfo.getUserId();
        	completedTask2.Type__c = null;
        	completedTask2.Type = 'Phone';
        	completedTask2.CurrencyIsoCode = 'USD';
        	completedTask2.Priority = 'Low';
        	completedTask2.status = 'Completed';
        	
        	Tasks.add(completedTask2);          	

        	Task myTask3 = new Task();
        	myTask3.OwnerId = UserInfo.getUserId();
        	myTask3.Type__c = null;
        	myTask3.Type = 'Email';
        	myTask3.CurrencyIsoCode = 'USD';
        	myTask3.Priority = 'Low';
        	myTask3.status = 'In Progress';
        	
        	Tasks.add(myTask3);
        	
        	Task completedTask3 = new Task();
        	completedTask3.OwnerId = UserInfo.getUserId();
        	completedTask3.Type__c = null;
        	completedTask3.Type = 'Email';
        	completedTask3.CurrencyIsoCode = 'USD';
        	completedTask3.Priority = 'Low';
        	completedTask3.status = 'Completed';
        	
        	Tasks.add(completedTask3);         	

        	Task myTask4 = new Task();
        	myTask4.OwnerId = UserInfo.getUserId();
        	myTask4.Type = 'Sent GES Show Business';
        	myTask4.CurrencyIsoCode = 'USD';
        	myTask4.Priority = 'Low';
        	myTask4.status = 'In Progress';
        	
        	Tasks.add(myTask4);
        	
        	Task completedTask4 = new Task();
        	completedTask4.OwnerId = UserInfo.getUserId();
        	completedTask4.Type = 'Sent GES Show Business';
        	completedTask4.CurrencyIsoCode = 'USD';
        	completedTask4.Priority = 'Low';
        	completedTask4.status = 'Completed';
        	
        	Tasks.add(completedTask4);         	


        	Task myTask5 = new Task();
        	myTask5.OwnerId = UserInfo.getUserId();
        	myTask5.Type__c = null;
        	myTask5.Type = 'Gift';
        	myTask5.CurrencyIsoCode = 'USD';
        	myTask5.Priority = 'Low';
        	myTask5.status = 'In Progress';
        	
        	Tasks.add(myTask5);
        	
        	Task completedTask5 = new Task();
        	completedTask5.OwnerId = UserInfo.getUserId();
        	completedTask5.Type__c = null;
        	completedTask5.Type = 'Gift';
        	completedTask5.CurrencyIsoCode = 'USD';
        	completedTask5.Priority = 'Low';
        	completedTask5.status = 'Completed';
        	
        	Tasks.add(completedTask5);         	

        	Task myTask6 = new Task();
        	myTask6.OwnerId = UserInfo.getUserId();
        	myTask6.Type__c = null;
        	myTask6.Type = 'Complete Competitor Show Report';
        	myTask6.CurrencyIsoCode = 'USD';
        	myTask6.Priority = 'Low';
        	myTask6.status = 'In Progress';
        	
        	Tasks.add(myTask6);
        	
        	Task completedTask6 = new Task();
        	completedTask6.OwnerId = UserInfo.getUserId();
        	completedTask6.Type__c = null;
        	completedTask6.Type = 'Complete Competitor Show Report';
        	completedTask6.CurrencyIsoCode = 'USD';
        	completedTask6.Priority = 'Low';
        	completedTask6.status = 'Completed';
        	
        	Tasks.add(completedTask6);          	

        	Task myTask7 = new Task();
        	myTask7.OwnerId = UserInfo.getUserId();
        	myTask7.Type__c = null;
        	myTask7.Type = 'Sent Proposal';
        	myTask7.CurrencyIsoCode = 'USD';
        	myTask7.Priority = 'Low';
        	myTask7.status = 'In Progress';
        	
        	Tasks.add(myTask7);
        	
        	Task completedTask7 = new Task();
        	completedTask7.OwnerId = UserInfo.getUserId();
        	completedTask7.Type__c = null;
        	completedTask7.Type = 'Sent Proposal';
        	completedTask7.CurrencyIsoCode = 'USD';
        	completedTask7.Priority = 'Low';
        	completedTask7.status = 'Completed';
        	
        	Tasks.add(completedTask7);         	

        	Task myTask8 = new Task();
        	myTask8.OwnerId = UserInfo.getUserId();
        	myTask8.Type__c = null;
        	myTask8.Type = 'Industry Event';
        	myTask8.CurrencyIsoCode = 'USD';
        	myTask8.Priority = 'Low';
        	myTask8.status = 'In Progress';
        	
        	Tasks.add(myTask8);
        	
        	Task completedTask8 = new Task();
        	completedTask8.OwnerId = UserInfo.getUserId();
        	completedTask8.Type__c = null;
        	completedTask8.Type = 'Industry Event';
        	completedTask8.CurrencyIsoCode = 'USD';
        	completedTask8.Priority = 'Low';
        	completedTask8.status = 'Completed';
        	
        	Tasks.add(completedTask8);        	

        	Task myTask9 = new Task();
        	myTask9.OwnerId = UserInfo.getUserId();
        	myTask9.Type__c = null;
        	myTask9.Type = 'Meeting - External';
        	myTask9.CurrencyIsoCode = 'USD';
        	myTask9.Priority = 'Low';
        	myTask9.status = 'In Progress';
        	
        	Tasks.add(myTask9);
        	
        	Task completedTask9 = new Task();
        	completedTask9.OwnerId = UserInfo.getUserId();
        	completedTask9.Type__c = null;
        	completedTask9.Type = 'Meeting - External';
        	completedTask9.CurrencyIsoCode = 'USD';
        	completedTask9.Priority = 'Low';
        	completedTask9.status = 'Completed';
        	
        	Tasks.add(completedTask9);          	

        	Task myTask10 = new Task();
        	myTask10.OwnerId = UserInfo.getUserId();
        	myTask10.Type__c = null;
        	myTask10.Type = 'Site Visit';
        	myTask10.CurrencyIsoCode = 'USD';
        	myTask10.Priority = 'Low';
        	myTask10.status = 'In Progress';
        	
        	Tasks.add(myTask10);
        	
        	Task completedTask10 = new Task();
        	completedTask10.OwnerId = UserInfo.getUserId();
        	completedTask10.Type__c = null;
        	completedTask10.Type = 'Site Visit';
        	completedTask10.CurrencyIsoCode = 'USD';
        	completedTask10.Priority = 'Low';
        	completedTask10.status = 'Completed';
        	
        	Tasks.add(completedTask10);         	

        	Task myTask11 = new Task();
        	myTask11.OwnerId = UserInfo.getUserId();
        	myTask11.Type__c = null;
        	myTask11.Type = 'Face to Face';
        	myTask11.CurrencyIsoCode = 'USD';
        	myTask11.Priority = 'Low';
        	myTask11.status = 'In Progress';
        	
        	Tasks.add(myTask11);
        	
        	Task completedTask11 = new Task();
        	completedTask11.OwnerId = UserInfo.getUserId();
        	completedTask11.Type__c = null;
        	completedTask11.Type = 'Face to Face';
        	completedTask11.CurrencyIsoCode = 'USD';
        	completedTask11.Priority = 'Low';
        	completedTask11.status = 'Completed';
        	
        	Tasks.add(completedTask11);         	

        	Task myTask12 = new Task();
        	myTask12.OwnerId = UserInfo.getUserId();
        	myTask12.Type__c = null;
        	myTask12.Type = 'Solutions Presentation';
        	myTask12.CurrencyIsoCode = 'USD';
        	myTask12.Priority = 'Low';
        	myTask12.status = 'In Progress';
        	
        	Tasks.add(myTask12);
        	
        	Task completedTask12 = new Task();
        	completedTask12.OwnerId = UserInfo.getUserId();
        	completedTask12.Type__c = null;
        	completedTask12.Type = 'Solutions Presentation';
        	completedTask12.CurrencyIsoCode = 'USD';
        	completedTask12.Priority = 'Low';
        	completedTask12.status = 'Completed';
        	
        	Tasks.add(completedTask12);         	

        	Task myTask13 = new Task();
        	myTask13.OwnerId = UserInfo.getUserId();
        	myTask13.Type__c = null;
        	myTask13.Type = 'Capabilities Presentation';
        	myTask13.CurrencyIsoCode = 'USD';
        	myTask13.Priority = 'Low';
        	myTask13.status = 'In Progress';
        	
        	Tasks.add(myTask13);
        	
        	Task completedTask13 = new Task();
        	completedTask13.OwnerId = UserInfo.getUserId();
        	completedTask13.Type__c = null;
        	completedTask13.Type = 'Capabilities Presentation';
        	completedTask13.CurrencyIsoCode = 'USD';
        	completedTask13.Priority = 'Low';
        	completedTask13.status = 'Completed';
        	
        	Tasks.add(completedTask13);         	

        	Task myTask14 = new Task();
        	myTask14.OwnerId = UserInfo.getUserId();
        	myTask14.Type__c = null;
        	myTask14.Type = 'Reassignment';
        	myTask14.CurrencyIsoCode = 'USD';
        	myTask14.Priority = 'Low';
        	myTask14.status = 'In Progress';
        	
        	Tasks.add(myTask14);
        	
        	Task completedTask14 = new Task();
        	completedTask14.OwnerId = UserInfo.getUserId();
        	completedTask14.Type__c = null;
        	completedTask14.Type = 'Reassignment';
        	completedTask14.CurrencyIsoCode = 'USD';
        	completedTask14.Priority = 'Low';
        	completedTask14.status = 'Completed';
        	
        	Tasks.add(completedTask14);         	

        	Task myTask15 = new Task();
        	myTask15.OwnerId = UserInfo.getUserId();
        	myTask15.Type__c = null;
        	myTask15.Type = 'Follow-up';
        	myTask15.CurrencyIsoCode = 'USD';
        	myTask15.Priority = 'Low';
        	myTask15.status = 'In Progress';
        	
        	Tasks.add(myTask15);
        	
        	Task completedTask15 = new Task();
        	completedTask15.OwnerId = UserInfo.getUserId();
        	completedTask15.Type__c = null;
        	completedTask15.Type = 'Follow-up';
        	completedTask15.CurrencyIsoCode = 'USD';
        	completedTask15.Priority = 'Low';
        	completedTask15.status = 'Completed';
        	
        	Tasks.add(completedTask15);         	

        	Task myTask16 = new Task();
        	myTask16.OwnerId = UserInfo.getUserId();
        	myTask16.Type__c = null;
        	myTask16.Type = 'Account Planning';
        	myTask16.CurrencyIsoCode = 'USD';
        	myTask16.Priority = 'Low';
        	myTask16.status = 'In Progress';
        	
        	Tasks.add(myTask16);
        	
        	Task completedTask16 = new Task();
        	completedTask16.OwnerId = UserInfo.getUserId();
        	completedTask16.Type__c = null;
        	completedTask16.Type = 'Account Planning';
        	completedTask16.CurrencyIsoCode = 'USD';
        	completedTask16.Priority = 'Low';
        	completedTask16.status = 'Completed';
        	
        	Tasks.add(completedTask16);        	

        	Task myTask17 = new Task();
        	myTask17.OwnerId = UserInfo.getUserId();
        	myTask17.Type__c = null;
        	myTask17.Type = 'Meeting - Internal';
        	myTask17.CurrencyIsoCode = 'USD';
        	myTask17.Priority = 'Low';
        	myTask17.status = 'In Progress';
        	
        	Tasks.add(myTask17);
        	
        	Task completedTask17 = new Task();
        	completedTask17.OwnerId = UserInfo.getUserId();
        	completedTask17.Type__c = null;
        	completedTask17.Type = 'Meeting - Internal';
        	completedTask17.CurrencyIsoCode = 'USD';
        	completedTask17.Priority = 'Low';
        	completedTask17.status = 'Completed';
        	
        	Tasks.add(completedTask17);         	

        	Task myTask18 = new Task();
        	myTask18.OwnerId = UserInfo.getUserId();
        	myTask18.Type__c = null;
        	myTask18.Type = 'Task';
        	myTask18.CurrencyIsoCode = 'USD';
        	myTask18.Priority = 'Low';
        	myTask18.status = 'In Progress';
        	
        	Tasks.add(myTask18);
        	
        	Task completedTask18 = new Task();
        	completedTask18.OwnerId = UserInfo.getUserId();
        	completedTask18.Type__c = null;
        	completedTask18.Type = 'Task';
        	completedTask18.CurrencyIsoCode = 'USD';
        	completedTask18.Priority = 'Low';
        	completedTask18.status = 'Completed';
        	
        	Tasks.add(completedTask18);          	

        	Task myTask19 = new Task();
        	myTask19.OwnerId = UserInfo.getUserId();
        	myTask19.Type__c = null;
        	myTask19.Type = 'Letter';
        	myTask19.CurrencyIsoCode = 'USD';
        	myTask19.Priority = 'Low';
        	myTask19.status = 'In Progress';
        	
        	Tasks.add(myTask19);
        	
        	Task completedTask19 = new Task();
        	completedTask19.OwnerId = UserInfo.getUserId();
        	completedTask19.Type__c = null;
        	completedTask19.Type = 'Letter';
        	completedTask19.CurrencyIsoCode = 'USD';
        	completedTask19.Priority = 'Low';
        	completedTask19.status = 'Completed';
        	
        	Tasks.add(completedTask19);           	

        	Task myTask20 = new Task();
        	myTask20.OwnerId = UserInfo.getUserId();
        	myTask20.Type__c = null;
        	myTask20.Type = 'Attached Competitor Show Report';
        	myTask20.CurrencyIsoCode = 'USD';
        	myTask20.Priority = 'Low';
        	myTask20.status = 'In Progress';
        	
        	Tasks.add(myTask20);
        	
        	Task completedTask20 = new Task();
        	completedTask20.OwnerId = UserInfo.getUserId();
        	completedTask20.Type__c = null;
        	completedTask20.Type = 'Attached Competitor Show Report';
        	completedTask20.CurrencyIsoCode = 'USD';
        	completedTask20.Priority = 'Low';
        	completedTask20.Status = 'Completed';
        	
        	Tasks.add(completedTask20);
        }
                
        Task[] insertTasks = new Task[200];
        Integer count = 0;
        
        for(Task mytask : Tasks)
        {
        	insertTasks[count++] = mytask;
        	
        	if (count == 200)
        	{
        		Database.insert(insertTasks,true);
        		count = 0;
        		insertTasks = new Task[200];
        	}
        }
        
        Integer CompleteActivitiesCount = -1;
        Integer OpenActivitiesCount = -1;
        
          
        //List<AggregateResult> ar = [Select Count(Id) From Task Where Status != 'Completed' And Type__c = null];
        //if (ar.size() > 0)
        //{
        //	OpenActivitiesCount = (Integer)(ar[0].get('expr0'));
        //}
        
        //System.assertEquals(380, OpenActivitiesCount);
        
                        
        controler.setFixType('RFC001155_SetTypeFieldOfOpenActivities');
        System.AssertEquals('RFC001155_SetTypeFieldOfOpenActivities', controler.getFixType());
                
        ref = controler.Save();
                   
        //ar = [Select Count(Id) From Task Where Status = 'Completed' And Type__c = null And Type = null];
        //if (ar.size() > 0)
        //{
        //	CompleteActivitiesCount = (Integer)(ar[0].get('expr0'));
        //}
        
        //System.assertEquals(380, CompleteActivitiesCount);
                           
        controler.setFixType('RFC001155_SetTypeFieldOfCompletedActivities');
        ref = controler.Save();
        
        
        //controler.setFixType('RFC001155_ChangeShowOpportunityPublicStageFromSLToSL4');
        //ref = controler.Save();
        
		// End: Test Function "RFC001155_SetTypeFieldOfOpenActivities()" and "RFC001155_SetTypeFieldOfCompletedActivities"
        */        

    }
}