/*
*********************************************************
Class Name       : CustomTemplateControllerTest
Created Date     : 10/03/2024  
Author           : Frank Berni - Cognizant             
Description      : Test class for CustomTemplateController & CustomHeaderController
Percentage       : 95%

History:
<Date>          <Authors Name>              <Brief Description of Change>
10/03/2024       Frank Berni                Initial creation
10/31/2024       Frank Berni                Test method created to cover CustomHeaderController - 100%
11/04/2024       Frank Berni                Commented out CustomHeaderControllerTest - solution is deprecated
**********************************************************/
@IsTest
public class CustomTemplateControllerTest {

    @testSetup
    static void setup() {

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

        // Insert Products
        List<Product2> prodList = new List<Product2>();
        Product2 prod1 = new Product2();
        prod1.Name = 'Test Tykes Math';
        prod1.IsActive = true;
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

        // Setting up Catalogs and Categories
        ProductCatalog catalog = new ProductCatalog();
        catalog.Name = 'Test Catalog';
        insert catalog;
        System.debug('Catalog Inserted - ' + catalog);

        ProductCategory masterCat = new ProductCategory();
        masterCat.Name = 'Master - Savvas CPQ Catalog';
        masterCat.CatalogId = catalog.Id;
        masterCat.IsNavigational = true;
        masterCat.SortOrder = 1;
        masterCat.CollectionID__c = 'TestCollectionId1';
        insert masterCat;
        System.debug('Master Category Inserted - ' + masterCat);

        ProductCategory mathCat = new ProductCategory();
        mathCat.Name = 'Math';
        mathCat.ParentCategoryId = masterCat.Id;
        mathCat.CatalogId = catalog.Id;
        mathCat.IsNavigational = true;
        mathCat.SortOrder = 1;
        mathCat.CollectionID__c = 'TestCollectionId2';
        insert mathCat;
        System.debug('Math Category Inserted - ' + mathCat);

        ProductCategory gradeKCat = new ProductCategory();
        gradeKCat.Name = 'Grade K';
        gradeKCat.ParentCategoryId = mathCat.Id;
        gradeKCat.CatalogId = catalog.Id;
        gradeKCat.IsNavigational = true;
        gradeKCat.SortOrder = 1;
        gradeKCat.CollectionID__c = 'TestCollectionId3';
        insert gradeKCat;
        System.debug('Grade K Category Inserted - ' + gradeKCat);

        // Create test QuoteTemplate
        SBQQ__QuoteTemplate__c template = new SBQQ__QuoteTemplate__c(
            SBQQ__BottomMargin__c = 1,
            SBQQ__LeftMargin__c = 1,
            SBQQ__RightMargin__c = 1,
            SBQQ__TopMargin__c = 1,
            SBQQ__FontFamily__c = 'Arial',
            SBQQ__FontSize__c = 12,
            SBQQ__ShadingColor__c = 'FFFFFF'
        );
        insert template;
        System.debug('Quote Template Inserted - ' + template);

        // Create test Quote
        SBQQ__Quote__c quote = new SBQQ__Quote__c();
        quote.SBQQ__Account__c = acc.Id;
        quote.SBQQ__Opportunity2__c = opp.Id;
        quote.SBQQ__PriceBookId__c = quotePricebook.Id;
        quote.SBQQ__StartDate__c = Date.Today(); 
        quote.SBQQ__SubscriptionTerm__c = 12;
        quote.Include_Ship_To__c = true;
        quote.ShippingAddress__c = '12345 Testera Ave, Testington Heights, FL, USA, 33372';
        quote.Special_Notes__c = 'I\'m a special note. Look how special I am';
        quote.License_to_District__c = '1234567';
        quote.InvoiceForFutureDate__c = true;
        quote.Future_Ship_Start_Date__c = Date.Today();
        insert quote;
        System.debug('Quote Inserted - ' + quote);

        // Create test QuoteLineProgram records
        List<QuoteLineProgram__c> qlPrograms = new List<QuoteLineProgram__c>();
        for (Integer i = 0; i < 3; i++) {
            QuoteLineProgram__c qlp = new QuoteLineProgram__c(
                Quote__c = quote.Id,
                Name = 'Program ' + i,
                BaseAmount__c = 100 * i,
                // Paid_Amt__c = 50 * i,
                FreeAmount__c = 10 * i
            );
            qlPrograms.add(qlp);
        }
        insert qlPrograms;
        System.debug('Quote Line Programs Inserted - ' + qlPrograms);

        // Create test QuoteLine records per pricebook entry and ql program
        List<SBQQ__QuoteLine__c> quoteLines = new List<SBQQ__QuoteLine__c>();
        for (PricebookEntry pbe : pbeList) {
            Integer i = 1;
            // double loop through programs
            for (QuoteLineProgram__c qlp : qlPrograms) {
                SBQQ__QuoteLine__c line = new SBQQ__QuoteLine__c(
                    SBQQ__Quote__c = quote.Id,
                    ProductCategory__c = gradeKCat.Id,
                    ProgramGroup__c = qlp.Id,
                    SBQQ__PricebookEntryId__c = pbe.Id,
                    CategoryType_SortOrder__c = i,
                    GradeLevel_SortOrder__c = i,
                    SBQQ__ListPrice__c = 100,
                    SBQQ__PricingMethod__c = 'List',
                    SBQQ__StartDate__c = Date.today(),
                    SBQQ__Quantity__c = 1,
                    SBQQ__PriorQuantity__c = 0,
                    SBQQ__RegularPrice__c = 100,
                    SBQQ__NetPrice__c = 100,
                    SBQQ__Number__c = 1,
                    SBQQ__ProrateMultiplier__c = 1,
                    SBQQ__SubscriptionPricing__c = 'Fixed Price',
                    SBQQ__SubscriptionScope__c = 'Quote',
                    SBQQ__DefaultSubscriptionTerm__c = 1
                );
                quoteLines.add(line);
            }
            i++;
        }

        SBQQ.TriggerControl.disable();

        insert quoteLines;
        System.debug('Quote Lines Inserted - ' + quoteLines);
        System.debug('Quote Lines Total' + quoteLines.size());
    }

    // Test method for CustomTemplateController
    @isTest
    static void testCustomTemplateController() {
        
        SBQQ__Quote__c quote = [SELECT Id FROM SBQQ__Quote__c LIMIT 1];
        SBQQ__QuoteTemplate__c template = [SELECT Id FROM SBQQ__QuoteTemplate__c LIMIT 1];

        // Set test page parameters
        Test.setCurrentPageReference(new PageReference('/apex/CustomTemplatePage'));
        ApexPages.currentPage().getParameters().put('qid', quote.Id);
        ApexPages.currentPage().getParameters().put('tid', template.Id);

        // Instantiate the controller
        CustomTemplateController controller = new CustomTemplateController();

        // Test that the template is populated correctly
        System.assertNotEquals(null, controller.template);
        System.assertEquals('Arial', controller.template.SBQQ__FontFamily__c);

        // Test that the quote lines are populated
        System.assertEquals(12, controller.lines.size());

        // Test that the quote line programs are populated
        System.assertEquals(3, controller.qlPrograms.size());

        // Test that the boolean field is updated properly
        System.assert(controller.showPriceQuoteSummary == false);
    }

}