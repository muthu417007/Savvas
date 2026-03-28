/*
@Author : Cognizant Team
@Name : SavvasSampleResourcesLandingTest
@CreateDate : 11-Jan-2023
@Description : This class is test class for SavvasSampleResourcesLandingController. 
@ModifiedBy: Cognizant Team
@ModifiedDate: 02-Nov-2023
@Ticket Number: VS-0014
*/
@isTest
public class SavvasSampleResourcesLandingTest {
    @testSetup static void setup() {
        UserRole role=[SELECT Id from UserRole where name='CEO' Limit 1];
        Profile profile1 = [SELECT Id FROM Profile where Name='System Administrator'];
        User systemAdmin = SavvasVirtualSamplingTestFactory.getUser(profile1.Id);
        systemAdmin.Email='TestAdmin@admin.com.invalid';
        systemAdmin.UserRoleId = role.Id;
        Insert systemAdmin;
        System.runAs(systemAdmin){
            Account newAccount = SavvasVirtualSamplingTestFactory.getAccount();
            insert newAccount;
            Contact newContact = SavvasVirtualSamplingTestFactory.getContact(newAccount.Id);
            newContact.Email='Testdummy@test9012.com';
            insert newContact;
            List<Collection_Access__c> collectionAccessList = new List<Collection_Access__c>();
            Collection_Access__c newCollectionAccess =  SavvasVirtualSamplingTestFactory.createCollectionAccess(newContact.Id);
            newCollectionAccess.Name = 'My xyz Materials';
            newCollectionAccess.Collection_Item_Id__c = 'f77c3866-1535-4254-a416-f14af8195340';
            newCollectionAccess.Program_Type__c = '2.0';
            collectionAccessList.add(newCollectionAccess);
            
            Collection_Access__c newCollectionAccess1 =  SavvasVirtualSamplingTestFactory.createCollectionAccess(newContact.Id);
            newCollectionAccess1.Name = 'My Materials';
            newCollectionAccess1.Collection_Item_Id__c = 'f77c3866-1575-4254-a416-f14af4195340';
            newCollectionAccess1.Program_Type__c = '2.0';
            collectionAccessList.add(newCollectionAccess1);
            
            Collection_Access__c newCollectionAccess2 =  SavvasVirtualSamplingTestFactory.createCollectionAccess(newContact.Id);
            newCollectionAccess2.Name = 'My abc Materials';
            newCollectionAccess2.Collection_Item_Id__c = 'f77c3866-1575-4254-c416-f14af4195340';
            newCollectionAccess2.Program_Type__c = '2.0';
            collectionAccessList.add(newCollectionAccess2);
            Insert collectionAccessList;
            
            List<Sitecore_Asset__c> sitecoreAssetList = new List<Sitecore_Asset__c>();
            Sitecore_Asset__c newSARecord = SavvasVirtualSamplingTestFactory.createSitecoreAsset(newContact.Id, collectionAccessList[0].Id);
            newSARecord.Entity_Id__c = '32139';
            sitecoreAssetList.add(newSARecord);
            
            Sitecore_Asset__c newSARecord1 = SavvasVirtualSamplingTestFactory.createSitecoreAsset(newContact.Id, collectionAccessList[1].Id);
            newSARecord1.Sitecore_Id__c = '7628fe94-7a84-4aeb-b536-19c8c31156fc';
            newSARecord1.Entity_Id__c = '32130';
            sitecoreAssetList.add(newSARecord1);
            
            Sitecore_Asset__c newSARecord2 = SavvasVirtualSamplingTestFactory.createSitecoreAsset(newContact.Id, collectionAccessList[2].Id);
            newSARecord2.Sitecore_Id__c = '7628ge94-7b84-4aeb-b536-19c8c31156fc';
            newSARecord2.Entity_Id__c = '32170';
            sitecoreAssetList.add(newSARecord2);
            Insert sitecoreAssetList;
            
            Profile profile = [SELECT Id,Name from Profile where profile.Name = 'Community Connection External User'];
            User newUser = SavvasVirtualSamplingTestFactory.getUser(profile.Id);
            newUser.Email=newContact.Email;
            newUser.contactId=newContact.Id;
            newUser.Username = newContact.Email;
            Insert newUser;
        }
    }
    
    @isTest
    public static void getSitecoreAsset(){
        Test.startTest();
        User user = [SELECT Id from User where Email='Testdummy@test9012.com'];
        System.runAs(user){
            SavvasSampleResourcesLandingController.updateAssetDescription('My Materials');
            Collection_Access__c collectionAccess = [SELECT Id,Name,Program_Description__c FROM Collection_Access__c WHERE Name=:'My Materials'];
            Assert.areEqual(collectionAccess.Program_Description__c,'Program Description','Program Description is not matched with expected');
            Map<String,List<SavvasSampleResourcesLandingController.CollectionData>> sitecoreAssetDetails = SavvasSampleResourcesLandingController.getSitecoreAsset('My xyz Materials');
            Assert.areEqual('32139', sitecoreAssetDetails.get('My xyz Materials')[0].entityId,'EntityId is not matched with expected');
            try{
                SavvasSampleResourcesLandingController.updateAssetDescription(NULL);
            }
            catch(Exception e){
                Assert.areEqual('System.AuraHandledException', e.getTypeName(),'Exception');
            }
        }
        Test.stopTest();
    }
    @isTest
    public static void authenticateDamTest(){
        Test.startTest();
        User user = [SELECT Id from User where Email='Testdummy@test9012.com'];
        System.runAs(user){
            String response = SavvasSampleResourcesLandingController.authenticateDam('330309');
            Assert.areNotEqual(null, response, 'Empty response');
            try{
                String response1 = SavvasSampleResourcesLandingController.authenticateDam(null);
            }
            catch(Exception e){
                Assert.areEqual('System.AuraHandledException', e.getTypeName(),'Exception');
            }
        }
        Test.stopTest();
    }
    @isTest
    public static void getAssetUsingEntityId(){
        try{
            String response = SavvasSampleResourcesLandingController.getAssetUsingEntityId('hdg3ju39j3j41ijd&*y','272638');
            Assert.areNotEqual(null, response, 'Empty response');
            String responseEmptyEntityId = SavvasSampleResourcesLandingController.getAssetUsingEntityId('hdg3ju39j3j41ijd&*y',null);
            Assert.areEqual(null, responseEmptyEntityId, 'Empty response');
            String responseEmpty = SavvasSampleResourcesLandingController.getAssetUsingEntityId(null,null);
            Assert.areEqual(null, responseEmpty, 'ResponseEmpty is not null');
        }
        catch(Exception e){
            Assert.areEqual('System.AuraHandledException', e.getTypeName(),'Exception');
        }
    }
    @isTest
    public static void generateAccessToken(){
        try{
            User user = [SELECT Id from User where Email='Testdummy@test9012.com'];
            System.runAs(user){
                Test.startTest();
                String accessToken1=SavvasSampleResourcesLandingController.generateAccessToken('7628fe94-7a84-4aeb-b536-19c8c31156fc');
                Assert.areEqual(true, String.isNotBlank(accessToken1), 'accessToken1 is blank');
                String accessToken2=SavvasSampleResourcesLandingController.generateAccessToken('');
                Test.stopTest();
                
            }
        }
        catch(Exception e){
            Assert.areEqual('System.AuraHandledException', e.getTypeName(),'Exception');
        }
    }
}