public without sharing class LineChatController {
    public LineChatController() {

    }

    @AuraEnabled
    public static void agentReplyToLineUser(String recordId, List<Message> messageList){
        // String endpoint = 'https://api.line.me/v2/bot/message/reply';
        String endpoint = 'https://api.line.me/v2/bot/message/push';
        String strAuthorizationHeader = 'Bearer ESegW9fiavQL3jpI6jNVARJMHEyviZHYmNKOMBoIWtATEVG+VKUUo50yDmShSclmtpYjLsy4cldDskgH3oXmZTGdEnBglRxWnwP2Yb5y7AX3i+Wpmkiv6huFkPmN1XoiT7bNkqvOAG7Fv8b+8lYqJAdB04t89/1O/w1cDnyilFU=';

        System.debug(LoggingLevel.INFO, '*** recordId : ' + recordId);
        System.debug(LoggingLevel.INFO, '*** messageList : ' + messageList);

        LiveChatTranscript livechat = [SELECT Id,replyToken__c,Line_User_Id__c FROM LiveChatTranscript WHERE Id = :recordId];

        System.debug(LoggingLevel.INFO, '*** livechat : ' + livechat);
        

        ReplyMessage objReplyMessage = new ReplyMessage();
        objReplyMessage.to = livechat.Line_User_Id__c;
        objReplyMessage.messages = messageList;

        Http http = new Http(); 
        HttpRequest req = new HttpRequest(); 
        req.setMethod('POST');
        req.setEndPoint(endpoint);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', strAuthorizationHeader);
        req.setHeader('X-Line-Retry-Key', String.valueOf(UUID.randomUUID()));

        System.debug(LoggingLevel.INFO, '*** body : ' + JSON.serialize(objReplyMessage));
        
        

        // System.debug(LoggingLevel.INFO, '*** JSON.serialize(objReplyMessage) : ' + JSON.serialize(objReplyMessage));
        
        // req.setBody(JSON.serialize(objReplyMessage));
        req.setBody(JSON.serialize(objReplyMessage));
        HttpResponse res = http.send(req);
        System.debug(LoggingLevel.INFO, '*** response.getBody() : ' + res.getBody());
    }

    public class ReplyMessage {
        // @AuraEnabled
        // public String replyToken {get; set;}
        @AuraEnabled
        public String to {get; set;}
        @AuraEnabled
        public List<Message> messages {get; set;}
    }   

    public class Message{
        @AuraEnabled
        public String type {get; set;}
        @AuraEnabled
        public String text {get; set;}
    }

}