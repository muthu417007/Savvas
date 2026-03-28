/***************************************************************************************
* @Class Name: scc_placeOrderISBNSearch_Controller
* @Description: Controller for searching products based on ISBN, title keyword, and active status.
* @Created By: Sanika Sol
* @Created On: 17/04/2024
* **************************************************************************************
* Modification Log:
* -------------------------------------------------------------------------------------
* Developer        Date            Description
* -------------------------------------------------------------------------------------
*/

public without sharing class scc_placeOrderISBNSearch_Controller {
    
    /**********************************************************************************
    * Method Name : searchProducts
    * Description : Searches products based on ISBN, title keyword, and active status.
    * Return Type : List<ProductWrapper>
    **********************************************************************************/
    @AuraEnabled(cacheable=true)
    public static List<ProductWrapper> searchProducts(String isbnValue, String selectedDiscipline, String titlekeyword, Boolean activeProducts) {
        List<ProductWrapper> productData = new List<ProductWrapper>();
        
        try {
            String searchISBN = String.isNotBlank(isbnValue) ? 
                                (isbnValue.length() <= 10 ? padZerosLeft(isbnValue, 10) : 
                                (isbnValue.length() <= 13 ? padZerosLeft(isbnValue, 13) : null)) : null;
            system.debug('***getCpuTime()***'+Limits.getCpuTime());
            // Build SOQL query based on input parameters
            String query = 'SELECT Id, ISBN10__c, ISBN13__c, Description, Sales_Restriction_Code__c, Rights_Restriction_Code__c, ' +
                           'Product_Sub_Type__c, Grade_Level__c, Copyright_Year__c, Product_Status__c, Net_Price__c, IsActive, SAP_C__c, ' +
                           'IsDuplicate__c, Program_Series__c,Product_Status_ID__c FROM Product2 WHERE ';
            
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
            
            if (activeProducts) {
                query += 'SAP_C__c = true AND ';
            }
            query += 'IsDuplicate__c = false AND ';
            
            Set<String> materialTypes = new Set<String>{'ZSBN', 'ZKPK', 'ZNVE', 'ZNMR'};
            query += 'Material_Type_ID__c IN :materialTypes ';
            
            Integer limitLeft = Limits.getLimitQueryRows() - Limits.getQueryRows();
            query += 'LIMIT :limitLeft';
            
            List<Product2> products = Database.query(query);
            for (Product2 prod : products) {
                ProductWrapper wrapper = new ProductWrapper();
                wrapper.productId = prod.Id;
                
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
                wrapper.SalesRestriction = prod.Sales_Restriction_Code__c;
                wrapper.RightsRestriction = prod.Rights_Restriction_Code__c;
                wrapper.IsActive = prod.SAP_C__c;
                wrapper.Price = 'NA';
                wrapper.ProgramSeries = prod.Program_Series__c;
                wrapper.disableCheckbox = prod.Product_Status__c == 'OUT OF PRINT' || 
                                          prod.Product_Status__c == 'NOT YET PUBLISHED' || 
                                          prod.Product_Status__c == 'Not Yet Published – No Due Date Available'; 
                wrapper.Product_Status_ID = prod.Product_Status_ID__c;
                productData.add(wrapper);
            }
            system.debug('***getCpuTime()***'+Limits.getCpuTime());
        } catch (Exception e) {
            System.debug('Exception occurred: ' + e.getMessage());
        }
        System.debug('productData: ' + productData);
        return productData;
    }

    /**********************************************************************************
    * Method Name : IsEusageOnly
    * Description : Checks if the current user is allowed only E-Usage products.
    * Return Type : Boolean
    **********************************************************************************/
    @AuraEnabled(cacheable=true)
    public static Boolean IsEusageOnly() {
        Id userId = UserInfo.getUserId(); 
        User userdata = [SELECT IsEusageOnly__c FROM User WHERE Id = :userId];
        System.debug('User E-Usage Only: ' + userdata.IsEusageOnly__c);
        return userdata.IsEusageOnly__c;          
    }
    
    // Inner class to wrap Product2 object fields
    public class ProductWrapper {
        @AuraEnabled public String productId;
        @AuraEnabled public String ISBN;
        @AuraEnabled public Boolean showISBN13Field;
        @AuraEnabled public String Title_Description;
        @AuraEnabled public String Type;
        @AuraEnabled public String Grade_Level;
        @AuraEnabled public String Copyright;
        @AuraEnabled public String Status;
        @AuraEnabled public String SalesRestriction;
        @AuraEnabled public String RightsRestriction;
        @AuraEnabled public String Price;
        @AuraEnabled public Boolean disableCheckbox;
        @AuraEnabled public Boolean IsActive;
        @AuraEnabled public String ProgramSeries;
        @AuraEnabled public String Product_Status_ID;
    }
    
    // Method to pad zeros to the left of a string
    public static String padZerosLeft(String input, Integer length) {
        while (input.length() < length) {
            input = '0' + input;
        }
        return input;
    }
}