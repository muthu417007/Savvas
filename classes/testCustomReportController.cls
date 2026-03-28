public class testCustomReportController {

      
public class OrderItemWrapper1 {
        
        @AuraEnabled public String orderNumber { get; set; }
        @AuraEnabled public Id orderItemId { get; set; } 
        @AuraEnabled public Decimal orderedQuantity { get; set; }
        @AuraEnabled public String invoiceNumber { get; set; }
        @AuraEnabled public String shipDate { get; set; }  
        @AuraEnabled public String trackingNumber { get; set; }
        @AuraEnabled public String parcelID { get; set; } 
        @AuraEnabled public String signature { get; set; } 
        @AuraEnabled public String shipAccount { get; set; }  
        @AuraEnabled public String shipAccountName { get; set; }
        @AuraEnabled public String state { get; set; } 
        @AuraEnabled public String city { get; set; }
        @AuraEnabled public String productDescription { get; set; }
        @AuraEnabled public String dueDate { get; set; }
		@AuraEnabled public String PO { get; set; }
        @AuraEnabled public String status {get; set;}
        @AuraEnabled public Decimal quantity {get; set;}
        @AuraEnabled public String reason {get; set;}
        @AuraEnabled public String isbn13 { get; set; }
        @AuraEnabled public Date orderDate { get; set; }
        @AuraEnabled public String backorderCancelDate { get; set; }
		@AuraEnabled public String futureShipDate { get; set; }
        @AuraEnabled public String carrierName { get; set; }

        public OrderItemWrapper1(OrderItem item, List<SAP_Package__c> invoices, List<OrderLine_Status__c> statuses) {
        this.orderItemId = item.Id;
        this.orderDate = item.Order.EffectiveDate;
        //this.productCode = item.Product2.ProductCode;
        this.productDescription = item.Product2.Description;
        this.isbn13 = item.Product2.ISBN13__c;
        this.quantity = item.Quantity;
        for (OrderLine_Status__c status : statuses) {
            if (status.OrderItemId__c == item.Id) {
                this.reason = status.LineItem_Status_Reason_Description__c;
                this.status = status.LineItem_Status_Description__c;
                break;
            }
        }

        for (SAP_Package__c invoice : invoices) {
            if (invoice.OrderItemId__c == item.Id) {
                this.invoiceNumber = invoice.Invoice_Number__c; 
                 this.parcelID=invoice.Parcel_ID_Number__c; 
                this.signature=invoice.Signature__c;
                this.trackingNumber=invoice.Tracking_Number__c;
                this.carrierName=invoice.carrier_name__c;
                //this.shipDate=invoice.Delivery_Date__c != null ? String.valueOf(invoice[0].Delivery_Date__c.month()) + '/' + String.valueOf(invoice.Delivery_Date__c.day()) + '/' + String.valueOf(invoice.Delivery_Date__c.year()) : '';
                break;
            }
        } 
        //this.shipAccountName=  item.Order.BACKORDER_CANCEL_DATE__c != null ? String.valueOf(item.Order.BACKORDER_CANCEL_DATE__c.month()) + '/' + String.valueOf(item.Order.BACKORDER_CANCEL_DATE__c.day()) + '/' + String.valueOf(item.Order.BACKORDER_CANCEL_DATE__c.year()) : '';     
        this.backorderCancelDate = item.Order.BACKORDER_CANCEL_DATE__c != null ? String.valueOf(item.Order.BACKORDER_CANCEL_DATE__c.month()) + '/' + String.valueOf(item.Order.BACKORDER_CANCEL_DATE__c.day()) + '/' + String.valueOf(item.Order.BACKORDER_CANCEL_DATE__c.year()) : '';
        this.futureShipDate = item.Order.Deliver_On__c != null ? String.valueOf(item.Order.Deliver_On__c.month()) + '/' + String.valueOf(item.Order.Deliver_On__c.day()) + '/' + String.valueOf(item.Order.Deliver_On__c.year()) : '';
        this.orderNumber = item.Order.SAP_Document_Number__c != null ? item.Order.SAP_Document_Number__c : '';
        this.city = item.Order.ShippingCity != null ? item.Order.ShippingCity : '';
        this.state = item.Order.ShippingState != null ? item.Order.ShippingState : '';
        this.shipAccountName = item.Order.ShipTo_Name__c != null ? item.Order.ShipTo_Name__c : '';
        this.shipAccount= item.Order.SAP_Shipto__c != null ? item.Order.SAP_Shipto__c : '';
        this.PO = item.order.Account_PO_Number__c != null ?  item.order.Account_PO_Number__c : '';
        this.orderedQuantity=item.Quantity;
        //this.shippedQuantity=item.Shipped_Quantity__c != null ? item.Shipped_Quantity__c : 0;
        //this.backorderQuantity=item.Backorder_Quantity__c != null ? item.Backorder_Quantity__c : 0;
       // this.holdQuantity= item.On_Pick_Quantity__c != null ? item.On_Pick_Quantity__c : 0;
        this.dueDate = item.Product2.Due_In_Stock_Date__c != null ? String.valueOf(item.Product2.Due_In_Stock_Date__c.month()) + '/' + String.valueOf(item.Product2.Due_In_Stock_Date__c.day()) + '/' + String.valueOf(item.Product2.Due_In_Stock_Date__c.year()) : '';
    }
}
    @AuraEnabled(cacheable=true)
    public static List<OrderItemWrapper1> detailReport(String BillTo, String ShipTo) {
        /* Id loggedInUserId = UserInfo.getUserId();
List<User> usr = [SELECT Id, Profile.Name, Contact.AccountID, Contact.Name, Contact.Account.Name 
                      FROM User WHERE Id = :loggedInUserId LIMIT 1];*/
        
    List<OrderItemWrapper1> orderItemWrappers = new List<OrderItemWrapper1>();
  
   String  query =    'SELECT Id, Quantity,Shippable_Quantity__c ,Backorder_Quantity__c, Product2.Description, Product2.ISBN13__c,Product2.Due_In_Stock_Date__c, ' +
                   'Order.EffectiveDate, Order.BACKORDER_CANCEL_DATE__c, Order.Deliver_On__c ,On_Pick_Quantity__c, ' +
                   'Order.Account_PO_Number__c, Order.SAP_Document_Number__c, Order.ShippingCity,' +
                   'Order.ShippingState,  Order.ShipTo_Name__c, Order.SAP_Shipto__c,' +
                	'Order.ShippingPostalCode, Order.BillingPostalCode,  Order.BillingState, Order.Order_Status_Code__c , '+
                   '(SELECT LineItem_Status_Reason_Description__c, Quantity__c FROM OrderLine_Statuss__r), ' +
                   '(SELECT Invoice_Number__c, Delivery_Date__c,Parcel_ID_Number__c ,Signature__c, carrier_name__c FROM SAP_Packages__r) ' +
                   'FROM OrderItem '  +
                    'WHERE WHERE //Order.AccountId = :userAccountId And order.CreatedById =:loggedInUserId  And'+
                    'Order.EffectiveDate >= LAST_N_MONTHS:12 order by Order.EffectiveDate DESC' ;
   
    List<String> conditions = new List<String>();
        if (BillTo != null && BillTo != '') {
            conditions.add('Order.SAP_BillTo__c = :BillTo');
            System.debug('BillTo condition added: ' + BillTo);
        }

        if (ShipTo != null && ShipTo != '') {
           conditions.add('Order.SAP_ShipTo__c = :ShipTo');
           System.debug('BillTo condition added: ' + ShipTo);
        } 
       /* if (loggedInUserId != null) {
            conditions.add('CreatedById = :loggedInUserId');
          // conditions.add('CreatedById = :005W4000001mHxFIAU');
        } */
        
       if (!conditions.isEmpty()) {
            query += String.join(conditions, ' AND ');
            System.debug('Combined conditions: ' + String.join(conditions, ' AND '));
        }
        else {
            System.debug('No conditions added, fetching all records.');
           query = 'SELECT Id, Quantity,Shippable_Quantity__c ,Backorder_Quantity__c, Product2.Description, Product2.ISBN13__c,Product2.Due_In_Stock_Date__c, ' +
                   'Order.EffectiveDate, Order.BACKORDER_CANCEL_DATE__c, Order.Deliver_On__c ,On_Pick_Quantity__c, ' +
                   'Order.Account_PO_Number__c, Order.SAP_Document_Number__c, Order.ShippingCity, ' +
                   'Order.ShippingState,  Order.ShipTo_Name__c,  ' +
                	'Order.ShippingPostalCode, Order.BillingPostalCode,  Order.BillingState, Order.Order_Status_Code__c , '+
                   '(SELECT LineItem_Status_Reason_Description__c, Quantity__c FROM OrderLine_Statuss__r), ' +
                   '(SELECT Invoice_Number__c, Delivery_Date__c,Parcel_ID_Number__c ,Signature__c, carrier_name__c FROM SAP_Packages__r) ' +
                   'FROM OrderItem ' +
                   'WHERE WHERE Order.AccountId = :userAccountId And order.CreatedById =:loggedInUserId  And'+
                   'Order.EffectiveDate >= LAST_N_MONTHS:12 order by Order.EffectiveDate DESC' ;

        }
  
        
       List<OrderItem> orderItems = Database.query(query);

 // Extract related data
    Map<Id, List<SAP_Package__c>> invoiceMap = new Map<Id, List<SAP_Package__c>>();
    Map<Id, List<OrderLine_Status__c>> statusMap = new Map<Id, List<OrderLine_Status__c>>();

    for (OrderItem item : orderItems) {
        invoiceMap.put(item.Id, new List<SAP_Package__c>());
        statusMap.put(item.Id, new List<OrderLine_Status__c>());
    }

    // Query related SAP_Packages and OrderLine_Statuss
    List<SAP_Package__c> invoices = [SELECT Id, Invoice_Number__c,Delivery_Date__c,carrier_name__c,Tracking_Number__c,Parcel_ID_Number__c,Signature__c, OrderItemId__c FROM SAP_Package__c WHERE OrderItemId__c IN :invoiceMap.keySet()];
    List<OrderLine_Status__c> statuses = [SELECT Id,LineItem_Status_Description__c, LineItem_Status_Reason_Description__c, OrderItemId__c FROM OrderLine_Status__c WHERE OrderItemId__c IN :statusMap.keySet()];

    // Populate the maps
    for (SAP_Package__c invoice : invoices) {
        if (invoiceMap.containsKey(invoice.OrderItemId__c)) {
            invoiceMap.get(invoice.OrderItemId__c).add(invoice);
        }
    }

    for (OrderLine_Status__c status : statuses) {
        if (statusMap.containsKey(status.OrderItemId__c)) {
            statusMap.get(status.OrderItemId__c).add(status);
        }
    }

    // Create wrappers
    for (OrderItem item : orderItems) {
        List<SAP_Package__c> relatedInvoices = invoiceMap.get(item.Id);
        List<OrderLine_Status__c> relatedStatuses = statusMap.get(item.Id);
        orderItemWrappers.add(new OrderItemWrapper1(item, relatedInvoices, relatedStatuses));
    }

    return orderItemWrappers;
}

}