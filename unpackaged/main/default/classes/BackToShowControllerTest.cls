@isTest
public class BackToShowControllerTest {
 @testSetup static void setup() {
        GC_Connect2_Show__c testShws = new GC_Connect2_Show__c(Job_Number__c='Show');
        insert testShws;    
     
      Booth_Area__c parentBooth=new Booth_Area__c(BoothID_Area__c='1001',Connect2_Show__c=testShws.Id);
        insert parentBooth;
     }
    public Static testMethod Void ConstructorMethod(){
        
    List<GC_Connect2_Show__c> testShowId=[select id,Job_Number__c from GC_Connect2_Show__c where Job_Number__c= 'Show' ];
    Booth_Area__c parentBooth=[select id,BoothID_Area__c,Connect2_Show__c from Booth_Area__c where Connect2_Show__c=:testShowId[0].id];
    BackToShowController.getShowId(parentBooth.Id);
 }
}