@isTest
private class TitanUtilityTest{
    private static void createTestUser() {
        User testUser = new User();
        testUser.Username= 'titanTestUser1@liveops.com';
        testUser.Email = 'titanTestUser1@liveops.com';
        testUser.Lastname = 'user';
        testUser.Firstname = 'test';
        testUser.Alias = 'test';
        testUser.CommunityNickname = '12346';
        testUser.UserRole = [ select id from userrole LIMIT 1 ];
        SObject prof = [select id, name from profile where name like '%ICOM Sales%' Limit 1];
        testUser.ProfileId = (ID) prof.get('ID');
        testUser.TimeZoneSidKey = 'GMT';
        testUser.LocaleSidKey = 'en_US';
        testUser.EmailEncodingKey = 'ISO-8859-1';
        testUser.LanguageLocaleKey = 'en_US';
        testUser.UserPermissionsMobileUser = false;
        
        testUser.Titan_User_Name__c = 'titan';
        testUser.Titan_Password__c = 'password';
        
        System.debug ( JSON.serializePretty( testUser ) );
        
        insert testUser;
    }

    static testMethod void testGetCredential(){
        createTestUser();

        String userJsonString = TitanUtility.getCredential('titanTestUser1@liveops.com');
        Map<String, String> userJson = (Map<String, String>)JSON.deserialize(userJsonString, Map<String, String>.class);
        
        System.assertEquals('titan', userJson.get('userName'));
        System.assertEquals('password', userJson.get('password'));
    }
    
    static testMethod void testSaveCredential(){
        createTestUser();

        TitanUtility.saveCredential('titanTestUser1@liveops.com', 'titan-new', 'password-new');
        User user = [Select Titan_User_Name__c, Titan_Password__c from User where username = 'titanTestUser1@liveops.com' LIMIT 1];
        
        System.assertEquals('titan-new', user.Titan_User_Name__c);
        System.assertEquals('password-new', user.Titan_Password__c);
    }
}