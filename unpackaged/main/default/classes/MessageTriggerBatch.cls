public class MessageTriggerBatch implements Database.AllowsCallouts,Database.Batchable<sObject>{

    Set<String> toNumSet = new Set<String>();
    Set<String> phNumSet = new Set<String>();
    Map<String, Id> mapPhoneToChatTransId = new Map<String, Id>();
    Map<String, Id> mapChatToContactId = new Map<String, Id>();
    Map<String, Id> mapChatToCaseID = new Map<String, Id>();
    
    public MessageTriggerBatch(){
        List<Twilio_Numbers__mdt> numbersList = new List<Twilio_Numbers__mdt>([Select Phone_Number__c,IsActive__c from Twilio_Numbers__mdt where IsActive__c = true ]);
        for(Twilio_Numbers__mdt tNum : numbersList){
            phNumSet.add(tNum.Phone_Number__c);             
        }
        /*phNumSet = new Set<String>{'+17067195492',
            '+17707586160',
            '+13215290545',
            '+13213513974',
            '+14109703055',
            '+14697464502',
            '+14454474190',
            '+17256000262',
            '+17252162463',
            '+17027182122',
            '+17027189991',
            '+17024890529',
            '+12136992400',
            '+16029755112',
            '+14698718220',
            '+17734324279',
            '+17735707802'};*/
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        system.debug('phNumSet:: '+phNumSet);
        String query;
        if(!Test.isRunningTest()){
            query = 'SELECT Id,TwilioSF__From_Number__c,TwilioSF__To_Number__c, Contact__c, Contact_Id__c, Case__c, Chat_Transcript__c FROM TwilioSF__Message__c '+
            'WHERE (TwilioSF__From_Number__c IN :phNumSet OR TwilioSF__To_Number__c IN :phNumSet) AND TwilioSF__Contact__c != null ' +
            'AND TwilioSF__Date_Created__c <= Today AND TwilioSF__Date_Created__c >= 2021-01-01T17:57:49.000+0000 and Case__c = null order by TwilioSF__Date_Created__c';
        }else{
            query = 'SELECT Id,TwilioSF__From_Number__c,TwilioSF__To_Number__c, Contact__c, Contact_Id__c, Case__c, Chat_Transcript__c FROM TwilioSF__Message__c '+
            'WHERE (TwilioSF__From_Number__c IN :phNumSet OR TwilioSF__To_Number__c IN :phNumSet) AND TwilioSF__Contact__c != null ' +
            'AND TwilioSF__Date_Created__c <= Today AND TwilioSF__Date_Created__c >= 2021-01-01T17:57:49.000+0000 order by TwilioSF__Date_Created__c';
        }
        return  Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC,List<TwilioSF__Message__c> scope){
        List<TwilioSF__Message__c> msgToUpdate = new List<TwilioSF__Message__c>();
        if(scope != null && scope.size() > 0){
            for(TwilioSF__Message__c tMsg: scope){
                if(!phNumSet.contains(tMsg.TwilioSF__From_Number__c) && !toNumSet.contains(tMsg.TwilioSF__From_Number__c)){
                    toNumSet.add(tMsg.TwilioSF__From_Number__c);
                }
                if(!phNumSet.contains(tMsg.TwilioSF__To_Number__c) && !toNumSet.contains(tMsg.TwilioSF__To_Number__c)){
                    toNumSet.add(tMsg.TwilioSF__To_Number__c);
                }
            }
            system.debug('toNumSet:: '+toNumSet);
            
            List<LiveChatTranscript> chatTransList = new List<LiveChatTranscript>();
            if(!Test.isRunningTest()){
                chatTransList = new List<LiveChatTranscript>([SELECT Id,ContactId,Contact.Phone, Contact.MobilePhone, CaseId, Case.Show_Opportunity__c, Case.Origin FROM LiveChatTranscript where ContactId != null AND (Contact.Phone IN: toNumSet OR Contact.MobilePhone IN: toNumSet) AND Case.Owner.Name =: 'Exhibitor Services Text' AND Case.CreatedBy.Name =: 'Twilio Integration' order by LastModifiedDate desc]);
            }else{
                chatTransList = new List<LiveChatTranscript>([SELECT Id,ContactId,Contact.Phone, Contact.MobilePhone, CaseId, Case.Show_Opportunity__c, Case.Origin FROM LiveChatTranscript where ContactId != null AND (Contact.Phone IN: toNumSet OR Contact.MobilePhone IN: toNumSet) order by LastModifiedDate desc]);
            }
            
            System.debug('chatTransList:: '+chatTransList);
            for(LiveChatTranscript chatTrans : chatTransList){
                System.debug('chatTrans:: '+chatTrans);
                if(!mapPhoneToChatTransId.containsKey(chatTrans.Contact.MobilePhone) && toNumSet.contains(chatTrans.Contact.MobilePhone)){
                    mapPhoneToChatTransId.put(chatTrans.Contact.MobilePhone, chatTrans.Id);
                }
                if(!mapPhoneToChatTransId.containsKey(chatTrans.Contact.Phone) && toNumSet.contains(chatTrans.Contact.Phone)){
                    mapPhoneToChatTransId.put(chatTrans.Contact.Phone, chatTrans.Id);
                }
                mapChatToContactId.put(chatTrans.Id, chatTrans.ContactId);
                mapChatToCaseID.put(chatTrans.Id, chatTrans.CaseId);
            }
            System.debug('mapPhoneToChatTransId:: '+mapPhoneToChatTransId);
            System.debug('mapChatToContactId:: '+mapChatToContactId);
            System.debug('mapChatToCaseID:: '+mapChatToCaseID);
            
            if(mapPhoneToChatTransId != null && mapPhoneToChatTransId.size() > 0){
                for(TwilioSF__Message__c tMsg :scope){
                    if(!phNumSet.contains(tMsg.TwilioSF__From_Number__c)){
                        System.debug('msgFromNumber:: '+tMsg.TwilioSF__From_Number__c);
                        String chatId = mapPhoneToChatTransId.get(tMsg.TwilioSF__From_Number__c);
                        System.debug('chatIdFROM:: '+chatId);
                        if(chatId != null){
                            if(tMsg.Chat_Transcript__c == null){
                                tMsg.Chat_Transcript__c = chatId;
                            }
                            if(tMsg.Case__c == null && mapChatToCaseID?.containsKey(chatId)){
                                tMsg.Case__c = mapChatToCaseID.get(chatId);
                            }
                            if(tMsg.Contact__c == null && mapChatToContactId?.containsKey(chatId)){
                                tMsg.Contact__c = mapChatToContactId.get(chatId);
                                tMsg.Contact_Id__c = mapChatToContactId.get(chatId);
                            }
                        }
                    }
                    else if(!phNumSet.contains(tMsg.TwilioSF__To_Number__c)){
                        System.debug('msgToNumber:: '+tMsg.TwilioSF__To_Number__c);
                        String chatId = mapPhoneToChatTransId.get(tMsg.TwilioSF__To_Number__c);
                        System.debug('chatIdTO:: '+chatId);
                        if(chatId != null){
                            if(tMsg.Chat_Transcript__c == null){
                                tMsg.Chat_Transcript__c = chatId;
                            }
                            if(tMsg.Case__c == null && mapChatToCaseID?.containsKey(chatId)){
                                tMsg.Case__c = mapChatToCaseID.get(chatId);
                            }
                            if(tMsg.Contact__c == null && mapChatToContactId?.containsKey(chatId)){
                                tMsg.Contact__c = mapChatToContactId.get(chatId);
                                tMsg.Contact_Id__c = mapChatToContactId.get(chatId);
                            }
                        }
                    }
                    msgToUpdate.add(tMsg);
                }
            }
        }
        
        if(msgToUpdate != null && msgToUpdate.size() > 0){
            update msgToUpdate;
        }
        
    }
    
    public void finish(Database.BatchableContext BC){
    }
    
}