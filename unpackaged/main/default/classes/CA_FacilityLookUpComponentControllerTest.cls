@isTest
public class CA_FacilityLookUpComponentControllerTest{
    @isTest
    public static void testgetAccounts(){
        List<Account> searchedAccounts=CA_FacilityLookUpComponentController.getAccounts('hilton');
        CA_FacilityComponentContoller temp = new CA_FacilityComponentContoller();
    }
 
    @isTest
    public static void testgetProjectCentralShows(){
        List<GC_Connect2_Show__c> searchedgetProjectCentralShows=CA_FacilityLookUpComponentController.getProjectCentralShows('Sample Tradeshow');
        CA_FacilityComponentContoller temp = new CA_FacilityComponentContoller();
    }
}