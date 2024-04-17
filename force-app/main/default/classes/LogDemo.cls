public with sharing class LogDemo {
    @InvocableMethod(label='serializeOpp' description='serializeOpp')
    public static List<String> serializeOpp(List<Opportunity> opportunity){
        String jsonStr = JSON.serialize(opportunity).length() > 131000 ? JSON.serialize(opportunity).substring(0, 131000) : JSON.serialize(opportunity);
        System.debug(LoggingLevel.INFO, '*** jsonStr : ' + jsonStr);
        return new List<String>{jsonStr};
    }
}