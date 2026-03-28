public class scc_OrderItemWrapper {
    
  public class OrderItemWrapper {
    @AuraEnabled public Date orderDate { get; set; }
    @AuraEnabled public String productCode { get; set; }
    @AuraEnabled public String productDescription { get; set; }
    @AuraEnabled public String isbn13 { get; set; }
    @AuraEnabled public Decimal quantity { get; set; }
    @AuraEnabled public String reason { get; set; }
    @AuraEnabled public String status { get; set; }
 	@AuraEnabled public String orderNumber { get; set; }
 	@AuraEnabled public Id orderItemId { get; set; } 
    @AuraEnabled public Decimal orderedQuantity { get; set; }
    @AuraEnabled public string backorderCancelDate { get; set; }
    @AuraEnabled public string deliverOnDate { get; set; }
    @AuraEnabled public String PO { get; set; }
    @AuraEnabled public String sapDocumentNumber { get; set; }
    @AuraEnabled public String shippingCity { get; set; }
    @AuraEnabled public String shippingState { get; set; }
    @AuraEnabled public String shipToName { get; set; }
   	@AuraEnabled public String shipDate { get; set; }  
	@AuraEnabled public String trackingNumber { get; set; }
    @AuraEnabled public String parcelID { get; set; } 
    @AuraEnabled public String signature { get; set; } 
    @AuraEnabled public String shipAccount { get; set; }  
    @AuraEnabled public String shipAccountName { get; set; }
    @AuraEnabled public String state { get; set; } 
    @AuraEnabled public String city { get; set; }
	@AuraEnabled public String futureShipDate { get; set; }
    @AuraEnabled public String carrierName { get; set; }
     @AuraEnabled public Decimal holdQuantity { get; set; }
    @AuraEnabled public String dueDate { get; set; }
    @AuraEnabled public Decimal shippedQuantity { get; set; }
     @AuraEnabled public Decimal backorderQuantity { get; set; }
       @AuraEnabled public String invoiceNumber { get; set; }
    public OrderItemWrapper(OrderItem item, List<SAP_Package__c> invoices, List<OrderLine_Status__c> statuses) {
        this.orderItemId = item.Id;
        this.orderDate = item.Order.EffectiveDate;
        this.productCode = item.Product2.ProductCode;
        this.productDescription = item.Product2.Description;
        this.isbn13 = item.Product2.ISBN13__c;
        this.quantity = item.Quantity;
        for (OrderLine_Status__c status : statuses) {
            if (status.OrderItemId__c == item.Id) {
                this.reason = status.LineItem_Status_Reason_Description__c !=null ? status.LineItem_Status_Reason_Description__c :null;
                this.status = status.LineItem_Status_Description__c !=null ? status.LineItem_Status_Description__c :null;
                break;
            }
        }

        for (SAP_Package__c invoice : invoices) {
            if (invoice.OrderItemId__c == item.Id) {
                this.invoiceNumber = invoice.Invoice_Number__c !=null ? invoice.Invoice_Number__c :null;
                 this.parcelID=invoice.Parcel_ID_Number__c !=null ? invoice.Parcel_ID_Number__c :null;
                this.signature=invoice.Signature__c !=null ? invoice.Signature__c :null;
                this.trackingNumber=invoice.Tracking_Number__c !=null ? invoice.Tracking_Number__c :null;
                this.carrierName=invoice.carrier_name__c !=null ? invoice.carrier_name__c :null;
                this.shipDate=invoice.Delivery_Date__c != null ? String.valueOf(invoice.Delivery_Date__c.month()) + '/' + String.valueOf(invoice.Delivery_Date__c.day()) + '/' + String.valueOf(invoice.Delivery_Date__c.year()) : '';
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
        this.orderedQuantity = item.Quantity !=null ? item.Quantity : 0;
        this.shippedQuantity=item.Shipped_Quantity__c != null ? item.Shipped_Quantity__c : 0;
        this.backorderQuantity=item.Backorder_Quantity__c != null ? item.Backorder_Quantity__c : 0;
        this.holdQuantity= item.On_Pick_Quantity__c != null ? item.On_Pick_Quantity__c : 0;
        this.dueDate = item.Product2.Due_In_Stock_Date__c != null ? String.valueOf(item.Product2.Due_In_Stock_Date__c.month()) + '/' + String.valueOf(item.Product2.Due_In_Stock_Date__c.day()) + '/' + String.valueOf(item.Product2.Due_In_Stock_Date__c.year()) : '';
    }
  }
    @AuraEnabled(cacheable=true)
public  static List<OrderItemWrapper> getOrderItemData(
     date startDate,
    date endDate,
    String orderStatus,
    List<String> isbnList,
    List<String> poList,
    String sortOrder1,
    String sortOrder2,
    String sortOrder3,
    String orderEntryPeriod
) {
    Id loggedInUserId = UserInfo.getUserId();
     List<User> usr = [SELECT Id, Profile.Name, Contact.AccountID, Contact.Name, Contact.Account.Name 
                      FROM User WHERE Id = :loggedInUserId LIMIT 1];
//Id loggedInUserId = '005W4000001mHxFIAU';
    // Check if user has a contact and account associated
    String userAccountId = (usr != null && !usr.isEmpty() && usr[0].Contact != null) ? usr[0].Contact.AccountID : null;
   // if (userAccountId == null) {
      //  throw new AuraHandledException('User does not have a valid account associated.');
   // }
    //System.debug('User Account ID: ' + userAccountId);

    List<OrderItemWrapper> orderItemWrappers = new List<OrderItemWrapper>();

 
    /*String query = 'SELECT Id, Quantity, Product2.ProductCode, Product2.Description, Product2.ISBN13__c, ' +
                   'Order.EffectiveDate,  Order.Deliver_On__c, ' +
                   'Order.PoNumber__c, Order.SAP_Document_Number__c, Order.ShippingCity, Order.BACKORDER_CANCEL_DATE__c, ' +
                   'Order.ShippingState, Order.ShipTo_Name__c,' +
                   '(SELECT LineItem_Status_Reason_Description__c, Quantity__c FROM OrderLine_Statuss__r), ' +
                   '(SELECT Invoice_Number__c, Delivery_Date__c,Parcel_ID_Number__c ,Signature__c, carrier_name__c FROM SAP_Packages__r) ' +
                   'FROM OrderItem ' +
                   'WHERE ';*/
 String  query =    'SELECT Id, Quantity,Shipped_Quantity__c,Shippable_Quantity__c ,Backorder_Quantity__c,Product2.ProductCode, Product2.Description, Product2.ISBN13__c,Product2.Due_In_Stock_Date__c, ' +
                   'Order.EffectiveDate, Order.BACKORDER_CANCEL_DATE__c, Order.Deliver_On__c ,On_Pick_Quantity__c, ' +
                   'Order.Account_PO_Number__c, Order.SAP_Document_Number__c, Order.ShippingCity,' +
                   'Order.ShippingState,  Order.ShipTo_Name__c, Order.SAP_Shipto__c,' +
                	'Order.ShippingPostalCode, Order.BillingPostalCode,  Order.BillingState, Order.Order_Status_Code__c , '+
                   '(SELECT LineItem_Status_Reason_Description__c, Quantity__c FROM OrderLine_Statuss__r), ' +
                   '(SELECT Invoice_Number__c, Delivery_Date__c,Parcel_ID_Number__c ,Signature__c, carrier_name__c FROM SAP_Packages__r) ' +
                   'FROM OrderItem '  +
                    'WHERE ' ;
   
    List<String> conditions = new List<String>();
 if (startDate != null && endDate != null) {
            conditions.add('Order.EffectiveDate >= :startDate AND Order.EffectiveDate <= :endDate');
            System.debug('Date range condition added: ' + startDate + ' to ' + endDate);
        }

        // Add order status condition
        System.debug('Initial orderStatus: ' + orderStatus);
        if (orderStatus != null && orderStatus != '') {
            if (orderStatus.equalsIgnoreCase('FulFilled')) {
                orderStatus = 'Ful%';
                conditions.add('Order.Order_Status_Code__c LIKE :orderStatus');
                System.debug('Transformed orderStatus for FulFilled: ' + orderStatus);
            } else if (!orderStatus.equalsIgnoreCase('All')) {
                // Only add a condition if it's not "All"
                orderStatus = orderStatus + '%';
                conditions.add('Order.Order_Status_Code__c LIKE :orderStatus');
                System.debug('Order status condition added: ' + orderStatus);
            } else {
                System.debug('Order status is "All", fetching all orders regardless of status.');
            }
        } else {
            System.debug('No specific orderStatus provided.');
        }

        // Add ISBNs condition
        if (isbnList != null && !isbnList.isEmpty()) {
            conditions.add('(Product2.ISBN13__c IN :isbnList OR Product2.ISBN10__c IN :isbnList)');
            System.debug('ISBN condition added: ' + isbnList);
        } else {
            System.debug('No ISBNs provided.');
        }
 // Add account ID condition
      /*  if (userAccountId != null && userAccountId != '') {
            conditions.add('Order.AccountId = :userAccountId');
        }

        // Add logged-in user condition
        if (loggedInUserId != null) {
            conditions.add('CreatedById = :loggedInUserId');
          // conditions.add('CreatedById = :005W4000001mHxFIAU');
        }*/
        // Add POs condition
        if (poList != null && !poList.isEmpty()) {
            conditions.add('Order.Account_PO_Number__c IN :poList');
            System.debug('PO condition added: ' + poList);
        } else {
            System.debug('No POs provided.');
        }

        // Add order entry data
        if (orderEntryPeriod != null && orderEntryPeriod != '') {
            conditions.add('Order.EffectiveDate >= LAST_N_MONTHS:' + orderEntryPeriod);
            System.debug('Order entry period condition added: LAST_N_MONTHS:' + orderEntryPeriod);
        } else {
            System.debug('No order entry period provided.');
        }

        // Combine all conditions
        if (!conditions.isEmpty()) {
            query += String.join(conditions, ' AND ');
            System.debug('Combined conditions: ' + String.join(conditions, ' AND '));
        } else {
            System.debug('No conditions added, fetching all records.');
           query = 'SELECT Id, Quantity,Shipped_Quantity__c,Shippable_Quantity__c ,Backorder_Quantity__c,Product2.ProductCode, Product2.Description, Product2.ISBN13__c,Product2.Due_In_Stock_Date__c, ' +
                   'Order.EffectiveDate, Order.BACKORDER_CANCEL_DATE__c, Order.Deliver_On__c ,On_Pick_Quantity__c, ' +
                   'Order.Account_PO_Number__c, Order.SAP_Document_Number__c, Order.ShippingCity, ' +
                   'Order.ShippingState,  Order.ShipTo_Name__c,  Order.SAP_Shipto__c, ' +
                	'Order.ShippingPostalCode, Order.BillingPostalCode,  Order.BillingState, Order.Order_Status_Code__c , '+
                   '(SELECT LineItem_Status_Reason_Description__c, Quantity__c FROM OrderLine_Statuss__r), ' +
                   '(SELECT Invoice_Number__c, Delivery_Date__c,Parcel_ID_Number__c ,Signature__c, carrier_name__c FROM SAP_Packages__r) ' +
                   'FROM OrderItem '  ;
           /* query = 'SELECT Id, Shipped_Quantity__c, Account_PO_Number__c, Shippable_Quantity__c, Backorder_Quantity__c, ' +
                    'Quantity, OrderItemNumber, Product2.ProductCode, On_Pick_Quantity__c, ' +
                    'Product2.ISBN10__c, Product2.ISBN13__c, Product2.Description, Order.ShippingCity, ' +
                    'Product2.Due_In_Stock_Date__c, Order.SAP_Document_Number__c, Order.AccountId, Order.BACKORDER_CANCEL_DATE__c,Order.Deliver_On__c,' +
                    'Order.EffectiveDate, Order.Account_PO_Number__c, Order.Order_Status_Code__c, ' +
                    'Order.ShippingPostalCode, Order.BillingPostalCode, Order.ShippingState, Order.BillingState, ' +
                	'(SELECT LineItem_Status_Reason_Description__c, Quantity__c FROM OrderLine_Statuss__r), ' +
                   '(SELECT Invoice_Number__c, Delivery_Date__c,Parcel_ID_Number__c ,Signature__c, carrier_name__c FROM SAP_Packages__r) ' +
                    'FROM OrderItem';*/

                
        }

        // Add sorting
        List<String> orderByClauses = new List<String>();
        Map<String, String> fieldmap = new Map<String, String>{
            'ISBN' => 'Product2.ISBN13__c',
            'PO #' => 'Order.Account_PO_Number__c',
            'State' => 'Order.ShippingState, Order.BillingState',
            'Zip' => 'Order.ShippingPostalCode, Order.BillingPostalCode'
        };

        if (sortOrder1 != null && sortOrder1 != '') {
            System.debug('sortOrder1: ' + sortOrder1);
            if (fieldmap.containsKey(sortOrder1)) {
                orderByClauses.add(fieldmap.get(sortOrder1) + ' ' + (sortOrder1 != null ? sortOrder1 : 'DESC'));
            }
        }

        if (sortOrder2 != null && sortOrder2 != '') {
            System.debug('sortOrder2: ' + sortOrder2);
            if (fieldmap.containsKey(sortOrder2)) {
                orderByClauses.add(fieldmap.get(sortOrder2) + ' ' + (sortOrder2 != null ? sortOrder2 : 'DESC'));
            }
        }

        if (sortOrder3 != null && sortOrder3 != '') {
            System.debug('sortOrder3: ' + sortOrder3);
            if (fieldmap.containsKey(sortOrder3)) {
                orderByClauses.add(fieldmap.get(sortOrder3) + ' ' + (sortOrder3 != null ? sortOrder3 : 'DESC'));
            }
        }

        orderByClauses.add('Order.EffectiveDate DESC');

        if (!orderByClauses.isEmpty()) {
            query += ' ORDER BY ' + String.join(orderByClauses, ', ');
            System.debug('Order by clauses added: ' + String.join(orderByClauses, ', '));
        }

        System.debug('Final Query: ' + query);

    

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
        orderItemWrappers.add(new OrderItemWrapper(item, relatedInvoices, relatedStatuses));
    }

    return orderItemWrappers;
}

}