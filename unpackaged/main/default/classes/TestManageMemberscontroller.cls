/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestManageMemberscontroller {

    static testMethod void myUnitTest() {
        
        Campaign camp=new Campaign(name='andreea test class'); // Name = 'Test'
        insert camp;
        CampaignMember  cmp = new CampaignMember(); 
        list<CampaignMember> lli = new  list<CampaignMember>();
        lli.add(cmp);
       ManageMembersController mb=new ManageMembersController(new ApexPages.standardcontroller(camp));
       CampaignMember  cmp1 = new CampaignMember(); 
        list<CampaignMember> lli1 = new  list<CampaignMember>();
        lli.add(cmp1);
       mb.selectall =  true;
       mb.statusupdate = 'test';
       mb.members = lli;
      // mb.applyfilters(field, operator, value, strselect);
       //mb.
       mb.go();
       mb.first();
       mb.last();
       mb.previos();
       mb.next();
       mb.getstatuses();
       mb.remove();
       mb.selectallLines();
       mb.removeoneline();
       mb.getnoofrecords();
       mb.getlistsize();
       mb.save();
       
      ManageMembersController.Member dfc  = new ManageMembersController.Member(cmp); 
      list<ManageMembersController.Member> des = new list<ManageMembersController.Member> ();
      des.add(dfc);
     
       mb.field1='member_owner__c';
       mb.operator1='equals';
       mb.value1='andreea test class';
       
         mb.field2='member_owner__c';
       mb.operator2='equals';
       mb.value2='andreea test class';
       
         mb.field3='member_owner__c';
       mb.operator3='equals';
       mb.value3='andreea test class';
       
         mb.field4='member_owner__c';
       mb.operator4='equals';
       mb.value4='andreea test class';
       
         mb.field5='member_owner__c';
       mb.operator5='equals';
       mb.value5='andreea test class';
       
       mb.savecolumns();
       mb.go();
       mb.getMyPageBlockTable();
       mb.getmemberswcurent();
       mb.showcolumns();
       mb.changestatus();
       mb.applyfilters('Name', 'equals', 'andreea test class', 'strselect');
       mb.applyfilters('Name', 'equals', '', 'strselect');
       mb.applyfilters('Name', 'contains', 'andreea test class', 'strselect');
       mb.applyfilters('Name', 'starts with', 'andreea test class', 'strselect'); 
        mb.applyfilters('Name', 'does not contain', 'andreea test class', 'strselect'); 
       mb.cancelcolumns();
       mb.clearfilters();
       mb.copyvalueandsave();
       mb.getcurin();
       mb.getfields();
       mb.getfields2();
       mb.getcurin();
       mb.recalculatelines();
       
       
    }
}