@isTest
public class LC_ShowDetailsApexTest {
     @testSetup static void setup() {
        GC_Connect2_Show__c testShws = new GC_Connect2_Show__c(Job_Number__c='Show');
        insert testShws;     
     }

    @isTest Static Void testfogetrecords(){
    GC_Connect2_Show__c testShowId= [select id,Job_Number__c from GC_Connect2_Show__c where Job_Number__c='Show' ];
    LC_ShowDetailsApex.showDetils(testShowId.id,testShowId.Job_Number__c);
        LC_ShowDetailsApex.fetchUser();
        LC_ShowDetailsApex.getShows(testShowId.Id);
    }
 @isTest Static Void testfogetrecords1(){
    GC_Connect2_Show__c testShowId= [select id,Job_Number__c from GC_Connect2_Show__c where Job_Number__c='Show' ];
    LC_ShowDetailsApex.showDetils(testShowId.id,'');
 }
    @isTest Static Void testfogetrecords2(){
    GC_Connect2_Show__c testShowId= [select id,Job_Number__c from GC_Connect2_Show__c where Job_Number__c='Show' ];
    LC_ShowDetailsApex.showDetils('',testShowId.Job_Number__c);
 }
    
}