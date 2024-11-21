public class ChatMessagesBatch implements Database.AllowsCallouts,Database.Batchable<String>{
    
    public Iterable<String> start(Database.BatchableContext BC){
        List<Twilio_Numbers__mdt> numbersList = new List<Twilio_Numbers__mdt>([Select Phone_Number__c from Twilio_Numbers__mdt where IsActive__c = true ]);
        List<String> phNumList = new List<String>();
        for(Twilio_Numbers__mdt tNum : numbersList){
            phNumList.add(tNum.Phone_Number__c);
        }
        return phNumList;
    }
    public void execute(Database.BatchableContext BC,List<String> scope){
        system.debug('Scope '+scope);
        List<TwilioSF__Message__c> messagesList = [Select Id,TwilioSF__Message_SID__c,TwilioSF__Body__c,TwilioSF__Date_Sent__c,TwilioSF__from_Number__c from TwilioSF__Message__c where TwilioSF__from_Number__c IN :scope and CreatedDate = LAST_N_DAYS:16];  //SFDC-234, reterieved Message records outside For loop to avoid the Too many rows 50001 Error -06/12/23 - Sajid
        List<TwilioSF__Message__c> twilioInsertMsgList = new List<TwilioSF__Message__c>(); // code added by Sajid to fix Uncommited work pending Issue
        for(String fromNum: scope){
            system.debug('from Number '+fromNum);
            //SFDC-234, added messagesList parameter to fix the Too many rows 50001 Error - 06/12/23 - Sajid
            //List<TwilioSF__Message__c> messageList = ChatCommunicationMsg.getChatMessages(fromNum);
            List<TwilioSF__Message__c> messageList = ChatCommunicationMsg.getChatMessages(fromNum,messagesList);
            
            // code added by Sajid to fix Uncommited work pending Issue
            if(messageList != null && messageList.size()>0){
                twilioInsertMsgList.addAll(messageList);
            }
        }
        // code added by Sajid to fix Uncommited work pending Issue
        if(twilioInsertMsgList != null && twilioInsertMsgList.size() > 0){
            Database.insert(twilioInsertMsgList, false);
        }
    }
    public void finish(Database.BatchableContext BC){
        if(!Test.isRunningTest()){
        	System.scheduleBatch(new ChatMessagesBatch(),'ChatMessagesBatch',4);
        }
    }

}