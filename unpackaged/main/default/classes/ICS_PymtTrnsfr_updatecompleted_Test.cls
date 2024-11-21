@isTest 
    public class ICS_PymtTrnsfr_updatecompleted_Test {      
        //static Payment_Transfer_ICS__c PT = new Payment_Transfer_ICS__c();
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
               // ICS.Customer__c = '1001';   
                insert ICS; 
                
                Payment_Transfer_ICS__c PT = new Payment_Transfer_ICS__c();
                PT.Transfer_Amount__c = 50000;
                PT.Completed_Transaction__c = False;
                PT.CSI_ICS_No__c = ICS.Id;
                insert PT;
                    
                PT.Completed_Transaction__c = true;
                update PT;
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
                
                Payment_Transfer_ICS__c PT = new Payment_Transfer_ICS__c();
                PT.CSI_ICS_No__c = ICS.Id;
                PT.Transfer_Amount__c = 1000;
                PT.Completed_Transaction__c = True;
                insert PT;
           }            
}