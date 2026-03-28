/*
*********************************************************
Class Name       : CpqProductSelectionCtrlTest
Created Date     : 5/06/2024  
Author           : Frank Berni - Cognizant
Description      : Test class for CpqProductSelectionCtrl
Percentage       : 95%

History:
<Date>          <Authors Name>              <Brief Description of Change>
5/06/2024       Frank Berni                 Initial creation
5/07/2024       Frank Berni                 Created 2 unit tests 
5/21/2024       Frank Berni                 Updated test data and added new unit tests for getCategoryProductsBySearchTerm and getPicklistValues
5/22/2024       Frank Berni                 Updated testInsertSelectedProducts and testGetCategoryProductsBySearchTerm to reflect new recordId parameter
6/04/2024       Frank Berni                 Deprecated getPicklistValues test due to removal in apex class
6/14/2024       Frank Berni                 Updated tests for testInsertSelectedProducts and testGetCategoryProductsBySearchTerm to use ProductTableData instead of ProductCategoryProducts
8/13/2024       Frank Berni                 Updated test for testInsertSelectedProducts so it uses a List of Ids as parameter for Multi Select categories
10/08/2024      Frank Berni                 Added isQuotable = true to test products 
**********************************************************/
@IsTest
public class CpqProductSelectionCtrlTest {
    
    /*
    *********************************************************
    Method Name    : setupTestData
    Author         : Frank Berni
    Description    : Inserts test data being used in CpqProductSelectionCtrl
    ********************************************************
    */
    @TestSetup
    static void setupTestData() {

        Id schoolAccId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Schools Account').getRecordTypeId();

        Account acc = new Account();
        acc.RecordTypeId = schoolAccId;
        acc.Name = 'Testing Tykes Elementary';
        acc.Type = 'Public District';
        insert acc;
        System.debug('Account Inserted - ' + acc);

        Opportunity opp = new Opportunity();
        opp.Name = 'Tykes Elem - Envision Core Offerings';
        opp.CloseDate = Date.Today();
        opp.StageName = 'Prospect';
        opp.AccountId = acc.Id;
        insert opp;
        System.debug('Opportunity Inserted - ' + opp);

        List<Product2> prodList = new List<Product2>();
        Product2 prod1 = new Product2();
        prod1.Name = 'Test Tykes Math';
        prod1.IsActive = true;
        prod1.IsQuotable__c = true;
        prod1.SBQQ__DefaultQuantity__c = 1;
        prod1.ProductCode = '1234567891234'; 
        prod1.ISBN13__c = '1234567891234'; 
        prod1.Audience__c = 'Student';
        prod1.Net_Price__c = 17.50;
        prod1.Description = 'Test Tykes 2020 Math Envision';
        prod1.Product_Sub_Type__c = 'License';
        prod1.GradeBand__c = 'Elementary (K-5)';
        prod1.Copyright_Year__c = '2020';
        prod1.Duration__c = '1YR';
        prod1.Solution_Type__c = 'Digital';
        prodList.add(prod1);

        Product2 prod2 = new Product2();
        prod2.Name = 'Test Tykes Math Pre-Algebra';
        prod2.IsActive = true;
        prod2.IsQuotable__c = true;
        prod2.SBQQ__DefaultQuantity__c = 1;
        prod2.ProductCode = '1234567574896'; 
        prod2.ISBN13__c = '1234567574896'; 
        prod2.Audience__c = 'Student';
        prod2.Net_Price__c = 20.50;
        prod2.Description = 'Test Tykes 2020 Math Pre-Algebra Envision';
        prod2.Product_Sub_Type__c = 'License';
        prod2.GradeBand__c = 'Elementary (K-5)';
        prod2.Copyright_Year__c = '2020';
        prod2.Duration__c = '1YR';
        prod2.Solution_Type__c = 'Digital';
        prodList.add(prod2);

        insert prodList;
        System.debug('Products Inserted - ' + prodList);

        // Setting up a test PriceBook 
        Pricebook2 testPriceBook = new Pricebook2();
        testPriceBook.Id = Test.getStandardPricebookId();
        testPriceBook.IsActive = true;
        update testPriceBook;
        System.debug('Pricebook setup - ' + testPricebook);

        // Setting up Quote Pricebook to avoid record trigger flow error for defaulting Quote
        PriceBook2 quotePricebook = new PriceBook2();
        quotePricebook.Name = 'Quote Pricebook';
        quotePricebook.IsActive = true;
        insert quotePricebook;

        List<PricebookEntry> pbeList = new List<PricebookEntry>();
        for (Product2 prod : prodList) {
            // Standard pricebook
            PricebookEntry pbe = new PricebookEntry();
            pbe.Product2Id = prod.Id;
            pbe.Pricebook2Id = testPriceBook.Id;
            pbe.UnitPrice = 17.50;
            pbe.IsActive = true;
            pbeList.add(pbe);

            // Quote pricebook
            PricebookEntry pbe2 = new PricebookEntry();
            pbe2.Product2Id = prod.Id;
            pbe2.Pricebook2Id = quotePricebook.Id;
            pbe2.UnitPrice = 17.50;
            pbe2.IsActive = true;
            pbeList.add(pbe2);
        }
        
        insert pbeList;
        System.debug('Pricebook Entries Inserted - ' + pbeList);

        ProductCatalog catalog = new ProductCatalog();
        catalog.Name = 'Test Catalog';
        insert catalog;
        System.debug('Catalog Inserted - ' + catalog);

        ProductCategory masterCat = new ProductCategory();
        masterCat.Name = 'Master - Savvas CPQ Catalog';
        masterCat.CatalogId = catalog.Id;
        masterCat.IsNavigational = true;
        masterCat.Is_Quotable__c = true;
        masterCat.SortOrder = 1;
        masterCat.CollectionID__c = 'TestCollectionId1';
        insert masterCat;
        System.debug('Master Category Inserted - ' + masterCat);

        ProductCategory mathCat = new ProductCategory();
        mathCat.Name = 'Math';
        mathCat.ParentCategoryId = masterCat.Id;
        mathCat.CatalogId = catalog.Id;
        mathCat.IsNavigational = true;
        mathCat.Is_Quotable__c = true;
        mathCat.SortOrder = 1;
        mathCat.CollectionID__c = 'TestCollectionId2';
        insert mathCat;
        System.debug('Math Category Inserted - ' + mathCat);

        ProductCategory gradeKCat = new ProductCategory();
        gradeKCat.Name = 'Grade K';
        gradeKCat.ParentCategoryId = mathCat.Id;
        gradeKCat.CatalogId = catalog.Id;
        gradeKCat.IsNavigational = true;
        gradeKCat.Is_Quotable__c = true;
        gradeKCat.SortOrder = 1;
        gradeKCat.CollectionID__c = 'TestCollectionId3';
        insert gradeKCat;
        System.debug('Grade K Category Inserted - ' + gradeKCat);

        List<ProductCategoryProduct> pcpList = new List<ProductCategoryProduct>();
        for (Product2 prod : prodList) {
            ProductCategoryProduct pcp = new ProductCategoryProduct();
            pcp.ProductCategoryId = gradeKCat.Id;
            pcp.ProductId = prod.Id;
            pcpList.add(pcp);
        }
        
        insert pcpList;
        System.debug('Product Category Products Inserted - ' + pcpList);

        // Disabling CPQ triggers due to After Save error
        // SBQQ.TriggerControl.disable();

        SBQQ__Quote__c quote = new SBQQ__Quote__c();
        quote.SBQQ__Account__c = acc.Id;
        quote.SBQQ__Opportunity2__c = opp.Id;
        quote.SBQQ__PriceBookId__c = quotePricebook.Id;
        quote.SBQQ__StartDate__c = Date.Today(); 
        quote.SBQQ__SubscriptionTerm__c = 12;
        insert quote;
        System.debug('Quote Inserted - ' + quote);

        System.debug('All Test Data Inserted Successfully');

    }
    
    /*
    *********************************************************
    Method Name    : testGetCategoryData
    Author         : Frank Berni
    Description    : Tests for getMasterCategoryId & getCategoryData
    ********************************************************
    */
    @IsTest
    static void testGetCategoryData() {

        // Calling getMasterCategoryId for coverage and later use in test
        String masterCategoryId = CpqProductSelectionCtrl.getMasterCategoryId();
        // System.debug('masterCategoryId - ' + masterCategoryId);
        System.assert(masterCategoryId != null, 'Master category Id did not return properly');

        // Setting up our 2 other parameters
        String soql = 'SELECT Id, Name, ParentCategoryId FROM ProductCategory';
        String parentField = 'ParentCategoryId';

        // Calling getCategoryData 
        List<CpqProductSelectionCtrl.WrapperData> returnedDataList = CpqProductSelectionCtrl.getCategoryData(soql, parentField, masterCategoryId);
        // System.debug('returnedDataList - ' + returnedDataList);

        System.assert(returnedDataList.size() > 0, 'Did not return Product Category data properly');

    }

    /*
    *********************************************************
    Method Name    : testInsertSelectedProducts
    Author         : Frank Berni
    Description    : Tests for getCategoryProductsByCategory, insertSelectedProducts & getQuoteLines
    ********************************************************
    */
    @IsTest
    static void testInsertSelectedProducts() {

        // query and store the parent quote Id
        SBQQ__Quote__c quote = [SELECT Id FROM SBQQ__Quote__c];
        Id quoteId = quote.Id;

        // query deepest nested category and store its Id
        ProductCategory selectedCategory = [SELECT Id, Name FROM ProductCategory WHERE Name = 'Grade K'];
        Id gradeKId = selectedCategory.Id;

        // NEW new list to store chosen category Ids
        List<Id> categoryIdList = new List<Id>();
        categoryIdList.add(gradeKId);

        Test.startTest();
        // NEW using categoryIdList to feed through category query
        List<CpqProductSelectionCtrl.ProductTableData> gradeKProducts = CpqProductSelectionCtrl.getCategoryProductsByCategory(categoryIdList, quoteId);
        System.debug('gradeKProducts - ' + gradeKProducts);
        System.assert(gradeKProducts.size() > 0, 'Did not return Product Category Products related to Category properly');

        // set up our list of category product Ids
        List<String> selectedCatProductIds = new List<String>();
        for (CpqProductSelectionCtrl.ProductTableData pcp : gradeKProducts) {
            selectedCatProductIds.add((String)pcp.id);
        }
        System.debug('selectedCatProductIds - ' + selectedCatProductIds);

        // call insertSelectedProducts using the list of catgeory product Ids and parent quote Id
        CpqProductSelectionCtrl.insertSelectedProducts(selectedCatProductIds, quoteId);

        // call CpqProductSelectionCtrl.getQuoteLines to check quote line
        List<SBQQ__QuoteLine__c> quoteLineResults = CpqProductSelectionCtrl.getQuoteLines(quoteId);
        Test.stopTest();

        System.debug('quoteLineResults - ' + quoteLineResults);
        System.assert(quoteLineResults.size() > 0, 'Quote Lines were not inserted to the parent Quote');

    }

    /*
    *********************************************************
    Method Name    : testGetCategoryProductsBySearchTerm
    Author         : Frank Berni
    Description    : Tests for getCategoryProductsBySearchTerm - tests search by Description and ProductCode (ISBN)
    ********************************************************
    */
    @IsTest
    static void testGetCategoryProductsBySearchTerm() {

        // query and store the parent quote Id
        SBQQ__Quote__c quote = [SELECT Id FROM SBQQ__Quote__c];
        Id quoteId = quote.Id;

        // Setting up our search terms
        String descSearch = 'Tykes';
        
        // Using partial isbn to test that exact matches aren't needed
        String isbnSearch = '574896';

        Test.startTest();
        // Our Product.Description for both products have Tykes in the name, this should return 2
        List<CpqProductSelectionCtrl.ProductTableData> tykesProducts = CpqProductSelectionCtrl.getCategoryProductsBySearchTerm(descSearch, quoteId);
        
        // One Product.ProductCode has '1234567574896', this should return 1
        List<CpqProductSelectionCtrl.ProductTableData> isbnProducts = CpqProductSelectionCtrl.getCategoryProductsBySearchTerm(isbnSearch, quoteId);
        Test.stopTest();

        System.assert(tykesProducts.size() == 2, 'Category Products matching the description did not all return');
        System.assert(isbnProducts.size() == 1, 'Category Products matching the ISBN searched did not return');
    }

}