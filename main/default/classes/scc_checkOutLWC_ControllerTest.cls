/*********************************************************** 
* @Class Name  - scc_checkOutLWC_ControllerTest
* @description - Test class for scc_addItemsToCartController
* @Created By  - CTS-Suresh Kalshetti
* @Created On - 2024-05-21
* **********************************************************/ 
@istest 
public class scc_checkOutLWC_ControllerTest {
    public static List<User> userList=new List<User>();
    @isTest
    static void testClassMethod(){
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
        
        Account_Addresses__c testAccountShipAddress = new Account_Addresses__c(
            Account__c = accList[0].Id,
            ERP_Account_Name__c='school2',
            Address_1__c='street1',
            Address_Type__c='Shipping',
            City__c='c1',
            County__c='country1c',
            ERP_Account_Number__c='8769',
            State__c='state1',
            Zip_Code__c='123' );
        
        insert testAccountShipAddress;
        
        Account acc= scc_TestDataFactory.accountCreation('testAccount1');
        Account acc1= scc_TestDataFactory.accountCreation('testAccount2');
        acc1.AccountNumber = '123456';
        acc1.MDR_PID__c = '1234454';
        update acc1;
        
        WebStore webStr = new WebStore();
        webStr.Name = 'MySavvasOrders';
        webStr.PricingStrategy = 'LowestPrice';
        insert webStr;
        
        Profile pd = [Select id From profile where name = 'Customer Community Login User' limit 1];
        user us=[select id from user where profile.name= 'System Administrator' and id != :userinfo.getUserID() and isActive=true limit 1];
        
        user ru= new User(contactID=cList[0].id, Alias = 'ruser', Email='standardistuser6@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId= pd.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@testorg.com'); 
        userList.add(ru);
        insert userList;
        
        WebCart activeCart =scc_TestDataFactory.webCartCreation( acc.Id, userList[0].Id, webStr.Id);
        activeCart.License_Partner__c = '123456';
        activeCart.Coupon__c = 'TEST';
        activeCart.Site_Id__c = '11';
        activeCart.Coupon_Discount__c = -1.50;
        activeCart.Shipping_Amount__c = 2.00;
        activeCart.Shipping_Country__c = 'USA';
        activeCart.BillingCountry = 'Canada';
        update activeCart;
        
        Product2 productA =scc_TestDataFactory.productCreation1();
        CartDeliveryGroup caDe =scc_TestDataFactory.cartDeliverGroupCreation(activeCart.Id);
        CartItem caItem =scc_TestDataFactory.cartItemCreation(activeCart.Id,productA.Id,caDe.Id,'test Product');
        caItem.Tax__c = 2.00;
        update caItem;
        
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = Test.getStandardPricebookId();
        standardPrice.Product2Id = productA.Id;
        standardPrice.UnitPrice = 100;
        standardPrice.IsActive = true;
        standardPrice.UseStandardPrice = false;
        insert standardPrice ;
        
        Order ord = New Order();
        ord.Type='Stock';
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
        ord.Order_Confirmation_Sent__c = false;
        ord.Customer_Email__c='testuser@example.com';
        ord.ShippingpostalCode = '1234';
        ord.ShippingCountry = 'United States';
        ord.ShippingState = 'FL';
        ord.ShippingCity = 'test';
        ord.ShippingStreet ='123 test';
        ord.ShipTo_Name__c ='test name';
        ord.Order_Confirmation_Sent__c=false;
        ord.Customer_Email__c ='testuser@example.com'; 
        ord.PriceBook2Id = Test.getStandardPricebookId();
        ord.SAP_Order_Type__c = 'YORD';
        insert ord; 
        
        OrderItem lineItem = new OrderItem();
        lineItem.OrderId = ord.Id;
        lineItem.Quantity = 24;
        lineItem.UnitPrice = 240;
        lineItem.Product2id = productA.Id;
        lineItem.ISBN__c = '43534534';
        lineItem.SAP_Order_Item_status__c = 'Active';
        lineItem.ListPrice = 100;
        lineItem.Discount__c = 1;
        lineItem.PricebookEntryId=standardPrice.Id;
        insert lineItem;
        
        Map<String, String> cardDetails = new Map<String, String>();
        cardDetails.put('expYear', '2025');
        cardDetails.put('expMonth', '12');
        cardDetails.put('cardHolderName', 'John Smith');
        cardDetails.put('cardType', 'VI');
        cardDetails.put('tokenizedCardNumber', '1234567890123456');
        cardDetails.put('securityCode', '123');
        
        Map<String, String> cardDetails1 = new Map<String, String>();
        cardDetails1.put('expYear', '2025');
        cardDetails1.put('expMonth', '12');
        cardDetails1.put('cardHolderName', 'John Smith');
        cardDetails1.put('cardType', 'DI');
        cardDetails1.put('tokenizedCardNumber', '1234567890123456');
        cardDetails1.put('securityCode', '123');
        
        Map<String, String> cardDetails2 = new Map<String, String>();
        cardDetails2.put('expYear', '2025');
        cardDetails2.put('expMonth', '12');
        cardDetails2.put('cardHolderName', 'John Smith');
        cardDetails2.put('cardType', 'AX');
        cardDetails2.put('tokenizedCardNumber', '1234567890123456');
        cardDetails2.put('securityCode', '123');
        
        Map<String, String> shipAddressMap = new Map<String, String>();
        shipAddressMap.put('shipName', 'Test User');
        shipAddressMap.put('shipStreet', '123 Main St');
        shipAddressMap.put('cardCity', 'Anytown');
        shipAddressMap.put('shipCountry', 'US');
        shipAddressMap.put('shipState', 'CA');
        shipAddressMap.put('shipZip', '12345');
        shipAddressMap.put('shipFloor', '123');
        
        Map<String, String> billAddressMap = new Map<String, String>();
        billAddressMap.put('billName', 'Test User');
        billAddressMap.put('billStreet', '123 Main St');
        billAddressMap.put('billCity', 'Anytown');
        billAddressMap.put('billCountry', 'Canada');
        billAddressMap.put('billState', 'CA');
        billAddressMap.put('billZip', '12345');
        billAddressMap.put('billFloor', '123');
        
        Map<String, String> institutionDetails = new Map<String, String>();
        institutionDetails.put('displayInstitution', 'true');
        institutionDetails.put('institutionName', 'testName');
        institutionDetails.put('institutionType', 'Public');
        institutionDetails.put('iAm', 'Teacher');
        
        test.startTest();
        System.runAs(userList[0]) {
            scc_checkOutLWC_Controller.updatePoNum(activeCart.Id,acc.Id);
            System.assertNotEquals(null,scc_checkOutLWC_Controller.getShippingInstructionOptions());
            System.assertNotEquals(null,scc_checkOutLWC_Controller.getServiceLvlOptions());
            System.assertNotEquals(null,scc_checkOutLWC_Controller.getCurrentUserShippingAddress());
            System.assertNotEquals(null,scc_checkOutLWC_Controller.getCurrShipTo());
            System.assertNotEquals(null,scc_checkOutLWC_Controller.updateShipAddress(activeCart.Id,'test abc','Street 2','City2','State2','12345','Countrys','123456'));
            System.assertNotEquals(null,scc_checkOutLWC_Controller.updateLicenseToAddress(activeCart.Id,'test abc','Street 2','City2','State2','12345','Countrys','123456'));
            System.assertNotEquals(null,scc_checkOutLWC_Controller.createOrderRecord('Test','User','1234567890','testuser1@user.com','testuser1@user.com',System.today(),'test','test test','Warehouse','1234567690','test01@user.com',activeCart.Id,'SUM10','Domestic Ground','test instruction',true,cardDetails,'',true,'Name','Street','City','India','12345'));
            System.assertNotEquals(null,scc_checkOutLWC_Controller.createOrderRecord('Test','User','1234567890','testuser1@user.com','testuser1@user.com',System.today(),'test','test test','Warehouse','1234567690','test01@user.com',activeCart.Id,'SUM10','Domestic Ground','test instruction',true,cardDetails1,'',true,'Name','Street','City','India','12345'));
            System.assertNotEquals(null,scc_checkOutLWC_Controller.createOrderRecord('Test','User','1234567890','testuser1@user.com','testuser1@user.com',System.today(),'test','test test','Warehouse','1234567690','test01@user.com',activeCart.Id,'SUM10','Domestic Ground','test instruction',true,cardDetails2,'',true,'Name','Street','City','India','12345'));
            System.assertNotEquals(null,scc_checkOutLWC_Controller.createOrderRecord('Test','User','1234567890','testuser1@user.com','testuser1@user.com',System.today(),'test','test test','Warehouse','1234567690','test01@user.com',activeCart.Id,'SUM10','Domestic Ground','test instruction',false,new Map<String,String>(),'testPO',true,'Name','Street','City','India','12345'));
            System.assertNotEquals(null,scc_checkOutLWC_Controller.createGuestOrderRecord('Test','User','1234567890','testuser1@user.com','testuser1@user.com',System.today(),'test',activeCart.Id,acc.Id,'SUM10','Domestic Ground',cardDetails,shipAddressMap,true,new Map<String,String>(),institutionDetails));
            System.assertNotEquals(null,scc_checkOutLWC_Controller.createGuestOrderRecord('Test','User','1234567890','testuser1@user.com','testuser1@user.com',System.today(),'test',activeCart.Id,acc.Id,'SUM10','Domestic Ground',cardDetails,shipAddressMap,false,billAddressMap,institutionDetails));
            System.assertNotEquals(null,scc_checkOutLWC_Controller.createGuestOrderRecord('Test','User','1234567890','testuser1@user.com','testuser1@user.com',System.today(),'test',activeCart.Id,acc.Id,'SUM10','Domestic Ground',cardDetails1,shipAddressMap,false,billAddressMap,institutionDetails));
            System.assertNotEquals(null,scc_checkOutLWC_Controller.createGuestOrderRecord('Test','User','1234567890','testuser1@user.com','testuser1@user.com',System.today(),'test',activeCart.Id,acc.Id,'SUM10','Domestic Ground',cardDetails2,shipAddressMap,false,billAddressMap,institutionDetails));
            System.assertNotEquals(null,scc_checkOutLWC_Controller.fetchCartData(activeCart.Id));
            System.assertNotEquals(null,scc_checkOutLWC_Controller.fetchCartDetails(activeCart.Id));
            
            System.assertNotEquals(null,scc_checkOutLWC_Controller.fetchOrderData(activeCart.Id));
            System.assertNotEquals(null,scc_checkOutLWC_Controller.fetchOrderData(activeCart.Id));
            System.assertNotEquals(null,scc_checkOutLWC_Controller.fetchOrderItemData(ord.Id));
            System.assertNotEquals(null,scc_checkOutLWC_Controller.updateShipServiceLvel(activeCart.Id,'RUSH'));
            System.assertNotEquals(true,scc_checkOutLWC_Controller.isGuestUser());
            System.assertNotEquals(null,scc_checkOutLWC_Controller.createERPOrder(activeCart.Id,acc.Id));
            scc_checkOutLWC_Controller.updateCartStatus(activeCart.Id);
        }   
        test.stopTest();
    }
 	 @isTest
    static void testClassMethod2(){
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
        
        Account_Addresses__c testAccountShipAddress = new Account_Addresses__c(
            Account__c = accList[0].Id,
            ERP_Account_Name__c='school2',
            Address_1__c='street1',
            Address_Type__c='Shipping',
            City__c='c1',
            County__c='country1c',
            ERP_Account_Number__c='8769',
            State__c='state1',
            Zip_Code__c='123' );
        
        insert testAccountShipAddress;
        
        Account acc= scc_TestDataFactory.accountCreation('testAccount1');
        Account acc1= scc_TestDataFactory.accountCreation('testAccount2');
        acc1.AccountNumber = '123456';
        acc1.MDR_PID__c = '1234454';
        update acc1;
        
        WebStore webStr = new WebStore();
        webStr.Name = 'MySavvasOrders';
        webStr.PricingStrategy = 'LowestPrice';
        insert webStr;
        
        Profile pd = [Select id From profile where name = 'Customer Community Login User' limit 1];
        user us=[select id from user where profile.name= 'System Administrator' and id != :userinfo.getUserID() and isActive=true limit 1];
        
        user ru= new User(contactID=cList[0].id, Alias = 'ruser', Email='standardistuser6@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId= pd.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@testorg.com'); 
        userList.add(ru);
        insert userList;
        
        WebCart activeCart =scc_TestDataFactory.webCartCreation( acc.Id, userList[0].Id, webStr.Id);
        activeCart.License_Partner__c = '123456';
        activeCart.Coupon__c = 'TEST';
        activeCart.Site_Id__c = '11';
        activeCart.Coupon_Discount__c = -1.50;
        activeCart.Shipping_Amount__c = 2.00;
        activeCart.Shipping_Country__c = 'USA';
        activeCart.BillingCountry = 'India';
        update activeCart;
        
        Product2 productA =scc_TestDataFactory.productCreation1();
        CartDeliveryGroup caDe =scc_TestDataFactory.cartDeliverGroupCreation(activeCart.Id);
        CartItem caItem =scc_TestDataFactory.cartItemCreation(activeCart.Id,productA.Id,caDe.Id,'test Product');
        caItem.Tax__c = 2.00;
        update caItem;
        
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = Test.getStandardPricebookId();
        standardPrice.Product2Id = productA.Id;
        standardPrice.UnitPrice = 100;
        standardPrice.IsActive = true;
        standardPrice.UseStandardPrice = false;
        insert standardPrice ;
        
        Order ord = New Order();
        ord.Type='Stock';
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
        ord.Order_Confirmation_Sent__c = false;
        ord.Customer_Email__c='testuser@example.com';
        ord.ShippingpostalCode = '1234';
        ord.ShippingCountry = 'United States';
        ord.ShippingState = 'FL';
        ord.ShippingCity = 'test';
        ord.ShippingStreet ='123 test';
        ord.ShipTo_Name__c ='test name';
        ord.Order_Confirmation_Sent__c=false;
        ord.Customer_Email__c ='testuser@example.com'; 
        ord.PriceBook2Id = Test.getStandardPricebookId();
        ord.SAP_Order_Type__c = 'YORD';
        insert ord; 
        
        OrderItem lineItem = new OrderItem();
        lineItem.OrderId = ord.Id;
        lineItem.Quantity = 24;
        lineItem.UnitPrice = 240;
        lineItem.Product2id = productA.Id;
        lineItem.ISBN__c = '43534534';
        lineItem.SAP_Order_Item_status__c = 'Active';
        lineItem.ListPrice = 100;
        lineItem.Discount__c = 1;
        lineItem.PricebookEntryId=standardPrice.Id;
        insert lineItem;
        
        Map<String, String> cardDetails = new Map<String, String>();
        cardDetails.put('expYear', '2025');
        cardDetails.put('expMonth', '12');
        cardDetails.put('cardHolderName', 'John Smith');
        cardDetails.put('cardType', 'VI');
        cardDetails.put('tokenizedCardNumber', '1234567890123456');
        cardDetails.put('securityCode', '123');
        
        Map<String, String> cardDetails1 = new Map<String, String>();
        cardDetails1.put('expYear', '2025');
        cardDetails1.put('expMonth', '12');
        cardDetails1.put('cardHolderName', 'John Smith');
        cardDetails1.put('cardType', 'DI');
        cardDetails1.put('tokenizedCardNumber', '1234567890123456');
        cardDetails1.put('securityCode', '123');
        
        Map<String, String> cardDetails2 = new Map<String, String>();
        cardDetails2.put('expYear', '2025');
        cardDetails2.put('expMonth', '12');
        cardDetails2.put('cardHolderName', 'John Smith');
        cardDetails2.put('cardType', 'AX');
        cardDetails2.put('tokenizedCardNumber', '1234567890123456');
        cardDetails2.put('securityCode', '123');
        
        Map<String, String> shipAddressMap = new Map<String, String>();
        shipAddressMap.put('shipName', 'Test User');
        shipAddressMap.put('shipStreet', '123 Main St');
        shipAddressMap.put('cardCity', 'Anytown');
        shipAddressMap.put('shipCountry', 'India');
        shipAddressMap.put('shipState', 'CA');
        shipAddressMap.put('shipZip', '12345');
        shipAddressMap.put('shipFloor', '123');
        
        Map<String, String> shipAddressMap1 = new Map<String, String>();
        shipAddressMap1.put('shipName', 'Test User');
        shipAddressMap1.put('shipStreet', '123 Main St');
        shipAddressMap1.put('cardCity', 'Anytown');
        shipAddressMap1.put('shipCountry', 'India');
        shipAddressMap1.put('shipState', 'CA');
        shipAddressMap1.put('shipZip', '12345');
        shipAddressMap1.put('shipFloor', '123');
        
        Map<String, String> billAddressMap = new Map<String, String>();
        billAddressMap.put('billName', 'Test User');
        billAddressMap.put('billStreet', '123 Main St');
        billAddressMap.put('billCity', 'Anytown');
        billAddressMap.put('billCountry', 'India');
        billAddressMap.put('billState', 'CA');
        billAddressMap.put('billZip', '12345');
        billAddressMap.put('billFloor', '123');
        
        Map<String, String> billAddressMap1 = new Map<String, String>();
        billAddressMap1.put('billName', 'Test User');
        billAddressMap1.put('billStreet', '123 Main St');
        billAddressMap1.put('billCity', 'Anytown');
        billAddressMap1.put('billCountry', 'Bangladesh');
        billAddressMap1.put('billState', 'CA');
        billAddressMap1.put('billZip', '12345');
        billAddressMap1.put('billFloor', '123');        
        
        Map<String, String> institutionDetails = new Map<String, String>();
        institutionDetails.put('displayInstitution', 'true');
        institutionDetails.put('institutionName', 'testName');
        institutionDetails.put('institutionType', 'Public');
        institutionDetails.put('iAm', 'Teacher');
        
        test.startTest();
        System.runAs(userList[0]) {
            scc_checkOutLWC_Controller.updatePoNum(activeCart.Id,acc.Id);
            System.assertNotEquals(null,scc_checkOutLWC_Controller.createOrderRecord('Test','User','1234567890','testuser1@user.com','testuser1@user.com',System.today(),'test','test test','Warehouse','1234567690','test01@user.com',activeCart.Id,'SUM10','Domestic Ground','test instruction',true,cardDetails,'',true,'Name','Street','City','India','12345'));
            System.assertNotEquals(null,scc_checkOutLWC_Controller.createOrderRecord('Test','User','1234567890','testuser1@user.com','testuser1@user.com',System.today(),'test','test test','Warehouse','1234567690','test01@user.com',activeCart.Id,'SUM10','Domestic Ground','test instruction',true,cardDetails1,'',true,'Name','Street','City','India','12345'));
            System.assertNotEquals(null,scc_checkOutLWC_Controller.createOrderRecord('Test','User','1234567890','testuser1@user.com','testuser1@user.com',System.today(),'test','test test','Warehouse','1234567690','test01@user.com',activeCart.Id,'SUM10','Domestic Ground','test instruction',true,cardDetails2,'',true,'Name','Street','City','India','12345'));
            System.assertNotEquals(null,scc_checkOutLWC_Controller.createOrderRecord('Test','User','1234567890','testuser1@user.com','testuser1@user.com',System.today(),'test','test test','Warehouse','1234567690','test01@user.com',activeCart.Id,'SUM10','Domestic Ground','test instruction',false,new Map<String,String>(),'testPO',true,'Name','Street','City','India','12345'));
            System.assertNotEquals(null,scc_checkOutLWC_Controller.createGuestOrderRecord('Test','User','1234567890','testuser1@user.com','testuser1@user.com',System.today(),'test',activeCart.Id,acc.Id,'SUM10','Domestic Ground',cardDetails,shipAddressMap,true,new Map<String,String>(),institutionDetails));
            System.assertNotEquals(null,scc_checkOutLWC_Controller.createGuestOrderRecord('Test','User','1234567890','testuser1@user.com','testuser1@user.com',System.today(),'test',activeCart.Id,acc.Id,'SUM10','Domestic Ground',cardDetails,shipAddressMap,false,billAddressMap,institutionDetails));
            System.assertNotEquals(null,scc_checkOutLWC_Controller.createGuestOrderRecord('Test','User','1234567890','testuser1@user.com','testuser1@user.com',System.today(),'test',activeCart.Id,acc.Id,'SUM10','Domestic Ground',cardDetails1,shipAddressMap,false,billAddressMap,institutionDetails));
            System.assertNotEquals(null,scc_checkOutLWC_Controller.createGuestOrderRecord('Test','User','1234567890','testuser1@user.com','testuser1@user.com',System.today(),'test',activeCart.Id,acc.Id,'SUM10','Domestic Ground',cardDetails2,shipAddressMap1,false,billAddressMap1,institutionDetails));
            System.assertNotEquals(null,scc_checkOutLWC_Controller.createERPOrder(activeCart.Id,acc.Id));
            System.assertNotEquals(null,scc_checkOutLWC_Controller.getUserdata());
        }   
        test.stopTest();
    }    
    
}