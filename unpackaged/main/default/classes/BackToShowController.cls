public class BackToShowController {
    
     @AuraEnabled
    public static string getShowId(string ShowId){
        Booth_Area__c shw = new Booth_Area__c();
        shw=[select id,Connect2_Show__c,name from Booth_Area__c where id =:ShowId];
        return shw.Connect2_Show__c;
    }

}