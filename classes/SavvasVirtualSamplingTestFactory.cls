/*
@Author : Cognizant Team
@Name : SavvasVirtualSamplingTestFactory 
@CreateDate : 13-Oct-2023
@Description: This class is test factory class for all test class
@ModifiedBy: Cognizant Team
@ModifiedDate: 02-Nov-2023
@Ticket Number: VS-0012, VS-0013
*/
public class SavvasVirtualSamplingTestFactory {
	
   /*
	*  Method Name : getAccount
	*  Description : creating test Account
	*  param : none
	*  return : Account
	*/
    public static Account getAccount(){
        Account testAccount = new Account(Name='TestParentAccount', type='International',
                                          BillingCity='New York',BillingStreet='100 Hudson Street',
                                          BillingPostalCode='10013', BillingState='NY',
                                          BillingCountry='United States',Account_Status__c = 'Active');
        return testAccount;
    }
    /*
	*  Method Name : getContact
	*  Description : creating test Contact
	*  param : accountId
	*  return : Contact
	*/
    public static Contact getContact(Id accountId){
        Contact testContact = new Contact(FirstName ='TestDummy',
                                          LastName='Test'+Integer.valueOf((Math.random())),
                                          Email= 'testdummy@test.com',
                                          AccountId = accountId);
        return testContact;
    }
    /*
	*  Method Name : getUser
	*  Description : creating test User
	*  param : profileId
	*  return : User
	*/
    public static User getUser(Id profileId){
        User testUser = new User(FirstName='TestUser', LastName='Test'+Integer.valueOf((Math.random())), 
                                        userName='testUser@test.com'+(String.valueOf(Math.random())).substring(0, 4), 
                                 		Email='testdummy@test.com'+(String.valueOf(Math.random())).substring(0, 4),
                                        emailencodingkey='UTF-8', languagelocalekey='en_US',
                                        alias = (String.valueOf(Math.random())).substring(0, 8),localesidkey='en_US', 
                                        timezonesidkey='America/Los_Angeles',
                                		ProfileId = profileId);
        return testUser;
    }
    /*
    *  Method Name : createCollectionAccess
    *  Description : creating a test Collection Access record
    *  param : contactId
    *  return : Collection Access
    */
    public static collection_Access__c createCollectionAccess(Id contactId){
        Collection_Access__c newCollectionAccess =  new Collection_Access__c();
        newCollectionAccess.Name = 'My Testing Collection 1';
        newCollectionAccess.Collection_Id__c = 'My_Testing_Collection_1';
        newCollectionAccess.Access_Granted_On__c = Date.today();
        newCollectionAccess.Access_Valid_Till__c = Date.today().addDays(Integer.valueOf(Label.Savvas_Learning_Access_Limit));
        newCollectionAccess.Program_Description__c = 'This is a testing collection access object';
        newCollectionAccess.Contact__c = contactId;
        return newCollectionAccess;
    }
    /*
    *  Method Name : createSitecoreAsset
    *  Description : creating a test Sitecore Asset record
    *  param : contactId, collectionAccessId
    *  return : Sitecore Asset
    */
    public static Sitecore_Asset__c createSitecoreAsset(Id contactId, Id collectionAccessId){
        Sitecore_Asset__c newSARecord = new Sitecore_Asset__c();
        newSARecord.Collection_Access__c = collectionAccessId;
        newSARecord.Entity_Id__c = '32139';
        newSARecord.Name ='Access Guide' ;
        newSARecord.Thumbnail_Id__c = 'ebc450df684f405ea35df3afe7415f0d?v=3dd83a7f';
        newSARecord.Contact__c = contactId;
        return newSARecord;
    }
    /*
    *  Method Name : createProductCatalog
    *  Description : creating a test ProductCatalog record
    *  param : None
    *  return : ProductCatalog
    */
    public static ProductCatalog createProductCatalog(){
        ProductCatalog productCatalog= new ProductCatalog();
        productCatalog.Name='Product Catalog 1';
        return productCatalog;
    }
    /*
    *  Method Name : createProductCategory
    *  Description : creating a test ProductCategory record
    *  param : productCatalogId, collectionAccess
    *  return : ProductCategory
    */
    public static ProductCategory createProductCategory(Id productCatalogId){
        ProductCategory ProductCategory= new ProductCategory();
        ProductCategory.Name='Product Category 1';
        ProductCategory.CatalogId=productCatalogId;
        return ProductCategory;
    }
    /*
    *  Method Name : createVirtualSamplesProgram
    *  Description : creating a test Virtual Samples Program record
    *  param : productCategoryId, collectionAccess
    *  return : Virtual Samples Program
    */
    public static Virtual_Samples_Program__c createVirtualSamplesProgram(String Collection_Id){
        Virtual_Samples_Program__c sampleProgram = new Virtual_Samples_Program__c();
        sampleProgram.Name = 'Program 1';
        sampleProgram.Program_Sample_Expiry__c = 30;
        sampleProgram.Program_Description__c = 'Virtual Sample program 1';
        sampleProgram.Program_Banner_Image_URL__c = '#';
        sampleProgram.Program_Banner_Source_URL__c = '#';
        sampleProgram.Program_Right_Banner__c = 'Savvas Realize';
        sampleProgram.Collection_Id__c = Collection_Id;
        return sampleProgram;
    }
    /*
    *  Method Name : createSamplesCategory
    *  Description : creating a test Samples Category record
    *  param : sampleProgramId
    *  return : Samples Category
    */
    public static Samples_Category__c createSamplesCategory(Id sampleProgramId){
        Samples_Category__c sampleCategory = new Samples_Category__c();
        sampleCategory.Parent_Program__c = sampleProgramId;
        sampleCategory.Name = 'Sample 1';
        
        return sampleCategory;
    }
    /*
    *  Method Name : createSampleAsset
    *  Description : creating a test Sample Asset record
    *  param : None
    *  return : Sample Asset
    */
    public static Sample_Asset__c createSampleAsset(){
        Sample_Asset__c sampleAsset = new Sample_Asset__c();
        sampleAsset.Name = 'Asset 1';
        sampleAsset.Display_Title__c = 'Asset 1';
        sampleAsset.Asset_URL__c = '#';
        sampleAsset.Resource_Type__c = 'Teacher Resources';
        sampleAsset.Sitecore_Id__c='127';
        sampleAsset.Thumbnail_URL__c = '#';
        return sampleAsset;
    }
    /*
    *  Method Name : createSamplesCategoryAsset
    *  Description : creating a test Samples Category Asset record
    *  param : sampleProgramId, sampleAssetId, sampleCategoryId
    *  return : Samples Category Asset
    */
    public static Samples_Category_Asset__c createSamplesCategoryAsset(Id sampleProgramId, Id sampleAssetId, Id sampleCategoryId){
        Samples_Category_Asset__c samplesCategoryAsset = new Samples_Category_Asset__c();
        samplesCategoryAsset.Virtual_Samples_Program__c = sampleProgramId;
        samplesCategoryAsset.Asset_Name__c = sampleAssetId;
        samplesCategoryAsset.Name = 'Asset c 1';
        samplesCategoryAsset.Sample_Category_Name__c = sampleCategoryId;
        return samplesCategoryAsset;
    }
    /*
    *  Method Name : createPermissionSet
    *  Description : creating a test PermissionSet record
    *  param : None
    *  return : PermissionSet
    */
    public static PermissionSet createPermissionSet(){
        PermissionSet permissionSet = new PermissionSet(
            Name = 'TestPermissionSet',
            Label = 'Test Permission Set'
        );
        return permissionSet;
    }
    /*
    *  Method Name : CreatePermissionSetAssignment
    *  Description : creating a test PermissionSetAssignment record
    *  param : permissionSetId, UserId
    *  return : PermissionSetAssignment
    */
    public static PermissionSetAssignment CreatePermissionSetAssignment(Id permissionSetId, Id UserId){
       	PermissionSetAssignment psa= new PermissionSetAssignment(
           	AssigneeId = UserId,
       		PermissionSetId = permissionSetId
      	);
        return psa;
    }   
    
    /*
        *  Method Name : createIntegrationUser
        *  Description : creating Integration User
        *  param : none
        *  return : User
        */
    public static User createIntegrationUser(){
        UserRole role=[SELECT Id from UserRole where name='CEO' Limit 1];
        Profile profile = [SELECT Id FROM Profile where Name='ICOM Mktg User'];
        Id permissionSetId = [SELECT Id from PermissionSet where Name = 'Samples_Community_Owner_Permission'].Id;
        User newUser = getUser(profile.Id);
        newUser.UserRoleId = role.Id;
        Insert newUser;
        
        PermissionSetAssignment psa= new PermissionSetAssignment(
           	AssigneeId = newUser.Id,
       		PermissionSetId = permissionSetId
      	);
        
        return newUser;
    }
    
}