/*
Apex Class:scc_documentSearchLWC_Controller
Author: CTS (Vaibhav Saptal)
Created Date: 22/07/2024
Reason: test class for 
Modified Date: 17/10/2024
*/
@istest
public class scc_documentSearchLWC_Controller_Test {
    public static List<User> userList=new List<User>();
    /**
*  Description: This is test method for getDocSearchByOptions and getCriteriaDocdata
*  @name:testClassMethod 
*  @param:No parameters
*  @return: NA
*  @throws exception- 
*/    
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
        
        
        Account acc= scc_TestDataFactory.accountCreation('testAccount4');
        
        Contact con = scc_TestDataFactory.contactCreation( acc.Id, 'firstname4', 'testlastname4', 'testemail1@abc.com');
        
        Profile pd = [Select id From profile where name = :scc_constantHelper.CUSTOMER_COMMUNITY_PLUS_LOGIN_USER limit 1];
        Profile pd2 = [Select id From profile where name = :scc_constantHelper.MY_SAVVAS_ORDERS_PROFILE limit 1];
        user us=[select id from user where profile.name= :scc_constantHelper.SYSTEM_ADMINISTRATOR_PROFILE and id != :userinfo.getUserID() and isActive=true limit 1];    	
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
        ord.Order_Status_Code__c = 'FULLFILLED';
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
        insert ord; 
        
        Order ord1 = New Order();
        ord1.Type='Stock';
        ord1.AccountId=acc.Id;
        ord1.Status='Draft';
        ord1.PONumber__c = 'PO-10000577021';
        ord1.SAP_Document_Number__c = '100001';
        ord1.EffectiveDate = system.today();
        ord1.BillingpostalCode = '1234';
        ord1.BillingCountry = 'United States';
        ord1.BillingState = 'FL';
        ord1.BillingCity = 'test';
        ord1.Order_Status_Code__c = 'FULLFILLED';
        ord1.BillingName__c ='Anny Wack';
        ord1.Billingstreet ='123 test';
        ord1.Order_Status_Code__c = 'OPEN';
        ord1.ShippingpostalCode = '1234';
        ord1.ShippingCountry = 'United States';
        ord1.ShippingState = 'FL';
        ord1.ShippingCity = 'test';
        ord1.ShippingStreet ='123 test';
        ord1.ShipTo_Name__c ='test name';
        ord1.Order_Confirmation_Sent__c=false;
        ord1.Customer_Email__c ='testuser@example.com';
        ord1.PriceBook2Id = Test.getStandardPricebookId();
        ord1.SAP_Order_Type__c = 'ZDMR';
        
        insert ord1; 
        
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
        inv.Invoice_Number__c = 'test';
        inv.Order_Number__c = '10000';
        inv.Order__c = ord.Id;
        inv.Invoice_Created_Date__c = System.today();
        inv.Invoice_Amount__c = '1234';
        inv.Pay_Status__c = false;
        insert inv;
        
        SAP_Invoice__c inv1 = new SAP_Invoice__c();
        inv1.Invoice_Number__c = 'test1';
        inv1.Order_Number__c = '10000';
        inv1.Order__c = ord.Id;
        inv1.Invoice_Created_Date__c = null;
        inv1.Invoice_Amount__c = '1234';
        inv1.Pay_Status__c = false;
        insert inv1;
        
        SAP_Invoice__c inv3 = new SAP_Invoice__c();
        inv3.Invoice_Number__c = 'test3';
        inv3.Order_Number__c = '100001';
        inv3.Order__c = ord1.Id;
        inv3.Invoice_Created_Date__c = null;
        inv3.Invoice_Amount__c = '1234';
        inv3.Pay_Status__c = false;
        insert inv3;
        
        SAP_Package__c pk = new SAP_Package__c();
        pk.Signature__c ='SAVVAS';
        pk.SAP_Invoice_Id__c = inv.Id;
        pk.Invoice_Number__c = 'test1';
        PK.OrderId__c = ord.Id;
        insert pk;
        
        String startDate1 = String.valueOf(System.today()-1);
        String endDate1 = String.valueOf(System.today()+1);
        Map<String, String> myMap = new Map<String, String>{'InvoNum' => '10000', 'SearchByvalue' => 'Invoice','PONum' =>'PO-10000577021','InvoiceStatus' =>'Closed','isAdvanced' =>'true','startDate' =>startDate1,'endDate' => endDate1};
        Map<String, String> myMap1 = new Map<String, String>{'InvoNum' => '10000', 'SearchByvalue' => 'Credit Memo','PONum' =>'','InvoiceStatus' =>'','isAdvanced' =>'false','startDate' =>startDate1,'endDate' => endDate1};
        Map<String, String> myMap2 = new Map<String, String>{'InvoNum' => '100001', 'SearchByvalue' => 'Debit Memo','PONum' =>'','InvoiceStatus' =>'','isAdvanced' =>'false','startDate' =>startDate1,'endDate' => endDate1};
        Map<String, String> myMap3 = new Map<String, String>{'InvoNum' => 'test1', 'SearchByvalue' => 'Credit Memo','PONum' =>'PO-10000577021','InvoiceStatus' =>'Closed','isAdvanced' =>'true','startDate' =>startDate1,'endDate' => endDate1};
        Map<String, String> myMap4 = new Map<String, String>{'InvoNum' => 'test1', 'SearchByvalue' => 'Debit Memo','PONum' =>'PO-10000577021','InvoiceStatus' =>'Closed','isAdvanced' =>'true','startDate' =>startDate1,'endDate' => endDate1};
        Map<String, String> myMap5 = new Map<String, String>{'InvoNum' => '10000', 'SearchByvalue' => 'Invoice','PONum' =>'','InvoiceStatus' =>'','isAdvanced' =>'false','startDate' =>startDate1,'endDate' => endDate1};
                                
        User testUser=  scc_TestDataFactory.userCreation(con.Id);
        System.assertNotEquals(null,scc_documentSearchLWC_Controller.getCriteriaDocdata(myMap2));
        
        //List<PermissionSetAssignment> permissions = [SELECT Id,Assignee.Email,PermissionSetId,PermissionSet.Name, Assignee.Id,Assignee.Name FROM PermissionSetAssignment WHERE PermissionSet.Name='Savvas_Commerce_Cloud_External_Users_Permissions' limit 1];
		List<PermissionSet> permissions = [SELECT Id, Name FROM PermissionSet where Name ='Savvas_Commerce_Cloud_External_Users_Permissions'];        
        System.runAs (us) {
            System.assertNotEquals(null,scc_documentSearchLWC_Controller.getDocSearchByOptions(true,true,false));
            PermissionSetAssignment psAssignment = new PermissionSetAssignment();
            psAssignment.PermissionSetId = permissions[0].Id;
            psAssignment.AssigneeId = testUser.Id;
            insert psAssignment; 
        }
        
        System.runAs (testUser1) {
            System.assertNotEquals(null,scc_documentSearchLWC_Controller.getDocSearchByOptions(true,true,false));
            System.assertNotEquals(null,scc_documentSearchLWC_Controller.getDocSearchByOptions(true,false,false));
        }
        
        System.runAs(testUser) {
            System.assertNotEquals(null,scc_documentSearchLWC_Controller.getCriteriaDocdata(myMap5));
            System.assertNotEquals(null,scc_documentSearchLWC_Controller.getDocSearchByOptions(true,true,false));
            System.assertNotEquals(null,scc_documentSearchLWC_Controller.getCriteriaDocdata(myMap));
            System.assertNotEquals(null,scc_documentSearchLWC_Controller.getCriteriaDocdata(myMap3));
            System.assertNotEquals(null,scc_documentSearchLWC_Controller.getCriteriaDocdata(myMap4));
            System.assertNotEquals(null,scc_documentSearchLWC_Controller.getCriteriaDocdata(myMap1));
            System.assertNotEquals(null,scc_documentSearchLWC_Controller.getCriteriaDocdata(myMap2));
            
        }   
        test.stopTest();
    }
    /**
*  Description: Below method is test method that covers catch exception block for getCriteriaDocdata
*  @name: getCriteriaDocdata_Exception
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/
    @isTest
    static void getCriteriaDocdata_Exception() {
        Test.startTest();
        try {
            Map<String, String> myMap = new Map<String, String>{'InvoNum' => '10000', 'SearchByvalue' => 'Invoice','PONum' =>'PO-10000577021','InvoiceStatus' =>'Closed','isAdvanced' =>'true','startDate' =>null,'endDate' => null};
            scc_documentSearchLWC_Controller.getCriteriaDocdata(myMap);           
        } catch (AuraHandledException e) {
            System.assertEquals(e.getMessage().contains('abcd'), false);
        }
        Test.stopTest();
    }    
}