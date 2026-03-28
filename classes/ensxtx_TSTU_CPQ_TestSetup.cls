@isTest public with sharing class ensxtx_TSTU_CPQ_TestSetup {

    public static Account createAccount(String customerNumber) {
        Account account = ensxtx_TSTU_SFTestObject.createTestAccount();
        account.Name = 'Mock Account';
        account.AccountNumber = customerNumber;
        account.BillingCity = 'Toledo';
        account.BillingStreet = '1234 Test St';
        Boolean isBillingCode = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().keySet().contains('BillingStateCode'.toLowerCase());
        String billingStateField = isBillingCode ? 'BillingStateCode' : 'BillingState';
        account.put(billingStateField, 'OH');
        account.BillingPostalCode = '43613';
        String billingCountryField = isBillingCode ? 'BillingCountryCode' : 'BillingCountry';
        account.put(billingCountryField, 'United States');
        account.put(ensxtx_UTIL_SFAccount.CustomerFieldName, customerNumber);
        ensxtx_TSTU_SFTestObject.upsertWithRetry(account);

        return account;
    }

    public static SBQQ__Quote__c createQuote() {
        SBQQ.TriggerControl.disable();
        SBQQ__Quote__c quote = ensxtx_TSTU_SFCPQQuote.createTestQuote();
        quote.SBQQ__Key__c = 'Mock Quote';
        quote.ensxtx_Ship_To_Number__c = 'TEST';
        ensxtx_TSTU_SFTestObject.upsertWithRetry(quote);
        
        Product2 product = createProduct2();
        
        SBQQ__QuoteLine__c quoteLine = ensxtx_TSTU_SFCPQQuote.createTestQuoteLine();
        quoteLine.SBQQ__Quote__c = quote.Id;
        quoteLine.SBQQ__Product__c = product.Id;
        quoteLine.SBQQ__Quantity__c = 1;
        quoteLine.SBQQ__ListPrice__c = 20.00;
        quoteLine.SBQQ__Description__c = 'TEST DESC';
        ensxtx_TSTU_SFTestObject.upsertWithRetry(quoteLine);

        return quote;
    }

    public static SBQQ__QuoteLine__c createQuoteLine() {
        SBQQ.TriggerControl.disable();
        SBQQ__Quote__c quote = ensxtx_TSTU_SFCPQQuote.createTestQuote();
        quote.SBQQ__Key__c = 'Mock Quote';
        ensxtx_TSTU_SFTestObject.upsertWithRetry(quote);
        
        Product2 product = createProduct2();
        
        SBQQ__QuoteLine__c quoteLine = ensxtx_TSTU_SFCPQQuote.createTestQuoteLine();
        quoteLine.SBQQ__Quote__c = quote.Id;
        quoteLine.SBQQ__Product__c = product.Id;
        quoteLine.SBQQ__Quantity__c = 1;
        quoteLine.SBQQ__ListPrice__c = 20.00;
        quoteLine.SBQQ__Description__c = 'TEST DESC';
        ensxtx_TSTU_SFTestObject.upsertWithRetry(quoteLine);
        ensxtx_TSTU_SFTestObject.upsertWithRetry(quote);

        return quoteLine;
    }

    public static List<SObject> createAccountQuoteLinked() {
        Account account = createAccount('TEST');

        SBQQ__Quote__c quote = createQuote();
        quote.SBQQ__Account__c = account.Id;
        ensxtx_TSTU_SFTestObject.upsertWithRetry(quote);

        return new List<SObject> { account, quote };
    }

    public static Product2 createProduct2() {
        Product2 product = ensxtx_TSTU_SFTestObject.createTestProduct2();
        ensxtx_TSTU_SFTestObject.upsertWithRetry(product);
        return product;
    }

    public static Address createAddress() {
        Account a = createAccount('TEST');
        a = [SELECT BillingAddress FROM Account WHERE Id = :a.Id];
        return (Address)a.get('BillingAddress');
    }
}