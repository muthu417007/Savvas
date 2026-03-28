/*********************************************************** 
* @Class Name  - scc_reviewCartPageController_Test
* @description - Test class for scc_reviewCartPageController
* @Created By  - CTS-Muthukumar
* @Created On - 2024-05-20
* **********************************************************/ 
@IsTest
public class scc_reviewCartPageController_Test {
        /**
*  Description: This method to test items on review cart page    
*  @name: testClassMethod
*  @param:NA
*  @return: NA
*  @throws exception- 
*/
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
            scc_reviewCartPageController.digitalProductsCheck(webca.Id);
            prod2.Product_Type_ID__c = 'OLS';
            update prod2;
            
            scc_reviewCartPageController.digitalProductsCheck(webca.Id);                        
            scc_reviewCartPageController.getActiveCartItems(webca.Id);
            webca.User_Cart_Name__c = '';
            update webca;
            
            scc_reviewCartPageController.getActiveCartItems(webca.Id);
            scc_reviewCartPageController.getActiveCartItems('');
            scc_reviewCartPageController.getActiveCart(webca.Id);
            scc_reviewCartPageController.getActiveCart('');
            scc_reviewCartPageController.digitalProductsCheck('');
            scc_reviewCartPageController.updateCartItemQuantity(cartItems.Id, 4,466);
            scc_reviewCartPageController.deleteCartItem(cartItems.Id);
            scc_reviewCartPageController.updateCartItemQuantity(cartItems.Id, 4,466);
            scc_reviewCartPageController.getPromoCode('SUM10',webca.Id);
            
            System.assertNotEquals(null,scc_reviewCartPageController.getActiveCartItems(webca.Id));
        }
        Test.stopTest();
    }    
}