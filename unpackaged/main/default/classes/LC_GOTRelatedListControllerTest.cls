@isTest
public class LC_GOTRelatedListControllerTest {
    @isTest
    public static void testMethod1() {
        List<string> emailList= new List<string>();
        emailList.add('knagaraj@ges.com');
        emailList.add('rsinha@ges.com');
        
        
        
        
        Map<String, User> users = GC_TestUtils.getUsers();
        User user = users.get('AM');
        User user1 = users.get('GPM');
        User user2 = users.get('System Administrator');
        System.runAs(user2) {
            GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
            GC_Order__c order = new GC_Order__c();
            order.Connect2_Show__c = show.Id;
            order.Order_Area_Description__c = 'testing';
            order.Booth_Area__c='Bangalore';
            order.Booth_Area_ID__c = '12345';
            insert order;
            
            GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c();
            stm.Connect2_Show__c = show.Id;
            stm.User__c = user.Id;
            stm.Show_Role__c = 'Account Manager';
            insert stm;
            
            GC_Show_Team_Member__c stm1 = new GC_Show_Team_Member__c();
            stm1.Connect2_Show__c = show.Id;
            stm1.User__c = user1.Id;
            stm1.Show_Role__c = 'Graphics Project Manager';
            insert stm1;
            
            GC_GES_Order_Task__c got = new GC_GES_Order_Task__c();
            got.Order__c = order.Id;
            got.Item_Category_ID__c = '1896';
            got.Item_Number__c = '300004';
            got.Description__c = 'Test Item Description';
            got.ItemType__c = 'Test Type';
            got.Item_Template__c = 'Basic';
            got.QuantityNum__c = 1;
            got.UOM__c = 'EA';
            got.Status__c = 'New';
            got.Show_Management_Field__c = 'Yes';
            got.File_Reference_Link__c = 'link';
            got.Completion_Date_Time__c = DateTime.Now();
            got.Removal_Date_Time__c = DateTime.Now();
            got.Delivery_Date_Time__c = DateTime.Now();
            got.Price__c = '11.59';
            got.New_Price__c = 12;
            got.Description__c = 'test Desciption';
            got.Invoice_Remarks__c = 'test remarks';
            got.Production_Remarks__c = 'test remarks';
            got.Item_Type_Remarks__c = 'test remarks';
            got.Show_Site_Remarks__c = 'test show site remarks';
            got.Budget_Code__c = '12345';
            got.Onsite_Contact_Person_Number_Other__c = '9876543210';
            got.Order_Line_ID__c = '11223344';
            got.AM_Approver_1__c = user.Id;
            got.AM_Approver_2__c = user.Id;
            got.AM_Approver_3__c = user.Id;
            insert got;
            
            LC_GOTRelatedListController.getGots(order.Id);
            LC_GOTRelatedListController.isCommunity();
            
            
            LC_GOTRelatedListController.fetchUserDetails();
            LC_GOTRelatedListController.getrelatedOrders(order.Id);
            LC_GOTRelatedListController.toggleHold(got.Id, '1');
            LC_GOTRelatedListController.toggleHold(got.Id, '2');
            LC_GOTRelatedListController.sendEmail(got.Id,emailList);
            got.Status__c='Canceled';
            got.Is_On_Hold__c=true;
            got.Previous_Status__c='New';
            update got;
            try{
                LC_GOTRelatedListController.getOrder(order.Id);
                LC_GOTRelatedListController.submitForApproval(got.Id);
                LC_GOTRelatedListController.recallTask(got.Id);
                LC_GOTRelatedListController.reworkTask(got.Id);
                LC_GOTRelatedListController.getrelatedOrders(order.Id);       
                LC_GOTRelatedListController.getProfilePermissions();
                
                Test.startTest();
                GC_Core_Session__c testSession = LC_GOTRelatedListController.sessionLoad(got.Id);
                LC_GOTRelatedListController.validateSessionID(testSession);
                LC_GOTRelatedListController.sessionLogin();
                LC_GOTRelatedListController.submitOrderAction(got.Id, testSession.Core_Application_Session_ID__c);
                LC_GOTRelatedListController.processOrderAction(got.Id, testSession.Core_Application_Session_ID__c);
                LC_GOTRelatedListController.cancelOrderAction(got.Id, testSession.Core_Application_Session_ID__c);
                LC_GOTRelatedListController.processCancelOrderAction(got.Id, testSession.Core_Application_Session_ID__c);
                LC_GOTRelatedListController.removeTask(got.Id);
                Test.stopTest();
            }catch(exception e){
                System.debug('Excp:: '+e);
            }     
        }
    }
}