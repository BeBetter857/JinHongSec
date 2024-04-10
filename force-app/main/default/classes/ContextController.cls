public with sharing class ContextController {
  public ContextController() {
  }
  // カスタム設定などからEC用の設定を取得する。
  @AuraEnabled(cacheable=true)
  public static String getContext() {
    String uid = UserInfo.getUserId();
    User loginUser = [
      SELECT ContactId,username 
      FROM User
      WHERE Id =: uid 
      LIMIT 1
    ];
    Organization orgInfo = [
        SELECT Phone, Name, Street, City, State, PostalCode, Fax
        FROM Organization
        LIMIT 1
      ];

    Map<String, Object> res = new Map<String, Object>();
    res.put('uid', uid);
    res.put('orgInfo', orgInfo);
    res.put('loginUser', loginUser);

    return JSON.serialize(res);
  }
}