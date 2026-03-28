@isTest
public class profileTest {
	 @testSetup
    static void setupTestData() {
        // Create a user for testing
        User testUser = [SELECT Id FROM User WHERE IsActive = TRUE LIMIT 1];
        
        // Create a WebCart record
        WebCart testWebCart = new WebCart(
            Name = 'Test WebCart',
            OwnerId = testUser.Id,
            Status = scc_constantHelper.STATUS_ACTIVE,
            IsSecondary = scc_constantHelper.FALSE_VALUE,
            Shipping_City__c = 'New York',
            Shipping_Country__c = 'USA',
            Shipping_State__c = 'NY',
            Shipping_Street__c = '123 Test St',
            Shipping_Zip_Code__c = '10001'
        );
        insert testWebCart;

        // Create Product2 for CartItem
        Product2 testProduct = new Product2(
            Name = 'Test Product',
            Availability__c = 'Available',
            ISBN13__c = '9781234567890',
            ISBN10__c = '1234567890',
            Description = 'Test Product Description',
            Copyright_Year__c = '2024',
            Grade_Level__c = '10',
            Product_Status__c = 'Active'
        );
        insert testProduct;
        
        // Create CartItem records associated with the WebCart
        CartItem cartItem1 = new CartItem(
            CartId = testWebCart.Id,
            Product2Id = testProduct.Id,
            Quantity = 2,
            TotalPrice = 100
        );
        CartItem cartItem2 = new CartItem(
            CartId = testWebCart.Id,
            Product2Id = testProduct.Id,
            Quantity = 3,
            TotalPrice = 150
        );
        insert new List<CartItem> { cartItem1, cartItem2 };
    }
    
    @isTest
    static void testGetActiveCartCount() {
        // Run the test in the context of the current test user
        Test.startTest();
        Integer result = scc_profileMenuCartController.getActiveCartCount();
        Test.stopTest();
        
        // Verify that the result is as expected (2 + 3 = 5)
        System.assertEquals(5, result, 'The cart quantity count should be 5.');
    }

}