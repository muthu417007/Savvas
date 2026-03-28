public with sharing class TestSummary {

    public class OrderItemWrapper {
        @AuraEnabled public String orderNumber { get; set; }
        @AuraEnabled public String sapAccountNumber { get; set; }
        @AuraEnabled public Id orderItemId { get; set; }
        @AuraEnabled public Decimal shippedQuantity { get; set; }
        @AuraEnabled public Decimal holdQuantity { get; set; }
        @AuraEnabled public Decimal backorderQuantity { get; set; }
        @AuraEnabled public String orderedQuantity { get; set; }
        @AuraEnabled public String orderItemNumber { get; set; }
        @AuraEnabled public String invoiceNumber { get; set; }
        @AuraEnabled public String productCode { get; set; }
        @AuraEnabled public String isbn10 { get; set; }
        @AuraEnabled public String isbn13 { get; set; }
        @AuraEnabled public String orderDate { get; set; }
        @AuraEnabled public String productDescription { get; set; }
        @AuraEnabled public String dueDate { get; set; }
		@AuraEnabled public String PO { get; set; }

        public OrderItemWrapper(OrderItem item) {
            this.orderedQuantity = item.Order.Original_Order_Qty__c  != null ? item.Order.Original_Order_Qty__c : '';
            this.orderNumber = item.Order.SAP_Document_Number__c != null ? item.Order.SAP_Document_Number__c : '';
            this.sapAccountNumber = item.Order.AccountId != null ? item.Order.AccountId : '';
            this.orderItemId = item.Id;
            this.shippedQuantity = item.Shipped_Quantity__c != null ? item.Shipped_Quantity__c : 0;
            this.PO = item.order.Account_PO_Number__c != null ? item.Order.Account_PO_Number__c : '';
            this.holdQuantity = item.Shippable_Quantity__c != null ? item.Shippable_Quantity__c : 0;
            this.backorderQuantity = item.Backorder_Quantity__c != null ? item.Backorder_Quantity__c : 0;
//this.orderedQuantity = item. != null ? String.valueOf(item.Quantity) : '';
            this.orderItemNumber = item.OrderItemNumber != null ? item.OrderItemNumber : '';
            this.invoiceNumber = item.SAP_Invoice_Number__c != null ? item.SAP_Invoice_Number__c : '';
            this.productCode = item.Product2.ProductCode != null ? item.Product2.ProductCode : '';
            this.isbn10 = item.Product2.ISBN10__c != null ? item.Product2.ISBN10__c : '';
            this.isbn13 = item.Product2.ISBN13__c != null ? item.Product2.ISBN13__c : '';
            this.orderDate = item.Order.EffectiveDate != null ? String.valueOf(item.Order.EffectiveDate.month()) + '/' + String.valueOf(item.Order.EffectiveDate.day()) + '/' + String.valueOf(item.Order.EffectiveDate.year()) : '99/99/99';
            this.productDescription = item.Product2.Description != null ? item.Product2.Description : '';
            this.dueDate = item.Product2.Due_In_Stock_Date__c != null ? String.valueOf(item.Product2.Due_In_Stock_Date__c.month()) + '/' + String.valueOf(item.Product2.Due_In_Stock_Date__c.day()) + '/' + String.valueOf(item.Product2.Due_In_Stock_Date__c.year()) : '99/99/99';
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<OrderItemWrapper> summaryReport() {
         Id loggedInUserId = UserInfo.getUserId();

        List<OrderItem> orderItems = [
            SELECT Id, Shipped_Quantity__c,Account_PO_Number__c , Shippable_Quantity__c, Backorder_Quantity__c,
                   Quantity, OrderItemNumber, SAP_Invoice_Number__c, Product2.ProductCode, 
                   Product2.ISBN10__c, Product2.ISBN13__c, Product2.Description, 
                   Product2.Due_In_Stock_Date__c, Order.SAP_Document_Number__c, Order.AccountId,order.Original_Order_Qty__c,order.Account_PO_Number__c,
                   Order.EffectiveDate
            FROM OrderItem /*CreatedById = :loggedInUserId
              AND */
            WHERE Order.EffectiveDate = LAST_N_MONTHS:12 
        ];

            

        List<OrderItemWrapper> orderItemWrappers = new List<OrderItemWrapper>();

        for (OrderItem item : orderItems) {
            orderItemWrappers.add(new OrderItemWrapper(item));
        }

        return orderItemWrappers;
    }
}