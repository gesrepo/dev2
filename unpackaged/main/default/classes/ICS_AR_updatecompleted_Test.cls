@isTest
    public class ICS_AR_updatecompleted_Test {           
                @istest
                Public static void test(){
                List<Employees__c> listEmp = new List<Employees__c>();
                Employees__c emp = TestDataUtil.createTestEmployee();
                Employees__c emp1 = TestDataUtil.createTestEmployee();
                emp1.Email_Address__c='test1@test1.com';
                listEmp.add(emp);
                listEmp.add(emp1);
                insert listEmp;             
                
                Customer_Service_Inquiries_ICS__c ICS = TestDataUtil.createTestCustomerServiceInquries();
                ICS.Case_Requestor__c = listEmp[0].Id;
                ICS.Case_Approval_Status__c = 'Case Approved';
                //ICS.Customer__c = '1001';   
                insert ICS; 
                
                AR_Adjustments__c AR = new AR_Adjustments__c();
                AR.Amount__c = 50000;
                AR.Completed_Transaction__c = False;
                AR.AR_Adj_CSI_ID__c = ICS.Id;
                AR.Billing_ID__c = '1001';
                AR.Sales_Order__c  = '2001';  
                insert AR;                    
                AR.Completed_Transaction__c = true;
                update AR;
        }
                @istest
                Public static void test2(){
                List<Employees__c> listEmp = new List<Employees__c>();
                Employees__c emp = TestDataUtil.createTestEmployee();
                Employees__c emp2 = TestDataUtil.createTestEmployee();
                emp2.Email_Address__c='test2@test1.com';
                listEmp.add(emp); 
                listEmp.add(emp2);
                insert listEmp;         
                
                Customer_Service_Inquiries_ICS__c ICS = TestDataUtil.createTestCustomerServiceInquries();
                ICS.Case_Requestor__c = listEmp[0].Id;
                ICS.Case_Approval_Status__c = 'Case Approved';
                //ICS.Customer__c = '1002';   
                insert ICS;
                
                AR_Adjustments__c AR = new AR_Adjustments__c();
                AR.Amount__c = 100000;
                AR.AR_Adj_CSI_ID__c = ICS.Id;
                AR.Billing_ID__c = '3001';
                AR.Sales_Order__c  = '4001';                  
                AR.Completed_Transaction__c = True;
                insert Ar;
           }            
}