@isTest
public class EC_ResponseTest {
	
    @isTest
    public static void method1(){
        Profile p = [Select Id, Name from Profile where Name = 'System Administrator'];
        User u = new user(
            email = 'test_001@tes.com', 
            username='test_001@test_001.com', 
            Alias = 'sta001',
            EmailEncodingKey='UTF-8',
            TimeZoneSidKey = 'Asia/Shanghai',
            LocaleSidKey = 'zh_CN',
            LanguageLocaleKey = 'zh_CN',
            ProfileId = p.Id,
            IsActive=true
        );
        try{
           insert u;
        }catch(Exception e){
			EC_Response response = new EC_Response();
            response.setException(e);
            System.debug('response : ' + response);  
        }
    }
    
    @isTest
    public static void method2(){
   		Profile p = [Select Id, Name from Profile where Name = 'System Administrator'];
        User u = new user(
            Lastname = 'TestLastname_001', 
            email = 'test_001@tes.com', 
            username='test_001@test_001.com', 
            Alias = 'sta001',
            EmailEncodingKey='UTF-8',
            TimeZoneSidKey = 'Asia/Shanghai',
            LocaleSidKey = 'zh_CN',
            LanguageLocaleKey = 'zh_CN',
            ProfileId = p.Id,
            IsActive=true
        );
        try{
           insert u;
           EC_Response response = new EC_Response();
           response.setMessage('Success');
           response.setSuccess(true);
           System.debug('response : ' + response); 
        }catch(Exception e){
			EC_Response response = new EC_Response();
            response.setException(e);
            System.debug('response : ' + response);  
        }
    }
    
}