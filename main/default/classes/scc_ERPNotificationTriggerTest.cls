@isTest
public class scc_ERPNotificationTriggerTest {
	@testSetup
    static void setupTestData() {        
        Account acc= scc_TestDataFactory.accountCreation('testAccount1');
        
        List<Contact> cList=new List<Contact>();
        Contact cont = new Contact();
        cont.AccountId = acc.id;
        cont.LastName = 'Testing';
        cont.Email = 'abc@xyz.com';
        cont.FirstName = 'Test';
        cList.add(cont); 
        insert cList;
        
        WebStore webStr = new WebStore();
        webStr.Name = 'MySavvasOrders';
        webStr.PricingStrategy = 'LowestPrice';
        insert webStr;
        
        Profile pd = [Select id From profile where name = 'Customer Community Login User' limit 1];
        user us=[select id from user where profile.name= 'System Administrator' and id != :userinfo.getUserID() and isActive=true limit 1];
        
        List<User> userList=new List<User>();
        
        user ru= new User(contactID=cList[0].id, Alias = 'ruser', Email='standardistuser6@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId= pd.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@testorg.com'); 
        userList.add(ru);
        insert userList;        
        
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
        insert ord; 
        
        WebCart activeCart =scc_TestDataFactory.webCartCreation( acc.Id, userList[0].Id, webStr.Id);
        activeCart.Order_Id__c = ord.Id;
        activeCart.Token__c = 'testToken';
        update activeCart;
    }

    @isTest
    static void testplatformEvent() {
		Test.startTest();
        Account acc = [SELECT Id FROM Account where Name = 'testAccount1' LIMIT 1];
        Order ord = [SELECT Id FROM Order where PONumber__c = 'PO-10000577021' LIMIT 1];
        
        Order_Notification_from_ERP__e orderEvent = new Order_Notification_from_ERP__e(
            Order_ID__c = ord.Id,
            Account_ID__c = acc.Id,
            Token__c = 'testToken',
            PO_Number__c = 'WEB000'+Integer.valueof((Math.random() * 1000))
        );
        Database.SaveResult sr = EventBus.publish(orderEvent);
        System.AssertEquals(true, sr.isSuccess());
        Test.stopTest();
    }
}