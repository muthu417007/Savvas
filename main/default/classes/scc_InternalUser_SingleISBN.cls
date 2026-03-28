/*
Apex Class:scc_InternalUser_SingleISBN
Author: CTS (Sudharani)
Created Date: 12/06/2024
Reason: Backend Scc_siopRegistrationLWC
Modified Date:
*/
public with sharing class scc_InternalUser_SingleISBN {
    
    /**
*  Description: This method search products    
*  @name: searchProducts
*  @param: String (isbnValue), String (selectedDiscipline), String (titlekeyword), Boolean (activeProducts), String (accountId), String (country)
*  @return:  List<ProductWrapper>
*/
    @AuraEnabled
    public static List<ProductWrapper> searchProducts(String isbnValue, String selectedDiscipline, String titlekeyword, Boolean activeProducts, String accountId, String country) {
        List<User> usr = [SELECT Id, Division__c, IsEmployee__c, Email 
                          FROM User WHERE Id = :UserInfo.getUserId() and IsEmployee__c=true];
        String countryCode='';
        if (usr.isEmpty() || !usr[0].IsEmployee__c) {
            return new List<ProductWrapper>();
        }
        Boolean isInternalUser = usr[0].IsEmployee__c;
        string sapAccId = String.isNotBlank(accountId) ? accountId : null;
        string effectiveAccountId='';
        if(sapAccId!= null)
        { 
            effectiveAccountId = getSAPAccountId(sapAccId);
        }
        
        String selectedcountry =  String.isNotBlank(country) ? country : null;
        
        if(selectedcountry == 'Only US Sales Org')
        {            
            countryCode = 'USD';
        }
        else if(selectedcountry == 'Only Canadian Sales Org')
        {
            countryCode = 'CAD';          
        }
        else
        {
            countryCode = '';
        }
        try {
            List<ProductWrapper> productData = new List<ProductWrapper>();                        
            String searchISBN = String.isNotBlank(isbnValue) ? (isbnValue.length() <= 10 ? padZerosLeft(isbnValue, 10) : (isbnValue.length() <= 13 ? padZerosLeft(isbnValue, 13) : null)) : null;
            
            String query = 'SELECT Id, ProductCode, ISBN10__c, ISBN13__c, Description, Product_Sub_Type__c, ' +
                'Grade_Level__c, Copyright_Year__c, Product_Status__c, IsActive, CurrencyIsoCode, SAP_C__c, IsDuplicate__c ';
            query += 'FROM Product2 WHERE ';
            
            query += 'IsDuplicate__c = false AND ';
            
            if (activeProducts) {
                query += 'SAP_C__c = true AND ';
            }
            
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
            
            if(country != 'Both') {
                query += 'CurrencyIsoCode = :countryCode AND ';   
            } 
            
            Set<String> materialTypes = new Set<String>{'ZSBN', 'ZKPK', 'ZNVE', 'ZNMR'};
                query += 'Material_Type_ID__c IN :materialTypes';
            
            Integer limitLeft =4960;
            query += ' LIMIT :limitLeft';
            
            List<Product2> products = Database.query(query);
            Map<Id, PricebookEntry> priceMap = new 	Map<Id, PricebookEntry>();
            if(selectedcountry != 'Both')
            {
                priceMap = getPricebookEntries(products,countryCode);                
            }
            else if(selectedcountry == 'Both')
            {
                priceMap = getPricebookEntriesBoth(products);
            }            
            
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
                wrapper.country=selectedcountry;
                wrapper.isInternalUser = isInternalUser;
                wrapper.countryCodeISO =countryCode;
                wrapper.UserStatus = (usr[0].Division__c == 'International') ? 'International': (usr[0].Division__c == 'K12/School') ? 'Internal US User':'internal user with account';
                wrapper.Price = 'NA';                    

                
                if (usr[0].Division__c == 'International') {
                    
                    if (String.isBlank(effectiveAccountId)) {
                        
                        PricebookEntry pbe = priceMap.get(prod.Id);
                        if (pbe!= null) {
                            Decimal unitPrice = pbe.UnitPrice;
                            Decimal  OrginalNetPrice = unitPrice;
                            Decimal    OrginalListPrice = unitPrice * 1.333;
                            
                            Decimal OrginalDiscount= OrginalListPrice!= 0? (OrginalListPrice - OrginalNetPrice) / OrginalListPrice* 100: 0;
                            wrapper.NetPrice = formatPrice(orginalNetPrice);
                            wrapper.ListPrice = formatPrice(OrginalListPrice);
                            wrapper.Discount = formatPrice(OrginalDiscount);
                            wrapper.UserStatus = 'International';
                            wrapper.countryCodeISO = pbe.CurrencyIsoCode;
                            wrapper.DisplayPrice = wrapper.ListPrice;
                            
                            wrapper.NetPriceFormatted = formatPrice(OrginalNetPrice);
                            wrapper.ListPriceFormatted = formatPrice(OrginalListPrice);
                            wrapper.DiscountFormatted = formatPrice(OrginalDiscount) + '%';
                        }
                    }
                } else if (usr[0].Division__c == 'K12/School') {
                    if (String.isBlank(effectiveAccountId)) {
                        
                        PricebookEntry pbe = priceMap.get(prod.Id);
                        
                        if (pbe!= null) {
                            Decimal unitPrice = pbe.UnitPrice;
                            Decimal OrginalNetPrice = unitPrice;
                            Decimal OrginalListPrice = unitPrice * 1.333;
                            
                            Decimal OrginalDiscount= OrginalListPrice!= 0? (OrginalListPrice - OrginalNetPrice) / OrginalListPrice* 100: 0;
                            wrapper.NetPrice = formatPrice(orginalNetPrice);
                            wrapper.ListPrice = formatPrice(OrginalListPrice);
                            wrapper.Discount = formatPrice(OrginalDiscount);
                            wrapper.UserStatus = (usr[0].Division__c == 'International') ? 'International' : (usr[0].Division__c == 'K12/School') ? 'Internal US User' : 'internal user with account';
                            wrapper.DisplayPrice = wrapper.ListPrice;
                            
                            wrapper.countryCodeISO = pbe.CurrencyIsoCode;
                            wrapper.NetPriceFormatted = formatPrice(OrginalNetPrice);
                            wrapper.ListPriceFormatted = formatPrice(OrginalListPrice);
                            wrapper.DiscountFormatted = formatPrice(OrginalDiscount) + '%';
                        }                        
                    }                     
                }                
                productData.add(wrapper);
            }            
            return productData;
        }
        catch (Exception e) {
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            throw new AuraHandledException('An error occurred while searching products: ' + e.getMessage());
        }
    }
    
    /********************************************************************** 
Method Name :  ProductWrapper
Description :  Product wrapper
Input       :  NA
Return type :  NA
***********************************************************************/ 
    public class ProductWrapper {
        @AuraEnabled public String productId;
        @AuraEnabled public String ISBN;
        @AuraEnabled public Boolean showISBN13Field;
        @AuraEnabled public String Title_Description;
        @AuraEnabled public String Type;
        @AuraEnabled public String Grade_Level;
        @AuraEnabled public String Copyright;
        @AuraEnabled public String Status;
        @AuraEnabled public string Price;
        @AuraEnabled public string accountId;
        @AuraEnabled public Boolean IsActive;
        @AuraEnabled public String ListPrice;
        @AuraEnabled public String Discount;
        @AuraEnabled public String DisplayPrice;
        @AuraEnabled public String NetPrice;
        @AuraEnabled public String UserStatus;
        @AuraEnabled public String NetPriceFormatted;
        @AuraEnabled public String ListPriceFormatted;
        @AuraEnabled public String DiscountFormatted;
        @AuraEnabled public String  country   ;
        @AuraEnabled public String countryCodeISO;
        @AuraEnabled public Boolean isInternalUser { get; set; }
    }    
    
    /********************************************************************** 
Method Name :  padZerosLeft
Description :  Method helps to format price 
Input       :  string(report name)
Return type :  String
***********************************************************************/ 
    public static String padZerosLeft(String input, Integer length) {
        String paddedValue = input;
        while (paddedValue.length() < length) {
            paddedValue = '0' + paddedValue;
        }
        return paddedValue;
    }
    
    /********************************************************************** 
Method Name :  formatPrice
Description :  Method helps to format price 
Input       :  Decimal(price)
Return type :  String
***********************************************************************/ 
    public static String formatPrice(Decimal price) {
        if (price != null) {            
            String formattedPrice = String.valueOf(price.setScale(2, RoundingMode.FLOOR));            
            return '$' + formattedPrice;            
        }
        return null;
    }
    /********************************************************************** 
Method Name :  getPricebookEntriesBoth
Description :  Method helps to  get  prices book etries for products and  based on country code 
Input       :  string(report name)
Return type :  NA
***********************************************************************/ 
    public static Map<Id,PricebookEntry> getPricebookEntries(List<Product2> products,String countryCode)
    {
        try{
            Map<Id, PricebookEntry> priceMap = new Map<Id, PricebookEntry>();
            if(products.isEmpty())
            {
                return priceMap;                
            }
            Set<Id> productIds=new Set<Id>();
            for(Product2 prod : products)
            {
                productIds.add(prod.Id);
            }
            
            List<PricebookEntry> prices = [SELECT IsActive, UnitPrice,Product2Id,CurrencyIsoCode FROM PricebookEntry where Product2Id IN : productIds AND CurrencyIsoCode =: countryCode and  UnitPrice!=null limit 25000  ];
            
            for(PricebookEntry pbe : prices)
            {
                if (pbe.UnitPrice != null) {
                    priceMap.put(pbe.Product2Id, pbe);
                }                
            }
            return priceMap;
        }
        catch (Exception e) {
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            throw new AuraHandledException('An error occurred while searching products: ' + e.getMessage());
        }
    }
    
    /********************************************************************** 
Method Name :  getPricebookEntriesBoth
Description :  Method helps to  get  prices book etries for products
Input       :  string(report name)
Return type :  NA
***********************************************************************/ 
    public static Map<Id,PricebookEntry> getPricebookEntriesBoth(List<Product2> products)
    {
        try{
            Map<Id, PricebookEntry> priceMap = new Map<Id, PricebookEntry>();
            if(products.isEmpty())
            {
                return priceMap;
                
            }
            Set<Id> productIds=new Set<Id>();
            for(Product2 prod : products)
            {
                productIds.add(prod.Id);
            }
            List<PricebookEntry> prices = 
            [SELECT IsActive, UnitPrice, Product2Id, CurrencyIsoCode
                FROM PricebookEntry
                WHERE Product2Id IN :productIds
                        ORDER BY CreatedDate ASC LIMIT 25000];
                                           
            for(PricebookEntry pbe : prices)
            {
                priceMap.put(pbe.Product2Id, pbe);
            }
            return priceMap;
        }
        catch (Exception e) {
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            throw new AuraHandledException('An error occurred while searching products: ' + e.getMessage());
        }
    }
    /********************************************************************** 
Method Name :  getSAPAccountId
Description :  Method helps to  get  reports account Sap number
Input       :  string(report name)
Return type :  NA
***********************************************************************/ 
    public static String getSAPAccountId(String sapAccId)
    {        
        List<Account> accSAPId =[select Id from Account where SAP_Account_Id__c =: sapAccId ];
        String accSap='';
        if(!accSAPId.isEmpty()){
            accSap = accSAPId[0].Id;
        }        
        return accSap;
    }
}