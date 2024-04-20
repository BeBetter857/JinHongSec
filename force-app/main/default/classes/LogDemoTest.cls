@isTest
public with sharing class LogDemoTest {
    @isTest
    public static void method1(){

        Account acc = new Account();
        acc.name = '123';
        insert acc;

        List<Opportunity> opplist = new List<Opportunity>();
        Opportunity op = new Opportunity();
        op.AccountId = acc.Id;
        op.CloseDate = system.now().date();
        op.StageName = 'Request Receive';
        LogDemo.serializeOpp(opplist);


        op.Description = 'snjssssnjssssssssssssssssssssssssssssssssssssssssssssnjssssssssssssssssssssssssssssssssssssssssssssnjssssssssssssssssssssssssssssssssssssssssssssnjssssssssssssssssssssssssssssssssssssssssssssnjssssssssssssssssssssssssssssssssssssssssssssnjssssssssssssssssssssssssssssssssssssssssssssnjssssssssssssssssssssssssssssssssssssssssssssnjsssssssssnjssssssssssssssssssssssssssssssssssssssssssssnjssssssssssssssssssssssssssssssssssssssssssssnjssssssssssssssssssssssssssssssssssssssssssssnjssssssssssssssssssssssssssssssssssssssssssssnjssssssssssssssssssssssssssssssssssssssssssssnjssssssssssssssssssssssssssssssssssssssssssssnjssssssssssssssssssssssssssssssssssssssssssssnjssssssssssssssssssssssssssssssssssssssssssssnjssssssssssssssssssssssssssssssssssssssssssssnjsssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssnjssssssssssssssssssssssssssssssssssssssssssssnjssssssssssssssssssssssssssssssssssssssssssssnjssssssssssssssssssssssssssssssssssssssssssssnjssssssssssssssssssssssssssssssssssssssssssssnjssssssssssssssssssssssssssssssssssssssssssssnjssssssssssssssssssssssssssssssssssssssssssssnjssssssssssssssssssssssssssssssssssssssssssssnjssssssssssssssssssssssssssssssssssssssssssssnjssssssssssssssssssssssssssssssssssssssssssssnjssssssssssssssssssssssssssssssssssssssssssssnjssssssssssssssssssssssssssssssssssssssssssssnjssssssssssssssssssssssssssssssssssssssssssssnjssssssssssssssssssssssssssssssssssssssssssssnjssssssssssssssssssssssssssssssssssssssssssssnjsssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';

        LogDemo.serializeOpp(opplist);

    }
}