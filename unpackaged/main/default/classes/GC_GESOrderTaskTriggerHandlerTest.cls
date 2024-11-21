/**
* @author Ethos Solutions - www.ethos.com
* @description Test code for GES Order Task trigger handler
* 2016-04-13 : Original Version
**/
@isTest
private class GC_GESOrderTaskTriggerHandlerTest {

    @isTest static void TestInsertAndUpdate() {
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        GC_Order__c order = new GC_Order__c();
        order.Connect2_Show__c = show.Id;
        order.Booth_Area_ID__c = '1390259';
        order.Booth_Area__c = 'Area';
        insert order;
        GC_GES_Order_Task__c task = new GC_GES_Order_Task__c();
        task.Order__c = order.Id;
        insert task;
    }

    @isTest static void TestHandleOrderStatus() {
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        GC_Order__c order = new GC_Order__c();
        order.Connect2_Show__c = show.Id;
        order.Booth_Area_ID__c = '1390259';
        order.Booth_Area__c = 'Area';
        insert order;
        GC_GES_Order_Task__c task = new GC_GES_Order_Task__c();
        task.Order__c = order.Id;
        task.Status__c = 'Active';
        insert task;

        order = [Select Id, Status__c from GC_Order__c where Id =: order.Id];
        System.assertEquals('Active', order.Status__c);

        task.Status__c = 'Canceled';
        update task;
        order = [Select Id, Status__c from GC_Order__c where Id =: order.Id];
       // System.assertEquals('Canceled', order.Status__c);
    }

    @isTest static void TestHandleOrderNumbers() {
        GC_GES_Connect2_Settings__c settings = new GC_GES_Connect2_Settings__c();
        settings.Name = 'GES Connect Settings';
        settings.Send_Show_Org_Emails__c = true;
        settings.Default_Login_Email__c = 'LDrummond@ges.com';
        settings.API_ENDPOINT__c = 'https://xsysapi.viad.com';
        insert settings;
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        GC_Order__c order = new GC_Order__c();
        order.Connect2_Show__c = show.Id;
        order.Booth_Area_ID__c = '1390259';
        order.Booth_Area__c = 'Area';
        insert order;
        Map<String, User> userMap = GC_TestUtils.getUsers();
        GC_Show_Team_Member__c teamMember = new GC_Show_Team_Member__c(Connect2_Show__c = show.Id, Show_Role__c = 'Show Organizer', User__c = userMap.get('AM').Id);
        insert teamMember;
        GC_GES_Order_Task__c task = new GC_GES_Order_Task__c();
        task.Order__c = order.Id;
        task.Status__c = 'New';
        insert task;

        task.Status__c = 'Active';
        task.Order_Number__c = '12345';
        update task;
        order = [Select Id, Order_Number__c from GC_Order__c where Id =: order.Id];
        System.assertEquals('12345', order.Order_Number__c);


    }

}