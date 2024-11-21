@isTest
public class ClaimsDisplayInformationControllerTest {
    @testSetup static void setup(){
        Claims__Claim__c testAccts = new Claims__Claim__c (
               NON_GES_Driver_First_Name__c='NONGES',
                    NON_GES_Driver_Last_Name__c='NONGRSLnmae',
                    Driver_First_Name__c='DriverFname',
                    Driver_Last_Name__c='DriverLname',
                    Injured_Party_First_Name__c='Fname',
                    Injured_Party_Last_Name__c='Lname',
                    Carrier_Claim_No__c='Cnumber',
                    Customer_Company_Name__c='CustomerName',
                    GES_Driver_Full_Name__c='Ges',
                    Injured_Employee_First_Name__c='InjFname',
                    Injured_Employee_Last_Name__c='InjLname'
        );
        insert testAccts;
        Claims__Claim__c testAccts2 = new Claims__Claim__c(
            Injured_Party_First_Name__c=null,
            Injured_Party_Last_Name__c='Lname1',
            Customer_Company_Name__c='Customer',
            Driver_First_Name__c=null,
            Driver_Last_Name__c='Driver lName',
            NON_GES_Driver_First_Name__c=null,
            NON_GES_Driver_Last_Name__c='NON GES',
            Injured_Employee_First_Name__c=null,
            Injured_Employee_Last_Name__c='InjLname',
            Carrier_Claim_No__c='Carrier'
          
        );
        insert testAccts2; 
        Claims__Claim__c testAccts1 = new Claims__Claim__c(
            Injured_Party_First_Name__c='Fname1',
            Injured_Party_Last_Name__c=null,
            Customer_Company_Name__c='Customer',
            Driver_First_Name__c='Driver Fname',
            Driver_Last_Name__c=null,
            NON_GES_Driver_First_Name__c='NON GES',
            NON_GES_Driver_Last_Name__c=null,
            Injured_Employee_First_Name__c='InjFname',
            Injured_Employee_Last_Name__c=null,
            Carrier_Claim_No__c=null
        );
        insert testAccts1; 
        Claims__Claim__c testAccts3 = new Claims__Claim__c(
            Injured_Party_First_Name__c=null,
            Injured_Party_Last_Name__c=null,
            Customer_Company_Name__c='Customertest',
            Driver_First_Name__c=null,
            Driver_Last_Name__c=null,
            NON_GES_Driver_First_Name__c=null,
            NON_GES_Driver_Last_Name__c=null,
            Injured_Employee_First_Name__c=null,
            Injured_Employee_Last_Name__c=null,
            Carrier_Claim_No__c='CarrierCaim'
        );
        insert testAccts3; 
        Claims__Claim__c testAccts4 = new Claims__Claim__c(
            Injured_Party_First_Name__c='PFirst',
            Injured_Party_Last_Name__c='PLast',
            Customer_Company_Name__c=null,
            Driver_First_Name__c='Driver Name',
            Driver_Last_Name__c='Driver lName',
             NON_GES_Driver_First_Name__c='NON GES',
            NON_GES_Driver_Last_Name__c='NON GES Lname',
            Injured_Employee_First_Name__c='InjFname1',
            Injured_Employee_Last_Name__c='InjuLnames',
            Carrier_Claim_No__c='CarrierCaim'
        );
        insert testAccts4; 
        Claims__Claim__c testAccts5 = new Claims__Claim__c(
            Injured_Party_First_Name__c='PFirst1',
            Injured_Party_Last_Name__c='PLast',
            Customer_Company_Name__c='Customertest',
            Driver_First_Name__c='Driver Name',
            Driver_Last_Name__c='Driver lName',
            NON_GES_Driver_First_Name__c='NON GES',
            NON_GES_Driver_Last_Name__c='NON GES Lname',
            Injured_Employee_First_Name__c='InjFname',
            Injured_Employee_Last_Name__c='InjuLnamesin',
            Carrier_Claim_No__c=null
        );
        insert testAccts5; 
          Claims__Claim__c testAccts6 = new Claims__Claim__c(
            Injured_Party_First_Name__c='PFirst1',
            Injured_Party_Last_Name__c=null,
            Customer_Company_Name__c='Customertest',
            Driver_First_Name__c='Driver Name',
              Driver_Last_Name__c=null,
              NON_GES_Driver_First_Name__c='NON GES',
            NON_GES_Driver_Last_Name__c=null,
            Injured_Employee_First_Name__c='InjFname',
            Injured_Employee_Last_Name__c=null,
            Carrier_Claim_No__c='CarrierLname'
        );
        insert testAccts6; 
          Claims__Claim__c testAccts7 = new Claims__Claim__c(
            Injured_Party_First_Name__c=null,
            Injured_Party_Last_Name__c=null,
            Customer_Company_Name__c='Customertestnull',
            Driver_First_Name__c=null,
              Driver_Last_Name__c=null,
              NON_GES_Driver_First_Name__c=null,
            NON_GES_Driver_Last_Name__c=null,
            Injured_Employee_First_Name__c=null,
            Injured_Employee_Last_Name__c=null,
            Carrier_Claim_No__c=null
        );
        insert testAccts7; 
           Claims__Claim__c testAccts8 = new Claims__Claim__c(
            Injured_Party_First_Name__c=null,
            Injured_Party_Last_Name__c='LnameNotNull',
            Customer_Company_Name__c='Customertestnull',
            Driver_First_Name__c=null,
            Driver_Last_Name__c='Driver lName',
            NON_GES_Driver_First_Name__c=null,
            NON_GES_Driver_Last_Name__c='NON GES Lname',
            Injured_Employee_First_Name__c=null,
            Injured_Employee_Last_Name__c='InjuLnameNotnull',
            Carrier_Claim_No__c=null
        );
        insert testAccts8; 
    }
    public static testMethod void test_CreateClaimFromIncidentReport(){
        Test.startTest();
        List<Claims__Claim__c> claimsList = [SELECT Id,NON_GES_Driver_First_Name__c,Record_Type_Name__c,Injured_Party_First_Name__c,Injured_Party_Last_Name__c,Carrier_Claim_No__c,Customer_Company_Name__c,GES_Driver_Full_Name__c,Injured_Employee_First_Name__c,Injured_Employee_Last_Name__c FROM Claims__Claim__c where NON_GES_Driver_First_Name__c='NONGES' ];
        ClaimsDisplayInformationController corvelCls = new ClaimsDisplayInformationController(new ApexPages.standardController(claimsList[0]));
        Test.stopTest();
    }
    public static testMethod void test_CreateClaimFromIncidentReport1(){
        Test.startTest();
        List<Claims__Claim__c> claimsList = [SELECT Id,Record_Type_Name__c,Injured_Party_First_Name__c,Injured_Party_Last_Name__c,Carrier_Claim_No__c,Customer_Company_Name__c,GES_Driver_Full_Name__c,Injured_Employee_First_Name__c,Injured_Employee_Last_Name__c FROM Claims__Claim__c where Customer_Company_Name__c='Customer' ];
        ClaimsDisplayInformationController corvelCls = new ClaimsDisplayInformationController(new ApexPages.standardController(claimsList[0]));
        Test.stopTest();
    }
    
    public static testMethod void test_CreateClaimFromIncidentReport2(){
        Test.startTest();
        List<Claims__Claim__c> claimsList = [SELECT Id,Record_Type_Name__c,Injured_Party_First_Name__c,Injured_Party_Last_Name__c,Carrier_Claim_No__c,Customer_Company_Name__c,GES_Driver_Full_Name__c,Injured_Employee_First_Name__c,Injured_Employee_Last_Name__c FROM Claims__Claim__c where Injured_Employee_First_Name__c='InjFname' ];
        ClaimsDisplayInformationController corvelCls = new ClaimsDisplayInformationController(new ApexPages.standardController(claimsList[0]));
        Test.stopTest();
    }
    
    public static testMethod void test_CreateClaimFromIncidentReport3(){
        Test.startTest();
        List<Claims__Claim__c> claimsList = [SELECT Id,Record_Type_Name__c,Injured_Party_First_Name__c,Injured_Party_Last_Name__c,Carrier_Claim_No__c,Customer_Company_Name__c,GES_Driver_Full_Name__c,Injured_Employee_First_Name__c,Injured_Employee_Last_Name__c FROM Claims__Claim__c where Customer_Company_Name__c='Customertest' ];
        ClaimsDisplayInformationController corvelCls = new ClaimsDisplayInformationController(new ApexPages.standardController(claimsList[0]));
        Test.stopTest();
    }
    public static testMethod void test_CreateClaimFromIncidentReport4(){
        Test.startTest();
        List<Claims__Claim__c> claimsList = [SELECT Id,Record_Type_Name__c,Injured_Party_First_Name__c,Injured_Party_Last_Name__c,Carrier_Claim_No__c,Customer_Company_Name__c,GES_Driver_Full_Name__c,Injured_Employee_First_Name__c,Injured_Employee_Last_Name__c FROM Claims__Claim__c where Injured_Party_Last_Name__c='PLast' ];
        ClaimsDisplayInformationController corvelCls = new ClaimsDisplayInformationController(new ApexPages.standardController(claimsList[0]));
        Test.stopTest();
    }
    public static testMethod void test_CreateClaimFromIncidentReport5(){
        Test.startTest();
        List<Claims__Claim__c> claimsList = [SELECT Id,Record_Type_Name__c,Injured_Party_First_Name__c,Injured_Party_Last_Name__c,Carrier_Claim_No__c,Customer_Company_Name__c,GES_Driver_Full_Name__c,Injured_Employee_First_Name__c,Injured_Employee_Last_Name__c FROM Claims__Claim__c where Injured_Party_First_Name__c='PFirst1' ];
        ClaimsDisplayInformationController corvelCls = new ClaimsDisplayInformationController(new ApexPages.standardController(claimsList[0]));
        Test.stopTest();
    }
    
    public static testMethod void test_CreateClaimFromIncidentReport6(){
        Test.startTest();
        List<Claims__Claim__c> claimsList = [SELECT Id,Record_Type_Name__c,Injured_Party_First_Name__c,Injured_Party_Last_Name__c,Carrier_Claim_No__c,Customer_Company_Name__c,GES_Driver_Full_Name__c,Injured_Employee_First_Name__c,Injured_Employee_Last_Name__c FROM Claims__Claim__c where Carrier_Claim_No__c='CarrierLname' ];
        ClaimsDisplayInformationController corvelCls = new ClaimsDisplayInformationController(new ApexPages.standardController(claimsList[0]));
        Test.stopTest();
    }
    
    public static testMethod void test_CreateClaimFromIncidentReport7(){
        Test.startTest();
        List<Claims__Claim__c> claimsList = [SELECT Id,Record_Type_Name__c,Injured_Party_First_Name__c,Injured_Party_Last_Name__c,Carrier_Claim_No__c,Customer_Company_Name__c,GES_Driver_Full_Name__c,Injured_Employee_First_Name__c,Injured_Employee_Last_Name__c FROM Claims__Claim__c where Customer_Company_Name__c='Customertestnull' ];
        ClaimsDisplayInformationController corvelCls = new ClaimsDisplayInformationController(new ApexPages.standardController(claimsList[0]));
        Test.stopTest();
    }
    
         
    public static testMethod void test_CreateClaimFromIncidentReport8(){
        Test.startTest();
        List<Claims__Claim__c> claimsList = [SELECT Id,Record_Type_Name__c,Injured_Party_First_Name__c,Injured_Party_Last_Name__c,Carrier_Claim_No__c,Customer_Company_Name__c,GES_Driver_Full_Name__c,Injured_Employee_First_Name__c,Injured_Employee_Last_Name__c FROM Claims__Claim__c where Injured_Party_Last_Name__c='LnameNotNull' ];
        ClaimsDisplayInformationController corvelCls = new ClaimsDisplayInformationController(new ApexPages.standardController(claimsList[0]));
        Test.stopTest();
    }
    
}