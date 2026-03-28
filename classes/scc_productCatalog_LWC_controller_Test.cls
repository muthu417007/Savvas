/***************************************************************************************
* @Class Name: scc_productCatalog_LWC_controller_Test
* @Description: 
* @Created By: Sudha Rani Pathivada
* @Created On: -5/22/2024
* *************************************************************************************
* Modification Log:-5/22/2024
* -------------------------------------------------------------------------------------
* Developer        Date            Description
* -------------------------------------------------------------------------------------
*/
@isTest
public class scc_productCatalog_LWC_controller_Test {
    private static User communityUser;
    private static final String CATALOG_NAME = 'Savvas CPQ Catalog';
    
    @testSetup
    static void setupTestData() {
        System.debug('Starting test data setup');
        try {
            // Create Product Catalog
            ProductCatalog catalog = new ProductCatalog(Name = CATALOG_NAME);
            insert catalog;
            System.debug('Created catalog: ' + catalog);
            
            // Verify catalog creation
            List<ProductCatalog> insertedCatalog = [SELECT Id FROM ProductCatalog WHERE Name = :CATALOG_NAME];
            System.assert(!insertedCatalog.isEmpty(), 'Product Catalog not created');
            
            // Create Parent Category
            ProductCategory parentCategory = new ProductCategory(
                Name = 'Parent Category',
                CatalogId = catalog.Id,
                myOrders_exclude__c = false,
                SortOrder = 1,
                CollectionID__c = '987'
            );
            insert parentCategory;
            System.debug('Created parent category: ' + parentCategory);
            
            // Create Child Category
            ProductCategory childCategory = new ProductCategory(
                Name = 'Child Category',
                ParentCategoryId = parentCategory.Id,
                CatalogId = catalog.Id,
                myOrders_exclude__c = false,
                SortOrder = 1,
                CollectionID__c = '9879'
            );
            insert childCategory;
            System.debug('Created child category: ' + childCategory);
            
            // Create products using TestDataFactory
            Product2 product1 = scc_TestDataFactory.productCreation1();
            Product2 product2 = scc_TestDataFactory.productCreation2();
            System.debug('Created products: ' + product1.Id + ', ' + product2.Id);
            
            // Ensure Standard Pricebook is active
            Id standardPricebookId = Test.getStandardPricebookId();
            Pricebook2 standardPricebook = new Pricebook2(
                Id = standardPricebookId,
                IsActive = true
            );
            update standardPricebook;
            
            // Create PricebookEntry records
            List<PricebookEntry> pricebookEntries = new List<PricebookEntry>{
                new PricebookEntry(
                    Pricebook2Id = standardPricebookId,
                    Product2Id = product1.Id,
                    UnitPrice = 100.00,
                    IsActive = true,
                    CurrencyIsoCode = 'USD'
                ),
                new PricebookEntry(
                    Pricebook2Id = standardPricebookId,
                    Product2Id = product2.Id,
                    UnitPrice = 150.00,
                    IsActive = true,
                    CurrencyIsoCode = 'USD'
                )
            };
            insert pricebookEntries;
            System.debug('Created pricebook entries: ' + pricebookEntries);
            
            // Link products to categories
            List<ProductCategoryProduct> categoryProducts = new List<ProductCategoryProduct>{
                new ProductCategoryProduct(
                    ProductCategoryId = childCategory.Id,
                    ProductId = product1.Id
                ),
                new ProductCategoryProduct(
                    ProductCategoryId = childCategory.Id,
                    ProductId = product2.Id
                )
            };
            insert categoryProducts;
            System.debug('Created category-product links: ' + categoryProducts);
            
            // Verify all test data
            verifyTestData();
            
        } catch(Exception e) {
            System.debug('Error in test setup: ' + e.getMessage() + '\n' + e.getStackTraceString());
            throw e;
        }
    }
    
    private static void verifyTestData() {
        // Verify all required test data exists
        List<ProductCatalog> catalogs = [SELECT Id FROM ProductCatalog];
        List<ProductCategory> categories = [SELECT Id FROM ProductCategory];
        List<Product2> products = [SELECT Id FROM Product2];
        List<PricebookEntry> pricebookEntries = [SELECT Id FROM PricebookEntry WHERE CurrencyIsoCode = 'USD'];
        List<ProductCategoryProduct> categoryProducts = [SELECT Id FROM ProductCategoryProduct];
        
        System.assertNotEquals(0, catalogs.size(), 'Product Catalog not created');
        System.assertNotEquals(0, categories.size(), 'Categories not created');
        System.assertNotEquals(0, products.size(), 'Products not created');
        System.assertNotEquals(0, pricebookEntries.size(), 'Pricebook entries not created');
        System.assertNotEquals(0, categoryProducts.size(), 'Category-Product links not created');
    }
    
    private static User getTestUser() {
        if (communityUser == null) {
            try {
                // Create test account
                Account testAccount = scc_TestDataFactory.accountCreation2('Test School');
                System.assertNotEquals(null, testAccount.Id, 'Failed to create test account');
                
                // Create test contact
                Contact testContact = scc_TestDataFactory.contactCreation(
                    testAccount.Id,
                    'Test',
                    'User',
                    'testuser@test.com'
                );
                System.assertNotEquals(null, testContact.Id, 'Failed to create test contact');
                
                // Create test user
                communityUser = scc_TestDataFactory.userCreation(testContact.Id);
                System.assertNotEquals(null, communityUser.Id, 'Failed to create test user');
                System.assert(communityUser.IsActive, 'Test user is not active');
                
            } catch(Exception e) {
                System.debug('Error creating test user: ' + e.getMessage() + '\n' + e.getStackTraceString());
                throw e;
            }
        }
        return communityUser;
    }
    
   @isTest
static void testGetProductCountMap() {
    Test.startTest();
    
    try {
        // Get categories that actually have products
        List<ProductCategoryProduct> categoryProducts = [
            SELECT ProductCategoryId 
            FROM ProductCategoryProduct 
            WHERE ProductId IN (SELECT Id FROM Product2)
        ];
        
        Set<Id> categoryIds = new Set<Id>();
        for(ProductCategoryProduct catProd : categoryProducts) {
            categoryIds.add(catProd.ProductCategoryId);
        }
        
        System.assertNotEquals(0, categoryIds.size(), 'No categories with products found for testing');
        
        // Test the method
        Map<Id, Integer> productCountMap = scc_ProductCatalogApexClass.getProductCountMap(categoryIds);
        
        // Verify results
        System.assertNotEquals(null, productCountMap, 'Product count map should not be null');
        System.assertNotEquals(0, productCountMap.size(), 'Product count map should not be empty');
        
        for(Id categoryId : categoryIds) {
            System.assert(productCountMap.containsKey(categoryId), 
                        'Product count map should contain category ID: ' + categoryId);
            System.assert(productCountMap.get(categoryId) > 0,
                        'Product count should be greater than 0 for category: ' + categoryId);
        }
        
    } catch(Exception e) {
        System.debug('Error in testGetProductCountMap: ' + e.getMessage());
        throw e;
    }
    
    Test.stopTest();
}
    
    @isTest
    static void testRetrieveProductCategory() {
        Test.startTest();
        
        try {
            List<scc_ProductCatalogApexClass.ProductCategoryWrapper> result = 
                scc_ProductCatalogApexClass.retrieveProductCategory('CA,NATL');
            
            System.assertNotEquals(null, result, 'Result should not be null');
            System.assertNotEquals(0, result.size(), 'Should return product categories');
            
            // Verify wrapper contents
            for(scc_ProductCatalogApexClass.ProductCategoryWrapper wrapper : result) {
                System.assertNotEquals(null, wrapper.productCategoryId, 'Category ID should not be null');
                System.assertNotEquals(null, wrapper.productCategoryName, 'Category name should not be null');
            }
            
        } catch(Exception e) {
            System.debug('Error in testRetrieveProductCategory: ' + e.getMessage());
            throw e;
        }
        
        Test.stopTest();
    }
    
   @isTest
static void testGetProductDetails() {
    Test.startTest();
    
    try {
        List<Product2> products = [SELECT Id, ProductCode FROM Product2 WHERE ProductCode != null LIMIT 2];
        System.assertNotEquals(0, products.size(), 'No products with ProductCode found for testing');
        
        List<Id> productIds = new List<Id>();
        for(Product2 prod : products) {
            productIds.add(prod.Id);
        }
        
        List<scc_ProductCatalogApexClass.ProductWrapper> result = 
            scc_ProductCatalogApexClass.getProductDetails(productIds);
        
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertNotEquals(0, result.size(), 'Should return product details');
        
        // Verify wrapper contents
        for(scc_ProductCatalogApexClass.ProductWrapper wrapper : result) {
            System.assertNotEquals(null, wrapper.productId, 'Product ID should not be null');
            
            // Find matching source product
            Product2 sourceProduct;
            for(Product2 prod : products) {
                if(prod.Id == wrapper.productId) {
                    sourceProduct = prod;
                    break;
                }
            }
            
            if(sourceProduct != null && sourceProduct.ProductCode != null) {
                System.assertNotEquals(null, wrapper.ProductCode, 
                    'Product code should not be null for product: ' + wrapper.productId);
            }
        }
        
    } catch(Exception e) {
        System.debug('Error in testGetProductDetails: ' + e.getMessage());
        throw e;
    }
    
    Test.stopTest();
}
    @isTest
    static void testFormatPrice() {
        Test.startTest();
        
        try {
            // Test various price scenarios
            String result1 = scc_ProductCatalogApexClass.formatPrice(1234.56);
            String result2 = scc_ProductCatalogApexClass.formatPrice(1000000.00);
            String result3 = scc_ProductCatalogApexClass.formatPrice(null);
            String result4 = scc_ProductCatalogApexClass.formatPrice(0.00);
            
            // Verify results
            System.assertEquals('1,234.56', result1, 'Should format price correctly');
            System.assertEquals('1,000,000.00', result2, 'Should format large numbers correctly');
            System.assertEquals(null, result3, 'Should handle null values');
            System.assertEquals('0.00', result4, 'Should handle zero values');
            
        } catch(Exception e) {
            System.debug('Error in testFormatPrice: ' + e.getMessage());
            throw e;
        }
        
        Test.stopTest();
    }
    
    @isTest
    static void testHasProducts() {
        Test.startTest();
        
        try {
            // Get a valid category with products
            ProductCategoryProduct categoryProduct = [SELECT ProductCategoryId 
                                                    FROM ProductCategoryProduct 
                                                    LIMIT 1];
            
            Map<Id, Integer> productCountMap = new Map<Id, Integer>();
            productCountMap.put(categoryProduct.ProductCategoryId, 5);
            
            // Test positive case
            Boolean hasProductsResult = scc_ProductCatalogApexClass.hasProducts(
                categoryProduct.ProductCategoryId, 
                productCountMap
            );
            System.assert(hasProductsResult, 'Should return true for category with products');
            
            // Test negative case
            productCountMap.put(categoryProduct.ProductCategoryId, 0);
            Boolean noProductsResult = scc_ProductCatalogApexClass.hasProducts(
                categoryProduct.ProductCategoryId, 
                productCountMap
            );
            System.assert(!noProductsResult, 'Should return false for category without products');
            
        } catch(Exception e) {
            System.debug('Error in testHasProducts: ' + e.getMessage());
            throw e;
        }
        
        Test.stopTest();
    }
    
    @isTest
    static void testGetChildRecords() {
        Test.startTest();
        
        try {
            // Get parent category
            ProductCategory parentCategory = [SELECT Id 
                                            FROM ProductCategory 
                                            WHERE ParentCategoryId = null 
                                            LIMIT 1];
            
            Integer childCount = scc_ProductCatalogApexClass.getChildRecords(parentCategory.Id);
            System.assertEquals(1, childCount, 'Should return correct number of child records');
            
        } catch(Exception e) {
            System.debug('Error in testGetChildRecords: ' + e.getMessage());
            throw e;
        }
        
        Test.stopTest();
    }
    
    @isTest
    static void testGetChildRecordsProductData() {
        Account acc= scc_TestDataFactory.accountCreation('testAccount4');
        Contact con = scc_TestDataFactory.contactCreation( acc.Id, 'firstname4', 'testlastname4', 'testemail1@abc.com');
        User testUser=  scc_TestDataFactory.userCreation(con.Id);
        
        Test.startTest();
        
        try {
            // Get child category
            ProductCategory childCategory = [SELECT Id 
                                           FROM ProductCategory 
                                           WHERE ParentCategoryId != null 
                                           LIMIT 1];
            
            List<ProductCategory> result = scc_ProductCatalogApexClass.getChildRecordsProductData(childCategory.Id, 'CA,NATL');
            System.runAs(testUser) {
               List<ProductCategory> result2 = scc_ProductCatalogApexClass.getChildRecordsProductData(childCategory.Id, 'CA,NATL'); 
            }
            System.assertNotEquals(null, result, 'Result should not be null');
            System.assertNotEquals(0, result.size(), 'Should return child product data');
            
        } catch(Exception e) {
            System.debug('Error in testGetChildRecordsProductData: ' + e.getMessage());
            throw e;
        }
        
        Test.stopTest();
    }
    @isTest
static void testRetrieveProductCategoryWithStateFiltering() {
    Test.startTest();
    
    try {
        // Create Account and Contact first
        Account testAccount = scc_TestDataFactory.accountCreation2('Test School');
        Contact testContact = scc_TestDataFactory.contactCreation(
            testAccount.Id,
            'Test',
            'User',
            'test@testuser.com'
        );
        
        // Create external user using the TestDataFactory
        User testUser = scc_TestDataFactory.userCreation(testContact.Id);

        // Create test data
        Product2 product = new Product2(
            Name = 'State Specific Product',
            ProductCode = 'SSP-001',
            IsActive = true,
            Program_Series__c = 'CA',
            IsDuplicate__c = false
        );
        insert product;

        // Get existing category
        ProductCategory category = [SELECT Id FROM ProductCategory WHERE ParentCategoryId = null LIMIT 1];
        
        // Link product to category
        ProductCategoryProduct categoryProduct = new ProductCategoryProduct(
            ProductCategoryId = category.Id,
            ProductId = product.Id
        );
        insert categoryProduct;

        // Run test as external user
        System.runAs(testUser) {
            List<scc_ProductCatalogApexClass.ProductCategoryWrapper> result = 
                scc_ProductCatalogApexClass.retrieveProductCategory('CA,NATL');

            System.assertNotEquals(0, result.size(), 'Should return product categories');
            
            for(scc_ProductCatalogApexClass.ProductCategoryWrapper wrapper : result) {
                if(wrapper.productCategoryId == category.Id) {
                    System.assertNotEquals(null, wrapper.productCategoryName, 'Category name should not be null');
                }
            }
        }
        
    } catch(Exception e) {
        System.debug('Error in testRetrieveProductCategoryWithStateFiltering: ' + e.getMessage());
        throw e;
    }
    
    Test.stopTest();
}

/**@isTest
static void testProductCategoryWithMultipleStates() {
    Test.startTest();
    
    try {
        // Create Account and Contact
        Account testAccount = scc_TestDataFactory.accountCreation2('Test School');
        Contact testContact = scc_TestDataFactory.contactCreation(
            testAccount.Id,
            'Test',
            'User',
            'test2@testuser.com'
        );
        
        // Create external user using the TestDataFactory
        User testUser = scc_TestDataFactory.userCreation(testContact.Id);

        // Create products for different states
        List<Product2> products = new List<Product2>{
            new Product2(
                Name = 'CA Product',
                ProductCode = 'CA-001',
                IsActive = true,
                Program_Series__c = 'CA',
                IsDuplicate__c = false
            ),
            new Product2(
                Name = 'TX Product',
                ProductCode = 'TX-001',
                IsActive = true,
                Program_Series__c = 'TX',
                IsDuplicate__c = false
            ),
            new Product2(
                Name = 'National Product',
                ProductCode = 'NATL-001',
                IsActive = true,
                Program_Series__c = 'NATL',
                IsDuplicate__c = false
            )
        };
        insert products;

        // Get existing category
        ProductCategory category = [SELECT Id FROM ProductCategory WHERE ParentCategoryId = null LIMIT 1];
        
        // Link products to category
        List<ProductCategoryProduct> categoryProducts = new List<ProductCategoryProduct>();
        for(Product2 prod : products) {
            categoryProducts.add(new ProductCategoryProduct(
                ProductCategoryId = category.Id,
                ProductId = prod.Id
            ));
        }
        insert categoryProducts;

        // Run test as external user
        System.runAs(testUser) {
            // Test with multiple states
            List<scc_ProductCatalogApexClass.ProductCategoryWrapper> result1 = 
                scc_ProductCatalogApexClass.retrieveProductCategory('CA,TX');
            System.assertNotEquals(0, result1.size(), 'Should return categories for CA,TX');

            // Test with single state
            List<scc_ProductCatalogApexClass.ProductCategoryWrapper> result2 = 
                scc_ProductCatalogApexClass.retrieveProductCategory('CA');
            System.assertNotEquals(0, result2.size(), 'Should return categories for CA');

            // Test with NATL included
            List<scc_ProductCatalogApexClass.ProductCategoryWrapper> result3 = 
                scc_ProductCatalogApexClass.retrieveProductCategory('CA,NATL');
            System.assertNotEquals(0, result3.size(), 'Should return categories for CA,NATL');
        }
        
    } catch(Exception e) {
        System.debug('Error in testProductCategoryWithMultipleStates: ' + e.getMessage());
        throw e;
    }
    
    Test.stopTest();
}**/
}