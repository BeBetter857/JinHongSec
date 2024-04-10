public with sharing class ContactService {
   public static void getContacts(){
        HttpRequest httpReq = new HttpRequest();
        httpReq.setEndpoint('https://empathetic-narwhal-ry10b2-dev-ed.my.salesforce.com/services/apexrest/Contact');
        httpReq.setMethod('GET');
       	String sessionId = getAccessToken();
       	httpReq.setHeader('Authorization', 'Bearer ' + sessionId);
        httpReq.setTimeout(120000);
        Http http = new Http();
        HTTPResponse httpRes = http.send(httpReq);
       if(httpRes.getBody() != null){
           List<Contact> contactList = new List<Contact>();
           contactList = (List<Contact>)Json.deserialize(httpRes.getBody(), List<Contact>.class);
           for(Contact contact : contactList){
               System.debug(contact);
           }	
         } 
        System.debug(LoggingLevel.INFO, '*** getStatus(): ' + httpRes.getStatus());
        System.debug(LoggingLevel.INFO, '*** getStatus(): ' + httpRes.getStatusCode());
        System.debug(LoggingLevel.INFO, '*** getStatus(): ' + httpRes.getBody());
   }

    public static String getAccessToken(){
        String username = 'irving.7758520@empathetic-narwhal-ry10b2.com';
        String password = '5211225@zjh';
        String securityToken = 'your_security_token';

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://empathetic-narwhal-ry10b2-dev-ed.my.salesforce.com/services/oauth2/token');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setBody('grant_type=password&client_id=3MVG9fe4g9fhX0E4lh3F8w63MkY942AY6bRzBxB2Iseh.kuRqzgp.kPj6cWzIGUgWIruSP4H_VGNH1zMkFVzV&client_secret=B55FB227F7909308715A223FD0E9B2A9EACD82AAE742C03AB10DC55D8EDC8A66&username=' + username + '&password=' + password );

        HttpResponse response = http.send(request);
        System.debug(LoggingLevel.INFO, '*** response: ' + response);
        if (response.getStatusCode() == 200) {
            System.debug(LoggingLevel.INFO, '*** response.getBody(): ' + response.getBody());
              Map<String, String> responseBody = (Map<String, String>)JSON.deserialize(response.getBody(), Map<String, String>.class);
    		  System.debug(LoggingLevel.INFO, '*** accessToken: ' + responseBody.get('access_token'));
              return responseBody.get('access_token');
        }else{
            return 'can not find access_token';
        }
    }

}