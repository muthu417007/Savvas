@IsTest
public class Savvas_SSO_UserProvisioningBatchTest {
    
    //UserList not empty and errorMap
    @isTest
    public static void BatchTest1() {
        Savvas_SSO_TestDataFactory factory = new Savvas_SSO_TestDataFactory();
        Account testAccount = factory.createAccount();
        Contact testContact = factory.createContact(testAccount.Id);
        User testUser = factory.createPortalUser(testContact);
        Blob file = Blob.valueOf('\"FirstName\",\"LastName\",\"Email\",\"accountId\",\"contactId\",\"appName\"\r\n\"Test\",\"User 1\",\"testUser@test.com\","'+testAccount.Id+'","'+testContact.Id+'",\"Worktext_Subscription\"\r\n\"Test\",\"User 2\",\"testUser@test.com\","'+testAccount.Id+'","'+testContact.Id+'",\"Worktext_Subscription\"');
            ContentVersion cv = new ContentVersion();
                cv.Title='SavvasSSODataLoad'; 
                cv.PathOnClient ='SavvasSSODataLoad.csv'; 
                cv.VersionData = file;
                cv.origin = 'H';
            insert cv;
            
            ContentVersion cv2 = [SELECT Id, Title, ContentDocumentId 
                                               FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
            
            ContentDocumentLink cd = new ContentDocumentLink();
            cd.LinkedEntityId = testAccount.id;
            cd.contentdocumentid = cv2.contentdocumentid;
            cd.ShareType = 'V';
            insert cd;
          
        Test.startTest();   
        Savvas_SSO_UserProvisioningBatch.userProvisioningIterator upi = new Savvas_SSO_UserProvisioningBatch.userProvisioningIterator();
        Savvas_SSO_UserProvisioningBatch sb = new Savvas_SSO_UserProvisioningBatch();
        Database.executeBatch(sb);
        System.assertNotEquals(null,upi);
        Test.stopTest();
    }
    
    //UserList not empty and successMap
    @isTest
    public static void BatchTest2() {
        Savvas_SSO_TestDataFactory factory = new Savvas_SSO_TestDataFactory();
        Account testAccount = factory.createAccount();
        Contact testContact = factory.createContact(testAccount.Id);
        User testUser = factory.createPortalUser(testContact);
        Blob file = Blob.valueOf('\"FirstName\",\"LastName\",\"Email\",\"accountId\",\"contactId\",\"appName\"\r\n\"Test\",\"User 1\",\"testUser@test.com\","'+testAccount.Id+'","'+testContact.Id+'",\"Worktext_Subscription\"\r\n\"Test\",\"User 2\",\"testUser@test.com\","'+testAccount.Id+'","'+testContact.Id+'",\"Worktext_Subscription\"');
            ContentVersion cv = new ContentVersion();
                cv.Title='SavvasSSODataLoad'; 
                cv.PathOnClient ='SavvasSSODataLoad.csv'; 
                cv.VersionData = file;
                cv.origin = 'H';
            insert cv;
            
            ContentVersion cv2 = [SELECT Id, Title, ContentDocumentId 
                                               FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
            
            ContentDocumentLink cd = new ContentDocumentLink();
            cd.LinkedEntityId = testAccount.id;
            cd.contentdocumentid = cv2.contentdocumentid;
            cd.ShareType = 'V';
            insert cd;
          
        Test.startTest();   
        Savvas_SSO_UserProvisioningBatch.userProvisioningIterator upi = new Savvas_SSO_UserProvisioningBatch.userProvisioningIterator();
        Savvas_SSO_UserProvisioningBatch sb = new Savvas_SSO_UserProvisioningBatch();
        Database.executeBatch(sb);
        System.assertNotEquals(null,upi);
        Test.stopTest();
    }
    
    //contactList not empty and errorMap
    @isTest
    public static void BatchTest3() { 
        Savvas_SSO_TestDataFactory factory = new Savvas_SSO_TestDataFactory();
        Account testAccount = factory.createAccount();
        Contact testContact = factory.createContact(testAccount.Id);
        User testUser = factory.createPortalUser(testContact);
        Blob file = Blob.valueOf('\"FirstName\",\"LastName\",\"Email\",\"accountId\",\"contactId\",\"appName\"\r\n\"Test\",\"User 1\",\"test@cognizant.com\","'+testAccount.Id+'","'+testContact.Id+'",\"Worktext_Subscription\"\r\n\"Test\",\"User 2\",\"test@cognizant.com\","'+testAccount.Id+'","'+testContact.Id+'",\"Worktext_Subscription\"');
            ContentVersion cv = new ContentVersion();
                cv.Title='SavvasSSODataLoad'; 
                cv.PathOnClient ='SavvasSSODataLoad.csv';
                cv.VersionData = file;
                cv.origin = 'H';
            insert cv;
            
            ContentVersion cv2 = [SELECT Id, Title, ContentDocumentId 
                                               FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
            
            ContentDocumentLink cd = new ContentDocumentLink();
            cd.LinkedEntityId = testAccount.id;
            cd.contentdocumentid = cv2.contentdocumentid;
            cd.ShareType = 'V';
            insert cd;
          
        Test.startTest();   
        Savvas_SSO_UserProvisioningBatch.userProvisioningIterator upi = new Savvas_SSO_UserProvisioningBatch.userProvisioningIterator();
        Savvas_SSO_UserProvisioningBatch sb = new Savvas_SSO_UserProvisioningBatch();
        Database.executeBatch(sb);
        System.assertNotEquals(null,upi);
        Test.stopTest();
    }
    
}