/***************************************************************************************
 * @Class Name: SCC_PlaceOrderMultiISBN_SearchController
 * @Description: Controller for searching products based on multiple ISBN's.
 * @Created By: Sudha Rani Pathivada
 * @Created On: 05/10/2024
 ****************************************************************************************
 * Modification Log:
 * -------------------------------------------------------------------------------------
 * Developer        Date            Description
 * -------------------------------------------------------------------------------------
 * Sudha Rani       05/10/2024      Initial creation
 ***************************************************************************************/
public without sharing class scc_PlaceOrderMultiISBN_SearchController {
    /***************************************************************************************
     * @Method: populateSearchResults
     * @Description: Retrieves a list of products based on the provided list of ISBNs.
     * @param recordIds - List of ISBNs to search for.
     * @return List of ProductWrapper objects containing product details.
     ****************************************************************************************/
    @AuraEnabled(cacheable=true)
    public static List<ProductWrapper> populateSearchResults(List<String> recordIds, Boolean activeProducts) {
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
        system.debug('paddedvalue'+paddedRecordIds);
        try {
            Map<String, Product2> productMap = new Map<String, Product2>();
            
            // Query products based on ISBNs
            String query = 'SELECT Id, ISBN13__c, ISBN10__c, Material_Type__c, Product_Sub_Type__c, Description, ' +
                      'Grade_Level__c, Copyright_Year__c, Product_Status__c, Net_Price__c, Sales_Restriction_Code__c,Rights_Restriction_Code__c, IsActive, SAP_C__c, IsDuplicate__c,Product_Status_ID__c, ' +
                      'Program_Series__c '+
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
            
            for (Product2 prod : products) {for (ProductWrapper wrapper : searchResults) {wrapper.productId = wrapper.product.Id;}
              
                    
                
                system.debug('dEbug for query2');
                /*String ISBN = '';
                if (recordIds.contains(prod.ISBN13__c) && recordIds.contains(prod.ISBN10__c)) {
                    
                 ISBN = (!String.isEmpty(prod.ISBN13__c)) ? prod.ISBN13__c : prod.ISBN10__c;

                } else if (recordIds.contains(prod.ISBN10__c)) {
                    ISBN = prod.ISBN10__c;
                } else if (recordIds.contains(prod.ISBN13__c)) {
                    ISBN = prod.ISBN13__c;
                } */
               /* String ISBN = '';
                if (paddedRecordIds.contains(prod.ISBN13__c) && paddedRecordIds.contains(prod.ISBN10__c)) {
                    
                 ISBN = (!String.isEmpty(prod.ISBN13__c)) ? prod.ISBN13__c : prod.ISBN10__c;

                } else if (paddedRecordIds.contains(prod.ISBN10__c)) {
                    ISBN = prod.ISBN10__c;
                } else if (paddedRecordIds.contains(prod.ISBN13__c)) {
                    ISBN = prod.ISBN13__c;
                } 
                if (!String.isEmpty(ISBN)) {
                    searchResults.add(new ProductWrapper(prod,  ISBN, prod.Id));
                }
        }*/
/*String ISBN = (paddedRecordIds.contains(prod.ISBN13__c) && paddedRecordIds.contains(prod.ISBN10__c)) ? prod.ISBN13__c : (String.isEmpty(prod.ISBN13__c) ? prod.ISBN10__c : prod.ISBN13__c);

    if (!String.isEmpty(ISBN)) { searchResults.add(new ProductWrapper(prod, ISBN, prod.Id));}*/
   	String ISBN = paddedRecordIds.contains(prod.ISBN13__c) ? prod.ISBN13__c : (paddedRecordIds.contains(prod.ISBN10__c) ? prod.ISBN10__c : '');

	if (!String.isEmpty(ISBN)) searchResults.add(new ProductWrapper(prod, ISBN, prod.Id));
   

            }
        } catch (QueryException qe) {
         
            System.debug('Query exception occurred: ' + qe.getMessage()); } catch (Exception e) {
     
     
            System.debug('An error occurred: ' + e.getMessage());
        }
        system.debug('search'+searchResults);
        return searchResults;
    }

    /***************************************************************************************
     * @Class: ProductWrapper
     * @Description: Wrapper class to hold product details for Lwc component
     ****************************************************************************************/
    public class ProductWrapper {
        @AuraEnabled public Product2 product { get; set; }
        @AuraEnabled public String Price { get; set; }
        @AuraEnabled public String ISBN { get; set; }
        @AuraEnabled public Id productId { get; set; }       
        @AuraEnabled public String Title_Description { get; set; }
        @AuraEnabled public String Grade_Level { get; set; }
        @AuraEnabled public String Type { get; set; }
        @AuraEnabled public String Status { get; set; }
        @AuraEnabled public String Copyright { get; set; }
        @AuraEnabled public String SalesRestriction{ get; set; }
        @AuraEnabled public String RightsRestriction{ get; set; }
        @AuraEnabled public Boolean IsActive{ get; set; }
        @AuraEnabled public String Product_Status_ID { get; set; }
        @AuraEnabled public String ProgramSeries;

        // Constructor
        public ProductWrapper(Product2 product,  String ISBN, Id productId) {
            this.product = product;
            this.Price = 'NA';
            this.ISBN = ISBN;
            this.productId = product.Id;
            this.Title_Description = product.Description;
            this.Grade_Level = product.Grade_Level__c;
            this.Type = product.Product_Sub_Type__c;
            this.Status = product.Product_Status__c;
            this.Copyright = product.Copyright_Year__c;
            this.SalesRestriction = product.Sales_Restriction_Code__c;
            this.RightsRestriction = product.Rights_Restriction_Code__c;
            this.IsActive = product.SAP_C__c;
            this.Product_Status_ID = product.Product_Status_ID__c;
            this.ProgramSeries = product.Program_Series__c;
        }
    }
    public static String padZerosLeft(String input, Integer length) {
        String paddedValue = input;
        while (paddedValue.length() < length) {
            paddedValue = '0' + paddedValue;
        }
        return paddedValue;
    }
}