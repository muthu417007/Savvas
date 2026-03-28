@isTest
public class accesscodecontrollerTest {

  	@isTest
    static void testClassMethod(){
        Account acc= scc_TestDataFactory.accountCreation('testAccount2');
        Contact con = scc_TestDataFactory.contactCreation( acc.Id, 'firstname2', 'testlastname2', 'testemail@abc.com');
        
        Product2 p = new Product2();
        p.Name = 'Test Product';
        p.Description='Test Product';
        p.productCode = 'ABC';
        p.ISBN10__c='0000121500';
        p.isActive = true;
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
        
        OrderItem lineItem2 = new OrderItem();
        lineItem2.OrderId = ord.Id;
        lineItem2.Quantity = 10;
        lineItem2.UnitPrice = 100;
        lineItem2.Product2id = p.Id;
        lineItem2.ISBN__c = '43534534';
        lineItem2.SAP_Order_Item_status__c = 'Active';
        lineItem2.ListPrice = 100;
        lineItem2.Discount__c = 1;
        lineItem2.PricebookEntryId=standardPrice.Id;
        insert lineItem2;
        
        EAccess_Imprints__c  eImprints = new EAccess_Imprints__c(
          Admin_Email2__c ='admin1@example.com'
          
        );
        insert eImprints;
        
        EAccess_Imprints__c  eImprints2 = new EAccess_Imprints__c(
          Admin_Email2__c ='admin1@example.com'
          
        );
        insert eImprints2;
        
         EAccess_List__c eAccess = new EAccess_List__c(
            Order__c = ord.Id,
            EAccess_Code__c = 'A2C963407445',
            //Admin_Email2__c ='admin1@example.com',
            EAccess_Imprints__c=eImprints.id,
            ISBN__c = '43534534'
        );
        insert eAccess;
        
        EAccess_List__c eAccess2 = new EAccess_List__c(
            Order__c = ord.Id,
            EAccess_Code__c = 'A6AD8242854B',
            //Admin_Email2__c ='admin1@example.com',
            EAccess_Imprints__c=eImprints2.id,
            ISBN__c = '43534534'
        );
        insert eAccess2;
        
        EAccess_Threshold__c threshold1 = new EAccess_Threshold__c();
        threshold1.ISBN__c = 'A2C963407445';
        threshold1.Avl_Stock__c = 2;
        insert threshold1;
         
        
        accesscodecontroller.FlowInput input = new accesscodecontroller.FlowInput();
        input.ordId = ord.Id;
        List<accesscodecontroller.FlowInput> inputs = new List<accesscodecontroller.FlowInput>{ input };
        TEST.StartTest();
        List<accesscodecontroller.FlowOutput> outputs = accesscodecontroller.quantityValidation(inputs);
         Test.stopTest();
            
    }
		@isTest
    static void testClassMethod2(){
        Account acc= scc_TestDataFactory.accountCreation('testAccount2');
        Contact con = scc_TestDataFactory.contactCreation( acc.Id, 'firstname2', 'testlastname2', 'testemail@abc.com');
        
        Product2 p = new Product2();
        p.Name = 'Test Product';
        p.Description='Test Product';
        p.productCode = 'ABC';
        p.ISBN10__c='0000121500';
        p.isActive = true;
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
        
        OrderItem lineItem2 = new OrderItem();
        lineItem2.OrderId = ord.Id;
        lineItem2.Quantity = 10;
        lineItem2.UnitPrice = 100;
        lineItem2.Product2id = p.Id;
        lineItem2.ISBN__c = '43534534';
        lineItem2.SAP_Order_Item_status__c = 'Active';
        lineItem2.ListPrice = 100;
        lineItem2.Discount__c = 1;
        lineItem2.PricebookEntryId=standardPrice.Id;
        insert lineItem2;
        
        EAccess_Imprints__c  eImprints = new EAccess_Imprints__c(
          Admin_Email2__c ='admin1@example.com'
          
        );
        insert eImprints;
       
        
         EAccess_List__c eAccess = new EAccess_List__c(
            Order__c = ord.Id,
            EAccess_Code__c = 'A2C963407445',
            //Admin_Email2__c ='admin1@example.com',
            EAccess_Imprints__c=eImprints.id,
            ISBN__c = '43534534'
        );
        insert eAccess;
        
       
        
        EAccess_Threshold__c threshold1 = new EAccess_Threshold__c();
        threshold1.ISBN__c = 'A2C963407445';
        threshold1.Avl_Stock__c = 2;
        insert threshold1;
         
        
        accesscodecontroller.FlowInput input = new accesscodecontroller.FlowInput();
        input.ordId = ord.Id;
        List<accesscodecontroller.FlowInput> inputs = new List<accesscodecontroller.FlowInput>{ input };
        TEST.StartTest();
        List<accesscodecontroller.FlowOutput> outputs = accesscodecontroller.quantityValidation(inputs);
         Test.stopTest();
            
    }
    
}