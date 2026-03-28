public without sharing class testAccessSearch {

    @AuraEnabled(cacheable=true)
    public static String getUserType() {
        User currentUser = [SELECT Id, Profile.Name, IsEmployee__c, Contact.AccountID FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];

        Boolean isInternalUser = currentUser.IsEmployee__c;
        Boolean isExternalUser = currentUser.Profile.Name == 'Savvas External Users Base Profile'; 

        Map<String, Object> result = new Map<String, Object>();
        result.put('isInternal', isInternalUser);
        result.put('accountId', currentUser.Contact.AccountID);

        return JSON.serialize(result);
    }

    @AuraEnabled(cacheable=true)
    public static List<Order> searchOrders(String poNumber, String orderNumber, String isbn) {
        String baseQuery = 'SELECT Id, OrderNumber, BillingAddress, CreatedDate, Order_Total_Units__c, PO_Number__c, SAP_BillTo__c, SAP_Document_Number__c, SAP_Order_Method__c, SAP_Shipto__c, ShippingAddress, Total_Items__c ' +
                           'FROM Order ' +
                           'WHERE Id IN (SELECT OrderId FROM OrderItem WHERE Product2.Product_Type_ID__c IN (\'OLS\', \'AMD\', \'BOL\', \'SUL\', \'SEM\', \'SER\', \'DSB\', \'OLC\'))';

        User currentUser = [SELECT Id, Profile.Name, IsEmployee__c, Contact.AccountID FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];

        Boolean isInternalUser = currentUser.IsEmployee__c;
        Boolean isExternalUser = currentUser.Profile.Name == 'Savvas External Users Base Profile'; 

        List<String> filters = new List<String>();

        if (isInternalUser) {
            // Internal users see all orders
        } else if (isExternalUser) {
            filters.add('AccountId = :accountId');
        } else {
            // Other user types can have additional or default filters
        }

        if (!String.isBlank(poNumber)) {
            filters.add('PO_Number__c LIKE :poPattern');
        }

        if (!String.isBlank(orderNumber)) {
            filters.add('SAP_Document_Number__c LIKE :orderPattern');
        }

        if (!String.isBlank(isbn)) {
            filters.add('Id IN (SELECT OrderId FROM OrderItem WHERE Product2.ProductCode LIKE :isbnPattern)');
        }

        if (!filters.isEmpty()) {
            baseQuery += ' AND ' + String.join(filters, ' AND ');
        }

        baseQuery += ' ORDER BY CreatedDate DESC LIMIT 1000';

        System.debug('Generated Query: ' + baseQuery);

        // Prepare bind variables
        String poPattern = '%' + poNumber + '%';
        String orderPattern = '%' + orderNumber + '%';
        String isbnPattern = '%' + isbn + '%';
        Id accountId = currentUser.Contact.AccountID;

        List<Order> orders = Database.query(baseQuery);
        System.debug('Search Orders Result: ' + orders);

        return orders; 
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getRelatedRecords(String orderId) {
        // Query EAccess_List__c records with their related Order and Product2 details
        List<EAccess_List__c> eAccessList = [
            SELECT Id, EAccess_Code__c, ProductId__r.ProductCode, ProductId__r.Description, 
                   Order__r.Customer_Email__c, Order__r.EffectiveDate, Order__r.PO_Number__c, Order__r.SAP_Document_Number__c
            FROM EAccess_List__c 
            WHERE Order__c = :orderId
        ];
    
        // Extract Product Codes for subsequent queries
        Set<String> productCodes = new Set<String>();
        for (EAccess_List__c eAccess : eAccessList) {
            if (eAccess.ProductId__r.ProductCode != null) {
                productCodes.add(eAccess.ProductId__r.ProductCode);
            }
        }
    
        // Query for EAccess_Redemption__c records
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
    
        // Prepare the final result list
        List<Map<String, Object>> resultList = new List<Map<String, Object>>();
        for (EAccess_List__c eAccess : eAccessList) {
            Map<String, Object> recordMap = new Map<String, Object>();
            recordMap.put('Id', eAccess.Id);
            recordMap.put('EAccess_Code__c', eAccess.EAccess_Code__c);
            recordMap.put('ProductCode__c', eAccess.ProductId__r.ProductCode);
            recordMap.put('Customer_Email__c', eAccess.Order__r.Customer_Email__c);
            recordMap.put('EffectiveDate', eAccess.Order__r.EffectiveDate);
            recordMap.put('PO_Number__c', eAccess.Order__r.PO_Number__c);
            recordMap.put('SAP_Document_Number__c', eAccess.Order__r.SAP_Document_Number__c);
            recordMap.put('Title_Description__c', eAccess.ProductId__r.Description);
    
            // Fetch redemptions
            recordMap.put('No_Of_Redemptions__c', redemptionCounts.get(eAccess.ProductId__r.ProductCode));
    
            resultList.add(recordMap);
        }
    
        return resultList;
    }    
}