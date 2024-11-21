@isTest
    public class ICS_ReceiptRvsl_updatecompleted_Test {     
        
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
                
                Receipt_Reversals__c RR = new Receipt_Reversals__c();
                RR.Receipt_Reversal_Amount__c = 50000;
                RR.Completed_Transaction__c = False;
                RR.CSI_ICS__c = ICS.Id;
                insert RR;
                    
                RR.Completed_Transaction__c = true;
                update RR;
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
                
                Receipt_Reversals__c RR = new Receipt_Reversals__c();
                RR.Receipt_Reversal_Amount__c = 50000;
                RR.Completed_Transaction__c = False;
                RR.CSI_ICS__c = ICS.Id;
                insert RR;
                    
                RR.Completed_Transaction__c = true;
                update RR;
           }            
}