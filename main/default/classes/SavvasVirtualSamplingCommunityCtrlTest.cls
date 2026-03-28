/*
@Author : Cognizant Team
@Name : SavvasVirtualSamplingCommunityCtrlTest
@CreateDate : 09-Aug-2023
@Description: This class is test class for SavvasVirtualSamplingCommunityController
@ModifiedBy: Cognizant Team
@ModifiedDate: 02-Nov-2023
@Ticket Number: VS-0012, VS-0013
*/
@isTest
public class SavvasVirtualSamplingCommunityCtrlTest {
    @testSetup 
    static void setup() {
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
            Collection_Access__c newCollectionAccess1 =  SavvasVirtualSamplingTestFactory.createCollectionAccess(newContact.Id);
            newCollectionAccess1.Name = 'Program 1';
            newCollectionAccess1.Program_Type__c = '2.0';
            collectionAccessList.add(newCollectionAccess1);
            Collection_Access__c newCollectionAccess2 =  SavvasVirtualSamplingTestFactory.createCollectionAccess(newContact.Id);
            newCollectionAccess2.Name = 'Program 2';
            newCollectionAccess2.Collection_Id__c = 'My_Testing_Collection_2';
            newCollectionAccess2.Program_Type__c = '2.0';
            collectionAccessList.add(newCollectionAccess2);
            Insert collectionAccessList;
            
            List<ProductCatalog> productCatalogList = new List<ProductCatalog>();
            ProductCatalog productCatalog1= SavvasVirtualSamplingTestFactory.createProductCatalog();
            productCatalogList.add(productCatalog1);
            ProductCatalog productCatalog2= SavvasVirtualSamplingTestFactory.createProductCatalog();
            productCatalog2.Name='Product 2';
            productCatalogList.add(productCatalog2);
            Insert productCatalogList;
            
            List<ProductCategory> productCategoryList = new List<ProductCategory>();
            ProductCategory productCategory1= SavvasVirtualSamplingTestFactory.createProductCategory(productCatalogList[0].Id);
            productCategory1.CollectionID__c=collectionAccessList[0].Collection_Id__c;
            productCategoryList.add(productCategory1);
            ProductCategory productCategory2= SavvasVirtualSamplingTestFactory.createProductCategory(productCatalogList[1].Id);
            productCategory2.Name='Product 12';
            productCategory2.CollectionID__c=collectionAccessList[1].Collection_Id__c;
            productCategoryList.add(productCategory2);
            Insert productCategoryList;
            
            List<Virtual_Samples_Program__c> virtualSamplesProgramList = new List<Virtual_Samples_Program__c>();
            Virtual_Samples_Program__c sampleProgram1 = SavvasVirtualSamplingTestFactory.createVirtualSamplesProgram(collectionAccessList[0].Collection_Id__c);
            sampleProgram1.Parent_Collection_Lookup__c = productCategoryList[0].Id;
            virtualSamplesProgramList.add(sampleProgram1);
            Virtual_Samples_Program__c sampleProgram2 = SavvasVirtualSamplingTestFactory.createVirtualSamplesProgram(collectionAccessList[1].Collection_Id__c);
            sampleProgram2.Name = 'Program 2';
            sampleProgram2.Program_Description__c = 'Virtual Sample program 2';
            sampleProgram2.Parent_Collection_Lookup__c = productCategoryList[1].Id;
            virtualSamplesProgramList.add(sampleProgram2);
            Insert virtualSamplesProgramList;
            
            List<Samples_Category__c> samplesCategoryList = new List<Samples_Category__c>();
            Samples_Category__c sampleCategory1 = SavvasVirtualSamplingTestFactory.createSamplesCategory(virtualSamplesProgramList[0].Id);
            sampleCategory1.Sequence__c=1.00;
            samplesCategoryList.add(sampleCategory1);
            Samples_Category__c sampleCategory2 = SavvasVirtualSamplingTestFactory.createSamplesCategory(virtualSamplesProgramList[1].Id);
            sampleCategory2.Name = 'Sample 2';
            sampleCategory2.Sequence__c=2.00;
            samplesCategoryList.add(sampleCategory2);
            Samples_Category__c sampleCategory3 = SavvasVirtualSamplingTestFactory.createSamplesCategory(virtualSamplesProgramList[1].Id);
            sampleCategory3.Sequence__c=3.00;
            sampleCategory3.Name = 'Sample 3';
            samplesCategoryList.add(sampleCategory3);
            Insert samplesCategoryList;
            
            List<Sample_Asset__c> sampleAssetList = new List<Sample_Asset__c>();
            Sample_Asset__c sampleAsset1 = SavvasVirtualSamplingTestFactory.createSampleAsset();
            sampleAsset1.Asset_Type__c='Conforming Asset';
            sampleAsset1.Entity_Id__c ='32139';
            sampleAsset1.Virtual_Samples_Program__c = virtualSamplesProgramList[0].Id;
            sampleAssetList.add(sampleAsset1);
            Sample_Asset__c sampleAsset2 = SavvasVirtualSamplingTestFactory.createSampleAsset();
            sampleAsset2.Name = 'Asset 2';
            sampleAsset2.Asset_Type__c='Conforming Asset';
            sampleAsset2.Entity_Id__c ='32139';
            sampleAsset2.Resource_Type__c = 'Student Resources';
            sampleAsset2.Virtual_Samples_Program__c = virtualSamplesProgramList[1].Id;
            sampleAssetList.add(sampleAsset2);
            Sample_Asset__c sampleAsset21 = SavvasVirtualSamplingTestFactory.createSampleAsset();
            sampleAsset21.Name = 'Asset21';
            sampleAsset21.Asset_Type__c='Non Conforming Asset';
            sampleAsset21.Resource_Type__c = 'Classroom Resources';
            sampleAsset21.Virtual_Samples_Program__c = virtualSamplesProgramList[1].Id;
            sampleAssetList.add(sampleAsset21);
            Sample_Asset__c sampleAsset3 = SavvasVirtualSamplingTestFactory.createSampleAsset();
            sampleAsset3.Name = 'Asset 3';
            sampleAsset3.Asset_Type__c='Conforming Asset';
            sampleAsset3.Entity_Id__c ='32139';
            sampleAsset3.Resource_Type__c = 'Classroom Resources';
            sampleAsset3.Virtual_Samples_Program__c = virtualSamplesProgramList[1].Id;
            sampleAssetList.add(sampleAsset3);
            Insert sampleAssetList;
            
            List<Samples_Category_Asset__c> samplesCategoryAssetList = new List<Samples_Category_Asset__c>();
            Samples_Category_Asset__c samplesCategoryAsset1 = SavvasVirtualSamplingTestFactory.createSamplesCategoryAsset(virtualSamplesProgramList[0].Id, sampleAssetList[0].Id, samplesCategoryList[0].Id);
            samplesCategoryAsset1.Sequence__c = 2.1;
            samplesCategoryAssetList.add(samplesCategoryAsset1);
            Samples_Category_Asset__c samplesCategoryAsset2 = SavvasVirtualSamplingTestFactory.createSamplesCategoryAsset(virtualSamplesProgramList[1].Id, sampleAssetList[1].Id, samplesCategoryList[1].Id);
            samplesCategoryAsset2.Name = 'Asset 2';
            samplesCategoryAsset2.Sequence__c = 2.1;
            samplesCategoryAssetList.add(samplesCategoryAsset2);
            Samples_Category_Asset__c samplesCategoryAsset21 = SavvasVirtualSamplingTestFactory.createSamplesCategoryAsset(virtualSamplesProgramList[1].Id, sampleAssetList[1].Id, samplesCategoryList[1].Id);
            samplesCategoryAsset21.Name = 'Asset21';
            samplesCategoryAsset21.Sequence__c = 3.1;
            samplesCategoryAssetList.add(samplesCategoryAsset21);
            Samples_Category_Asset__c samplesCategoryAsset22 = SavvasVirtualSamplingTestFactory.createSamplesCategoryAsset(virtualSamplesProgramList[1].Id, sampleAssetList[2].Id, samplesCategoryList[1].Id);
            samplesCategoryAsset22.Name = 'Asset22';
            samplesCategoryAsset22.Sequence__c = 1.1;
            samplesCategoryAssetList.add(samplesCategoryAsset22);
            Samples_Category_Asset__c samplesCategoryAsset3 = SavvasVirtualSamplingTestFactory.createSamplesCategoryAsset(virtualSamplesProgramList[1].Id, sampleAssetList[3].Id, samplesCategoryList[2].Id);
            samplesCategoryAsset3.Name = 'Asset 3';
            samplesCategoryAsset3.Sequence__c = 2.1;
            samplesCategoryAssetList.add(samplesCategoryAsset3);
            Insert samplesCategoryAssetList;
            
            Profile profile = [SELECT Id,Name from Profile where profile.Name = 'Savvas Sample Resources'];
            User newUser = SavvasVirtualSamplingTestFactory.getUser(profile.Id);
            newUser.Email=newContact.Email;
            newUser.contactId=newContact.Id;
            newUser.UserName=newContact.Email;
            Insert newUser;
        }
    }
    
    @isTest
    Public static void getProgramDetailsTest(){
        Test.startTest();
        User user = [SELECT Id from User where Email='Testdummy@test9012.com'];
        System.runAs(user){
            try{            
                SavvasVirtualSamplingCommunityHelper.programContainer programContainer = SavvasVirtualSamplingCommunityController.getProgramDetails();
                Assert.areEqual('Program 1',programContainer.programList[0].name, 'Program Name is not as expected');
                Assert.areEqual('Savvas Realize',programContainer.programBannerData.get('Program 1').programRightBanner, 'programRightBanner is not as expected');
                Assert.areEqual('Asset 1',programContainer.assetDetails.get('Program 1').get('Sample 1').get('Teacher Resources')[0].assetName, 'assetName is not as expected');
            }
            catch(Exception e){
                Assert.areEqual('System.AuraHandledException', e.getTypeName(),'Exception');
            }
        }
        Test.stopTest();
    }
    @isTest
    static void getProgramDetailsTestException() {
        try {
            Contact con = [SELECT Id,Name FROM Contact WHERE Email='Testdummy@test9012.com'];
            List<Collection_Access__c> cAList = [SELECT Id FROM Collection_Access__c WHERE Contact__c =: con.Id];
            DELETE cAList;
            User usr = [SELECT Id FROM User where ContactId=: con.Id];
            System.runAs(usr){
                SavvasVirtualSamplingCommunityHelper.programContainer programContainer = SavvasVirtualSamplingCommunityController.getProgramDetails();
                Assert.areNotEqual(null,programContainer, 'programContainer is null');
            }
        } catch (Exception e) {
            Assert.areEqual('Script-thrown exception', e.getMessage(),'Exception'); 
        }
    }
}