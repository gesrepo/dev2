trigger MessageTrigger on TwilioSF__Message__c (before insert, before update) {
    Set<String> phNumSet = new Set<String>();
    Set<String> toNumSet = new Set<String>();
    
    Map<String, Id> mapPhoneToChatTransId = new Map<String, Id>();
    Map<String, Id> mapChatToContactId = new Map<String, Id>();
    Map<String, Id> mapChatToCaseID = new Map<String, Id>();
    
    //SFDC-238 Credit Card Masking - 09/27/24 - SM
    for(TwilioSF__Message__c tMsg: Trigger.new){
        String messageBody = tMsg.TwilioSF__Body__c;
        tMsg.TwilioSF__Body__c = MessageTriggerHandler.maskCreditCardNumbers(messageBody);
    }
    //END - SFDC-238
    
    List<Twilio_Numbers__mdt> numbersList = new List<Twilio_Numbers__mdt>([Select Phone_Number__c,IsActive__c from Twilio_Numbers__mdt where IsActive__c = true ]);
    for(Twilio_Numbers__mdt tNum : numbersList){
        phNumSet.add(tNum.Phone_Number__c);             
    }
    
    for(TwilioSF__Message__c tMsg: Trigger.new){
        if(tMsg.TwilioSF__From_Number__c != null && !phNumSet.contains(tMsg.TwilioSF__From_Number__c) && !toNumSet.contains(tMsg.TwilioSF__From_Number__c)){
            toNumSet.add(tMsg.TwilioSF__From_Number__c);
        } 
        if(tMsg.TwilioSF__To_Number__c != null && !phNumSet.contains(tMsg.TwilioSF__To_Number__c) && !toNumSet.contains(tMsg.TwilioSF__To_Number__c)){
            toNumSet.add(tMsg.TwilioSF__To_Number__c);
        }
    }
    
    List<LiveChatTranscript> chatTransList = new List<LiveChatTranscript>();
    if(!Test.isRunningTest()){
        chatTransList = new List<LiveChatTranscript>([SELECT Id,ContactId,Contact.Phone, Contact.MobilePhone, CaseId, Case.Show_Opportunity__c, Case.Origin FROM LiveChatTranscript where ContactId != null AND (Contact.Phone IN: toNumSet OR Contact.MobilePhone IN: toNumSet) AND Case.Owner.Name =: 'Exhibitor Services Text' AND Case.CreatedBy.Name =: 'Twilio Integration' AND Case.Status != 'Closed' order by LastModifiedDate desc]);
    }
    else{
        chatTransList = new List<LiveChatTranscript>([SELECT Id,ContactId,Contact.Phone, Contact.MobilePhone, CaseId, Case.Show_Opportunity__c, Case.Origin FROM LiveChatTranscript where ContactId != null AND (Contact.Phone IN: toNumSet OR Contact.MobilePhone IN: toNumSet) order by LastModifiedDate desc]);
    }
    
	System.debug('chatTransList:: '+chatTransList);
    
    for(LiveChatTranscript chatTrans : chatTransList){
		System.debug('chatTrans:: '+chatTrans);
        if(chatTrans.Contact.MobilePhone != null && !mapPhoneToChatTransId.containsKey(chatTrans.Contact.MobilePhone) && toNumSet.contains(chatTrans.Contact.MobilePhone)){
            mapPhoneToChatTransId.put(chatTrans.Contact.MobilePhone, chatTrans.Id);
            mapChatToContactId.put(chatTrans.Id, chatTrans.ContactId);
            mapChatToCaseID.put(chatTrans.Id, chatTrans.CaseId);
        }
        
        if(chatTrans.Contact.Phone != null && !mapPhoneToChatTransId.containsKey(chatTrans.Contact.Phone) && toNumSet.contains(chatTrans.Contact.Phone)){
            mapPhoneToChatTransId.put(chatTrans.Contact.Phone, chatTrans.Id);
            mapChatToContactId.put(chatTrans.Id, chatTrans.ContactId);
            mapChatToCaseID.put(chatTrans.Id, chatTrans.CaseId);
        }
    }

    System.debug('mapPhoneToChatTransId:: '+mapPhoneToChatTransId);
    System.debug('mapChatToContactId:: '+mapChatToContactId);
    System.debug('mapChatToCaseID:: '+mapChatToCaseID);
    
    if(mapPhoneToChatTransId != null && mapPhoneToChatTransId.size() > 0){
        for(TwilioSF__Message__c tMsg :Trigger.new){
            if(!phNumSet.contains(tMsg.TwilioSF__From_Number__c)){
                System.debug('msgFromNumber:: '+tMsg.TwilioSF__From_Number__c);
                String chatId = mapPhoneToChatTransId.get(tMsg.TwilioSF__From_Number__c);
                System.debug('chatIdFROM:: '+chatId);
                if(chatId != null){
                    if(tMsg.Chat_Transcript__c == null){
                        tMsg.Chat_Transcript__c = chatId;
                    }

                    if(tMsg.Case__c == null && mapChatToCaseID?.containsKey(chatId)){
                        tMsg.Case__c =  mapChatToCaseID.get(chatId);
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
                        tMsg.Case__c =  mapChatToCaseID.get(chatId);
                    }
                    
                    if(tMsg.Contact__c == null && mapChatToContactId?.containsKey(chatId)){
                        tMsg.Contact__c = mapChatToContactId.get(chatId);
                        tMsg.Contact_Id__c = mapChatToContactId.get(chatId);
                    }
                }
            }
        }
    }   

}