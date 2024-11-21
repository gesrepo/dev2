/**
* @author Ethos Solutions - www.ethos.com
* @description Test code for design budget calculator controller
* 2016-04-13 : Original Version
**/
@isTest
private class GC_DesignBudgetCalculator_ControllerTest {

    @isTest static void testBudgetAccess() {
        GC_Connect2_Show__c show =  GC_TestUtils.getTestConnect2Show();
        GC_Design_Request_Form__c newDRF = GC_TestUtils.getTestDRF(show.Id);
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(newDRF);
        GC_DesignBudgetCalculator_Controller cont = new GC_DesignBudgetCalculator_Controller(sc);
        GC_Design_Request_Form__c drf = cont.getDRF();
        System.assertEquals(newDRF.Id, drf.Id);
        cont.createNewBudget();
        GC_Design_Request_Form_Budget__c budget = cont.Budget;
        System.assertNotEquals(null, budget);
        budget.New_Concept_Design_Style_Guide_Units__c = 1;
        budget.New_Concept_Design_Style_Guide__c = 1;
        cont.updateBudget();
        budget = cont.Budget;
        System.assertEquals(19.20, budget.Design_Style_Guide_Formula_e_hrs__c);
        PageReference pg = cont.backToDRF();
        System.assertEquals(pg.getUrl(), '/' + cont.Budget.Design_Request_Form__c);

        Boolean canRevise = cont.getCanCreateRevision();

        System.assertEquals(canRevise, false, 'Should not be able to revise');

        budget.Status__c = 'Approved';
        cont.updateBudget();
        canRevise = cont.getCanCreateRevision();
        System.Debug('' + canRevise);
        System.assertEquals(canRevise, true, 'Should be able to revise');
    }

    @isTest static void testCloneAndRevision() {
        GC_Connect2_Show__c show =  GC_TestUtils.getTestConnect2Show();
        GC_Design_Request_Form__c newDRF = GC_TestUtils.getTestDRF(show.Id);
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(newDRF);
        GC_DesignBudgetCalculator_Controller cont = new GC_DesignBudgetCalculator_Controller(sc);
        GC_Design_Request_Form__c drf = cont.getDRF();
        System.assertEquals(newDRF.Id, drf.Id);
        cont.createNewBudget();
        GC_Design_Request_Form_Budget__c budget = cont.Budget;
        System.assertNotEquals(null, budget);
        budget.New_Concept_Design_Style_Guide_Units__c = 1;
        budget.New_Concept_Design_Style_Guide__c = 1;
        cont.updateBudget();
        budget = cont.Budget;
        System.assertEquals(19.20, budget.Design_Style_Guide_Formula_e_hrs__c);
        PageReference pg = cont.backToDRF();
        System.assertEquals(pg.getUrl(), '/' + cont.Budget.Design_Request_Form__c);

        Boolean canRevise = cont.getCanCreateRevision();

        System.assertEquals(canRevise, false, 'Should not be able to revise');

        budget.Status__c = 'Approved';
        cont.updateBudget();
        canRevise = cont.getCanCreateRevision();
        System.Debug('' + canRevise);
        System.assertEquals(canRevise, true, 'Should be able to revise');
        GC_Design_Request_Form_Budget__c clone = cont.getClone();
        cont.updateBudget();
        cont.cancelBudget();
        cont.getBudgetLink();
        System.assertNotEquals(cont.Clone, null);
        ApexPages.currentPage().getParameters().put('IsRevision' , '1');
        cont = new GC_DesignBudgetCalculator_Controller(sc);
        System.assertNotEquals(cont.Clone, null);

    }

}