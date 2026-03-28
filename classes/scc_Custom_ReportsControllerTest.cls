/*********************************************************** 
* @Class Name  - scc_Custom_ReportsControllerTest
* @description - Test class for scc_Custom_ReportsController
* @Created By  - CTS- Sudharani Pathivada
* @Created On - 2024-07-11
* **********************************************************/ 
@IsTest
public class scc_Custom_ReportsControllerTest {
@TestSetup
static void setup() {
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
    p.productCode = 'ABC';
    p.ISBN13__c='0000121500';
    p.isActive = true;
    insert p;
    
    PricebookEntry standardPrice = new PricebookEntry();
    standardPrice.Pricebook2Id = Test.getStandardPricebookId();
    standardPrice.Product2Id = p.Id;
    standardPrice.UnitPrice = 100;
    standardPrice.IsActive = true;
    standardPrice.UseStandardPrice = false;
    insert standardPrice ;    
    
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
    ord.Order_Status_Code__c = 'OPEN';
    ord.ShippingpostalCode = '1234';
    ord.ShippingCountry = 'United States';
    ord.ShippingState = 'FL';
    ord.ShippingCity = 'test';
    ord.ShippingStreet ='123 test';
    ord.ShipTo_Name__c ='test name';
    ord.Order_Confirmation_Sent__c=false;
    ord.Customer_Email__c ='testuser@example.com';
    ord.PriceBook2Id = Test.getStandardPricebookId();
    ord.SAP_Order_Type__c = 'ZCRC';
    ord.BACKORDER_CANCEL_DATE__c=system.today();
    ord.Deliver_On__c=system.today();     
    ord.Order_Status_Code__c='Cancelled';
    ord.Account_PO_Number__c='PO-10000577021';        
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
    lineItem.Product2Id=p.id;
    lineItem.PricebookEntryId=standardPrice.Id;
    lineItem.On_Pick_Quantity__c = 1;
    lineItem.Backorder_Quantity__c =1;
    lineItem.Shippable_Quantity__c=1;
    lineItem.Shipped_Quantity__c=1;
    lineItem.Quantity=1;
    insert lineItem;
    
    id OrderItem =[select id from OrderItem where SAP_Order_Item_status__c='Active'  limit 1 ].id;

    SAP_Invoice__c inv = new SAP_Invoice__c();
    inv.Invoice_Number__c = 'test';
    inv.Order_Number__c = '10000';
    inv.Order__c = ord.Id;
    inv.Invoice_Created_Date__c = System.today();
    inv.Invoice_Amount__c = '1234';
    inv.Pay_Status__c = false;
    insert inv;
    
    SAP_Package__c pk = new SAP_Package__c();
    pk.Signature__c ='SAVVAS';
    pk.SAP_Invoice_Id__c = inv.Id;
    pk.Invoice_Number__c = 'test';
    PK.OrderId__c = ord.Id;
    pk.OrderItemId__c= OrderItem;
    pk.Delivery_Date__c=System.today();
    pk.Parcel_ID_Number__c='1234';
    pk.Tracking_Number__c='452314';
    pk.carrier_name__c='2099';
    insert pk;

    List<Custom_Report_Filter__c> customReportFilters = new List<Custom_Report_Filter__c>();
    for (Integer i = 0; i < 3; i++) {
        Custom_Report_Filter__c customFilter = new Custom_Report_Filter__c(
            Name = 'Test Filter ' + i,
            Contact__c=con.id 
        );
        customReportFilters.add(customFilter);
    }
    insert customReportFilters;
        Custom_Report_Filter__c reportFilter = new Custom_Report_Filter__c(
        Name = 'Test Report',
        Contact__c = cList[0].Id,
        ISBN_To_Include__c = '9780132154116,9780132154215',
        PO_To_Include__c = ',PO456',
        Order_From_Date__c = Date.today().addDays(-30),
        Order_To_Date__c = Date.today(),
        Order_Status__c = 'All',
        OrderEntryPeriod__c = '1',
        Sort_By__c = 'ISBN',
        Sort_By_2__c = 'ISBN',
        Sort_By_3__c = 'ISBN',
        originalReportType__c = 'Order Status Report – Summary',
        StandardReport__c = false
    );
    insert reportFilter;
}
@isTest
static void testDeleteCustomReport_Success() {
    Custom_Report_Filter__c customReport = [SELECT Id FROM Custom_Report_Filter__c WHERE Name = 'Test Report' LIMIT 1];
    System.assertNotEquals(null, customReport, 'Custom report should exist before deletion.');
    Test.startTest();
    scc_Custom_ReportsController.deleteCustomReportByName('Test Report');
    scc_Custom_ReportsController.deleteCustomReportByName('');
    Test.stopTest();
        List<Custom_Report_Filter__c> deletedReports = [SELECT Id FROM Custom_Report_Filter__c WHERE Name = 'Test Report'];
    System.assertEquals(0, deletedReports.size(), 'Custom report should be deleted.');
}
@IsTest
static void testGetReportOptions() {  
    User testUser1 = [SELECT Id FROM User WHERE Email = 'testuser@example.com' LIMIT 1];
    System.runAs(testUser1) {            
    String result = scc_Custom_ReportsController.getReportOptions();
    System.assertNotEquals(null, result, 'Result should not be null');
    List<scc_Custom_ReportsController.ReportOptionWrapper> options = (List<scc_Custom_ReportsController.ReportOptionWrapper>) JSON.deserialize(result, List<scc_Custom_ReportsController.ReportOptionWrapper>.class);    
    System.assertnotEquals('', options[0].label, 'First option ');
    System.assertnotEquals('', options[1].label, 'Second option ');
    System.assertnotEquals('', options[2].label, 'Third option ');    
}
}
@IsTest
static void testDetailReport() {
    Account testAccount = [SELECT Id FROM Account WHERE Name = 'TestR' LIMIT 1];
    System.assertNotEquals(null, testAccount, 'Test Account not found');

    Order testOrder = [SELECT Id FROM Order WHERE SAP_Order_Type__c = 'ZCRC' LIMIT 1];
    System.assertNotEquals(null, testOrder, 'Test Order not found');

    List<OrderItem> orderItems = [SELECT Id, Quantity, Product2.ProductCode, Product2.Description, Product2.ISBN13__c, 
                                    Order.EffectiveDate, Order.BACKORDER_CANCEL_DATE__c, Order.Deliver_On__c, On_Pick_Quantity__c,
                                    Order.PONumber__c, Order.SAP_Document_Number__c, Order.ShippingCity, Order.ShippingState, 
                                    Order.ShipTo_Name__c, Order.SAP_Shipto__c, Shipped_Quantity__c, Backorder_Quantity__c 
                                    FROM OrderItem WHERE OrderId = :testOrder.Id];
    System.assertNotEquals(0, orderItems.size(), 'No Order Items found');

    List<SAP_Package__c> sapPackages = [SELECT Id, Invoice_Number__c, Delivery_Date__c, carrier_name__c, Tracking_Number__c, Parcel_ID_Number__c, Signature__c, OrderItemId__c 
                                        FROM SAP_Package__c WHERE OrderItemId__c = :orderItems[0].Id];
    System.assertNotEquals(null, sapPackages.size(), 'No SAP Packages found');

    List<OrderLine_Status__c> orderLineStatuses = [SELECT Id, LineItem_Status_Description__c, LineItem_Status_Reason_Description__c, OrderItemId__c 
                                                    FROM OrderLine_Status__c WHERE OrderItemId__c = :orderItems[0].Id];
    System.assertEquals(0, orderLineStatuses.size(), 'No Order Line Statuses found');

    Test.startTest();
    String BillTo = '1234';
    String ShipTo = '1234';
    List<scc_Custom_ReportsController.OrderItemWrapper1> orderItemWrappers = scc_Custom_ReportsController.detailReport(BillTo, ShipTo);
    Test.stopTest();    
}

@isTest
static void testWithEmptyListsAndNullValues() {
    List<String> poList = new List<String>{};
    List<String> isbnList = new List<String>{};
    Date startDate = null;
    Date endDate = null;
    String orderStatus = '';
    Test.startTest();
    List<scc_Custom_ReportsController.OrderItemWrapper1> orderItems = scc_Custom_ReportsController.detailReport('', '');
    Test.stopTest();
    System.assertEquals(1, orderItems.size(), 'No Order Items found'); 
    scc_Custom_ReportsController.OrderItemWrapper1 wrapper = orderItems[0];       
    System.assertNotEquals(wrapper.productCode, '');
    System.assertNotEquals(wrapper.productDescription, 'Product Description is null');
    System.assertNotEquals(wrapper.isbn13, 'ISBN13 is null');
    System.assertNotEquals(wrapper.quantity, Null);
    System.assertNotEquals(wrapper.reason, 'Reason is null');
    System.assertNotEquals(wrapper.status, 'Status is null');
    System.assertNotEquals(wrapper.orderNumber, 'Order Number is null');
    System.assertNotEquals(wrapper.orderItemId, 'Order Item Id is null');
    System.assertNotEquals(wrapper.orderedQuantity, Null);
    System.assertNotEquals(wrapper.backorderCancelDate, 'Backorder Cancel Date is null');
    System.assertNotEquals(wrapper.deliverOnDate, 'Deliver On Date is null');
    System.assertNotEquals(wrapper.PO, 'PO is null');
    System.assertNotEquals(wrapper.sapDocumentNumber, 'SAP Document Number is null');
    System.assertNotEquals(wrapper.shippingCity, 'Shipping City is null');
    System.assertNotEquals(wrapper.shippingState, 'Shipping State is null');
    System.assertNotEquals(wrapper.shipToName, 'Ship To Name is null');
    System.assertNotEquals(wrapper.shipDate, 'Ship Date is null');
    System.assertNotEquals(wrapper.trackingNumber, 'Tracking Number is null');
    System.assertNotEquals(wrapper.parcelID, 'Parcel ID is null');
    System.assertNotEquals(wrapper.signature, 'Signature is null');
    System.assertNotEquals(wrapper.shipAccount, 'Ship Account is null');
    System.assertNotEquals(wrapper.shipAccountName, 'Ship Account Name is null');
    System.assertNotEquals(wrapper.state, 'State is null');
    System.assertNotEquals(wrapper.city, 'City is null');
    System.assertNotEquals(wrapper.futureShipDate, 'Future Ship Date is null');
    System.assertNotEquals(wrapper.carrierName, 'Carrier Name is null');
    System.assertNotEquals(wrapper.holdQuantity, null);
    System.assertEquals(wrapper.dueDate, '');
    System.assertNotEquals(wrapper.shippedQuantity, null);
    System.assertNotEquals(wrapper.backorderQuantity, null);
    System.assertNotEquals(wrapper.invoiceNumber, 'Invoice Number is null');
}
}