/***************************************************************************************
* @Class Name: scc_InternalUserQuickSearch
* @Description: This apex class helps to   get  product data  and prices for internal user based status of user 
* @Created By: Sudha Rani Pathivada
* @Created On: 09/07/2024
* **************************************************************************************
* Modification Log:
* -------------------------------------------------------------------------------------
* Developer        Date            Description
* -------------------------------------------------------------------------------------
*/
public with sharing class scc_InternalUserQuickSearch {
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
        
        @AuraEnabled public String accountId { get; set; }
        @AuraEnabled public String Country { get; set; }       
        @AuraEnabled public String ProductCode { get; set; }
        @AuraEnabled public Boolean isInternalUser { get; set; }
        @AuraEnabled public String ListPrice;
        @AuraEnabled public String Discount;
        @AuraEnabled public String DisplayPrice;
        @AuraEnabled public String NetPrice;
        @AuraEnabled public String UserStatus;
        @AuraEnabled public String NetPriceFormatted;
        @AuraEnabled public String ListPriceFormatted;
        @AuraEnabled public String DiscountFormatted;
        @AuraEnabled public String countryCodeISO;
        
        public ProductWrapper(Product2 product, String Price, String ISBN, Id productId, String ProductCode) {
            this.product = product;
            this.Price = Price;
            this.ISBN = ISBN;
            this.productId = productId;
            this.Title_Description = product != null ? product.Description : '';
            this.Grade_Level = product != null ? product.Grade_Level__c : '';
            this.Type = product != null ? product.Product_Sub_Type__c : '';
            this.Status = product != null ? product.Product_Status__c : '';
            this.Copyrightyear = product != null ? product.Copyright_Year__c : '';
            this.ProductCode = ProductCode;
            this.isInternalUser = isInternalUser;
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<ProductWrapper> searchRecords(List<String> recordIds, String accountId, String country, Boolean activeProducts) {
        List<ProductWrapper> searchResults = new List<ProductWrapper>();
        try {
            searchResults = populateSearchResults(recordIds, accountId, country, activeProducts);
        } catch (Exception e) {
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            searchResults = new List<ProductWrapper>{new ProductWrapper(null, null, 'Error: ' + e.getMessage(), null, null)};
        }
        return searchResults;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<ProductWrapper> populateSearchResults(List<String> recordIds, String accountId, String country, Boolean activeProducts) {
        List<ProductWrapper> searchResults = new List<ProductWrapper>();
        try {
            // Build the query dynamically to handle the activeProducts parameter
            String query = 'SELECT Id, ProductCode, ISBN13__c, ISBN10__c, Material_Type__c, Product_Sub_Type__c, Description, ' +
                          'Grade_Level__c, Copyright_Year__c, Product_Status__c, Net_Price__c, IsActive, SAP_C__c, IsDuplicate__c ' +
                          'FROM Product2 ' +
                          'WHERE IsDeleted = false AND (ISBN13__c IN :recordIds OR ISBN10__c IN :recordIds) ' +
                          'AND Material_Type_ID__c IN (\'ZSBN\', \'ZKPK\', \'ZNVE\', \'ZNMR\') ' +
                          'AND IsDuplicate__c = false';
            
            // Add SAP_C__c condition if activeProducts is true
            if (activeProducts) {
                query += ' AND SAP_C__c = true';
            }
            
            List<Product2> products = Database.query(query);
            
            String countryCode='';
            String selcCountryUS = System.Label.scc_countryIncludeUS;
            String selcCountryCAD = System.Label.scc_countryIncludeCAD;
            String selcCountryBoth = System.Label.scc_countryIncludeBoth;
            String countryUSCode = System.Label.scc_countryCodeUSD;
            String countryCADCode = System.Label.scc_countryCodeCAD;
            
            List<User> usr = [SELECT Id, Division__c, IsEmployee__c FROM User WHERE Id = :UserInfo.getUserId() AND IsEmployee__c = true];
            if (usr.isEmpty() || !usr[0].IsEmployee__c) {                
                return new List<ProductWrapper>();
            }
            Boolean isInternalUser = usr[0].IsEmployee__c;
            String selectedCountry = String.isNotBlank(country) ? country : null;
            if(selectedcountry == selcCountryUS)
            {             
                countryCode = countryUSCode;
            }
            else if(selectedcountry == selcCountryCAD)
            {
                countryCode = countryCADCode;          
            }
            Map<Id, PricebookEntry> priceMap = new 	Map<Id, PricebookEntry>();
            if(selectedcountry != selcCountryBoth)
            {
                priceMap = getPricebookEntries(products,countryCode);
            }
            else if(selectedcountry == selcCountryBoth)
            {
                priceMap = getPricebookEntriesBoth(products);
            }
            String sapAccId = String.isNotBlank(accountId) ? accountId : null;
            String effectiveAccountId='';
            if(sapAccId!= null)
            { 
                effectiveAccountId = getSAPAccountId(sapAccId);
            }
            
            for (Product2 prod : products) {
                String Price = 'NA';
                String ISBN = '';
                if (recordIds.contains(prod.ISBN13__c) && recordIds.contains(prod.ISBN10__c)) {
                    ISBN = !String.isEmpty(prod.ISBN13__c) ? prod.ISBN13__c : prod.ISBN10__c;
                } else if (recordIds.contains(prod.ISBN10__c)) {
                    ISBN = prod.ISBN10__c;
                } else if (recordIds.contains(prod.ISBN13__c)) {
                    ISBN = prod.ISBN13__c;
                }
                
                if (!String.isEmpty(ISBN)) {
                    ProductWrapper wrapper = new ProductWrapper(prod, Price, ISBN, prod.Id, prod.ProductCode);
                    wrapper.accountId = effectiveAccountId;
                    wrapper.Country = country;
                    wrapper.isInternalUser=isInternalUser;
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
                                Decimal  OrginalNetPrice = unitPrice;
                                Decimal    OrginalListPrice = unitPrice * 1.333;
                                Decimal OrginalDiscount= OrginalListPrice!= 0? (OrginalListPrice - OrginalNetPrice) / OrginalListPrice* 100: 0;
                                wrapper.NetPrice = formatPrice(orginalNetPrice);
                                wrapper.ListPrice = formatPrice(OrginalListPrice);
                                wrapper.Discount = formatPrice(OrginalDiscount);
                                wrapper.UserStatus = 'Internal US User';
                                wrapper.countryCodeISO = pbe.CurrencyIsoCode;
                                wrapper.DisplayPrice = wrapper.ListPrice;
                                wrapper.NetPriceFormatted = formatPrice(OrginalNetPrice);
                                wrapper.ListPriceFormatted = formatPrice(OrginalListPrice);
                                wrapper.DiscountFormatted = formatPrice(OrginalDiscount) + '%';
                            } 
                        }
                    }
                    searchResults.add(wrapper);                    
                }
            }
        } catch (Exception e) {
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            searchResults = new List<ProductWrapper>{new ProductWrapper(null, null, 'Error: ' + e.getMessage(), null, null)};
                }
        return searchResults;
    }
    public static String formatPrice(Decimal price) {
        if (price != null) {            
            String formattedPrice = String.valueOf(price.setScale(2));            
            return '$' + formattedPrice;            
        }
        return null;
    }
    /********************************************************************** 
Method Name :  getPricebookEntries
Description :  Method helps to  get  prices book etries for products based on countrycode 
Input       :  string(report name)
Return type :  NA
***********************************************************************/ 
    public static Map<Id,PricebookEntry> getPricebookEntries(List<Product2> products,String countryCode)
    {
        Map<Id, PricebookEntry> priceMap = new Map<Id, PricebookEntry>();
        try{
            if(products.isEmpty())
            {
                return priceMap;
                
            }
            Set<Id> productIds=new Set<Id>();
            for(Product2 prod : products)
            {
                productIds.add(prod.Id);
            }
            List<PricebookEntry> prices = [SELECT IsActive, UnitPrice,Product2Id,CurrencyIsoCode FROM PricebookEntry where Product2Id IN : productIds AND CurrencyIsoCode =: countryCode];
            for(PricebookEntry pbe : prices)
            {
                priceMap.put(pbe.Product2Id, pbe);
            }
        }catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            throw new AuraHandledException('Failed to get SIOP url:'+e.getMessage()+e.getCause());
        }        
        return priceMap;
    }
    /********************************************************************** 
Method Name :  getPricebookEntriesBoth
Description :  Method helps to  get  prices book etries for products
Input       :  string(report name)
Return type :  NA
***********************************************************************/ 
    public static Map<Id,PricebookEntry> getPricebookEntriesBoth(List<Product2> products)
    {
        Map<Id, PricebookEntry> priceMap = new Map<Id, PricebookEntry>();
        try{
            if(products.isEmpty())
            {
                return priceMap;
                
            }
            Set<Id> productIds=new Set<Id>();
            for(Product2 prod : products)
            {
                productIds.add(prod.Id);
            }
            List<PricebookEntry> prices = [SELECT IsActive, UnitPrice,Product2Id,CurrencyIsoCode FROM PricebookEntry where Product2Id IN : productIds];
            for(PricebookEntry pbe : prices)
            {
                priceMap.put(pbe.Product2Id, pbe);
            }
        }catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            throw new AuraHandledException('Failed to get SIOP url:'+e.getMessage()+e.getCause());
        }        
        return priceMap;
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
        try{            
            if(!accSAPId.isEmpty()){
                accSap = accSAPId[0].Id;
            }            
        }catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            throw new AuraHandledException('Failed to get SAP AccountId:'+e.getMessage()+e.getCause());
        }        
        return accSap;
    }
    
}