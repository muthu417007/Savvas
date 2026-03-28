@isTest
private class scc_AccessCodeBatchProcessorTest {
    
    @TestSetup
    static void setupTestData() {
        // Create test account
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        
        // Create test products with specific product codes
        List<Product2> products = new List<Product2>();
        // Only create one product for testing to match batch size of 1
        products.add(new Product2(
            Name = 'Test Product OLS',
            ProductCode = 'TEST-OLS',
            Product_Type_ID__c = 'OLS',  // Added Product Type ID
            IsActive = true
        ));
        insert products;
        
        // Create standard price book entries
        List<PricebookEntry> pbes = new List<PricebookEntry>();
        for(Product2 prod : products) {
            pbes.add(new PricebookEntry(
                Pricebook2Id = Test.getStandardPricebookId(),
                Product2Id = prod.Id,
                UnitPrice = 100,
                IsActive = true
            ));
        }
        insert pbes;
        
        // Create test order
        Order ord = new Order(
            AccountId = acc.Id,
            EffectiveDate = Date.today(),
            Status = 'Draft',
            Pricebook2Id = Test.getStandardPricebookId(),
            Customer_Email__c = 'test@example.com',
            BillingName__c = 'Test Billing',
            SAP_Document_Number__c = 'SAP001',
            PoNumber__c = 'PO001'
        );
        insert ord;
        
        // Create single order item to match batch size of 1
        OrderItem oi = new OrderItem(
            OrderId = ord.Id,
            PricebookEntryId = pbes[0].Id,
            Quantity = 2,
            UnitPrice = 100
        );
        insert oi;
        
        // Create EAccess_Imprints__c record
        EAccess_Imprints__c eaccessImprint = new EAccess_Imprints__c(
            Admin_Email1__c = 'admin1@test.com',
            Admin_Email2__c = 'admin2@test.com',
            Email_SpecificInstructions__c = 'Test Instructions'
        );
        insert eaccessImprint;
        
        // Create EAccess_List__c records
        List<EAccess_List__c> eaccessList = new List<EAccess_List__c>();
        for(Integer i = 0; i < 3; i++) {
            eaccessList.add(new EAccess_List__c(
                ProductId__c = products[0].Id,
                EAccess_Imprints__c = eaccessImprint.Id,
                EAccess_Code__c = 'OLS_CODE' + i,
                IsMailSent__c = 'N'
            ));
        }
        insert eaccessList;
        
        // Create EAccess_Threshold__c record
        EAccess_Threshold__c threshold = new EAccess_Threshold__c(
            ProductId__c = products[0].Id,
            Avl_Stock__c = 5,
            Threshold__c = 2,
            IsSentRequest__c = false
        );
        insert threshold;
    }
    
    @isTest
    static void testNoAccessCodeScenario() {
        // Get the test order and related product
        Order testOrder = [SELECT Id FROM Order LIMIT 1];
        Product2 prod = [SELECT Id, ProductCode, Product_Type_ID__c FROM Product2 WHERE Product_Type_ID__c = 'OLS' LIMIT 1];
        
        // Set up email template mock
        EmailTemplate template = new EmailTemplate();
        template.Name = System.Label.scc_Noaccesscode_Email_Template;
        template.Subject = 'Test Subject';
        template.Body = 'Test Body';
        template.HtmlValue = 'Test HTML Body';
        
        // Update threshold to trigger no access code scenario
        EAccess_Threshold__c threshold = [
            SELECT Id, Avl_Stock__c 
            FROM EAccess_Threshold__c 
            WHERE ProductId__c = :prod.Id 
            LIMIT 1
        ];
        threshold.Avl_Stock__c = 1; 
        update threshold;
        
        Test.startTest();
        
        // Create flow input
        List<scc_AccessCodeBatchProcessor.FlowInput> flowInputs = new List<scc_AccessCodeBatchProcessor.FlowInput>();
        scc_AccessCodeBatchProcessor.FlowInput input = new scc_AccessCodeBatchProcessor.FlowInput();
        input.ordFlowId = testOrder.Id;
        flowInputs.add(input);
        
        // Execute batch
        scc_AccessCodeBatchProcessor.executeCustomBatch(flowInputs);
        
        Test.stopTest();
        
        // Verify results
        EAccess_Threshold__c updatedThreshold = [
            SELECT Id, IsSentRequest__c 
            FROM EAccess_Threshold__c 
            WHERE ProductId__c = :prod.Id
            LIMIT 1
        ];
        System.assertEquals(true, updatedThreshold.IsSentRequest__c, 'Should mark threshold as request sent');
    }
    
    @isTest
    static void testMultipleEmailsScenario() {
        // Get the test order
        Order testOrder = [SELECT Id FROM Order LIMIT 1];
        
        // Set up email template mock
        EmailTemplate template = new EmailTemplate();
        template.Name = 'scc_Access_Code_Template';
        template.Subject = 'Test Subject';
        template.Body = 'Test Body';
        template.HtmlValue = 'Test HTML Body';
        
        // Update order to have multiple email addresses
        testOrder.Customer_Email__c = 'test1@example.com test2@example.com test3@example.com';
        update testOrder;
        
        Test.startTest();
        
        // Create flow input
        List<scc_AccessCodeBatchProcessor.FlowInput> flowInputs = new List<scc_AccessCodeBatchProcessor.FlowInput>();
        scc_AccessCodeBatchProcessor.FlowInput input = new scc_AccessCodeBatchProcessor.FlowInput();
        input.ordFlowId = testOrder.Id;
        flowInputs.add(input);
        
        // Execute batch
        scc_AccessCodeBatchProcessor.executeCustomBatch(flowInputs);
        
        Test.stopTest();
        
        // Verify results
        Order updatedOrder = [SELECT Id, Access_Code_Was_Sent__c FROM Order WHERE Id = :testOrder.Id];
        System.assertEquals(true, updatedOrder.Access_Code_Was_Sent__c, 'Access code should be marked as sent');
        
        // Verify that access codes were assigned
        List<EAccess_List__c> updatedAccessCodes = [
            SELECT Id, ProductId__r.ProductCode 
            FROM EAccess_List__c 
            WHERE Order__c = :testOrder.Id
            AND ProductId__r.Product_Type_ID__c = 'OLS'  
        ];
        System.assertNotEquals(0, updatedAccessCodes.size(), 'Access codes should be assigned to the order');
    }
}