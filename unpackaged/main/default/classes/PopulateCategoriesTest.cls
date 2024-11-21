@isTest
public class PopulateCategoriesTest
{

    public static testMethod void testMethod1()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User usr = new User(Alias = 'newTsUsr', Email='newTestuserTest@testorg.com',
             EmailEncodingKey='UTF-8', LastName='TestingUserTest', LanguageLocaleKey='en_US',
             LocaleSidKey='en_US', ProfileId = p.Id,
             TimeZoneSidKey='America/Los_Angeles', UserName='newuserTestTesting@testorg.com');
        
        System.runAs(usr) 
        {
            //GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show1();
            
            GC_Connect2_Show__c newShow = new GC_Connect2_Show__c();
            newShow.Opportunity_Name__c = '01453-201601-';
            newShow.Opportunity_Id__c = '006f000000F6EbtAAF';
            newShow.Show_Name__c = 'test show';
            newShow.Job_Number__c = '12345';
            newShow.Show_Start_Date__c = Date.today();
            newShow.Show_End_Date__c = Date.today()+30;
            newShow.Exhibit_Hall_Hours_Day_1__c = '5:00 PM To 8:00 PM';
            newShow.Exhibit_Hall_Hours_Day_2__c = '7:00 AM To 6:30 PM';
            newShow.Exhibit_Hall_Hours_Day_3__c = '8:00 AM To 4:00 PM';
            newShow.Exhibit_Hall_Hours_Day_4__c = '9:00 AM To 10:00 PM';
            newShow.Exhibit_Hall_Hours_Day_5__c = '9:00 AM To 10:00 PM';
            insert newShow;
            
            GC_Order__c order = new GC_Order__c();
            order.Connect2_Show__c = newShow.Id;
            order.Order_Area_Description__c = 'testing';
            order.Booth_Area__c='Bangalore';
            insert order;
    
            GC_GES_Order_Task__c got = new GC_GES_Order_Task__c();
            got.Order__c = order.Id;
            got.Sign_Length__c = 10;
            got.Sign_Width__c = 10;
            //got.Onsite_Contact_Person__c = accountManagerId;
            got.Delivery_Date_Time__c = DateTime.now();
            got.Completion_Date_Time__c = DateTime.now() + 5;
            got.Removal_Date_Time__c = DateTime.now() + 15;
            got.QuantityNum__c = 5;
            got.Carpet_Length__c = 15;
            got.Carpet_Width__c = 15;
            got.Revision__c = 1;
            got.Status__c = 'New';
            got.Item_Number__c = '12345';
            got.Item_Template__c = 'Carpet';
            insert got;
            
            GC_GES_Order_Task__c got1 = new GC_GES_Order_Task__c();
            got1.Order__c = order.Id;
            got1.Sign_Length__c = 10;
            got1.Sign_Width__c = 10;
            //got.Onsite_Contact_Person__c = accountManagerId;
            got1.Delivery_Date_Time__c = DateTime.now();
            got1.Completion_Date_Time__c = DateTime.now() + 5;
            got1.Removal_Date_Time__c = DateTime.now() + 15;
            got1.QuantityNum__c = 5;
            got1.Carpet_Length__c = 15;
            got1.Carpet_Width__c = 15;
            got1.Revision__c = 1;
            got1.Status__c = 'New';
            got1.Item_Number__c = '12345';
            got1.Item_Template__c = 'Carpet';
            insert got1;
        }
        Test.StartTest();
        PopulateCategories objBatch = new PopulateCategories();
        ID batchprocessid = Database.executeBatch(objBatch);
        Test.StopTest();
    }
}