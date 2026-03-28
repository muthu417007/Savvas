/*********************************************************** 
* @Class Name  - scc_holdCartPageController_Test
* @description - Test class for scc_holdCartPageController
* @Created By  - CTS-Muthukumar
* @Created On - 2024-05-20
* **********************************************************/ 
@isTest
public class scc_holdCartPageController_Test {
    /**
*  Description: Below test class method will setup test data and test updateToHeldCart, updateHeldCartName from class scc_holdCartPageController
*  @name: testClassMethod
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void testClassMethod(){
        
        Account acc= scc_TestDataFactory.accountCreation('testAccount3');
        Contact con = scc_TestDataFactory.contactCreation( acc.Id, 'firstname3', 'testlastname3', 'testemail@abc.com');
        
        
        User testUser = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Customer Community Login User' LIMIT 1].Id,
            LastName = 'Test User',
            Email = 'uniqueemailid2@savvas.com',
            Username = 'uniqueemailid2@savvas.com' + System.currentTimeMillis(),
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
        PermissionSet ps =[SELECT Id FROM PermissionSet WHERE Label = 'Savvas Commerce Cloud External Users Permissions' OR  Name = 'Savvas_Commerce_Cloud_External_Users_Permissions'];
        PermissionSet ps1 =[SELECT Id FROM PermissionSet WHERE Name = 'B2BBuyer' AND Label = 'Buyer'];
        User testUserr = [SELECT Id FROM User WHERE Email = 'uniqueemailid2@savvas.com' LIMIT 1];
        
        System.runAs (thisUser) {
            
            PermissionSetAssignment   psAssignment = new PermissionSetAssignment();
            psAssignment.PermissionSetId = ps.Id;
            psAssignment.AssigneeId = testUserr.Id;
            psAssignment.PermissionSetId = ps1.Id;
            psAssignment.AssigneeId = testUserr.Id;
            
            insert psAssignment;
            
        }
        TEST.StartTest();
        
        User testUser1 = [SELECT Id FROM User WHERE Email = 'uniqueemailid2@savvas.com' LIMIT 1];        
        System.runAs(testUser1){
            
            WebCart webca=scc_TestDataFactory.webCartCreation( acc.Id, testUser1.Id, webStr.Id);
            String webCartId =webca.Id;
            CartDeliveryGroup cDG=scc_TestDataFactory.cartDeliverGroupCreation(webca.Id);
            CartItem cartItems =scc_TestDataFactory.cartItemCreation(webca.Id, prod1.Id,  cDG.Id, prod1.Name);
            List<WebCart> activeCart = [ SELECT Id
                                        FROM Webcart
                                        WHERE AccountId IN (SELECT AccountId FROM User WHERE Id = :testUser1.Id) AND OwnerId=:testUser1.Id AND Status='Active' AND IsSecondary= false ORDER BY CreatedDate DESC];
            System.assertEquals(1, activeCart.size(), 'Expected 1 Webcart to be created.');
            List<CartItem> cartItem1 = [SELECT Id, Quantity, SalesPrice, TotalPrice, Product2Id FROM CartItem ORDER BY CreatedDate ASC];
            System.assertEquals(1, cartItem1.size(), 'Expected 1 CartItems to be created.');
            scc_holdCartPageController.updateToHeldCart(activeCart[0].Id, '');
            scc_holdCartPageController.updateToHeldCart(activeCart[0].Id, 'TestCart');
            List<WebCart> heldCart = [ SELECT Id
                                      FROM Webcart
                                      WHERE AccountId IN (SELECT AccountId FROM User WHERE Id = :testUser1.Id) AND OwnerId=:testUser1.Id AND Status='Active' AND IsSecondary= true ORDER BY CreatedDate DESC];
            System.assertEquals(1, heldCart.size(), 'Expected 1 heldcart to be created.');
            scc_holdCartPageController.updateHeldCartName(webCartId,'Updated cart name');
            
        }
        Test.stopTest();
    }
    
    
}