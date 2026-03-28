/***************************************************************************************
* @Class Name: scc_productQuickSearch_Controller
* @Description: Controller for searching products based on multiple ISBN's.
* @Created By: Sudha Rani Pathivada
* @Created On: 17/04/2024
* *************************************************************************************
* Modification Log:05/09/2024
* -------------------------------------------------------------------------------------
* Developer        Date            Description
* -------------------------------------------------------------------------------------
*/
public with sharing class scc_productQuickSearch_Controller {
    public class ProductWrapper {
        @AuraEnabled public Product2 product { get; set; }
        @AuraEnabled public String Price { get; set; } 
        @AuraEnabled public String ISBN { get; set; }
        @AuraEnabled public Id productId { get; set; }
        @AuraEnabled public String Title_Description { get; set; }
        @AuraEnabled public String Grade_Level { get; set; }
        @AuraEnabled public String Type { get; set; }
        @AuraEnabled public String Status { get; set; }
        @AuraEnabled public String Copyrightyear { get; set; }
        @AuraEnabled public String programSeries { get; set; }
        
        
        public ProductWrapper(Product2 product, String Price, String ISBN, Id productId) {//chnaged data type of price from decimal to string by Vaibhav for pricing connector
            this.product = product;
            this.Price = Price;
            this.ISBN = ISBN;
            this.productId = product.Id;
            this.Title_Description = product.Description;
            this.Grade_Level = product.Grade_Level__c;
            this.Type = product.Product_Sub_Type__c;
            this.Status = product.Product_Status__c;
            this.Copyrightyear = product.Copyright_Year__c;
            this.programSeries = product.Program_Series__c;
            
            
        }
    }
    @AuraEnabled(cacheable=true)
    public static List<ProductWrapper> searchRecords(List<String> recordIds, Boolean activeProducts) {
        /**********************************************************************************
* Method Name : searchRecords
* Description : Searches products based onbased on multiple ISBN's.
* Return Type : List<ProductWrapper>
**********************************************************************************/
        List<ProductWrapper> searchResults = new List<ProductWrapper>();        
        try {
            if (recordIds != null && recordIds.size() <= 25) {
                searchResults = populateSearchResults(recordIds, true, false, activeProducts);
            } else {
                Boolean isInternational = false; 
                Id userId = UserInfo.getUserId();
                Contact userContact = [SELECT AccountId, Account.Type FROM Contact WHERE Id IN (SELECT ContactId FROM User WHERE Id = :userId) LIMIT 1];
                if (userContact != null && userContact.AccountId != null) {
                    String accountType = userContact.Account.Type;
                    isInternational = isInternationalAccount(accountType);
                }
                searchResults = populateSearchResults(recordIds, false, isInternational, activeProducts);
            }
        } catch (Exception e) {
            // searchResults = new List<ProductWrapper>{new ProductWrapper(null, null, 'Error: ' + e.getMessage(), null)};
                System.debug('Error in searchRecords: ' + e.getMessage());
        }
        return searchResults;
    }    
    @AuraEnabled(cacheable=true)
    public static Boolean isInternationalAccount(String accountType) {
        /**********************************************************************************
* Method Name : isInternationalAccount
* Description : This method checks if the account is international.It takes an Account object as input and returns a boolean value            
* Return Type : List<ProductWrapper>
**********************************************************************************/
        if (accountType != null && (accountType.equalsIgnoreCase('International School') || accountType.equalsIgnoreCase('International Distributor'))) {
            return true;
        } else {
            return false;
        }
    }
    @AuraEnabled(cacheable=true)
    public static List<ProductWrapper> populateSearchResults(List<String> recordIds, Boolean considerCustomerPrice, Boolean isInternational, Boolean activeProducts) {
        /**********************************************************************************
* Method Name : populateSearchResults
* Description : This method queries the products based on certain criteria and returns a list of product wrappers.        
* Return Type : List<ProductWrapper>
**********************************************************************************/       
        List<ProductWrapper> searchResults = new List<ProductWrapper>(); 
        List<String> paddedRecordIds = new List<String>();
        for(String isbn : recordIds) {
            if(isbn.length() <= 10) {
                paddedRecordIds.add(padZerosLeft(isbn, 10));
            }
            if(isbn.length() <= 13) {
                paddedRecordIds.add(padZerosLeft(isbn, 13));
            }
        }
        try {
             String query = 'SELECT Id, ISBN13__c, ISBN10__c, Material_Type__c, Product_Sub_Type__c, Description, ' +
                      'Grade_Level__c, Copyright_Year__c, Product_Status__c, Net_Price__c, IsActive, SAP_C__c, IsDuplicate__c, ' +
						'Program_Series__c ' +                 	  
                      'FROM Product2 ' +
                      'WHERE IsDeleted = false ' +
                      'AND (ISBN13__c IN :paddedRecordIds OR ISBN10__c IN :paddedRecordIds) ' +
                      'AND Material_Type_ID__c IN (\'ZSBN\', \'ZKPK\', \'ZNVE\', \'ZNMR\') ' +
                      'AND IsDuplicate__c = false';

        // Add SAP_C__c filter if activeProducts is true
        if (activeProducts) {
            query += ' AND SAP_C__c = true';
        }

        List<Product2> products = Database.query(query);
            
            for (Product2 prod : products) {                
                String Price = 'NA';
                for (ProductWrapper wrapper : searchResults) {
                    wrapper.productId = wrapper.product.Id;
                }
                String ISBN = '';
                if (paddedRecordIds.contains(prod.ISBN13__c) && paddedRecordIds.contains(prod.ISBN10__c)) {
                    
                    ISBN = (!String.isEmpty(prod.ISBN13__c)) ? prod.ISBN13__c : prod.ISBN10__c;
                    
                } else if (paddedRecordIds.contains(prod.ISBN10__c)) {
                    ISBN = prod.ISBN10__c;
                } else if (paddedRecordIds.contains(prod.ISBN13__c)) {
                    ISBN = prod.ISBN13__c;
                } 
                
                if (!String.isEmpty(ISBN)) {
                    searchResults.add(new ProductWrapper(prod, Price, ISBN, prod.Id));
                }
            }
        } catch (Exception e) {
            searchResults = new List<ProductWrapper>{new ProductWrapper(null, null, 'Error: ' + e.getMessage(), null)};
                System.debug('Error in populateSearchResults: ' + e.getMessage());
        }
        
        return searchResults;
    }
    public static String padZerosLeft(String input, Integer length) {
        String paddedValue = input;
        while (paddedValue.length() < length) {
            paddedValue = '0' + paddedValue;
        }
        return paddedValue;
    } 
}