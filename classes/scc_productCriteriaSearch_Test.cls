/***************************************************************************************
 * @Test Class Name: scc_productCriteriaSearch_Test
 * @Description: Test class for the public class scc_productCriteriaSearch Apex class.
 * @Created By: Sanika Sol
 * @Created On: 17/04/2024
 * *************************************************************************************
 * Modification Log:
 * -------------------------------------------------------------------------------------
 * Developer        Date            Description

 * -------------------------------------------------------------------------------------
 */
@isTest
private class scc_productCriteriaSearch_Test {

    @TestSetup
    static void setupTestData() {
        // Create test products
        List<Product2> testProducts = new List<Product2>();
        
        testProducts.add(new Product2(
            Name = 'Better Business',
            Discipline__c = 'SPECIAL MARKETS',
            ISBN10__c = '0134522745',
            ISBN13__c = '9780134522746',
            Description = 'BETTER BUSINESS',
            Product_Sub_Type__c = 'Pupil Text Hardcover',
            Grade_Level__c = 'CU',
            Copyright_Year__c = '2023',
            Product_Status__c = 'IN PRINT',
            Net_Price__c = 124.99,
            IsActive = true,
            Material_Type_ID__c = 'ZSBN',
            SAP_C__c = true
        ));
        
        testProducts.add(new Product2(
            Name = 'Inactive Product',
            Discipline__c = 'SPECIAL MARKETS',
            ISBN10__c = '1234567890',
            ISBN13__c = '9781234567897',
            Description = 'INACTIVE PRODUCT',
            Product_Sub_Type__c = 'Pupil Text Softcover',
            Grade_Level__c = 'HS',
            Copyright_Year__c = '2022',
            Product_Status__c = 'OUT OF PRINT',
            Net_Price__c = 99.99,
            IsActive = false,
            Material_Type_ID__c = 'ZKPK',
            SAP_C__c = false
        ));
        
        insert testProducts;
    }

    @isTest
    static void testSearchProducts_NoParameters() {
        Test.startTest();
        List<scc_productCriteriaSearch.ProductWrapper> products = scc_productCriteriaSearch.searchProducts(null, null, null, false);
        Test.stopTest();

        System.assertNotEquals(0, products.size(), 'Should return products without parameters');
        System.assertEquals(2, products.size(), 'Should return all test products');
    }

    @isTest
    static void testSearchProducts_WithISBN() {
        Test.startTest();
        List<scc_productCriteriaSearch.ProductWrapper> products = scc_productCriteriaSearch.searchProducts('9780134522746', null, null, false);
        Test.stopTest();

        System.assertEquals(1, products.size(), 'Should return one product with the given ISBN');
        System.assertEquals('9780134522746', products[0].ISBN, 'ISBN should match');
    }

    @isTest
    static void testSearchProducts_WithDiscipline() {
        Test.startTest();
        List<scc_productCriteriaSearch.ProductWrapper> products = scc_productCriteriaSearch.searchProducts(null, 'SPECIAL MARKETS', null, false);
        Test.stopTest();

        System.assertNotEquals(0, products.size(), 'Should return products with the given discipline');
    }

    @isTest
    static void testSearchProducts_WithTitleKeyword() {
        Test.startTest();
        List<scc_productCriteriaSearch.ProductWrapper> products = scc_productCriteriaSearch.searchProducts(null, null, 'BETTER', false);
        Test.stopTest();

        System.assertEquals(1, products.size(), 'Should return one product with the given keyword');
        System.assert(products[0].Title_Description.contains('BETTER'), 'Title should contain the keyword');
    }

    @isTest
    static void testSearchProducts_ActiveProductsOnly() {
        Test.startTest();
        List<scc_productCriteriaSearch.ProductWrapper> products = scc_productCriteriaSearch.searchProducts(null, null, null, true);
        Test.stopTest();

        System.assertEquals(1, products.size(), 'Should return only active products');
        System.assert(products[0].IsActive, 'Returned product should be active');
    }

    @isTest
    static void testSearchProducts_InactiveProducts() {
        Test.startTest();
        List<scc_productCriteriaSearch.ProductWrapper> products = scc_productCriteriaSearch.searchProducts(null, null, 'INACTIVE', false);
        Test.stopTest();

        System.assertEquals(1, products.size(), 'Should return inactive product');
        System.assert(!products[0].IsActive, 'Returned product should be inactive');
    }

    @isTest
    static void testPadZerosLeft() {
        System.assertEquals('0000012345', scc_productCriteriaSearch.padZerosLeft('12345', 10), 'Should pad zeros to the left');
        System.assertEquals('12345', scc_productCriteriaSearch.padZerosLeft('12345', 5), 'Should not pad when length is equal');
        System.assertEquals('12345', scc_productCriteriaSearch.padZerosLeft('12345', 3), 'Should not truncate when input is longer');
    }
}