/*
Apex Test Class:scc_fetchHeldCartController_Test
Author: CTS (Varshaa)
Created Date: 16/10/2024
Reason: This test class is for class scc_FetchHeldCart_Controller
Modified Date:
*/
@isTest
public with sharing class scc_fetchHeldCartController_Test {
    /**
*  Description: Below method will create test data and methods of scc_FetchHeldCart_Controller
*  @name: testClassMethod
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void testClassMethod(){
        
        Account acc= scc_TestDataFactory.accountCreation('testAccount3');
        Account acc1= scc_TestDataFactory.accountCreation('testAccount1');
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
        
        TEST.StartTest();
        
        User testUser1 = [SELECT Id FROM User WHERE Email = 'uniqueemailid2@savvas.com' LIMIT 1];
        
        System.runAs(testUser1){
            WebCart webca=scc_TestDataFactory.webCartCreation( acc1.Id, testUser1.Id, webStr.Id);
            scc_FetchHeldCart_Controller.getHeldCartRecords();
            scc_FetchHeldCart_Controller.getAllHeldCartRecords();
            WebCart webca1=scc_TestDataFactory.webCartCreation( acc.Id, testUser1.Id, webStr.Id);
            WebCart webca2=scc_TestDataFactory.webCartCreationIsSec( acc.Id, testUser1.Id, webStr.Id);
            
            CartDeliveryGroup cDG1=scc_TestDataFactory.cartDeliverGroupCreation(webca1.Id);
            CartItem cartItems1 =scc_TestDataFactory.cartItemCreation(webca1.Id, prod1.Id,  cDG1.Id, prod1.Name);
            
            String webCartId2 =webca2.Id;
            CartDeliveryGroup cDG2=scc_TestDataFactory.cartDeliverGroupCreation(webca2.Id);
            CartItem cartItems2 =scc_TestDataFactory.cartItemCreation(webca2.Id, prod1.Id,  cDG2.Id, prod1.Name);
            
            List<WebCart> activeCart = [ SELECT Id
                                        FROM Webcart
                                        WHERE AccountId IN (SELECT AccountId FROM User WHERE Id = :testUser1.Id) AND OwnerId=:testUser1.Id AND Status='Active' AND IsSecondary= false ORDER BY CreatedDate DESC];
            System.assertEquals(1, activeCart.size(), 'Expected 1 Webcart to be created.');
            List<CartItem> cartItem1 = [SELECT Id, Quantity, SalesPrice, TotalPrice, Product2Id FROM CartItem ORDER BY CreatedDate ASC];
            System.assertEquals(2, cartItem1.size(), 'Expected 2 CartItems to be created.');
            scc_FetchHeldCart_Controller.getHeldCartRecords();
            scc_FetchHeldCart_Controller.getAllHeldCartRecords();
            scc_FetchHeldCart_Controller.getAllHeldCartRecordsByCartName('cart');
            scc_FetchHeldCart_Controller.getAllHeldCartRecordsByCartName('1234');
            
            List<WebCart> heldCart = [ SELECT Id
                                      FROM Webcart
                                      WHERE AccountId IN (SELECT AccountId FROM User WHERE Id = :testUser1.Id) AND OwnerId=:testUser1.Id AND Status='Active' AND IsSecondary= true ORDER BY CreatedDate DESC];
            scc_FetchHeldCart_Controller.deleteCartItem(heldCart[0].id);
            System.assertEquals(1, heldCart.size(), 'Expected 1 heldcart to be created.');   
        }
        Test.stopTest();
    }
}