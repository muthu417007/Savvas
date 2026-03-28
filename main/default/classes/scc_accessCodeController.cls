/*
Apex Class:scc_accessCodeController
Author: CTS (Sanika)
Created Date: 16/07/2024
Reason:
Modified Date:
*/
public without sharing class scc_accessCodeController {
    /**
    *  Description: This method gets user type of current user
    *  @param : none
    *  @return : String .
    */
    @AuraEnabled(cacheable=true)
    public static String getUserType() {
        User currentUser = [SELECT Id, Profile.Name, IsEmployee__c, Contact.AccountID FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        
        Boolean isInternalUser = currentUser.IsEmployee__c;
        Boolean isExternalUser = currentUser.Profile.Name == scc_constantHelper.SAVVAS_EXTERNAL_USERS_BASE_PROFILE; 
        
        Map<String, Object> result = new Map<String, Object>();
        result.put('isInternal', isInternalUser);
        result.put('accountId', currentUser.Contact.AccountID);
        
        return JSON.serialize(result);
    }
    /**
    *  Description: This method search for orders
    *  @param : String, String, String
    *  @return : List .
    */
    @AuraEnabled(cacheable=true)
    public static List<Order> searchOrders(String poNumber, String orderNumber, String isbn) {
        String baseQuery = 'SELECT Id, OrderNumber, BillingAddress, CreatedDate, EffectiveDate, Order_Total_Units__c, PoNumber__c, SAP_BillTo__c, SAP_Document_Number__c, SAP_Order_Method__c, SAP_Shipto__c, ShippingAddress, Total_Items__c ' +
            'FROM Order ' +
            'WHERE Id IN (SELECT Order__c FROM EAccess_List__c WHERE Order__c != null';
        
        User currentUser = [SELECT Id, Profile.Name, IsEmployee__c, Contact.AccountID FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        Boolean isExternalUser = currentUser.Profile.Name == scc_constantHelper.SAVVAS_EXTERNAL_USERS_BASE_PROFILE; 
        
        List<String> filters = new List<String>();
        
        if (isExternalUser) {
            filters.add('AccountId = \'' + String.escapeSingleQuotes(currentUser.Contact.AccountID) + '\'');
        }
        
        if (!String.isBlank(poNumber)) {
            filters.add('PoNumber__c = \'' + String.escapeSingleQuotes(poNumber) + '\'');
        }
        
        if (!String.isBlank(orderNumber)) {
            filters.add('SAP_Document_Number__c = \'' + String.escapeSingleQuotes(orderNumber) + '\'');
        }
        
        if (!String.isBlank(isbn)) {
            baseQuery += ' AND ProductId__r.ProductCode = \'' + String.escapeSingleQuotes(isbn) + '\'';
        }
        
        baseQuery += ')';
        
        if (!filters.isEmpty()) {
            baseQuery += ' AND ' + String.join(filters, ' AND ');
        }
        List<Order> orders = Database.query(baseQuery);
        return orders; 
    }
    
    /**
    *  Description: This method order related records from EAccess_List__c
    *  @param : String, String, String
    *  @return : List .
    */
    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getRelatedRecords(String orderId, String poNumber, String orderNumber, String isbn) {        
        
        String baseQuery = 'SELECT Id, EAccess_Code__c, ProductId__r.ProductCode, ProductId__r.Description, ' +
            'Order__r.Customer_Email__c, Order__r.EffectiveDate, Order__r.PoNumber__c, Order__r.SAP_Document_Number__c ' +
            'FROM EAccess_List__c ' +
            'WHERE Order__c = :orderId';
        
        List<String> filters = new List<String>();
        
        if (!String.isBlank(poNumber)) {
            filters.add('Order__r.PoNumber__c = \'' + String.escapeSingleQuotes(poNumber) + '\'');
        }
        
        if (!String.isBlank(orderNumber)) {
            filters.add('Order__r.SAP_Document_Number__c = \'' + String.escapeSingleQuotes(orderNumber) + '\'');
        }
        
        if (!String.isBlank(isbn)) {
            filters.add('ProductId__r.ProductCode = \'' + String.escapeSingleQuotes(isbn) + '\'');
        }
        
        if (!filters.isEmpty()) {
            baseQuery += ' AND ' + String.join(filters, ' AND ');
        }
        
        List<EAccess_List__c> eAccessList = Database.query(baseQuery);        
        
        Set<String> productCodes = new Set<String>();
        for (EAccess_List__c eAccess : eAccessList) {
            if (eAccess.ProductId__r.ProductCode != null) {
                productCodes.add(eAccess.ProductId__r.ProductCode);
            }
        }
        
        Map<String, Decimal> redemptionCounts = new Map<String, Decimal>();
        if (!productCodes.isEmpty()) {
            List<EAccess_Redemption__c> redemptions = [
                SELECT ProductCode__c, No_Of_Redemptions__c 
                FROM EAccess_Redemption__c 
                WHERE ProductCode__c IN :productCodes
            ];
            for (EAccess_Redemption__c redemption : redemptions) {
                redemptionCounts.put(redemption.ProductCode__c, redemption.No_Of_Redemptions__c);
            }
        }
        
        List<Map<String, Object>> resultList = new List<Map<String, Object>>();
        for (EAccess_List__c eAccess : eAccessList) {
            Map<String, Object> recordMap = new Map<String, Object>();
            recordMap.put('Id', eAccess.Id);
            recordMap.put('EAccess_Code__c', eAccess.EAccess_Code__c);
            recordMap.put('ProductCode__c', eAccess.ProductId__r.ProductCode);
            recordMap.put('Customer_Email__c', eAccess.Order__r.Customer_Email__c);
            recordMap.put('EffectiveDate', eAccess.Order__r.EffectiveDate);
            recordMap.put('PoNumber__c', eAccess.Order__r.PoNumber__c);
            recordMap.put('SAP_Document_Number__c', eAccess.Order__r.SAP_Document_Number__c);
            recordMap.put('Title_Description__c', eAccess.ProductId__r.Description);                        
            recordMap.put('No_Of_Redemptions__c', redemptionCounts.get(eAccess.ProductId__r.ProductCode));            
            resultList.add(recordMap);
        }
        return resultList;
    }
}