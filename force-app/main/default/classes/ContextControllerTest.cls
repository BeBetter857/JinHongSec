@isTest
public class ContextControllerTest {
    
  	@testSetup 
    static void setup() {
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
        
    	insert u;
        
       	Contact contact = new Contact();
        contact.LastName = 'test_contact';
        contact.Salutation = 'test';

        insert contact;
        System.debug('result____: ' + contact.Id);
      
        // update new user( Id = u.Id, ContactId = contact.Id);
        
    }
    
	@isTest
    public static void method1(){
        ContextController con= new ContextController();
        String result = ContextController.getContext();
        List<User> userList = [SELECT Id FROM User];
        System.debug('userList.size____: ' + userList.size());
        System.debug('result____: ' + result);
    }
    

    @isTest
    public static void method2(){
        List<User> userList = [SELECT Id,Username,ContactId FROM User WHERE Username = 'test_001@test_001.com'];
        System.assert(userList.size() > 0, '未找到用户');
        User currentUser = userList[0];
        System.debug('currentUser: ' + currentUser);
        System.runAs(currentUser){
       		String result = ContextController.getContext();
            Map<String, Object> res = (Map<String, Object>) JSON.deserializeUntyped(result);
            Object loginUser = res.get('loginUser');
     		System.debug('User: ' + JSON.serialize(loginUser));
            User con1 = (User)JSON.deserialize(JSON.serialize(loginUser), User.Class);
      		System.debug('User: ' + con1);
        }
    }
}