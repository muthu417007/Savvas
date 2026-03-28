@istest//(SeeAllData=true)
public class testRecentController_Test {
    public static List<User> userList=new List<User>();
    @isTest
    static void testClassMethod(){
         test.startTest();
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Schools Account'].Id;
        List<Account> acclist=new List<Account>();
        Account SchoolAccount = new Account();
        SchoolAccount.name='TestR';
        SchoolAccount.RecordTypeId = strRecordTypeId;
        SchoolAccount.SAP_Account_Id__c ='TestSAN';
        acclist.add(SchoolAccount);
       	insert accList;
        	
       	List<Contact> cList=new List<Contact>();
        Contact cont = new Contact();
        cont.AccountId = accList[0].id;
        cont.LastName = 'Testing';
        cont.Email = 'abc@xyz.com';
        cont.FirstName = 'Test';
        cList.add(cont); 
        insert cList;
        
        Product2 p = new Product2();
        p.Name = 'Test Product';
        p.Description='Test Product';
        p.ProductCode = 'ABC';
        p.ISBN10__c='0000121500';
        p.isActive = true;
        p.ISBN13__c = '0000121500';
        insert p;
        
		PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = Test.getStandardPricebookId();
        standardPrice.Product2Id = p.Id;
        standardPrice.UnitPrice = 100;
        standardPrice.IsActive = true;
        standardPrice.UseStandardPrice = false;
		insert standardPrice ;
        
        Product2 p1 = new Product2();
        p1.Name = 'Test Product';
        p1.Description='Test Product';
        p1.ProductCode = '0000121501';
        p1.ISBN10__c='0000121501';
        p1.isActive = true;
        insert p1;
        
		PricebookEntry standardPrice1 = new PricebookEntry();
        standardPrice1.Pricebook2Id = Test.getStandardPricebookId();
        standardPrice1.Product2Id = p1.Id;
        standardPrice1.UnitPrice = 100;
        standardPrice1.IsActive = true;
        standardPrice1.UseStandardPrice = false;
		insert standardPrice1 ;

        
        
        
        SAP_Invoice__c inv = new SAP_Invoice__c();
        inv.Invoice_Number__c = 'test';
        inv.Order_Number__c = '10000';
        insert inv;
        
        ZVC__Country_Phone_Code__c countPhn = new ZVC__Country_Phone_Code__c();
        countPhn.Name='testName';
        countPhn.ZVC__Country_Code__c = 'India';
        insert countPhn;
        /*
        Product2 prd = new Product2();
        prd.Name='Test';
        prd.ISBN10__c = '0123456789';
        prd.ISBN13__c = '0123456789101';
        prd.IsActive = true;
        insert prd;
        
        OrderItem oitem = new OrderItem();
        oitem.Product2Id = prd.Id;
        oitem.OrderId = ord.Id;
        oitem.UnitPrice=125.00;
        oitem.Quantity =2.00;
        oitem.SAP_Invoice_Number__c='invoice-123';
        insert oitem;
        */
        
        Account acc= scc_TestDataFactory.accountCreation('testAccount4');
        
        Contact con = scc_TestDataFactory.contactCreation( acc.Id, 'firstname4', 'testlastname4', 'testemail1@abc.com');
        
        Profile pd = [Select id From profile where name = 'Customer Community Plus Login User' limit 1];
        Profile pd2 = [Select id From profile where name = 'MySavvasOrders Profile' limit 1];
        user us=[select id from user where profile.name= 'System Administrator' and id != :userinfo.getUserID() and isActive=true limit 1];
    	//User testUser= scc_TestDataFactory.userCreation(cList[0].id);
    	User testUser1 = new User();
    	testUser1.ProfileId=pd2.Id;          
        testUser1.LastName = 'Test User';
        testUser1.Email = 'testuser@example.com';
        testUser1.Username = 'testuser@example.com' + System.currentTimeMillis();
        testUser1.Alias = 'tuser';
        testUser1.TimeZoneSidKey = 'America/Los_Angeles';
        testUser1.LocaleSidKey = 'en_US';
        testUser1.EmailEncodingKey = 'UTF-8';
        testUser1.LanguageLocaleKey = 'en_US';
        insert testUser1;
        
        Order ord = New Order();
        ord.Type='Stock';
       // ord.AccountId=SchoolAccount.Id;
       	ord.AccountId=acc.Id;
        ord.Status='Draft';
        ord.PONumber__c = 'PO-10000577021';
        ord.SAP_Document_Number__c = '10000';
        ord.EffectiveDate = system.today();
        ord.BillingpostalCode = '1234';
        ord.BillingCountry = 'United States';
        ord.BillingState = 'FL';
        ord.BillingCity = 'test';
        ord.Order_Status_Code__c = 'Open';
        ord.BillingName__c ='Anny Wack';
        ord.Billingstreet ='123 test';
        
        ord.ShippingpostalCode = '1234';
        ord.ShippingCountry = 'United States';
        ord.ShippingState = 'FL';
        ord.ShippingCity = 'test';
        ord.ShippingStreet ='123 test';
        ord.ShipTo_Name__c ='test name';
        ord.Order_Confirmation_Sent__c=false;
        ord.Customer_Email__c ='testuser@example.com';
        ord.PriceBook2Id = Test.getStandardPricebookId();
        insert ord; 
        
        OrderItem lineItem = new OrderItem();
        lineItem.OrderId = ord.Id;
        lineItem.Quantity = 24;
        lineItem.UnitPrice = 240;
        lineItem.Product2id = p.Id;
        lineItem.ISBN__c = '43534534';
        lineItem.SAP_Order_Item_status__c = 'Active';
        lineItem.ListPrice = 100;
        lineItem.Discount__c = 1;
        lineItem.PricebookEntryId=standardPrice.Id;
        insert lineItem;
        
        OrderItem lineItem1 = new OrderItem();
        lineItem1.OrderId = ord.Id;
        lineItem1.Quantity = 24;
        lineItem1.UnitPrice = 240;
        lineItem1.Product2id = p1.Id;
        lineItem1.ISBN__c = '43534535';
        lineItem1.SAP_Order_Item_status__c = 'Active';
        lineItem1.ListPrice = 100;
        lineItem1.Discount__c = 1;
        lineItem1.PricebookEntryId=standardPrice1.Id;
        insert lineItem1;
        
        User testUser=  scc_TestDataFactory.userCreation(con.Id);
        System.assertNotEquals(null,testRecentController.getCriteriaOrderdata('PO-10000577021','0000121501',System.today() - 1,System.today() + 1,'Open','','1234','','','','','','','','','PO#'));
		
       
        System.runAs(testUser1) {
            System.assertNotEquals(null,testRecentController.getCriteriaOrderdata('PO-10000577021','0000121500',System.today() - 1,System.today() + 1,'Open','','1234','','','','','','','','','PO#'));
            System.assertNotEquals(null, testRecentController.getOrderStatusData(false));

        }
        System.runAs(testUser) {
         	System.assertNotEquals(null,testRecentController.getSearchByOptions(true));
            System.assertNotEquals(null,testRecentController.getSearchByOptions(false));
            //System.assertNotEquals(null,testRecentController.getSearchByOptions());]
         	System.assertNotEquals(null,testRecentController.getOrderStatusOptions());
         	System.assertNotEquals(null,testRecentController.getCountrysOptions());
            System.assertNotEquals(null, testRecentController.getOrderStatusData(false)); // For non-credits
			System.assertNotEquals(null, testRecentController.getOrderStatusData(true));  // For credits
            System.assertNotEquals(null,testRecentController.getCriteriaOrderdata('PO-10000577021','',System.today() - 1,System.today() + 1,'Open','','','','','','','','','','','PO#'));
        	System.assertNotEquals(null,testRecentController.getCriteriaOrderdata('','',null,null,'Open','10000','','','','','','','','','','Order #'));
			System.assertNotEquals(null,testRecentController.getCriteriaOrderdata('PO-10000577021','1234',System.today() - 1,System.today() + 1,'Open','','1234','FL','','United States','','','','','','Containing ISBN'));
            System.assertNotEquals(null,testRecentController.getCriteriaOrderdata('','',null,null,'','','1234','','','','','','','','','Zip/Postal Code'));       
        	System.assertNotEquals(null,testRecentController.getCriteriaOrderdata('','',null,null,'','','','','','United States','Ann','','','','','Country'));           
			System.assertNotEquals(null,testRecentController.getCriteriaOrderdata('','',null,null,'','','','FL','test','','','','','','','State/Province'));           
			System.assertNotEquals(null,testRecentController.getCriteriaOrderdata('PO-10000577021','',null,null,'Open','','','','','','','','','TestSAN','','Customer SAN'));           
     		System.assertNotEquals(null,testRecentController.padZerosLeftforOrder('01245678',9));  
            System.assertNotEquals(null,testRecentController.getCriteriaOrderdata('PO-10000577021','',System.today() - 1,System.today() + 1,'Open','','','','','','','','','','','Our Ship-To Locations Only'));
            System.assertNotEquals(null,testRecentController.getCriteriaOrderdata('PO-10000577021','',System.today() - 1,System.today() + 1,'false','','','','','','','','','','','Our Ship-To Locations Only'));
        	System.assertNotEquals(null,testRecentController.getCriteriaOrderdata('','',null,null,'Open','','','','','','','','','','','All Orders'));   
        	System.assertNotEquals(null,testRecentController.getCriteriaOrderdata('','',null,null,'','','','','','','','','','','test','Invoice #'));
            System.assertNotEquals(null,testRecentController.getCriteriaOrderdata('PO-10000577021','',System.today() - 1,System.today() + 1,'Open','','','','','','','','test','','',scc_constantHelper.CUSTOMER_ACCOUNT));   
            System.assertNotEquals(null,testRecentController.getCriteriaOrderdata('','',null,null,'','','','','','','','2173162','','','',scc_constantHelper.CUSTOMER_ACCOUNT));   
        	System.assertNotEquals(null,testRecentController.getCriteriaOrderdata('','',null,null,'','','','','','','test','','','','',scc_constantHelper.CUSTOMER_NAME));    

        }
        // Additional setup for testing SAP_Order_Type__c
        Order creditOrder1 = new Order();
        creditOrder1.AccountId = acc.Id;
        creditOrder1.Order_Status_Code__c = 'Open';
        creditOrder1.PoNumber__c = 'PO-10000577022';
        creditOrder1.SAP_Document_Number__c = '10001';
        creditOrder1.SAP_Order_Type__c = 'ZCRC';  // Set to a value covered by the condition
        creditOrder1.EffectiveDate = system.today();
        creditOrder1.BillingName__c = 'test';
        creditOrder1.Status = 'Draft';
        creditOrder1.Customer_Email__c = 'testuser@example.com';
        creditOrder1.Order_Confirmation_Sent__c = false;
        insert creditOrder1;
        
        Order creditOrder2 = new Order();
        creditOrder2.AccountId = acc.Id;
        creditOrder2.Order_Status_Code__c = 'Open';
        creditOrder2.PoNumber__c = 'PO-10000577023';
        creditOrder2.SAP_Document_Number__c = '10002';
        creditOrder2.SAP_Order_Type__c = 'ZDMR';  // Set to a value covered by the condition
        creditOrder2.EffectiveDate = system.today();
        creditOrder2.BillingName__c = 'test';
        creditOrder2.Status = 'Draft';
        creditOrder2.Customer_Email__c = 'testuser@example.com';
        creditOrder2.Order_Confirmation_Sent__c = false;
        insert creditOrder2;

        // Run tests for non-credits
        System.runAs(testUser1) {
            System.assertNotEquals(null, testRecentController.getOrderStatusData(false)); // For non-credits
        }
        
        // Run tests for credits
        System.runAs(testUser1) {
            System.assertNotEquals(null, testRecentController.getOrderStatusData(true));  // For credits
        }

        
        List<testRecentController.getCriteriaOrderwrapper> testSwrap = new List<testRecentController.getCriteriaOrderwrapper>();
        testRecentController.updateOrder('10000');
        test.stopTest();
    }
      @isTest (seeAllData=true)
    static void testClassMethod2(){
         test.startTest();
       // List<RecentlyViewed> recentlyViewedRecords = new List<RecentlyViewed>();
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Schools Account'].Id;
        List<Account> acclist=new List<Account>();
        Account SchoolAccount = new Account();
        SchoolAccount.name='TestR';
        SchoolAccount.RecordTypeId = strRecordTypeId;
        SchoolAccount.SAP_Account_Id__c ='TestSAN';
        acclist.add(SchoolAccount);
       	insert accList;
        
        
        List<Contact> cList=new List<Contact>();
        Contact cont = new Contact();
        cont.AccountId = accList[0].id;
        cont.LastName = 'Testing';
        cont.Email = 'abc@xyz.com';
        cont.FirstName = 'Test';
        cList.add(cont); 
        insert cList;
        
        Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'Savvas External Users Base Profile' LIMIT 1];
        User testUser1 = new User(
        Alias = 'testuser',
        Email = 'testuser@example.com',
        LastName = 'Test',
        FirstName = 'User',
        Username = 'testuser@example.com',
        TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        LanguageLocaleKey = 'en_US',
        ProfileId = testProfile.Id,
        ContactId=cont.Id
        );
        insert testUser1;
        
         Order testOrder = new Order(
        AccountId = acclist[0].Id,
//        OrderNumber = '00000101',
        Order_Status_Code__c = 'Open',
        PoNumber__c = 'POYHSGSF01',
        SAP_Document_Number__c = '1000057747',
        EffectiveDate = Date.today(),
        ShipTo_Name__c = 'Rob Wilson',
        BillingName__c = 'test',
        Status='Draft',
        Account_PO_Number__c = 'POYHSGSF02',
        Customer_Email__c ='testuser@example.com',
        Order_Confirmation_Sent__c=false
        );
        insert testOrder;
         System.runAs(testUser1) {
            System.assertNotEquals(null, testRecentController.getOrderStatusData(false)); // For non-credits
            System.assertNotEquals(null, testRecentController.getOrderStatusData(true));  // For credits

          }
        
        //For else condition
// Create System Administrator user
    Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
    User adminUser = new User(
        Alias = 'admin',
        Email = 'admin@testorg.com',
        EmailEncodingKey = 'UTF-8',
        LastName = 'Admin',
        LanguageLocaleKey = 'en_US',
        LocaleSidKey = 'en_US',
        ProfileId = adminProfile.Id,
        TimeZoneSidKey = 'America/Los_Angeles',
        UserName = 'admin@testorg.com' + System.currentTimeMillis()
    );
    insert adminUser;
    
    System.runAs(adminUser) {
        // Create non-credit order
        Order nonCreditOrder = new Order(
            AccountId = acclist[0].Id,
            EffectiveDate = Date.today(),
            Status = 'Draft',
            SAP_Document_Number__c = '1000057747'
        );
        insert nonCreditOrder;
        
        // Create credit orders
        Order creditOrder1 = new Order(
            AccountId = acclist[0].Id,
            EffectiveDate = Date.today(),
            Status = 'Draft',
            SAP_Document_Number__c = '10003',
            SAP_Order_Type__c = 'ZCRC'
        );
        insert creditOrder1;
        
        Order creditOrder2 = new Order(
            AccountId = acclist[0].Id,
            EffectiveDate = Date.today(),
            Status = 'Draft',
            SAP_Document_Number__c = '10004',
            SAP_Order_Type__c = 'ZDMR'
        );
        insert creditOrder2;
        
        // Force creation of RecentlyViewed records
        List<Order> ordersToView = [SELECT Id FROM Order WHERE Id IN (:nonCreditOrder.Id, :creditOrder1.Id, :creditOrder2.Id)];
        for(Order ord : ordersToView) {
            Order viewedOrder = [SELECT Id FROM Order WHERE Id = :ord.Id FOR VIEW];
        }
        
        // Test non-credit orders
        String nonCreditResult = testRecentController.getOrderStatusData(false);
        System.debug('Non-credit result: ' + nonCreditResult);
        System.assertNotEquals(null, nonCreditResult, 'Non-credit result should not be null');
        System.assert(nonCreditResult.contains('1000057747'), 'Non-credit result should contain the regular order');
        
        // Test credit orders
        String creditResult = testRecentController.getOrderStatusData(true);
        System.debug('Credit result: ' + creditResult);
        System.assertNotEquals(null, creditResult, 'Credit result should not be null');
        System.assert(creditResult.contains('10003'), 'Credit result should contain ZCRC order');
        System.assert(creditResult.contains('10004'), 'Credit result should contain ZDMR order');
    }
    
    Test.stopTest();
}
     @isTest
    static void testGetStatesOptions() {
        // Create sample data for SCC_StateInfo__c
        SCC_StateInfo__c state1 = new SCC_StateInfo__c(Name='California', State_Code__c='CA');
        SCC_StateInfo__c state2 = new SCC_StateInfo__c(Name='Texas', State_Code__c='TX');
        SCC_StateInfo__c state3 = new SCC_StateInfo__c(Name='New York', State_Code__c='NY');
        insert state1;
        insert state2;
        insert state3;

        Test.startTest();

        // Call the getStatesOptions method
        String result = testRecentController.getStatesOptions();
        
        Test.stopTest();
        
        // Deserialize the JSON result
        List<testRecentController.geStatesOptionsWrapper> statesOptions = 
            (List<testRecentController.geStatesOptionsWrapper>) JSON.deserialize(result, List<testRecentController.geStatesOptionsWrapper>.class);
        
        // Verify the results
        System.assertEquals(3, statesOptions.size(), 'There should be 3 states options');
        
        // Verify that the states are returned in the expected order
        System.assertEquals('California', statesOptions[0].label, 'First state should be California');
        System.assertEquals('CA', statesOptions[0].value, 'First state code should be CA');
        
        System.assertEquals('New York', statesOptions[1].label, 'Second state should be New York');
        System.assertEquals('NY', statesOptions[1].value, 'Second state code should be NY');
        
        System.assertEquals('Texas', statesOptions[2].label, 'Third state should be Texas');
        System.assertEquals('TX', statesOptions[2].value, 'Third state code should be TX');
    }
}