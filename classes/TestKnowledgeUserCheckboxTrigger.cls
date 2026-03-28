@isTest
public class TestKnowledgeUserCheckboxTrigger {
    static testMethod void testKnowledgeUserCheckboxTrue()
    {
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User(Alias = 'icomtst3', Email = 'standarduser@testorg1.com',
            EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p.Id,
            TimeZoneSidKey = 'America/Chicago', 
            UserName = 'icomtestuser3@icomtestuser.com',
            UserPermissionsKnowledgeUser = true);
        Test.startTest();
        insert u;
        Test.stopTest();
        
        User userFromServer = [Select Id, Knowledge_License__c from User where Id=:u.id limit 1];
        System.assertEquals(userFromServer.Knowledge_License__c, true);
    }
    static testMethod void testKnowledgeUserCheckboxFalse()
    {
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User(Alias = 'icomtst2', Email = 'standarduser@testorg1.com',
            EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p.Id,
            TimeZoneSidKey = 'America/Chicago', 
            UserName = 'icomtestuser2@icomtestuser.com',
            UserPermissionsKnowledgeUser = false);
        Test.startTest();
        insert u;
        Test.stopTest();
        
        User userFromServer = [Select Id, Knowledge_License__c from User where Id=:u.id limit 1];
        System.assertEquals(userFromServer.Knowledge_License__c, false);
    }
    
}