public class OrderController1 {
    @AuraEnabled
    public static void updateOrder(String orderId) {
      
        if (String.isBlank(orderId)) {
            throw new AuraHandledException('Order ID cannot be null or empty.');
        }
        try {           
            Order orderToUpdate = [SELECT Id, OrderNumber,	scc_Recently_Viewed_User__c,scc_LastViewDate__c FROM Order WHERE OrderNumber  = :orderId LIMIT 1];           
            orderToUpdate.scc_Recently_Viewed_User__c = true;
            orderToUpdate.scc_LastViewDate__c = System.today();
            
            update orderToUpdate;
            
        } catch (DmlException e) {    
            System.debug('Error updating order: ' + e.getMessage());
        }
    }
}