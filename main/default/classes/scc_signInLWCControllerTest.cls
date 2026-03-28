/*
Apex Test Class: scc_signInLWCControllerTest
Author: CTS (Suresh Kalshetti)
Created Date: 08/04/2024
Modified Date: 16/04/2024
*/
@isTest
public class scc_signInLWCControllerTest {
    /**
*  Description: Below method is test method that checks users signin
*  @name: siopchecktest
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void signIntest(){
        String username = 'testuser@example.com';
        String password = URL.getOrgDomainUrl().toExternalForm();
        
        Test.startTest();
        System.assertEquals('',scc_signInLWCController.signIn(username,password));        
        Test.stopTest();        
    }
    /**
*  Description: Below method is test method that checks users signin
*  @name: signIntest2
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void signIntest2(){
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Schools Account'].Id;
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
        
        Order ord = New Order();
        ord.Type='Stock';   
        ord.AccountId=acc.Id;
        ord.Status='Draft';
        ord.PONumber__c = 'PO-10000577021';
        ord.SAP_Document_Number__c = '10000';
        ord.EffectiveDate = system.today();
        ord.BillingpostalCode = '77047';
        ord.BillingCountry = 'United States';
        ord.BillingState = 'FL';
        ord.BillingCity = 'test';
        ord.Order_Status_Code__c = 'Open';
        ord.BillingName__c ='Anny Wack';
        ord.Billingstreet ='123 test';
        
        ord.ShippingpostalCode = '77047';
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
        
        SAP_Invoice__c inv = new SAP_Invoice__c();
        inv.Order__c=ord.id;
        inv.Invoice_Number__c = '7028573119';
        insert inv;
        
        String invoice = '7028573119';
        String postalcode = '77047';
                
        Test.startTest();
        scc_signInLWCController.verifyInvoice(invoice,postalcode);        
        Test.stopTest();        
    }
    
    /**
*  Description: Below method is test method that checks users signin
*  @name: signIntest3
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void signIntest3(){
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Schools Account'].Id;
        Account acc= scc_TestDataFactory.accountCreation('testAccount4');       
        Contact con = scc_TestDataFactory.contactCreation( acc.Id, 'firstname4', 'testlastname4', 'testemail1@abc.com');       
        Profile pd = [Select id From profile where name = 'Customer Community Plus Login User' limit 1];
        Profile pd2 = [Select id From profile where name = 'MySavvasOrders Profile' limit 1];
        user us=[select id from user where profile.name= 'System Administrator' and id != :userinfo.getUserID() and isActive=true limit 1];
        
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
        
        Order ord = New Order();
        ord.Type='Stock';        
        ord.AccountId=acc.Id;
        ord.Status='Draft';
        ord.PONumber__c = 'PO-10000577021';
        ord.SAP_Document_Number__c = '10000';
        ord.EffectiveDate = system.today();
        ord.BillingpostalCode = '77047';
        ord.BillingCountry = 'United States';
        ord.BillingState = 'FL';
        ord.BillingCity = 'test';
        ord.Order_Status_Code__c = 'Open';
        ord.BillingName__c ='Anny Wack';
        ord.Billingstreet ='123 test';
        
        ord.ShippingpostalCode = '77047';
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
        
        SAP_Invoice__c inv = new SAP_Invoice__c();
        inv.Order__c=ord.id;
        inv.Invoice_Number__c = '7028573119';
        insert inv;
        
        String invoice = '7028573119';
        String postalcode = '1234';
        
        Test.startTest();
        scc_signInLWCController.verifyInvoice(invoice,postalcode);
        
        Test.stopTest();
        
    }
}