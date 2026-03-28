/*
@Author : Cognizant Team
@Name : SavvasDigitalSamplesServiceTest
@CreateDate : 23-Jan-2023
@Description : This class is test class for SavvasDigitalSamplesService.
@ModifiedBy: Cognizant Team
@ModifiedDate: 02-Nov-2023
@Ticket Number: VS-0011
@This class has been deprecated as part of SSO project to accomodate the new account contact validation logic as per new requirements. 
User story number for reference: W-015376
New Classes for reference : SavvasVirtualSampleUserProvisioning, SavvasVirtualSampleUserProvisioningTest
*/
 
@isTest
public class SavvasDigitalSamplesServiceTest {
    /*
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
            contactList.add(newContact);
            Contact newContact1 = SavvasVirtualSamplingTestFactory.getContact(newAccount.Id);
            newContact1.Email = 'Testdummy@test901.com';
            contactList.add(newContact1);
            Contact newContact2 = SavvasVirtualSamplingTestFactory.getContact(newAccount.Id);
            newContact2.Email = 'Testdummy@test90.com';
            contactList.add(newContact2);
            insert contactList;
            
            String profileName = Label.Savvas_Sample_Resources_Profile;
            Profile profile1 = [SELECT Id FROM Profile WHERE Name=: profileName];
            Profile profile2 = [SELECT Id,Name from Profile where Name = 'Community Connection External User'];
            List<User> userList = new List<User>();
            User newUser = SavvasVirtualSamplingTestFactory.getUser(profile1.Id);
            newUser.ContactId = contactList[1].Id;
            userList.add(newUser);
            User newUser1 = SavvasVirtualSamplingTestFactory.getUser(profile1.Id);
            newUser1.Email = 'Testdummy@test90.com';
            newUser1.ContactId = contactList[2].Id;
            userList.add(newUser1);
            Insert userList;
            PermissionSet permissionSet1 = [SELECT id FROM PermissionSet WHERE Name=: profileName.replaceAll(' ', '_')];
            PermissionSetAssignment psa = SavvasVirtualSamplingTestFactory.CreatePermissionSetAssignment(permissionSet1.Id, userList[1].Id);
            Insert psa;
            
            List<Collection_Access__c> collectionAccessList = new List<Collection_Access__c>();
            Collection_Access__c newCollectionAccess =  SavvasVirtualSamplingTestFactory.createCollectionAccess(contactList[1].Id);
            newCollectionAccess.Name = 'My xyz Materials';
            newCollectionAccess.Collection_Id__c = '2345';
            collectionAccessList.add(newCollectionAccess);
            Collection_Access__c newCollectionAccess1 =  SavvasVirtualSamplingTestFactory.createCollectionAccess(contactList[1].Id);
            newCollectionAccess1.Name = 'My sample Materials';
            newCollectionAccess1.Collection_Id__c = '2345';
            collectionAccessList.add(newCollectionAccess1);
            insert collectionAccessList;
            
            List<Sitecore_Asset__c> sitecoreAssetList = new List<Sitecore_Asset__c>();
            Sitecore_Asset__c newSARecord = SavvasVirtualSamplingTestFactory.createSitecoreAsset(contactList[1].Id, collectionAccessList[0].Id);
            sitecoreAssetList.add(newSARecord);
            Sitecore_Asset__c newSARecord1 = SavvasVirtualSamplingTestFactory.createSitecoreAsset(contactList[1].Id, collectionAccessList[1].Id);
            sitecoreAssetList.add(newSARecord1);
            Insert sitecoreAssetList;
        }
    }
    @isTest
    public static void validateContact(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/userregistration';
        req.httpMethod = 'Post';
        req.requestBody=Blob.valueOf('{ "firstName": "Test", "lastName": "Test", "email": "new.Test@test.com", "collectionId": "1091", "productOfInterest": "My xyz Materials", "collectionName": "", "collectionDetails": [ { "entityId": "32139", "assetName": "Access Guide", "thumbnailId": "ebc450df684f405ea35df3afe7415f0d?v=3dd83a7f" } ] }');
        RestContext.request = req;
        RestContext.response= res;
        SavvasDigitalSamplesService.validateContact(); 
        String responseBody = res.responseBody.toString();
        SavvasDigitalSamplesService.APIResponseBody responseDetails = (SavvasDigitalSamplesService.APIResponseBody)JSON.deserialize(responseBody, SavvasDigitalSamplesService.APIResponseBody.class);
        Assert.areEqual(0, responseDetails.statusCode,'Expected and Actual are not same');
    } 
    @isTest
    public static void validateContactExist(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/userregistration';
        req.httpMethod = 'Post';
        req.requestBody=Blob.valueOf('{ "firstName": "Test", "lastName": "Test", "email": "Testdummy@test9012.com","programType":"1.0", "collectionId": "9089", "productOfInterest": "My xyz Materials", "collectionName": "", "collectionDetails": [ { "entityId": "32139", "assetName": "Access Guide", "thumbnailId": "ebc450df684f405ea35df3afe7415f0d?v=3dd83a7f" } ] }');
        RestContext.request = req;
        RestContext.response= res;
        SavvasDigitalSamplesService.validateContact();  
        String responseBody = res.responseBody.toString();
        SavvasDigitalSamplesService.APIResponseBody responseDetails = (SavvasDigitalSamplesService.APIResponseBody)JSON.deserialize(responseBody, SavvasDigitalSamplesService.APIResponseBody.class);
        Assert.areEqual(1, responseDetails.statusCode,'Expected and Actual are not same');
    }
    @isTest
    public static void validateContactExist2(){
        List<Account> acc = [SELECT ID from Account where Name='TestParentAccount'];
        List<Contact> contactList = new list<Contact>(); 
        Contact newContact = SavvasVirtualSamplingTestFactory.getContact(acc[0].Id);
        newContact.Email = 'Testdummy@test9999.com';
        contactList.add(newContact);
        Insert contactList;
        Collection_Access__c newCollectionAccess =  SavvasVirtualSamplingTestFactory.createCollectionAccess(contactList[0].Id);
        newCollectionAccess.Name = 'My xyz Materials';
        newCollectionAccess.Collection_Id__c='12345';
        Insert newCollectionAccess;
        String profileName = Label.Savvas_Sample_Resources_Profile;
        Profile profile1 = [SELECT Id FROM Profile WHERE Name=: profileName];
        List<User> userList = new List<User>();
        User newUser = SavvasVirtualSamplingTestFactory.getUser(profile1.Id);
        newUser.ContactId = contactList[0].Id;
        userList.add(newUser);
        Insert userList;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/userregistration';
        req.httpMethod = 'Post';
        req.requestBody=Blob.valueOf('{ "firstName": "Test", "lastName": "Test", "email": "Testdummy@test9999.com","programType":"1.0", "collectionId": "12345", "productOfInterest": "My xyz Materials", "collectionName": "", "collectionDetails": [ { "entityId": "32139", "assetName": "Access Guide", "thumbnailId": "ebc450df684f405ea35df3afe7415f0d?v=3dd83a7f" } ] }');
        RestContext.request = req;
        RestContext.response= res;
        SavvasDigitalSamplesService.validateContact();  
        String responseBody = res.responseBody.toString();
        SavvasDigitalSamplesService.APIResponseBody responseDetails = (SavvasDigitalSamplesService.APIResponseBody)JSON.deserialize(responseBody, SavvasDigitalSamplesService.APIResponseBody.class);
        Assert.areEqual(2, responseDetails.statusCode,'Expected and Actual are not same');
    }
    @isTest
    public static void validateContactExist3(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/userregistration';
        req.httpMethod = 'Post';
        req.requestBody=Blob.valueOf('{ "firstName": "Test", "lastName": "Test", "email": "Testdummy@test9012.com","programType":"2.0", "collectionId": "9076", "productOfInterest": "My xyz Materials", "collectionName": "", "collectionDetails": [ { "entityId": "32139", "assetName": "Access Guide", "thumbnailId": "ebc450df684f405ea35df3afe7415f0d?v=3dd83a7f" } ] }');
        RestContext.request = req;
        RestContext.response= res;
        SavvasDigitalSamplesService.validateContact();  
        String responseBody = res.responseBody.toString();
        SavvasDigitalSamplesService.APIResponseBody responseDetails = (SavvasDigitalSamplesService.APIResponseBody)JSON.deserialize(responseBody, SavvasDigitalSamplesService.APIResponseBody.class);
        Assert.areEqual(1, responseDetails.statusCode,'Expected and Actual are not same');
    }
    @isTest
    public static void validateContactExist4(){
        List<Account> acc = [SELECT ID from Account where Name='TestParentAccount'];
        List<Contact> contactList = new list<Contact>(); 
        Contact newContact = SavvasVirtualSamplingTestFactory.getContact(acc[0].Id);
        newContact.Email = 'Testdummy@test909.com';
        contactList.add(newContact);
        Insert contactList;
        Collection_Access__c newCollectionAccess =  SavvasVirtualSamplingTestFactory.createCollectionAccess(contactList[0].Id);
        newCollectionAccess.Name = 'My xyz Materials';
        newCollectionAccess.Collection_Id__c='12345';
        Insert newCollectionAccess;
        String profileName = Label.Savvas_Sample_Resources_Profile;
        Profile profile1 = [SELECT Id FROM Profile WHERE Name=: profileName];
        List<User> userList = new List<User>();
        User newUser = SavvasVirtualSamplingTestFactory.getUser(profile1.Id);
        newUser.ContactId = contactList[0].Id;
        userList.add(newUser);
        Insert userList;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/userregistration';
        req.httpMethod = 'Post';
        req.requestBody=Blob.valueOf('{ "firstName": "Test", "lastName": "Test", "email": "Testdummy@test909.com","programType":"2.0", "collectionId": "12345", "productOfInterest": "My xyz Materials"}');
        RestContext.request = req;
        RestContext.response= res;
        SavvasDigitalSamplesService.validateContact();  
        String responseBody = res.responseBody.toString();
        SavvasDigitalSamplesService.APIResponseBody responseDetails = (SavvasDigitalSamplesService.APIResponseBody)JSON.deserialize(responseBody, SavvasDigitalSamplesService.APIResponseBody.class);
        Assert.areEqual(2, responseDetails.statusCode,'Expected and Actual are not same');
    }
    @isTest
    public static void validateContactExist5(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/userregistration';
        req.httpMethod = 'Post';
        req.requestBody=Blob.valueOf('{ "firstName": "Test", "lastName": "Test", "email": "Testdummy@test901.com","programType":"2.0", "collectionId": "7777", "productOfInterest": "My abc Materials", "collectionName": "", "collectionDetails": [ { "entityId": "32139", "assetName": "Access Guide", "thumbnailId": "ebc450df684f405ea35df3afe7415f0d?v=3dd83a7f" } ] }');
        RestContext.request = req;
        RestContext.response= res;
        SavvasDigitalSamplesService.validateContact();  
        String responseBody = res.responseBody.toString();
        SavvasDigitalSamplesService.APIResponseBody responseDetails = (SavvasDigitalSamplesService.APIResponseBody)JSON.deserialize(responseBody, SavvasDigitalSamplesService.APIResponseBody.class);
        Assert.areEqual(3, responseDetails.statusCode,'Expected and Actual are not same');
    }
    @isTest
    public static void validateUserExist(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/userregistration';
        req.httpMethod = 'Post';
        req.requestBody=Blob.valueOf('{ "firstName": "Test", "lastName": "Test", "email": "Testdummy@test90.com","programType":"1.0", "collectionId": "921", "productOfInterest": "My xyz Materials", "collectionName": "", "collectionDetails": [ { "entityId": "32139", "assetName": "Access Guide", "thumbnailId": "ebc450df684f405ea35df3afe7415f0d?v=3dd83a7f", "asset_itemId":"7e50872b-7066-4582-8ad2-2992015ffe58" } ] }');
        RestContext.request = req;
        RestContext.response= res;
        SavvasDigitalSamplesService.validateContact();  
        RestRequest req1 = new RestRequest(); 
        RestResponse res1 = new RestResponse();             
        req1.requestURI = '/services/apexrest/userregistration';
        req1.httpMethod = 'Post';
        req1.requestBody=Blob.valueOf('{ "firstName": "Heather", "lastName": "McLemore Test","programType":"1.0", "email": "Testdummy@test9012.com", "collectionId": "954", "productOfInterest": "My xyz Materials", "collectionName": "", "collectionDetails": [ { "entityId": "32139", "assetName": "Access Guide", "thumbnailId": "ebc450df684f405ea35df3afe7415f0d?v=3dd83a7f", "asset_itemId":"7e50872b-7066-4582-8ad2-2992015ffe58" }, { "entityId": "32130", "assetName": "Access Guides", "thumbnailId": "ebc450df684f405ea35df3afe7415f0d?v=3dd83a7f", "asset_itemId":"7e50472b-7066-4982-8ad2-29921xffe58" } ] }');
        RestContext.request = req1;
        RestContext.response= res1;
        SavvasDigitalSamplesService.validateContact();  
        String responseBody = res.responseBody.toString();
        SavvasDigitalSamplesService.APIResponseBody responseDetails = (SavvasDigitalSamplesService.APIResponseBody)JSON.deserialize(responseBody, SavvasDigitalSamplesService.APIResponseBody.class);
        Assert.areEqual(3, responseDetails.statusCode,'Expected and Actual are not same');
    }
    @isTest
    public static void validateUserExist1(){
        Contact contactRecord = [SELECT ID,FirstName,LastName,Email from contact where Email='Testdummy@test9012.com'];
        Profile profile = [SELECT Id,Name from Profile where profile.Name = 'Savvas Sample Resources'];
        User newUser = SavvasVirtualSamplingTestFactory.getUser(profile.Id);
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
        req.requestBody=Blob.valueOf('{ "firstName": "Test", "lastName": "Test", "email": "Testdummy@test9012.com","programType":"1.0", "collectionId": "4343", "productOfInterest": "My xyz Materials", "collectionName": "", "collectionDetails": [ { "entityId": "32139", "assetName": "Access Guide", "thumbnailId": "ebc450df684f405ea35df3afe7415f0d?v=3dd83a7f", "asset_itemId":"7e50872b-7066-4582-8ad2-2992015ffe58" } ] }');
        RestContext.request = req;
        RestContext.response= res;
        SavvasDigitalSamplesService.validateContact();  
        RestRequest req1 = new RestRequest(); 
        RestResponse res1 = new RestResponse();             
        req1.requestURI = '/services/apexrest/userregistration';
        req1.httpMethod = 'Post';
        req1.requestBody=Blob.valueOf('{ "firstName": "Heather", "lastName": "McLemore Test","programType":"1.0", "email": "Testdummy@test9012.com", "collectionId": "4343", "productOfInterest": "My xyz Materials", "collectionName": "", "collectionDetails": [ { "entityId": "32139", "assetName": "Access Guide", "thumbnailId": "ebc450df684f405ea35df3afe7415f0d?v=3dd83a7f", "asset_itemId":"7e50872b-7066-4582-8ad2-2992015ffe58" }, { "entityId": "32130", "assetName": "Access Guides", "thumbnailId": "ebc450df684f405ea35df3afe7415f0d?v=3dd83a7f", "asset_itemId":"7e50472b-7066-4982-8ad2-29921xffe58" } ] }');
        RestContext.request = req1;
        RestContext.response= res1;
        SavvasDigitalSamplesService.validateContact();  
        String responseBody = res.responseBody.toString();
        SavvasDigitalSamplesService.APIResponseBody responseDetails = (SavvasDigitalSamplesService.APIResponseBody)JSON.deserialize(responseBody, SavvasDigitalSamplesService.APIResponseBody.class);
        Assert.areEqual(3, responseDetails.statusCode,'Expected and Actual are not same');
    }
    @isTest
    public static void siteCoreAsset1(){
        List<Account> acc = [SELECT ID from Account where Name='TestParentAccount'];
        List<Contact> contactList = new list<Contact>(); 
        Contact newContact = SavvasVirtualSamplingTestFactory.getContact(acc[0].Id);
        newContact.Email = 'Testdummy@test9009.com';
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
        newUser.ContactId = contactList[0].Id;
        userList.add(newUser);
        Insert userList;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/userregistration';
        req.httpMethod = 'Post';
        req.requestBody=Blob.valueOf('{ "firstName": "Test", "lastName": "Test", "email": "Testdummy@test9009.com","programType":"1.0", "collectionId": "12356", "productOfInterest": "My xyz Materials", "collectionName": "", "collectionDetails": [ { "entityId": "32135", "assetName": "Access Guide", "thumbnailId": "ebc450df684f405ea35df3afe7415f0d?v=3dd83a7f" } ] }');
        RestContext.request = req;
        RestContext.response= res;
        SavvasDigitalSamplesService.validateContact();       
        String responseBody = res.responseBody.toString();
        SavvasDigitalSamplesService.APIResponseBody responseDetails = (SavvasDigitalSamplesService.APIResponseBody)JSON.deserialize(responseBody, SavvasDigitalSamplesService.APIResponseBody.class);
        Assert.areEqual(2, responseDetails.statusCode,'Expected and Actual are not same');
    }
    @isTest
    public static void exceptionTest1(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/userregistration';
        req.httpMethod = 'Post';
        req.requestBody=Blob.valueOf('{ "firstName": "Test", "lastName": "Test", "email": "Testdummy@test9012.com", "programType":"1.0","collectionId": "3333", "productOfInterest": "My xyz Materials", "collectionName": "", "collectionDetails": [] }');
        RestContext.request = req;
        RestContext.response= res;
        SavvasDigitalSamplesService.validateContact();  
        String responseBody = res.responseBody.toString();
        SavvasDigitalSamplesService.APIResponseBody responseDetails = (SavvasDigitalSamplesService.APIResponseBody)JSON.deserialize(responseBody, SavvasDigitalSamplesService.APIResponseBody.class);
        Assert.areEqual(1, responseDetails.statusCode,'Expected and Actual are not same');
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
        SavvasDigitalSamplesService.validateContact();  
        String responseBody = res.responseBody.toString();
        SavvasDigitalSamplesService.APIResponseBody responseDetails = (SavvasDigitalSamplesService.APIResponseBody)JSON.deserialize(responseBody, SavvasDigitalSamplesService.APIResponseBody.class);
        Assert.areEqual(null, responseDetails.statusCode,'Expected and Actual are not same');
    }*/
}