@isTest
public class CampaignMemberAllTest {

    public static testMethod void Test_UpdateCampaignMemberExhibitorAndBooth() {
    
        Show__c sh = new Show__c();
        sh.Show_ID__c = '153295';
        //sh.Close_Date__c = Date.today() + 20;
        insert sh;
            
        Account ac = new Account();
        ac.Name = 'Lucian 452245';
        insert ac;
        
        Opportunity op = new Opportunity();
        op.Show_Name__c = sh.Id;
        op.Amount = 1000;
        op.Name = 'Lucian 334219';
        op.StageName = 'Prospecting';
        op.CloseDate = Date.today() + 20;
        op.Show_Close_Date__c = Date.today() + 20;
        op.RecordTypeId = [select Id from RecordType where Name = 'Master Show Occurrence' and SobjectType = 'Opportunity'].id;
        insert op;
        
        Opportunity op2 = new Opportunity();
        op2.Show_Occurrence__c = op.Id;
        op2.Amount = 1000;
        op2.Name = 'Lucian 334220';
        op2.StageName = 'Prospecting';
        op2.CloseDate = Date.today() + 20;
        op2.Show_Close_Date__c = Date.today() + 20;
        op2.RecordTypeId = [select Id from RecordType where Name = 'EMEA - AV' and SobjectType = 'Opportunity'].id;
        insert op2;
    
        Contact co = new Contact();
        co.LastName = 'Lucian 324351';
        insert co;
        
        Oracle_Show_Booth__c bo = new Oracle_Show_Booth__c();
        bo.Account__c = ac.Id;
        bo.Show_Occurrence__c = op.Id;
        insert bo;
        
        Oracle_Show_Booth_Contact__c bc = new Oracle_Show_Booth_Contact__c();
        bc.Contact__c = co.Id;
        bc.Oracle_Show_Booth__c = bo.Id;
        insert bc;
        
        Campaign ca = new Campaign();
        ca.Name = 'Lucian 123098';
        ca.Show__c = sh.Id;
        ca.Exhibition_Opportunity__c = op.Id;
        insert ca;
        
        CampaignMember cm = new CampaignMember();
        cm.CampaignId = ca.Id;
        cm.ContactId = co.Id;
        insert cm;
        
        cm = [SELECT Booth__c, Exhibitor__c FROM CampaignMember WHERE Id = :cm.Id];
        
        System.assertEquals(bo.Id, cm.Booth__c);
        System.assertEquals(ac.Id, cm.Exhibitor__c);
    
    }

}