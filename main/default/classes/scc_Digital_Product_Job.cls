global class scc_Digital_Product_Job implements Database.Batchable<SObject>,Database.Stateful{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        set<String> set1 = new set<String>{'OLS', 'AMD', 'BOL', 'SUL', 'DSB', 'OLC'};
            
            String listofDigitalProduct = 'SELECT OrderId,Order.Has_Digital_Products__c FROM OrderItem WHERE  Product2.Product_Type_ID__c In:set1';
        return Database.getQueryLocator(listofDigitalProduct);
    }
    global void execute(Database.BatchableContext BC, List<OrderItem> scope)
    {
        List<Order> ordUpdate = new List<Order>();
        Set<Id> OrdId = new Set<Id>();
        for(OrderItem oi : scope){
            if(!OrdId.contains(oi.OrderId)){
                OrdId.add(oi.OrderId);
                Order ord = new Order();
                ord.id = oi.OrderId;
                ord.Has_Digital_Products__c = true;
                ordUpdate.add(ord);
            }
            
        }
        Database.Update(ordUpdate);
    }
    global void finish(Database.BatchableContext BC){
        
    }
}