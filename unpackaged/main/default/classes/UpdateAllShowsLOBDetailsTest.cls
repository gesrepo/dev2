@isTest    
public class UpdateAllShowsLOBDetailsTest{
    static testMethod void MyTest(){
    
    
        Account a = new Account();
        a.name = 'test account';
        a.recordTypeId = [select Id from RecordType where Name = 'Firm' and SobjectType = 'Account'].id;
        insert a;
        
        Show__c s = new Show__c();
        s.Show_ID__c = 'abcdef';
        insert s;
        Show__c s2 = new Show__c();
        s2.Show_ID__c = 'abcdee';
        s2.Registration_Not_Applicable__c = true;
        s2.Housing_Not_Applicable__c = true;
        s2.AV_Not_Applicable__c = true;
        insert s2;
        
        Opportunity o1 = new Opportunity();
        Opportunity o2 = new Opportunity();
        Opportunity o3 = new Opportunity();
        Opportunity o4 = new Opportunity();
        Opportunity o5 = new Opportunity();
        Opportunity o6 = new Opportunity();
        Opportunity o7 = new Opportunity();
        Opportunity o8 = new Opportunity();
        
        //Exh
        o2.name = 'test opp 2';
        o2.stagename = 'LO';
        o2.closedate = Date.today()+10;
        o2.Show_Name__c = s.id;
        o2.Show_Close_Date__c = Date.Today()+10;
        o2.RecordTypeId = [select Id from RecordType where Name = 'Master Show Occurrence' and SobjectType = 'Opportunity'].id;
        o2.amount = 20000;
        o2.Prime_Contractor__c = a.id;
        
        //Exh
        o6.name = 'test opp 6';
        o6.stagename = 'LO';
        o6.closedate = Date.today()+11;
        o6.Show_Name__c = s.id;
        o6.Show_Close_Date__c = Date.Today()+15;
        o6.RecordTypeId = [select Id from RecordType where Name = 'EMEA - AV' and SobjectType = 'Opportunity'].id;
        o6.amount = 20000;
        o6.Prime_Contractor__c = a.id;
        
        List<Opportunity> opps = new List<Opportunity>();
        opps.add(o2);
        opps.add(o6);
        insert opps;
        
        //Hs
        o3.name = 'test opp 3';
        o3.stagename = 'CV';
        o3.closedate = Date.today()+15;
        o3.Show_Name__c = s.id;
        o3.Show_Close_Date__c = Date.Today()+15;
        o3.Housing_Provider__c = 'test provider 3';
        o3.Show_Occurrence__c = o2.id;
        o3.RecordTypeId = [select Id from RecordType where Name = 'EMEA - AV' and SobjectType = 'Opportunity'].id;
        o3.amount = 30000;
        
        //Hs
        o8.name = 'test opp 8';
        o8.stagename = 'CV';
        o8.closedate = Date.today()+20;
        o8.Show_Name__c = s.id;
        o8.Show_Close_Date__c = Date.Today()+16;
        o8.Housing_Provider__c = 'test provider 8';
        o8.Show_Occurrence__c = o6.id;
        o8.RecordTypeId = [select Id from RecordType where Name = 'EMEA – Housing' and SobjectType = 'Opportunity'].id;
        o8.amount = 50000;
        
        //Reg
        o4.name = 'test opp 4';
        o4.stagename = 'Won';
        o4.closedate = Date.today()+25;
        o4.Show_Name__c = s.id;
        o4.Show_Close_Date__c = Date.Today()+25;
        o4.Registration_Provider__c = 'test provider 4';
        o4.Show_Occurrence__c = o2.id;
        o4.RecordTypeId = [select Id from RecordType where Name = 'EMEA - Registration' and SobjectType = 'Opportunity'].id;
        o4.amount = 40000;
        
        //Reg
        o5.name = 'test opp 5';
        o5.stagename = 'Won';
        o5.closedate = Date.today()+25;
        o5.Show_Name__c = s.id;
        o5.Show_Close_Date__c = Date.Today()+26;
        o5.Registration_Provider__c = 'test provider 5';
        o5.Show_Occurrence__c = o6.id;
        o5.RecordTypeId = [select Id from RecordType where Name = 'EMEA - AV' and SobjectType = 'Opportunity'].id;
        o5.amount = 40000;
        
        //AV
        o1.name = 'test opp 1';
        o1.stagename = 'CR';
        o1.closedate = Date.today()+5;
        o1.Show_Name__c = s.id;
        o1.Show_Close_Date__c = Date.Today()+5;
        o1.Audio_Visual_Provider__c = 'test provider 1';
        o1.Show_Occurrence__c = o2.id;
        o1.RecordTypeId = [select Id from RecordType where Name = 'AV - CR' and SobjectType = 'Opportunity'].id;
        o1.amount = 10000;
        
        //AV
        o7.name = 'test opp 7';
        o7.stagename = 'CR';
        o7.closedate = Date.today()+6;
        o7.Show_Name__c = s.id;
        o7.Show_End_Date_Time__c = Date.Today()+35;
        o7.Audio_Visual_Provider__c = 'test provider 7';
        o7.Show_Occurrence__c = o6.id;
        o7.RecordTypeId = [select Id from RecordType where Name = 'EMEA - AV New Business' and SobjectType = 'Opportunity'].id;
        o7.amount = 10000;
        
        List<Opportunity> opps2 = new List<Opportunity>();
        opps2.add(o3);
        opps2.add(o4);
        opps2.add(o5);
        opps2.add(o1);
        opps2.add(o7);
        opps2.add(o8);
        insert opps2;
        
        //UpdateAllShowsLOBDetails batch = new UpdateAllShowsLOBDetails();
        Database.executeBatch(new UpdateAllShowsLOBDetails(), 200);
        

    }
}