@IsTest
public class scc_cloneOrderController_Test {
    @isTest
    static void testClassMethod(){
        
        Account acc= scc_TestDataFactory.accountCreation('testAccount1');
        Contact con = scc_TestDataFactory.contactCreation( acc.Id, 'firstname1', 'testlastname1', 'testemail@abc.com');
        User testUser= scc_TestDataFactory.userCreation(con.Id);
        WebStore webStr = new WebStore();
        webStr.Name = 'MySavvasOrders';
        webStr.PricingStrategy = 'LowestPrice';
        insert webStr;
       
        scc_TestDataFactory.initialStorefrontSetup(webStr.Id, acc.Id, acc.Name);
        
        Product2 prod1 = scc_TestDataFactory.productCreation1();
        Product2 prod2 = scc_TestDataFactory.productCreation2();
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        system.debug('current user id is'+thisUser.Id);
        PermissionSet ps =[SELECT Id FROM PermissionSet WHERE Label = 'buyer'];
      
        System.runAs (thisUser) {      
                PermissionSetAssignment   psAssignment = new PermissionSetAssignment();
                psAssignment.PermissionSetId = ps.Id;
                psAssignment.AssigneeId = testUser.Id;
                insert psAssignment;             
        }
           TEST.StartTest();
 
        User testUser1 = [SELECT Id FROM User WHERE Email = 'testuser@example.com' LIMIT 1];
        system.debug('run useras'+testUser1.Id);
        List<scc_cloneOrderController.addcartItemsUserInputs> userInputs = new List<scc_cloneOrderController.addcartItemsUserInputs>();
        scc_cloneOrderController.addcartItemsUserInputs usrInp = new scc_cloneOrderController.addcartItemsUserInputs();
        usrInp.sapUserShip = '234';
        usrInp.oneTimeShip = true;
        usrInp.shipCountry = 'US';
        userInputs.add(usrInp);
        System.runAs(testUser){
            
            WebCart webca=scc_TestDataFactory.webCartCreation( acc.Id, testUser.Id, webStr.Id);
            CartDeliveryGroup cDG=scc_TestDataFactory.cartDeliverGroupCreation(webca.Id);
            CartItem cartItems =scc_TestDataFactory.cartItemCreation(webca.Id, prod1.Id,  cDG.Id, prod1.Name);
   			scc_cloneOrderController.cloneOrderController(webca.Id,userInputs );
           // scc_changeCartAsSecondary.changeHeldToActiveCart(webca.Id);
           	
           
	     }
         Test.stopTest();
}
    @isTest
    static void getCurrentUserShippingAddressTest(){
        TEST.StartTest();

         Account acc= scc_TestDataFactory.accountCreation('testAccount4');
         acc.type='International School';
         update acc;
         Contact con = scc_TestDataFactory.contactCreation( acc.Id, 'firstname4', 'testlastname4', 'testemail1@abc.com');
         User testUser= scc_TestDataFactory.userCreation(con.Id);
         User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
         system.debug('current user id is'+thisUser.Id);
        
         PermissionSet ps =[SELECT Id FROM PermissionSet WHERE Label = 'buyer'];
      
         System.runAs (thisUser) {      
                PermissionSetAssignment   psAssignment = new PermissionSetAssignment();
                psAssignment.PermissionSetId = ps.Id;
                psAssignment.AssigneeId = testUser.Id;
                insert psAssignment;             
         }
        
        // Create test data for Affiliation__c
        Affiliation__c testAffiliation = new Affiliation__c(
            Parent_Account__c = acc.Id
            //Child_Account__c = acc.Id         
            
        );
        insert testAffiliation;
        
        
        // Create test data for Account_Addresses__c
        Account_Addresses__c testAccountAddress = new Account_Addresses__c(
            Account__c = acc.Id,
            ERP_Account_Name__c='school2',
            Address_1__c='street1',
            Address_Type__c='Billing',
            City__c='c1',
            County__c='country1c',
            ERP_Account_Number__c='8769',
            State__c='state1',
            Zip_Code__c='123' 
        );
        insert testAccountAddress;
        
        Account_Addresses__c testAccountAddress1 = new Account_Addresses__c(
            Account__c = acc.Id,
            ERP_Account_Name__c='school2',
            Address_1__c='street1',
            Address_Type__c='Billing',
            City__c='c1',
            County__c='country1c',
            ERP_Account_Number__c='8769',
            State__c='state1',
            Zip_Code__c='123' 
        );
        insert testAccountAddress1;
        
        Account_Addresses__c testAccountShipAddress = new Account_Addresses__c(
            Account__c = acc.Id,
            ERP_Account_Name__c='school2',
            Address_1__c='street1',
            Address_Type__c='Shipping',
            City__c='c1',
            County__c='country1c',
            ERP_Account_Number__c='8769',
            State__c='state1',
            Zip_Code__c='123' );
        
        insert testAccountShipAddress;
        
        Id account1=acc.Id;
        Id shipaddr=testAccountAddress.Id;
        Id billaddr= testAccountAddress1.Id;
        Id accuserid = testUser.AccountId;
        Id usrId=testUser.Id;
        WebStore webStr = new WebStore();
        webStr.Name = 'MySavvasOrders';
        webStr.PricingStrategy = 'LowestPrice';
        insert webStr;
        scc_TestDataFactory.initialStorefrontSetup(webStr.Id, acc.Id, acc.Name);
        Product2 prod1 = scc_TestDataFactory.productCreation1();
        prod1.Sales_Restriction_Code__c = '07';
        update prod1;
        
        
        System.runAs(testUser){
           	WebCart webca=scc_TestDataFactory.webCartCreation( acc.Id, testUser.Id, webStr.Id);
            CartDeliveryGroup cDG=scc_TestDataFactory.cartDeliverGroupCreation(webca.Id);
            CartItem cartItems =scc_TestDataFactory.cartItemCreation(webca.Id, prod1.Id,  cDG.Id, prod1.Name);
            List<scc_cloneOrderController.addressWrapper> shippingList = scc_cloneOrderController.getCurrentUserShippingAddress(true);
            List<scc_cloneOrderController.addressWrapper> shippingList1 = scc_cloneOrderController.getCurrentUserShippingAddress(false);
           	Boolean restrictedCartcheck = scc_cloneOrderController.checkRestrictedCartItems(cartItems.Id);
            System.assertEquals(false,shippingList.isEmpty());
            System.assertEquals(false,shippingList1.isEmpty());
            System.assertEquals(false,restrictedCartcheck);
            
        }
        
    }
}