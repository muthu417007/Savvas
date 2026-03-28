global class PricebookEntryBatch implements Database.Batchable<SObject>, Database.Stateful {

    

    private String countryCode;

    private List<Product2> products;

    public Map<Id, PricebookEntry> priceMap = new Map<Id, PricebookEntry>();

    // Constructor to pass in products and countryCode

    public PricebookEntryBatch(List<Product2> products, String countryCode) {

        this.products = products;

        this.countryCode = countryCode;

    }

    // Start method to specify the scope of the query

    global Database.QueryLocator start(Database.BatchableContext BC) {

        // In this example, we will use the passed product list directly.

        return Database.getQueryLocator([

            SELECT Id FROM Product2 WHERE Id IN :products

        ]);

    }

    // Execute method processes each batch of Product2 records

    global void execute(Database.BatchableContext BC, List<Product2> productList) {

        Set<Id> productIds = new Set<Id>();

        for (Product2 prod : productList) {

            productIds.add(prod.Id);

        }

        // Query the PricebookEntries for the current batch of Product2 IDs

        List<PricebookEntry> pricebookEntries = [SELECT IsActive, UnitPrice, Product2Id, CurrencyIsoCode

                                                 FROM PricebookEntry

                                                 WHERE Product2Id IN :productIds

                                                 AND CurrencyIsoCode = :countryCode

                                                 AND IsActive = true

                                                 ORDER BY CreatedDate ASC];

        // Store PricebookEntries in the map

        for (PricebookEntry pbe : pricebookEntries) {

            priceMap.put(pbe.Product2Id, pbe);

        }

    }

    // Finish method for post-processing

    global void finish(Database.BatchableContext BC) {

        System.debug('Batch processing completed. PricebookEntry map: ' + priceMap);

    }

}