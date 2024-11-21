public class JsonParseringClass
{
    //Method To Parse JSON Data
    public static MessageList getJSONData(String jsonString)
    {
        MessageList msgList = new MessageList();
        String msgString = '{"MessageList":' + jsonString +'}';
        
        msgList = (MessageList)System.JSON.deserialize(msgString, MessageList.class);
        System.debug('Response- ' + msgList);
        return msgList;
    }
     
    public class MessageList
    {
        public List<MessageWrapper> MessageList;
    }
     
    public class MessageWrapper
    {
        public string body { get; set; }
        public string direction { get; set; }
        public string date_updated { get; set; }
        public string uri { get; set; }
        public string to { get; set; }
        public string date_created { get; set; }
        public string status { get; set; }
        public string sid { get; set; }
        public string date_sent { get; set; }
       
    }
}