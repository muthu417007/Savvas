@isTest
public class SavvasDigitalSamplesValidateTokenTest {
    
    @testSetup static void setup() {
        UserRole role=[SELECT Id from UserRole where name='CEO' Limit 1];
        Profile profile1 = [SELECT Id FROM Profile where Name='System Administrator'];
        User systemAdmin = new User(FirstName='testAdmin', LastName='testAdmin', 
                                    userName='testAdmin@test.com'+(String.valueOf(Math.random())).substring(0, 4), Email='TestAdmin@admin.com.invalid',
                                    emailencodingkey='UTF-8', languagelocalekey='en_US',
                                    alias = (String.valueOf(Math.random())).substring(0, 8),localesidkey='en_US', 
                                    timezonesidkey='America/Los_Angeles', profileId = profile1.Id, UserRoleId = role.Id);
        Insert systemAdmin;
        System.runAs(systemAdmin){
            Account newAccount = new Account(Name='TestParentAccount', type='International',
                                             BillingCity='New York',BillingStreet='100 Hudson Street',
                                             BillingPostalCode='10013', BillingState='NY',
                                             BillingCountry='United States');
            insert newAccount;
            Contact newContact = new Contact(FirstName ='TestDummy',LastName='Test'+Integer.valueOf((Math.random())),
                                             Email = 'Testdummy@test9012.com',AccountId=newAccount.Id);
            insert newContact;
            Collection_Access__c newCollectionAccess =  new Collection_Access__c();
            newCollectionAccess.Name = 'My xyz Materials';
            newCollectionAccess.Access_Granted_On__c = Date.today();
            newCollectionAccess.Access_Valid_Till__c = Date.today().addDays(Integer.valueOf(Label.Savvas_Learning_Access_Limit));
            newCollectionAccess.Contact__c = newContact.Id;
            Insert newCollectionAccess;
            Sitecore_Asset__c newSARecord = new Sitecore_Asset__c();
            newSARecord.Collection_Access__c = newCollectionAccess.Id;
            newSARecord.Entity_Id__c = '32139';
            newSARecord.Name ='Access Guide' ;
            newSARecord.Thumbnail_Id__c = 'ebc450df684f405ea35df3afe7415f0d?v=3dd83a7f';
            newSARecord.Contact__c = newContact.Id;
            Insert newSARecord;
            Collection_Access__c newCollectionAccess1 =  new Collection_Access__c();
            newCollectionAccess1.Name = 'My Materials';
            newCollectionAccess1.Collection_Item_Id__c = 'f77c3866-1575-4254-a416-f14af4195340';
            newCollectionAccess1.Access_Granted_On__c = Date.today();
            newCollectionAccess1.Access_Valid_Till__c = Date.today().addDays(Integer.valueOf(Label.Savvas_Learning_Access_Limit));
            newCollectionAccess1.Contact__c = newContact.Id;
            Insert newCollectionAccess1;
            Sitecore_Asset__c newSARecord1 = new Sitecore_Asset__c();
            newSARecord1.Collection_Access__c = newCollectionAccess1.Id;
            newSARecord1.Sitecore_Id__c = '7628fe94-7a84-4aeb-b536-19c8c31156fc';
            newSARecord1.Entity_Id__c = '32130';
            newSARecord1.Name ='Access Guide' ;
            newSARecord1.Thumbnail_Id__c = 'ebc450df684f405ea35df3afe7415f0d?v=3dd83a7f';
            newSARecord1.Contact__c = newContact.Id;
            newSARecord1.Is_SF_Launched__c = True;
            Insert newSARecord1;
            Profile profile = [SELECT Id,Name from Profile where profile.Name = 'Savvas Sample Resources'];
            User newUser = new User(FirstName = newContact.FirstName,LastName=newContact.LastName,
                                    Email=newContact.Email,contactId=newContact.Id,
                                    ProfileId=profile.Id,UserName=newContact.Email,
                                    alias = string.valueof(newContact.firstName.substring(0,1) + newContact.lastName.substring(0,1)),
                                    emailencodingkey='UTF-8', languagelocalekey='en_US', 
                                    localesidkey='en_US', timezonesidkey='America/Los_Angeles');
            Insert newUser;
        }
    }
    
    @isTest
    public static void validate(){
        User usr = [SELECT Id,contactId from User where userName='Testdummy@test9012.com'];
        System.runAs(usr){
        Test.startTest();
            RestRequest req = new RestRequest(); 
        	RestResponse res = new RestResponse();             
        	req.requestURI = '/services/apexrest/ValidateToken';
        	req.httpMethod = 'Post';
        	req.requestBody=Blob.valueOf('{ "asset_itemId": "7628fe94-7a84-4aeb-b536-19c8c31156fc" }');
        	RestContext.request = req;
        	RestContext.response= res;
        	SavvasDigitalSamplesValidateToken.validate('7628fe94-7a84-4aeb-b536-19c8c31156fc');
        Test.stopTest();
        //System.assertEquals(true, valid);
        }
    }
    @isTest
    public static void validate1(){
        User usr = [SELECT Id,contactId from User where userName='Testdummy@test9012.com'];
        System.runAs(usr){
        Test.startTest();
            RestRequest req = new RestRequest(); 
        	RestResponse res = new RestResponse();             
        	req.requestURI = '/services/apexrest/ValidateToken';
        	req.httpMethod = 'Post';
        	req.requestBody=Blob.valueOf('{ "sitecoreId": "7628fe94-7a84-4aeb-b536-19c8c31156fc" }');
        	RestContext.request = req;
        	RestContext.response= res;
        	SavvasDigitalSamplesValidateToken.validate('7628fe94-7a84-4aeb-b536-19c8c334g45');
        Test.stopTest();
        }
    }
}