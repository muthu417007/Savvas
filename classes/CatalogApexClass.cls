public class CatalogApexClass {
    @AuraEnabled(cacheable=true)
    public static List<ProductCategoryWrapper> retrieveProductCategory(){
        List<ProductCategoryWrapper> productCategoryWrapperRecordList = new List<ProductCategoryWrapper>();
        Map<Id, ProductCategory> mapProductCategoryIdToRecord   =   new Map<Id, ProductCategory>([Select Id, Name, ParentCategoryId, (Select Id, Name, ParentCategoryId From ChildCategories) From ProductCategory]);
        system.debug('parent and child records'+mapProductCategoryIdToRecord );
        for(Id productCategoryId : mapProductCategoryIdToRecord.keyset()){
            ProductCategory currentPdtCategory = mapProductCategoryIdToRecord.get(productCategoryId);
            system.debug('currentPdtCategory'+currentPdtCategory );
            if(currentPdtCategory.ParentCategoryId == null){
                ProductCategoryWrapper currentPdtCategoryWrapper = new ProductCategoryWrapper(currentPdtCategory, mapProductCategoryIdToRecord);
                productCategoryWrapperRecordList.add(currentPdtCategoryWrapper);
                system.debug('productCategoryWrapperRecordList'+productCategoryWrapperRecordList );
            }
        }
        if(productCategoryWrapperRecordList != null && !productCategoryWrapperRecordList.isEmpty()){
            return productCategoryWrapperRecordList;
        }
        return new List<ProductCategoryWrapper>();
    }
    
    @AuraEnabled
    Public static Integer getChildRecords(String selectedId){
       // system.debug('getChildRecords'+getChildRecords );
        return [Select Id, Name, ParentCategoryId, (Select Id, Name, ParentCategoryId From ChildCategories) From ProductCategory WHERE ParentCategoryId =: selectedId].size();
     
    }
    
    @AuraEnabled
    Public static List<ProductCategory> getChildRecordsProductData(String selectedRowId){
        List<ProductCategory> products = [SELECT Id, Name, ParentCategory.Id, ParentCategory.Name,
                                          (SELECT Product.Id, Product.Name, Product.ISBN10__c, Product.ISBN13__c,
                                           Product.Description, Product.Product_Sub_Type__c, Product.Grade_Level__c,Product.Copyright_Year__c, Product.Product_Status__c, Product.Net_Price__c
                                           FROM ProductCategoryProducts)
                                          FROM ProductCategory
                                          WHERE Id =: selectedRowId];
        system.debug('products'+products );
        return products;
    }
    
    @AuraEnabled
    Public static List<CatalogSearchResults.ProductWrapper> getProductDetails(List<Id> prodId){
        List<CatalogSearchResults.ProductWrapper> productData = new List<CatalogSearchResults.ProductWrapper>();
        List<Product2> products= [SELECT Id, ISBN10__c, ISBN13__c, Description, Product_Sub_Type__c, Grade_Level__c, 
                                  Copyright_Year__c, Product_Status__c, Net_Price__c 
                                  FROM Product2 
                                  WHERE Id In: prodId];
         system.debug('products'+products );
        for (Product2 prod : products) {
            CatalogSearchResults.ProductWrapper wrapper = new CatalogSearchResults.ProductWrapper();
            wrapper.productId = prod.Id;
            wrapper.ISBN = prod.ISBN13__c != null ? prod.ISBN13__c : prod.ISBN10__c;
            wrapper.showISBN13Field = prod.ISBN13__c != null;
            wrapper.Title_Description = prod.Description;
            wrapper.Type = prod.Product_Sub_Type__c;
            wrapper.Grade_Level = prod.Grade_Level__c;
            wrapper.Copyright = prod.Copyright_Year__c;
            wrapper.Status = prod.Product_Status__c;
            wrapper.Price = prod.Net_Price__c;
            productData.add(wrapper);
        }
        
        return productData;
    }
    
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