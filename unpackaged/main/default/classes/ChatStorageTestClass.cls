@isTest
public class ChatStorageTestClass {
	@isTest
    static void testMethod1() 
    {
        Profile profile1 = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User adminUser = new User(
            ProfileId = profile1.Id,
            Username ='admintestuser001@test.com',
            Alias = 'adtest',
            Email='admin.user@test.com',
            EmailEncodingKey='UTF-8',
            Firstname='Twilio',
            Lastname='Integration',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
        );
        insert(adminUser);
        
        Group testGroup = new Group(Name='Exhibitor Services Text', Type='Queue');
        insert testGroup;
        
        System.runAs(new User(Id=UserInfo.getUserId()))
        {
            QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Case');
            insert testQueue;
        }
        
        
        //User usr = GC_TestUtils.createUser('System Administrator', 'Exhibitor', 'Services Text');
        //User usr = [select Id, Name from User WHERE IsActive=True AND Name = 'Exhibitor Services Text' LIMIT 1];
        Case c = new Case();
        System.runAs(adminUser){
            c.subject='testcase';
            c.ownerId=testGroup.id;
            c.Status = 'New';
        }
        
        Account acc = new Account();
        acc.Name ='Name';
        insert acc;
        
        Contact cont = new Contact();
        cont.LastName = 'Test Contact';
        cont.MobilePhone = '+18606005240';
        cont.Email = 'test@ges.com';
        cont.AccountId = acc.Id;
        insert cont;

        LiveChatVisitor visitor = new LiveChatVisitor();
        insert visitor;
        
        LiveChatTranscript chat = new LiveChatTranscript();
        chat.ContactId = cont.Id;
        chat.LiveChatVisitorId = visitor.Id;
        chat.StartTime = system.now();
        chat.CaseId = c.Id;
        insert chat;
		
		LiveChatVisitor visitor1 = new LiveChatVisitor();
        insert visitor1;
        
        LiveChatTranscript chat1 = new LiveChatTranscript();
        chat1.ContactId = cont.Id;
        chat1.LiveChatVisitorId = visitor1.Id;
        chat1.StartTime = system.now();
        chat1.CaseId = c.Id;
        insert chat1;
        
        LiveChatVisitor visitor2 = new LiveChatVisitor();
        insert visitor2; 
        
        LiveChatTranscript chat2 = new LiveChatTranscript();
        chat2.ContactId = cont.Id;         
        chat2.LiveChatVisitorId = visitor2.Id;        
        chat2.StartTime = system.now();
        chat2.CaseId = c.Id;
         insert chat2;
        
        List<TwilioSF__Message__c> listMsg = new List<TwilioSF__Message__c>();
        TwilioSF__Message__c tMsg = new TwilioSF__Message__c();
        tMsg.TwilioSF__Body__c='Body ';
        tMsg.TwilioSF__From_Number__c = '+18606005240';//external contact 
        tMsg.TwilioSF__To_Number__c = '+17027182122'; //twilio number +17573798751
        tMsg.TwilioSF__Direction__c = 'inbound';
        tMsg.TwilioSF__Date_Created__c = System.now().addMinutes(-2);
        tMsg.TwilioSF__Contact__c = cont.Id;
        tMsg.CreatedById='0058Z000008a1SbQAI';
        tMsg.Chat_Transcript__c = chat.Id;
        listMsg.add(tMsg);
        
        TwilioSF__Message__c tMsg1 = new TwilioSF__Message__c();
        tMsg1.TwilioSF__Body__c='Thank you for your response.';
        tMsg1.TwilioSF__From_Number__c = '+17027182122';//twilio number +17573798751
        tMsg1.TwilioSF__To_Number__c = '+18606005240';//external contact number
        tMsg1.TwilioSF__Direction__c = 'outbound';
        tMsg1.TwilioSF__Date_Created__c = System.now().addMinutes(-2);
        tMsg1.TwilioSF__Contact__c = cont.Id;
        tMsg1.CreatedById='0058Z000008a1SbQAI'; //any user id from executable env
        tMsg1.Chat_Transcript__c = chat1.Id;
        listMsg.add(tMsg1);
        
        TwilioSF__Message__c tMsg2 = new TwilioSF__Message__c();
        tMsg2.TwilioSF__Body__c='Thank you for your response.';
        tMsg2.TwilioSF__From_Number__c = '+17027182122';//twilio number +17573798751
        tMsg2.TwilioSF__To_Number__c = '+18606005240';//external contact number
        tMsg2.TwilioSF__Direction__c = 'outbound';
        tMsg2.TwilioSF__Date_Created__c = System.now().addMinutes(-2);
        tMsg2.TwilioSF__Contact__c = cont.Id;
        tMsg2.CreatedById='0058Z000008a1SbQAI'; //any user id from executable env
        tMsg2.Chat_Transcript__c = chat2.Id;
        listMsg.add(tMsg2);
        insert listMsg;
        
        
        Test.startTest();
        
        ChatStorageBatch chatBatch = new ChatStorageBatch();
        Id batchId = Database.executeBatch(chatBatch);
        chatBatch.execute(null,listMsg);
                        
        Test.stopTest();
    }
    
}