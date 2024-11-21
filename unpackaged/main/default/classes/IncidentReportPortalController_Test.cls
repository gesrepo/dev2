/**
* @description This is the test class for the IncidentReportPortalController.
*/
@isTest
private class IncidentReportPortalController_Test {

    /**
    *   @description    Tests portal type being set correctly for Workers Compensation. 
    *                   Based on url containing a particular string either in site url or as a parameter.
    */
    @isTest static void portalTypeWC_Test() {

        Test.startTest();

            PageReference pageRef = Page.IncidentReportPortal;
            pageRef.getParameters().put('type', Label.Supervisor_Portal_Path);
            Test.setCurrentPageReference(pageRef);
        
            IncidentReportPortalController ctl = new IncidentReportPortalController();

            system.assertEquals(Label.Supervisor_Portal_Path, ctl.portalType);
        Test.stopTest();

    }

    @isTest 
    private static void portalTypeWCMultiCase_Test() {

        Test.startTest();

            PageReference pageRef = Page.IncidentReportPortal;
            pageRef.getParameters().put('type', 'Supervisorportal');
            Test.setCurrentPageReference(pageRef);
        
            IncidentReportPortalController ctl = new IncidentReportPortalController();

            system.assertEquals(Label.Supervisor_Portal_Path, ctl.portalType);
        Test.stopTest();

    }

    /**
    *   @description    Tests portal type being set correctly for General Loss. 
    *                   Based on url containing a particular string either in site url or as a parameter.
    */
    @isTest 
    private static void portalTypeGL_Test() {

        Test.startTest();

            PageReference pageRef = Page.IncidentReportPortal;
            pageRef.getParameters().put('type', Label.Incident_Portal_Path);
            Test.setCurrentPageReference(pageRef);
        
            IncidentReportPortalController ctl = new IncidentReportPortalController();

            system.assertEquals(Label.Incident_Portal_Path, ctl.portalType);
        Test.stopTest();

    }

    /**
    *   @description    Tests portal type being set correctly for General Loss. 
    *                   Based on url containing a particular string either in site url or as a parameter.
    */
    @isTest 
    private static void portalTypeGLMultiCase_Test() {

        Test.startTest();

            PageReference pageRef = Page.IncidentReportPortal;
            pageRef.getParameters().put('type', 'Incidentportal');
            Test.setCurrentPageReference(pageRef);
        
            IncidentReportPortalController ctl = new IncidentReportPortalController();

            system.assertEquals(Label.Incident_Portal_Path, ctl.portalType);
        Test.stopTest();

    }

    /**
    *   @description    Tests search functionality with incorrect formatted Incident report name. 
    */
    @isTest 
    private static void searchInvalidIdTest() {

        Id rc = Schema.SObjectType.Claims__Incident_Report__c.getRecordTypeInfosByName().get('Bodily Injury').getRecordTypeId();

        List<Claims__Incident_Report__c> incidentReports = TestDataCreator.createIncidentReports(1, rc);
        insert incidentReports;
        Claims__Incident_Report__c icInserted = [SELECT Id, Name FROM Claims__Incident_Report__c WHERE Id =:incidentReports[0].Id LIMIT 1];

        PageReference pageRef = Page.IncidentReportPortal;
        pageRef.getParameters().put('type', Label.Incident_Portal_Path);
        Test.setCurrentPageReference(pageRef);

        Test.startTest();
            IncidentReportPortalController ct = new IncidentReportPortalController();
            // Set variables required for search
            ct.searchStringId = 'xxx';
            ct.selectedAction = ct.searchStage.Name();
            // Simulate selecting action.
            ct.actionSelected();
            PageReference pg = ct.searchIncidents();
            System.assertEquals(null, pg);
            System.assertEquals(true, Apexpages.hasMessages());
            System.assertEquals(Label.Search_Invalid_ID_Format, Apexpages.getMessages()[0].getDetail());
            System.assertEquals(false, ct.noReportsFound);
            System.assertEquals(ct.searchStage, ct.currentStage);
        Test.stopTest();
    }

    /**
    *   @description    Tests search functionality with both search parameters entered. 
    */
    @isTest 
    private static void searchBothParametersTest() {

        Id rc = Schema.SObjectType.Claims__Incident_Report__c.getRecordTypeInfosByName().get('Bodily Injury').getRecordTypeId();

        List<Claims__Incident_Report__c> incidentReports = TestDataCreator.createIncidentReports(1, rc);
        insert incidentReports;
        Claims__Incident_Report__c icInserted = [SELECT Id, Name FROM Claims__Incident_Report__c WHERE Id =:incidentReports[0].Id LIMIT 1];

        PageReference pageRef = Page.IncidentReportPortal;
        pageRef.getParameters().put('type', Label.Incident_Portal_Path);
        Test.setCurrentPageReference(pageRef);

        Test.startTest();
            IncidentReportPortalController ct = new IncidentReportPortalController();
            // Set variables required for search
            ct.searchStringId = 'IR-00020';
            ct.searchStringName = 'test';
            ct.selectedAction = ct.searchStage.Name();
            // Simulate selecting action.
            ct.actionSelected();
            PageReference pg = ct.searchIncidents();
            System.assertEquals(null, pg);
            System.assertEquals(true, Apexpages.hasMessages());
            System.assertEquals(Label.Search_Parameter_Error, Apexpages.getMessages()[0].getDetail());
            System.assertEquals(false, ct.noReportsFound);
            System.assertEquals(ct.searchStage, ct.currentStage);
        Test.stopTest();
    }

    /**
    *   @description - Test searching General Loss incidents by Id - returning 1 incident.
    */
    @isTest
    private static void searchGLReportByIDTest() {

        Id rc = Schema.SObjectType.Claims__Incident_Report__c.getRecordTypeInfosByName().get('Bodily Injury').getRecordTypeId();

        List<Claims__Incident_Report__c> incidentReports = TestDataCreator.createIncidentReports(1, rc);
        insert incidentReports;
        Claims__Incident_Report__c icInserted = [SELECT Id, Name FROM Claims__Incident_Report__c WHERE Id =:incidentReports[0].Id LIMIT 1];

        PageReference pageRef = Page.IncidentReportPortal;
        pageRef.getParameters().put('type', Label.Incident_Portal_Path);
        Test.setCurrentPageReference(pageRef);

        Test.startTest();
            IncidentReportPortalController ct = new IncidentReportPortalController();
            // Set variables required for search
            ct.searchStringId = icInserted.Name;
            ct.selectedAction = ct.searchStage.Name();
            // Simulate selecting action.
            ct.actionSelected();
            PageReference pg = ct.searchIncidents();
            System.assertEquals(null, pg);
            System.assertEquals(incidentReports[0].Id, ct.report.Id);
            System.assertEquals(incidentReports[0].RecordTypeId, ct.report.RecordTypeId);
            System.assertEquals(false, ct.noReportsFound);
            System.assertEquals(ct.detailStage, ct.currentStage);
        Test.stopTest();
    }

/**
    *   @description - Test searching General Loss incidents by Id - returning 0 incidents.
    */
    @isTest
    private static void searchGLReportByIDNoneFoundTest() {

        Id rc = Schema.SObjectType.Claims__Incident_Report__c.getRecordTypeInfosByName().get('Bodily Injury').getRecordTypeId();

        List<Claims__Incident_Report__c> incidentReports = TestDataCreator.createIncidentReports(1, rc);
        insert incidentReports;
        Claims__Incident_Report__c icInserted = [SELECT Id, Name FROM Claims__Incident_Report__c WHERE Id =:incidentReports[0].Id LIMIT 1];

        PageReference pageRef = Page.IncidentReportPortal;
        pageRef.getParameters().put('type', Label.Incident_Portal_Path);
        Test.setCurrentPageReference(pageRef);

        Test.startTest();
            IncidentReportPortalController ct = new IncidentReportPortalController();
            // Set variables required for search
            ct.searchStringId = 'IR-xxx';
            ct.selectedAction = ct.searchStage.Name();
            // Simulate selecting action.
            ct.actionSelected();
            PageReference pg = ct.searchIncidents();
            System.assertEquals(null, pg);
            System.assertEquals(null, ct.report.Id);
            System.assertEquals(null, ct.report.RecordTypeId);
            System.assertEquals(true, ct.availableReports.isEmpty());
            System.assertEquals(true, ct.noReportsFound);
            System.assertEquals(ct.searchStage, ct.currentStage);
        Test.stopTest();
    }

    /**
    *   @description - Test searching General Loss incidents by Preparers Last Name - returning 1 incident.
    */
    @isTest
    private static void searchGLReportByLastNameTest() {

        Id rc = Schema.SObjectType.Claims__Incident_Report__c.getRecordTypeInfosByName().get('Motor Vehicle').getRecordTypeId();

        List<Claims__Incident_Report__c> incidentReports = TestDataCreator.createIncidentReports(1, rc);
        incidentReports[0].Claims__First_Name__c = 'Test';
        incidentReports[0].Claims__Last_Name__c = 'Preparer';
        insert incidentReports;

        PageReference pageRef = Page.IncidentReportPortal;
        pageRef.getParameters().put('type', Label.Incident_Portal_Path);
        Test.setCurrentPageReference(pageRef);

        Test.startTest();
            IncidentReportPortalController ct = new IncidentReportPortalController();
            // Set variables required for search
            ct.searchStringName = 'Preparer';
            ct.selectedAction = ct.searchStage.Name();
            // Simulate selecting action.
            ct.actionSelected();
            PageReference pg = ct.searchIncidents();
            System.assertEquals(null, pg);
            System.assertEquals(incidentReports[0].Id, ct.report.Id);
            System.assertEquals(incidentReports[0].RecordTypeId, ct.report.RecordTypeId);
            System.assertEquals(false, ct.noReportsFound);
            System.assertEquals(ct.detailStage, ct.currentStage);
        Test.stopTest();
    }

    /**
    *   @description - Test searching General Loss incidents by Preparers Last Name - returning 1 incident.
    */
    @isTest
    private static void searchGLReportByLastNameNoneFoundTest() {

        Id rc = Schema.SObjectType.Claims__Incident_Report__c.getRecordTypeInfosByName().get('Motor Vehicle').getRecordTypeId();

        List<Claims__Incident_Report__c> incidentReports = TestDataCreator.createIncidentReports(1, rc);
        incidentReports[0].Claims__First_Name__c = 'Test';
        incidentReports[0].Claims__Last_Name__c = 'Preparer';
        insert incidentReports;

        PageReference pageRef = Page.IncidentReportPortal;
        pageRef.getParameters().put('type', Label.Incident_Portal_Path);
        Test.setCurrentPageReference(pageRef);

        Test.startTest();
            IncidentReportPortalController ct = new IncidentReportPortalController();
            // Set variables required for search
            ct.searchStringName = 'SearchPreparer';
            ct.selectedAction = ct.searchStage.Name();
            // Simulate selecting action.
            ct.actionSelected();
            PageReference pg = ct.searchIncidents();
            System.assertEquals(null, pg);
            System.assertEquals(null, ct.report.Id);
            System.assertEquals(null, ct.report.RecordTypeId);
            System.assertEquals(true, ct.noReportsFound);
            System.assertEquals(true, ct.availableReports.isEmpty());
            System.assertEquals(ct.searchStage, ct.currentStage);
        Test.stopTest();
    }

    /**
    *   @description - Test searching General Loss incidents by Preparers Last Name - returning multiple incidents.
    */
    @isTest
    private static void searchGLReportByLastNameMultipleTest() {

        Id rc = Schema.SObjectType.Claims__Incident_Report__c.getRecordTypeInfosByName().get('Facility Damage').getRecordTypeId();

        List<Claims__Incident_Report__c> incidentReports = TestDataCreator.createIncidentReports(2, rc);
        incidentReports[0].Claims__First_Name__c = 'Test';
        incidentReports[0].Claims__Last_Name__c = 'Preparer';
        incidentReports[1].Claims__First_Name__c = 'Test';
        incidentReports[1].Claims__Last_Name__c = 'Preparer';
        insert incidentReports;

        PageReference pageRef = Page.IncidentReportPortal;
        pageRef.getParameters().put('type', Label.Incident_Portal_Path);
        Test.setCurrentPageReference(pageRef);

        Test.startTest();
            IncidentReportPortalController ct = new IncidentReportPortalController();
            // Set variables required for search
            ct.searchStringName = 'Preparer';
            ct.selectedAction = ct.searchStage.Name();
            // Simulate selecting action.
            ct.actionSelected();
            PageReference pg = ct.searchIncidents();
            System.assertEquals(null, pg);
            System.assertEquals(null, ct.report.Id);
            System.assertEquals(2, ct.availableReports.size());
            System.assertEquals(false, ct.noReportsFound);
            System.assertEquals(ct.reportListStage, ct.currentStage);
        Test.stopTest();
    }

    /**
    *   @description - Test searching General Loss incidents by Preparers Last Name with apostrophe - returning 1 incident.
    */
    @isTest
    private static void searchGLReportByLastNameAposTest() {

        Id rc = Schema.SObjectType.Claims__Incident_Report__c.getRecordTypeInfosByName().get('Motor Vehicle').getRecordTypeId();

        List<Claims__Incident_Report__c> incidentReports = TestDataCreator.createIncidentReports(1, rc);
        incidentReports[0].Claims__First_Name__c = 'Test';
        incidentReports[0].Claims__Last_Name__c = 'O\'Prep';        
        insert incidentReports;

        PageReference pageRef = Page.IncidentReportPortal;
        pageRef.getParameters().put('type', Label.Incident_Portal_Path);
        Test.setCurrentPageReference(pageRef);

        Test.startTest();
            IncidentReportPortalController ct = new IncidentReportPortalController();
            // Set variables required for search
            ct.searchStringName = 'O\'Prep';
            ct.selectedAction = ct.searchStage.Name();
            // Simulate selecting action.
            ct.actionSelected();
            PageReference pg = ct.searchIncidents();
            System.assertEquals(null, pg);
            System.assertEquals(incidentReports[0].Id, ct.report.Id);
            System.assertEquals(incidentReports[0].RecordTypeId, ct.report.RecordTypeId);
            System.assertEquals(false, ct.noReportsFound);
            System.assertEquals(ct.detailStage, ct.currentStage);
        Test.stopTest();
    }

    /**
    *   @description - Test searching Workers Compensation incidents by Id - returning 1 incident.
    */
    @isTest
    private static void searchWCReportByIDTest() {

        Id rc = Schema.SObjectType.Claims__Incident_Report__c.getRecordTypeInfosByName().get('Workers Compensation').getRecordTypeId();

        List<Claims__Incident_Report__c> incidentReports = TestDataCreator.createIncidentReports(1, rc);
        insert incidentReports;
        Claims__Incident_Report__c icInserted = [SELECT Id, Name FROM Claims__Incident_Report__c WHERE Id =:incidentReports[0].Id LIMIT 1];

        PageReference pageRef = Page.IncidentReportPortal;
        pageRef.getParameters().put('type', Label.Supervisor_Portal_Path);
        Test.setCurrentPageReference(pageRef);

        Test.startTest();
            IncidentReportPortalController ct = new IncidentReportPortalController();
            // Set variables required for search
            ct.searchStringId = icInserted.Name;
            ct.selectedAction = ct.searchStage.Name();
            // Simulate selecting action.
            ct.actionSelected();
            PageReference pg = ct.searchIncidents();
            System.assertEquals(null, pg);
            System.assertEquals(incidentReports[0].Id, ct.report.Id);
            System.assertEquals(incidentReports[0].RecordTypeId, ct.report.RecordTypeId);
            System.assertEquals(false, ct.noReportsFound);
            System.assertEquals(ct.detailStage, ct.currentStage);
        Test.stopTest();
    }

    /**
    *   @description - Test searching Workers Compensation incidents by Preparers Last Name - returning 1 incident.
    */
    @isTest
    private static void searchWCReportByNameTest() {

        Id rc = Schema.SObjectType.Claims__Incident_Report__c.getRecordTypeInfosByName().get('Workers Compensation').getRecordTypeId();

        List<Claims__Incident_Report__c> incidentReports = TestDataCreator.createIncidentReports(1, rc);
        incidentReports[0].Claims__First_Name__c = 'Test';
        incidentReports[0].Claims__Last_Name__c = 'Preparer';
        insert incidentReports;

        PageReference pageRef = Page.IncidentReportPortal;
        pageRef.getParameters().put('type', Label.Supervisor_Portal_Path);
        Test.setCurrentPageReference(pageRef);

        Test.startTest();
            IncidentReportPortalController ct = new IncidentReportPortalController();
            // Set variables required for search
            ct.searchStringName = 'Preparer';
            ct.selectedAction = ct.searchStage.Name();
            // Simulate selecting action.
            ct.actionSelected();
            PageReference pg = ct.searchIncidents();
            System.assertEquals(null, pg);
            System.assertEquals(incidentReports[0].Id, ct.report.Id);
            System.assertEquals(incidentReports[0].RecordTypeId, ct.report.RecordTypeId);
            System.assertEquals(false, ct.noReportsFound);
            System.assertEquals(ct.detailStage, ct.currentStage);
        Test.stopTest();
    }

    /**
    *   @description - Test searching Workers Compensation incidents by Preparers Last Name with apostrophe - returning 1 incident.
    */
    @isTest
    private static void searchWCReportByNameAposTest() {

        Id rc = Schema.SObjectType.Claims__Incident_Report__c.getRecordTypeInfosByName().get('Workers Compensation').getRecordTypeId();

        List<Claims__Incident_Report__c> incidentReports = TestDataCreator.createIncidentReports(1, rc);
        incidentReports[0].Claims__First_Name__c = 'Test';
        incidentReports[0].Claims__Last_Name__c = 'O\'Prep';
        insert incidentReports;

        PageReference pageRef = Page.IncidentReportPortal;
        pageRef.getParameters().put('type', Label.Supervisor_Portal_Path);
        Test.setCurrentPageReference(pageRef);

        Test.startTest();
            IncidentReportPortalController ct = new IncidentReportPortalController();
            // Set variables required for search
            ct.searchStringName = 'O\'Prep';
            ct.selectedAction = ct.searchStage.Name();
            // Simulate selecting action.
            ct.actionSelected();
            PageReference pg = ct.searchIncidents();
            System.assertEquals(null, pg);
            System.assertEquals(incidentReports[0].Id, ct.report.Id);
            System.assertEquals(incidentReports[0].RecordTypeId, ct.report.RecordTypeId);
            System.assertEquals(false, ct.noReportsFound);
            System.assertEquals(ct.detailStage, ct.currentStage);
        Test.stopTest();
    }

    /**
    *   @description - Test searching Workers Compensation incidents by Preparers Last Name - returning multiple incidents.
    */
    @isTest
    private static void searchWCReportByLastNameMultipleTest() {

        Id rc = Schema.SObjectType.Claims__Incident_Report__c.getRecordTypeInfosByName().get('Workers Compensation').getRecordTypeId();

        List<Claims__Incident_Report__c> incidentReports = TestDataCreator.createIncidentReports(2, rc);
        incidentReports[0].Claims__First_Name__c = 'Test';
        incidentReports[0].Claims__Last_Name__c = 'Preparer';
        incidentReports[1].Claims__First_Name__c = 'Test';
        incidentReports[1].Claims__Last_Name__c = 'Preparer';
        insert incidentReports;

        PageReference pageRef = Page.IncidentReportPortal;
        pageRef.getParameters().put('type', Label.Supervisor_Portal_Path);
        Test.setCurrentPageReference(pageRef);

        Test.startTest();
            IncidentReportPortalController ct = new IncidentReportPortalController();
            // Set variables required for search
            ct.searchStringName = 'Preparer';
            ct.selectedAction = ct.searchStage.Name();
            // Simulate selecting action.
            ct.actionSelected();
            PageReference pg = ct.searchIncidents();
            System.assertEquals(null, pg);
            System.assertEquals(null, ct.report.Id);
            System.assertEquals(2, ct.availableReports.size());
            System.assertEquals(false, ct.noReportsFound);
            System.assertEquals(ct.reportListStage, ct.currentStage);            
        Test.stopTest();
    }

    /**
    *   @description - Test process of creating new incident report and saving as In Progress.
    */
    @isTest static void saveInProgressWCTest() {

        Id rc = Schema.SObjectType.Claims__Incident_Report__c.getRecordTypeInfosByName().get('Workers Compensation').getRecordTypeId();

        PageReference pageRef = Page.IncidentReportPortal;
        pageRef.getParameters().put('type', Label.Incident_Portal_Path);
        Test.setCurrentPageReference(pageRef);

        Test.startTest();
            IncidentReportPortalController ct = new IncidentReportPortalController();
            ct.selectedType = rc;
            ct.setRecordTypeName();
            ct.report.Claims__First_Name__c = 'Test';
            ct.report.Claims__Last_Name__c = 'Preparer';
            ct.report.Claims__Email__c = 'test@test.com';
            ct.report.Claims__IncidentDate__c = Date.today();
            ct.report.Claims__IncidentLocation__c = 'Sheffield';
            ct.report.Claims__Date_Reported__c = System.Today();
            PageReference rt = ct.saveWithoutSubmission();
            system.assertEquals(null, rt);
            system.assertEquals(ct.attachStage, ct.currentStage);
            List<Claims__Incident_Report__c> incidents = [SELECT Id, In_Progress_Report__c, RecordTypeId, Claims__First_Name__c,Claims__Last_Name__c,Claims__Report_Completed_By__c FROM Claims__Incident_Report__c];
            system.assertEquals(1, incidents.size());
            system.assertEquals(rc, incidents[0].recordTypeId);
            system.assertEquals(true, ct.report.In_Progress_Report__c);                    
            system.assertEquals('Test Preparer', ct.report.Claims__Report_Completed_By__c);
        Test.stopTest();

    }

    /**
    *   @description - Test process of creating new incident report and saving as submitted.
    */
    @isTest static void saveSubmittedWCTest() {

        Id rc = Schema.SObjectType.Claims__Incident_Report__c.getRecordTypeInfosByName().get('Workers Compensation').getRecordTypeId();

        PageReference pageRef = Page.IncidentReportPortal;
        pageRef.getParameters().put('type', Label.Incident_Portal_Path);
        Test.setCurrentPageReference(pageRef);

        Test.startTest();
            IncidentReportPortalController ct = new IncidentReportPortalController();
            ct.selectedType = rc;
            ct.setRecordTypeName();
            ct.report.Claims__First_Name__c = 'Test';
            ct.report.Claims__Last_Name__c = 'Preparer';
            ct.report.Claims__Email__c = 'test@test.com';
            ct.report.Claims__IncidentDate__c = Date.today();
            ct.report.Claims__IncidentLocation__c = 'Sheffield';
            ct.report.Claims__Date_Reported__c = System.Today();
            PageReference rt = ct.save();
            system.assertEquals(null, rt);
            system.assertEquals(ct.attachStage, ct.currentStage);
            List<Claims__Incident_Report__c> incidents = [SELECT Id, In_Progress_Report__c, RecordTypeId, Claims__First_Name__c,Claims__Last_Name__c,Claims__Report_Completed_By__c FROM Claims__Incident_Report__c];
            system.assertEquals(1, incidents.size());
            system.assertEquals(rc, incidents[0].recordTypeId);
            system.assertEquals(false, ct.report.In_Progress_Report__c);
            system.assertEquals(ct.report.Claims__Report_Completed_By__c, 'Test Preparer');
            
        Test.stopTest();

    }

    /**
    *   @description - Test process of creating new incident report and saving as In Progress.
    */
    @isTest static void saveInProgressGLTest() {

        Id rc = Schema.SObjectType.Claims__Incident_Report__c.getRecordTypeInfosByName().get('Property Damage').getRecordTypeId();

        PageReference pageRef = Page.IncidentReportPortal;
        pageRef.getParameters().put('type', Label.Incident_Portal_Path);
        Test.setCurrentPageReference(pageRef);

        Test.startTest();
            IncidentReportPortalController ct = new IncidentReportPortalController();
            ct.selectedType = rc;
            ct.setRecordTypeName();
            ct.report.Claims__First_Name__c = 'Test';
            ct.report.Claims__Last_Name__c = 'Preparer';
            ct.report.Claims__Email__c = 'test@test.com';
            ct.report.Claims__IncidentDate__c = Date.today();
            ct.report.Claims__IncidentLocation__c = 'Sheffield';
            ct.report.Claims__Date_Reported__c = System.Today();
            PageReference rt = ct.saveWithoutSubmission();
            system.assertEquals(null, rt);
            system.assertEquals(ct.attachStage, ct.currentStage);
            List<Claims__Incident_Report__c> incidents = [SELECT Id, In_Progress_Report__c, RecordTypeId, Claims__First_Name__c,Claims__Last_Name__c,Claims__Report_Completed_By__c FROM Claims__Incident_Report__c];
            system.assertEquals(1, incidents.size());
            system.assertEquals(rc, incidents[0].recordTypeId);
            system.assertEquals(true, ct.report.In_Progress_Report__c);
            system.assertEquals('Test', ct.report.Claims__First_Name__c);
            system.assertEquals('Preparer', ct.report.Claims__Last_Name__c);
            system.assertEquals('Test Preparer', ct.report.Claims__Report_Completed_By__c);

        Test.stopTest();

    }

    /**
    *   @description - Test process of creating new incident report and saving as submitted.
    */
    @isTest static void saveSubmittedGLTest() {

        Id rc = Schema.SObjectType.Claims__Incident_Report__c.getRecordTypeInfosByName().get('Property Damage').getRecordTypeId();

        PageReference pageRef = Page.IncidentReportPortal;
        pageRef.getParameters().put('type', Label.Incident_Portal_Path);
        Test.setCurrentPageReference(pageRef);

        Test.startTest();
            IncidentReportPortalController ct = new IncidentReportPortalController();
            ct.selectedType = rc;
            ct.setRecordTypeName();
            ct.report.Claims__First_Name__c = 'Test';
            ct.report.Claims__Last_Name__c = 'Preparer';
            ct.report.Claims__Email__c = 'test@test.com';
            ct.report.Claims__IncidentDate__c = Date.today();
            ct.report.Claims__IncidentLocation__c = 'Sheffield';
            ct.report.Claims__Date_Reported__c = System.Today();
            PageReference rt = ct.save();
            system.assertEquals(null, rt);
            system.assertEquals(ct.attachStage, ct.currentStage);
            List<Claims__Incident_Report__c> incidents = [SELECT Id, In_Progress_Report__c, RecordTypeId, Claims__First_Name__c,Claims__Last_Name__c,Claims__Report_Completed_By__c FROM Claims__Incident_Report__c];
            system.assertEquals(1, incidents.size());
            system.assertEquals(rc, incidents[0].recordTypeId);
            system.assertEquals(false, ct.report.In_Progress_Report__c);
            system.assertEquals('Test', ct.report.Claims__First_Name__c);
            system.assertEquals('Preparer', ct.report.Claims__Last_Name__c);
            system.assertEquals('Test Preparer', ct.report.Claims__Report_Completed_By__c);
        Test.stopTest();

    }

    /**
    *   @description Test attaching file
    */
    @isTest 
    private static void TestAttachNewFile()
    {

        Id rc = Schema.SObjectType.Claims__Incident_Report__c.getRecordTypeInfosByName().get('Property Damage').getRecordTypeId();

        PageReference pageRef = Page.IncidentReportPortal;
        pageRef.getParameters().put('type', Label.Incident_Portal_Path);
        Test.setCurrentPageReference(pageRef);

        Test.startTest();

            IncidentReportPortalController ct = new IncidentReportPortalController();
            ct.selectedType = rc;
            ct.setRecordTypeName();
            ct.report.Claims__First_Name__c = 'Test';
            ct.report.Claims__Last_Name__c = 'Preparer';
            ct.report.Claims__Email__c = 'test@test.com';
            ct.report.Claims__IncidentDate__c = Date.today();
            ct.report.Claims__IncidentLocation__c = 'Sheffield';
            ct.report.Claims__Date_Reported__c = System.Today();
            PageReference rt = ct.save();

            System.assert(ct.attachments.size() == 0);

            ct.attach.Name = 'Test';
            ct.attach.Body = Blob.valueOf('Test String');

            ct.saveAttachment();

            System.assert(ct.attachments.size() == 1);

        Test.stopTest();
    }

    /**
    *   @description - Test process of creating new incident report, saving as In Progress and then submitting
    */
    @isTest static void saveInProgressGLSubmittedTest() {

        Id rc = Schema.SObjectType.Claims__Incident_Report__c.getRecordTypeInfosByName().get('Property Damage').getRecordTypeId();

        PageReference pageRef = Page.IncidentReportPortal;
        pageRef.getParameters().put('type', Label.Incident_Portal_Path);
        Test.setCurrentPageReference(pageRef);

        Test.startTest();
            IncidentReportPortalController ct = new IncidentReportPortalController();
            ct.selectedType = rc;
            ct.setRecordTypeName();
            ct.report.Claims__First_Name__c = 'Test';
            ct.report.Claims__Last_Name__c = 'Preparer';
            ct.report.Claims__Email__c = 'test@test.com';
            ct.report.Claims__IncidentDate__c = Date.today();
            ct.report.Claims__IncidentLocation__c = 'Sheffield';
            ct.report.Claims__Date_Reported__c = System.Today();
            PageReference rt = ct.saveWithoutSubmission();
            system.assertEquals(null, rt);
            system.assertEquals(ct.attachStage, ct.currentStage);
            List<Claims__Incident_Report__c> incidents = [SELECT Id, In_Progress_Report__c FROM Claims__Incident_Report__c];
            system.assertEquals(true, ct.report.In_Progress_Report__c);

            rt = ct.submitReport();
            system.assertEquals(null, rt);
            incidents = [SELECT Id, In_Progress_Report__c FROM Claims__Incident_Report__c];
            system.assertEquals(false, ct.report.In_Progress_Report__c);
            system.assertEquals(ct.thanksStage, ct.currentStage);


        Test.stopTest();

    }

    /**
    *   @description - Test process of creating new incident report, saving as In Progress and then saving without submitting again.
    */
    @isTest static void saveInProgressGLNotSubmittedTest() {

        Id rc = Schema.SObjectType.Claims__Incident_Report__c.getRecordTypeInfosByName().get('Property Damage').getRecordTypeId();

        PageReference pageRef = Page.IncidentReportPortal;
        pageRef.getParameters().put('type', Label.Incident_Portal_Path);
        Test.setCurrentPageReference(pageRef);

        Test.startTest();
            IncidentReportPortalController ct = new IncidentReportPortalController();
            ct.selectedType = rc;
            ct.setRecordTypeName();
            ct.report.Claims__Email__c = 'test@test.com';
            ct.report.Claims__First_Name__c = 'Test';
            ct.report.Claims__Last_Name__c = 'Preparer';
            ct.report.Claims__IncidentDate__c = Date.today();
            ct.report.Claims__IncidentLocation__c = 'Sheffield';
            ct.report.Claims__Date_Reported__c = System.Today();
            PageReference rt = ct.saveWithoutSubmission();
            system.assertEquals(null, rt);
            system.assertEquals(ct.attachStage, ct.currentStage);
            List<Claims__Incident_Report__c> incidents = [SELECT Id, In_Progress_Report__c FROM Claims__Incident_Report__c];
            system.assertEquals(true, ct.report.In_Progress_Report__c);

            rt = ct.saveWithoutSubmitReport();
            system.assertEquals(null, rt);
            incidents = [SELECT Id, In_Progress_Report__c FROM Claims__Incident_Report__c];
            system.assertEquals(true, ct.report.In_Progress_Report__c);
            system.assertEquals(ct.thanksStage, ct.currentStage);
        Test.stopTest();
    }

    /**
    *   @description  Test standard controller
    */
    @isTest
    private static void standardControllerTest(){

        Id rc = Schema.SObjectType.Claims__Incident_Report__c.getRecordTypeInfosByName().get('Bodily Injury').getRecordTypeId();

        List<Claims__Incident_Report__c> incidentReports = TestDataCreator.createIncidentReports(1, rc);
        insert incidentReports;

        Test.startTest();
            ApexPages.standardController std = new ApexPages.standardController(incidentReports[0]);
            IncidentReportPortalController ct = new IncidentReportPortalController(std);
            system.assertEquals(rc, ct.report.recordTypeId);
            system.assertEquals('Bodily Injury', ct.recordTypeName);
        Test.stopTest();
    }

    /**
    *   @description    Test 'Back' link
    */ 
    @isTest
    private static void backToActionTest() {

        IncidentReportPortalController ct = new IncidentReportPortalController();

        Test.startTest();
            PageReference rt = ct.backToAction();
            System.assertEquals(null, rt);
            System.assertEquals(ct.actionStage, ct.currentStage);
            System.assertEquals(null, ct.recordTypeName);
            System.assertEquals(null, ct.report.id);
            System.assertEquals('', ct.searchStringID);
            System.assertEquals('', ct.searchStringName);
            System.assertEquals(null, ct.selectedAction);
            System.assertEquals(false, ct.noReportsFound);
        Test.stopTest();
    }

    /**
    *   @description - Test selecting incident from searched list
    */
    @isTest
    private static void incidentSelectedTest() {

        Id rc = Schema.SObjectType.Claims__Incident_Report__c.getRecordTypeInfosByName().get('Theft').getRecordTypeId();

        List<Claims__Incident_Report__c> incidentReports = TestDataCreator.createIncidentReports(3, rc);
        incidentReports[0].Claims__First_Name__c = 'Test';
        incidentReports[0].Claims__Last_Name__c = 'Preparer';
        incidentReports[1].Claims__First_Name__c = 'Test';
        incidentReports[1].Claims__Last_Name__c = 'Preparer';
        incidentReports[2].Claims__First_Name__c = 'Test';        
        incidentReports[2].Claims__Last_Name__c = 'Preparer';
        insert incidentReports;

        PageReference pageRef = Page.IncidentReportPortal;
        pageRef.getParameters().put('type', Label.Incident_Portal_Path);
        Test.setCurrentPageReference(pageRef);

        Test.startTest();
            IncidentReportPortalController ct = new IncidentReportPortalController();
            // Set variables required for search
            ct.searchStringName = 'Preparer';
            ct.selectedAction = ct.searchStage.Name();
            // Simulate selecting action.
            ct.actionSelected();
            PageReference rt = ct.searchIncidents();
            System.assertEquals(null, rt);
            System.assertEquals(null, ct.report.Id);
            System.assertEquals(3, ct.availableReports.size());
            System.assertEquals(ct.reportListStage, ct.currentStage);
            // Simulate selecting report from list.
            ct.selectedReportId = incidentReports[1].Id;
            rt = ct.incidentSelected();
            system.assertEquals(null, rt);
            system.assertEquals(incidentReports[1].Id, ct.report.Id);
            system.assertEquals('Theft', ct.recordTypeName);
            system.assertEquals(ct.detailStage, ct.currentStage);

        Test.stopTest();
    }

    /**
    *   @description - Test process of creating new Workers Compensation incident report and saving as In Progress. 
    *                  Search for record by preparer last name, save as submitted and then search for record again.
    */
    @isTest static void saveInProgress_Search_SaveSubmitted_Search_WCTest() {

        Id rc = Schema.SObjectType.Claims__Incident_Report__c.getRecordTypeInfosByName().get('Workers Compensation').getRecordTypeId();

        PageReference pageRef = Page.IncidentReportPortal;
        pageRef.getParameters().put('type', Label.Supervisor_Portal_Path);
        Test.setCurrentPageReference(pageRef);

        Test.startTest();
            IncidentReportPortalController ct = new IncidentReportPortalController();
            ct.selectedType = rc;
            ct.setRecordTypeName();
            ct.report.Claims__First_Name__c = 'Test';
            ct.report.Claims__Last_Name__c = 'Preparer';
            ct.report.Claims__Email__c = 'test@test.com';
            ct.report.Claims__IncidentDate__c = Date.today();
            ct.report.Claims__IncidentLocation__c = 'Sheffield';
            ct.report.Claims__Date_Reported__c = System.Today();
            // Save as 'In Progress'
            PageReference rtInProgress = ct.saveWithoutSubmission();
            system.assertEquals(null, rtInProgress);
            system.assertEquals(ct.attachStage, ct.currentStage);
            List<Claims__Incident_Report__c> incidents = [SELECT Id, In_Progress_Report__c, RecordTypeId, Claims__First_Name__c,Claims__Last_Name__c,Claims__Report_Completed_By__c FROM Claims__Incident_Report__c];
            system.assertEquals(1, incidents.size());
            system.assertEquals(rc, incidents[0].recordTypeId);
            system.assertEquals(true, ct.report.In_Progress_Report__c);
            system.assertEquals('Test Preparer', incidents[0].Claims__Report_Completed_By__c);

            // Search for 'In Progress' incident report - should be found
            ct = new IncidentReportPortalController();
            ct.searchStringName = 'Preparer';
            ct.selectedAction = ct.searchStage.Name();
            ct.actionSelected();
            PageReference pgSearch = ct.searchIncidents();
            System.assertEquals(null, pgSearch);
            System.assertEquals(incidents[0].Id, ct.report.Id);
            System.assertEquals(incidents[0].RecordTypeId, ct.report.RecordTypeId);
            System.assertEquals(false, ct.noReportsFound);
            System.assertEquals(ct.detailStage, ct.currentStage);

            // Save submitted (NOT in progress).
            PageReference rtSubmitted = ct.save();
            system.assertEquals(null, rtSubmitted);
            system.assertEquals(ct.attachStage, ct.currentStage);
            incidents = [SELECT Id, In_Progress_Report__c, RecordTypeId, Claims__First_Name__c,Claims__Last_Name__c,Claims__Report_Completed_By__c FROM Claims__Incident_Report__c];
            system.assertEquals(1, incidents.size());
            system.assertEquals(rc, incidents[0].recordTypeId);
            system.assertEquals(false, ct.report.In_Progress_Report__c);
            system.assertEquals(incidents[0].Claims__Report_Completed_By__c, 'Test Preparer');

            // Search for submitted incident report - should NOT be found
            ct = new IncidentReportPortalController();
            ct.searchStringName = 'Preparer';
            ct.selectedAction = ct.searchStage.Name();
            ct.actionSelected();
            pgSearch = ct.searchIncidents();
            System.assertEquals(null, pgSearch);
            System.assertEquals(null, ct.report.Id);
            System.assertEquals(rc, ct.report.RecordTypeId);
            System.assertEquals(true, ct.noReportsFound);
            System.assertEquals(ct.searchStage, ct.currentStage);

        Test.stopTest();
    }

    /**
    *   @description - Test process of creating new General Loss incident report and saving as In Progress. 
    *                  Search for record  by preparer last name, save as submitted and then search for record again.
    */
    @isTest static void saveInProgress_Search_SaveSubmitted_Search_GLTest() {

        Id rc = Schema.SObjectType.Claims__Incident_Report__c.getRecordTypeInfosByName().get('Theft').getRecordTypeId();

        PageReference pageRef = Page.IncidentReportPortal;
        pageRef.getParameters().put('type', Label.Incident_Portal_Path);
        Test.setCurrentPageReference(pageRef);

        Test.startTest();
            IncidentReportPortalController ct = new IncidentReportPortalController();
            ct.selectedType = rc;
            ct.setRecordTypeName();
            ct.report.Claims__First_Name__c = 'Test';
            ct.report.Claims__Last_Name__c = 'Preparer';
            ct.report.Claims__Email__c = 'test@test.com';
            ct.report.Claims__IncidentDate__c = Date.today();
            ct.report.Claims__IncidentLocation__c = 'Sheffield';
            ct.report.Claims__Date_Reported__c = System.Today();
            // Save as 'In Progress'
            PageReference rtInProgress = ct.saveWithoutSubmission();
            system.assertEquals(null, rtInProgress);
            system.assertEquals(ct.attachStage, ct.currentStage);
            List<Claims__Incident_Report__c> incidents = [SELECT Id, In_Progress_Report__c, RecordTypeId, Claims__First_Name__c,Claims__Last_Name__c,Claims__Report_Completed_By__c FROM Claims__Incident_Report__c];
            system.assertEquals(1, incidents.size());
            system.assertEquals(rc, incidents[0].recordTypeId);
            system.assertEquals(true, ct.report.In_Progress_Report__c);
            system.assertEquals('Test', incidents[0].Claims__First_Name__c);
            system.assertEquals('Preparer', incidents[0].Claims__Last_Name__c);
            system.assertEquals('Test Preparer', incidents[0].Claims__Report_Completed_By__c);

            // Search for 'In Progress' incident report - should be found
            ct = new IncidentReportPortalController();
            ct.searchStringName = 'Preparer';
            ct.selectedAction = ct.searchStage.Name();
            ct.actionSelected();
            PageReference pgSearch = ct.searchIncidents();
            System.assertEquals(null, pgSearch);
            System.assertEquals(incidents[0].Id, ct.report.Id);
            System.assertEquals(incidents[0].RecordTypeId, ct.report.RecordTypeId);
            System.assertEquals(false, ct.noReportsFound);
            System.assertEquals(ct.detailStage, ct.currentStage);

            // Save submitted (NOT in progress).
            PageReference rtSubmitted = ct.save();
            system.assertEquals(null, rtSubmitted);
            system.assertEquals(ct.attachStage, ct.currentStage);
            incidents = [SELECT Id, In_Progress_Report__c, RecordTypeId, Claims__First_Name__c,Claims__Last_Name__c,Claims__Report_Completed_By__c FROM Claims__Incident_Report__c];
            system.assertEquals(1, incidents.size());
            system.assertEquals(rc, incidents[0].recordTypeId);
            system.assertEquals(false, ct.report.In_Progress_Report__c);
            system.assertEquals('Test Preparer', incidents[0].Claims__Report_Completed_By__c);

            // Search for submitted incident report - should NOT be found
            ct = new IncidentReportPortalController();
            ct.searchStringName = 'Preparer';
            ct.selectedAction = ct.searchStage.Name();
            ct.actionSelected();
            pgSearch = ct.searchIncidents();
            System.assertEquals(null, pgSearch);
            System.assertEquals(null, ct.report.Id);
            System.assertEquals(null, ct.report.RecordTypeId);
            System.assertEquals(true, ct.noReportsFound);
            System.assertEquals(ct.searchStage, ct.currentStage);

        Test.stopTest();
    }

    /**
    *   @description - Test process of creating new Workers Compensation incident report and saving as In Progress. 
    *                  Search for record by Id, save as submitted and then search for record again.
    */
    @isTest static void saveInProgress_SearchId_SaveSubmitted_SearchId_WCTest() {

        Id rc = Schema.SObjectType.Claims__Incident_Report__c.getRecordTypeInfosByName().get('Workers Compensation').getRecordTypeId();

        PageReference pageRef = Page.IncidentReportPortal;
        pageRef.getParameters().put('type', Label.Supervisor_Portal_Path);
        Test.setCurrentPageReference(pageRef);

        Test.startTest();
            IncidentReportPortalController ct = new IncidentReportPortalController();
            ct.selectedType = rc;
            ct.setRecordTypeName();
            ct.report.Claims__First_Name__c = 'Test';
            ct.report.Claims__Last_Name__c = 'Preparer';
            ct.report.Claims__Email__c = 'test@test.com';
            ct.report.Claims__IncidentDate__c = Date.today();
            ct.report.Claims__IncidentLocation__c = 'Sheffield';
            ct.report.Claims__Date_Reported__c = System.Today();
            // Save as 'In Progress'
            PageReference rtInProgress = ct.saveWithoutSubmission();
            system.assertEquals(null, rtInProgress);
            system.assertEquals(ct.attachStage, ct.currentStage);
            List<Claims__Incident_Report__c> incidents = [SELECT Id, Name, In_Progress_Report__c, RecordTypeId, Claims__First_Name__c,Claims__Last_Name__c,Claims__Report_Completed_By__c FROM Claims__Incident_Report__c];
            system.assertEquals(1, incidents.size());
            system.assertEquals(rc, incidents[0].recordTypeId);
            system.assertEquals(true, ct.report.In_Progress_Report__c);
            system.assertEquals('Test Preparer', incidents[0].Claims__Report_Completed_By__c);

            // Search for 'In Progress' incident report - should be found
            ct = new IncidentReportPortalController();
            ct.searchStringId = incidents[0].Name;            
            ct.selectedAction = ct.searchStage.Name();
            ct.actionSelected();
            PageReference pgSearch = ct.searchIncidents();
            System.assertEquals(null, pgSearch);
            System.assertEquals(incidents[0].Id, ct.report.Id);
            System.assertEquals(incidents[0].RecordTypeId, ct.report.RecordTypeId);
            System.assertEquals(false, ct.noReportsFound);
            System.assertEquals(ct.detailStage, ct.currentStage);

            // Save submitted (NOT in progress).
            PageReference rtSubmitted = ct.save();
            system.assertEquals(null, rtSubmitted);
            system.assertEquals(ct.attachStage, ct.currentStage);
            incidents = [SELECT Id, Name, In_Progress_Report__c, RecordTypeId, Claims__First_Name__c,Claims__Last_Name__c,Claims__Report_Completed_By__c FROM Claims__Incident_Report__c];
            system.assertEquals(1, incidents.size());
            system.assertEquals(rc, incidents[0].recordTypeId);
            system.assertEquals(false, ct.report.In_Progress_Report__c);
            system.assertEquals('Test Preparer', incidents[0].Claims__Report_Completed_By__c);

            // Search for submitted incident report - should NOT be found
            ct = new IncidentReportPortalController();
            ct.searchStringId = incidents[0].Name;
            ct.selectedAction = ct.searchStage.Name();
            ct.actionSelected();
            pgSearch = ct.searchIncidents();
            System.assertEquals(null, pgSearch);
            System.assertEquals(null, ct.report.Id);
            System.assertEquals(rc, ct.report.RecordTypeId);
            System.assertEquals(true, ct.noReportsFound);
            System.assertEquals(ct.searchStage, ct.currentStage);

        Test.stopTest();
    }

    /**
    *   @description - Test process of creating new General Loss incident report and saving as In Progress. 
    *                  Search for record Id, save as submitted and then search for record again.
    */
    @isTest static void saveInProgress_SearchId_SaveSubmitted_SearchId_GLTest() {

        Id rc = Schema.SObjectType.Claims__Incident_Report__c.getRecordTypeInfosByName().get('Theft').getRecordTypeId();

        PageReference pageRef = Page.IncidentReportPortal;
        pageRef.getParameters().put('type', Label.Incident_Portal_Path);
        Test.setCurrentPageReference(pageRef);

        Test.startTest();
            IncidentReportPortalController ct = new IncidentReportPortalController();
            ct.selectedType = rc;
            ct.setRecordTypeName();
            ct.report.Claims__First_Name__c = 'Test';
            ct.report.Claims__Last_Name__c = 'Preparer';
            ct.report.Claims__Email__c = 'test@test.com';
            ct.report.Claims__IncidentDate__c = Date.today();
            ct.report.Claims__IncidentLocation__c = 'Sheffield';
            ct.report.Claims__Date_Reported__c = System.Today();
            // Save as 'In Progress'
            PageReference rtInProgress = ct.saveWithoutSubmission();
            system.assertEquals(null, rtInProgress);
            system.assertEquals(ct.attachStage, ct.currentStage);
            List<Claims__Incident_Report__c> incidents = [SELECT Id, Name, In_Progress_Report__c, RecordTypeId, Claims__First_Name__c,Claims__Last_Name__c,Claims__Report_Completed_By__c FROM Claims__Incident_Report__c];
            system.assertEquals(1, incidents.size());
            system.assertEquals(rc, incidents[0].recordTypeId);
            system.assertEquals(true, ct.report.In_Progress_Report__c);
            system.assertEquals('Test Preparer', incidents[0].Claims__Report_Completed_By__c);
            
            // Search for 'In Progress' incident report - should be found
            ct = new IncidentReportPortalController();
            ct.searchStringId = incidents[0].Name;
            ct.selectedAction = ct.searchStage.Name();
            ct.actionSelected();
            PageReference pgSearch = ct.searchIncidents();
            System.assertEquals(null, pgSearch);
            System.assertEquals(incidents[0].Id, ct.report.Id);
            System.assertEquals(incidents[0].RecordTypeId, ct.report.RecordTypeId);
            System.assertEquals(false, ct.noReportsFound);
            System.assertEquals(ct.detailStage, ct.currentStage);

            // Save submitted (NOT in progress).
            PageReference rtSubmitted = ct.save();
            system.assertEquals(null, rtSubmitted);
            system.assertEquals(ct.attachStage, ct.currentStage);
            incidents = [SELECT Id, Name, In_Progress_Report__c, RecordTypeId, Claims__First_Name__c,Claims__Last_Name__c,Claims__Report_Completed_By__c FROM Claims__Incident_Report__c];
            system.assertEquals(1, incidents.size());
            system.assertEquals(rc, incidents[0].recordTypeId);
            system.assertEquals(false, ct.report.In_Progress_Report__c);
            system.assertEquals('Test Preparer', incidents[0].Claims__Report_Completed_By__c);

            // Search for submitted incident report - should NOT be found
            ct = new IncidentReportPortalController();
            ct.searchStringId = incidents[0].Name;
            ct.selectedAction = ct.searchStage.Name();
            ct.actionSelected();
            pgSearch = ct.searchIncidents();
            System.assertEquals(null, pgSearch);
            System.assertEquals(null, ct.report.Id);
            System.assertEquals(null, ct.report.RecordTypeId);
            System.assertEquals(true, ct.noReportsFound);
            System.assertEquals(ct.searchStage, ct.currentStage);

        Test.stopTest();
    }
}