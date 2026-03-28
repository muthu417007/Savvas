public with sharing class ratCatalogSearchResults {

   /* public class ProductWrapper {
        @AuraEnabled public String productId;
        @AuraEnabled public String ISBN;
        @AuraEnabled public Boolean showISBN13Field;
        @AuraEnabled public String Title_Description;
        @AuraEnabled public String Type;
        @AuraEnabled public String Grade_Level;
        @AuraEnabled public String Copyright;
        @AuraEnabled public String Status;
        @AuraEnabled public Decimal Price;
    }

    @AuraEnabled(cacheable=true)
    public static List<ProductWrapper> searchProducts(String titleKeyword) {
        List<ProductWrapper> productData = new List<ProductWrapper>();
        Boolean SapCheck = true;
        String query = 'SELECT Id, ISBN10__c, ISBN13__c, Description, Product_Sub_Type__c, Grade_Level__c, ';
        query += 'Copyright_Year__c, Product_Status__c, Net_Price__c ';
        query += 'FROM Product2 ';
        query += 'WHERE Description LIKE \'%' + titleKeyword + '%\' ';
        System.debug('query' +titleKeyword);
        System.debug('query' +query);
        // Additional filter for Material_Type_ID__c
        Set<String> materialTypes = new Set<String>{'ZSBN', 'ZKPK', 'ZNVE', 'ZNMR'};
        query += 'AND Material_Type_ID__c IN :materialTypes ';
        query += ' AND SAP_A_Check__c = :SapCheck ';
        Integer limitLeft = Limits.getLimitQueryRows() - Limits.getQueryRows();
        query += 'LIMIT :limitLeft';
        System.debug('query' +query);
        List<Product2> products = Database.query(query);

        for (Product2 prod : products) {
            ProductWrapper wrapper = new ProductWrapper();
            wrapper.productId = prod.Id;
            wrapper.ISBN = prod.ISBN13__c != null ? prod.ISBN13__c : prod.ISBN10__c;
            wrapper.showISBN13Field = prod.ISBN13__c != null;
            wrapper.Title_Description = prod.Description;
            wrapper.Type = prod.Product_Sub_Type__c;
            wrapper.Grade_Level = prod.Grade_Level__c;
            wrapper.Copyright = prod.Copyright_Year__c;
            wrapper.Status = prod.Product_Status__c;
            wrapper.Price = prod.Net_Price__c;
            productData.add(wrapper);
        }

        return productData;
    }*/
}