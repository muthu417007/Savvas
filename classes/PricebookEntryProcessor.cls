public class PricebookEntryProcessor {

    public static void fetchPricebookEntries(List<Product2> products, String countryCode) {
        PricebookEntryBatch batchJob = new PricebookEntryBatch(products, countryCode);
        Database.executeBatch(batchJob, 200);

    }

}