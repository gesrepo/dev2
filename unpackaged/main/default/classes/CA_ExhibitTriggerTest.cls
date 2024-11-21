@isTest
public class CA_ExhibitTriggerTest {
    
    @testSetup
    public static void testsetupMethod(){
        CA_Personalized_Object_Setting__c perSetObj01 = LC_TestUtils.insertMainEventPersonSetObj();
        CA_Main_Event__c mainEvent = LC_TestUtils.insertMainEvent();
		
		List<CA_Manager__c> corpAccMgr= new List<CA_Manager__c>();
		corpAccMgr.add(new CA_Manager__c(Email__c='ilenia.casarotto@bms.com',First_Name__c='Ilenia',Last_Name__c='Casarotto',Phone__c='+44(0)1895 523688'));
		corpAccMgr.add(new CA_Manager__c(Email__c='dbullock@ges.com',First_Name__c='Deana',Last_Name__c='Bullock',Phone__c='(781) 844-9131'));
		corpAccMgr.add(new CA_Manager__c(Email__c='mmulvey@ges.com',First_Name__c='Mike',Last_Name__c='Mulvey',Phone__c='(617) 852-3593'));
		corpAccMgr.add(new CA_Manager__c(Email__c='rmarsh@ges.com',First_Name__c='Reta',Last_Name__c='Marsh',Phone__c='(859) 283-8727'));
		corpAccMgr.add(new CA_Manager__c(Email__c='bradfinstrom@gmail.com',First_Name__c='Brad',Last_Name__c='Finstrom',Phone__c='(815) 687-4234'));
		
		insert corpAccMgr;
		
		CA_Exhibit__c parentEx  = new CA_Exhibit__c();
        parentEx.Event__c= mainEvent.Id;
        parentEx.Exhibit_Name__c='test exhibit003';
		parentEx.Event_Manager__c='Casarotto, Ilenia';

        insert parentEx;
		List<CA_Product__c> products= new List<CA_Product__c>();
        CA_Product__c tempProd2= new CA_Product__c();
        tempProd2.Exhibit__c=parentEx.Id;
        tempProd2.Event__c=mainEvent.Id;
        products.add(tempProd2);
        
        insert products;
    }
    
        @isTest
    public static void testUpdateContactFields(){
        CA_Exhibit__c parentEx = [SELECT Id, Name,Cancelled__c,Cancellation_Date__c,Reason_for_Cancellation__c,Event_Manager__c,GES_Account_Executive__c,GES_Account_Manager__c,GES_Project_Manager__c,I_D_Supervisor__c FROM CA_Exhibit__c WHERE Exhibit_Name__c = 'test exhibit003'];  

		parentEx.GES_Account_Executive__c='Bullock, Deana';
		parentEx.GES_Account_Manager__c='Marsh, Reta';
		parentEx.GES_Project_Manager__c='Mulvey, Mike';
		parentEx.I_D_Supervisor__c='Finstrom, Brad';
		
		parentEx.Cancelled__c=TRUE;
		parentEx.Reason_for_Cancellation__c='Product Owner Decision';
		parentEx.Cancellation_Date__c=Date.Today();
		
		update parentEx;
		
		delete parentEx;
        
    }
	        @isTest
    public static void testCancel(){
        CA_Exhibit__c parentEx = [SELECT Id, Name,Cancelled__c,Cancellation_Date__c,Reason_for_Cancellation__c,Event_Manager__c,GES_Account_Executive__c,GES_Account_Manager__c,GES_Project_Manager__c,I_D_Supervisor__c FROM CA_Exhibit__c WHERE Exhibit_Name__c = 'test exhibit003'];
		
		parentEx.Cancelled__c=TRUE;
		parentEx.Reason_for_Cancellation__c='Product Owner Decision';
		parentEx.Cancellation_Date__c=Date.Today();
		update parentEx;
        
        parentEx.Cancelled__c=False;
        update parentEx;
    }
	
		        @isTest
    public static void testDelete(){
        CA_Exhibit__c parentEx = [SELECT Id, Name,Cancelled__c,Cancellation_Date__c,Reason_for_Cancellation__c,Event_Manager__c,GES_Account_Executive__c,GES_Account_Manager__c,GES_Project_Manager__c,I_D_Supervisor__c FROM CA_Exhibit__c WHERE Exhibit_Name__c = 'test exhibit003'];
		
		delete parentEx;
        
    }
    
}