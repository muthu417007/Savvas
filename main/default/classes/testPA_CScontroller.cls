public without sharing class testPA_CScontroller {
    
    @AuraEnabled(cacheable=true)
    public static List<ProductWrapper> searchProducts(String isbnValue, String selectedDiscipline, String titlekeyword, Boolean activeProducts) {
        List<ProductWrapper> productData = new List<ProductWrapper>();
        System.debug('isbnValue :: ' + isbnValue);
        Boolean SapCheck = true;
        String searchISBN = String.isNotBlank(isbnValue) ? (isbnValue.length() <= 10 ? padZerosLeft(isbnValue, 10) : (isbnValue.length() <= 13 ? padZerosLeft(isbnValue, 13) : null)) : null;
        System.debug('searchISBN :: ' + searchISBN);
        String query = 'SELECT Id, ISBN10__c, ISBN13__c, Description, Product_Sub_Type__c,  Grade_Level__c, Copyright_Year__c, Product_Status__c, Net_Price__c ';
        query += 'FROM Product2 ';
        query += 'WHERE ';
        if (searchISBN != null) {
            query += '(ISBN13__c = :searchISBN OR ISBN10__c = :searchISBN) AND ';
        }
        else {
            if (String.isNotBlank(selectedDiscipline)) {
            query += 'Discipline__c = :selectedDiscipline AND ';
            }
            if (String.isNotBlank(titlekeyword)) {
                query += 'Description LIKE \'%' + titlekeyword + '%\' AND ';
            }
        }
 
        query += 'IsActive = :activeProducts ';
        query += ' AND SAP_A_Check__c = :SapCheck';
        
        // Additional filter for Material_Type_ID__c
        Set<String> materialTypes = new Set<String>{'ZSBN', 'ZKPK', 'ZNVE', 'ZNMR'};
        query += ' AND Material_Type_ID__c IN :materialTypes';
        
        Integer limitLeft = Limits.getLimitQueryRows() - Limits.getQueryRows();
        // Add LIMIT to LIMIT the number of records returned
        query += ' LIMIT :limitLeft';
 
        System.debug('Search Query:' +query);
 
        List<Product2> products = Database.query(query);
 
        System.debug('Number of Products found:' +products.size());
 
        for (Product2 prod : products) {
            ProductWrapper wrapper = new ProductWrapper();
            wrapper.productId = prod.Id;
            wrapper.quantity = 0; // Set quantity to zero
            
            if (searchISBN != null && String.isNotBlank(searchISBN)) {
                wrapper.ISBN = searchISBN;
                wrapper.showISBN13Field = searchISBN.length() == 13;
            } else {
                wrapper.ISBN = prod.ISBN13__c != null ? prod.ISBN13__c : prod.ISBN10__c;
                wrapper.showISBN13Field = prod.ISBN13__c != null;
            }
 
            wrapper.Title_Description = prod.Description;
            wrapper.Type = prod.Product_Sub_Type__c;
            wrapper.Grade_Level = prod.Grade_Level__c;
            wrapper.Copyright = prod.Copyright_Year__c;
            wrapper.Status = prod.Product_Status__c;
            wrapper.Price = prod.Net_Price__c;
            productData.add(wrapper);
        }
 
        return productData;
    }
 
    public class ProductWrapper {
        @AuraEnabled public String productId;
        @AuraEnabled public String ISBN;
        @AuraEnabled public Boolean showISBN13Field;
        @AuraEnabled public String Title_Description;
        @AuraEnabled public String Type;
        @AuraEnabled public String Grade_Level;
        @AuraEnabled public String Copyright;
        @AuraEnabled public String Status;
        @AuraEnabled public Decimal Price;
        @AuraEnabled public Integer quantity; // New field for quantity
    }    
 
    private static String padZerosLeft(String input, Integer length) {
        String paddedValue = input;
        while (paddedValue.length() < length) {
            paddedValue = '0' + paddedValue;
        }
        return paddedValue;
    }
}