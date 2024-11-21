@isTest
public class SingleRelatedListControllerTest {
    @testSetup
    public static void testsetupMethod(){
           Opportunity opp=LC_TestUtils.insertOpportunity();
            GC_Connect2_Show__c show=LC_TestUtils.insertShow(opp.Id,opp.Name);
        
        LC_TestUtils.insertMainEventPersonSetObj();
        LC_TestUtils.insertExhibitPersonSetObj();
        
        CA_Main_Event__c insertMainEvent= new CA_Main_Event__c();
        insertMainEvent.Name_of_Event__c='Test Event';
        insertMainEvent.Event_Acronym__c='TE';
        insert insertMainEvent;
        
        CA_Exhibit__c insertCAExhibit = new CA_Exhibit__c();
        insertCAExhibit.Exhibit_Name__c='Test Exhibit';
        insertCAExhibit.Event__c = insertMainEvent.Id;
        insert insertCAExhibit;
        
        GT_Event__c insertConnectEvent= new GT_Event__c();
        insertConnectEvent.Shipping_City_c__c='testShippingCity';
        insertConnectEvent.Shipping_Zip_Postal_Code_c__c='12345';
        insert insertConnectEvent;
        
        GT_Exhibit__c insertExhibit=new GT_Exhibit__c();
        insertExhibit.GES_Connect_Event__c=insertConnectEvent.Id;
        insertExhibit.Agency_Contact_Name__c='test Agency Contact Name';
        insert insertExhibit;
        GT_Brand__c insertBrand=new GT_Brand__c();
        insertBrand.Exhibit__c=insertExhibit.id;
        insertBrand.Additional_Cost_Description_6__c='test brand of Exhibit';
        insert insertBrand;
        
        GT_Sponsorship__c insertSponsership=new GT_Sponsorship__c();
        insertSponsership.GES_Connect_Event__c=insertConnectEvent.Id;
        insertSponsership.Sponsorship_Name__c='test Sponseship name';
        insert insertSponsership;
        GT_Brand__c insertsponBrand=new GT_Brand__c();
        insertsponBrand.Sponsorship__c=insertSponsership.Id;
        insertsponBrand.Additional_Cost_Description_6__c='test brand for sponsership';
        insert insertsponBrand;
        
        GT_Meeting_Room__c insertMeeting=new GT_Meeting_Room__c();
        insertMeeting.GES_Connect_Event__c=insertConnectEvent.Id;
        insertMeeting.Agency_Name__c='test meetingRoom name';
        insert insertMeeting;
        GT_Brand__c insertMeetingBrand=new GT_Brand__c();
        insertMeetingBrand.Meeting_Room__c=insertMeeting.Id;
        insertMeetingBrand.Additional_Cost_Description_6__c='test brand for Meeting';
        insert insertMeetingBrand;
        
        GT_Speaking_Engagement__c insertSpeaking=new GT_Speaking_Engagement__c();
        insertSpeaking.GES_Connect_Event__c=insertConnectEvent.Id;
        insertSpeaking.Event_Manager__c='test speakingEng name';
        insert insertSpeaking;
        GT_Brand__c insertSpeakingBrand=new GT_Brand__c();
        insertSpeakingBrand.Speaking_Engagement__c=insertSpeaking.Id;
        insertSpeakingBrand.Additional_Cost_Description_6__c='test brand for SpeakingEng';
        insert insertSpeakingBrand;
    }
    
    @isTest public static void testInit(){
        Account acc = new Account(Name = 'test');
        insert acc;
        Contact cnt = new Contact(LastName = 'test', AccountId = acc.Id);
        insert cnt;
        
        Map<String, Object> requestMap = new Map<String, Object>(); 
        requestMap.put(SingleRelatedListController.FIELDS_PARAM, 'Name, Title, Email, Phone');
        requestMap.put(SingleRelatedListController.RELATED_FIELD_API_NAME_PARAM, 'AccountId');
        requestMap.put(SingleRelatedListController.RECORD_ID_PARAM, acc.Id);
        requestMap.put(SingleRelatedListController.NUMBER_OF_RECORDS_PARAM, 1);
        requestMap.put(SingleRelatedListController.SOBJECT_API_NAME_PARAM, 'Contact');
        requestMap.put(SingleRelatedListController.SORTED_BY_PARAM, 'Name');
        requestMap.put(SingleRelatedListController.SORTED_DIRECTION_PARAM, 'ASC');
        
        String jsonData = SingleRelatedListController.initData(JSON.serialize(requestMap));
        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(jsonData);
        List<Object> records = (List<Object>)responseMap.get(SingleRelatedListController.RECORDS_PARAM);
        System.assert(!records.isEmpty());
        String iconName = (String)responseMap.get(SingleRelatedListController.ICON_NAME_PARAM);
        System.assert(String.isNotBlank(iconName));
        SingleRelatedListController.getProfileName();
        GT_Exhibit__c exhibit=[select Id from GT_Exhibit__c where Agency_Contact_Name__c='test Agency Contact Name' limit 1];
        SingleRelatedListController.relatedObjectNameToQuery(exhibit.Id);
        GT_Sponsorship__c GTBRandSpon=[select id from GT_Sponsorship__c where Sponsorship_Name__c='test Sponseship name' limit 1];
        SingleRelatedListController.relatedObjectNameToQuery(GTBRandSpon.Id);
        GT_Meeting_Room__c GTBRandmeeting=[select id from GT_Meeting_Room__c where Agency_Name__c='test meetingRoom name' limit 1];
        SingleRelatedListController.relatedObjectNameToQuery(GTBRandmeeting.Id);
        GT_Speaking_Engagement__c GTBRandspeaking=[select id from GT_Speaking_Engagement__c where Event_Manager__c='test speakingEng name' limit 1];
        SingleRelatedListController.relatedObjectNameToQuery(GTBRandspeaking.Id);
        SingleRelatedListController.deleteRecord(GTBRandspeaking.Id);
        
        GC_Connect2_Show__c sId=[select Id from GC_Connect2_Show__c where Show_Name__c = 'test show' and Job_Number__c = '12345' and Production_Location__c='71' limit 1];
        pharmaTemplateApexController.getShowRelated(sId.Id);
        
        GT_Event__c event=[select Id from GT_Event__c where Shipping_City_c__c='testShippingCity' and Shipping_Zip_Postal_Code_c__c='12345' limit 1];
        pharmaTemplateApexController.cloneRecord(event);
        
        pharmaTemplateApexController.CalendarValuesCongress(event.Id);
        
        Account testAccount = GC_TestUtils.getAccount(1);
        pharmaTemplateApexController.getFacilityRelated(testAccount.Id);

        
    }
    @isTest 
    public static void testGetMainEventId(){
                
        CA_Exhibit__c caExhibit = [SELECT ID,Name,Exhibit_Name__c FROM CA_Exhibit__c WHERE Exhibit_Name__c = 'Test Exhibit'];
        SingleRelatedListController.getPerObjSettings(caExhibit.Id, 'CA_Exhibit__c');
        SingleRelatedListController.getMainEventId('CA_Exhibit__c',caExhibit.Id);
    }
}