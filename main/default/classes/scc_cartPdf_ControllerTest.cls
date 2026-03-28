/*
Apex Test Class: scc_cartPdf_ControllerTest
Author: CTS (Balamurugan D)
Created Date: 27/06/2024
Modified Date: 27/06/2024
*/
@isTest
public class scc_cartPdf_ControllerTest {
    @isTest
    static void testClassMethod(){
        
        Account acc= scc_TestDataFactory.accountCreation('testAccount1');
        Contact con = scc_TestDataFactory.contactCreation( acc.Id, 'firstname1', 'testlastname1', 'testemail@abc.com');
        
        
        User testUser = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Customer Community Login User' LIMIT 1].Id,
            LastName = 'Test User',
            Email = 'uniqueemailid@savvas.com',
            Username = 'uniqueemailid@savvas.com' + System.currentTimeMillis(),
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
        
        PermissionSet ps =[SELECT Id FROM PermissionSet WHERE Label = 'buyer'];
        
        User testUserr = [SELECT Id FROM User WHERE Email = 'uniqueemailid@savvas.com' LIMIT 1];
        
        WebCart guestCart =scc_TestDataFactory.webCartCreation(acc.Id, testUser.Id, webStr.Id);
        CartDeliveryGroup guestdeleivery = scc_TestDataFactory.cartDeliverGroupCreation(guestCart.Id);
        CartItem guestItem = scc_TestDataFactory.cartItemCreation(guestCart.Id,prod1.Id,guestdeleivery.Id,'Test Product 1');
        
        List<scc_addItemsToCartController.addcartItems> selectedProducts = new List<scc_addItemsToCartController.addcartItems>();
        List<scc_addItemsToCartController.addcartItems> selectedProducts1 = new List<scc_addItemsToCartController.addcartItems>();
        scc_addItemsToCartController.addcartItems item = new scc_addItemsToCartController.addcartItems();
        item.Product2Id =  prod1.Id;
        item.Quantity = 2;
        item.SalesPrice = 50;
        item.Name = 'Test Product 1';
        selectedProducts.add(item);
        
        scc_addItemsToCartController.addcartItems item1 = new scc_addItemsToCartController.addcartItems();
        item1.Product2Id =  prod2.Id;
        item1.Quantity = 2;
        item1.SalesPrice = 50;
        item1.Name = 'Test Product 1';
        selectedProducts.add(item1);
        
        scc_addItemsToCartController.addcartItems item2 = new scc_addItemsToCartController.addcartItems();
        item2.Product2Id =  prod1.Id;
        item2.Quantity = 2;
        item2.SalesPrice = 50;
        item2.Name = 'Test Product 1';
        selectedProducts1.add(item1);
        
        List<scc_addItemsToCartController.addcartItemsUserInputs> userInputs = new List<scc_addItemsToCartController.addcartItemsUserInputs>();
        scc_addItemsToCartController.addcartItemsUserInputs usrInp = new scc_addItemsToCartController.addcartItemsUserInputs();
        usrInp.sapUserBill =  '12345';
        usrInp.sapUserShip = '234';
        usrInp.oneTimeShip = true;
        usrInp.billCountry = 'US';
        usrInp.billStreet = '123 Test';
        usrInp.billCity = 'Houstan';
        usrInp.billState = 'Texas';
        usrInp.billZipCode = 'US';
        usrInp.guestCartId = guestCart.Id;
        usrInp.guestAccountId = acc.Id;
        userInputs.add(usrInp);
        
        List<scc_addItemsToCartController.addcartItemsUserInputs> userInputs1 = new List<scc_addItemsToCartController.addcartItemsUserInputs>();
        scc_addItemsToCartController.addcartItemsUserInputs usrInp1 = new scc_addItemsToCartController.addcartItemsUserInputs();
        usrInp1.sapUserBill =  '12345';
        usrInp1.sapUserShip = '234';
        usrInp1.oneTimeShip = true;
        usrInp1.billCountry = 'US';
        usrInp1.billStreet = '123 Test';
        usrInp1.billCity = 'Houstan';
        usrInp1.billState = 'Texas';
        usrInp1.billZipCode = 'US';
        usrInp1.guestCartId = '';
        usrInp1.guestAccountId = '';
        usrInp1.schoolDistrict = true ;
        userInputs1.add(usrInp1);
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        system.debug('current user id is'+thisUser.Id);
        
        System.runAs (thisUser) {
            
            PermissionSetAssignment   psAssignment = new PermissionSetAssignment();
            psAssignment.PermissionSetId = ps.Id;
            psAssignment.AssigneeId = testUserr.Id;
            insert psAssignment;
            
        }
        TEST.StartTest();
        
        User testUser1 = [SELECT Id FROM User WHERE Email = 'uniqueemailid@savvas.com' LIMIT 1];
        system.debug('run useras'+testUser1.Id);
        System.runAs(testUser1){
            //Account acc1 = scc_TestDataFactory.accountCreation('testAccount2');
            scc_addItemsToCartController.addItemToCart(selectedProducts, userInputs);
            WebCart activeCart = [ SELECT Id,BillingCountry, Shipping_Country__c, Shipping_State__c, Specify_One_Time_Shipping__c,School_Or_District__c,Cart_Id__c
                                  FROM Webcart
                                  WHERE AccountId IN (SELECT AccountId FROM User WHERE Id = :testUser1.Id) AND OwnerId=:testUser1.Id AND Status='Active' AND IsSecondary= false ORDER BY CreatedDate DESC];
            String activeCartId = activeCart.Id;
            system.debug('activeCartId>>>>'+activeCartId);
            scc_pdfCartController sccPdfConstructor = new scc_pdfCartController();
            scc_cartPdf_Controller.generatePdf();
            
        }
        Test.stopTest();
    }
    
    @isTest
    static void testFormatWithCommas() {
        Decimal testDecimal = 1234567.89;
        Integer testInteger = 1234567;
        
        String formattedDecimal = scc_pdfCartController.formatWithCommas(testDecimal);
        String formattedInteger = scc_pdfCartController.formatWithCommas(testInteger);        
        
        System.assertEquals('1,234,567.89', formattedDecimal);
        System.assertEquals('1,234,567', formattedInteger);
    }
    
}