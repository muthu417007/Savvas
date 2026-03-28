global class TitanUtility{

webService static String getCredential(String userName) {
   User user = [Select Titan_User_Name__c, Titan_Password__c from User where username = :userName LIMIT 1];
   Map<String, String> result = new Map<String, String>{'userName' => user.Titan_User_Name__c, 'password' => user.Titan_Password__c};
   
   return JSON.serialize(result);
 }

webService static void saveCredential(String userName, String titanUserName, String titanPassword) {
   User user = [Select Titan_User_Name__c, Titan_Password__c from User where username = :userName LIMIT 1];
   user.Titan_User_Name__c = titanUserName;
   user.Titan_Password__c = titanPassword;
   update user;
 }
}