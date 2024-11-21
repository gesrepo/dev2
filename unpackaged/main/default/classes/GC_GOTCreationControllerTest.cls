@isTest
private class GC_GOTCreationControllerTest {
    public GC_CoreQuery coreApi {get; set;}
    public CORE_V1MockImpl Core {get; set;}
    public List<String> currentItems { get; set; } 
    public GC_CoreQuery.GC_ItemHolder selectedItem { get; set; } 
    GC_GOTCreationControllerTest(){
        
    }
    
    @isTest static void testAllMethodsClassic(){
        GC_Order__c order= GC_TestUtils.getTestOrder(); 
        GC_GES_Order_Task__c got = new GC_GES_Order_Task__c();
        got.Order__c = order.Id;
        got.Sign_Length__c = 10;
        got.Sign_Width__c = 10;
        got.Delivery_Date_Time__c = DateTime.now();
        got.Completion_Date_Time__c = DateTime.now() + 10;
        got.Removal_Date_Time__c = DateTime.now() + 15;
        got.QuantityNum__c = 5;
        got.Carpet_Length__c = 15;
        got.Carpet_Width__c = 15;
        got.Revision__c = 1;
        got.Status__c = 'New';
        got.Item_Number__c = '400004';
        got.Item_Template__c = 'Carpet';
        got.UOM__c = 'SF';
        got.Electrical_Ordered__c = false;
        got.Electrical_Under__c = false;
        insert got;
        String classicURL = '/apex/GC_OrderView?id='+order.Id;
        
        Test.setCurrentPageReference(new PageReference('Page.GC_GOTCreatePage'));
        System.currentPageReference().getParameters().put('orderId',order.Id);    
        System.currentPageReference().getParameters().put('showId',order.Connect2_Show__c );
        System.currentPageReference().getParameters().put('isClone', 'true' );
        System.currentPageReference().getParameters().put('isEdit', 'true' );
        System.currentPageReference().getParameters().put('taskId', got.Id );
        System.currentPageReference().getParameters().put('isTaskPage', 'true' );
        
        
        
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(got);
        GC_GOTCreationController controller= new GC_GOTCreationController(stdController);
        PageReference pr = controller.sessionLoad();
        controller.coreApi.obtainProducts();
        
        //controller.coreApi.setItemNumber.add('400004');
        controller.selectedGesTask.task.Sign_Length__c = 10;
        controller.selectedGesTask.task.Sign_Width__c = 10;
        controller.selectedGesTask.task.Delivery_Date_Time__c = DateTime.now();
        controller.selectedGesTask.task.Completion_Date_Time__c = DateTime.now() + 10;
        controller.selectedGesTask.task.Removal_Date_Time__c = DateTime.now() + 15;
        controller.selectedGesTask.task.QuantityNum__c = 5;
        controller.selectedGesTask.task.Carpet_Length__c = 15;
        controller.selectedGesTask.task.Carpet_Width__c = 15;
        controller.selectedGesTask.task.Status__c = 'New';
        controller.selectedGesTask.task.Item_Number__c = '400004';
        controller.selectedGesTask.task.Item_Template__c = 'Carpet';
        controller.selectedGesTask.task.UOM__c = 'SF';
        controller.selectedGesTask.task.Show_Management_Field__c = '';
        controller.selectedGesTask.task.Electrical_Ordered__c = false;
        controller.selectedGesTask.task.Electrical_Under__c = false;
        GC_OrderViewController.GesTaskWrapper taskWrapper = controller.selectedGesTask;
        controller.taskFieldManager.Special_Instructions_Client_Remarks__c='Shown and Required';
        PageReference saveNReturn1=controller.validateFields();
        PageReference saveNReturn=controller.validateSave();
        //PageReference saveNReturn=controller.saveTask();
        PageReference cancelNReturn= controller.cancelEditTask();
        GC_GES_Order_Task__c taskk = taskWrapper.task.clone(false, false);
        controller.selectedGesTask= taskWrapper;
        controller.selectedGesTask.task = taskk;
        controller.coreapi.setItemNumber= new set<string>();
        controller.coreapi.setItemNumber.add(taskk.Item_Number__c);
        controller.coreapi.setItemNumber= new set<string>();
        
        saveNReturn1=controller.saveTask();
        GC_GOTCreationController.getReasonCodes('inputReasonCode');
        controller.clearDiscountValues();
        stdController.save();
             
    }
    
    @isTest static void testAllMethodsComm(){
        Test.setMock(WebServiceMock.class, new CORE_V1MockImpl());
        CORE_V1.BasicHttpBinding_IProductService productService = new CORE_V1.BasicHttpBinding_IProductService();
        GC_Order__c order= GC_TestUtils.getTestOrder(); 
        GC_GES_Order_Task__c got = new GC_GES_Order_Task__c();
        got.Order__c = order.Id;
        got.Sign_Length__c = 10;
        got.Sign_Width__c = 10;
        got.Delivery_Date_Time__c = DateTime.now();
        got.Completion_Date_Time__c = DateTime.now() + 10;
        got.Removal_Date_Time__c = DateTime.now() + 15;
        got.QuantityNum__c = 5;
        got.Carpet_Length__c = 15;
        got.Carpet_Width__c = 15;
        //got.Revision__c = 1;
        got.Status__c = 'New';
        got.Item_Number__c = '400004';
        got.Item_Template__c = 'Carpet';
        got.UOM__c = 'SF';
        got.Electrical_Ordered__c = false;
        got.Electrical_Under__c = false;
        got.Parent_Category__c='test';
        got.Child_Category__c='test';
        got.Booth_Area_Discount__c=10;
        got.Description__c='Test Desc';
        insert got;
        String communityURL = '/apex/GC_Community_OrderView?orderid='+order.Id+'&showid='+order.Connect2_Show__c;
        
        Test.setCurrentPageReference(new PageReference('Page.GC_Community_GOTCreatePage'));
        System.currentPageReference().getParameters().put('orderId',order.Id);    
        System.currentPageReference().getParameters().put('showId',order.Connect2_Show__c );
        GC_GOTCreationController controller= new GC_GOTCreationController();
        GC_OrderViewController.GesTaskWrapper taskWrapper = controller.selectedGesTask;
        controller.taskFieldManager.Special_Instructions_Client_Remarks__c='Shown and Required';
        PageReference pr = controller.sessionLoad();
        controller.coreApi.obtainProducts();
        controller.coreApi.selectItem();
        controller.coreApi.obtainBoothAreas();
        controller.coreApi.selectBoothArea();
        controller.coreapi.setItemNumber= new set<string>();
        controller.coreapi.setItemNumber.add(got.Item_Number__c);
        controller.selectedGesTask.task=got;
        PageReference saveNReturn=controller.validateSave();
        PageReference pr1=controller.saveTask();
        PageReference cancelNReturn= controller.cancelEditTask();
        
        Product_List__c prd = new Product_List__c();
        prd.Name = 'test';
        prd.Project_Number__c ='123456';
        prd.Show_Org_Products__c='test';

        insert prd;
        
         List<Product_List__c> productList = new  List<Product_List__c>();
         productList.add(prd);
        
        SelectOption so = new SelectOption('uniqueValue', 'displayValue');
       
       
        LargeSelectList lst = new LargeSelectList();
        lst.add(so);
        controller.coreApi.populateProductList();
        controller.coreApi.emptyProductList();
        controller.coreApi.selectedParentCategory='Carpet';
        controller.coreApi.selectedChildCategory ='Autro';
        controller.coreApi.searchItemClick='searchItemHidden';
        controller.coreApi.selectedItemNumberAndDescription='400004_Test Desc';
        
       /*  GC_CoreQuery.GC_ItemHolder gcItem =  controller.coreApi.selectedItem;
        gcItem.BoothAreaDiscount='12';
        gcItem.Category='2345';
        gcItem.CategoryId ='1234';
        gcItem.ChildCategory='Testchild';
        gcItem.ImageUrl='image.jpeg';
        gcItem.InventoryItemId='Test';
        gcItem.ItemDescription='testItemdesc';
        gcItem.ItemNumber='1234';
        gcItem.ItemOptionTemplate='Carpet';
        gcItem.ItemType='String';
        gcItem.LineOfBusiness='TestLob';
        gcItem.ParentCategory='Carpet';
        gcItem.Price='1234';
        gcItem.TaxRate='1234';
        gcItem.Units='12345'; */
        
       
        controller.coreApi.selectItem();
         SelectOption noneOption = new SelectOption('' , '--None--');
        noneOption.setValue('test');
         
        List<SelectOption> childCategories= new  List<SelectOption>();
            childCategories.add(noneOption);
       controller.coreApi.selectCategories();      
      
        
      }      
}