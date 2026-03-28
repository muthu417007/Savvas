/*
Apex Test Class: scc_emailCartController_Test
Author: CTS 
Created Date: 2024-05-25
Modified Date: 17/10/2024
*/
@isTest
public class scc_emailCartController_Test {
    
    /**
*  Description:  Below method is test method that create test data and test methods of scc_emailCart_Controller
*  @name: testClassMethod
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void testClassMethod(){
        // Setup test data using scc_TestDataFactory
        Account acc = scc_TestDataFactory.accountCreation2('testAccount2');
        Contact con = scc_TestDataFactory.contactCreation(acc.Id, 'firstname2', 'testlastname2', 'testemail@abc.com');
        User testUser = scc_TestDataFactory.userCreation(con.Id);
        
        WebStore webStr = new WebStore(
            Name = 'MySavvasOrders',
            PricingStrategy = 'LowestPrice'
        );
        insert webStr;
        
        scc_TestDataFactory.initialStorefrontSetup(webStr.Id, acc.Id, acc.Name);
        
        Product2 prod1 = scc_TestDataFactory.productCreation1();
        Product2 prod2 = scc_TestDataFactory.productCreation2();
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Label = 'buyer' OR Name = 'B2BBuyer' LIMIT 1];
        
        System.runAs(thisUser) {
            PermissionSetAssignment psAssignment = new PermissionSetAssignment(
                PermissionSetId = ps.Id,
                AssigneeId = testUser.Id
            );
            insert psAssignment;
        }
        
        Test.startTest();
        
        System.runAs(testUser){
            WebCart webca = scc_TestDataFactory.webCartCreation(acc.Id, testUser.Id, webStr.Id);
            CartDeliveryGroup cDG = scc_TestDataFactory.cartDeliverGroupCreation(webca.Id);
            CartItem cartItems = scc_TestDataFactory.cartItemCreation(webca.Id, prod1.Id, cDG.Id, prod1.Name);
            
            // Test sendEmailCart method
            String emailaddrs = 'validvalid@test.com';
            Integer initialEmailInvocations = Limits.getEmailInvocations();
            scc_emailCart_Controller.sendEmailCart(emailaddrs);
            Integer finalEmailInvocations = Limits.getEmailInvocations();
            
            // Assert that an email was sent
            System.assertEquals(initialEmailInvocations + 1, finalEmailInvocations, 'An email should have been sent');
            
            // Test generateCSV method
            String csvContent = scc_emailCart_Controller.generateCSV(testUser.Id);
            
            // Assert that CSV content is not empty and contains expected headers
            System.assertNotEquals('', csvContent, 'CSV content should not be empty');
            System.assert(csvContent.contains('Sales Price,Net Unit Price,Coupon Discount,Cart ID,Cart Name'), 'CSV should contain expected headers');
            
            // Test getWebCartId method
            List<scc_emailCart_Controller.emailCartWrapper> webCartList = scc_emailCart_Controller.getWebCartId(testUser.Id);
            
            // Assert that we got a non-empty result
            System.assertNotEquals(0, webCartList.size(), 'Should return at least one WebCart');
            System.assertNotEquals('', webCartList[0].cartName, 'Cart name should not be empty');
            
            // Additional assertion to check if the cart name matches the expected value
            System.assertEquals('cart1', webCartList[0].cartName, 'Cart name should match the value set in webCartCreation method');
        }
        
        Test.stopTest();
    }
}