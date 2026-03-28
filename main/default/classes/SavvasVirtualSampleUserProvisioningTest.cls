/*
    @Author : Cognizant Team
    @Name : SavvasVirtualSampleUserProvisioningTest
    @CreateDate : 16-Aug-2024
    @Description: Test class for SavvasVirtualSampleUserProvisioning and SavvasVirtualSampleUserProvHelper class
    @ModifiedBy: Cognizant Team
    @ModifiedDate: 16-Aug-2024
    @Ticket Number: W-013769,W-014602,W-015376
*/
@isTest
public class SavvasVirtualSampleUserProvisioningTest {
    @testSetup static void setup() {
        	UserRole role=[SELECT Id from UserRole where name='CEO' Limit 1];
        Profile profile = [SELECT Id FROM Profile where Name='System Administrator'];
        User systemAdmin = SavvasVirtualSamplingTestFactory.getUser(profile.Id);
        systemAdmin.UserRoleId = role.Id;
        Insert systemAdmin;
        System.runAs(systemAdmin){

            Account newAccount = SavvasVirtualSamplingTestFactory.getAccount();
            insert newAccount;
            
            List<Contact> contactList = new list<Contact>(); 
            Contact newContact = SavvasVirtualSamplingTestFactory.getContact(newAccount.Id);
            newContact.Email = 'Testdummy@test9012.com';
            newContact.UCID__c ='Test1';
            contactList.add(newContact);
            Contact newContact1 = SavvasVirtualSamplingTestFactory.getContact(newAccount.Id);
            newContact1.Email = 'Testdummy@test901.com';
            newContact1.UCID__c ='Test2';
            contactList.add(newContact1);
            Contact newContact2 = SavvasVirtualSamplingTestFactory.getContact(newAccount.Id);
            newContact2.Email = 'Testdummy@test90.com';
            newContact2.UCID__c ='Test3';
            contactList.add(newContact2);
            Contact newContact3 = SavvasVirtualSamplingTestFactory.getContact(newAccount.Id);
            newContact3.Email = 'Testdummy@test902.com';
            newContact3.UCID__c ='Test4';
            contactList.add(newContact3);
            Contact newContact4 = SavvasVirtualSamplingTestFactory.getContact(newAccount.Id);
            newContact4.Email = 'Testdummy@test100.com';
            newContact4.UCID__c ='Test5';
            contactList.add(newContact4);
            insert contactList;
            
            String profileName = Label.Savvas_Sample_Resources_Profile;
            Profile profile1 = [SELECT Id FROM Profile WHERE Name='Savvas External Users Base Profile'];//W-014602 SSO App Management
            System.debug(profile1);
            Profile profile2 = [SELECT Id,Name from Profile where Name = 'Community Connection External User'];
            System.debug(profile2);
            List<User> userList = new List<User>();
            User newUser = SavvasVirtualSamplingTestFactory.getUser(profile1.Id);
            newUser.userName = 'Testdummy@test901.com';
            newUser.ContactId = contactList[1].Id;
            userList.add(newUser);
            User newUser1 = SavvasVirtualSamplingTestFactory.getUser(profile1.Id);
            newUser1.userName = 'Testdummy@test90.com';
            newUser1.Email = 'Testdummy@test90.com';
            newUser1.ContactId = contactList[2].Id;
            userList.add(newUser1);
            
            User newUser2 = SavvasVirtualSamplingTestFactory.getUser(profile1.Id);
            newUser2.UserName = 'Testdummy@test902.com';
            newUser2.ContactId = contactList[3].Id;
            userList.add(newUser2);
            Insert userList;
            List<PermissionSetAssignment> psaList = new List<PermissionSetAssignment>();
            PermissionSet permissionSet1 = [SELECT id FROM PermissionSet WHERE Name=: Label.Savvas_Sample_Resources_Permission_Set];
            PermissionSet permissionSet2 = [SELECT id FROM PermissionSet WHERE Name=: 'Savvas_Customer_Care_External_Users_Permissions'];
            PermissionSetAssignment psa = SavvasVirtualSamplingTestFactory.CreatePermissionSetAssignment(permissionSet1.Id, userList[1].Id);
            PermissionSetAssignment psa1 = SavvasVirtualSamplingTestFactory.CreatePermissionSetAssignment(permissionSet1.Id, userList[2].Id);
            psaList.add(psa);
            psaList.add(psa1);
            Insert psaList;
            
            List<Collection_Access__c> collectionAccessList = new List<Collection_Access__c>();
            Collection_Access__c newCollectionAccess =  SavvasVirtualSamplingTestFactory.createCollectionAccess(contactList[1].Id);
            newCollectionAccess.Name = 'My xyz Materials';
            newCollectionAccess.Collection_Id__c = '2345';
            collectionAccessList.add(newCollectionAccess);
            Collection_Access__c newCollectionAccess1 =  SavvasVirtualSamplingTestFactory.createCollectionAccess(contactList[1].Id);
            newCollectionAccess1.Name = 'My sample Materials';
            newCollectionAccess1.Collection_Id__c = '2345';
            collectionAccessList.add(newCollectionAccess1);
            
            Collection_Access__c newCollectionAccess2 =  SavvasVirtualSamplingTestFactory.createCollectionAccess(contactList[3].Id);
            newCollectionAccess2.Name = 'My xyz Materials';
            newCollectionAccess2.Collection_Id__c = '2345';
            collectionAccessList.add(newCollectionAccess2);
            Collection_Access__c newCollectionAccess3 =  SavvasVirtualSamplingTestFactory.createCollectionAccess(contactList[3].Id);
            newCollectionAccess3.Name = 'My sample Materials';
            newCollectionAccess3.Collection_Id__c = '2345';
            collectionAccessList.add(newCollectionAccess3);
            
            Collection_Access__c newCollectionAccess4 =  SavvasVirtualSamplingTestFactory.createCollectionAccess(contactList[4].Id);
            newCollectionAccess4.Name = 'My xyz Materials';
            newCollectionAccess4.Collection_Id__c = '2345';
            collectionAccessList.add(newCollectionAccess4);
            Collection_Access__c newCollectionAccess5 =  SavvasVirtualSamplingTestFactory.createCollectionAccess(contactList[4].Id);
            newCollectionAccess5.Name = 'My abc Materials';
            newCollectionAccess5.Collection_Id__c = '4567';
            collectionAccessList.add(newCollectionAccess5);
            insert collectionAccessList;
            
            List<Sitecore_Asset__c> sitecoreAssetList = new List<Sitecore_Asset__c>();
            Sitecore_Asset__c newSARecord = SavvasVirtualSamplingTestFactory.createSitecoreAsset(contactList[1].Id, collectionAccessList[0].Id);
            sitecoreAssetList.add(newSARecord);
            Sitecore_Asset__c newSARecord1 = SavvasVirtualSamplingTestFactory.createSitecoreAsset(contactList[1].Id, collectionAccessList[1].Id);
            sitecoreAssetList.add(newSARecord1);
            
            Sitecore_Asset__c newSARecord2 = SavvasVirtualSamplingTestFactory.createSitecoreAsset(contactList[3].Id, collectionAccessList[2].Id);
            sitecoreAssetList.add(newSARecord2);
            Sitecore_Asset__c newSARecord3 = SavvasVirtualSamplingTestFactory.createSitecoreAsset(contactList[3].Id, collectionAccessList[3].Id);
            sitecoreAssetList.add(newSARecord3);
            
            Sitecore_Asset__c newSARecord4 = SavvasVirtualSamplingTestFactory.createSitecoreAsset(contactList[4].Id, collectionAccessList[4].Id);
            sitecoreAssetList.add(newSARecord4);
            Sitecore_Asset__c newSARecord5 = SavvasVirtualSamplingTestFactory.createSitecoreAsset(contactList[4].Id, collectionAccessList[4].Id);
            sitecoreAssetList.add(newSARecord5);
            Sitecore_Asset__c newSARecord6 = SavvasVirtualSamplingTestFactory.createSitecoreAsset(contactList[4].Id, collectionAccessList[5].Id);
            sitecoreAssetList.add(newSARecord6);
            Insert sitecoreAssetList;
        }
    }
    //contact not found
    @isTest
    public static void validateContact(){
        List<Account> acc = [SELECT ID from Account where Name='TestParentAccount'];
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/userregistration';
        req.httpMethod = 'Post';
        req.requestBody=Blob.valueOf('{ "firstName": "Test", "lastName": "Test", "email": "new.Test@test.com", "collectionId": "1091", "productOfInterest": "My xyz Materials", "collectionName": "", "collectionDetails": [ { "entityId": "32139", "assetName": "Access Guide", "thumbnailId": "ebc450df684f405ea35df3afe7415f0d?v=3dd83a7f" } ] , "accountId":"' + acc[0].ID + '" }');
        RestContext.request = req;
        RestContext.response= res;
        SavvasVirtualSampleUserProvisioning.validateContact(); 
        String responseBody = res.responseBody.toString();
        SavvasVirtualSampleUserProvisioning.APIResponseBody responseDetails = (SavvasVirtualSampleUserProvisioning.APIResponseBody)JSON.deserialize(responseBody, SavvasVirtualSampleUserProvisioning.APIResponseBody.class);
        Assert.areEqual(0, responseDetails.statusCode,'Expected and Actual are not same ' + responseDetails);
    }
    //new user for 1.0
    @isTest
    public static void validateContactExist(){
        List<Account> acc = [SELECT ID from Account where Name='TestParentAccount'];
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/userregistration';
        req.httpMethod = 'Post';
        req.requestBody=Blob.valueOf('{ "firstName": "Test", "lastName": "Test", "email": "Testdummy@test9012.com","programType":"1.0", "collectionId": "9089", "productOfInterest": "My xyz Materials", "collectionName": "", "collectionDetails": [ { "entityId": "32139", "assetName": "Access Guide", "thumbnailId": "ebc450df684f405ea35df3afe7415f0d?v=3dd83a7f" } ], "accountId":"' + acc[0].ID + '" }');
        RestContext.request = req;
        RestContext.response= res;
        SavvasVirtualSampleUserProvisioning.validateContact();  
        String responseBody = res.responseBody.toString();
        SavvasVirtualSampleUserProvisioning.APIResponseBody responseDetails = (SavvasVirtualSampleUserProvisioning.APIResponseBody)JSON.deserialize(responseBody, SavvasVirtualSampleUserProvisioning.APIResponseBody.class);
        Assert.areEqual(1, responseDetails.statusCode,'Expected and Actual are not same ' + responseDetails);
    }
    //existing user 
    @isTest
    public static void validateContactExist2(){
        UserRole role=[SELECT Id from UserRole where name='CEO' Limit 1];
        Profile profile = [SELECT Id FROM Profile where Name='System Administrator'];
        User systemAdmin = SavvasVirtualSamplingTestFactory.getUser(profile.Id);
        systemAdmin.UserRoleId = role.Id;
        Insert systemAdmin;
        System.runAs(systemAdmin){
        List<Account> acc = [SELECT ID from Account where Name='TestParentAccount'];
        List<Contact> contactList = new list<Contact>(); 
        Contact newContact = SavvasVirtualSamplingTestFactory.getContact(acc[0].Id);
        newContact.Email = 'Testdummy@test9999.com';
        newContact.UCID__c ='Test99';
        contactList.add(newContact);
        Insert contactList;
        Collection_Access__c newCollectionAccess =  SavvasVirtualSamplingTestFactory.createCollectionAccess(contactList[0].Id);
        newCollectionAccess.Name = 'My xyz Materials';
        newCollectionAccess.Collection_Id__c='12345';
        Insert newCollectionAccess;
        String profileName = Label.Savvas_Single_Sign_On_Profile;
        Profile profile1 = [SELECT Id FROM Profile WHERE Name=: profileName];
        List<User> userList = new List<User>();
        User newUser = SavvasVirtualSamplingTestFactory.getUser(profile1.Id);
        newUser.userName = 'Testdummy@test9999.com';
        newUser.ContactId = contactList[0].Id;
        userList.add(newUser);
        Insert userList;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/userregistration';
        req.httpMethod = 'Post';
        req.requestBody=Blob.valueOf('{ "firstName": "Test", "lastName": "Test", "email": "Testdummy@test9999.com","programType":"1.0", "collectionId": "12345", "productOfInterest": "My xyz Materials", "collectionName": "", "collectionDetails": [ { "entityId": "32139", "assetName": "Access Guide", "thumbnailId": "ebc450df684f405ea35df3afe7415f0d?v=3dd83a7f" } ], "accountId":"' + acc[0].ID + '" }');
        RestContext.request = req;
        RestContext.response= res;
        SavvasVirtualSampleUserProvisioning.validateContact();  
        String responseBody = res.responseBody.toString();
        SavvasVirtualSampleUserProvisioning.APIResponseBody responseDetails = (SavvasVirtualSampleUserProvisioning.APIResponseBody)JSON.deserialize(responseBody, SavvasVirtualSampleUserProvisioning.APIResponseBody.class);
        Assert.areEqual(2, responseDetails.statusCode,'Expected and Actual are not same ' + responseDetails);
        }
    }
    //new user for 2.0
    @isTest
    public static void validateContactExist3(){
        List<Account> acc = [SELECT ID from Account where Name='TestParentAccount'];
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/userregistration';
        req.httpMethod = 'Post';
        req.requestBody=Blob.valueOf('{ "firstName": "Test", "lastName": "Test", "email": "Testdummy@test9012.com","programType":"2.0", "collectionId": "9076", "productOfInterest": "My xyz Materials", "collectionName": "", "collectionDetails": [ { "entityId": "32139", "assetName": "Access Guide", "thumbnailId": "ebc450df684f405ea35df3afe7415f0d?v=3dd83a7f" } ],"accountId":"' + acc[0].ID + '" }');
        RestContext.request = req;
        RestContext.response= res;
        SavvasVirtualSampleUserProvisioning.validateContact();  
        String responseBody = res.responseBody.toString();
        SavvasVirtualSampleUserProvisioning.APIResponseBody responseDetails = (SavvasVirtualSampleUserProvisioning.APIResponseBody)JSON.deserialize(responseBody, SavvasVirtualSampleUserProvisioning.APIResponseBody.class);
        Assert.areEqual(1, responseDetails.statusCode,'Expected and Actual are not same ' + responseDetails);
    }
    //duplicate user
    @isTest
    public static void validateContactExist4(){
        UserRole role=[SELECT Id from UserRole where name='CEO' Limit 1];
        Profile profile = [SELECT Id FROM Profile where Name='System Administrator'];
        User systemAdmin = SavvasVirtualSamplingTestFactory.getUser(profile.Id);
        systemAdmin.UserRoleId = role.Id;
        Insert systemAdmin;
        System.runAs(systemAdmin){
        List<Account> acc = [SELECT ID from Account where Name='TestParentAccount'];
        List<Contact> contactList = new list<Contact>(); 
        Contact newContact = SavvasVirtualSamplingTestFactory.getContact(acc[0].Id);
        newContact.Email = 'Testdummy@test909.com';
        newContact.UCID__c ='Test909';
        contactList.add(newContact);
        Insert contactList;
        Collection_Access__c newCollectionAccess =  SavvasVirtualSamplingTestFactory.createCollectionAccess(contactList[0].Id);
        newCollectionAccess.Name = 'My xyz Materials';
        newCollectionAccess.Collection_Id__c='12345';
        Insert newCollectionAccess;
        String profileName = Label.Savvas_Single_Sign_On_Profile;
        Profile profile1 = [SELECT Id FROM Profile WHERE Name=: profileName];
        List<User> userList = new List<User>();
        User newUser = SavvasVirtualSamplingTestFactory.getUser(profile1.Id);
        newUser.ContactId = contactList[0].Id;
        newUser.UserName = 'Testdummy@test909.com';
        userList.add(newUser);
        Insert userList;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/userregistration';
        req.httpMethod = 'Post';
        req.requestBody=Blob.valueOf('{ "firstName": "Test", "lastName": "Test", "email": "Testdummy@test909.com","programType":"2.0", "collectionId": "12345", "productOfInterest": "My xyz Materials", "accountId":"' + acc[0].ID + '"}');
        RestContext.request = req;
        RestContext.response= res;
        SavvasVirtualSampleUserProvisioning.validateContact();  
        String responseBody = res.responseBody.toString();
        SavvasVirtualSampleUserProvisioning.APIResponseBody responseDetails = (SavvasVirtualSampleUserProvisioning.APIResponseBody)JSON.deserialize(responseBody, SavvasVirtualSampleUserProvisioning.APIResponseBody.class);
        Assert.areEqual(2, responseDetails.statusCode,'Expected and Actual are not same ' + responseDetails);
        }
    }
    //existing user for 2.0
    @isTest
    public static void validateContactExist5(){
        List<Account> acc = [SELECT ID from Account where Name='TestParentAccount'];
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/userregistration';
        req.httpMethod = 'Post';
        req.requestBody=Blob.valueOf('{ "firstName": "Test", "lastName": "Test", "email": "Testdummy@test901.com","programType":"2.0", "collectionId": "7777", "productOfInterest": "My abc Materials", "collectionName": "", "collectionDetails": [ { "entityId": "32139", "assetName": "Access Guide", "thumbnailId": "ebc450df684f405ea35df3afe7415f0d?v=3dd83a7f" } ], "accountId":"' + acc[0].ID + '" }');
        RestContext.request = req;
        RestContext.response= res;
        SavvasVirtualSampleUserProvisioning.validateContact();  
        String responseBody = res.responseBody.toString();
        SavvasVirtualSampleUserProvisioning.APIResponseBody responseDetails = (SavvasVirtualSampleUserProvisioning.APIResponseBody)JSON.deserialize(responseBody, SavvasVirtualSampleUserProvisioning.APIResponseBody.class);
        Assert.areEqual(3, responseDetails.statusCode,'Expected and Actual are not same ' + responseDetails);
    }
    @isTest
    public static void validateContactExist6(){
        List<Account> acc = [SELECT ID from Account where Name='TestParentAccount'];
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/userregistration';
        req.httpMethod = 'Post';
        req.requestBody=Blob.valueOf('{ "firstName": "Test", "lastName": "Test", "email": "Testdummy@test902.com","programType":"2.0", "collectionId": "7777", "productOfInterest": "My abc Materials", "collectionName": "", "collectionDetails": [ { "entityId": "32139", "assetName": "Access Guide", "thumbnailId": "ebc450df684f405ea35df3afe7415f0d?v=3dd83a7f" } ], "accountId":"' + acc[0].ID + '" }');
        RestContext.request = req;
        RestContext.response= res;
        SavvasVirtualSampleUserProvisioning.validateContact();  
        String responseBody = res.responseBody.toString();
        SavvasVirtualSampleUserProvisioning.APIResponseBody responseDetails = (SavvasVirtualSampleUserProvisioning.APIResponseBody)JSON.deserialize(responseBody, SavvasVirtualSampleUserProvisioning.APIResponseBody.class);
        Assert.areEqual(3, responseDetails.statusCode,'Expected and Actual are not same ' + responseDetails);
    }
    //contact with collection access
    @isTest
    public static void validateContactExist7(){
        List<Account> acc = [SELECT ID from Account where Name='TestParentAccount'];
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/userregistration';
        req.httpMethod = 'Post';
        req.requestBody=Blob.valueOf('{ "firstName": "Test", "lastName": "Test", "email": "Testdummy@test100.com","programType":"1.0", "collectionId": "2345", "productOfInterest": "My xyz Materials", "collectionName": "", "collectionDetails": [ { "entityId": "32139", "assetName": "Access Guide", "thumbnailId": "ebc450df684f405ea35df3afe7415f0d?v=3dd83a7f" } ], "accountId":"' + acc[0].ID + '" }');
        RestContext.request = req;
        RestContext.response= res;
        SavvasVirtualSampleUserProvisioning.validateContact();  
        String responseBody = res.responseBody.toString();
        SavvasVirtualSampleUserProvisioning.APIResponseBody responseDetails = (SavvasVirtualSampleUserProvisioning.APIResponseBody)JSON.deserialize(responseBody, SavvasVirtualSampleUserProvisioning.APIResponseBody.class);
        Assert.areEqual(4, responseDetails.statusCode,'Expected and Actual are not same ' + responseDetails);
    }
    @isTest
    public static void validateContactExist8(){
        List<Account> acc = [SELECT ID from Account where Name='TestParentAccount'];
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/userregistration';
        req.httpMethod = 'Post';
        req.requestBody=Blob.valueOf('{ "firstName": "Test", "lastName": "Test", "email": "Testdummy@test100.com","programType":"2.0", "collectionId": "2345", "productOfInterest": "My xyz Materials", "collectionName": "", "collectionDetails": [ { "entityId": "32139", "assetName": "Access Guide", "thumbnailId": "ebc450df684f405ea35df3afe7415f0d?v=3dd83a7f" } ], "accountId":"' + acc[0].ID + '" }');
        RestContext.request = req;
        RestContext.response= res;
        SavvasVirtualSampleUserProvisioning.validateContact();  
        String responseBody = res.responseBody.toString();
        SavvasVirtualSampleUserProvisioning.APIResponseBody responseDetails = (SavvasVirtualSampleUserProvisioning.APIResponseBody)JSON.deserialize(responseBody, SavvasVirtualSampleUserProvisioning.APIResponseBody.class);
        Assert.areEqual(4, responseDetails.statusCode,'Expected and Actual are not same ' + responseDetails);
    }
    @isTest
    public static void validateUserExist(){
        User newIntUser = SavvasVirtualSamplingTestFactory.createIntegrationUser();
        System.runAs(newIntUser){
        List<Account> acc = [SELECT ID from Account where Name='TestParentAccount'];
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/userregistration';
        req.httpMethod = 'Post';
        req.requestBody=Blob.valueOf('{ "firstName": "Test", "lastName": "Test", "email": "Testdummy@test90.com","programType":"1.0", "collectionId": "921", "productOfInterest": "My xyz Materials", "collectionName": "", "collectionDetails": [ { "entityId": "32139", "assetName": "Access Guide", "thumbnailId": "ebc450df684f405ea35df3afe7415f0d?v=3dd83a7f", "asset_itemId":"7e50872b-7066-4582-8ad2-2992015ffe58" } ], "accountId":"' + acc[0].ID + '" }');
        RestContext.request = req;
        RestContext.response= res;
        SavvasVirtualSampleUserProvisioning.validateContact();  
        RestRequest req1 = new RestRequest(); 
        RestResponse res1 = new RestResponse();             
        req1.requestURI = '/services/apexrest/userregistration';
        req1.httpMethod = 'Post';
        req1.requestBody=Blob.valueOf('{ "firstName": "Heather", "lastName": "McLemore Test","programType":"1.0", "email": "Testdummy@test9012.com", "collectionId": "954", "productOfInterest": "My xyz Materials", "collectionName": "", "collectionDetails": [ { "entityId": "32139", "assetName": "Access Guide", "thumbnailId": "ebc450df684f405ea35df3afe7415f0d?v=3dd83a7f", "asset_itemId":"7e50872b-7066-4582-8ad2-2992015ffe58" }, { "entityId": "32130", "assetName": "Access Guides", "thumbnailId": "ebc450df684f405ea35df3afe7415f0d?v=3dd83a7f", "asset_itemId":"7e50472b-7066-4982-8ad2-29921xffe58" } ], "accountId":"' + acc[0].ID + '" }');
        RestContext.request = req1;
        RestContext.response= res1;
        SavvasVirtualSampleUserProvisioning.validateContact();  
        String responseBody = res.responseBody.toString();
        SavvasVirtualSampleUserProvisioning.APIResponseBody responseDetails = (SavvasVirtualSampleUserProvisioning.APIResponseBody)JSON.deserialize(responseBody, SavvasVirtualSampleUserProvisioning.APIResponseBody.class);
        Assert.areEqual(3, responseDetails.statusCode,'Expected and Actual are not same ' + responseDetails);
        }
    }
    @isTest
    public static void validateUserExist1(){
        UserRole role=[SELECT Id from UserRole where name='CEO' Limit 1];
        Profile profile1 = [SELECT Id FROM Profile where Name='System Administrator'];
        User systemAdmin = SavvasVirtualSamplingTestFactory.getUser(profile1.Id);
        systemAdmin.UserRoleId = role.Id;
        Insert systemAdmin;
        System.runAs(systemAdmin){
        List<Account> acc = [SELECT ID from Account where Name='TestParentAccount'];
        Contact contactRecord = [SELECT ID,FirstName,LastName,Email from contact where Email='Testdummy@test9012.com'];
        Profile profile = [SELECT Id,Name from Profile where profile.Name ='Savvas External Users Base Profile'];
        User newUser = SavvasVirtualSamplingTestFactory.getUser(profile.Id);
        newUser.Username = 'Testdummy@test9012.com';
        newUser.Email='Testdummy@test9012.com';
        newUser.contactId=contactRecord.Id;
        Insert newUser;
        Collection_Access__c newCollectionAccess =  SavvasVirtualSamplingTestFactory.createCollectionAccess(contactRecord.Id);
        newCollectionAccess.Name = 'My xyz Materials';
        newCollectionAccess.Collection_Id__c = '4343';
        Insert newCollectionAccess;
        Sitecore_Asset__c newSARecord = SavvasVirtualSamplingTestFactory.createSitecoreAsset(contactRecord.Id, newCollectionAccess.Id);
        Insert newSARecord;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/userregistration';
        req.httpMethod = 'Post';
        req.requestBody=Blob.valueOf('{ "firstName": "Test", "lastName": "Test", "email": "Testdummy@test9012.com","programType":"1.0", "collectionId": "4343", "productOfInterest": "My xyz Materials", "collectionName": "", "collectionDetails": [ { "entityId": "32139", "assetName": "Access Guide", "thumbnailId": "ebc450df684f405ea35df3afe7415f0d?v=3dd83a7f", "asset_itemId":"7e50872b-7066-4582-8ad2-2992015ffe58" } ],  "accountId":"' + acc[0].ID + '" }');
        RestContext.request = req;
        RestContext.response= res;	
        SavvasVirtualSampleUserProvisioning.validateContact();  
        RestRequest req1 = new RestRequest(); 
        RestResponse res1 = new RestResponse();             
        req1.requestURI = '/services/apexrest/userregistration';
        req1.httpMethod = 'Post';
        req1.requestBody=Blob.valueOf('{ "firstName": "Heather", "lastName": "McLemore Test","programType":"1.0", "email": "Testdummy@test9012.com", "collectionId": "4343", "productOfInterest": "My xyz Materials", "collectionName": "", "collectionDetails": [ { "entityId": "32139", "assetName": "Access Guide", "thumbnailId": "ebc450df684f405ea35df3afe7415f0d?v=3dd83a7f", "asset_itemId":"7e50872b-7066-4582-8ad2-2992015ffe58" }, { "entityId": "32130", "assetName": "Access Guides", "thumbnailId": "ebc450df684f405ea35df3afe7415f0d?v=3dd83a7f", "asset_itemId":"7e50472b-7066-4982-8ad2-29921xffe58" } ], "accountId":"' + acc[0].ID + '" }');
        RestContext.request = req1;
        RestContext.response= res1;
        SavvasVirtualSampleUserProvisioning.validateContact();  
        String responseBody = res.responseBody.toString();
        SavvasVirtualSampleUserProvisioning.APIResponseBody responseDetails = (SavvasVirtualSampleUserProvisioning.APIResponseBody)JSON.deserialize(responseBody, SavvasVirtualSampleUserProvisioning.APIResponseBody.class);
        Assert.areEqual(3, responseDetails.statusCode,'Expected and Actual are not same ' + responseDetails);
        }
    }
    @isTest
    public static void validateUserExist2(){
        List<Account> acc = [SELECT ID from Account where Name='TestParentAccount'];
        Contact contactRecord = [SELECT ID,FirstName,LastName,Email from contact where Email='Testdummy@test9012.com'];
        Profile profile = [SELECT Id,Name from Profile where profile.Name ='Savvas External Users Base Profile'];
        User newUser = SavvasVirtualSamplingTestFactory.getUser(profile.Id);
        newUser.Username = 'Testdummy@test9012.com';
        newUser.Email='Testdummy@test9012.com';
        newUser.contactId=contactRecord.Id;
        Insert newUser;
        Collection_Access__c newCollectionAccess =  SavvasVirtualSamplingTestFactory.createCollectionAccess(contactRecord.Id);
        newCollectionAccess.Name = 'My xyz Materials';
        newCollectionAccess.Collection_Id__c = '4343';
        Insert newCollectionAccess;
        Sitecore_Asset__c newSARecord = SavvasVirtualSamplingTestFactory.createSitecoreAsset(contactRecord.Id, newCollectionAccess.Id);
        Insert newSARecord;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/userregistration';
        req.httpMethod = 'Post';
        req.requestBody=Blob.valueOf('{ "firstName": "Test", "lastName": "Test", "email": "Testdummy@test9012.com","programType":"1.0", "collectionId": "4343", "productOfInterest": "My xyz Materials", "collectionName": "", "collectionDetails": [ { "entityId": "32139", "assetName": "Access Guide", "thumbnailId": "ebc450df684f405ea35df3afe7415f0d?v=3dd83a7f", "asset_itemId":"7e50872b-7066-4582-8ad2-2992015ffe58" } ],  "accountId":"' + '0015300000U1p4NAAR' + '" }');
        RestContext.request = req;
        RestContext.response= res;	
        SavvasVirtualSampleUserProvisioning.validateContact(); 
        String responseBody = res.responseBody.toString();
        SavvasVirtualSampleUserProvisioning.APIResponseBody responseDetails = (SavvasVirtualSampleUserProvisioning.APIResponseBody)JSON.deserialize(responseBody, SavvasVirtualSampleUserProvisioning.APIResponseBody.class);
        Assert.areEqual(4, responseDetails.statusCode,'Expected and Actual are not same ' + responseDetails);
    }
    @isTest
    public static void siteCoreAsset1(){
        UserRole role=[SELECT Id from UserRole where name='CEO' Limit 1];
        Profile profile = [SELECT Id FROM Profile where Name='System Administrator'];
        User systemAdmin = SavvasVirtualSamplingTestFactory.getUser(profile.Id);
        systemAdmin.UserRoleId = role.Id;
        Insert systemAdmin;
        System.runAs(systemAdmin){
        List<Account> acc = [SELECT ID from Account where Name='TestParentAccount'];
        List<Contact> contactList = new list<Contact>(); 
        Contact newContact = SavvasVirtualSamplingTestFactory.getContact(acc[0].Id);
        newContact.Email = 'Testdummy@test9009.com';
        newContact.UCID__c ='Test9009';
        contactList.add(newContact);
        Insert contactList;
        Collection_Access__c newCollectionAccess =  SavvasVirtualSamplingTestFactory.createCollectionAccess(contactList[0].Id);
        newCollectionAccess.Name = 'My xyz Materials';
        newCollectionAccess.Collection_Id__c='12356';
        Insert newCollectionAccess;
        String profileName = Label.Savvas_Sample_Resources_Profile;
        Profile profile1 = [SELECT Id FROM Profile WHERE Name=: profileName];
        List<User> userList = new List<User>();
        User newUser = SavvasVirtualSamplingTestFactory.getUser(profile1.Id);
        newUser.UserName = 'Testdummy@test9009.com';
        newUser.ContactId = contactList[0].Id;
        userList.add(newUser);
        Insert userList;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/userregistration';
        req.httpMethod = 'Post';
        req.requestBody=Blob.valueOf('{ "firstName": "Test", "lastName": "Test", "email": "Testdummy@test9009.com","programType":"1.0", "collectionId": "12356", "productOfInterest": "My xyz Materials", "collectionName": "", "collectionDetails": [ { "entityId": "32135", "assetName": "Access Guide", "thumbnailId": "ebc450df684f405ea35df3afe7415f0d?v=3dd83a7f" } ],  "accountId":"' + acc[0].ID + '" }');
        RestContext.request = req;
        RestContext.response= res;
        SavvasVirtualSampleUserProvisioning.validateContact();       
        String responseBody = res.responseBody.toString();
        SavvasVirtualSampleUserProvisioning.APIResponseBody responseDetails = (SavvasVirtualSampleUserProvisioning.APIResponseBody)JSON.deserialize(responseBody, SavvasVirtualSampleUserProvisioning.APIResponseBody.class);
        Assert.areEqual(2, responseDetails.statusCode,'Expected and Actual are not same ' + responseDetails);
        }
    }
    @isTest
    public static void exceptionTest1(){
        List<Account> acc = [SELECT ID from Account where Name='TestParentAccount'];
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/userregistration';
        req.httpMethod = 'Post';
        req.requestBody=Blob.valueOf('{ "firstName": "Test", "lastName": "Test", "email": "Testdummy@test9012.com", "programType":"1.0","collectionId": "3333", "productOfInterest": "My xyz Materials", "collectionName": "", "collectionDetails": [],  "accountId":"' + acc[0].ID + '" }');
        RestContext.request = req;
        RestContext.response= res;
        SavvasVirtualSampleUserProvisioning.validateContact();  
        String responseBody = res.responseBody.toString();
        SavvasVirtualSampleUserProvisioning.APIResponseBody responseDetails = (SavvasVirtualSampleUserProvisioning.APIResponseBody)JSON.deserialize(responseBody, SavvasVirtualSampleUserProvisioning.APIResponseBody.class);
        Assert.areEqual(1, responseDetails.statusCode,'Expected and Actual are not same ' + responseDetails);
    }
    @isTest
    public static void exceptionTest2(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/userregistration';
        req.httpMethod = 'Post';
        req.requestBody=Blob.valueOf(' ');
        RestContext.request = req;
        RestContext.response= res;
        SavvasVirtualSampleUserProvisioning.validateContact();  
        String responseBody = res.responseBody.toString();
        SavvasVirtualSampleUserProvisioning.APIResponseBody responseDetails = (SavvasVirtualSampleUserProvisioning.APIResponseBody)JSON.deserialize(responseBody, SavvasVirtualSampleUserProvisioning.APIResponseBody.class);
        Assert.areEqual(null, responseDetails.statusCode,'Expected and Actual are not same ' + responseDetails);
    }
}