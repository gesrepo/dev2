/**
* @author       Thiyagarajan Selvaraj
* @date         23/05/2016
* @description  Method to create test data
**/
public with sharing class TestDataCreator {
    
    /**
    * @author       Thiyagarajan Selvaraj
    * @date         19/05/2016
    * @description  Method to create mapping between incident and claim
    **/
    public static Claims__Mapping__c createMapping(){
        Claims__Mapping__c mappingRecord = new Claims__Mapping__c(Claims__Name__c='Claims__Claim__c',Claims__From_Object__c='Claims__Incident_Report__c',Claims__To_Object__c='Claims__Claim__c',
                                                                    Claims__Field_Mapping__c='[{ "toLabel":"Injury Description", "toFieldType":"string", "toField":"Loss_Description_Long__c", "fromLabel":"Description of Injury", "fromFieldType":"string", "fromField":"Claims__Details_of_All_Any_Injuries__c" }, { "toLabel":"Job Number", "toFieldType":"string", "toField":"Job_Number__c", "fromLabel":"Job Number", "fromFieldType":"string", "fromField":"Job_Number__c" }, { "toLabel":"Police - Address", "toFieldType":"string", "toField":"Police_Fire_EMT_Address__c", "fromLabel":"Police - Address", "fromFieldType":"string", "fromField":"Address_poilice_fire__c" }, { "toLabel":"Prop Dam - Address", "toFieldType":"string", "toField":"Damaged_Property_Address__c", "fromLabel":"Prop Dam- Address", "fromFieldType":"string", "fromField":"Address_property_damage__c" }, { "toLabel":"Body Part & Nature of Injury", "toFieldType":"string", "toField":"Body_Part_Nature_of_Injury__c", "fromLabel":"Body Part & Nature of Injury", "fromFieldType":"string", "fromField":"Body_Part_Nature_of_Injury__c" }, { "toLabel":"Booth#", "toFieldType":"string", "toField":"Booth__c", "fromLabel":"Booth#", "fromFieldType":"string", "fromField":"Booth__c" }, { "toLabel":"Prop Dam - Booth Number", "toFieldType":"string", "toField":"Damaged_Property_Booth_Number__c", "fromLabel":"Prop Dam - Booth Number", "fromFieldType":"string", "fromField":"Booth_Number_property_damage__c" }, { "toLabel":"For what", "toFieldType":"string", "toField":"Citations_Issued_For_what__c", "fromLabel":"For What", "fromFieldType":"string", "fromField":"Citations_Issued_For_what__c" }]');
        insert mappingRecord;
        return mappingRecord;
    }
	

    /**
    * @author       Thiyagarajan Selvaraj
    * @date         19/05/2016
    * @description  Method to create incident reports
    **/
    public static List<Claims__Incident_Report__c> createIncidentReports(Integer noOfIncidentReports){
        List<Claims__Incident_Report__c> incidentReportList = new List<Claims__Incident_Report__c>();

        for(Integer i=0;i<noOfIncidentReports;i++){
            incidentReportList.add(new Claims__Incident_Report__c(Claims__Date_Reported__c=System.today(),Claims__Email__c='test@xactium.com',Claims__First_Name__c='Test',Claims__IncidentDate__c=System.today(),Claims__IncidentLocation__c='Sheffield',Claims__Last_Name__c='Hardy',Claims__Report_Completed_By__c='Jeff',Claims__Details_of_All_Any_Injuries__c='Test-'+i,Job_Number__c='Developer',Address_poilice_fire__c='12,weststreet',Address_property_damage__c='24,weststreet',Body_Part_Nature_of_Injury__c='test',Booth__c='sheffield',Citations_Issued_For_what__c='test1',Type_of_Loss_Final__c='Bodily Injury'));
        }
        insert incidentReportList;
        return incidentReportList;
    }

    /**
    * @author       Dean Gelder
    * @date         23/01/2019
    * @description  Method to create incident reports
    **/
    public static List<Claims__Incident_Report__c> createIncidentReports(Integer noOfIncidentReports, Id recordTypeId){
        List<Claims__Incident_Report__c> incidentReportList = new List<Claims__Incident_Report__c>();

        for(Integer i=0;i<noOfIncidentReports;i++){
            incidentReportList.add(new Claims__Incident_Report__c(RecordTypeId=recordTypeId, In_Progress_Report__c=true, Claims__Date_Reported__c=System.today(),Claims__Email__c='test@xactium.com',Claims__First_Name__c='Test',Claims__IncidentDate__c=System.today(),Claims__IncidentLocation__c='Sheffield',Claims__Last_Name__c='Hardy',Claims__Report_Completed_By__c='Jeff',Claims__Details_of_All_Any_Injuries__c='Test-'+i,Job_Number__c='Developer',Address_poilice_fire__c='12,weststreet',Address_property_damage__c='24,weststreet',Body_Part_Nature_of_Injury__c='test',Booth__c='sheffield',Citations_Issued_For_what__c='test1',Type_of_Loss_Final__c='Bodily Injury'));
        }
        // insert incidentReportList;
        return incidentReportList;
    }

    /**
    * @author       Thiyagarajan Selvaraj
    * @date         19/05/2016
    * @description  Method to create account records
    **/
    public static List<Account> createAccounts(Integer noOfAccounts){
        List<Account> accountsList = new List<Account>();

        for(Integer i=0;i<noOfAccounts;i++){
            accountsList.add(new Account(Name='Test Account-'+i,BillingStreet='40,weststreet',BillingState='South Yorkshire',BillingPostalCode='S8 0SU',BillingCountry='GB',BillingCity='Sheffield'));
        }
        insert accountsList;
        return accountsList;
    }

    /**
    * @author       Thiyagarajan Selvaraj
    * @date         23/05/2016
    * @description  Method to create client records
    **/
    public static List<Claims__Client__c> createClients(List<Account> accountsList){
        List<Claims__Client__c> clientsList = new List<Claims__Client__c>();

        for(Account account : accountsList){
            clientsList.add(new Claims__Client__c(Claims__Account__c=account.Id));
        }
        insert clientsList;
        return clientsList;
    }

    /**
    * @author       Thiyagarajan Selvaraj
    * @date         23/05/2016
    * @description  Method to create policy types
    **/
    public static List<Claims__Policy_Type__c> createPolicyTypes(Integer noOfPolicyTypes){
        List<Claims__Policy_Type__c> policyTypesList = new List<Claims__Policy_Type__c>();

        for(Integer i=0;i<noOfPolicyTypes;i++){
            policyTypesList.add(new Claims__Policy_Type__c(Name='Test Policy Type - '+i));
        }
        insert policyTypesList;
        return policyTypesList;
    }

    /**
    * @author       Thiyagarajan Selvaraj
    * @date         23/05/2016
    * @description  Method to create policy records
    **/
    public static List<Claims__Policy__c> createPolicies(List<Claims__Client__c> clientsList, List<Claims__Policy_Type__c> policyTypesList){
        List<Claims__Policy__c> policiesList = new List<Claims__Policy__c>();

        for(Claims__Client__c client : clientsList){
            for(Claims__Policy_Type__c policyType : policyTypesList){
                policiesList.add(new Claims__Policy__c(Name=client.Name,Claims__Client__c=client.Id,Claims__Policy_Type_Lookup__c=policyType.Id,Claims__Policy_Year__c='2016'));
            }
        }
        insert policiesList;
        return policiesList;
    }

    /**
    * @author       Thiyagarajan Selvaraj
    * @date         23/05/2016
    * @description  Method to create cover type setup records
    **/
    public static List<Claims__Cover_Type_Setup__c> createCoverTypeSetUpList(List<Claims__Policy_Type__c> policyTypesList){
        List<Claims__Cover_Type_Setup__c> coverTypeSetUpList = new List<Claims__Cover_Type_Setup__c>();

        for(Claims__Policy_Type__c policyType : policyTypesList){
            coverTypeSetUpList.add(new Claims__Cover_Type_Setup__c(Name=policyType.Name,Claims__Policy_Type__c=policyType.Id));
        }
        insert coverTypeSetUpList;
        return coverTypeSetUpList;
    }

    /**
    * @author       Thiyagarajan Selvaraj
    * @date         23/05/2016
    * @description  Method to create cover type records
    **/
    public static List<Claims__Policy_Detail__c> createCoverTypesList(List<Claims__Policy__c> policiesList, List<Claims__Cover_Type_Setup__c> coverTypeSetUpList){
        List<Claims__Policy_Detail__c> coverTypesList = new List<Claims__Policy_Detail__c>();

        for(Claims__Policy__c policy : policiesList){
            for(Claims__Cover_Type_Setup__c coverType : coverTypeSetUpList){
                coverTypesList.add(new Claims__Policy_Detail__c(Claims__Policy__c=policy.Id,Claims__Cover_Type_Lookup__c=coverType.Id,Claims__Inception_Date__c=System.now(),Claims__Is_Active__c=true));
            }
        }
        insert coverTypesList;
        return coverTypesList;
    }

    /**
    * @author       Thiyagarajan Selvaraj
    * @date         23/05/2016
    * @description  Method to create claim records
    **/
    public static List<Claims__Claim__c> createClaims(Integer noOfClaims, Id clientId, Id policyDetailId, Id incidentReportId){
        List<Claims__Claim__c> claimsList = new List<Claims__Claim__c>();

        for(Integer i=0;i<noOfClaims;i++){
            claimsList.add(new Claims__Claim__c(Claims__Employee_Name__c='Test',Claims__Client__c=clientId,Claims__Policy_Detail__c=policyDetailId,Claims__Incident_Report__c=incidentReportId));
        }
        insert claimsList;
        return claimsList;
    }

     /**
    * @author       Thiyagarajan Selvaraj
    * @date         08/03/2018
    * @description  Method to create days away
    **/
    public static List<Days_Away__c> createDaysAway(Integer noOfDaysAway, Set<Id> claimIds){
        List<Days_Away__c> daysAwayList = new List<Days_Away__c>();

        for(Id claimId : claimIds){
            for(Integer i=0;i<noOfDaysAway;i++){
                daysAwayList.add(new Days_Away__c(Claim__c=claimId,Start_of_Time_Tracking__c=System.today().addDays(-7)));
            }
        }
        insert daysAwayList;
        return daysAwayList;
    }
}