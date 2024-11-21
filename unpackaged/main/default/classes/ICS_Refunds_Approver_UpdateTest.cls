@isTest
public class ICS_Refunds_Approver_UpdateTest {
     static Account facility=TestDataUtil.CreateTestFacility();
    static Account firm=TestDataUtil.CreateTestFirm();
    static Show__c show=TestDataUtil.CreateTestShow(firm.id);
     static List<Refunds_ICS__c> testdata=new List<Refunds_ICS__c>();
     static Refunds_ICS__c sample=new Refunds_ICS__c();
    
    
   		   @istest
  		  public static void test1(){        
   			ICS_Approver_Matrix__c AM=new ICS_Approver_Matrix__c();
            Employees__c e=new Employees__c();
            e.name='sample';
            e.Email_Address__c='sample@sample.com';
            insert e;
            Employees__c e1=new Employees__c();
            e1.name='sample1';
            e1.Email_Address__c='sample1@sample.com';
            insert e1;
            Customer_Service_Inquiries_ICS__c ICS1 = TestDataUtil.createTestCustomerServiceInquries();
            ICS1.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
            ICS1.Case_Approval_Status__c = 'Requestor Submitted';        
            ICS1.Case_Requestor_Email_ID__c='sample1@sample.com';
            insert ICS1;
            am.Min_Amount__c=1000;
            am.Max_Amount__c=10000;
            am.AR1_Approver__c=e1.id;
            am.AR2_Approver__c=e.id;
            am.CSO_Approver__c=e.id;      
            am.Additional_Approver__c=e.id;
            am.Transaction_Types__c='Refunds';
            am.Location__c='110- Las Vegas';
            insert am;
            Refunds_ICS__c i1 = new Refunds_ICS__c();
            i1.Amount__c=1500;
            i1.Last_4_of_CC__c='2000';	
            i1.Last_4_of_Token__c='3000';
            i1.AR1_Approver_Name__c =i1.Name;
            i1.CSI_ICS__c=ICS1.Id;
            i1.AR2_Approver_Name__c =i1.Name;     
            List<Refunds_ICS__c> RefundsList = new List<Refunds_ICS__c>();
            RefundsList.add(i1);
            insert RefundsList;
            ICS_Refunds_Approver_Update.Refunds_Approverdetails(RefundsList);                 
 	  	 }
     @istest
  		  public static void test2(){        
   			ICS_Approver_Matrix__c AM=new ICS_Approver_Matrix__c();
            Employees__c e=new Employees__c();
            e.name='sample';
            e.Email_Address__c='sample@sample.com';
            insert e;
            Employees__c e1=new Employees__c();
            e1.name='sample1';
            e1.Email_Address__c='sample1@sample.com';
            insert e1;
            Customer_Service_Inquiries_ICS__c ICS2 = TestDataUtil.createTestCustomerServiceInquries();
            ICS2.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
            ICS2.Case_Approval_Status__c = 'Requestor Submitted';        
            ICS2.Case_Requestor_Email_ID__c='sample1@sample.com';
            insert ICS2;
            am.Min_Amount__c=10001;
            am.AR1_Approver__c=e1.id;
            am.AR2_Approver__c=e.id;
            am.CSO_Approver__c=e.id;      
            am.Additional_Approver__c=e.id;
            am.Transaction_Types__c='Refunds';
            am.Location__c='110- Las Vegas';
            insert am;
            Refunds_ICS__c i1 = new Refunds_ICS__c();
            i1.Amount__c=100001;
            i1.Last_4_of_CC__c='2000';	
            i1.Last_4_of_Token__c='3000';
            i1.AR1_Approver_Name__c =i1.Name;
            i1.CSI_ICS__c=ICS2.Id;
            i1.AR2_Approver_Name__c =i1.Name;     
            List<Refunds_ICS__c> RefundsList = new List<Refunds_ICS__c>();
            RefundsList.add(i1);
            insert RefundsList;
            ICS_Refunds_Approver_Update.Refunds_Approverdetails(RefundsList);                 
 	  	 }
  }