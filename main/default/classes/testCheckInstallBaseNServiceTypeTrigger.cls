@isTest(SeeAllData=true)
public class testCheckInstallBaseNServiceTypeTrigger {
    static testMethod void myUnitTest1() {
        Account a = new Account(Name='createorderAccount',BillingCity='New York');
        database.Saveresult asr =database.insert(a);
        id acctid = asr.getId();
        Account_Addresses__c aadd = new Account_Addresses__c();
        aadd.Account__c = acctid;
        aadd.Address_1__c = '1234 test address';
        aadd.ERP_Account_Number__c = 'ERP#:12345';
        aadd.Location__c = 'Account Location';
        database.Saveresult aaddsr =database.insert(aadd);
        id accaddid = aaddsr.getId();
        Order__c o = new Order__c();
        o.Account__c = acctid;
        o.OrderId__c = 'OrderID345';
        o.Status__c = 'New';
        o.DeliverToAddress__c = accaddid;
        o.InvoiceToAddress__c = accaddid;
        o.ShipToAddress__c = accaddid;
        database.Saveresult osr =database.insert(o);
        id orderid = osr.getId();
        Product2 p = new Product2();
        p.Name = 'Test Product';
        p.Install_Base_Required__c = 'Y';
        p.Service_Item_Type_Code__c = 'Service';
        database.Saveresult psr =database.insert(p);
        id productid = psr.getId();
        OrderLineItem__c ol = new OrderLineItem__c();
        ol.Account__c=acctid;
        ol.Order__c = orderid;
        ol.Product__c = productid;
        ol.Ordered_Item__c = 'This is the Order Line Item';
        ol.ProductforService__c= productid; //added by Rob to repair test coverage
        insert ol;
        o.Status__c = 'Approved';
        update o;
    }
}