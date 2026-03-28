/*
*********************************************************
Class Name       : CpqProductSelectionCtrl
Created Date     : 4/22/2024  
Author           : Frank Berni - Cognizant
Description      : Server side controller for 'CpqProductSelection' Lightning Web Component.

History:
<Date>          <Authors Name>              <Brief Description of Change>
4/22/2024       Frank Berni                 Initial creation: Ticket W-014433 
4/26/2024       Frank Berni                 New getMasterCategoryId method and reverted parameter changes in getCategoryData
5/01/2024       Frank Berni                 Reworked getCategoryProductsByCategory and insertSelectedProducts to account for ProductCategoryProduct records
5/08/2024       Frank Berni                 Updated Name in soql to query 'Master - Savvas CPQ Catalog' record as part of Dev3 and higher environments
5/10/2024       Frank Berni                 Added getQuoteLines method for the cpqProductCart cmp
5/13/2024       Frank Berni                 Ticket W-014412: added getCategoryProductsByIsbn13 as an alternative method to find Products
5/16/2024       Frank Berni                 Ticket W-014412: updated getCategoryProductsByIsbn13 so it also searches by Description and changed to getCategoryProductsBySearchTerm
                                            > Ticket W-014516: Updated all queries to use Product2 fields instead of ProductCategoryProduct and added all Product List Filter fields
5/17/2024       Frank Berni                 Ticket W-014412: Changed ISBN10__c to ProductCode (This field is the source of truth of ISBN)
5/19/2024       Frank Berni                 Added try catch to getCategoryProductsByCategory method. Brought Product.ISBN10__c into queries to avoid potential issues with ProductCode (DEV4 mainly)
5/20/2024       Frank Berni                 Ticket W-014516: Added getPicklistValues method to grab default picklist values for filter fields
5/21/2024       Frank Berni                 Ticket W-014516: Added Product.Program_Series__c to Product Category Product query
5/22/2024       Frank Berni                 Updated getCategoryProductsByCategory and getCategoryProductsBySearchTerm to return category products that match the Quote's Pricebook Entries
5/23/2024       Frank Berni                 Added ProductCategoryId and Product.CategoryType__c to query for category products when inserting quote lines, more field mappings to come later
6/04/2024       Frank Berni                 Added more field mappings to come later for Quote Line when inserting Products. Deprecated getPicklistValues due to dynamic filters requirement
6/13/2024       Frank Berni                 Refactor: Created a new ProductTableData wrapper class to hold values from Product Category Product, Product and PricebookEntry 
6/14/2024       Frank Berni                 Added CurrencyIsoCode to query for Products
6/15/2024       Frank Berni                 Updated getMatchingPricebookEntries to account for CurrencyIsoCode in case there is a mix of currencies in the assigned pricebook, 
                                            > Added Product.Product_Type_Id__c to Product mapping
6/19/2024       Frank Berni                 Added Freight Code to Product2 mapping
6/26/2024       Frank Berni                 Updated getQuoteLines to return Quote Lines organized by most recent CreatedDate
7/02/2024       Frank Berni                 Added PCP Display_sequence to be mapped over to quote line's Display_Sequence
8/01/2024       Frank Berni                 W-015630: refactored insertSelectedProducts so it inserts a quote line for each unique category product instead of unique product id
                                            > W-015581: added Order By ASC query for quote lines for cart page
8/09/2024       Frank Berni                 UAT Feedback W-015728: Update default Quantity for Quote Lines to be 1 instead of 0
8/12/2024       Frank Berni                 W-015750: Updated getQuoteLines to query Product's Description for cpqProductCart
                                            > W-015738: Also updated getProductsByCategory to take in a list of Ids for multi category select
8/21/2024       Frank Berni                 W-015698: Added Product Status Id to mapped Quote Lines | W-015830: updated sort order for returned product category products - included GradeLevel Sort Order and CategoryType Sort Order
8/22/2024       Frank Berni                 W-015698: included new formula fields GradeLevel Sort Order and CategoryType Sort Order
8/26/2024       Frank Berni                 W-015877: Added an IsActive filter for ProductCategoryProduct queries and added matching currency to quote when inserting quote lines
9/16/2024       Frank Berni                 W-016058: Replacing Grade Band with Grade Level
10/07/2024      Brent Mac                   W-016294: Adding filter for IsQuotable__c = true for the product category product query
10/09/2024      Frank Berni                 W-016294: Added filter for Is_Quotable__c = true for the product category query 
10/31/2024      Frank Berni                 W-016463: Added DescriptionLongText__c mapping from Product Description
**********************************************************/
public with sharing class CpqProductSelectionCtrl {

  /*
  *********************************************************
  Class Name     : WrapperData
  Author         : Frank Berni
  Description    : Structure wrapper data for the lightning-tree-grid
  ********************************************************
  */
  public class WrapperData {
    @AuraEnabled
    public Object record;
    @AuraEnabled
    public Boolean hasChildrenContent;
    public WrapperData(Object record, Boolean hasChildrenContent) {
      this.record = record;
      this.hasChildrenContent = hasChildrenContent;
    }
  }

  /*
  *********************************************************
  Class Name     : ProductTableData
  Author         : Frank Berni
  Description    : Structure wrapper data for the Product List
  ********************************************************
  */
  public class ProductTableData {
    @AuraEnabled
    public String id {get; set;}
    @AuraEnabled
    public String productCode {get; set;}
    @AuraEnabled
    public String categoryFamily {get; set;}
    @AuraEnabled
    public String description {get; set;}
    @AuraEnabled
    public String audience {get; set;}
    @AuraEnabled
    public String productSubType {get; set;}
    @AuraEnabled
    public String programSeries {get; set;}
    // W-016058 replace gradeBand with gradeLevel
    @AuraEnabled
    public String gradeLevel {get; set;}
    @AuraEnabled
    public String solutionType {get; set;}
    @AuraEnabled
    public String duration {get; set;}
    @AuraEnabled
    public String copyrightYear {get; set;}
    @AuraEnabled
    public Decimal netPrice {get; set;}
    @AuraEnabled
    public String currencyCode {get; set;}

    // Constructor
    public ProductTableData(
      String product_id,
      String product_productCode,
      String product_categoryFamily,
      String product_description,
      String product_audience,
      String product_productSubType,
      String product_programSeries,
      // W-016058 replace gradeBand with gradeLevel
      String product_gradeLevel,
      String product_solutionType,
      String product_duration,
      String product_copyrightYear,
      Decimal product_netPrice,
      String product_currencyCode
    ) {
        // Assignments
        this.id = product_id;
        this.productCode = product_productCode;
        this.categoryFamily = product_categoryFamily;
        this.description = product_description;
        this.audience = product_audience;
        this.productSubType = product_productSubType;
        this.programSeries = product_programSeries;
        // W-016058 replace gradeBand with gradeLevel
        this.gradeLevel = product_gradeLevel;
        this.solutionType = product_solutionType;
        this.duration = product_duration;
        this.copyrightYear = product_copyrightYear;
        this.netPrice = product_netPrice;
        this.currencyCode = product_currencyCode;
    }

  }

  /*
    *********************************************************
    Method Name    : getMasterCategoryId
    Author         : Frank Berni
    Description    : Method returns the master category record Id from the org so its available in LWC. Used in CpqProductSelection LWC
    Param          : 
    return         : String masterCatId
    ********************************************************
    */
  @AuraEnabled(cacheable=true)
  public static String getMasterCategoryId() {
      ProductCategory masterCat = [SELECT Id FROM ProductCategory WHERE Name = 'Master - Savvas CPQ Catalog'];
      String masterCatId = (String)masterCat.Id;
      System.debug('masterCatId: ' + masterCatId);
      return masterCatId;
  }

  /*
  *********************************************************
  Method Name    : getCategoryData
  Author         : Frank Berni
  Description    : this method returns the wrapper of Hierarchy Data for ProductCategory records. Used in CpqProductCategoryHierarchy LWC
  Param          : String soql, String parentField, String recordId
  return         : List<WrapperData> valuesList of mapOfRecord
  ********************************************************
  */
  @AuraEnabled
  public static List<WrapperData> getCategoryData(
    String soql,
    String parentField,
    String recordId
  ) {
    try {
      Map<Id, WrapperData> mapOfRecord = new Map<Id, WrapperData>();
      String firstSOQL = soql, secondSOQL = soql;

      //Get the Parent Record
      // Added Is_Quotable__c to true
      firstSOQL += ' WHERE ' + parentField + ' = ' + '\'' + recordId + '\'' + 'AND Is_Quotable__c = true ORDER BY SortOrder' ;
      for (sObject obj : Database.query(firstSOQL)) {
        mapOfRecord.put((Id) obj.get('Id'), new WrapperData(obj, false));
      }
      Set<Id> setOfKeys = mapOfRecord.keySet();
      
      //Check If Parent Record has children or not
      secondSOQL += ' WHERE ' + parentField + ' IN : setOfKeys ';
      for (sObject obj : Database.query(secondSOQL)) {
        if (mapOfRecord.containsKey((Id) obj.get(parentField))) {
          mapOfRecord.get((Id) obj.get(parentField)).hasChildrenContent = true;
        }
      }
    
      return mapOfRecord.values();
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
    
    
     
    /*
    *********************************************************
    Method Name    : getCategoryProductsByCategory
    Author         : Frank Berni
    Description    : this method returns ProductCategoryProduct records that match the selected catgeory Id and matches Quote's Pricebook. Used in CpqProductList LWC
    Param          : List<Id> categoryIds, Id recordId
    return         : List<ProductCategoryProduct> matching ProductCategoryProduct list
    ********************************************************
    */
    @AuraEnabled(cacheable=true)
    public static List<ProductTableData> getCategoryProductsByCategory(List<Id> categoryIds, Id recordId) {
      
      // Setting up our collections
      List<ProductCategoryProduct> returnedPcpList = new List<ProductCategoryProduct>();
      // wrapper class is used to represent the products
      List<ProductTableData> pbePcpTableDataList = new List<ProductTableData>();
      Set<Id> pcpProductIds = new Set<Id>();
      
      try {
          // Retrieve the quote record
          SBQQ__Quote__c quote = [SELECT Id, SBQQ__PriceBook__c, CurrencyIsoCode FROM SBQQ__Quote__c WHERE Id = :recordId];

          // W-016058 replace GradeBand with Grade_Level
          // Query product2 fields based on the category selected
          returnedPcpList = [SELECT Id, ProductId, Product.ProductCode, Product.ISBN10__c, Product.Name, Product.Audience__c, Product.Net_Price__c,
                            Product.Description, Product.Product_Sub_Type__c,  
                            Product.Grade_Level__c, Product.Copyright_Year__c, Product.Duration__c, Product.Solution_Type__c,
                            Product.Program_Series__c  
                            , ProductCategory.Name, ProductCategory.ParentCategory.Name
                    FROM ProductCategoryProduct 
                    // W-015877 - add AND Product.isActive = true to filter
                    WHERE ProductCategoryId IN :categoryIds AND Product.IsActive = true AND Product.IsQuotable__c = true 
                    // NEW including Is Quoteable filter on Product Category
                    AND ProductCategory.Is_Quotable__c = true
                    // updated SOQL query to Order By these 5 fields - included GradeLevel Sort Order and CategoryType Sort Order
                    ORDER BY ProductCategory.MasterProgramFamily__c ASC,
                      Product.GradeLevel_SortOrder__c ASC, Product.CategoryType_SortOrder__c ASC,
                      Product.Product_Sub_Type__c ASC, Product.Duration__c ASC,
                      Product.ISBN13__c ASC
                    LIMIT 50000];
          
          
          // Add Product Ids from each Category Product to a set
          for (ProductCategoryProduct pcp : returnedPcpList) {
            pcpProductIds.add(pcp.ProductId);
          }

          // using helper method to cut down on reptitious code
          pbePcpTableDataList = getMatchingPricebookEntries(pcpProductIds, quote.SBQQ__PriceBook__c, quote.CurrencyIsoCode, returnedPcpList);

          return pbePcpTableDataList;
      }
      catch (Exception e) {
        // return empty list if SOQL does return any data
        // prints an error message in dev console
        System.debug('Error occurred - ' + e.getMessage());
        return pbePcpTableDataList;
      } 
    }

    /*
    *********************************************************
    Method Name    : insertSelectedProducts
    Author         : Frank Berni
    Description    : inserts SBQQ__QuoteLine__c records for every categoryProduct Id on the parent SBQQ__Quote__c
    Param          : List<String> selectedCatProductIds, Id recordId
    return         : 
    ********************************************************
    */
    @AuraEnabled
    public static void insertSelectedProducts(List<String> selectedCatProductIds, Id recordId) {
        System.debug('selectedCatProductIds - ' + selectedCatProductIds);
        
        List<SBQQ__QuoteLine__c> qlsToInsert = new List<SBQQ__QuoteLine__c>();

        // W-015877 make sure we pull in currencyIsoCode
        // Retrieve the quote record
        SBQQ__Quote__c quote = [SELECT Id, SBQQ__PriceBook__c, CurrencyIsoCode FROM SBQQ__Quote__c WHERE Id = :recordId];
        System.debug('quote - ' + quote);

        // Generate ProductCatMap with 
        Map<Id, ProductCategoryProduct> productToCatProductMap = new Map<Id, ProductCategoryProduct>();
        Set<Id> productIdSet = new Set<Id>();
        // Create map of Id to categoryProducts
        Map<Id, ProductCategoryProduct> catProductMap = new Map<Id, ProductCategoryProduct>();


        // Updated query to include Product.Product_Status_ID__c
        // Query ProductCategoryProduct records with Product2 fields
        List<ProductCategoryProduct> selectedCatProductList = [
          SELECT Id, ProductCategoryId, ProductId, ProductCategory.Name,
                Product.Name, Product.Audience__c, Product.SBQQ__BatchQuantity__c,
                Product.SBQQ__BillingFrequency__c, Product.SBQQ__BillingType__c, Product.CategoryType__c,
                Product.SBQQ__ChargeType__c, Product.SBQQ__CostEditable__c,
                Product.SBQQ__DefaultQuantity__c, Product.Discount_Code__c,
                Product.SBQQ__GenerateContractedPrice__c, Product.SBQQ__HasConsumptionSchedule__c,
                Product.SBQQ__Hidden__c, Product.ISBN13__c, Product.MasterProgram__c,
                Product.Net_Price__c, Product.SBQQ__NonDiscountable__c, Product.ProductType__c,
                Product.SBQQ__NonPartnerDiscountable__c, Product.SBQQ__Optional__c, Product.SBQQ__PriceEditable__c,
                Product.SBQQ__PricingMethod__c, Product.SBQQ__PricingMethodEditable__c,
                Product.ProductCode, Product.Description, Product.Service_Type__c,
                Product.StandardCost__c, Product.SBQQ__SubscriptionTerm__c,
                Product.SBQQ__SubscriptionType__c, Product.SBQQ__TaxCode__c, Product.SBQQ__Taxable__c,
                Product.SBQQ__TermDiscountSchedule__c, Product.Product_Type_Id__c, Product.Freight_Code__c, Product.GradeLevel_SortOrder__c, Product.CategoryType_SortOrder__c,
                Display_sequence__c, Product.Product_Status_ID__c
          FROM ProductCategoryProduct 
          WHERE Id IN :selectedCatProductIds
          LIMIT 50000
        ];
        
        // Looping through returned ProductCategoryProduct records
        for (ProductCategoryProduct pcp : selectedCatProductList) {
          // Populating map with Id and ProductCategoryProduct
          productToCatProductMap.put(pcp.ProductId, pcp);
          // Adding parent Product Id to Set
          productIdSet.add(pcp.ProductId);
          // populate the new map of catProducts with its Id and record
          catProductMap.put(pcp.Id, pcp);
        }
        
        // W-015877 make sure we use in the quote's currencyIsoCode so it pulls in the correct matching pbe
        // Query pricebookentries matching ProductIdSet and Quote's PricebookId
        List<PricebookEntry> selectedPbes = [
            SELECT Id, Product2Id, UnitPrice, ProductCode 
            FROM PricebookEntry 
            WHERE Product2Id IN :productIdSet AND Pricebook2Id = :quote.SBQQ__PriceBook__c AND CurrencyIsoCode = :quote.CurrencyIsoCode LIMIT 50000
            ];
        
        // Populate map of Product to PricebookEntry
        Map<Id, PricebookEntry> productToPbeMap = new Map<Id, PricebookEntry>();
        for (PricebookEntry pbe : selectedPbes) {
            productToPbeMap.put(pbe.Product2Id, pbe);
        }

        // loop through catProductId map keySet
        for (Id catProductId : catProductMap.keySet()) {
            // grabbing the rest of the categoryProduct
            ProductCategoryProduct categoryProduct = catProductMap.get(catProductId);
            // setting new variable for productId from categoryProduct
            Id productId = categoryProduct.ProductId;
            // grabbing related pricebook entry
            PricebookEntry relatedPbe = productToPbeMap.get(productId);
            
            // New additional fields for Quote Line added, Quantity fields have been hardcoded to 0
            // Create a new Quote Line Item and map fields
            SBQQ__QuoteLine__c ql = new SBQQ__QuoteLine__c();
            ql.Audience__c = categoryProduct.Product.Audience__c;
            ql.Category__c = categoryProduct.ProductCategory.Name;
            ql.CategoryType__c = categoryProduct.Product.CategoryType__c; // This doesn't exist in Dev4
            ql.SBQQ__Description__c = categoryProduct.Product.Description;
            ql.Discount_Code__c = categoryProduct.Product.Discount_Code__c;
            ql.FWO_Quantity__c = 0;
            // ProductCode is essentially ISBN13, assigning it to QL
            ql.ISBN13__c = categoryProduct.Product.ProductCode;
            ql.MasterProgram__c = categoryProduct.Product.MasterProgram__c;
            ql.Paid_Quantity__c = 0;
            ql.SBQQ__Product__c = productId;
            ql.ProductCategory__c = categoryProduct.ProductCategoryId;
            ql.ProductType__c = categoryProduct.Product.ProductType__c;
            ql.SBQQ__BatchQuantity__c = categoryProduct.Product.SBQQ__BatchQuantity__c;
            ql.SBQQ__BillingFrequency__c = categoryProduct.Product.SBQQ__BillingFrequency__c;
            ql.SBQQ__BillingType__c = categoryProduct.Product.SBQQ__BillingType__c;
            ql.SBQQ__ChargeType__c = categoryProduct.Product.SBQQ__ChargeType__c;
            ql.SBQQ__CostEditable__c =  categoryProduct.Product.SBQQ__CostEditable__c;
            ql.SBQQ__GenerateContractedPrice__c =  categoryProduct.Product.SBQQ__GenerateContractedPrice__c;
            ql.SBQQ__HasConsumptionSchedule__c =  categoryProduct.Product.SBQQ__HasConsumptionSchedule__c;
            ql.SBQQ__Hidden__c =  categoryProduct.Product.SBQQ__Hidden__c;
            // Adding PricebookEntry price unless the relatedPbe is null
            ql.SBQQ__ListPrice__c =  (relatedPbe == null) ? categoryProduct.Product.Net_Price__c : relatedPbe.UnitPrice;
            ql.SBQQ__NonDiscountable__c =  categoryProduct.Product.SBQQ__NonDiscountable__c;
            ql.SBQQ__NonPartnerDiscountable__c =  categoryProduct.Product.SBQQ__NonPartnerDiscountable__c;
            ql.SBQQ__Optional__c =  categoryProduct.Product.SBQQ__Optional__c;
            // Assigning null if no PBE exists for Product
            ql.SBQQ__PricebookEntryId__c =  (relatedPbe == null) ? null : relatedPbe.Id;
            ql.SBQQ__PriceEditable__c =  categoryProduct.Product.SBQQ__PriceEditable__c;
            ql.SBQQ__PricingMethod__c =  categoryProduct.Product.SBQQ__PricingMethod__c;
            ql.SBQQ__PricingMethodEditable__c =  categoryProduct.Product.SBQQ__PricingMethodEditable__c;
            // Changed so it defaults to 1 instead of 0 to satisfy W-015728
            ql.SBQQ__Quantity__c =  1;
            ql.SBQQ__Quote__c = recordId;
            ql.SBQQ__SubscriptionTerm__c =  categoryProduct.Product.SBQQ__SubscriptionTerm__c;
            // Commenting out SubscriptionType to avoid Apex test issues
            // ql.SBQQ__SubscriptionType__c =  categoryProduct.Product.SBQQ__SubscriptionType__c;
            ql.SBQQ__Taxable__c =  categoryProduct.Product.SBQQ__Taxable__c;
            ql.SBQQ__TaxCode__c =  categoryProduct.Product.SBQQ__TaxCode__c;
            // Assigning null if no Discount Schedule exists for Product
            ql.SBQQ__TermDiscountSchedule__c =  (categoryProduct.Product.SBQQ__TermDiscountSchedule__c == null) ? null : categoryProduct.Product.SBQQ__TermDiscountSchedule__c;
            ql.Service_Type__c =  categoryProduct.Product.Service_Type__c;
            ql.StandardCost__c =  categoryProduct.Product.StandardCost__c;
            ql.Total_Qty__c =  0;
            // Added Product Type Id and Freight Code
            ql.Product_Type_Id__c = categoryProduct.Product.Product_Type_Id__c;
            ql.Freight_Code__c = categoryProduct.Product.Freight_Code__c;
            ql.Display_Sequence__c = categoryProduct.Display_sequence__c;
            // Added Product Status Id
            ql.Product_Status_ID__c = categoryProduct.Product.Product_Status_ID__c;
            ql.CategoryType_SortOrder__c = categoryProduct.Product.CategoryType_SortOrder__c;
            ql.GradeLevel_SortOrder__c = categoryProduct.Product.GradeLevel_SortOrder__c;
            // NEW W-016463 - Product.Description to DescriptionLongText__c to support output doc special characters
            ql.DescriptionLongText__c = categoryProduct.Product.Description;
            qlsToInsert.add(ql);
        }
        
        // Insert the Quote Line Items
        if (!qlsToInsert.isEmpty()) {
            System.debug('qlsToInsert inserted - ' + qlsToInsert);
            Database.insert(qlsToInsert);
        }
    }
    
    /*
    *********************************************************
    Method Name    : getQuoteLines
    Author         : Frank Berni
    Description    : queries quote lines for the quote and displays them in the CpqProductCart
    Param          : Id recordId
    return         : List<SBQQ__QuoteLine__c>
    ********************************************************
    */
    @AuraEnabled(cacheable=true)
    public static List<SBQQ__QuoteLine__c> getQuoteLines(Id recordId){
      try {
        System.debug('recordId - ' + recordId);

        // Adding Product's Description to query to fix special character error in cpqProductCart table
        // querying all quote lines for the parent quote
        List<SBQQ__QuoteLine__c> quoteLineList = [
            SELECT Id, ISBN13__c, SBQQ__Description__c, SBQQ__Product__r.Description, Audience__c, Category__c, SBQQ__ListPrice__c, CurrencyIsoCode  
            FROM SBQQ__QuoteLine__c 
            WHERE SBQQ__Quote__c =:recordId 
            // Order By CreatedDate as ASC so qls sort by earliest to latest
            ORDER BY CreatedDate ASC
            LIMIT 50000
          ];
          
          System.debug('quoteLineList - ' + quoteLineList);

          return quoteLineList;
        
      } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
      }
    }

    /*
    *********************************************************
    Method Name    : getCategoryProductsBySearchTerm
    Author         : Frank Berni
    Description    : W-014412: Alternative method to query ProductCategoryProducts by ISBN13/Product Code or Description and matches Quote's Pricebook
    Param          : String searchString
    return         : List<ProductTableData>
    ********************************************************
    */
    @AuraEnabled(cacheable=true)
    public static List<ProductTableData> getCategoryProductsBySearchTerm(String searchString, Id recordId){
      
      // set up searchTerm with wild card for partial matches
      String searchTerm = '%' + searchString + '%'; 
      List<ProductCategoryProduct> returnedPcpList = new List<ProductCategoryProduct>();
      // wrapper class is used to represent the products
      List<ProductTableData> pbePcpTableDataList = new List<ProductTableData>();
      Set<Id> pcpProductIds = new Set<Id>();
      
      try {
        // Retrieve the quote record
        SBQQ__Quote__c quote = [SELECT Id, SBQQ__PriceBook__c, CurrencyIsoCode FROM SBQQ__Quote__c WHERE Id = :recordId];
        System.debug('quote - ' + quote);

        // W-016058 replace GradeBand with Grade_Level
        // Queries products based on Product.ProductCode or Product.Description searched (ISBN13__c used additionally) 
        returnedPcpList = [SELECT Id, ProductId, Product.ProductCode, Product.ISBN13__c, Product.Name, Product.Audience__c, Product.Net_Price__c,
                          Product.Description, Product.Product_Sub_Type__c,  
                          Product.Grade_Level__c, Product.Copyright_Year__c, Product.Duration__c, Product.Solution_Type__c,
                          Product.Program_Series__c
                          , ProductCategory.Name, ProductCategory.ParentCategory.Name
                FROM ProductCategoryProduct 
                // W-015877 - add AND Product.isActive = true to filter
                WHERE (Product.ProductCode LIKE :searchTerm OR Product.Description LIKE :searchTerm OR Product.ISBN13__c LIKE :searchTerm)
                AND Product.IsActive = true
                AND Product.IsQuotable__c = true
                // NEW including Is Quoteable filter on Product Category
                AND ProductCategory.Is_Quotable__c = true
                // updated SOQL query to Order By these 5 fields - included GradeLevel Sort Order and CategoryType Sort Order
                ORDER BY ProductCategory.MasterProgramFamily__c ASC,
                  Product.GradeLevel_SortOrder__c ASC, Product.CategoryType_SortOrder__c ASC,
                  Product.Product_Sub_Type__c ASC, Product.Duration__c ASC,
                  Product.ISBN13__c ASC
                LIMIT 50000];
        System.debug('returnedPcpList - ' + returnedPcpList);

        // Add Product Ids from each Category Product to a set
        for (ProductCategoryProduct pcp : returnedPcpList) {
          pcpProductIds.add(pcp.ProductId);
        }
        System.debug('pcpProductIds - ' + pcpProductIds);

        // using helper method to cut down on reptitious code
        pbePcpTableDataList = getMatchingPricebookEntries(pcpProductIds, quote.SBQQ__PriceBook__c, quote.CurrencyIsoCode, returnedPcpList);

        return pbePcpTableDataList;
        
      } catch (Exception e) {
        // return empty list if SOQL does return any data
        System.debug('Error occurred - ' + e.getMessage());
        return pbePcpTableDataList;
      }
    }

    /*
    *********************************************************
    Method Name    : getMatchingPricebookEntries
    Author         : Frank Berni
    Description    : Pairs Product Category Product with its Pricebook Entry counterpart on the parent quote and assigns their field values to ProductTableData wrapper class
    Param          : Set<Id> pcpProductIds, Id pricebookId, String currencyIsoCode, List<ProductCategoryProduct> pcpList
    return         : List<ProductTableData>
    ********************************************************
    */
    private static List<ProductTableData> getMatchingPricebookEntries (Set<Id> pcpProductIds, Id pricebookId, String currencyIsoCode, List<ProductCategoryProduct> pcpList) {

      List<ProductTableData> pbePcpTableDataList = new List<ProductTableData>();
      // Set<Id> pbeProductIds = new Set<Id>();
      Map<Id, PricebookEntry> productToPbeMap = new Map<Id, PricebookEntry>();

        // Query pricebookentries matching ProductIds from Category Products and Quote's PricebookId
        List<PricebookEntry> matchingPbeList = [
          SELECT Id, Product2Id, ProductCode, UnitPrice 
          , CurrencyIsoCode 
          FROM PricebookEntry 
          WHERE Product2Id IN :pcpProductIds AND Pricebook2Id = :pricebookId AND CurrencyIsoCode = :currencyIsoCode LIMIT 50000
        ];
        System.debug('matchingPbeList - ' + matchingPbeList);

        // Populate map with Product Id to Pricebook Entry
        for (PricebookEntry pbe : matchingPbeList) {
          productToPbeMap.put(pbe.Product2Id, pbe);
        }
        
        // Debugging to make sure ProductCode doesn't list in Exponential Notation
        for (ProductCategoryProduct pcp : pcpList) {

          // Check if this Category Product has it Product in the Quote's Pricebook
          if (productToPbeMap.containsKey(pcp.ProductId)) {

          PricebookEntry relatedPbe = productToPbeMap.get(pcp.ProductId);

            // reformat ProductCode to avoid Exponential Notation
            pcp.Product.ProductCode = String.valueOf(pcp.Product.ProductCode);

            
            String parentAndCategoryName = ''; 
            if (pcp.ProductCategory.ParentCategory.Name != null) {
              // Concatenating the Category's Parent Category Name with its Name to prevent confusion with duplicate products
              parentAndCategoryName = pcp.ProductCategory.ParentCategory.Name + ' ' +  pcp.ProductCategory.Name;
            } else {
              // If ParentCategory Name is null then just use the Product Category Name instead
              parentAndCategoryName = pcp.ProductCategory.Name;
            }

             // Add this filtered Category Product as a ProductTableData to a new list
            pbePcpTableDataList.add(
            new ProductTableData(
              pcp.Id,
              pcp.Product.ProductCode,
              parentAndCategoryName,
              pcp.Product.Description,
              pcp.Product.Audience__c,
              pcp.Product.Product_Sub_Type__c,
              pcp.Product.Program_Series__c,
              // W-016058 replace GradeBand with Grade_Level
              pcp.Product.Grade_Level__c,
              pcp.Product.Solution_Type__c,
              pcp.Product.Duration__c,
              pcp.Product.Copyright_Year__c,
              relatedPbe.UnitPrice,
              relatedPbe.CurrencyIsoCode
            )
          );
        }
      }

      System.debug('pbePcpTableDataList - ' + pbePcpTableDataList);
      return pbePcpTableDataList;

    }
    
}