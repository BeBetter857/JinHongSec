trigger LiveChatTranscriptTrigger on LiveChatTranscript (before update) {

    System.debug(LoggingLevel.INFO, '*** ..... : ' );
    
    if(trigger.isBefore && trigger.isUpdate){
        Set<String> lineUserIdSet = new Set<String>();
        for(LiveChatTranscript liveChat : Trigger.new){
            if(String.isNotBlank(liveChat.Line_User_Id__c)){
                lineUserIdSet.add(liveChat.Line_User_Id__c);
            }
        }
        Set<String> integrationIdSet = new Set<String>();
        List<Account> accountlist = [SELECT Id,Integration_Id__c FROM Account WHERE Integration_Id__c IN :lineUserIdSet];
        for(Account account : accountlist){
            integrationIdSet.add(account.Integration_Id__c);
        }
        Map<String,Account> accountIdMap = new Map<String,Account>();
        accountlist = new List<Account>();
        for(LiveChatTranscript liveChat : Trigger.new){
            if(String.isNotBlank(liveChat.Line_User_Id__c) && !integrationIdSet.contains(liveChat.Line_User_Id__c)){
                Account account = new Account();
                account.Name = 'TESTUSER';
                account.Integration_Id__c = liveChat.Line_User_Id__c;
                accountlist.add(account);
                accountIdMap.put(account.Integration_Id__c, account);
            }
        }
        insert accountlist;
        System.debug(LoggingLevel.INFO, '*** accountlist : ' + accountlist);
        
        for(LiveChatTranscript liveChat : Trigger.new){
            if(String.isNotBlank(liveChat.Line_User_Id__c) && !integrationIdSet.contains(liveChat.Line_User_Id__c)){
                liveChat.AccountId = accountIdMap.get(liveChat.Line_User_Id__c).Id;
            }
            System.debug(LoggingLevel.INFO, '*** liveChat : ' + liveChat);
        }
    }
}