@isTest
private class scc_Digital_Product_JobTest {
    static testMethod void testme(){
        Product2 op = new Product2();
        op.Product_Type_ID__c='DSB';
        op.Name = 'pro2';
        insert op;
        Account aa = new Account();
        aa.Name = 'New Account';
        insert aa;
        Order os = new Order();
        os.Has_Digital_Products__c=True;
        os.AccountId = aa.Id;
        os.Name = 'or2';
        os.EffectiveDate = system.today();
        os.Status = 'Draft';
        insert os;
        OrderItem oi = new OrderItem();
        oi.Product2Id =op.Id;
        oi.OrderId=os.Id;
        oi.ListPrice = 123;
        oi.UnitPrice = 12;
        oi.TotalLineAmount = 123;
        oi.Quantity = 2;
        insert oi;
        Test.startTest();
        scc_Digital_Product_Job ba= new scc_Digital_Product_Job();
        Id jobid= Database.executeBatch(ba,5);
        Test.stopTest();
        system.assertEquals(12, oi.UnitPrice);
    }
}