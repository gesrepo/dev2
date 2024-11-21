@isTest
    public class ICS_Charges_updatecompleted_Test {          
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
                
                Charges__c Ch = new Charges__c();
                Ch.Total_Amount__c = 50000;
                Ch.Completed_Transaction__c = False;
                Ch.CSI_ICS__c = ICS.Id;
                Ch.Last_4_of_CC__c = '1000';
                Ch.Last_4_of_Token__c = '2000';    
                insert Ch;                    
                Ch.Completed_Transaction__c = true;
                update Ch;
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
                
                Charges__c Ch = new Charges__c();
                Ch.Total_Amount__c = 150000;
                Ch.Completed_Transaction__c = False;
                Ch.CSI_ICS__c = ICS.Id;
                Ch.Last_4_of_CC__c = '3000';
                Ch.Last_4_of_Token__c = '4000';    
                insert Ch;                    
                Ch.Completed_Transaction__c = true;
                update Ch;
           }            
}