/***************************************************************************************
* @Class Name: scc_internalUser_Realtedproducts
* @Description: This apex class helps to get product data
* @Created By: Sudha Rani Pathivada
* @Created On: 09/07/2024
* **************************************************************************************
* Modification Log:
* -------------------------------------------------------------------------------------
* Developer        Date            Description
* -------------------------------------------------------------------------------------
*/
public with sharing class scc_internalUser_Realtedproducts {
    @AuraEnabled(cacheable=true)
    /********************************************************************** 
Method Name :  getRelatedProducts
Description :  Method helps to  get product data
Input       :  String productId,string sapAccountid, String country 
Return type :  List<ProductWrapper>
***********************************************************************/ 
    public static List<ProductWrapper> getRelatedProducts(String productId,string sapAccountid, String country ) {
        try{
            List<User> usr = [SELECT Id, Division__c, IsEmployee__c, Email 
                              FROM User WHERE Id = :UserInfo.getUserId() AND IsEmployee__c = true];
            if (usr.isEmpty() || !usr[0].IsEmployee__c) {
                return new List<ProductWrapper>();
            }
            String sapAccId = String.isNotBlank(sapAccountid) ? sapAccountid : null;
            Boolean isInternalUser = usr[0].IsEmployee__c;
            String prodId = productId;
            List<Product2> productDetails = new List<Product2>();
            List<ProductWrapper> productData = new List<ProductWrapper>();
            productDetails = [SELECT Id, Program_Series__c, Item_Category_Group__c, PRODUCT_GROUP_CODE__c, Grade_Level__c, Copyright_Year__c, ProductCode 
                              FROM Product2 WHERE Id = :prodId LIMIT 1];
            
            String programSeries = productDetails[0].Program_Series__c;
            String productGroup = productDetails[0].PRODUCT_GROUP_CODE__c;
            String gradeLevel = productDetails[0].Grade_Level__c;
            String copyRight = productDetails[0].Copyright_Year__c;                                 
            
            productDetails =[SELECT Id,ISBN10__c,ISBN13__c,Description,SAP_C__c,Product_Sub_Type__c,Net_Price__c, ProductCode, PRODUCT_GROUP_CODE__c, Sales_Restriction_Code__c,Rights_Restriction_Code__c, Grade_Level__c,Copyright_Year__c,Product_Status__c,Item_Category_Group__c,Program_Series__c,IsActive FROM Product2 
                                 WHERE Program_Series__c =:programSeries 
                                 AND PRODUCT_GROUP_CODE__c =:productGroup
                                 AND Copyright_Year__c =:copyRight
                                 AND Grade_Level__c =:gradeLevel];
            
            Set<String> productCodes = new Set<String>();
            for (Product2 prod : productDetails) {
                productCodes.add(prod.ProductCode);
            }

            String countryCode='';
            String selectedcountry =  String.isNotBlank(country) ? country : null;
            if(selectedcountry == 'Only US Sales Org'|| selectedcountry == '002' || selectedcountry=='USD'||selectedcountry==''||selectedcountry=='undefined')
            {                
                countryCode = 'USD';
            }
            else if(selectedcountry == 'Only Canadian Sales Org'|| selectedcountry == '006' || selectedcountry=='CAD')
            {
                countryCode = 'CAD';          
            }            
            
            List<PricebookEntry> pricebookEntries = [SELECT IsActive, Product2Id,UnitPrice FROM PricebookEntry where  Product2Id = :productDetails  AND CurrencyIsoCode =:countryCode limit 50000];
            
            // Create a map to hold the pricebook entries by product code
            Map<String, PricebookEntry> productCodeToPriceMap = new Map<String, PricebookEntry>();
            for (PricebookEntry price : pricebookEntries) {
                
                if (!productCodeToPriceMap.containsKey(price.Product2Id)) {
                    productCodeToPriceMap.put(price.Product2Id, price);
                }
            }
            
            for (Product2 prod : productDetails) {
                if (String.isBlank(prod.ISBN13__c)) {
                    prod.ISBN13__c = prod.ISBN10__c;
                }
                
                ProductWrapper wrapper = new ProductWrapper();
                wrapper.Id = prod.Id;
                wrapper.ISBN10 = prod.ISBN10__c;
                wrapper.ISBN13 = prod.ISBN13__c;
                wrapper.Description = prod.Description;
                wrapper.Product_Sub_Type = prod.Product_Sub_Type__c;
                wrapper.Net_Price = prod.IsActive ? 'NA' : '';
                wrapper.Grade_Level = prod.Grade_Level__c;
                wrapper.Copyright_Year = prod.Copyright_Year__c;
                wrapper.Product_Status = prod.Product_Status__c;
                wrapper.Item_Category_Group = prod.Item_Category_Group__c;
                wrapper.IsActive = prod.IsActive;
                wrapper.Program_Series = prod.Program_Series__c;
                wrapper.isInternalUser = isInternalUser;
                wrapper.accountId=sapAccId;
                wrapper.country=selectedcountry;
                
                wrapper.UserStatus = (usr[0].Division__c == 'International') ? 'International': (usr[0].Division__c == 'K12/School') ? 'Internal US User':'internal user with account';
                
                if (isInternalUser) {
                    if (String.isBlank(sapAccId)) {
                        PricebookEntry price = productCodeToPriceMap.get(prod.Id);
                        if (price != null) {
                            Decimal unitPrice = price.UnitPrice;
                            Decimal OrginalNetPrice = unitPrice;
                            Decimal OrginalListPrice = unitPrice * 1.333;
                           
                            Decimal OrginalDiscount = OrginalListPrice != 0 ? (OrginalListPrice - OrginalNetPrice) / OrginalListPrice * 100 : 0;
                            wrapper.NetPrice = formatPrice(OrginalNetPrice);
                            wrapper.ListPrice = formatPrice(OrginalListPrice);
                            wrapper.Discount = formatPrice(OrginalDiscount)+ '%';
                            wrapper.NetPriceFormatted = formatPrice(OrginalNetPrice);
                            wrapper.ListPriceFormatted = formatPrice(OrginalListPrice);
                            wrapper.DiscountFormatted = formatPrice(OrginalDiscount) + '%';
                            wrapper.DisplayPrice = wrapper.ListPrice;
                            
                        }
                    }
                } else if(isInternalUser && !String.isBlank(sapAccId))
                {
                    wrapper.DisplayPrice = null; wrapper.NetPriceFormatted = null; wrapper.ListPriceFormatted = null;wrapper.DiscountFormatted = null;  
                   
                   
                                      
                }
                
                if(prodId != prod.Id){                    
                    productData.add(wrapper);
                }
            }            
            return productData;
        }
        catch (DmlException e) {
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            throw new AuraHandledException('Error getting related products: ' + e.getMessage());
        }
    }
    
    public static String formatPrice(Decimal price) {
        if (price != null) {
            String formattedPrice = String.valueOf(price.setScale(2, RoundingMode.HALF_UP));
            formattedPrice = formattedPrice.replaceAll('(\\d)(?=(\\d{3})+\\.)', '$1,');
            return '$' + formattedPrice;
        }
        return null;
    }
    
    
    public class ProductWrapper {
        @AuraEnabled public String Id;
        @AuraEnabled public String ISBN10;
        @AuraEnabled public String ISBN13;
        @AuraEnabled public String Description;
        @AuraEnabled public String Product_Sub_Type;
        @AuraEnabled public String Net_Price;
        @AuraEnabled public String Grade_Level;
        @AuraEnabled public String Copyright_Year;
        @AuraEnabled public String Product_Status;
        @AuraEnabled public String Item_Category_Group;
        @AuraEnabled public Boolean IsActive;
        @AuraEnabled public String Program_Series;
        @AuraEnabled public Boolean isInternalUser;
        @AuraEnabled public String ListPrice;
        @AuraEnabled public String Discount;
        @AuraEnabled public String DisplayPrice;
        @AuraEnabled public String NetPrice;
        @AuraEnabled public String UserStatus;
        @AuraEnabled public String NetPriceFormatted;
        @AuraEnabled public String ListPriceFormatted;
        @AuraEnabled public String DiscountFormatted;
        @AuraEnabled public String accountId { get; set; }
        @AuraEnabled public String country { get; set; }
    }
}