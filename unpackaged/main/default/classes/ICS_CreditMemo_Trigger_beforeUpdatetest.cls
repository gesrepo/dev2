@isTest
public class ICS_CreditMemo_Trigger_beforeUpdatetest {
    static Account facility=TestDataUtil.CreateTestFacility();
    static Account firm=TestDataUtil.CreateTestFirm();
    static Show__c show=TestDataUtil.CreateTestShow(firm.id);
	static List<Credit_Memo_ICS__c> testdata=new List<Credit_Memo_ICS__c>();
     static Credit_Memo_ICS__c cmi=new Credit_Memo_ICS__c();
    
    @istest
    public static void testCheck1() {
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
        	//ICS1.Case_Requestor__c ='Soniya';
            ICS1.Case_Requestor_Email_ID__c='soniya.gopu@slkgroup.com';
            ICS1.Sales_Channel__c='E&E (Trade Show)';
            insert ICS1;
            AM.Min_Amount__c=1000;
            AM.Max_Amount__c=10000;
        	AM.LOB_Approver__c=e1.id;
        	AM.F_R_Approver__c=e1.id;
            AM.AR1_Approver__c=e1.id;
     	   	AM.CSO_Approver__c=e.id;  
            AM.AR2_Approver__c=e.id;    
            AM.Additional_Approver__c=e.id;
            AM.Transaction_Types__c='Credit Memo';
        	AM.Sales_Channel__c='E&E (Trade Show)';
        	AM.LOB__c='AUDIO VISUAL';
        	AM.Reason_Code_Category__c='Cat - B';
            AM.Location__c='110- Las Vegas';
            insert AM;
        
            Credit_Memo_ICS__c cmi = new Credit_Memo_ICS__c();
            cmi.CSI_ICS__c=ICS1.id;
            cmi.Amount_w_psp__c = 1000;
            cmi.Tax_Amount__c = 200;
            cmi.Credit_Memo_Reason__c = 'Bad Debt: CM';
            cmi.Reason_Code_Category__c='Cat - B';
            cmi.Credit_LOB__c = 'AUDIO VISUAL';
       		cmi.LOB_Approver_Name__c = cmi.Name;
        	cmi.F_R_Approver_Name__c=cmi.Name;
        	cmi.AR1_Approver_Name__c=cmi.Name;
        	cmi.CSO_Approver_Name__c=cmi.Name;
        	cmi.AR2_Approver_Name__c=cmi.Name;
        	cmi.Additional_Approver_Name__c=cmi.Name;
      		List<Credit_Memo_ICS__c> CrList = new List<Credit_Memo_ICS__c>();
            CrList.add(cmi);        	
            insert cmi;   
            cmi.Location__c = '110- Las Vegas';
            //cmi.Case_Sales_Channel__c='E&E (Trade Show)';
            update cmi;
        	ICS_CreditMemo_Handler.CMapproverdetails(CrList); 
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
              //  ICS.Customer__c = '1002';   
                insert ICS;
                
                Credit_Memo_ICS__c Cr = new Credit_Memo_ICS__c();
                Cr.CSI_ICS__c = ICS.Id; 
                Cr.Amount_w_psp__c  = 20000;
                Cr.Tax_Amount__c = 100;
                Cr.Completed_Transaction__c = False;                
                //  cr.Credit_LOB__C = 'AUDIO VISUAL';
                Cr.Credit_Memo_Reason__c    = 'Accounts Receivables Billing Error: CM ERROR';  
                insert Cr;                    
                Cr.Completed_Transaction__c = true;
                update Cr;
           }           
    
    
     @istest
    public static void testCheck2() {
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
        	//ICS1.Case_Requestor__c ='Soniya';
            ICS1.Case_Requestor_Email_ID__c='soniya.gopu@slkgroup.com';
        	//ICS1.Location__c = '710- Chicago, Cleveland, Milwaukee, St. Louis';
            ICS1.Sales_Channel__c='E&E (Trade Show)';
            insert ICS1;
            AM.Min_Amount__c=1000;
            AM.Max_Amount__c=10000;
        	AM.LOB_Approver__c=e1.id;
        	AM.F_R_Approver__c=e1.id;
            AM.AR1_Approver__c=e1.id;
     	   	AM.CSO_Approver__c=e.id;  
            AM.AR2_Approver__c=e.id;    
            AM.Additional_Approver__c=e.id;
            AM.Transaction_Types__c='Credit Memo';
        	AM.Sales_Channel__c='E&E (Trade Show)';
      		Am.LOB__c='AUDIO VISUAL';
        	AM.Reason_Code_Category__c='Cat - A';
            AM.Location__c='710- Chicago, Cleveland, Milwaukee, St. Louis';
            insert AM;
        
            Credit_Memo_ICS__c cmi = new Credit_Memo_ICS__c();
            cmi.CSI_ICS__c=ICS1.id;
            cmi.Amount_w_psp__c = 1000;
            cmi.Tax_Amount__c = 200;
       		cmi.Credit_LOB__c = 'AUDIO VISUAL';
        	//cmi.Total_Amount__c = 1002000;
            cmi.Credit_Memo_Reason__c = 'Accounts Receivables Billing Error: CM ERROR';
            cmi.Reason_Code_Category__c='Cat - A';
            //cmi.Credit_LOB__c = 'AUDIO VISUAL';
       		cmi.LOB_Approver_Name__c = cmi.Name;
        	cmi.F_R_Approver_Name__c=cmi.Name;
        	cmi.AR1_Approver_Name__c=cmi.Name;
        	cmi.CSO_Approver_Name__c=cmi.Name;
        	cmi.AR2_Approver_Name__c=cmi.Name;
        	cmi.Additional_Approver_Name__c=cmi.Name;
      		List<Credit_Memo_ICS__c> CrList = new List<Credit_Memo_ICS__c>();
            CrList.add(cmi);
            insert cmi;   
            //cmi.Location__c = '710- Chicago, Cleveland, Milwaukee, St. Louis';
            //cmi.Sales_Channel__c='E&E (Trade Show)';           
            //update cmi;
        	ICS_CreditMemo_Handler.CMapproverdetails(CrList); 
  } 
  @istest
    public static void testCheck3() {
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
        	//ICS1.Case_Requestor__c ='Soniya';
            ICS1.Case_Requestor_Email_ID__c='soniya.gopu@slkgroup.com';
            ICS1.Sales_Channel__c='E&E (Trade Show)';
            insert ICS1;
            AM.Min_Amount__c=1000;
            AM.Max_Amount__c=100000;
        	AM.LOB_Approver__c=e1.id;
        	AM.F_R_Approver__c=e1.id;
            AM.AR1_Approver__c=e1.id;
     	   	AM.CSO_Approver__c=e.id;  
            AM.AR2_Approver__c=e.id;    
            AM.Additional_Approver__c=e.id;
            AM.Transaction_Types__c='Credit Memo';
        	AM.Sales_Channel__c='E&E (Trade Show)';
      		AM.LOB__c='AUDIO VISUAL';
        	AM.Reason_Code_Category__c='Cat - C';
            AM.Location__c='710- Chicago, Cleveland, Milwaukee, St. Louis';
            insert AM;
        
            Credit_Memo_ICS__c cmi = new Credit_Memo_ICS__c();
            cmi.CSI_ICS__c=ICS1.id;
            cmi.Amount_w_psp__c = 1000;
            cmi.Tax_Amount__c = 200;
            cmi.Credit_Memo_Reason__c = 'Order Entry Error: CM';
            cmi.Reason_Code_Category__c='Cat - C';
            cmi.Credit_LOB__c = 'AUDIO VISUAL';
       		cmi.LOB_Approver_Name__c = cmi.Name;
        	cmi.F_R_Approver_Name__c=cmi.Name;
        	cmi.AR1_Approver_Name__c=cmi.Name;
        	cmi.CSO_Approver_Name__c=cmi.Name;
        	cmi.AR2_Approver_Name__c=cmi.Name;
        	cmi.Additional_Approver_Name__c=cmi.Name;
      		List<Credit_Memo_ICS__c> CrList = new List<Credit_Memo_ICS__c>();
            CrList.add(cmi);
            insert cmi;   
            cmi.Location__c = '710- Chicago, Cleveland, Milwaukee, St. Louis';
            //cmi.Sales_Channel__c='E&E (Trade Show)';           
            update cmi;
        	ICS_CreditMemo_Handler.CMapproverdetails(CrList); 
  }     
     @istest
    public static void testCheck4() { 
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
			//ICS1.Case_Requestor__c ='Soniya';        
            ICS1.Case_Requestor_Email_ID__c='soniya.gopu@slkgroup.com';
            insert ICS1;
            AM.Min_Amount__c=1000000;
            //AM.Max_Amount__c=10000;
        	AM.LOB_Approver__c=e1.id;
        	AM.F_R_Approver__c=e1.id;
            AM.AR1_Approver__c=e1.id;
     	   	AM.CSO_Approver__c=e.id;  
            AM.AR2_Approver__c=e.id;    
            AM.Additional_Approver__c=e.id;
            AM.Transaction_Types__c='Credit Memo';
        	AM.Sales_Channel__c='E&E (Trade Show)';
      	    AM.LOB__c='AUDIO VISUAL';
        	AM.Reason_Code_Category__c='Cat - B';
            AM.Location__c='710- Chicago, Cleveland, Milwaukee, St. Louis';
            insert AM;
        
            Credit_Memo_ICS__c cmi = new Credit_Memo_ICS__c();
            cmi.CSI_ICS__c=ICS1.id;
            cmi.Amount_w_psp__c = 1000001;
            cmi.Tax_Amount__c = 200;
        	//cmi.Total_Amount__c = 1002000;
            cmi.Credit_Memo_Reason__c = 'Bad Debt: CM';
            cmi.Reason_Code_Category__c='Cat - B';
            cmi.Credit_LOB__c = 'AUDIO VISUAL';
            cmi.Credit_LOB__c = 'AUDIO VISUAL';
       		cmi.LOB_Approver_Name__c = cmi.Name;
        	cmi.F_R_Approver_Name__c=cmi.Name;
        	cmi.AR1_Approver_Name__c=cmi.Name;
        	cmi.CSO_Approver_Name__c=cmi.Name;
        	cmi.AR2_Approver_Name__c=cmi.Name;
        	cmi.Additional_Approver_Name__c=cmi.Name;
      		List<Credit_Memo_ICS__c> CrList = new List<Credit_Memo_ICS__c>();
            CrList.add(cmi);
            insert cmi;   
            cmi.Location__c = '710- Chicago, Cleveland, Milwaukee, St. Louis';
            cmi.Sales_Channel__c='E&E (Trade Show)';
            update cmi;
        	ICS_CreditMemo_Handler.CMapproverdetails(CrList); 
  } 
    
}