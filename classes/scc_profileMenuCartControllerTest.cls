@isTest
public class scc_profileMenuCartControllerTest {
    
    
    
        
    @isTest
    static void testClassMethod(){
        
        Account acc= scc_TestDataFactory.accountCreation('testAccount2');
        Contact con = scc_TestDataFactory.contactCreation( acc.Id, 'firstname2', 'testlastname2', 'testemail@abc.com');
        
            
        User testUser = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Customer Community Login User' LIMIT 1].Id,
            LastName = 'Test User',
            Email = 'uniqueemailid1@savvas.com',
            Username = 'uniqueemailid1@savvas.com' + System.currentTimeMillis(),
            Alias = 'tuser',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ContactId=con.Id
        );
        insert testUser;
        
        WebStore webStr = new WebStore();
        webStr.Name = 'MySavvasOrders';
        webStr.PricingStrategy = 'LowestPrice';
        insert webStr;
               
        scc_TestDataFactory.initialStorefrontSetup(webStr.Id, acc.Id, acc.Name);
        
        Product2 prod1 = scc_TestDataFactory.productCreation1();
        Product2 prod2 = scc_TestDataFactory.productCreation2();
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        system.debug('current user id is'+thisUser.Id);
        PermissionSet ps =[SELECT Id FROM PermissionSet WHERE Label = 'buyer' OR  Name = 'B2BBuyer' LIMIT 1];
        User testUserr = [SELECT Id FROM User WHERE Email = 'uniqueemailid1@savvas.com' LIMIT 1];

        System.runAs (thisUser) {
      
                PermissionSetAssignment   psAssignment = new PermissionSetAssignment();
                psAssignment.PermissionSetId = ps.Id;
                psAssignment.AssigneeId = testUserr.Id;
                insert psAssignment;
             
        }
       TEST.StartTest();
 
        User testUser1 = [SELECT Id FROM User WHERE Email = 'uniqueemailid1@savvas.com' LIMIT 1];
        system.debug('run useras'+testUser1.Id);
        System.runAs(testUser1){
            Promotion abc = new Promotion();
            abc.Name = 'SUM10';
            abc.IsActive = true;
            abc.IsCommercePromotion = true;
            abc.EndDateTime = system.today()+5;
            insert abc;
            
            WebCart webca=scc_TestDataFactory.webCartCreation( acc.Id, testUser1.Id, webStr.Id);
            CartDeliveryGroup cDG=scc_TestDataFactory.cartDeliverGroupCreation(webca.Id);
            CartItem cartItems =scc_TestDataFactory.cartItemCreation(webca.Id, prod2.Id,  cDG.Id, prod1.Name);
            system.debug('entere66');
            // scc_profileMenuCartController.getActiveCartCount();
    		 }
         Test.stopTest();
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
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
    
/*    @isTest
    static void testGetActiveCartCount() {
        // Run the test in the context of the current test user
        Test.startTest();
     //   Integer result = scc_profileMenuCartController.getActiveCartCount();
        Test.stopTest();
        
        // Verify that the result is as expected (2 + 3 = 5)
      //  System.assertEquals(5, result, 'The cart quantity count should be 5.');
    } */
}