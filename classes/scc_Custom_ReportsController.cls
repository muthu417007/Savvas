/***************************************************************************************
* @Class Name: scc_Custom_ReportsController
* @Description: This apex class helps to  get reports  based on account 
* @Created By: Sudha Rani Pathivada
* @Created On: 09/07/2024
* **************************************************************************************
* Modification Log:
* -------------------------------------------------------------------------------------
* Developer        Date            Description
* -------------------------------------------------------------------------------------
*/

public  with sharing class scc_Custom_ReportsController {
    /********************************************************************** 
Method Name :  deleteCustomReportByName
Description :  Method to delete custom report
Input       :  string(report name)
Return type :  NA
***********************************************************************/ 
    @AuraEnabled
    public static void deleteCustomReportByName(String reportName) {     
        try {
            // Query for the report with the provided name and current user ID
            List<Custom_Report_Filter__c> reports = [SELECT Id, Name, StandardReport__c, CreatedById
                                                     FROM Custom_Report_Filter__c WHERE Name = :reportName  AND CreatedById = :UserInfo.getUserId() LIMIT 1];          
            if (!reports.isEmpty()) {
            }
            if (reports.isEmpty()) {              
                throw new AuraHandledException('Report not found.');
            }
            Custom_Report_Filter__c report = reports[0];
            if (!report.StandardReport__c) {               
                delete report;               
            } 
        }catch(Exception e){
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());    // returns null
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());    
        }        
    }
    /**********************************************************************************
* Method Name : getReportOptions
* Description : this methos helps to get report options from reports tab
* Input    : NA
* Return Type : String
**********************************************************************************/ 
    @AuraEnabled(cacheable=false)
    public static String getReportOptions() {     
        List<User> usr = [
            SELECT ID, Profile.Name, IsEmployee__c, Contact.AccountID, Contact.Account.SAP_Account_Id__c, Contact.Name, Contact.Account.Name 
            FROM User 
            WHERE Id = :UserInfo.getUserId()
        ];         
        String metadataQuery = 'SELECT MasterLabel, isExternal__c, IsActive__c,Order__c  FROM scc_reportsOptions__mdt WHERE IsActive__c=true';        
        if (usr[0].Profile.Name == 'MySavvasOrders Profile') {
            metadataQuery += ' AND IsExternal__c=true';
        } else {
            metadataQuery += ' AND IsExternal__c=true';
            metadataQuery += ' ORDER BY Order__c  ASC';
        }       
        List<scc_reportsOptions__mdt> scc_searchByOptionsData = Database.query(metadataQuery);    
        List<Custom_Report_Filter__c> customReportFilters = [
            SELECT Name, CreatedDate, Description__c, originalReportType__c
            FROM Custom_Report_Filter__c
            WHERE CreatedById =:UserInfo.getUserId()           
            ORDER BY CreatedDate DESC
        ];     
        List<ReportOptionWrapper> getSearchByOptionsWrap = new List<ReportOptionWrapper>();
        for (scc_reportsOptions__mdt record : scc_searchByOptionsData) {
            getSearchByOptionsWrap.add(new ReportOptionWrapper(record.MasterLabel, record.MasterLabel,'', 'metadata',''));
        }
        for (Custom_Report_Filter__c record : customReportFilters) {
            getSearchByOptionsWrap.add(new ReportOptionWrapper(record.Name, record.Name, record.Description__c, 'custom', record.originalReportType__c));
        }
        return JSON.serialize(getSearchByOptionsWrap);
    }     
    // Wrapper data
    public class ReportOptionWrapper {
        @AuraEnabled public String label { get; set; }
        @AuraEnabled public String value { get; set; }
        @AuraEnabled  public String description{ get; set; }
        @AuraEnabled  public String source;
        @AuraEnabled  public String originalReportType{ get; set; }
        
        public ReportOptionWrapper(String label, String value, String description, string source, string originalReportType ) {
            this.label = label;
            this.value = value;
            this.description = description;
            this.source = source;
            this.originalReportType=originalReportType;            
        }
    }
    /**********************************************************************************
* Method Name : OrderItemWrapper1
* Description : this methos helps to get report data  from reports tab
* Return Type : orderItemWrappers
**********************************************************************************/
    public class OrderItemWrapper1 {        
        @AuraEnabled public String orderDate { get; set; }
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
        @AuraEnabled public Decimal cancelledQuantity { get; set; }  
        
        public OrderItemWrapper1(OrderItem item, List<SAP_Package__c> invoices, List<OrderLine_Status__c> statuses) {
            this.orderItemId = item.Id;
            this.orderDate = item.Order.EffectiveDate != null ? String.valueOf(item.Order.EffectiveDate.month()) + '/' + String.valueOf(item.Order.EffectiveDate.day()) + '/' + String.valueOf(item.Order.EffectiveDate.year()) : '';
            this.productCode = item.Product2.ProductCode;
            this.productDescription = item.Product2.Description;
            this.isbn13 = item.Product2.ISBN13__c;
            this.quantity = item.Quantity;
            for (OrderLine_Status__c status : statuses) {
                System.debug('OrderLine_Status__c record with OrderItemId__c: ' + status.OrderItemId__c);
                if (status.OrderItemId__c == item.Id) {
                     System.debug('OrderLine_Srttatus__c record with OrderItemId__c: ' + status.OrderItemId__c);
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
            this.PO = item.order.PoNumber__c != null ?  item.order.PoNumber__c : '';
            this.orderedQuantity=item.Quantity;
            this.shippedQuantity=item.Shipped_Quantity__c != null ? item.Shipped_Quantity__c : 0;
            this.backorderQuantity=item.Backorder_Quantity__c != null ? item.Backorder_Quantity__c : 0;
            this.holdQuantity= item.On_Pick_Quantity__c != null ? item.On_Pick_Quantity__c : 0;
            this.cancelledQuantity= item.Cancelled_Quantity__c != null ? item.Cancelled_Quantity__c : 0;
            this.dueDate = item.Product2.Due_In_Stock_Date__c != null ? String.valueOf(item.Product2.Due_In_Stock_Date__c.month()) + '/' + String.valueOf(item.Product2.Due_In_Stock_Date__c.day()) + '/' + String.valueOf(item.Product2.Due_In_Stock_Date__c.year()) : '';
        }
    }
    /********************************************************************** 
Method Name :  detailReport
Description :  Method to return detail report data
Input       :  string, String
Return type :  List
***********************************************************************/ 
    @AuraEnabled(cacheable=true)
    public static List<OrderItemWrapper1> detailReport(String BillTo, String ShipTo) {  
        
        Id loggedInUserId = UserInfo.getUserId();
        List<User> usr = [SELECT Id, Profile.Name, Contact.AccountID, Contact.Name, Contact.Account.Name ,Contact.Account.AccountNumber
                          FROM User WHERE Id = :loggedInUserId LIMIT 1]; 
        String userAccountId = (usr != null && !usr.isEmpty() && usr[0].Contact != null) ? usr[0].Contact.AccountID : null;
       String userAccountNumber = (usr != null && !usr.isEmpty() && usr[0].Contact != null) ? usr[0].Contact.Account.AccountNumber : null;
        List<OrderItemWrapper1> orderItemWrappers = new List<OrderItemWrapper1>();
        system.debug('***getCpuTime()***'+Limits.getCpuTime());
        String  query = 'SELECT Id, Quantity,Shippable_Quantity__c,Shipped_Quantity__c ,Backorder_Quantity__c, Product2.Description, Product2.ISBN13__c,Product2.Due_In_Stock_Date__c, ' +
            'Order.EffectiveDate, Order.BACKORDER_CANCEL_DATE__c, Order.Deliver_On__c ,On_Pick_Quantity__c,Product2.ProductCode,  ' +
            'Order.SAP_BillTo__c, '+
            'Order.PoNumber__c, Order.SAP_Document_Number__c, Order.ShippingCity, Cancelled_Quantity__c,Order.License_Partner__c,' +
            'Order.ShippingState,  Order.ShipTo_Name__c, Order.SAP_Shipto__c,' +
            'Order.ShippingPostalCode, Order.BillingPostalCode,  Order.BillingState, Order.Order_Status_Code__c , '+
            '(SELECT LineItem_Status_Description__c,LineItem_Status_Reason_Description__c, Quantity__c FROM OrderLine_Statuss__r), ' +
            '(SELECT Invoice_Number__c, Delivery_Date__c,Parcel_ID_Number__c ,Signature__c, carrier_name__c FROM SAP_Packages__r) ' +
            'FROM OrderItem '  +
            'WHERE ';                  
        List<String> conditions = new List<String>();
        List<String> orConditions = new List<String>();
        if (userAccountId != null && userAccountId != '') {
            orConditions.add('Order.AccountId = :userAccountId');
        }            
        if (userAccountNumber != null) {
            orConditions.add('Order.License_Partner__c  = :userAccountNumber');
        }       
        if (!orConditions.isEmpty()) {
            conditions.add('(' + String.join(orConditions, ' OR ') + ')');
        }        
        if (BillTo != null && BillTo != '') {
            conditions.add('Order.SAP_BillTo__c = :BillTo');
            System.debug('BillTo condition added: ' + BillTo);
        }
        if (ShipTo != null && ShipTo != '') {
            conditions.add('Order.SAP_Shipto__c = :ShipTo');
            System.debug('BillTo condition added: ' + ShipTo);
        }
        if (userAccountId != null && userAccountId != '') {
            conditions.add('Order.AccountId = :userAccountId');
        }
        conditions.add('Order.EffectiveDate >= LAST_N_MONTHS:24 order by Order.EffectiveDate DESC LIMIT 40000');
        if (!conditions.isEmpty()) {
            query += String.join(conditions, ' AND ');
            System.debug('Combined conditions: ' + String.join(conditions, ' AND '));
        }
        else {
            System.debug('No conditions added, fetching all records.');
            query = 'SELECT Id, Quantity,Shippable_Quantity__c,Shipped_Quantity__c ,Backorder_Quantity__c, Product2.Description, Product2.ISBN13__c,Product2.Due_In_Stock_Date__c, ' +
                'Order.EffectiveDate, Order.BACKORDER_CANCEL_DATE__c, Order.Deliver_On__c ,On_Pick_Quantity__c, Cancelled_Quantity__c, ' +
                'Order.SAP_BillTo__c, '+
                'Order.PoNumber__c, Order.SAP_Document_Number__c, Order.ShippingCity, order.License_Partner__c, ' +
                'Order.ShippingState,  Order.ShipTo_Name__c,  ' +
                'Order.ShippingPostalCode, Order.BillingPostalCode,  Order.BillingState, Order.Order_Status_Code__c , '+
                '(SELECT LineItem_Status_Description__c,LineItem_Status_Reason_Description__c, Quantity__c FROM OrderLine_Statuss__r), ' +
                '(SELECT Invoice_Number__c, Delivery_Date__c,Parcel_ID_Number__c ,Signature__c, carrier_name__c FROM SAP_Packages__r) ' +
                'FROM OrderItem ' +
                'WHERE '+
                'Order.EffectiveDate >= LAST_N_MONTHS:24 order by Order.EffectiveDate DESC LIMIT 40000' ;
        }
        
        List<OrderItem> orderItems = Database.query(query);
        
        Map<Id, List<SAP_Package__c>> invoiceMap = new Map<Id, List<SAP_Package__c>>();
        Map<Id, List<OrderLine_Status__c>> statusMap = new Map<Id, List<OrderLine_Status__c>>();
        for (OrderItem item : orderItems) {
            invoiceMap.put(item.Id, new List<SAP_Package__c>());
            statusMap.put(item.Id, new List<OrderLine_Status__c>());
        }
        List<SAP_Package__c> invoices = [SELECT Id, Invoice_Number__c,Delivery_Date__c,carrier_name__c,Tracking_Number__c,Parcel_ID_Number__c,Signature__c, OrderItemId__c FROM SAP_Package__c WHERE OrderItemId__c IN :invoiceMap.keySet()];
        List<OrderLine_Status__c> statuses = [SELECT Id,LineItem_Status_Description__c, LineItem_Status_Reason_Description__c, OrderItemId__c FROM OrderLine_Status__c WHERE OrderItemId__c IN :statusMap.keySet()];
        system.debug('Statuses fetched: ' + statuses);
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
        for (OrderItem item : orderItems) {
            List<SAP_Package__c> relatedInvoices = invoiceMap.get(item.Id);
            List<OrderLine_Status__c> relatedStatuses = statusMap.get(item.Id);
            orderItemWrappers.add(new OrderItemWrapper1(item, relatedInvoices, relatedStatuses));
        }
        system.debug('***getCpuTime()***'+Limits.getCpuTime());
        return orderItemWrappers;
    }
}