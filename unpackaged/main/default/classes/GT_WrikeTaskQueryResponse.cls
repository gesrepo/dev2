/**
* The class contains the methods used to store Tasks coming from Wrike after a query is made in SFDC
*
* @author  Rahul Sinha
* @version 1.0
* @since   09-10-2019
*/

public class GT_WrikeTaskQueryResponse {
    
    public class CustomFields {
        public String id {get;set;} 
        public String value {get;set;} 

        public CustomFields(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getText();
                        } else if (text == 'value') {
                            value = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'CustomFields consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public String kind {get;set;} 
    public List<Data> data {get;set;} 

    public GT_WrikeTaskQueryResponse(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'kind') {
                        kind = parser.getText();
                    } else if (text == 'data') {
                        data = arrayOfData(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'GT_WrikeTaskQueryResponse consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
    public class Metadata {
        public String key {get;set;} 
        public String value {get;set;} 

        public Metadata(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'key') {
                            key = parser.getText();
                        } else if (text == 'value') {
                            value = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Metadata consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Dates {
        public String type_Z {get;set;} // in json: type
        public Integer duration {get;set;} 
        public String start {get;set;} 
        public String due {get;set;} 

        public Dates(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'type') {
                            type_Z = parser.getText();
                        } else if (text == 'duration') {
                            duration = parser.getIntegerValue();
                        } else if (text == 'start') {
                            start = parser.getText();
                        } else if (text == 'due') {
                            due = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Dates consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Data {
        public String id {get;set;} 
        public String accountId {get;set;} 
        public String title {get;set;} 
        public String description {get;set;} 
        public String briefDescription {get;set;} 
        public List<String> parentIds {get;set;} 
        public List<String> superParentIds {get;set;} 
        public List<String> sharedIds {get;set;} 
        public List<String> responsibleIds {get;set;} 
        public String status {get;set;} 
        public String importance {get;set;} 
        public String createdDate {get;set;} 
        public String updatedDate {get;set;} 
        public Dates dates {get;set;} 
        public String scope {get;set;} 
        public List<String> authorIds {get;set;} 
        public String customStatusId {get;set;} 
        public Boolean hasAttachments {get;set;} 
        public Integer attachmentCount {get;set;} 
        public String permalink {get;set;} 
        public String priority {get;set;} 
        public List<String> superTaskIds {get;set;} 
        public List<String> subTaskIds {get;set;} 
        public List<String> dependencyIds {get;set;} 
        public List<Metadata> metadata {get;set;} 
        public List<CustomFields> customFields {get;set;} 

        public Data(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getText();
                        } else if (text == 'accountId') {
                            accountId = parser.getText();
                        } else if (text == 'title') {
                            title = parser.getText();
                        } else if (text == 'description') {
                            description = parser.getText();
                        } else if (text == 'briefDescription') {
                            briefDescription = parser.getText();
                        } else if (text == 'parentIds') {
                            parentIds = arrayOfString(parser);
                        } else if (text == 'superParentIds') {
                            superParentIds = arrayOfString(parser);
                        } else if (text == 'sharedIds') {
                            sharedIds = arrayOfString(parser);
                        } else if (text == 'responsibleIds') {
                            responsibleIds = arrayOfString(parser);
                        } else if (text == 'status') {
                            status = parser.getText();
                        } else if (text == 'importance') {
                            importance = parser.getText();
                        } else if (text == 'createdDate') {
                            createdDate = parser.getText();
                        } else if (text == 'updatedDate') {
                            updatedDate = parser.getText();
                        } else if (text == 'dates') {
                            dates = new Dates(parser);
                        } else if (text == 'scope') {
                            scope = parser.getText();
                        } else if (text == 'authorIds') {
                            authorIds = arrayOfString(parser);
                        } else if (text == 'customStatusId') {
                            customStatusId = parser.getText();
                        } else if (text == 'hasAttachments') {
                            hasAttachments = parser.getBooleanValue();
                        } else if (text == 'attachmentCount') {
                            attachmentCount = parser.getIntegerValue();
                        } else if (text == 'permalink') {
                            permalink = parser.getText();
                        } else if (text == 'priority') {
                            priority = parser.getText();
                        } else if (text == 'superTaskIds') {
                            superTaskIds = arrayOfString(parser);
                        } else if (text == 'subTaskIds') {
                            subTaskIds = arrayOfString(parser);
                        } else if (text == 'dependencyIds') {
                            dependencyIds = arrayOfString(parser);
                        } else if (text == 'metadata') {
                            metadata = arrayOfMetadata(parser);
                        } else if (text == 'customFields') {
                            customFields = arrayOfCustomFields(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Data consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    
    public static GT_WrikeTaskQueryResponse parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new GT_WrikeTaskQueryResponse(parser);
    }
    
    public static void consumeObject(System.JSONParser parser) {
        Integer depth = 0;
        do {
            System.JSONToken curr = parser.getCurrentToken();
            if (curr == System.JSONToken.START_OBJECT || 
                curr == System.JSONToken.START_ARRAY) {
                depth++;
            } else if (curr == System.JSONToken.END_OBJECT ||
                curr == System.JSONToken.END_ARRAY) {
                depth--;
            }
        } while (depth > 0 && parser.nextToken() != null);
    }
    

    @TestVisible
    private static List<CustomFields> arrayOfCustomFields(System.JSONParser p) {
        List<CustomFields> res = new List<CustomFields>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new CustomFields(p));
        }
        return res;
    }


    @TestVisible
    private static List<String> arrayOfString(System.JSONParser p) {
        List<String> res = new List<String>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(p.getText());
        }
        return res;
    }

    @TestVisible
    private static List<Metadata> arrayOfMetadata(System.JSONParser p) {
        List<Metadata> res = new List<Metadata>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Metadata(p));
        }
        return res;
    }

    @TestVisible
    private static List<Data> arrayOfData(System.JSONParser p) {
        List<Data> res = new List<Data>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Data(p));
        }
        return res;
    }
}