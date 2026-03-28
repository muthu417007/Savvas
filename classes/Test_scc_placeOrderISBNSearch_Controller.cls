@isTest
private class Test_scc_placeOrderISBNSearch_Controller {
    
    @isTest
    static void testSearchProducts() {
        // Create test data with ISBN13 value
        Product2 testProduct1 = new Product2(
            Name = 'Test Product 1',
            ISBN10__c = '1234567890',
            ISBN13__c = '1234567890123',
            Description = 'Test Description 1',
            Product_Sub_Type__c = 'Test Type 1',
            Grade_Level__c = 'Test Grade 1',
            Copyright_Year__c = '2022',
            Product_Status__c = 'Active',
            Net_Price__c = 50.0,
            IsActive = true,
            SAP_A_Check__c = true,
            Material_Type_ID__c = 'ZSBN'
        );
        insert testProduct1;

        // Create test data with ISBN10 value
        Product2 testProduct2 = new Product2(
            Name = 'Test Product 2',
            ISBN10__c = '9876543210',
            Description = 'Test Description 2',
            Product_Sub_Type__c = 'Test Type 2',
            Grade_Level__c = 'Test Grade 2',
            Discipline__c = 'Test Discipline',
            Copyright_Year__c = '2022',
            Product_Status__c = 'Active',
            Net_Price__c = 50.0,
            IsActive = false, // Add inactive product
            SAP_A_Check__c = true,
            Material_Type_ID__c = 'ZSBN'
        );
        insert testProduct2;

        // Call the method to be tested with ISBN13 value
        List<scc_placeOrderISBNSearch_Controller.ProductWrapper> products1 = scc_placeOrderISBNSearch_Controller.searchProducts('1234567890123', null, null, true);

        // Verify results for ISBN13 value
        if (products1.isEmpty()) {
            throw new System.AssertException('No products were returned');
        }
        scc_placeOrderISBNSearch_Controller.ProductWrapper productWrapper1 = products1[0];
        if (!productWrapper1.ISBN.equals('1234567890123')) {
            throw new System.AssertException('ISBN should match');
        }
        if (!productWrapper1.showISBN13Field) {
            throw new System.AssertException('ISBN13 field should be shown');
        }

        // Call the method to be tested with ISBN10 value and non-null selectedDiscipline
        List<scc_placeOrderISBNSearch_Controller.ProductWrapper> products2 = scc_placeOrderISBNSearch_Controller.searchProducts('9876543210', 'Test Discipline', null, false); // Set activeProducts to false

        // Verify results for ISBN10 value and non-null selectedDiscipline
        if (products2.isEmpty()) {
            throw new System.AssertException('No products were returned');
        }
        scc_placeOrderISBNSearch_Controller.ProductWrapper productWrapper2 = products2[0];
        if (!productWrapper2.ISBN.equals('9876543210')) {
            throw new System.AssertException('ISBN should match');
        }
        if (productWrapper2.showISBN13Field) {
            throw new System.AssertException('ISBN13 field should not be shown');
        }
    }
}