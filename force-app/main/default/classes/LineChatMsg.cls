public class LineChatMsg {

    public String destination {get;set;} 
    public List<Events> events {get;set;} 

    public LineChatMsg(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'destination') {
                        destination = parser.getText();
                    } else if (text == 'events') {
                        events = arrayOfEvents(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'LineChatMsg consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
    public class Message {
        public String type {get;set;} 
        public String id {get;set;} 
        public String quoteToken {get;set;} 
        public String text {get;set;} 

        public Message(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'type') {
                            type = parser.getText();
                        } else if (text == 'id') {
                            id = parser.getText();
                        } else if (text == 'quoteToken') {
                            quoteToken = parser.getText();
                        } else if (text == 'text') {
                            text = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Message consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Events {
        public String type {get;set;} 
        public Message message {get;set;} 
        public String webhookEventId {get;set;} 
        public DeliveryContext deliveryContext {get;set;} 
        public Long timestamp {get;set;} 
        public Source source {get;set;} 
        public String replyToken {get;set;} 
        public String mode {get;set;} 

        public Events(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'type') {
                            type = parser.getText();
                        } else if (text == 'message') {
                            message = new Message(parser);
                        } else if (text == 'webhookEventId') {
                            webhookEventId = parser.getText();
                        } else if (text == 'deliveryContext') {
                            deliveryContext = new DeliveryContext(parser);
                        } else if (text == 'timestamp') {
                            timestamp = parser.getLongValue();
                        } else if (text == 'source') {
                            source = new Source(parser);
                        } else if (text == 'replyToken') {
                            replyToken = parser.getText();
                        } else if (text == 'mode') {
                            mode = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Events consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class DeliveryContext {
        public Boolean isRedelivery {get;set;} 

        public DeliveryContext(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'isRedelivery') {
                            isRedelivery = parser.getBooleanValue();
                        } else {
                            System.debug(LoggingLevel.WARN, 'DeliveryContext consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Source {
        public String type {get;set;} 
        public String userId {get;set;} 

        public Source(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'type') {
                            type = parser.getText();
                        } else if (text == 'userId') {
                            userId = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Source consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    
    public static LineChatMsg parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new LineChatMsg(parser);
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
    private static List<Events> arrayOfEvents(System.JSONParser p) {
        List<Events> res = new List<Events>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Events(p));
        }
        return res;
    }
}