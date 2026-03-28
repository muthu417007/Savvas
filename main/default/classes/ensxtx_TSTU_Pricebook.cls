/*
* Test cases for price book utility class
*/
@isTest
public class ensxtx_TSTU_Pricebook
{
    @isTest
    public static void test_getStandardPricebook()
    {
        Test.startTest();
        Id pb = ensxtx_UTIL_Pricebook.getStandardPriceBookId();
        Test.stopTest();
    }

    @isTest
    public static void test_getEntriesForPricebook()
    {
        Test.startTest();
        Account testAcct = ensxtx_TSTU_SFTestObject.createTestAccount();
        ensxtx_TSTU_SFTestObject.upsertWithRetry(testAcct);
        ensxtx_UTIL_Pricebook.getEntriesForPricebookById(testAcct.Id, null, null);
        ensxtx_UTIL_Pricebook.getEntriesForPricebookById(null, new Set<String>{'Test'}, null);
        ensxtx_UTIL_Pricebook.loadResult(new List<PriceBookEntry>{new PriceBookEntry()}, new Map<Id, PriceBookEntry>());
        Test.stopTest();
    }

    @isTest 
    public static void testvalidateProductsInPricebook()
    {
        ensxtx_DS_Document_Detail salesDocDetail = new ensxtx_DS_Document_Detail();
        salesDocDetail.ITEMS.add(new ensxtx_DS_Document_Detail.ITEMS());
        salesDocDetail.ITEMS.add(new ensxtx_DS_Document_Detail.ITEMS());
        salesDocDetail.ITEMS[0].ItemNumber = '1';
        salesDocDetail.ITEMS[1].HigherLevelItemNumber = '1';
        salesDocDetail.ITEMS.add(salesDocDetail.ITEMS[1]);
        List<Product2> newProdList = new List<Product2>();

        Product2 product1 = ensxtx_TSTU_SFTestObject.createTestProduct2();
        newProdList.add(product1);

        Product2 product2 = ensxtx_TSTU_SFTestObject.createTestProduct2();
        product2.Name = 'test';
        product2.put(ensxtx_UTIL_SFProduct.MaterialFieldName, 'test');
        newProdList.add(product2);

        Product2 product3 = ensxtx_TSTU_SFTestObject.createTestProduct2();
        newProdList.add(product3);

        ensxtx_TSTU_SFTestObject.upsertWithRetry(newProdList);

        Id standardPricebook = ensxtx_UTIL_Pricebook.getStandardPriceBookId();
        Id priceBookId = ensxtx_TSTU_SFTestObject.createTestPriceBook2();
        Map<Id, PriceBookEntry> standardPricebookEntriesMap = new Map<Id, PriceBookEntry>();
        Map<Id, PriceBookEntry> pricebookEntriesMap = new Map<Id, PriceBookEntry>();
        Integer prodTot = newProdList.size();
        for (Integer prodCnt = 0 ; prodCnt < prodTot ; prodCnt++)
        {
            Product2 prod = newProdList[prodCnt];
            PricebookEntry standardPBE = ensxtx_TSTU_SFTestObject.createTestPriceBookEntry();
            standardPBE.PriceBook2Id = standardPricebook;
            standardPBE.Product2Id = prod.Id;
            standardPBE.Product2 = prod;
            standardPBE.UnitPrice = 100;
            standardPBE.isActive = true;
            standardPricebookEntriesMap.put(prod.Id, standardPBE);
            PricebookEntry priceBookEntry = ensxtx_TSTU_SFTestObject.createTestPriceBookEntry();
            priceBookEntry.PriceBook2Id = priceBookId;
            priceBookEntry.Product2Id = prod.Id;
            priceBookEntry.Product2 = prod;
            priceBookEntry.UnitPrice = 100;
            priceBookEntry.isActive = true;
            pricebookEntriesMap.put(prod.Id, priceBookEntry);
        }

        ensxtx_UTIL_Pricebook.validateProductsInPricebook(
            salesDocDetail, standardPricebook, new Set<string>{'main'},
            new Map<Id, PriceBookEntry>());
                
        ensxtx_UTIL_Pricebook.validateProductsInPricebook(
            salesDocDetail, standardPricebook, new Set<string>{product1.Name},
            standardPricebookEntriesMap);

        try 
        {            
            standardPricebookEntriesMap.put(product2.Id,standardPricebookEntriesMap.values()[0]);
            ensxtx_UTIL_Pricebook.validateProductsInPricebook(
                salesDocDetail, standardPricebook, new Set<string>{product1.Name},
                standardPricebookEntriesMap);
        } 
        catch (Exception e) {}
        
        Set<String> materialNumbers = new Set<string>{product1.Name, product2.Name, product3.Name};   
        ensxtx_UTIL_Pricebook.validateProductsInPricebook(
            salesDocDetail, priceBookId, materialNumbers,
            pricebookEntriesMap);
        ensxtx_UTIL_Pricebook.validateProductsInPricebook(
            salesDocDetail, priceBookId, materialNumbers,
            pricebookEntriesMap);
    }
}