@isTest
public class CA_SponTriggerTest {
    
    @testSetup
    public static void testsetupMethod(){
        CA_Personalized_Object_Setting__c perSetObj01 = LC_TestUtils.insertMainEventPersonSetObj();
        CA_Main_Event__c mainEvent = LC_TestUtils.insertMainEvent();
		
		List<CA_Manager__c> corpAccMgr= new List<CA_Manager__c>();
		corpAccMgr.add(new CA_Manager__c(Email__c='ilenia.casarotto@bms.com',First_Name__c='Carol',Last_Name__c='Ardolino',Phone__c='+44(0)1895 523688'));
		corpAccMgr.add(new CA_Manager__c(Email__c='dbullock@ges.com',First_Name__c='Deana',Last_Name__c='Bullock',Phone__c='(781) 844-9131'));
		corpAccMgr.add(new CA_Manager__c(Email__c='mmulvey@ges.com',First_Name__c='Alexa',Last_Name__c='Kelly',Phone__c='(617) 852-3593'));
		corpAccMgr.add(new CA_Manager__c(Email__c='rCosta@ges.com',First_Name__c='Debra',Last_Name__c='Costa',Phone__c='(859) 283-8727'));
		corpAccMgr.add(new CA_Manager__c(Email__c='bradfinstrom@gmail.com',First_Name__c='Brad',Last_Name__c='Finstrom',Phone__c='(815) 687-4234'));
		
		insert corpAccMgr;
		List<CA_Product__c> products =new List<CA_Product__c>();
		
        CA_Sponsorship__c parentSP  = new CA_Sponsorship__c();
        parentSP.Event__c= mainEvent.Id;
        parentSP.Sponsorship_Name__c='test SP003';
        insert parentSP;
        CA_Product__c tempProd6= new CA_Product__c();
        tempProd6.Sponsorship__c=parentSP.Id;
        tempProd6.Event__c=mainEvent.Id;
        products.add(tempProd6);
        
        insert products;
    }
    
        @isTest
    public static void testUpdateContactFields(){
        CA_Sponsorship__c parentEx = [SELECT Id, Name,Cancelled__c,Cancellation_Date__c,Reason_for_Cancellation__c,Event_Manager__c,GES_Account_Executive__c,GES_Account_Manager__c,GES_Project_Manager__c,I_D_Supervisor__c FROM CA_Sponsorship__c WHERE Sponsorship_Name__c = 'test SP003'];  

		parentEx.GES_Account_Executive__c='Bullock, Deana';
		parentEx.GES_Account_Manager__c='Costa, Debra';
		parentEx.GES_Project_Manager__c='Kelly, Alexa';
		//parentEx.I_D_Supervisor__c='Finstrom, Brad';
		parentEx.Event_Manager__c='Ardolino, Carol';
		
		update parentEx;
		
        
    }
	        @isTest
    public static void testCancel(){
        CA_Sponsorship__c parentEx = [SELECT Id, Name,Cancelled__c,Cancellation_Date_Time__c,Reason_for_Cancellation__c,Event_Manager__c,GES_Account_Executive__c,GES_Account_Manager__c,GES_Project_Manager__c,I_D_Supervisor__c FROM CA_Sponsorship__c WHERE Sponsorship_Name__c = 'test SP003'];
		
		parentEx.Cancelled__c=TRUE;
		parentEx.Reason_for_Cancellation__c='Product Owner Decision';
		parentEx.Cancellation_Date_Time__c=DateTime.now();
		update parentEx;
        
        parentEx.Cancelled__c=False;
        update parentEx;
    }
	
		        @isTest
    public static void testDelete(){
        CA_Sponsorship__c parentEx = [SELECT Id, Name,Cancelled__c,Cancellation_Date__c,Reason_for_Cancellation__c,Event_Manager__c,GES_Account_Executive__c,GES_Account_Manager__c,GES_Project_Manager__c,I_D_Supervisor__c FROM CA_Sponsorship__c WHERE Sponsorship_Name__c = 'test SP003'];
		
		delete parentEx;
        
    }
    
}