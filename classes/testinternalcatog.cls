public with sharing class testinternalcatog {
    
    public class ProductWrapper {
        @AuraEnabled public String productId;
        @AuraEnabled public String ISBN;
        @AuraEnabled public Boolean showISBN13Field;
        @AuraEnabled public String Title_Description;
        @AuraEnabled public String Type;
        @AuraEnabled public String Grade_Level;
        @AuraEnabled public String Copyright;
        @AuraEnabled public String Status;
      @AuraEnabled public String UserStatus { get; set; }
        @AuraEnabled public Decimal NetPrice { get; set; }
        @AuraEnabled public Decimal ListPrice { get; set; }
        @AuraEnabled public Decimal Discount { get; set; }
        @AuraEnabled public Decimal DisplayPrice { get; set; }
        @AuraEnabled public String AccountId { get; set; }
        @AuraEnabled public String Country { get; set; }       
        @AuraEnabled public String ProductCode { get; set; }
        @AuraEnabled public String Price { get; set; }
         @AuraEnabled public Boolean isInternalUser { get; set; }
        
    }
    @AuraEnabled(cacheable=true)
    public static List<ProductCategoryWrapper> retrieveProductCategory(){
        List<ProductCategoryWrapper> productCategoryWrapperRecordList = new List<ProductCategoryWrapper>();
        Map<Id, ProductCategory> mapProductCategoryIdToRecord   =   new Map<Id, ProductCategory>([Select Id, Name, ParentCategoryId, (Select Id, Name, ParentCategoryId From ChildCategories) From ProductCategory ORDER BY Name]);
       // system.debug('parent and child records'+mapProductCategoryIdToRecord );
        for(Id productCategoryId : mapProductCategoryIdToRecord.keyset()){
            ProductCategory currentPdtCategory = mapProductCategoryIdToRecord.get(productCategoryId);
            system.debug('currentPdtCategory'+currentPdtCategory );
            if(currentPdtCategory.ParentCategoryId == null){
                ProductCategoryWrapper currentPdtCategoryWrapper = new ProductCategoryWrapper(currentPdtCategory, mapProductCategoryIdToRecord);
                productCategoryWrapperRecordList.add(currentPdtCategoryWrapper);
               // system.debug('productCategoryWrapperRecordList'+productCategoryWrapperRecordList );
            }
        }
        if(productCategoryWrapperRecordList != null && !productCategoryWrapperRecordList.isEmpty()){
            return productCategoryWrapperRecordList;
        }
        return new List<ProductCategoryWrapper>();
    }
    /**********************************************************************************
		* Method Name : getChildRecords
		* Description : Retrieves child records of a product category.
		* Return Type : List<ProductCategory>
*********************************************************************************/
    @AuraEnabled
    Public static Integer getChildRecords(String selectedId){
       // system.debug('getChildRecords'+getChildRecords );
        return [Select Id, Name, ParentCategoryId, (Select Id, Name, ParentCategoryId From ChildCategories) From ProductCategory WHERE ParentCategoryId =: selectedId].size();
     
    }
     /**********************************************************************************
		* Method Name : getChildRecordsProductData
		* Description : Retrieves child records of a product category.
		* Return Type : List<ProductCategory>
*********************************************************************************/
    @AuraEnabled
    Public static List<ProductCategory> getChildRecordsProductData(String selectedRowId){
        List<ProductCategory> products = [SELECT Id, Name, ParentCategory.Id, ParentCategory.Name,
                                          (SELECT Product.Id, Product.Name, Product.ISBN10__c, Product.ISBN13__c,
                                           Product.Description, Product.ProductCode,Product.Product_Sub_Type__c, Product.Grade_Level__c,Product.Copyright_Year__c, Product.Product_Status__c, Product.Net_Price__c
                                           FROM ProductCategoryProducts)
                                          FROM ProductCategory
                                          WHERE Id =: selectedRowId];
       // system.debug('products'+products );
        return products;
    }
     /**********************************************************************************
		* Method Name : getProductDetails
		* Description : Retrieves getProductDetails records of a product category.
		* Return Type : List<ProductCategory>
*********************************************************************************/   
    @AuraEnabled
     public static List<ProductWrapper> getProductDetails(List<Id> prodId) {
       List<ProductWrapper> productData = new List<ProductWrapper>();
    
    try {
        List<Product2> products = [SELECT Id, ISBN10__c, ISBN13__c, Description, Product_Sub_Type__c, Grade_Level__c, 
                                  Copyright_Year__c, Product_Status__c, Net_Price__c, ProductCode
                                  FROM Product2 
                                  WHERE Id IN :prodId];
        List<User> usr = [SELECT Id, Division__c, IsEmployee__c FROM User WHERE Id = :UserInfo.getUserId() AND IsEmployee__c = true];
        
        if (usr.isEmpty() || !usr[0].IsEmployee__c) {
            System.debug('No valid internal user found');
            return new List<ProductWrapper>();
        }
        Boolean InternalUser = usr[0].IsEmployee__c;
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
            wrapper.Price = 'NA';
              Boolean isInternalUser = InternalUser;
            
  		
       if (isInternalUser) {
            if (usr[0].Division__c == 'International') {
                List<PricebookEntry> prices = [SELECT IsActive, UnitPrice, Product2.ProductCode, Pricebook2.Name 
                                               FROM PricebookEntry 
                                               WHERE Pricebook2.Name = 'Standard Price Book' 
                                               AND Product2.ProductCode = :prod.ProductCode 
                                               AND CurrencyIsoCode = 'USD'];
                if (!prices.isEmpty()) {
                     Decimal unitPrice = prices[0].UnitPrice;
                     wrapper.NetPrice = unitPrice;
                                wrapper.ListPrice = unitPrice * 1.333;
                                wrapper.Discount = (wrapper.ListPrice - wrapper.NetPrice) / wrapper.NetPrice * 100;
                                wrapper.UserStatus = 'International';
                                wrapper.DisplayPrice = wrapper.ListPrice;
                }
            }
       else if (usr[0].Division__c == 'K12/School') {
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
                                wrapper.UserStatus = 'Internal US User';
                                wrapper.DisplayPrice = unitPrice;
                   			
                } else {
                    wrapper.Price = 'NA'; // Default value if no price found
                }
            } else {
                wrapper.Price = 'NA'; // Default value for other users
            }
            
           
        }
        
        else{
          wrapper.Price = 'NA'  ;
        }
         productData.add(wrapper);
        }
    } catch (Exception e) {
        System.debug('Error in getProductDetails: ' + e.getMessage());
    }

    System.debug('Data for productData: ' + productData);
    
    return productData; 

}
         
 /**********************************************************************************
		* Method Name : ProductCategoryWrapper
		* Description : Wrapper class for representing a Product Category record in AuraEnabled methods
		* Return Type : List<ProductCategory>
*********************************************************************************/
    public class ProductCategoryWrapper {
        @AuraEnabled public String productCategoryId {get; set;}
        @AuraEnabled public String productCategoryName {get; set;}
        @AuraEnabled public String parentProductCategoryId {get; set;}
        @AuraEnabled public List<ProductCategoryWrapper> childProductCategoryList {get; set;}
        public ProductCategoryWrapper(ProductCategory oneProductCategory, Map<Id, ProductCategory> mapProductCategoryIdToRecord){
            this.productCategoryId = oneProductCategory.Id;
            this.productCategoryName = oneProductCategory.Name;
            this.parentProductCategoryId = oneProductCategory.ParentCategoryId;
            this.childProductCategoryList = convertChildProductSobjectListToWrapperList(oneProductCategory.ChildCategories, mapProductCategoryIdToRecord);
        }
        public List<ProductCategoryWrapper> convertChildProductSobjectListToWrapperList(List<ProductCategory> childProductCategoryList, Map<Id, ProductCategory> mapProductCategoryIdToRecord){
            List<ProductCategoryWrapper> local_ChildProductCategoryList = new List<ProductCategoryWrapper>();
            if(childProductCategoryList != null && !childProductCategoryList.isEmpty()){
                for(ProductCategory oneChildProductCategory : childProductCategoryList){
                    ProductCategory currentProductCategory = mapProductCategoryIdToRecord.containskey(oneChildProductCategory.Id) ? mapProductCategoryIdToRecord.get(oneChildProductCategory.Id) : null;
                    if(currentProductCategory != null){
                        local_childProductCategoryList.add(new ProductCategoryWrapper(currentProductCategory, mapProductCategoryIdToRecord));    
                    }
                    else{
                        local_childProductCategoryList.add(new ProductCategoryWrapper(oneChildProductCategory, mapProductCategoryIdToRecord));    
                    }
                    
                }
                 system.debug('local_ChildProductCategoryList'+local_ChildProductCategoryList );
            }
            return local_ChildProductCategoryList;
            
        }
    }  
}