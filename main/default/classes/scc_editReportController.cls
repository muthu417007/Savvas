/***************************************************************************************
* @Class Name: scc_editReportController
* @Description: This apex class helps to  get orderdata based on search  critera
* @Created By: Sudha Rani Pathivada
* @Created On: 09/07/2024
* **************************************************************************************
* Modification Log:
* -------------------------------------------------------------------------------------
* Developer        Date            Description
* -------------------------------------------------------------------------------------
*/
public with sharing class scc_editReportController {
    /********************************************************************** 
Method Name :  fetchCustomReportData
Description :  Method helps to  get  reports data fro custom reports 
Input       :  string(report name)
Return type :  NA
***********************************************************************/ 
    
    @AuraEnabled(cacheable=true)
    public static List<OrderItemWrapper> fetchCustomReportData(String reportNameWithCustom) {
        try{
            
            Id currentUserId = UserInfo.getUserId(); 
            String actualReportName = reportNameWithCustom.replace(' [custom]', ''); 
            List<Custom_Report_Filter__c> reports = [
                SELECT Id, Name, Description__c, ISBN_To_Include__c, PO_To_Include__c,
                Order_From_Date__c, Order_To_Date__c, Order_Status__c, 
                OrderEntryPeriod__c, Sort_By__c, Sort_By_2__c, Sort_By_3__c,originalReportType__c,StandardReport__c
                FROM Custom_Report_Filter__c
                WHERE Name = :actualReportName AND CreatedById = :currentUserId
            ];
            
            if (reports.isEmpty()) {
                throw new AuraHandledException('No report found with the name: ' + actualReportName + ' for the current user.');
            }
            Custom_Report_Filter__c report = reports[0]; 
            List<String> isbnList = report.ISBN_To_Include__c != null ? new List<String>(report.ISBN_To_Include__c.split(',')) : new List<String>();
            List<String> poList = report.PO_To_Include__c != null ? new List<String>(report.PO_To_Include__c.split(',')) : new List<String>();

            // Reuse existing method to get order items
            return getOrderItemData(
                report.Order_From_Date__c,
                report.Order_To_Date__c,
                report.Order_Status__c,
                isbnList,
                poList,
                report.Sort_By__c,
                report.Sort_By_2__c,
                report.Sort_By_3__c,
                report.OrderEntryPeriod__c,
                report.originalReportType__c,
                report.Description__c,
                report.Name,
                report.StandardReport__c
            );
        }
        catch (Exception e) {
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            throw new AuraHandledException('Error constructing OrderItemWrapper: ' + e.getMessage());
        }
        
    }
    
    
    /********************************************************************** 
Method Name :  fetchReportDetails
Description :  Method helps to  get  reports data fro custom reports 
Input       :  Id(report id)
Return type :  NA
***********************************************************************/ 
    @AuraEnabled(cacheable=false)
    public static  List<OrderItemWrapper> fetchReportDetails(Id reportId) {
        try{
            List<Custom_Report_Filter__c> reports = [
                SELECT Id, Name, Description__c, ISBN_To_Include__c, PO_To_Include__c,
                Order_From_Date__c, Order_To_Date__c, Order_Status__c, 
                OrderEntryPeriod__c, Sort_By__c, Sort_By_2__c, Sort_By_3__c,originalReportType__c,StandardReport__c
                FROM Custom_Report_Filter__c
                WHERE Id = :reportId
            ];
            
            Custom_Report_Filter__c report = reports[0]; 
            List<String> isbnList = report.ISBN_To_Include__c != null ? new List<String>(report.ISBN_To_Include__c.split(',')) : new List<String>();
            List<String> poList = report.PO_To_Include__c != null ? new List<String>(report.PO_To_Include__c.split(',')) : new List<String>();
                        
            return  getOrderItemData(
                report.Order_From_Date__c,
                report.Order_To_Date__c,
                report.Order_Status__c,
                isbnList,
                poList,
                report.Sort_By__c,
                report.Sort_By_2__c,
                report.Sort_By_3__c,
                report.OrderEntryPeriod__c,
                report.originalReportType__c,
                report.Description__c,
                report.Name,
                report.StandardReport__c
            );
        }
        catch (Exception e) {
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            
            throw new AuraHandledException('Error constructing OrderItemWrapper: ' + e.getMessage());
        }
    }
    /********************************************************************** 
Method Name :  OrderItemWrapper
Description :  Method helps to  create order item wrapper 
Input       :  NA
Return type :  NA
***********************************************************************/ 
    public class OrderItemWrapper {
        @AuraEnabled public string  orderDate { get; set; }
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
        
        // Search criteria fields
        @AuraEnabled public Date startDate { get; set; }
        @AuraEnabled public Date endDate { get; set; }
        @AuraEnabled public String orderStatus { get; set; }
        @AuraEnabled public List<String> isbnList { get; set; }
        @AuraEnabled public List<String> poList { get; set; }
        @AuraEnabled public String sortOrder1 { get; set; }
        @AuraEnabled public String sortOrder2 { get; set; }
        @AuraEnabled public String sortOrder3 { get; set; }
        @AuraEnabled public String orderEntryPeriod { get; set; }
        @AuraEnabled public id loggedInUserId { get; set; }
        @AuraEnabled public string originalReport { get; set; }
        @AuraEnabled public string Description { get; set; }
        @AuraEnabled public string Name { get; set; }
        @AuraEnabled public boolean StandardReport { get; set; }
        public OrderItemWrapper(OrderItem item, List<SAP_Package__c> invoices, List<OrderLine_Status__c> statuses, Date startDate, Date endDate, String orderStatus, List<String> isbnList, List<String> poList,
                                String sortOrder1, String sortOrder2, String sortOrder3, String orderEntryPeriod,id loggedInUserId, string originalReport,string Description,string Name, boolean StandardReport) {
                                    this.orderItemId = item.Id;
                                    this.orderDate = item.Order.EffectiveDate != null ? String.valueOf(item.Order.EffectiveDate.month()) + '/' + String.valueOf(item.Order.EffectiveDate.day()) + '/' + String.valueOf(item.Order.EffectiveDate.year()) : '';
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
                                    this.backorderCancelDate = item.Order.BACKORDER_CANCEL_DATE__c != null ? String.valueOf(item.Order.BACKORDER_CANCEL_DATE__c.month()) + '/' + String.valueOf(item.Order.BACKORDER_CANCEL_DATE__c.day()) + '/' + String.valueOf(item.Order.BACKORDER_CANCEL_DATE__c.year()) : '';
                                    this.futureShipDate = item.Order.Deliver_On__c != null ? String.valueOf(item.Order.Deliver_On__c.month()) + '/' + String.valueOf(item.Order.Deliver_On__c.day()) + '/' + String.valueOf(item.Order.Deliver_On__c.year()) : '';
                                    this.orderNumber = item.Order.SAP_Document_Number__c != null ? item.Order.SAP_Document_Number__c : '';
                                    this.city = item.Order.ShippingCity != null ? item.Order.ShippingCity : '';
                                    this.state = item.Order.ShippingState != null ? item.Order.ShippingState : '';
                                    this.shipAccountName = item.Order.ShipTo_Name__c != null ? item.Order.ShipTo_Name__c : '';
                                    this.shipAccount= item.Order.SAP_Shipto__c != null ? item.Order.SAP_Shipto__c : '';
                                    this.PO = item.order.PoNumber__c  != null ?  item.order.PoNumber__c : '';
                                    this.orderedQuantity = item.Quantity !=null ? item.Quantity : 0;
                                    this.shippedQuantity=item.Shipped_Quantity__c != null ? item.Shipped_Quantity__c : 0;
                                    this.backorderQuantity=item.Backorder_Quantity__c != null ? item.Backorder_Quantity__c : 0;
                                    this.holdQuantity= item.On_Pick_Quantity__c != null ? item.On_Pick_Quantity__c : 0;
                                    this.dueDate = item.Product2.Due_In_Stock_Date__c != null ? String.valueOf(item.Product2.Due_In_Stock_Date__c.month()) + '/' + String.valueOf(item.Product2.Due_In_Stock_Date__c.day()) + '/' + String.valueOf(item.Product2.Due_In_Stock_Date__c.year()) : '';
                                    // search criteria                           
                                    this.startDate = startDate;
                                    this.endDate = endDate;
                                    this.orderStatus = orderStatus;
                                    this.isbnList = isbnList;
                                    this.poList = poList;
                                    this.sortOrder1 = sortOrder1;
                                    this.sortOrder2 = sortOrder2;
                                    this.sortOrder3 = sortOrder3;
                                    this.orderEntryPeriod = orderEntryPeriod;
                                    this.loggedInUserId = loggedInUserId; 
                                    this.originalReport= originalReport;   
                                    this.Description=Description;    
                                    this.Name=Name; 
                                    this.StandardReport=StandardReport;
                                }
    }
    
    /********************************************************************** 
Method Name :  getOrderItemData
Description :  Method helps to  get order item data
Input       :  date startDate,
        date endDate,
        String orderStatus,
        List<String> isbnList,
        List<String> poList,
        String sortOrder1,
        String sortOrder2,
        String sortOrder3,
        String orderEntryPeriod,
        string originalReport,
        string Description,
        string Name,
        Boolean StandardReport
Return type :  List
***********************************************************************/ 
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
        String orderEntryPeriod,
        string originalReport,
        string Description,
        string Name,
        Boolean StandardReport        
    ) {
        try{
            Id loggedInUserId = UserInfo.getUserId();
            List<User> usr = [SELECT Id, Profile.Name, Contact.AccountID, Contact.Name, Contact.Account.Name ,contact.Account.AccountNumber 
                              FROM User WHERE Id = :loggedInUserId LIMIT 1];
             
            // Check if user has a contact and account associated
            String userAccountNumber = (usr != null && !usr.isEmpty() && usr[0].Contact != null) ? usr[0].Contact.Account.AccountNumber : null;
            String userAccountId = (usr != null && !usr.isEmpty() && usr[0].Contact != null) ? usr[0].Contact.AccountID : null;
            List<OrderItemWrapper> orderItemWrappers = new List<OrderItemWrapper>();

            String  query =    'SELECT Id, Quantity,Shipped_Quantity__c,Shippable_Quantity__c ,Backorder_Quantity__c,Product2.ProductCode, Product2.Description, Product2.ISBN13__c,Product2.Due_In_Stock_Date__c, ' +
                'Order.EffectiveDate, Order.BACKORDER_CANCEL_DATE__c, Order.Deliver_On__c ,On_Pick_Quantity__c, ' +
                'Order.Account_PO_Number__c,Order.PoNumber__c , Order.SAP_Document_Number__c, Order.ShippingCity, Order.License_Partner__c ,' +
                'Order.ShippingState,  Order.ShipTo_Name__c, Order.SAP_Shipto__c,' +
                'Order.ShippingPostalCode, Order.BillingPostalCode,  Order.BillingState, Order.Order_Status_Code__c , '+
                '(SELECT LineItem_Status_Reason_Description__c, Quantity__c FROM OrderLine_Statuss__r), ' +
                '(SELECT Invoice_Number__c, Delivery_Date__c,Parcel_ID_Number__c ,Signature__c, carrier_name__c FROM SAP_Packages__r) ' +
                'FROM OrderItem '  +
                'WHERE ' ;
            
            List<String> conditions = new List<String>();
            List<String> orConditions = new List<String>();
            
            if (userAccountId != null && userAccountId != '') {  orConditions.add('Order.AccountId = :userAccountId');}
              
            
            if (userAccountNumber != null) {orConditions.add('Order.License_Partner__c  = :userAccountNumber');}
                
            
            if (!orConditions.isEmpty()) {conditions.add('(' + String.join(orConditions, ' OR ') + ')');}
                
            
            if (startDate != null && endDate != null) {
                conditions.add('Order.EffectiveDate >= :startDate AND Order.EffectiveDate <= :endDate');
                
            }
            
            // Add order status condition            
            if (orderStatus != null && orderStatus != '') {
                if (orderStatus.equalsIgnoreCase('FulFilled')) {
                    orderStatus = 'Ful%'; conditions.add('Order.Order_Status_Code__c LIKE :orderStatus'); 
                                      
                } else if (!orderStatus.equalsIgnoreCase('All')) {
                    // Only add a condition if it's not "All"
                    orderStatus = orderStatus + '%';
                    conditions.add('Order.Order_Status_Code__c LIKE :orderStatus');                    
                } else {
                    System.debug('Order status is "All", fetching all orders regardless of status.');
                }
            } else {
                
            }
            
            // Add ISBNs condition
            if (isbnList != null && !isbnList.isEmpty()) {
                conditions.add('(Product2.ISBN13__c IN :isbnList OR Product2.ISBN10__c IN :isbnList)');
                System.debug('ISBN condition added: ' + isbnList);
            } else {
                System.debug('No ISBNs provided.');
            }
                        
            if (poList != null && !poList.isEmpty()) {
                conditions.add('Order.PoNumber__c  IN :poList');                
            } else {
                System.debug('No POs provided.');
            }
            
            // Add order entry data
            if (orderEntryPeriod != null && orderEntryPeriod != '') {
                conditions.add('Order.EffectiveDate >= LAST_N_MONTHS:' + orderEntryPeriod);                
            } else {
                System.debug('No order entry period provided.');
            }
            
            // Combine all conditions
            if (!conditions.isEmpty()) {
                query += String.join(conditions, ' AND ');                
            } else {
                
                query = 'SELECT Id, Quantity,Shipped_Quantity__c,Shippable_Quantity__c ,Backorder_Quantity__c,Product2.ProductCode, Product2.Description, Product2.ISBN13__c,Product2.Due_In_Stock_Date__c, ' +
                    'Order.EffectiveDate, Order.BACKORDER_CANCEL_DATE__c, Order.Deliver_On__c ,On_Pick_Quantity__c, ' +
                    'Order.Account_PO_Number__c,Order.PoNumber__c,Order.SAP_Document_Number__c, Order.ShippingCity, Order.License_Partner__c ,' +
                    'Order.ShippingState,  Order.ShipTo_Name__c,  Order.SAP_Shipto__c, ' +
                    'Order.ShippingPostalCode, Order.BillingPostalCode,  Order.BillingState, Order.Order_Status_Code__c , '+
                    '(SELECT LineItem_Status_Reason_Description__c, Quantity__c FROM OrderLine_Statuss__r), ' +
                    '(SELECT Invoice_Number__c, Delivery_Date__c,Parcel_ID_Number__c ,Signature__c, carrier_name__c FROM SAP_Packages__r) ' +
                    'FROM OrderItem '  ;
            }
            List<String> orderByClauses = new List<String>();
            Map<String, String> fieldMap = new Map<String, String>{
                'ISBN' => 'Product2.ISBN13__c',
                    'PO #' => 'Order.PoNumber__c ',
                    'State' => 'Order.ShippingState, Order.BillingState',  // Assuming you want to sort by both states
                    'Zip' => 'Order.ShippingPostalCode, Order.BillingPostalCode' // Assuming you want to sort by both zip codes
                    };
                        if (String.isNotEmpty(sortOrder1) && fieldMap.containsKey(sortOrder1)) {
                            String fieldName = fieldMap.get(sortOrder1);
                            String direction = 'DESC';  // Assuming descending; this could also be dynamically set
                            orderByClauses.add(fieldName + ' ' + direction);
                        } else {
                            System.debug('Error: Invalid sort order input: ' + sortOrder1);
                        }
            if (String.isNotEmpty(sortOrder2) && fieldMap.containsKey(sortOrder2)) {
                String fieldName = fieldMap.get(sortOrder2);
                String direction = 'DESC';  // Assuming descending; this could also be dynamically set
                orderByClauses.add(fieldName + ' ' + direction);
            } else {
                System.debug('Error: Invalid sort order input: ' + sortOrder2);
            }
            
            if (String.isNotEmpty(sortOrder3) && fieldMap.containsKey(sortOrder3)) {
                String fieldName = fieldMap.get(sortOrder3);
                String direction = 'DESC';  // Assuming descending; this could also be dynamically set
                orderByClauses.add(fieldName + ' ' + direction);
            } else {
                System.debug('Error: Invalid sort order input: ' + sortOrder3);
            }

            orderByClauses.add('Order.EffectiveDate DESC');
            
            if (!orderByClauses.isEmpty()) {
                query += ' ORDER BY ' + String.join(orderByClauses, ', ');
            }
            query += ' LIMIT 50000';
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
                if (statusMap.containsKey(status.OrderItemId__c)) { statusMap.get(status.OrderItemId__c).add(status);}
                   
                
            }
            
            // Create wrappers
            for (OrderItem item : orderItems) {
                List<SAP_Package__c> relatedInvoices = invoiceMap.get(item.Id);
                List<OrderLine_Status__c> relatedStatuses = statusMap.get(item.Id);                
                orderItemWrappers.add(new OrderItemWrapper(item, relatedInvoices, relatedStatuses, startDate, endDate, orderStatus, isbnList, poList, sortOrder1, sortOrder2, sortOrder3, orderEntryPeriod ,loggedInUserId,originalReport,Description,Name,StandardReport));
            }
            
            return orderItemWrappers;
        } catch (Exception e) {
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            throw new AuraHandledException('An error occurred while fetching order item data: ' + e.getMessage());
        }
        
    }
    /********************************************************************** 
Method Name :  getOrderEntryOptions
Description :  Method helps to  get  meta data options in  custom reports 
Input       :  NA
Return type :  String
***********************************************************************/ 
    @AuraEnabled(cacheable=true)
    public static String getOrderEntryOptions() {
        List<User> usr = [
            SELECT ID, Profile.Name, IsEmployee__c, Contact.AccountID, Contact.Account.SAP_Account_Id__c, Contact.Name, Contact.Account.Name 
            FROM User 
            WHERE Id = :UserInfo.getUserId()
        ]; 
        try{
            // Metadata query
            String metadataQuery = 'SELECT MasterLabel, IsActive__c,Order__c  FROM scc_OrderEntryPeriods__mdt WHERE IsActive__c=true  ORDER BY Order__c  ASC';
            List<scc_OrderEntryPeriods__mdt> orderEntryPeriods  = Database.query(metadataQuery);
            
            List<ReportOptionWrapper> getSearchByOptionsWrap = new List<ReportOptionWrapper>();
            
            // meta data options 
            for (scc_OrderEntryPeriods__mdt record : orderEntryPeriods) {
                getSearchByOptionsWrap.add(new ReportOptionWrapper(record.MasterLabel, record.MasterLabel));
            }
            
            return JSON.serialize(getSearchByOptionsWrap);
        }
        catch (Exception e) {
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());throw new AuraHandledException('An error occurred while fetching order item data: ' + e.getMessage());
            
        }
        
    }
    
    /********************************************************************** 
Method Name :  ReportOptionWrapper
Description :  Method helps to  create option wrapper
Input       :  NA
Return type :  NA
***********************************************************************/ 
    public class ReportOptionWrapper {
        @AuraEnabled public String label { get; set; }
        @AuraEnabled public String value { get; set; }
        
        public ReportOptionWrapper(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }
}