@isTest
public class ChatMessagesTestClass {
    static testMethod void testMethod1() {
        
        Account acc = new Account();
        acc.Name ='Name';
        insert acc;
        
        Contact cont = new Contact();
        cont.LastName = 'Test Contact';
        cont.MobilePhone = '+17027189991';
        cont.Email = 'test@ges.com';
        cont.AccountId = acc.Id;
        insert cont;
        
        List<TwilioSF__Message__c> listMsg = new List<TwilioSF__Message__c>();
        TwilioSF__Message__c tMsg = new TwilioSF__Message__c();
        tMsg.TwilioSF__Body__c='Body ';
        tMsg.TwilioSF__From_Number__c = '+17027182122';
        tMsg.TwilioSF__To_Number__c = '+17027189991';
        tMsg.TwilioSF__Direction__c = 'outbound';
        tMsg.TwilioSF__Date_Created__c = System.now();
        tMsg.TwilioSF__Contact__c = cont.Id;
        listMsg.add(tMsg);
        TwilioSF__Message__c tMsg2 = new TwilioSF__Message__c();
        tMsg2.TwilioSF__Body__c='Body ';
        tMsg2.TwilioSF__From_Number__c = '+17027102050';
        tMsg2.TwilioSF__To_Number__c = '+17027189991';
        tMsg2.TwilioSF__Direction__c = 'outbound';
        tMsg2.TwilioSF__Date_Created__c = System.now();
        tMsg2.TwilioSF__Contact__c = cont.Id;
        listMsg.add(tMsg2);
        TwilioSF__Message__c tMsg3 = new TwilioSF__Message__c();
        tMsg3.TwilioSF__Body__c='Body ';
        tMsg3.TwilioSF__From_Number__c = '+17573798751';
        tMsg3.TwilioSF__To_Number__c = '+17027189991';
        tMsg3.TwilioSF__Direction__c = 'outbound';
        tMsg3.TwilioSF__Date_Created__c = System.now();
        tMsg3.TwilioSF__Contact__c = cont.Id;
        listMsg.add(tMsg3);
        insert listMsg;
        
        
        
        
        LiveChatVisitor visitor = new LiveChatVisitor();
        insert visitor;
        
        LiveChatTranscript chat = new LiveChatTranscript();
        chat.ContactId = cont.Id;
        chat.Body = tMsg.TwilioSF__Body__c;
        chat.LiveChatVisitorId = visitor.Id;
        insert chat;
        
        LiveChatVisitor visitor1 = new LiveChatVisitor();
        insert visitor1;
        
        LiveChatTranscript chat1 = new LiveChatTranscript();
        chat1.ContactId = cont.Id;
        chat1.Body = tMsg.TwilioSF__Body__c;
        chat1.LiveChatVisitorId = visitor1.Id;
        insert chat1;
        
        LiveChatVisitor visitor2 = new LiveChatVisitor();
        insert visitor2;
        
        LiveChatTranscript chat2 = new LiveChatTranscript();
        chat2.ContactId = cont.Id;
        chat2.Body = tMsg.TwilioSF__Body__c;
        chat2.LiveChatVisitorId = visitor2.Id;
        insert chat2;
        
    	Test.startTest();
        
			ChatMessagesBatch chatBatch = new ChatMessagesBatch();
			Id batchId = Database.executeBatch(chatBatch);
                        
        Test.stopTest();
        
        //System.assertEquals(1, [select count() from TwilioSF__Message__c LIMIT 1]);
        
    }

}