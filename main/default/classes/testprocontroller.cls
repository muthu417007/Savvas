public with sharing class testprocontroller  {

    @AuraEnabled(cacheable=true)
    public static List<ProductWrapper> searchRecords(List<String> recordIds) {
        List<ProductWrapper> searchResults = new List<ProductWrapper>();
        try {
              Boolean isPriceLoaded = false;
         	  String iconname = '';
            if (recordIds != null && recordIds.size() <= 25) {
                isPriceLoaded = true;
                  iconname = 'utility:hourglass';
                searchResults = populateSearchResults(recordIds, true, false,isPriceLoaded,iconname);
            } else {
                Boolean isInternational = false;
                Id userId = UserInfo.getUserId();
                Contact userContact = [SELECT AccountId, Account.Type FROM Contact WHERE Id IN (SELECT ContactId FROM User WHERE Id = :userId) LIMIT 1];
                if (userContact != null && userContact.AccountId != null) {
                    String accountType = userContact.Account.Type;
                    isInternational = checkInternationalAccount(accountType);
                }
                searchResults = populateSearchResults(recordIds, false, isInternational,isPriceLoaded,iconname);
            }
        } catch (Exception e) {
            System.debug('Exception in searchRecords: ' + e.getMessage());
        }
        return searchResults;
    }

    @AuraEnabled(cacheable=true)
public static Boolean checkInternationalAccount(String accountType) {
    try {
        if (accountType != null && (accountType.equalsIgnoreCase('International School') || accountType.equalsIgnoreCase('International Distributor'))) {
            return true;
        } else {
            return false;
        }
    } catch (Exception e) {
        System.debug('Exception in checkInternationalAccount: ' + e.getMessage());
        return false;
    }
}

    @AuraEnabled(cacheable=true)
public static List<ProductWrapper> populateSearchResults(List<String> recordIds, Boolean considerCustomerPrice, Boolean isInternational,Boolean isPriceLoaded, String iconname) {
    List<ProductWrapper> searchResults = new List<ProductWrapper>();
    try {
        List<Product2> products = [SELECT Id, ISBN13__c, ISBN10__c, Material_Type__c, Product_Sub_Type__c, Description, Grade_Level__c, Copyright_Year__c, Product_Status__c, Net_Price__c 
                                   FROM Product2 WHERE IsDeleted = false AND (ISBN13__c IN :recordIds OR ISBN10__c IN :recordIds) AND Material_Type_ID__c IN ('ZSBN', 'ZKPK', 'ZNVE', 'ZNMR')];
        
     Map<Id, Decimal> netPriceMap = new Map<Id, Decimal>();
    	for (Product2 prod : products) {
            if (!netPriceMap.containsKey(prod.Id)) {
                netPriceMap.put(prod.Id, prod.Net_Price__c * 1.33);
            }
        }
        
      for (Product2 prod : products) {
                Decimal price = null;
                if (!considerCustomerPrice) {
                    if (isInternational) {
                        price = netPriceMap.get(prod.Id);
                    } else {
                        price = prod.Net_Price__c;
                    }
                }
       
            String ISBN = '';
            if (recordIds.contains(prod.ISBN13__c) && recordIds.contains(prod.ISBN10__c)) {
                if (recordIds.contains(prod.ISBN13__c)) {
                    ISBN = prod.ISBN13__c;
                } else {
                    ISBN = prod.ISBN10__c;
                }
            } else if (recordIds.contains(prod.ISBN10__c)) {
                ISBN = prod.ISBN10__c;
            } else if (recordIds.contains(prod.ISBN13__c)) {
                ISBN = prod.ISBN13__c;
            }
            
            if (!String.isEmpty(ISBN)) {
                //searchResults.add(new ProductWrapper(prod, price, ISBN, prod.Id));
                 searchResults.add(new ProductWrapper(prod, Price, ISBN, prod.Id,isPriceLoaded ,iconname));
            }
        }
        System.debug('Search Results: ' + searchResults);
    } catch (Exception e) {
        System.debug('Exception in populateSearchResults: ' + e.getMessage());
    }
    return searchResults;
}

    public class ProductWrapper {
        @AuraEnabled public Product2 product { get; set; }
        @AuraEnabled public Decimal Price { get; set; }
        @AuraEnabled public String ISBN { get; set; }
        @AuraEnabled public Id productId { get; set; }
        @AuraEnabled public Boolean disableCheckbox { get; set; }
        @AuraEnabled public String Title_Description { get; set; }
        @AuraEnabled public String Grade_Level { get; set; }
        @AuraEnabled public String Type { get; set; }
        @AuraEnabled public String Status { get; set; }
        @AuraEnabled public String Copyrightyear { get; set; }
		@AuraEnabled public Boolean isPriceLoaded { get; set; }
        @AuraEnabled public string iconname { get; set; }
        public ProductWrapper(Product2 product, Decimal Price, String ISBN, Id productId,Boolean isPriceLoaded ,string iconname) {
            this.product = product;
            this.Price = Price;
            this.ISBN = ISBN;
            this.productId = product.Id;
            this.Title_Description = product.Description;
            this.Grade_Level = product.Grade_Level__c;
            this.Type = product.Product_Sub_Type__c;
            this.Status = product.Product_Status__c;
            this.Copyrightyear = product.Copyright_Year__c;
			this.isPriceLoaded = isPriceLoaded;
            this.iconname=iconname;
        }
    }
}