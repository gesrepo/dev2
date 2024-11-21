@isTest
public Class LC_GOTCreateControllerTest
{

    @testsetup
    public static void testSetup(){
        Opportunity opp= LC_TestUtils.insertOpportunity();
        GC_Connect2_Show__c show = LC_TestUtils.insertShow(opp.Id,opp.Name);
        GC_Order__c order=LC_TestUtils.insertOrder(show.Id);
        GC_Show_Attribute__c venue=LC_TestUtils.insertVenueAttributes(show.Id);
        GC_Show_Attribute__c dept=LC_TestUtils.insertDeptAttributes(show.Id);
        GC_GES_Order_Task__c got=LC_TestUtils.insertGOT(order.Id,venue.Id,dept.Id);
    }
 
    @isTest
    public static void testMethod1(){
        
        GC_Order__c order = [select id from GC_Order__c where Booth_Area__c='new Booth Area'];
        GC_GES_Order_Task__c gesOT = [select Id, QuantityNum__c, Parent_Category__c, Child_Category__c, Item_Number__c, Labor_In_Out__c,
                                      Description__c,Parent_GEM_Structure__c,Client_Layout_Notes__c,Show_Management_Field__c,Special_Instructions_Client_Remarks__c,
                                      Layout__c,Sign_Copy_Plain__c,Sign_Copy__c,Item_Template__c, Item_Category__c, UOM__c,Carpet_Length__c, 
                                      Carpet_Width__c,Electrical_Ordered__c ,Electrical_Under__c ,Status__c,Revision__c,Booth_Area_Discount_Override__c 
                                     from GC_GES_Order_Task__c where Delivery_Location__c='Test GES Delivery Location'];
        
        gesOT.Status__c = 'Active' ;
        gesOT.Parent_Category__c  = 'Test Parent Cat';
        gesOT.Child_Category__c  = 'Test Child Cat';
        gesOT.Item_Category__c  = 'Test Item';
        gesOT.Carpet_Length__c  = 1;
        gesOT.Carpet_Width__c  = 1;
        gesOT.Sign_Copy_Plain__c  = '';
        gesOT.Special_Instructions_Client_Remarks__c  = '';
        gesOT.Client_Layout_Notes__c  = '';
        gesOT.Show_Management_Field__c  = 'Test';
        gesOT.Layout__c  = 'Test';
        gesOT.Sign_Copy__c  = 'Test';
        gesOT.UOM__c  = 'SF';   
        gesOT.Item_Template__c = 'Carpet'; 
        
        update gesOT;
        
        List<String> taskIds= new List<String>();
        taskIds.add(gesOT.Id);
        
        Test.startTest(); 
        LC_GOTCreateController.getSessionId();
        GC_GES_Order_Task__c orderTask = LC_GOTCreateController.getGESOrderTask(gesOT.Id,'Clone');
        LC_GOTCreateController.getTaskFieldManager(order.Id);
        LC_GOTCreateController.saveGESOrderTask(order.Id, gesOT, 'Revise');
        LC_GOTCreateController.getAllDataMap('1111-2222-3333-4444', order.Id); 
        LC_GOTCreateController.processOrderTask(new GC_GES_Order_Task__c());
        LC_GOTCreateController.getDeptsVenuesAndMaterials(order.Id);
        LC_GOTCreateController.getOrderDates(order.Id);
        LC_GOTCreateController.getAllPicklistValues();
        System.assertEquals(true, LC_GOTCreateController.getUserPermission());
        Test.stopTest();
    }
}