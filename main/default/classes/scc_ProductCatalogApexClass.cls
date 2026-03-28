/***************************************************************************************
* @Class Name: scc_ProductCatalogApexClass
* @Description: 
* @Created By: CTS
* @Created On: 5/22/2024
* *************************************************************************************
* Modification Log: 12/17/2024
* -------------------------------------------------------------------------------------
* Developer        Date            Description
* -------------------------------------------------------------------------------------
*/

public without sharing class scc_ProductCatalogApexClass {
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
    @AuraEnabled public Boolean IsActive;
    //@AuraEnabled public Decimal Price;
    @AuraEnabled public String Price;//changes by Vaibhav for pricing connector
    @AuraEnabled public String UserStatus { get; set; }
    @AuraEnabled public String ListPrice;
    @AuraEnabled public String Discount;
    @AuraEnabled public String DisplayPrice;
    @AuraEnabled public String NetPrice;
    // @AuraEnabled public String UserStatus;
    @AuraEnabled public String NetPriceFormatted;
    @AuraEnabled public String ListPriceFormatted;
    @AuraEnabled public String DiscountFormatted;
    // @AuraEnabled public Decimal DisplayPrice { get; set; }
    //@AuraEnabled public String AccountId { get; set; }
    @AuraEnabled public String Country { get; set; }       
    @AuraEnabled public String ProductCode { get; set; }
    @AuraEnabled public String countryCodeISO { get; set; }
    @AuraEnabled public string accountId { get; set; } 
    @AuraEnabled public Boolean isInternalUser { get; set; }
    @AuraEnabled public String Product_Status_ID { get; set; }
}

/**
 * Retrieves and builds a hierarchical product category structure based on user access
 * and available products. Filters out empty categories and respects state-based visibility.
 * 
 * @param selectedState Comma-separated list of state codes for filtering products
 * @return List<ProductCategoryWrapper> List of valid product categories with their hierarchy
 */
@AuraEnabled(cacheable=true)
public static List<ProductCategoryWrapper> retrieveProductCategory(String selectedState) {
    // 1) Get current user
    User currentUser = [
        SELECT IsEmployee__c 
        FROM User 
        WHERE Id = :UserInfo.getUserId()
    ];
    
    // 2) Query product categories
    Map<Id, ProductCategory> mapProductCategoryIdToRecord = new Map<Id, ProductCategory>(
        [SELECT Id, Name, ParentCategoryId,
            (SELECT Id, Name, ParentCategoryId
             FROM ChildCategories 
             WHERE myOrders_exclude__c = false
             ORDER BY SortOrder)
         FROM ProductCategory 
         WHERE Catalog.Name = 'Savvas CPQ Catalog' 
           AND myOrders_exclude__c = false 
         ORDER BY ParentCategory.name, SortOrder]
    );
    
    Set<Id> productCategoryIds = mapProductCategoryIdToRecord.keySet();
    Map<Id, Integer> productCountMap = new Map<Id, Integer>();
    
    // 3) Build userStatesSet for external users
    Set<String> userStatesSet = new Set<String>();
    if (currentUser.IsEmployee__c) {
        // Internal user => no need to filter
        // We'll do the same aggregator as you already do:
        List<AggregateResult> results = [
            SELECT ProductCategoryId, COUNT(Id) productCount
            FROM ProductCategoryProduct
            WHERE ProductCategoryId IN :productCategoryIds
              AND Product.IsDuplicate__c = false
            GROUP BY ProductCategoryId
        ];
        for (AggregateResult ar : results) {
            productCountMap.put(
                (Id)ar.get('ProductCategoryId'),
                (Integer)ar.get('productCount')
            );
        }
    } else {
        // External user
        userStatesSet.add('NATL');
        if (String.isNotBlank(selectedState)) {
            for (String st : selectedState.split(',')) {
                if (String.isNotBlank(st)) {
                    userStatesSet.add(st.trim());
                }
            }
        }
        
        // 3A) Query for in-state + NATL products (as you do now)
        List<AggregateResult> results = [
            SELECT ProductCategoryId, COUNT(Id) productCount
            FROM ProductCategoryProduct
            WHERE ProductCategoryId IN :productCategoryIds
              AND Product.Program_Series__c IN :userStatesSet
              AND Product.IsDuplicate__c = false
            GROUP BY ProductCategoryId
        ];
        for (AggregateResult ar : results) {
            productCountMap.put(
                (Id)ar.get('ProductCategoryId'),
                (Integer)ar.get('productCount')
            );
        }
    }
    
    // 3B) **NEW** - Also query for out-of-state products
    //     We only need it for external users. For internal users,
    //     no folder is hidden because of “out-of-state”.
    Map<Id, Integer> outOfStateCountMap = new Map<Id, Integer>();
    if (!currentUser.IsEmployee__c) {
        List<AggregateResult> outOfStateResults = [
            SELECT ProductCategoryId, COUNT(Id) productCount
            FROM ProductCategoryProduct
            WHERE ProductCategoryId IN :productCategoryIds
              AND Product.Program_Series__c NOT IN :userStatesSet
              AND Product.IsDuplicate__c = false
            GROUP BY ProductCategoryId
        ];
        for (AggregateResult ar : outOfStateResults) {
            outOfStateCountMap.put(
                (Id)ar.get('ProductCategoryId'),
                (Integer)ar.get('productCount')
            );
        }
    }
    
    // 4) Convert everything into wrappers
    List<ProductCategoryWrapper> productCategoryWrapperRecordList = new List<ProductCategoryWrapper>();
    for (Id catId : mapProductCategoryIdToRecord.keySet()) {
        ProductCategory cat = mapProductCategoryIdToRecord.get(catId);
        if (cat.ParentCategoryId == null) {
            ProductCategoryWrapper wrapper = new ProductCategoryWrapper(
                cat,
                mapProductCategoryIdToRecord,
                currentUser.IsEmployee__c ? null : userStatesSet,
                productCountMap
            );
            productCategoryWrapperRecordList.add(wrapper);
        }
    }
    
    // 5) Remove empty categories **and** those containing out-of-state
    return removeEmptyCategories(
        productCategoryWrapperRecordList, 
        productCountMap, 
        outOfStateCountMap
    );
}

/**
 * Recursively processes category hierarchy to remove categories that have no products
 * and no valid child categories. A category is considered valid if it either has
 * direct products or contains valid child categories.
 * 
 * @param categoryList List of categories to process
 * @param productCountMap Map of category IDs to their product counts
 * @return List<ProductCategoryWrapper> Filtered list containing only valid categories
 */
private static List<ProductCategoryWrapper> removeEmptyCategories(
    List<ProductCategoryWrapper> categoryList, 
    Map<Id, Integer> productCountMap,
    Map<Id, Integer> outOfStateCountMap
) {
    List<ProductCategoryWrapper> validCategories = new List<ProductCategoryWrapper>();
    
    for (ProductCategoryWrapper category : categoryList) {
        
        // 1) Recursively process child categories
        List<ProductCategoryWrapper> validChildren = new List<ProductCategoryWrapper>();
        if (category.childProductCategoryList != null && !category.childProductCategoryList.isEmpty()) {
            validChildren = removeEmptyCategories(
                category.childProductCategoryList,
                productCountMap,
                outOfStateCountMap
            );
        }
        
        // 2) Check if it has direct products we are allowed to see
        Boolean hasDirectProducts = (
            productCountMap.containsKey(category.productCategoryId) && 
            productCountMap.get(category.productCategoryId) > 0
        );
        
        // 3) Check out-of-state counts
        Boolean hasOutOfStateProducts = (
            outOfStateCountMap != null && 
            outOfStateCountMap.containsKey(category.productCategoryId) && 
            outOfStateCountMap.get(category.productCategoryId) > 0
        );
        
        // 4) If it has out-of-state products, we mark it as invalid
        if (hasOutOfStateProducts) {
            System.debug('Removing Category ' + category.productCategoryName + ' due to out-of-state products.');
            continue;
        }
        
        // 5) If either direct products or valid children => keep it
        if (hasDirectProducts || !validChildren.isEmpty()) {
            category.childProductCategoryList = validChildren;
            validCategories.add(category);
        }
        
        System.debug('Category: ' + category.productCategoryName
            + ' | directProducts=' + hasDirectProducts 
            + ' | validChild=' + !validChildren.isEmpty());
    }
    
    return validCategories;
}




/**
 * Checks if a specific category has any direct products associated with it.
 * 
 * @param categoryId ID of the category to check
 * @param productCountMap Map of category IDs to their product counts
 * @return Boolean True if category has products, false otherwise
 */
public static Boolean hasProducts(String categoryId, Map<Id, Integer> productCountMap) {
      // Returns true if category exists in map and has more than 0 products
    return productCountMap.containsKey(categoryId) && productCountMap.get(categoryId) > 0;
}


    public static Map<Id, Integer> getProductCountMap(Set<Id> productCategoryIds) {
        Map<Id, Integer> productCountMap = new Map<Id, Integer>();

        List<AggregateResult> results = [SELECT ProductCategoryId, COUNT(Id) productCount
                                        FROM ProductCategoryProduct
                                        WHERE ProductCategoryId IN :productCategoryIds
                                        GROUP BY ProductCategoryId];
        for (AggregateResult result : results) {
            productCountMap.put((Id)result.get('ProductCategoryId'), (Integer)result.get('productCount'));
        }

        return productCountMap;
    }

/**
 * Returns the count of immediate child categories for a given parent category.
 * Only includes non-excluded categories (myOrders_exclude__c = false).
 * 
 * @param selectedId ID of the parent category
 * @return Integer Number of child categories
 */
    @AuraEnabled(cacheable=true)
    public static Integer getChildRecords(String selectedId) {
        // Returns count of immediate child categories for a given category ID
        return [SELECT Id, Name, ParentCategoryId, 
                   (SELECT Id, Name, ParentCategoryId FROM ChildCategories WHERE myOrders_exclude__c = false) 
                FROM ProductCategory WHERE ParentCategoryId = :selectedId AND myOrders_exclude__c = false].size();
    }

/**
 * Retrieves detailed product data for a selected category, including child products.
 * Filters products based on user type (employee/non-employee) and state access.
 * 
 * @param selectedRowId ID of the selected category
 * @param selectedState Comma-separated list of state codes for filtering products
 * @return List<ProductCategory> List of product categories with their associated products
 */

    @AuraEnabled(cacheable=true)
    public static List<ProductCategory> getChildRecordsProductData(String selectedRowId, String selectedState) {
       User currentUser = [SELECT IsEmployee__c FROM User WHERE Id = :UserInfo.getUserId()];

    if (currentUser.IsEmployee__c) {
        return [SELECT Id, Name, ParentCategory.Id, ParentCategory.Name,
                   (SELECT Product.Id, Product.Name, Product.ISBN10__c, Product.ISBN13__c,
                           Product.Description, Product.Product_Sub_Type__c, Product.Grade_Level__c, 
                           Product.Copyright_Year__c, Product.Product_Status__c, Product.Net_Price__c
                    FROM ProductCategoryProducts
                    WHERE Product.IsDuplicate__c = false)
                FROM ProductCategory
                WHERE Id = :selectedRowId AND myOrders_exclude__c = false];
    } else {
        Set<String> userStatesSet = new Set<String>{'NATL'};
        if (String.isNotBlank(selectedState)) {
            for (String st : selectedState.split(',')) {
                if (String.isNotBlank(st)) {
                    userStatesSet.add(st.trim());
                }
            }
        }

        return [SELECT Id, Name, ParentCategory.Id, ParentCategory.Name,
                   (SELECT Product.Id, Product.Name, Product.ISBN10__c, Product.ISBN13__c,
                           Product.Description, Product.Product_Sub_Type__c, Product.Grade_Level__c, 
                           Product.Copyright_Year__c, Product.Product_Status__c, Product.Net_Price__c
                    FROM ProductCategoryProducts
                    WHERE Product.Program_Series__c IN :userStatesSet
                    AND Product.IsDuplicate__c = false)
                FROM ProductCategory
                WHERE Id = :selectedRowId AND myOrders_exclude__c = false];
    }
}

/**
 * Wrapper class for product categories that includes hierarchy information
 * and provides methods for processing child categories.
 */
    public class ProductCategoryWrapper {
        @AuraEnabled public String productCategoryId {get; set; }
        @AuraEnabled public String productCategoryName {get; set; }
        @AuraEnabled public String parentProductCategoryId {get; set; }
        @AuraEnabled public List<ProductCategoryWrapper> childProductCategoryList {get; set; }

 /**
     * Constructor that initializes a category wrapper and processes its children
     * 
     * @param oneProductCategory The product category to wrap
     * @param mapProductCategoryIdToRecord Map of all category records
     * @param userStatesSet Set of state codes the user has access to
     * @param productCountMap Map of category IDs to their product counts
     */
        public ProductCategoryWrapper(ProductCategory oneProductCategory, Map<Id, ProductCategory> mapProductCategoryIdToRecord, Set<String> userStatesSet, Map<Id, Integer> productCountMap) {
            this.productCategoryId = oneProductCategory.Id;
            this.productCategoryName = oneProductCategory.Name;
            this.parentProductCategoryId = oneProductCategory.ParentCategoryId;
            this.childProductCategoryList = convertChildProductSobjectListToWrapperList(oneProductCategory.ChildCategories, mapProductCategoryIdToRecord, userStatesSet, productCountMap);
        }

 /**
     * Converts a list of child product categories into wrapper objects
     * 
     * @param childProductCategoryList List of child categories to process
     * @param mapProductCategoryIdToRecord Map of all category records
     * @param userStatesSet Set of state codes the user has access to
     * @param productCountMap Map of category IDs to their product counts
     * @return List<ProductCategoryWrapper> List of wrapped child categories
     */
        public List<ProductCategoryWrapper> convertChildProductSobjectListToWrapperList(List<ProductCategory> childProductCategoryList, Map<Id, ProductCategory> mapProductCategoryIdToRecord, Set<String> userStatesSet, Map<Id, Integer> productCountMap) {
            List<ProductCategoryWrapper> local_ChildProductCategoryList = new List<ProductCategoryWrapper>();
            if (childProductCategoryList != null && !childProductCategoryList.isEmpty()) {
                for (ProductCategory oneChildProductCategory : childProductCategoryList) {
                    ProductCategory currentProductCategory = mapProductCategoryIdToRecord.containsKey(oneChildProductCategory.Id) ? mapProductCategoryIdToRecord.get(oneChildProductCategory.Id) : null;
                    if (currentProductCategory != null) {
                        local_ChildProductCategoryList.add(new ProductCategoryWrapper(currentProductCategory, mapProductCategoryIdToRecord, userStatesSet, productCountMap));
                    } else {
                        local_ChildProductCategoryList.add(new ProductCategoryWrapper(oneChildProductCategory, mapProductCategoryIdToRecord, userStatesSet, productCountMap));
                    }
                }
            }
            return local_ChildProductCategoryList;
        }
    }

    /**********************************************************************************
    * Method Name : getProductDetails
    * Description : Retrieves getProductDetails records of a product category.
    * Return Type : List<ProductCategory>
*********************************************************************************/
@AuraEnabled(cacheable=true)
    public static List<ProductWrapper> getProductDetails(List<Id> prodId) {
    List<ProductWrapper> productData = new List<ProductWrapper>(); 
try {
    // Fetch products based on provided product IDs
    List<Product2> products = [SELECT Id, ISBN10__c, ISBN13__c, Description, Product_Sub_Type__c, Grade_Level__c, 
                                Copyright_Year__c, Product_Status__c, Net_Price__c, ProductCode,Sales_Restriction_Code__c, Rights_Restriction_Code__c,IsActive, SAP_C__c, IsDuplicate__c,Product_Status_ID__c
                                FROM Product2 
                                WHERE Id IN :prodId 
                                AND IsDuplicate__c = false];
    // Fetch user information
    List<User> usr = [SELECT Id, Division__c, IsEmployee__c FROM User WHERE Id = :UserInfo.getUserId()];
    Boolean isInternalUser = usr[0].IsEmployee__c;
    // If no valid user found, return an empty list
    if (usr.isEmpty()) {
        System.debug('No valid user found');
        //return new List<ProductWrapper>();
    }else{
        isInternalUser = usr[0].IsEmployee__c;
    }
        Set<String> productCodes = new Set<String>();
    for (Product2 prod : products) {
        productCodes.add(prod.ProductCode);
    }
List<PricebookEntry> pricebookEntries = [SELECT IsActive, Product2Id,UnitPrice FROM PricebookEntry where  Product2Id = :prodId  AND CurrencyIsoCode = 'USD'];
    system.debug(pricebookEntries);
    // Create a map to hold the pricebook entries by product code
    Map<String, PricebookEntry> productCodeToPriceMap = new Map<String, PricebookEntry>();
    for (PricebookEntry price : pricebookEntries) {
        // Add the pricebook entry to the map
        if (!productCodeToPriceMap.containsKey(price.Product2Id)) {
            productCodeToPriceMap.put(price.Product2Id, price);
        }
    }
    for (Product2 prod : products) {
        ProductWrapper wrapper = new ProductWrapper();
        wrapper.productId = prod.Id;
        wrapper.ISBN = prod.ISBN13__c != null ? prod.ISBN13__c : prod.ISBN10__c;
        wrapper.showISBN13Field = prod.ISBN13__c != null;
        wrapper.Title_Description = prod.Description;
        wrapper.Type = prod.Product_Sub_Type__c;
        wrapper.Grade_Level = prod.Grade_Level__c;
        wrapper.Copyright = prod.Copyright_Year__c;
        wrapper.Status = prod.Product_Status__c;
        wrapper.ProductCode = prod.ProductCode;
        wrapper.isInternalUser = isInternalUser;
        wrapper.SalesRestriction=prod.Sales_Restriction_Code__c;
        wrapper.RightsRestriction=prod.Rights_Restriction_Code__c;
        wrapper.IsActive=prod.SAP_C__c;
        wrapper.Product_Status_ID=prod.Product_Status_ID__c;
        wrapper.Price = 'NA';
            if (isInternalUser || !isInternalUser) {
            PricebookEntry price = productCodeToPriceMap.get(prod.Id);
            if (price != null) {
                Decimal unitPrice = price.UnitPrice;
                Decimal OrginalNetPrice = unitPrice;
                Decimal OrginalListPrice = unitPrice * 1.333;
                // Decimal OrginalDiscount = (OrginalListPrice - OrginalNetPrice) / OrginalListPrice * 100;
                Decimal OrginalDiscount = OrginalListPrice != 0 ? (OrginalListPrice - OrginalNetPrice) / OrginalListPrice * 100 : 0;
                wrapper.NetPrice = formatPrice(OrginalNetPrice);
                wrapper.ListPrice = formatPrice(OrginalListPrice);
                wrapper.Discount = formatPrice(OrginalDiscount)+ '%';
                    wrapper.NetPriceFormatted = formatPrice(OrginalNetPrice);
                wrapper.ListPriceFormatted = formatPrice(OrginalListPrice);
                wrapper.DiscountFormatted = formatPrice(OrginalDiscount) + '%';
                if (usr[0].Division__c == 'International') {
                    wrapper.UserStatus = 'International';
                        wrapper.countryCodeISO = 'USD';
                        wrapper.accountId = '';  
                } else if (usr[0].Division__c == 'K12/School') {
                    wrapper.UserStatus = 'Internal US User'; wrapper.countryCodeISO = 'USD'; wrapper.accountId = '';  
                } else if(!isInternalUser){
                    wrapper.UserStatus = 'Internal US User without Account';
                }
                wrapper.DisplayPrice = wrapper.ListPrice;
                wrapper.NetPriceFormatted = formatPrice(OrginalNetPrice);
                wrapper.ListPriceFormatted = formatPrice(OrginalListPrice);
                wrapper.DiscountFormatted = formatPrice(OrginalDiscount) + '%';
            }
        } else {
            
        }
        productData.add(wrapper);
    }
} catch (Exception e) {
    throw new AuraHandledException(e.getMessage());
}
System.debug('Data for productData: ' + productData);
return productData;
    }
  
public static String formatPrice(Decimal price) {
    if (price != null) {
        String formattedPrice = String.valueOf(price.setScale(2, RoundingMode.HALF_UP));
        formattedPrice = formattedPrice.replaceAll('(\\d)(?=(\\d{3})+\\.)', '$1,');
        return  formattedPrice;
    }
    return null;
}
}