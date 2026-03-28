/*
Apex Test Class:scc_EnosixOrderSubmissionErrorsTest
Author: CTS (Dhiyaneswari)
Created Date: 16/07/2024
Modified Date:
*/
@isTest
public class scc_EnosixOrderSubmissionErrorsTest {
    
    /**
*  Description: Below method is to create test data
*  @name: setupTestData
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @testSetup
    static void setupTestData() {        
        Account acc= scc_TestDataFactory.accountCreation('testAccount1');
        
        List<Contact> cList=new List<Contact>();
        Contact cont = new Contact();
        cont.AccountId = acc.id;
        cont.LastName = 'Testing';
        cont.Email = 'abc@xyz.com';
        cont.FirstName = 'Test';
        cList.add(cont); 
        insert cList;
        
        WebStore webStr = new WebStore();
        webStr.Name = 'MySavvasOrders';
        webStr.PricingStrategy = 'LowestPrice';
        insert webStr;
        
        Profile pd = [Select id From profile where name = 'Customer Community Login User' limit 1];
        user us=[select id from user where profile.name= 'System Administrator' and id != :userinfo.getUserID() and isActive=true limit 1];
        
        List<User> userList=new List<User>();
        
        user ru= new User(contactID=cList[0].id, Alias = 'ruser', Email='standardistuser6@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId= pd.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@testorg.com'); 
        userList.add(ru);
        insert userList;
        
        WebCart activeCart =scc_TestDataFactory.webCartCreation( acc.Id, userList[0].Id, webStr.Id);
        
        Order ord = New Order();
        ord.Type='Stock';
        ord.AccountId=acc.Id;
        ord.Status='Draft';
        ord.PONumber__c = 'PO-10000577021';
        ord.SAP_Document_Number__c = '10000';
        ord.EffectiveDate = system.today();
        ord.BillingpostalCode = '1234';
        ord.BillingCountry = 'United States';
        ord.BillingState = 'FL';
        ord.BillingCity = 'test';
        ord.Order_Status_Code__c = 'Open';
        ord.BillingName__c ='Anny Wack';
        ord.Billingstreet ='123 test';
        ord.Order_Confirmation_Sent__c = false;
        ord.Customer_Email__c='testuser@example.com';
        ord.ShippingpostalCode = '1234';
        ord.ShippingCountry = 'United States';
        ord.ShippingState = 'FL';
        ord.ShippingCity = 'test';
        ord.ShippingStreet ='123 test';
        ord.ShipTo_Name__c ='test name';
        ord.Order_Confirmation_Sent__c=false;
        ord.Customer_Email__c ='testuser@example.com'; 
        ord.PriceBook2Id = Test.getStandardPricebookId();
        insert ord; 
        
        Case testCase = new Case(            
            Subject = 'Test Case',
            Status = 'New'
        );
        insert testCase;
    }
    
    /**
*  Description: Below method to test user friendly message from custom metadata
*  @name: testGetUserFriendlyErrorMessage
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void testGetUserFriendlyErrorMessage() {
        Test.startTest();
        String errorCode = '200';
        WebCart cart = [SELECT Id FROM WebCart where Name = 'cart' LIMIT 1];
        String cartId = cart.Id;
        Map<String, String> result = scc_EnosixOrderSubmissionErrors.getUserFriendlyErrorMessage(errorCode, cartId);
        scc_EnosixOrderSubmissionErrors.getUserDetails(cartId);
        scc_EnosixOrderSubmissionErrors.getUserFriendlyErrorMessage('152', cartId);
        scc_EnosixOrderSubmissionErrors.getUserFriendlyErrorMessage('111', cartId);
        scc_EnosixOrderSubmissionErrors.getUserFriendlyErrorMessage('200', cartId);
        System.assertEquals('We are unable to validate the Customer Account for Cart ID:'+cartId+'; error code 200.', result.get('errorMessage'));
        System.assertEquals('true', result.get('support'));
        Test.stopTest();
    }
    
    /**
*  Description: Below method is test method that covers createCase, createCaseProfile 
*  @name: testGetUserFriendlyErrorMessage
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void testCreateCase() {
        Test.startTest();
        Account acc= scc_TestDataFactory.accountCreation('Account01');
        WebCart cart = [SELECT Id FROM WebCart where Name = 'cart' LIMIT 1];
        String cartId = cart.Id;
        String description = 'Test description';
        User PortalGuest = [SELECT Id FROM User WHERE Name = 'MySavvasOrders Site Guest User'][0];
        System.RunAs(PortalGuest){
            scc_EnosixOrderSubmissionErrors.getUserDetails(cartId);
        }
        
        String caseNumber = scc_EnosixOrderSubmissionErrors.createCase(cartId, 'casedescription','test usr','test@test.com','Order Submission Error');
        scc_EnosixOrderSubmissionErrors.createCaseProfile(description,'test usr','test@test.com','Order Submission Error');
        scc_EnosixOrderSubmissionErrors.createCaseSendEmail('Other','username','user01','test@test.com','Account01','123 ABC','Case created for order submission issue');
        scc_EnosixOrderSubmissionErrors.createCaseForInternalUser('Other','username','test@test.com','Case created for order submission issue', 'Account01','12345','true','false',acc.id);
        Case createdCase = [SELECT Id, Subject, Status, Origin, Description FROM Case WHERE CaseNumber = :caseNumber LIMIT 1];
        System.assertEquals('Test Case', createdCase.Subject);
        System.assertEquals('New', createdCase.Status);
        System.assertEquals('Phone', createdCase.Origin);        
        Test.stopTest();
    }
    
    /**
*  Description: Below method is test method that covers sendEmailToUser, sendEmailToUserProfile and updateCartAndOrder
*  @name: testGetUserFriendlyErrorMessage
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void testSendEmailToUser() {
        Test.startTest();
        WebCart cart = [SELECT Id FROM WebCart where Name = 'cart' LIMIT 1];
        String cartId = cart.Id;
        Order ord = [select Id, Status, ActivatedDate from Order where PONumber__c = 'PO-10000577021' LIMIT 1]; 
        String caseNumber = scc_EnosixOrderSubmissionErrors.createCase(cartId, 'casedescription','test usr','test@test.com','Order Submission Error');
        Case createdCase = [SELECT Id, Subject, Status, Origin, Description FROM Case WHERE CaseNumber = :caseNumber LIMIT 1];
        scc_EnosixOrderSubmissionErrors.sendEmailToUser(casenumber,'test@test.com');
        scc_EnosixOrderSubmissionErrors.sendEmailToUserProfile(casenumber,'test','my savvas order','accountname','test@test.com','Test');
        scc_EnosixOrderSubmissionErrors.updateCartAndOrder(cart.Id,ord.Id);
        Test.stopTest();
    }
    
    @isTest
    static void testUploadFile() {
        // Create a test record
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        // Base64 encode a sample file content
        String sampleContent = 'Sample file content';
        String base64Data = EncodingUtil.base64Encode(Blob.valueOf(sampleContent));
        
        // Call the method
        String result = scc_EnosixOrderSubmissionErrors.uploadFile('TestFile.txt', base64Data, testAccount.Id);
        
        // Verify the result
        System.assertEquals('File uploaded successfully!', result);
        
        // Verify the ContentVersion record
        ContentVersion cv = [SELECT Id, Title, VersionData FROM ContentVersion WHERE Title = 'TestFile.txt' LIMIT 1];
        System.assertEquals('TestFile.txt', cv.Title);        
    }
        
}