public with sharing class testprodcontru {

    @AuraEnabled(cacheable=true)
    public static List<ProductWrapper> searchRecords(List<String> recordIds) {
        List<ProductWrapper> searchResults = new List<ProductWrapper>();
        System.debug('Entered searchRecords method');
        System.debug('RecordIds: ' + recordIds);
        System.debug('RecordIds size: ' + recordIds.size());

        try {
            if (recordIds.size() <= 25) {
                System.debug('Record count is less than or equal to 25');
                searchResults = populateSearchResults(recordIds, true, false);
            } else {
                System.debug('Record count is greater than 25');
                Boolean isInternational = false; 
                Id userId = UserInfo.getUserId();
                Contact userContact = [SELECT AccountId, Account.Type FROM Contact WHERE Id IN (SELECT ContactId FROM User WHERE Id = :userId) LIMIT 1];
                if (userContact != null && userContact.AccountId != null) {
                    String accountType = userContact.Account.Type;
                    isInternational = isInternationalAccount(accountType);
                }
                searchResults = populateSearchResults(recordIds, false, isInternational);
            }
        } catch (Exception e) {
            System.debug('Exception caught in searchRecords method: ' + e.getMessage());
            searchResults = new List<ProductWrapper>();
            searchResults.add(new ProductWrapper(null, null, 'Error: ' + e.getMessage(), null));
        }
        
        return searchResults;
    }

    @AuraEnabled(cacheable=true)
    public static Boolean isInternationalAccount(String accountType) {
        if (accountType != null && (accountType.equalsIgnoreCase('International School') || accountType.equalsIgnoreCase('International Distributor'))) {
            return true;
        } else {
            return false;
        }
    }


@AuraEnabled(cacheable=true)
public static List<ProductWrapper> populateSearchResults(List<String> recordIds, Boolean considerCustomerPrice, Boolean isInternational) {
    List<ProductWrapper> searchResults = new List<ProductWrapper>();

    try {
        List<Product2> products = [SELECT Id, ISBN13__c, ISBN10__c, Material_Type__c, Product_Sub_Type__c, Description, Grade_Level__c, 
                                    Copyright_Year__c, Product_Status__c, Net_Price__c 
                                    FROM Product2 WHERE IsDeleted = false AND (ISBN13__c IN :recordIds OR ISBN10__c IN :recordIds) 
                                    AND Material_Type_ID__c IN ('ZSBN', 'ZKPK', 'ZNVE', 'ZNMR') ];
        System.debug('Products fetched successfully: ' + products);

        Map<Id, Decimal> netPriceMap = new Map<Id, Decimal>();
        for (Product2 prod : products) {
             System.debug('ISBN set for product: ');

           if (prod.Net_Price__c != null && !netPriceMap.containsKey(prod.Id)) {
        netPriceMap.put(prod.Id, prod.Net_Price__c * 1.33);
        System.debug('ISBN set for product: ');
    }
        }

        for (Product2 prod : products) {
            System.debug('Processing product: ' + prod);

            Decimal Price = null;
            if (!considerCustomerPrice) {
                if (isInternational) {
                    Price = netPriceMap.get(prod.Id);
                } else {
                    Price = prod.Net_Price__c;
                }
            }

            System.debug('Price calculated for product: ' + Price);

            String ISBN = '';
            System.debug('Price calculated for product: ' + Price);
            if (recordIds.contains(prod.ISBN13__c) && recordIds.contains(prod.ISBN10__c)) {
                System.debug('ISBN set for product: ' + ISBN);

                ISBN = prod.ISBN13__c;
            } else if (recordIds.contains(prod.ISBN13__c)) {
               System.debug('ISBN set for product: ' + ISBN);

                ISBN = prod.ISBN13__c;
            } else if (recordIds.contains(prod.ISBN10__c)) {
             System.debug('ISBN set for product: ' + ISBN);

                ISBN = prod.ISBN10__c;
            } 

            System.debug('ISBN set for product: ' + ISBN);

            if (!String.isEmpty(ISBN)) {
                searchResults.add(new ProductWrapper(prod, Price, ISBN, prod.Id));
            }
        }
    } catch (Exception e) {
        System.debug('Exception caught in populateSearchResults method: ' + e.getMessage());
        searchResults = new List<ProductWrapper>();
        searchResults.add(new ProductWrapper(null, null, 'Error: ' + e.getMessage(), null));
    }

    return searchResults;
}



    public class ProductWrapper {
        @AuraEnabled public Product2 product { get; set; }
        @AuraEnabled public Decimal Price { get; set; }
        @AuraEnabled public String ISBN { get; set; }
        @AuraEnabled public Id productId { get; set; }
        @AuraEnabled public String Title_Description { get; set; }
        @AuraEnabled public String Grade_Level { get; set; }
        @AuraEnabled public String Type { get; set; }
        @AuraEnabled public String Status { get; set; }
        @AuraEnabled public String Copyrightyear { get; set; }

        public ProductWrapper(Product2 product, Decimal Price, String ISBN, Id productId) {
            this.product = product;
            this.Price = Price;
            this.ISBN = ISBN;
            this.productId = product.Id;
            this.Title_Description = product.Description;
            this.Grade_Level = product.Grade_Level__c;
            this.Type = product.Product_Sub_Type__c;
            this.Status = product.Product_Status__c;
            this.Copyrightyear = product.Copyright_Year__c;
        }
    }
}