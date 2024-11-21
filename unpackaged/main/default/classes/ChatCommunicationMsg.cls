public class ChatCommunicationMsg {
	//@InvocableMethod(label='Get Chat Messages' description='Returns the list of messages corresponding to the specified To Number.')
    
    // SFDC-234, Added messagesList parameter to avoid the Too many rows 50001 Error - 06/12/23 - Sajid
    //public static List<TwilioSF__Message__c> getChatMessages(String fromNum){ // Added retrun type by Sajid to fix uncommited work pending issue
    public static List<TwilioSF__Message__c> getChatMessages(String fromNum, List<TwilioSF__Message__c> messagesList){ // Added retrun type by Sajid to fix uncommited work pending issue
        JsonParseringClass.MessageList msgList = new JsonParseringClass.MessageList();
        String messagesString = '';
        
        // SFDC-234, added by Sajid - 06/12/23
        Date dte = date.today().addDays(-15);
        String formattedDate = String.valueOf(dte);
        if(formattedDate.length()>10)
            formattedDate = formattedDate.substring(0, 10);
        // code end
        
        //String accountSID = 'AC105c937643b7593455237d902f2b1a30';
        String accountSID = System.Label.Twilio_Account_SID;
        if (!Test.isRunningTest()) {
            TwilioSF.TwilioApiClient client = new TwilioSF.TwilioApiClient();
            client.addUrlPart('Accounts');
            client.addUrlPart(accountSID);
            client.addUrlPart('Messages');
            client.addUrlPart('.json');
            
            client.addParam('From',fromNum);
            client.addParam('Status','delivered');
            //client.addParam('DateCreated','2022-06-06','>=');
            client.addParam('DateCreated',formattedDate,'>='); // Fixed Apex heap size too large Issue - 05/20/24 - Sajid
            TwilioSF.TwilioApiClientResponse response = client.doGet();
            
            messagesString = response.getTwilioJsonParser().get('messages').getString();
        }else{
            messagesString = '[{"body":"Which show "are you \\exhibiting at?","num_segments":"1","direction":"outbound-api","from":"+18633426358","date_updated":"Mon, 20 Jun 2022 08:53:24 +0000","price":"-0.00750","error_message":null,"uri":"/2010-04-01/Accounts/AC105c937643b7593455237d902f2b1a30/Messages/SM55206ba63f3062106803fc29330a9371.json","account_sid":"AC105c937643b7593455237d902f2b1a30","num_media":"0","to":"+18636243488","date_created":"Mon, 20 Jun 2022 08:53:23 +0000","status":"delivered","sid":"SM55206ba63f3062106803fc29330a9371","date_sent":"Mon, 20 Jun 2022 08:53:23 +0000","messaging_service_sid":null,"error_code":null,"price_unit":"USD","api_version":"2010-04-01","subresource_uris":{"media":"/2010-04-01/Accounts/AC105c937643b7593455237d902f2b1a30/Messages/SM55206ba63f3062106803fc29330a9371/Media.json","feedback":"/2010-04-01/Accounts/AC105c937643b7593455237d902f2b1a30/Messages/SM55206ba63f3062106803fc29330a9371/Feedback.json"}},{"body":"Sorry, we could not find you in our system. Could you please verify your company name?","num_segments":"1","direction":"outbound-api","from":"+18633426358","date_updated":"Mon, 20 Jun 2022 08:52:56 +0000","price":"-0.00750","error_message":null,"uri":"/2010-04-01/Accounts/AC105c937643b7593455237d902f2b1a30/Messages/SM45a3a84eba282d8e03a782ee55e6db09.json","account_sid":"AC105c937643b7593455237d902f2b1a30","num_media":"0","to":"+18636243488","date_created":"Mon, 20 Jun 2022 08:52:55 +0000","status":"delivered","sid":"SM45a3a84eba282d8e03a782ee55e6db09","date_sent":"Mon, 20 Jun 2022 08:52:55 +0000","messaging_service_sid":null,"error_code":null,"price_unit":"USD","api_version":"2010-04-01","subresource_uris":{"media":"/2010-04-01/Accounts/AC105c937643b7593455237d902f2b1a30/Messages/SM45a3a84eba282d8e03a782ee55e6db09/Media.json","feedback":"/2010-04-01/Accounts/AC105c937643b7593455237d902f2b1a30/Messages/SM45a3a84eba282d8e03a782ee55e6db09/Feedback.json"}}]';	
        }
        system.debug('messagesString: '+messagesString);
        
        //Code added by Sajid - 03/15/23 (JIRA-200)
        /*String messagesString1 = '';
        List<String> listStr1 = messagesString.split('}}');
        System.debug('listStr1 size:: '+listStr1.size());
        
        for(String str : listStr1){
            System.debug('inputString1 :: '+str);
            if(str != ']'){
                String resultStr = FormatBodyResponse(str);
                messagesString1 = messagesString1+resultStr+'}}'; 
            }
            else{
                messagesString1 = messagesString1+str;
            }
            
            System.debug('finalString1 :: '+messagesString1);
        }*/
        //Code Ended - Sajid
        String messagesString1 = FormatBodyResponse(messagesString);
        system.debug('messagesString1: '+messagesString1);
        
        // SFDC-234, Below Code commented to avoid the Too many rows retreived 50001 Error 06/12/23 - Sajid
        /*List<TwilioSF__Message__c> messagesList = new List<TwilioSF__Message__c>();
        List<Twilio_Numbers__mdt> fromNumbersList = new List<Twilio_Numbers__mdt>([Select Phone_Number__c from Twilio_Numbers__mdt where IsActive__c = true ]);
		List<String> phNumList = new List<String>();
        for(Twilio_Numbers__mdt tNum : fromNumbersList){
            phNumList.add(tNum.Phone_Number__c);
        }
        system.debug('phNumList '+phNumList);
        messagesList = [Select Id,TwilioSF__Message_SID__c,TwilioSF__Body__c,TwilioSF__Date_Sent__c,TwilioSF__from_Number__c from TwilioSF__Message__c where TwilioSF__from_Number__c IN :phNumList ];
        system.debug('line 145 messagesList: '+messagesList);
        */
		msgList = JsonParseringClass.getJSONData(messagesString1);
        system.debug('line 147 messagesList: '+msgList);
        Set<String> existingSIDSet = new Set<String>();
        List<TwilioSF__Message__c> insertMsgList = new List<TwilioSF__Message__c>();
		Set<String> responseIdSet = new Set<String>();
        for(Integer i=0;i<msgList.MessageList.size();i++){
            responseIdSet.add(msgList.MessageList[i].sid);
        }
        if(messagesList.size()>0){
            for(TwilioSF__Message__c msg:messagesList){
                if(responseIdSet.Contains(msg.TwilioSF__Message_SID__c)){
                    existingSIDSet.add(msg.TwilioSF__Message_SID__c);
                }
            }
        }
        system.debug('existingSIDSet ' +existingSIDSet);
        if(msgList.MessageList.size()>0){
            system.debug('msgList.MessageList.size() '+msgList.MessageList.size());
            for(JsonParseringClass.MessageWrapper outboundMsg:msgList.MessageList){
                if(!existingSIDSet.Contains(outboundMsg.sid)){
                    //system.debug('if contains ');
                    system.debug('outboundMsg.body '+outboundMsg.body);
                    
                    insertMsgList.add(new TwilioSF__Message__c(
                        TwilioSF__Body__c = outboundMsg.body,
                        TwilioSF__Direction__c = outboundMsg.direction,
                        TwilioSF__Message_SID__c = outboundMsg.sid,
                        TwilioSF__To_Number__c = outboundMsg.to,
                        TwilioSF__From_Number__c = fromNum,
                        TwilioSF__Status__c = outboundMsg.status,
                        TwilioSF__Date_Created__c = getDateFormat(outboundMsg.date_created),
                        TwilioSF__Date_Sent__c = getDateFormat(outboundMsg.date_sent),
                        TwilioSF__Date_Updated__c = getDateFormat(outboundMsg.date_updated),
                        TwilioSF__Resource_Location__c = outboundMsg.uri
                        
                        
                    ));
                    existingSIDSet.add(outboundMsg.sid); // Added by Sajid - 03/15/23 (JIRA-)
                }
            }
        }
            // Code commented by Sajid to fix Uncommited work pending Issue
           /* if(insertMsgList.size()>0){
                insertOutboundMessages(insertMsgList);
                system.debug('insertMsgList: '+insertMsgList);
            }*/
       return insertMsgList; // added by Sajid
	}
    
    // Code commented by Sajid to fix Uncommited work pending Issue 
   /* public static void insertOutboundMessages(List<TwilioSF__Message__c> messageList){
        Database.insert(messageList, false);
    }*/
    
    public static datetime getDateFormat(String dateFormat){
        Map <String, Integer> monthNames = new Map <String, Integer> {'Jan'=>1, 'Feb'=>2, 'Mar'=>3, 'Apr'=>4, 'May'=>5, 'Jun'=>6, 'Jul'=>7, 'Aug'=>8, 'Sep'=>9, 'Oct'=>10, 'Nov'=>11, 'Dec'=>12};
        List <String> stringParts = dateFormat.split(' ');
        List <String> timeParts = stringParts[4].split(':');
        
        DateTime yourDateVariable = DateTime.newInstanceGmt(Integer.valueOf(stringParts[3]), 
                                    monthNames.get(stringParts[2]), 
                                    Integer.valueOf(stringParts[1]), 
                                    Integer.valueOf(timeParts[0]), 
                                    Integer.valueOf(timeParts[1]), 
                                    Integer.valueOf(timeParts[2]));
        return yourDateVariable;
    }
    
    public static String FormatBodyResponse(String inputString){
        List<String> listInputStr = inputString.split('"body":"');
        String finalString = '';
        Boolean firstExecution=true;
        Boolean doubleQuotes=false;
        
        for(String str : listInputStr){
            system.debug('str:: '+str);
            if(!firstExecution){
                Integer strLength = str.length();
                Integer index = str.indexOf('","');
                String subString1 = str.substring(0,index);
                String newString=subString1;
                system.debug('subString1:: '+subString1);
                if(subString1.contains('"')){
                    system.debug('continas double qotes::');
                    newString='';
                    newString = subString1.replace('"','');
                    doubleQuotes=true;
                }
                if(subString1.contains('\\')){
                    system.debug('continas back slash::');
                    if(doubleQuotes){
                        subString1 = newString;
                    }
                    newString='';
                    List<String> listSubString1 = subString1.split('\\\\');
                    for(String str2 : listSubString1){
                        newString+=str2+'\\\\';
                    }
                    newString = newString.removeEnd('\\\\');
                }
                system.debug('newString:: '+newString);
                String subString2 = str.substring(index,strLength);
                finalString += '"body":"'+newString+subString2;
            }else{
                finalString = str;
            }
            firstExecution=false;
            doubleQuotes=false;
        }
        return finalString;
        /*System.debug('inputString2:: '+inputString);
        String finalStr='';
        List<String> listStr = inputString.split('num_segments');
        if(listStr.size()>1){
            List<String> listStr2 = listStr[0].split(':');
            String str1 ='';
            if(listStr.size()>1){
                for(Integer i=1; i< listStr2.size(); i++){
                    str1 = str1 + listStr2[i].replace('"','');
                    for(Integer j=0; j<str1.length(); j++){
                        if(str1.charAt(j) == 92){
                            System.debug('Before Backslash:: '+str1);
                            str1 = str1.substring(0, j)+'\\\\'+str1.substring(j+1, str1.length());
                            ++j;
                            System.debug('After Backslash:: '+str1);
                        }
                    }
                }
            }
            String resultStr = listStr2[0] +':"'+str1.removeEnd(',')+'","';
            finalStr = resultStr + 'num_segments' +listStr[1];
        }else{
            finalStr = inputString;
        }
        System.debug('finalStr2:: '+finalStr);
        return finalStr;*/
    }
}