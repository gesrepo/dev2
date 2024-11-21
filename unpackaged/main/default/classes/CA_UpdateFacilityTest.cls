@isTest
public class CA_UpdateFacilityTest 
{
@isTest
    public static void executeMethod1()
    {
        List<GC_Connect2_Show__c> lstPCS = New List<GC_Connect2_Show__c>();
        GC_Connect2_Show__c pcs = new GC_Connect2_Show__c();
        pcs.FacilityAddressPostalCode__c= 'B40 1NT';
        pcs.FacilityAddressStreet__c='The Nec';
        pcs.Facility_Address_City__c='Birmingham';
        pcs.Facility_Address_Country__c='UK';
        pcs.Facility_Address_State__c='West Midlands';
        pcs.IsUpdated__c=FALSE;
        lstPCS.add(pcs);
       
        insert lstPCS;
        
        Test.startTest();
         CA_UpdateFacility updatefac = new CA_UpdateFacility();
         DataBase.executeBatch(updatefac); 
        Test.stopTest();
    }
}