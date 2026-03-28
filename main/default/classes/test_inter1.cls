public class test_inter1 {

    @AuraEnabled(cacheable=true)
    public static List<ProductWrapper> searchProducts(String isbnValue, String selectedDiscipline, String titlekeyword, Boolean activeProducts, String accountId) {
        List<User> usr = [SELECT Id, Division__c, IsEmployee__c, Email 
                          FROM User WHERE Id = :UserInfo.getUserId() and IsEmployee__c=true];
        if (usr.isEmpty() || !usr[0].IsEmployee__c) {
            return new List<ProductWrapper>();
        }
        
        String effectiveAccountId =  String.isNotBlank(accountId) ? accountId : null;
        List<ProductWrapper> productData = new List<ProductWrapper>();
        System.debug('isbnValue :: ' + isbnValue);
        Boolean SapCheck = true;
        String searchISBN = String.isNotBlank(isbnValue) ? (isbnValue.length() <= 10 ? padZerosLeft(isbnValue, 10) : (isbnValue.length() <= 13 ? padZerosLeft(isbnValue, 13) : null)) : null;
        System.debug('searchISBN :: ' + searchISBN);

        String query = 'SELECT Id,ProductCode, ISBN10__c, ISBN13__c, Description, Product_Sub_Type__c, Grade_Level__c, Copyright_Year__c, Product_Status__c, IsActive ';
        query += 'FROM Product2 ';
        query += 'WHERE ';
        if (searchISBN != null) {
            query += '(ISBN13__c = :searchISBN OR ISBN10__c = :searchISBN) AND ';
        } else {
            if (String.isNotBlank(selectedDiscipline)) {
                query += 'Discipline__c = :selectedDiscipline AND ';
            }
            if (String.isNotBlank(titlekeyword)) {
                query += 'Description LIKE \'%' + titlekeyword + '%\' AND ';
            }
        }

        if (activeProducts) {
            query += 'IsActive = true ';
        } else {
            query += '(IsActive = true OR IsActive = false) ';
        }
        query += ' AND SAP_A_Check__c = :SapCheck';
        
        Set<String> materialTypes = new Set<String>{'ZSBN', 'ZKPK', 'ZNVE', 'ZNMR'};
        query += ' AND Material_Type_ID__c IN :materialTypes';
        
        Integer limitLeft = Limits.getLimitQueryRows() - Limits.getQueryRows();
        query += ' LIMIT :limitLeft';

        System.debug('Search Query:' + query);

        List<Product2> products = Database.query(query);

        System.debug('Number of Products found:' + products.size());

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
            wrapper.IsActive = prod.IsActive;
            wrapper.accountId = effectiveAccountId;
   
            if (prod.IsActive) {
                wrapper.Price = '';
                wrapper.DisplayPrice = null;
            } else {
                wrapper.Price = '';
                 wrapper.DisplayPrice = null;
            }
            
            if (usr[0].Division__c == 'International') {
                if (String.isBlank(effectiveAccountId)) {
                    List<PricebookEntry> prices = [SELECT IsActive, UnitPrice, Product2.ProductCode, Pricebook2.Name 
                                                   FROM PricebookEntry 
                                                   WHERE Pricebook2.Name = 'Standard Price Book' 
                                                   AND Product2.ProductCode = :prod.ProductCode 
                                                   AND CurrencyIsoCode = 'USD'];
                    
                    if (!prices.isEmpty()) {
                        Decimal unitPrice = prices[0].UnitPrice;
                        wrapper.NetPrice = unitPrice;
                        wrapper.ListPrice = unitPrice * 1.333;
                        wrapper.Discount = (wrapper.NetPrice - wrapper.ListPrice) / wrapper.ListPrice * 100;
                        wrapper.UserStatus='International';
                        wrapper.DisplayPrice = null;
                    }
                } else {
                    List<PricebookEntry> prices = [SELECT IsActive, UnitPrice, Product2.ProductCode, Pricebook2.Name 
                                                   FROM PricebookEntry 
                                                   WHERE Pricebook2.Name = 'Standard Price Book' 
                                                   AND Product2.ProductCode = :prod.ProductCode 
                                                   AND CurrencyIsoCode = 'USD'];

                    if (!prices.isEmpty()) {
                        Decimal unitPrice = prices[0].UnitPrice;
                        wrapper.ListPrice = unitPrice * 1.333;
                        wrapper.NetPrice = null ;
                        wrapper.Discount = null ;
                        wrapper.UserStatus='International With Account';
                        wrapper.DisplayPrice = null;
                    }
                }
            } else if (usr[0].Division__c == 'K12/School') {
                if (String.isBlank(effectiveAccountId)) {
                    List<PricebookEntry> prices = [SELECT IsActive, UnitPrice, Product2.ProductCode, Pricebook2.Name 
                                                   FROM PricebookEntry 
                                                   WHERE Pricebook2.Name = 'Standard Price Book' 
                                                   AND Product2.ProductCode = :prod.ProductCode 
                                                   AND CurrencyIsoCode = 'USD'];
                    
                    if (!prices.isEmpty()) {
                        Decimal unitPrice = prices[0].UnitPrice;
                        wrapper.NetPrice = unitPrice;
                        wrapper.ListPrice = null;
                        wrapper.Discount = null;
                        wrapper.UserStatus='Internal US User';
                        wrapper.DisplayPrice = null;
                    }
                    else{
                        wrapper.UserStatus='Internal US User without Account';
                        wrapper.DisplayPrice = null;
                    }
                } 
            
            }
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
        @AuraEnabled public String Price;
        @AuraEnabled public Id accountId;
        @AuraEnabled public Boolean IsActive;
        @AuraEnabled public Decimal NetPrice;
        @AuraEnabled public Decimal ListPrice;
        @AuraEnabled public Decimal Discount;
         @AuraEnabled public String  UserStatus;
         @AuraEnabled public Decimal  DisplayPrice;
    }    

    public static String padZerosLeft(String input, Integer length) {
        String paddedValue = input;
        while (paddedValue.length() < length) {
            paddedValue = '0' + paddedValue;
        }
        return paddedValue;
    }
    
 
}