public class test_placecontroller {
    /*
        Apex Class:scc_productQuickSearch_Controller
        Author: CTS (Sudharani Pathivada)
        Created Date: 15/04/2024
        Reason: This Controller referered in LWC "scc_productQuickSearch_Controller" for the savvas LWC component.
        Description: From price &availaility we can see Multi ISBN tab, on clicks  of tab user can search with multi Isbn and will get the search resuts
        Modified Date: 16/04/2024
        */

   
         
    /*
        searchRecords Logic start
    *  Description: this metod checks records size ,if it is morethan 25 it will check account status of ther user based on that price will be added.
    *  @name: searchRecords
    *  @param:List<String> recordIds
    *  @return: list of strigs
     
    */
        
  // the actual customer price will come from sap , currently hardcoded will work on futuer sprint 
        
        @AuraEnabled(cacheable=true)
        public static List<Product2Wrapper> searchRecords(List<String> recordIds) {
            List<Product2Wrapper> searchResults = new List<Product2Wrapper>();
            // System.debug('Entering searchRecords method with recordIds: ' + recordIds);
            
           if (recordIds != null && recordIds.size() <= 25) {
                searchResults = populateSearchResults(recordIds, true, false);
            } else {
                Boolean isInternational = false; 
                Id userId = UserInfo.getUserId();
                Contact userContact = [SELECT AccountId, Account.Type  FROM Contact WHERE Id IN (SELECT ContactId FROM User WHERE Id = :userId) LIMIT 1];
                if (userContact != null && userContact.AccountId != null) {
                    String accountType = userContact.Account.Type ;
                    isInternational = isInternationalAccount(accountType);
                }
                searchResults = populateSearchResults(recordIds, false, isInternational);
            }
            return searchResults;
        }
    /*  isInternationalAccount Logic start
       
    *  Description: this method checks account status     
    *  @name: isInternationalAccount
    *  @param: string accountZipCode
    *  @return:  string
     
    */
        
  /* ## waiting  for update from savvas to checks account status  cuurently hardcoded */
       
          @AuraEnabled(cacheable=true)
        public static Boolean isInternationalAccount(String accountType) {
           /* Set<String> internationalZipCodes = new Set<String>{'94100', '67890'}; 
            return internationalZipCodes.contains(accountZipCode);*/
            if (accountType != null && (accountType.equalsIgnoreCase('International School') || accountType.equalsIgnoreCase('International Distributor'))) {
        return true; // Account is international
    } else {
        return false; // Account is not international
    }
        }
        
    /*  populateSearchResults Logic start
       
    *  Description: this metod  queries based on searched ISBNs added by user  reteruning the search result including price and status of account
                    if it is morethan 25 it will check account status of ther user based on that price will be added       
    *  @name: searchRecords
    *  @param:List<String> recordIds, Boolean considerCustomerPrice, Boolean isInternational
    *  @return: list of strigs
     
    */
          @AuraEnabled(cacheable=true)
        public static List<Product2Wrapper> populateSearchResults(List<String> recordIds, Boolean considerCustomerPrice, Boolean isInternational) {
            List<Product2Wrapper> searchResults = new List<Product2Wrapper>();
            
            List<Product2> products = [SELECT Id, ISBN13__c, ISBN10__c, Material_Type__c,Product_Sub_Type__c, Description, Grade_Level__c, 
                                        Copyright_Year__c, Product_Status__c, Net_Price__c, List_Price__c, Customer_Price__c
                                        FROM Product2
                                        WHERE IsDeleted = false
                                        AND (ISBN13__c IN :recordIds OR ISBN10__c IN :recordIds)
                                        AND Product_Status__c IN ('OUT OF PRINT', 'IN PRINT')
                                        AND Material_Type_ID__c IN ('ZSBN', 'ZKPK', 'ZNVE', 'ZNMR')];
            
            Map<Id, Decimal> netPriceMap = new Map<Id, Decimal>();
            for (Product2 prod : products) {
                if (!netPriceMap.containsKey(prod.Id)) {
                    netPriceMap.put(prod.Id, prod.Net_Price__c);
                }
            }
            for (Id prodId : netPriceMap.keySet()) {
                
               Decimal netPrice = netPriceMap.get(prodId);
               /* Decimal listPrice = netPrice * 1.33; 
                netPriceMap.put(prodId, listPrice);*/
                if (netPrice != null) { // Check if netPrice is not null
            Decimal listPrice = netPrice * 1.33; 
            netPriceMap.put(prodId, listPrice);
        }
            }
            
            for (Product2 prod : products) {
                Decimal price = null;
                if (considerCustomerPrice) {
                    price = null;
                } else {
                    if (isInternational) {
                        price = netPriceMap.get(prod.Id);
                    } else {
                        price = prod.Net_Price__c;
                    }
                }
                for (Product2Wrapper wrapper : searchResults) {
                wrapper.productId = wrapper.product.Id;
            }
    
               /* // Determine which ISBN value to display based on the user's search input
                String isbnToDisplay = '';
            if (recordIds.contains(prod.ISBN13__c)) {
                //  system.debug('enter65');
                isbnToDisplay = prod.ISBN13__c;
            } else if (recordIds.contains(prod.ISBN10__c)) {
                // system.debug('enter68');
                isbnToDisplay = prod.ISBN10__c;
            } else {
                // Both ISBN 10 and ISBN 13 are not in the search IDs, so use the non-null ISBN value if available
                if (prod.ISBN13__c != null) {
                     //system.debug('enter70');
                    isbnToDisplay = prod.ISBN10__c;
                } else {
                    // system.debug('enter74');
                    isbnToDisplay = prod.ISBN13__c;
                }
            }
            
           searchResults.add(new Product2Wrapper(prod, price, isbnToDisplay, prod.Id));
        }*/
             // Determine which ISBN value to display based on the user's search input
            String isbnToDisplay = '';
            if (recordIds.contains(prod.ISBN13__c) && recordIds.contains(prod.ISBN10__c)) {
                if (recordIds.contains(prod.ISBN13__c)) {
                    isbnToDisplay = prod.ISBN13__c;
                } else {
                    isbnToDisplay = prod.ISBN10__c;
                }
            } else if (recordIds.contains(prod.ISBN10__c)) {
                isbnToDisplay = prod.ISBN10__c;
            } else if (recordIds.contains(prod.ISBN13__c)) {
                isbnToDisplay = prod.ISBN13__c;
            } 
    
            if (!String.isEmpty(isbnToDisplay)) {
                searchResults.add(new Product2Wrapper(prod, price, isbnToDisplay, prod.Id));
            }
        }
    
    
    
            system.debug(searchResults);
            return searchResults;
            
        }
        
    /* 
       
    *  Description:  Product2Wrapper class for maps variables from the product object to the returned result including these variables in the output  
    *  @name: Product2Wrapper
    *  
        Fields:
            - productId (String): ID of the product.
            - product (object):object
            - isbnToDisplay (string): whether to display the ISBN13  or ISBN10 feild 
            - Price (Decimal): basis of account status and records size price will  be addd 

     
    */
        public class Product2Wrapper {
            @AuraEnabled public Product2 product { get; set; }
            @AuraEnabled public Decimal price { get; set; }
            @AuraEnabled public String isbnToDisplay { get; set; }
             @AuraEnabled public Id productId { get; set; }
            public Product2Wrapper(Product2 product, Decimal price, String isbnToDisplay, Id productId) {
                this.product = product;
                this.price = price;
                this.isbnToDisplay = isbnToDisplay;
                 //this.productId = product.Id;
            }
        }
    }