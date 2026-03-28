/*********************************************************** 
* @Class Name  - scc_placeOrderMultiISBN_Test
* @description - Test class for scc_PlaceOrderMultiISBN_SearchController
* @Created By  - CTS-Sanika
* @Created On - 20/10/2024
* **********************************************************/ 
@isTest
public class scc_placeOrderMultiISBN_Test {
    /**
*  Description: Below method is test search results
*  @name: testPopulateSearchResults
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void testPopulateSearchResults() {
        // Test data setup: creating 4 products with valid ISBNs
        List<Product2> testProducts = new List<Product2>();
        for (Integer i = 0; i < 4; i++) {
            String isbn13 = '978' + String.valueOf(0134905952 + i);
            String isbn10 = '013' + String.valueOf(234455 + i);
            testProducts.add(new Product2(
                Name = 'ProductTest' + i,
                ISBN13__c = isbn13,
                ISBN10__c = isbn10,
                Material_Type_ID__c = 'ZSBN', 
                SAP_A_Check__c = true,
                Net_Price__c = 100,
                Copyright_Year__c = '2020',
                Grade_Level__c = 'CU',
                Product_Sub_Type__c = 'studentEdition',
                IsActive = true,
                
                myOrders_exclude__c = false,
                SAP_C__c = true
            ));
        }
        insert testProducts;
        
        Test.startTest();
        
        // Generate test data
        List<Product2> productList = [SELECT Id, ISBN13__c, ISBN10__c, Sales_Restriction_Code__c,Rights_Restriction_Code__c, Material_Type__c, Product_Sub_Type__c, Description, Grade_Level__c, 
                                      Copyright_Year__c, Product_Status__c, Net_Price__c, SAP_A_Check__c , IsActive
                                      FROM Product2
                                      WHERE IsDeleted = false
                                      AND SAP_A_Check__c = true
                                      AND myOrders_exclude__c = false
                                      AND SAP_C__c = true   and  Name LIKE 'ProductTest%' LIMIT 3];       
        List<String> recordIds = new List<String>();
        for (Product2 prod : productList) {
            if (prod.ISBN13__c != null) {
                recordIds.add(prod.ISBN13__c);
            } else if (prod.ISBN10__c != null) {
                recordIds.add(prod.ISBN10__c);
            }
        }
        
        List<String> recordIds1 = new List<String>{'0134522745'};           
        // Valid scenario
        List<scc_placeOrderMultiISBN_SearchController.ProductWrapper> resultList = scc_placeOrderMultiISBN_SearchController.populateSearchResults(recordIds1, true );
        System.assertnotEquals(1, resultList.size(), 'Correct number of search results should be returned.');        
        // Edge case: No matching products
        List<String> emptyRecordIds = new List<String>{'NonExistentISBN1', 'NonExistentISBN2'};
            List<scc_placeOrderMultiISBN_SearchController.ProductWrapper> emptyResultList = scc_placeOrderMultiISBN_SearchController.populateSearchResults(recordIds, true);
        System.assertEquals(0, emptyResultList.size(), 'No products should be returned for non-matching ISBNs.');
        for (scc_placeOrderMultiISBN_SearchController.ProductWrapper wrapper : resultList) {
            System.assertNotEquals(null, wrapper.product, 'Product should not be null');
            System.assertEquals(null, wrapper.Price, 'Price should be NA for active products');
            System.assertNotEquals(null, wrapper.ISBN, 'ISBN should not be null');
        }
        
        // Error Handling: Query Exception
        try {
            // Error Handling: Null Input
            List<scc_placeOrderMultiISBN_SearchController.ProductWrapper> nullInputResult = scc_placeOrderMultiISBN_SearchController.populateSearchResults(null, true);
            System.assertEquals(0, nullInputResult.size(), 'Expected an empty list for null input.');
        } catch (NullPointerException e) {
            System.assertEquals('Attempt to de-reference a null object', e.getMessage());
        }
        Test.stopTest();
    }

    /**
*  Description: Below method is test pads to left
*  @name: testPadZerosLeft
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void testPadZerosLeft() {
        System.assertEquals('0001234567', scc_placeOrderMultiISBN_SearchController.padZerosLeft('1234567', 10), 'Should pad zeros to the left');
        System.assertEquals('1234567890', scc_placeOrderMultiISBN_SearchController.padZerosLeft('1234567890', 10), 'Should not pad if length is already correct');
        System.assertEquals('0000000123', scc_placeOrderMultiISBN_SearchController.padZerosLeft('123', 10), 'Should pad zeros for short strings');
    }

      /**
*  Description: Below method is tests wrapper with non matching data
*  @name: testWrapperWithNonMatchingData
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void testWrapperWithNonMatchingData() {
        List<Product2> productList1 = [SELECT Id, ISBN13__c, ISBN10__c, Sales_Restriction_Code__c,Rights_Restriction_Code__c, Material_Type__c, Product_Sub_Type__c, Description, Grade_Level__c, 
                                       Copyright_Year__c, Product_Status__c, Net_Price__c, SAP_A_Check__c , IsActive
                                       FROM Product2
                                       WHERE IsDeleted = false
                                       AND SAP_A_Check__c = true
                                       AND myOrders_exclude__c = false
                                       AND SAP_C__c = true   and  Name LIKE 'ProductTest%' LIMIT 3];       
        List<String> paddedRecordIds = new List<String>{'970123456', '012345'};
        
        Test.startTest();
        List<scc_placeOrderMultiISBN_SearchController.ProductWrapper> results = scc_placeOrderMultiISBN_SearchController.populateSearchResults(paddedRecordIds, true);
        Test.stopTest();
        
        System.assertEquals(0, results.size(), 'No products should be returned for non-matching ISBNs');

        if (results.isEmpty()) {            
            Product2 nullProduct = new Product2();
            scc_placeOrderMultiISBN_SearchController.ProductWrapper wrapper = new  scc_placeOrderMultiISBN_SearchController.ProductWrapper (nullProduct, '', nullProduct.id);
            System.assertNotEquals('12345', wrapper.ISBN, 'ISBN should be null in this scenario');
            System.assertNotEquals('123456', wrapper.productId, 'Product ID should be null in this scenario');
            System.assertNotEquals('60', wrapper.Price, 'Price should be null in this scenario');
            System.assertNotEquals('testhelo', wrapper.Title_Description, 'Title Description should be null in this scenario');
            System.assertNotEquals('Ca', wrapper.Grade_Level, 'Grade Level should be null in this scenario');
        }
    }    
}