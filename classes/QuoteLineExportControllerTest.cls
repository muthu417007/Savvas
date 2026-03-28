/*
*********************************************************
Class Name       : QuoteLineExportControllerTest
Created Date     : 08/22/2024  
Author           : Frank Berni - Cognizant
Description      : Test class for QuoteLineExportController
Percentage       : 100%


History:
<Date>          <Authors Name>              <Brief Description of Change>
08/23/2024      Frank Berni                  Ticket W-015737: Initial creation - LWC version of Exporting Quote Lines
**********************************************************/
@IsTest
public class QuoteLineExportControllerTest {
    
    @IsTest
    static void testGenerateQuoteLineCsv() {

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

        // Create a test Quote record
        SBQQ__Quote__c testQuote = new SBQQ__Quote__c(
            SBQQ__PriceBookId__c = quotePricebook.Id,
            SBQQ__StartDate__c = Date.Today(),
            SBQQ__SubscriptionTerm__c = 12,
            Quote_Name__c = 'Test Quote'
        );
        insert testQuote;
        System.debug('Quote Inserted - ' + testQuote);
        
        // Create test Quote Lines
        List<SBQQ__QuoteLine__c> testQuoteLines = new List<SBQQ__QuoteLine__c>();
        for (PricebookEntry pbe : pbeList) {
            SBQQ__QuoteLine__c ql = new SBQQ__QuoteLine__c(
                SBQQ__Quote__c = testQuote.Id,
                SBQQ__PricebookEntryId__c = pbe.Id,
                QL_Optional__c = false,
                SBQQ__Product__c = pbe.Product2Id,
                SBQQ__Description__c = 'Test Description',
                SBQQ__Quantity__c = 1,
                FWO_Quantity__c = 1,
                SBQQ__ListPrice__c = 100,
                SBQQ__AdditionalDiscountAmount__c = 20,
                SBQQ__NetPrice__c = 70,
                StandardCost__c = 50,
                Contract_Price_Checked__c = true,
                Applied_Promotion_Name__c = 'Promo'
            );
            testQuoteLines.add(ql);
        }
        insert testQuoteLines;
        System.debug('Quote Lines Inserted - ' + testQuote);
        
        Map<String, String> result = QuoteLineExportController.generateQuoteLineCsv(testQuote.Id);

        String csvContent = result.get('csvContent');
        String quoteName = result.get('quoteName');
        
        // Assert the results
        Assert.areNotEqual(null, csvContent, 'csvContent should not be empty');
        Assert.areEqual(testQuote.Quote_Name__c, quoteName, 'Returned quote name does not match actual quote name');
        
        
    }
}