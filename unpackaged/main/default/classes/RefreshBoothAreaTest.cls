/********************************************************
* Author: Karthik N, Created: 9/25/2017 
* This Class implements test methods for RefreshBoothArea
*********************************************************/
@isTest
public class RefreshBoothAreaTest {
    
    @isTest
    static void RefreshMethodCallout(){
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        InsertTestBoothArea(show.Id);
       
        Test.setMock(WebServiceMock.class, new RefreshBoothWebServiceMock('RefreshMethod'));
        Test.startTest();
        RefreshBoothArea.refreshMethod(show.Id);
        Test.stopTest();
    }
    
    private static void InsertTestBoothArea(string ShowId){
        Booth_Area__c bc=new Booth_Area__c();
        bc.Name='MATERIAL HANDLING';
        bc.BoothID_Area__c='431202';
        bc.Completion_Date_time__c=system.today();
        bc.Deleteable__c=false;
        bc.Delivery_Date_time__c=system.today();
        bc.Delivery_Location__c='Bangalore';
        bc.Display_Sequence__c=string.valueOf(1010);
        bc.Editable__c=true;
        bc.FacilityId__c=string.valueOf(1291);
        bc.Job_Number__c=string.valueOf(071079249);
        bc.Removal_Date_time__c=system.today();
        bc.ShowOccrCustomerId__c=349334;
        bc.ShowToCustomer__c=true;
        bc.Connect2_Show__c = showId;
        bc.Zone_Id__c='B1';
        bc.GroupOrdersByCategory__c = true;
        insert bc;
    }
}