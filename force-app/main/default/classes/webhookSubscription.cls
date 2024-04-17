@RestResource (urlMapping='/api/Webhooks/incoming/pushDetails/*')
global without sharing class webhookSubscription {

    global static String ChannelAccessToken = 'ESegW9fiavQL3jpI6jNVARJMHEyviZHYmNKOMBoIWtATEVG+VKUUo50yDmShSclmtpYjLsy4cldDskgH3oXmZTGdEnBglRxWnwP2Yb5y7AX3i+Wpmkiv6huFkPmN1XoiT7bNkqvOAG7Fv8b+8lYqJAdB04t89/1O/w1cDnyilFU=';

    @HttpPost
    global static void handleNotification() {
        RestRequest request = RestContext.request;
        Blob blobData =  request.requestBody;
        String blobString = blobData.toString();
        System.debug(LoggingLevel.INFO, '*** blobString : ' + blobString);

        LineChatMsg LineChatMsg = (LineChatMsg) JSON.deserialize(blobString, LineChatMsg.class);

        if(LineChatMsg != null){
            String lineUserId = LineChatMsg.events[0].source.userId;
            LineUserInfo lineUser = getLineUserInfo(lineUserId);

            List<LiveChatTranscript> liveChatTranscriptList = [SELECT Id,ChatKey,LiveAgent_Affinity__c,LIVEAGENT_SEQUENCE__c,LIVEAGENT_SESSION_KEY__c FROM LiveChatTranscript WHERE Line_User_Id__c = 'Uad86f73982c2132a4d04b25fe92d61dc' AND Status = 'InProgress' Order By CreatedDate DESC Limit 1];

            System.debug(LoggingLevel.INFO, '*** liveChatTranscriptList : ' + liveChatTranscriptList);
            

            if(liveChatTranscriptList != null && liveChatTranscriptList.size() > 0){
                System.debug(LoggingLevel.INFO, '*** aleardy lineUser : ' + lineUser);
                String chatEndpoint = 'https://d.la2-c2-ukb.salesforceliveagent.com/chat/rest/Chasitor/ChatMessage/';
                Http http = new Http(); 
                HttpRequest req = new HttpRequest(); 
                req.setMethod('GET');
                req.setEndPoint(chatEndpoint);
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('X-LIVEAGENT-AFFINITY', liveChatTranscriptList[0].LiveAgent_Affinity__c);
                req.setHeader('X-LIVEAGENT-API-VERSION', '56');
                req.setHeader('X-LIVEAGENT-SEQUENCE', String.valueOf(Integer.valueOf(liveChatTranscriptList[0].LIVEAGENT_SEQUENCE__c + 1)));
                req.setHeader('X-LIVEAGENT-SESSION-KEY', liveChatTranscriptList[0].LIVEAGENT_SESSION_KEY__c);

                string AFFINITY = req.getHeader('X-LIVEAGENT-AFFINITY');
                string VERSION = req.getHeader('X-LIVEAGENT-API-VERSION');
                string SEQUENCE = req.getHeader('X-LIVEAGENT-SEQUENCE');

                System.debug(LoggingLevel.INFO, '*** AFFINITY : ' + AFFINITY);
                System.debug(LoggingLevel.INFO, '*** VERSION : ' + VERSION);
                System.debug(LoggingLevel.INFO, '*** SEQUENCE : ' + SEQUENCE);
                


                SFChatMSG sfmsg = new SFChatMSG();
                sfmsg.text = LineChatMsg.events[0].message.text;
                System.debug(LoggingLevel.INFO, '*** sfmsg : ' + sfmsg);
                req.setBody(JSON.serialize(sfmsg));
                HttpResponse res2 = http.send(req);
                System.debug(LoggingLevel.INFO, '*** res.getBody() : ' + res2.getBody());
                if(res2.getStatusCode() == 200){ 
                    liveChatTranscriptList[0].LIVEAGENT_SEQUENCE__c +=1;
                    update liveChatTranscriptList;
                }
    
            }else{
                System.debug(LoggingLevel.INFO, '*** lineUser : ' + lineUser);
                String chatEndpoint = 'https://d.la2-c2-ukb.salesforceliveagent.com/chat/rest/System/SessionId/';
                Http http = new Http(); 
                HttpRequest req = new HttpRequest(); 
                req.setMethod('GET');
                req.setEndPoint(chatEndpoint);
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('X-LIVEAGENT-AFFINITY', 'null');
                req.setHeader('X-LIVEAGENT-API-VERSION', '56');
                HttpResponse res = http.send(req);
                System.debug(LoggingLevel.INFO, '*** res.getBody() : ' + res.getBody());
                if(res.getStatusCode() == 200){
    
                    ChatSession chatSession = (ChatSession)JSON.deserialize(res.getBody(), ChatSession.class);
                    System.debug(LoggingLevel.INFO, '*** chatSession : ' + chatSession);
                    
                    String chatEndpoint2 = 'https://d.la2-c2-ukb.salesforceliveagent.com/chat/rest/Chasitor/ChasitorInit';
                    Http http2 = new Http(); 
                    HttpRequest req2 = new HttpRequest(); 
                    req2.setMethod('POST');
                    req2.setEndPoint(chatEndpoint2);
                    req2.setHeader('X-LIVEAGENT-AFFINITY', chatSession.affinityToken);
                    req2.setHeader('X-LIVEAGENT-SESSION-KEY', chatSession.key);
                    req2.setHeader('X-LIVEAGENT-SEQUENCE', '1');
                    req2.setHeader('X-LIVEAGENT-API-VERSION', '56');
    
                    ChasitorInit chasitorInit = new ChasitorInit();
                    chasitorInit.organizationId = '00D2w00000RrKXj';
                    chasitorInit.deploymentId = '5722w000000MLJ8';
                    chasitorInit.sessionId = chatSession.id;
                    chasitorInit.buttonId = '5732w000000MOlq';
                    chasitorInit.screenResolution = '1900x1080';
                    chasitorInit.userAgent = 'Postman';
                    chasitorInit.language = 'en-US';
                    chasitorInit.visitorName = 'Test Contact';
                    chasitorInit.receiveQueueUpdates = true;
                    chasitorInit.isPost = true;
                    System.debug(LoggingLevel.INFO, '*** chasitorInit : ' + JSON.serialize(chasitorInit));
                    
                    CustomDetail customDetail = new CustomDetail();
                    customDetail.label = 'replyToken';
                    customDetail.value = LineChatMsg.events[0].source.userId;
                    customDetail.transcriptFields = new List<String>{'replyToken__c'};
    
                    CustomDetail customDetail2 = new CustomDetail();
                    customDetail2.label = 'LineUserId';
                    customDetail2.value = lineUser.userId;
                    customDetail2.transcriptFields = new List<String>{'Line_User_Id__c'};
    
                    CustomDetail customDetail3 = new CustomDetail();
                    customDetail3.label = 'LiveAgentAffinity';
                    customDetail3.value = chatSession.affinityToken;
                    customDetail3.transcriptFields = new List<String>{'LiveAgent_Affinity__c'};

                    CustomDetail customDetail4 = new CustomDetail();
                    customDetail4.label = 'LIVEAGENT_SEQUENCE__c';
                    customDetail4.value = '2';
                    customDetail4.transcriptFields = new List<String>{'LIVEAGENT_SEQUENCE__c'};

                    CustomDetail customDetail5 = new CustomDetail();
                    customDetail5.label = 'LIVEAGENT_SESSION_KEY__c';
                    customDetail5.value = chatSession.key;
                    customDetail5.transcriptFields = new List<String>{'LIVEAGENT_SESSION_KEY__c'};
    
                    chasitorInit.prechatDetails = new List<CustomDetail>{customDetail, customDetail2, customDetail3, customDetail4, customDetail5};                
                    req2.setBody(JSON.serialize(chasitorInit));

                    HttpResponse res2 = http2.send(req2);
                    
                    System.debug(LoggingLevel.INFO, '*** res2.getBody() : ' + res2.getBody());


                    String chatEndpoint3 = 'https://d.la2-c2-ukb.salesforceliveagent.com/chat/rest/Chasitor/ChatMessage/';
                    Http http3 = new Http(); 
                    HttpRequest req3 = new HttpRequest(); 
                    req3.setMethod('GET');
                    req3.setEndPoint(chatEndpoint3);
                    req3.setHeader('Content-Type', 'application/json');
                    req3.setHeader('X-LIVEAGENT-AFFINITY', chatSession.affinityToken);
                    req3.setHeader('X-LIVEAGENT-API-VERSION', '56');
                    req3.setHeader('X-LIVEAGENT-SEQUENCE', '2');
                    req3.setHeader('X-LIVEAGENT-SESSION-KEY', chatSession.key);
                    SFChatMSG sfmsg = new SFChatMSG();
                    sfmsg.text = LineChatMsg.events[0].message.text;
                    req3.setBody(JSON.serialize(sfmsg));
                    HttpResponse res3 = http3.send(req3);
                    System.debug(LoggingLevel.INFO, '*** res3.getBody() : ' + res3.getBody());
                    if(res3.getStatusCode() == 200){ 
    
                    }
                }else{
                    
                }
            }
        }
    }


    public static LineUserInfo getLineUserInfo(String userId){
        String chatEndpoint = 'https://api.line.me/v2/bot/profile/' + userId;
        Http http = new Http(); 
        HttpRequest req = new HttpRequest(); 
        req.setMethod('GET');
        req.setEndPoint(chatEndpoint);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + ChannelAccessToken);
        HttpResponse res = http.send(req);
        LineUserInfo lineUserInfo = (LineUserInfo)JSON.deserialize(res.getBody().toString(), LineUserInfo.class);
        System.debug(LoggingLevel.INFO, '*** res.get : ' + res.getBody());
        return lineUserInfo;
    }



    public class ChatSession{
        @AuraEnabled
        public String key = '';
        @AuraEnabled
        public String id = '';
        @AuraEnabled
        public Decimal clientPollTimeout;
        @AuraEnabled
        public String affinityToken = '';
    }

    public class ChasitorInit{
        @AuraEnabled
        public String organizationId = '';
        @AuraEnabled
        public String deploymentId = '';
        @AuraEnabled
        public String buttonId = '';
        // @AuraEnabled
        // public String agentId = '';
        // @AuraEnabled
        // public Boolean doFallback = false;
        @AuraEnabled
        public String sessionId = '';
        @AuraEnabled
        public String userAgent = '';
        @AuraEnabled
        public String language = '';
        @AuraEnabled
        public String screenResolution = '';
        @AuraEnabled
        public String visitorName = '';
        @AuraEnabled
        public List<CustomDetail> prechatDetails = new List<CustomDetail>();
        @AuraEnabled
        public List<Entity> prechatEntities = new List<Entity>();
        // @AuraEnabled
        // public List<String> buttonOverrides = new List<String>();
        @AuraEnabled
        public Boolean receiveQueueUpdates = false;
        @AuraEnabled
        public Boolean isPost = false;
    }
    public class CustomDetail{
        @AuraEnabled
        public String label = '';
        @AuraEnabled
        public String value = '';
        @AuraEnabled
        public List<String> transcriptFields = new List<String>();
        @AuraEnabled
        public Boolean displayToAgent = true;
    }
    
    public class Entity{
        @AuraEnabled
        public String entityName = '';
        @AuraEnabled
        public String linkToEntityName = '';
        @AuraEnabled
        public String linkToEntityField = '';
        @AuraEnabled
        public String saveToTranscript = '';
        @AuraEnabled
        public Boolean showOnCreate = false;
        @AuraEnabled
        public List<EntityFieldsMaps> entityFieldsMaps = new List<EntityFieldsMaps>();

    }
    public class EntityFieldsMaps{
        @AuraEnabled
        public String fieldName = '';
        @AuraEnabled
        public String label = '';
        @AuraEnabled
        public Boolean doFind = false;
        @AuraEnabled
        public Boolean isExactMatch = false;
        @AuraEnabled
        public Boolean doCreate = false;
    }

    public class LineUserInfo{
        @AuraEnabled
        public String userId {get; set;}
        @AuraEnabled
        public String displayName {get; set;}
        @AuraEnabled
        public String language {get; set;}
    }


    public class SFChatMSG{
        @AuraEnabled
        public String text {get; set;}
    }
}