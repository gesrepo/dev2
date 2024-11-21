@isTest(SeeAllData=true)
public class GT_EventTriggerHandlerTest {
    
    Static TestMethod void createUserMethod() {
        
        User u1 = [SELECT Id,Name FROM User WHERE Id='0051W000004GnhR'];//0051W000004GnhR
        System.runAs(u1){ 
            GT_Wrike_Integration_Setting__c newSettings = new GT_Wrike_Integration_Setting__c();
            newSettings.Name='Test Sig Sauer';
            newSettings.Authorization_Key__c='Authorization';
            newSettings.Event_Record_Type_ID__c='0121W000000YepBQAS';
            newSettings.Permanent_Access_Token__c='1234557540934yi7yuout89yonjduiy';
            newSettings.Project_Template_ID__c='IEABRDPJI4AQOJ3I';
            newSettings.Wrike_Space_Id__c='IEABRDPJI4AQOJ3W';
            newSettings.Folder_Map__c='{"folderMap":{"2020":"IEAB4P3RI4LUZMZV","2018":"IEAB4P3RI4LUZOED"}}';
            insert newSettings;
            GT_Brand__c brand1 = new GT_Brand__c();
            
            list<String> gesEventID = new list<String>();
            list<GT_Event__c> gesEvent = new list<GT_Event__c>();
            GT_Exhibit__c exhibit = new GT_Exhibit__c();
            GT_Sponsorship__c sponsorship = new GT_Sponsorship__c();
            GT_Meeting_Room__c meetingRoom = new GT_Meeting_Room__c();
            GT_Speaking_Engagement__c speakingEngagement = new GT_Speaking_Engagement__c();
            GT_Event_RL__c event = new GT_Event_RL__c();
            GT_Event__c connectEvent = new GT_Event__c();
            GT_Reg_Attend_Only__c regAttend = new  GT_Reg_Attend_Only__c();
            GT_Sporting_Event__c sporEve = new GT_Sporting_Event__c();
            GT_Membership__c mem = new GT_Membership__c();
            GT_Meeting_Planning__c  meetPlan = new GT_Meeting_Planning__c();
            
            connectEvent.Association_Contact_Name__c = 'test name';
            connectEvent.RecordTypeId='0121W000000YepBQAS';
            connectEvent.Event_Start_Date__c=Date.Today()+2;
            connectEvent.Event_End_Date__c=Date.Today()+15;
            connectEvent.Event_Acronym__c='TEST01RHL';
            Test.setMock(HttpCalloutMock.class, new MockForGT_WrikeApiMethods());
            
            insert connectEvent;
           // GT_WrikeApiMethods.getAllSpacesInfo(connectEvent.RecordTypeId,connectEvent.id);
        Test.startTest();    
            exhibit.GES_Connect_Event__c = connectEvent.Id;
            insert exhibit;
            
            sponsorship.GES_Connect_Event__c = connectEvent.Id;
            insert sponsorship;
            
            meetingRoom.GES_Connect_Event__c = connectEvent.Id;
            insert meetingRoom;
            
            speakingEngagement.GES_Connect_Event__c = connectEvent.Id;
            insert speakingEngagement;
            
            regAttend.GES_Connect_Event__c = connectEvent.Id;
            insert regAttend;
            
            event.GES_Connect_Event__c = connectEvent.Id;
            event.Event_Room_Name__c = 'test name';
            insert event;
            
            meetPlan.GES_Connect_Event__c = connectEvent.Id;
            meetPlan.Meeting_Planning_Name__c = 'Test';
            insert meetPlan; 
            
            sporEve.GES_Connect_Event__c = connectEvent.Id;
            sporEve.Sporting_Event_Type__c = 'Suite';
            insert sporEve;
            
            mem.GES_Connect_Event__c = connectEvent.Id;
            insert mem;
            
            brand1.Exhibit__c = exhibit.Id;
            insert brand1;
            
            connectEvent.Event_Cancelled__c = true;
            connectEvent.Event_Cancellation_Date__c = dateTime.now();
            update connectEvent;
            
            
            GT_Event__c  updateEvent = new GT_Event__c();  
            updateEvent = [SELECT ID,Event_Cancelled__c,Event_Cancellation_Date__c FROM GT_Event__c WHERE Id = :connectEvent.Id];
            updateEvent.Event_Cancelled__c = true;
            updateEvent.Event_Cancellation_Date__c = dateTime.now();
            update updateEvent;
            
            /*GT_Exhibit__c  updateEX=new GT_Exhibit__c();  
            updateEX = [SELECT ID,Canceled__c,Cancellation_Date__c FROM GT_Exhibit__c WHERE Id = :exhibit.Id];
            updateEX.Canceled__c = true;
            updateEX.Cancellation_Date__c = system.today();
            update updateEX;*/
            
            GT_Event__c  updateEvent1=new GT_Event__c();  
            updateEvent1 = [SELECT ID,Event_Cancelled__c FROM GT_Event__c WHERE Id = :connectEvent.Id];
            updateEvent1.Event_Cancelled__c = false;
            update updateEvent1;
            
            gesEventID.add(connectEvent.Id);
            
            GT_EventTriggerHandler.updateActivities(gesEventID);
        Test.stopTest();    
            //delete trigger test from here
            
            GT_Event__c dE1 = new GT_Event__c();  
            dE1.Event_Cancelled__c = true;
            GT_Event__c dE2 = new GT_Event__c(); 
            dE2.Event_Cancelled__c = true;
            GT_Event__c dE3 = new GT_Event__c(); 
            dE3.Event_Cancelled__c = true;
            GT_Event__c dE4 = new GT_Event__c(); 
            dE4.Event_Cancelled__c = true;
            GT_Event__c dE5 = new GT_Event__c(); 
            dE5.Event_Cancelled__c = true;
            GT_Event__c dE6 = new GT_Event__c(); 
            dE6.Event_Cancelled__c = true;
            GT_Event__c dE7 = new GT_Event__c(); 
            dE7.Event_Cancelled__c = true;
            
            GT_Exhibit__c e1 = new GT_Exhibit__c();
            e1.Canceled__c = false;
            GT_Sponsorship__c s1 = new GT_Sponsorship__c();
            s1.Canceled__c = false;
            GT_Meeting_Room__c mr1 = new GT_Meeting_Room__c();
            mr1.Canceled__c = false;
            GT_Speaking_Engagement__c se1 = new GT_Speaking_Engagement__c();
            se1.Canceled__c = false;
            GT_Event_RL__c ev1 = new GT_Event_RL__c();
            ev1.Canceled__c = false;
            GT_Reg_Attend_Only__c r1 = new  GT_Reg_Attend_Only__c();
            r1.Canceled__c = false;
            GT_General_Event_Costs__c g1 = new GT_General_Event_Costs__c();
            
            
            
            dE1.Association_Contact_Name__c = 'test name';
            insert dE1;
            insert dE2;
            insert dE3;
            insert dE4;
            insert dE5;
            insert dE6;
            insert dE7;
            
            e1.GES_Connect_Event__c = dE1.Id;
            insert e1;
            
            s1.GES_Connect_Event__c = dE2.Id;
            insert s1;
            
            mr1.GES_Connect_Event__c = dE3.Id;
            insert mr1;
            
            se1.GES_Connect_Event__c = dE4.Id;
            insert se1;
            
            r1.GES_Connect_Event__c = de5.Id;
            insert r1;
            
            g1.GES_Connect_Event__c = de6.Id;
            insert g1;
            
            ev1.GES_Connect_Event__c = de7.Id;
            ev1.Event_Room_Name__c = 'test name';
            insert ev1;
            
            delete dE1;
            delete dE2;
            delete dE3;
            delete dE4;
            delete dE5;
            delete dE6;
            delete dE7;
        System.debug('1.Number of Queries used in this apex code so far: ' + Limits.getQueries());  
			GT_WrikeApiObject.FolderMapObj a= new GT_WrikeApiObject.FolderMapObj();
			GT_WrikeApiObject.TaskDatesObj dates =new GT_WrikeApiObject.TaskDatesObj();
			dates.type='Test';
			dates.duration=10;
			dates.due='2019-10-19';
			dates.start='2019-10-19';
			dates.workOnWeekends=TRUE;
        }

    }
    
    static TestMethod void createUserMethod2(){
        User u2 = [SELECT Id,Name FROM User WHERE alias='c(merck)' and isActive=TRUE LIMIT 1];//'c(merck)'
        System.runAs(u2){
            GT_Brand__c brand1 = new GT_Brand__c();
            
            list<String> gesEventID = new list<String>();
            list<GT_Event__c> gesEvent = new list<GT_Event__c>();
            GT_Exhibit__c exhibit = new GT_Exhibit__c();
            GT_Sponsorship__c sponsorship = new GT_Sponsorship__c();
            GT_Meeting_Room__c meetingRoom = new GT_Meeting_Room__c();
            GT_Speaking_Engagement__c speakingEngagement = new GT_Speaking_Engagement__c();
            GT_Event_RL__c event = new GT_Event_RL__c();
            GT_Event__c connectEvent = new GT_Event__c();
            GT_Reg_Attend_Only__c regAttend = new  GT_Reg_Attend_Only__c();
            GT_Sporting_Event__c sporEve = new GT_Sporting_Event__c();
            GT_Membership__c mem = new GT_Membership__c();
            GT_Meeting_Planning__c  meetPlan = new GT_Meeting_Planning__c();
            
            connectEvent.Association_Contact_Name__c = 'test name';
            insert connectEvent;
            
            exhibit.GES_Connect_Event__c = connectEvent.Id;
            insert exhibit;
            
            sponsorship.GES_Connect_Event__c = connectEvent.Id;
            insert sponsorship;
            
            meetingRoom.GES_Connect_Event__c = connectEvent.Id;
            insert meetingRoom;
            
            speakingEngagement.GES_Connect_Event__c = connectEvent.Id;
            insert speakingEngagement;
        Test.startTest();
            regAttend.GES_Connect_Event__c = connectEvent.Id;
            insert regAttend;
            
            event.GES_Connect_Event__c = connectEvent.Id;
            event.Event_Room_Name__c = 'test name';
            insert event;
            
            meetPlan.GES_Connect_Event__c = connectEvent.Id;
            meetPlan.Meeting_Planning_Name__c = 'Test'; 
            insert meetPlan; 
            
            sporEve.GES_Connect_Event__c = connectEvent.Id;
            sporEve.Sporting_Event_Type__c = 'Suite';
            insert sporEve;
            
            mem.GES_Connect_Event__c = connectEvent.Id;
            insert mem;
            
            brand1.Exhibit__c = exhibit.Id;
            insert brand1;
            
            GT_Event__c  updateEvent = new GT_Event__c();  
            updateEvent = [SELECT ID,Congress_Cancelled__c,Congress_Cancellation_Date__c FROM GT_Event__c WHERE Id = :connectEvent.Id];
            updateEvent.Congress_Cancelled__c = true;
            updateEvent.Congress_Cancellation_Date__c = system.today();
            update updateEvent;
            
            GT_Event__c  updateEvent1=new GT_Event__c();  
            updateEvent1 = [SELECT ID,Congress_Cancelled__c FROM GT_Event__c WHERE Id = :connectEvent.Id];
            updateEvent1.Congress_Cancelled__c = false;
            update updateEvent1;
            
            
            gesEventID.add(connectEvent.Id);
            
            GT_EventTriggerHandler.updateActivities(gesEventID);
           
            //delete trigger test from here
            
            GT_Event__c dE1 = new GT_Event__c();  
            dE1.Event_Cancelled__c = true;
            GT_Event__c dE2 = new GT_Event__c(); 
            dE2.Event_Cancelled__c = true;
            GT_Event__c dE3 = new GT_Event__c(); 
            dE3.Event_Cancelled__c = true;
            GT_Event__c dE4 = new GT_Event__c(); 
            dE4.Event_Cancelled__c = true;
            GT_Event__c dE5 = new GT_Event__c(); 
            dE5.Event_Cancelled__c = true;
            GT_Event__c dE6 = new GT_Event__c(); 
            dE6.Event_Cancelled__c = true;
            GT_Event__c dE7 = new GT_Event__c(); 
            dE7.Event_Cancelled__c = true;
            
            GT_Exhibit__c e1 = new GT_Exhibit__c();
            e1.Canceled__c = false;
            GT_Sponsorship__c s1 = new GT_Sponsorship__c();
            s1.Canceled__c = false;
            GT_Meeting_Room__c mr1 = new GT_Meeting_Room__c();
            mr1.Canceled__c = false;
            GT_Speaking_Engagement__c se1 = new GT_Speaking_Engagement__c();
            se1.Canceled__c = false;
            GT_Event_RL__c ev1 = new GT_Event_RL__c();
            ev1.Canceled__c = false;
            GT_Reg_Attend_Only__c r1 = new  GT_Reg_Attend_Only__c();
            r1.Canceled__c = false;
            GT_General_Event_Costs__c g1 = new GT_General_Event_Costs__c();
            
            
            
            dE1.Association_Contact_Name__c = 'test name';
            insert dE1;
            insert dE2;
            insert dE3;
            insert dE4;
            insert dE5;
            insert dE6;
            insert dE7;
        Test.stopTest();     
            e1.GES_Connect_Event__c = dE1.Id;
            insert e1;
            
            s1.GES_Connect_Event__c = dE2.Id;
            insert s1;
            
            mr1.GES_Connect_Event__c = dE3.Id;
            insert mr1;
            
            se1.GES_Connect_Event__c = dE4.Id;
            insert se1;
            
            r1.GES_Connect_Event__c = de5.Id;
            insert r1;
            
            g1.GES_Connect_Event__c = de6.Id;
            insert g1;
            
            ev1.GES_Connect_Event__c = de7.Id;
            ev1.Event_Room_Name__c = 'test name';
            insert ev1;
            
            delete dE1;
            delete dE2;
            delete dE3;
            delete dE4;
            delete dE5;
            delete dE6;
            delete dE7;
        System.debug('1.Number of Queries used in this apex code so far: ' + Limits.getQueries());    
        }
    }
}