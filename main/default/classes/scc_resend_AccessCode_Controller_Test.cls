/*
Apex Test Class:scc_resend_AccessCode_Controller_Test
Author: CTS (Dhiyaneswari)
Created Date: 16/07/2024
Modified Date:
*/
@isTest
public class scc_resend_AccessCode_Controller_Test {
    /**
*  Description: Below method is to create test data
*  @name: setupTestData
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @testSetup 
    static void setupTestData() {
        // Create a test Account
        Account account = scc_TestDataFactory.accountCreation('Test Account');
        
        // Create a test Order record
        Order testOrder = new Order(
            SAP_Document_Number__c = '1234567890',
            AccountId = account.Id,
            EffectiveDate = Date.today(),
            Status = 'Draft',
            BillingName__c = 'Test Billing'
        );
        insert testOrder;
        
        // Create test Product2 records
        List<Product2> testProducts = new List<Product2>();
        for (Integer i = 1; i <= 5; i++) {
            testProducts.add(new Product2(
                Name = 'Test Book ' + i,
                ProductCode = 'ISBN' + i,
                Description = 'Test Book Description ' + i
            ));
        }
        insert testProducts;
        
        // Create test EAccess_List__c records
        List<EAccess_List__c> testEAccesses = new List<EAccess_List__c>();
        for (Integer i = 0; i < 5; i++) {
            testEAccesses.add(new EAccess_List__c(
                Order__c = testOrder.Id,
                EAccess_Code__c = 'TESTCODE' + (i + 1),
                ISBN__c = '978123456789' + (i + 1),
                ProductId__c = testProducts[i].Id
            ));
        }
        insert testEAccesses;
    }
    
    /**
*  Description: Below method tests resend access code email
*  @name: testSendResendAccess
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void testSendResendAccess() {
        Order testOrder = [SELECT Id, SAP_Document_Number__c, OrderNumber FROM Order WHERE SAP_Document_Number__c = '1234567890' LIMIT 1];
        List<EAccess_List__c> allEAccesses = [SELECT EAccess_Code__c FROM EAccess_List__c WHERE Order__c = :testOrder.Id];
        
        // Select a subset of EAccess codes to simulate pagination
        List<String> selectedEAccessCodes = new List<String>{allEAccesses[0].EAccess_Code__c, allEAccesses[1].EAccess_Code__c};
            
            Test.startTest();
        Integer emailInvocationsBefore = Limits.getEmailInvocations();
        scc_resend_AccessCode_Controller.sendResendAccess('test@example.com', testOrder.SAP_Document_Number__c, selectedEAccessCodes);
        Integer emailInvocationsAfter = Limits.getEmailInvocations();
        Test.stopTest();
        
        // Assert that an email was sent
        System.assertEquals(1, emailInvocationsAfter - emailInvocationsBefore, 'An email should have been sent');
    }
    
    /**
*  Description: Below method is used to check if email not sent for resend access code
*  @name: testSendResendAccessNoRecords
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void testSendResendAccessNoRecords() {
        Order testOrder = [SELECT Id, SAP_Document_Number__c, OrderNumber FROM Order WHERE SAP_Document_Number__c = '1234567890' LIMIT 1];
        
        Test.startTest();
        // Pass an empty list of EAccess codes
        List<String> emptyEAccessCodes = new List<String>();
        Integer emailInvocationsBefore = Limits.getEmailInvocations();
        
        scc_resend_AccessCode_Controller.sendResendAccess('test@example.com', testOrder.SAP_Document_Number__c, emptyEAccessCodes);
        Integer emailInvocationsAfter = Limits.getEmailInvocations();
        Test.stopTest();
        
        // Assert that no email was sent
        System.assertEquals(0, emailInvocationsAfter - emailInvocationsBefore, 'No email should have been sent');
    }
}