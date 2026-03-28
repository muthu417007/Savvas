public without sharing class testController{
    
    @AuraEnabled(cacheable=true)
    public static List<Product2Wrapper> searchRecords(List<String> recordIds) {
        List<Product2Wrapper> searchResults = new List<Product2Wrapper>();
        
       //system.debug('entered15'+recordIds);
        if (recordIds != null && recordIds.size() <=35) {
           
            searchResults = populateSearchResults(recordIds, true, false);
//             system.debug('entered16'+searchResults);
        } else {
            
            Boolean isInternational = false; 
            Id userId = UserInfo.getUserId();
            system.debug(userId);
            Contact userContact = [SELECT AccountId, Account.BillingPostalCode FROM Contact WHERE Id IN (SELECT ContactId FROM User WHERE Id = :userId) LIMIT 1];
            if (userContact != null && userContact.AccountId != null) {
                String accountZipCode = userContact.Account.BillingPostalCode;
                isInternational = isInternationalAccount(accountZipCode);
            }
            
           
            searchResults = populateSearchResults(recordIds, false, isInternational);
            //system.debug('entered17'+searchResults);
        }
        //system.debug('entered18'+searchResults);
        return searchResults;
    }

    // Method to determine international account status based on the zip code
    private static Boolean isInternationalAccount(String accountZipCode) {
        Set<String> internationalZipCodes = new Set<String>{'94100', '67890'}; 
           // system.debug('entered18'+internationalZipCodes.contains(accountZipCode));
        return internationalZipCodes.contains(accountZipCode);
        
    }

private static List<Product2Wrapper> populateSearchResults(List<String> recordIds, Boolean considerCustomerPrice, Boolean isInternational) {
    List<Product2Wrapper> searchResults = new List<Product2Wrapper>();

    
    List<Product2> products = [SELECT Id, ISBN13__c, ISBN10__c, Material_Type__c, Description, Grade_Level__c, 
                                Copyright_Year__c, Product_Status__c, Net_Price__c, List_Price__c, Customer_Price__c
                                FROM Product2
                                WHERE IsDeleted = false
                                AND (ISBN13__c IN :recordIds OR ISBN10__c IN :recordIds)
                                AND Product_Status__c IN ('OUT OF PRINT', 'IN PRINT')
                               AND Material_Type_ID__c IN ('ZSBN', 'ZKPK', 'ZNVE', 'ZNMR')
                              ];
    
    
    Map<Id, Decimal> netPriceMap = new Map<Id, Decimal>();
    for (Product2 prod : products) {
        if (!netPriceMap.containsKey(prod.Id)) {
            netPriceMap.put(prod.Id, prod.Net_Price__c);
        }
    }
    for (Id prodId : netPriceMap.keySet()) {
        Decimal netPrice = netPriceMap.get(prodId);
        Decimal listPrice = netPrice * 1.33; 
        netPriceMap.put(prodId, listPrice);
    }

    
    for (Product2 prod : products) {
        Decimal price = null;
       if (considerCustomerPrice) {
    
    price = null;
}
        else {
            if (isInternational) {
                
                price = netPriceMap.get(prod.Id);
            } else {
               
                price = prod.Net_Price__c;
            }
        }
        searchResults.add(new Product2Wrapper(prod, price));
    }
    
    return searchResults;
}

    
  
    public class Product2Wrapper {
        @AuraEnabled public Product2 product { get; set; }
        @AuraEnabled public Decimal price { get; set; }
       
        public Product2Wrapper(Product2 product, Decimal price) {
            this.product = product;
            this.price = price;
        }
    }
}