public class ChatStorageBatch implements Database.AllowsCallouts,Database.Batchable<sObject>{
    
    Set<String> phNumSet = new Set<String>();
    public static Twilio_Custom_Setting__c twilioSetting = Twilio_Custom_Setting__c.getOrgDefaults();
    public static Boolean scheduledJobInd = twilioSetting.Storage_Batch_Scheduled_Job_Indicator__c;
    public static Integer scheduledMins = scheduledJobInd ? twilioSetting.Storage_Batch_Scheduled_Job_Time__c!= null?(Integer) twilioSetting.Storage_Batch_Scheduled_Job_Time__c:0:0;
    public static DateTime scheduleDateTime;
    
    public ChatStorageBatch(){
        List<Twilio_Numbers__mdt> numbersList = new List<Twilio_Numbers__mdt>([Select Phone_Number__c,IsActive__c from Twilio_Numbers__mdt where IsActive__c = true ]);
        for(Twilio_Numbers__mdt tNum : numbersList){
            phNumSet.add(tNum.Phone_Number__c);          
        }
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        
        DateTime timeDelay;
        DateTime dt = System.now();

       	scheduleDateTime = (DateTime) twilioSetting.Storage_Batch_Date_and_Time_Delay__c;
        timeDelay = scheduledJobInd ? dt.addMinutes(-scheduledMins) : scheduleDateTime != null ? scheduleDateTime:dt;
		system.debug('dt:: '+dt);
        system.debug('timeDelay:: '+timeDelay);
        
        String query = 'SELECT Id, TwilioSF__Body__c,TwilioSF__From_Number__c,TwilioSF__To_Number__c, Chat_Transcript__c, Contact__c, Contact__r.LastName, TwilioSF__Contact__c, TwilioSF__Contact__r.LastName, TwilioSF__Date_Created__c,TwilioSF__Direction__c,CreatedById, CreatedBy.Name FROM TwilioSF__Message__c '+
            'WHERE (TwilioSF__From_Number__c IN :phNumSet OR TwilioSF__To_Number__c IN :phNumSet) AND Contact__c != null AND Chat_Transcript__c != null ' +
            'AND CreatedDate >= :timeDelay order by TwilioSF__Date_Created__c ';
        List<TwilioSF__Message__c> listMsg = Database.query(query);
        system.debug('listMsg:: '+listMsg);
        return  Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext BC,List<TwilioSF__Message__c> scope){
        List<LiveChatTranscript> updateChatList = new List<LiveChatTranscript>();
        Map<Id, List<TwilioSF__Message__c>> mapChatTransIdToMessage = new Map<Id, List<TwilioSF__Message__c>>();
        
        String autoMessage = 'Could you please verify your booth number?';
        String autoMessage1 = 'Which show are you exhibiting at?';
        String autoMessage2 = 'Can you please tell us your name?';
        String autoMessage3 = 'Could you please verify your company name?';
        String autoMessage4 = 'Thank you for your text message. Sorry, we did not find this contact in our system. Can you please tell us your name?';
        String autoMessage5 = 'Thank you for your response.';
        
		System.debug('scope size:: '+scope.size());
        
        for(TwilioSF__Message__c tMsg: scope){
            if(mapChatTransIdToMessage.containsKey(tMsg.Chat_Transcript__c)){
                List<TwilioSF__Message__c> lst_msg = mapChatTransIdToMessage.get(tMsg.Chat_Transcript__c);
                lst_msg.add(tMsg);
                mapChatTransIdToMessage.put(tMsg.Chat_Transcript__c,lst_msg); 
            }else{
                mapChatTransIdToMessage.put(tMsg.Chat_Transcript__c, new List<TwilioSF__Message__c>{tMsg});
            }  
        }
        System.debug('mapChatTransIdToMessage size:: '+mapChatTransIdToMessage.size());
        
        List<LiveChatTranscript> chatTransList = new List<LiveChatTranscript>();
        if(!Test.isRunningTest()){
            chatTransList = [SELECT Id, Body,Name,ContactId,CaseId,CreatedDate,UserAgent FROM LiveChatTranscript where Id IN :mapChatTransIdToMessage.keySet() AND Case.Owner.Name =: 'Exhibitor Services Text' AND  Case.CreatedBy.Name =: 'Twilio Integration'];
        }else{
            chatTransList = [SELECT Id, Body,Name,ContactId,CaseId,CreatedDate,UserAgent FROM LiveChatTranscript];
        }
        
        for(LiveChatTranscript chatTransRecord : chatTransList){
            List<TwilioSF__Message__c> msgRecords = mapChatTransIdToMessage.get(chatTransRecord.Id);
            
            System.debug('msgRecords size:: '+msgRecords.size());
            
            for(TwilioSF__Message__c tMsg : msgRecords){
                String twilioBody = tMsg.TwilioSF__Body__c;
                if(twilioBody != null){
                    if(chatTransRecord.Body == Null){
                        chatTransRecord.Body = 'Chat Conversation: '+'<br/>';
                    }
                    
                    if(tMsg.TwilioSF__Direction__c == 'inbound'){
                        chatTransRecord.Body += '<br/>' + tMsg.TwilioSF__Date_Created__c + ' : ' + tMsg.Contact__r.LastName + ' : ' +tMsg.TwilioSF__Body__c + '<br/> ';
                        chatTransRecord.EndTime =tMsg.TwilioSF__Date_Created__c;
                    }
                    else{
                        chatTransRecord.Body += '<br/>' + tMsg.TwilioSF__Date_Created__c + ' : ' + 'GES' + ' : ' +tMsg.TwilioSF__Body__c + '<br/> ';
                        chatTransRecord.UserAgent = tMsg.CreatedBy.Name;
                        chatTransRecord.EndTime =tMsg.TwilioSF__Date_Created__c;
                        
                        if(twilioBody.contains(autoMessage) ||
                          twilioBody.contains(autoMessage1) ||
                          twilioBody.contains(autoMessage2) ||
                          twilioBody.contains(autoMessage3) ||
                          twilioBody.contains(autoMessage4) ||
                          twilioBody.contains(autoMessage5)){
                            system.debug('autoMessage '+twilioBody);
                        }else{
                            chatTransRecord.Premature_Chat__c = False;
                        }
                    }
                }
            }
            updateChatList.add(chatTransRecord);
        }
        if(updateChatList != null && updateChatList.size() > 0){
            update updateChatList;
        }
    }
    public void finish(Database.BatchableContext BC){
        if(!Test.isRunningTest() && scheduledJobInd && scheduledMins!=0){
            System.scheduleBatch(new ChatStorageBatch(),'ChatStorageBatch', scheduledMins);  
        }
    }
    
}