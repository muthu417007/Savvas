/*
* @Class Name: scc_productCriteriaSearch
* @Description: Controller for searching products based on ISBN, title keyword, and active status.
* @Created By: Sanika Sol
* @Created On: 17/04/2024
* **************************************************************************************
* Modification Log:
* -------------------------------------------------------------------------------------
* Developer        Date            Description
* -------------------------------------------------------------------------------------
Description: 
This class provides backend logic for searching products based on various criteria such as ISBN, title keyword, and active status.

Methods:
- searchProducts(String isbnValue, String selectedDiscipline, String titlekeyword, Boolean activeProducts): 
    Searches for products based on the specified criteria.
    - isbnValue (String): ISBN value to search for.
    - selectedDiscipline (String): Discipline to filter products by.
    - titlekeyword (String): Keyword to search for in the product description.
    - activeProducts (Boolean): Flag to indicate whether to include active products only.
    Returns: List<ProductWrapper> - List of product details wrapped in ProductWrapper objects.

Inner Class:
- ProductWrapper: Wrapper class for product data returned by searchProducts().
    - productId (String): ID of the product.
    - ISBN (String): ISBN of the product.
    - showISBN13Field (Boolean): Indicates whether to display the ISBN13 field.
    - Title_Description (String): Description of the product.
    - Type (String): Subtype of the product.
    - Grade_Level (String): Grade level associated with the product.
    - Copyright (String): Copyright year.
    - Status (String): Status of the product.
    - Price (String): Net price of the product (if applicable).
    - accountId (Id): Account ID of the user.
    - IsActive (Boolean): Active status of the product.

Methods:
- padZerosLeft(String input, Integer length): 
    Pads zeros to the left of a string to reach the specified length.
    - input (String): Input string to pad.
    - length (Integer): Desired length of the padded string.
    Returns: String - Padded string.
*/
public with sharing class scc_productCriteriaSearch {
    @AuraEnabled(cacheable=true)
    public static List<ProductWrapper> searchProducts(String isbnValue, String selectedDiscipline, String titlekeyword, Boolean activeProducts) {
        List<ProductWrapper> productData = new List<ProductWrapper>();

        try {
            // Get current user's account info
            User currentUser = [SELECT Contact.AccountId FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];

            // Prepare the ISBN search value
            String searchISBN = String.isNotBlank(isbnValue)
                ? (isbnValue.length() <= 10 ? padZerosLeft(isbnValue, 10) 
                   : (isbnValue.length() <= 13 ? padZerosLeft(isbnValue, 13) : null)) 
                : null;

            // Build the SOQL query
            String query = 'SELECT Id, ISBN10__c, ISBN13__c, Description, Product_Sub_Type__c, Grade_Level__c, ' +
                           'Copyright_Year__c, Product_Status__c, IsActive, Program_Series__c  FROM Product2 WHERE ';

            // Apply filters based on search criteria
            if (searchISBN != null) {
                query += '(ISBN13__c = :searchISBN OR ISBN10__c = :searchISBN) AND ';
            } else {
                if (String.isNotBlank(selectedDiscipline)) {
                    query += 'Discipline__c = :selectedDiscipline AND ';
                }
                if (String.isNotBlank(titlekeyword)) {
                    String searchTitleKeyword = '%' + titlekeyword + '%';
                    query += 'Description LIKE :searchTitleKeyword AND ';
                }
            }

            // Filter by active products
            if (activeProducts) {
                query += 'SAP_C__c = true AND ';
            }

            query += 'IsDuplicate__c = false AND ';

            // Filter by material types
            Set<String> materialTypes = new Set<String>{'ZSBN', 'ZKPK', 'ZNVE', 'ZNMR'};
            query += 'Material_Type_ID__c IN :materialTypes ';

            // Limit the number of records returned
            Integer limitLeft = Limits.getLimitQueryRows() - Limits.getQueryRows();
            query += 'LIMIT :limitLeft';

            System.debug('Search Query: ' + query);

            // Execute the query
            List<Product2> products = Database.query(query);
            System.debug('Number of Products found: ' + products.size());

            // Wrap the product data in ProductWrapper objects
            for (Product2 prod : products) {
                ProductWrapper wrapper = new ProductWrapper();
                wrapper.productId = prod.Id;

                // Set ISBN and determine whether to show ISBN13
                if (searchISBN != null) {
                    wrapper.ISBN = searchISBN;
                    wrapper.showISBN13Field = searchISBN.length() == 13;
                } else {
                    wrapper.ISBN = prod.ISBN13__c != null ? prod.ISBN13__c : prod.ISBN10__c;
                    wrapper.showISBN13Field = prod.ISBN13__c != null;
                }

                // Populate other fields
                wrapper.Title_Description = prod.Description;
                wrapper.Type = prod.Product_Sub_Type__c;
                wrapper.Grade_Level = prod.Grade_Level__c;
                wrapper.Copyright = prod.Copyright_Year__c;
                wrapper.Status = prod.Product_Status__c;
                wrapper.Price = 'NA';
                wrapper.accountId = currentUser.Contact.AccountId;
                wrapper.IsActive = prod.IsActive;
                wrapper.programSeries = prod.Program_Series__c;

                productData.add(wrapper);
            }

        } catch (Exception e) {
            System.debug('Exception occurred in searchProducts: ' + e.getMessage());
            System.debug('Stack trace: ' + e.getStackTraceString());
            throw new AuraHandledException('An error occurred while searching products: ' + e.getMessage());
        }

        return productData;
    }

    // Inner class to hold product data
    public class ProductWrapper {
        @AuraEnabled public String productId;
        @AuraEnabled public String ISBN;
        @AuraEnabled public Boolean showISBN13Field;
        @AuraEnabled public String Title_Description;
        @AuraEnabled public String Type;
        @AuraEnabled public String Grade_Level;
        @AuraEnabled public String Copyright;
        @AuraEnabled public String Status;
        @AuraEnabled public String Price;
        @AuraEnabled public Id accountId;
        @AuraEnabled public Boolean IsActive;
        @AuraEnabled public String programSeries;
    }

    // Pads zeros to the left of a string to reach the specified length
     public static String padZerosLeft(String input, Integer length) {
        while (input.length() < length) {
            input = '0' + input;
        }
        return input;
    }
}