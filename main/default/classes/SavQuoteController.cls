public with sharing class SavQuoteController {

    @AuraEnabled(cacheable=true)
    public static CameleonCPQ__Quote__c getQuotesOnOpp(String oppId) {
        
        List<CameleonCPQ__Quote__c> quotes =  [SELECT Id,CameleonCPQ__ActiveRelease__c FROM CameleonCPQ__Quote__c WHERE CPQOpportunityId__c =: oppId];

        if( quotes.size() > 0 )  
            return quotes.get( 0 );  
        else  
            return null;  
    }

    @AuraEnabled(cacheable=true)
    public static CameleonCPQ__Quote__c getQuote(String quoteId) {
        
        List<CameleonCPQ__Quote__c> quotes =  [SELECT Id,CameleonCPQ__ActiveRelease__c FROM CameleonCPQ__Quote__c WHERE Id =: quoteId];

        if( quotes.size() > 0 )  
            return quotes.get( 0 );  
        else  
            return null;  
    }

    @AuraEnabled(cacheable=true)
    public static Opportunity getOppInfo(String oppId) {

        List<Opportunity> opportunities = [SELECT Id, Name, AccountId FROM Opportunity WHERE Id =:oppId];

        if( opportunities.size() > 0 )  
            return opportunities.get( 0 );  
        else  
            return null;  

    }

    @AuraEnabled(cacheable=false)
    public static OpportunityContactRole getPrimaryContact(String oppId) {

        List<OpportunityContactRole> oppContact = [SELECT Id, ContactId FROM OpportunityContactRole WHERE IsPrimary = TRUE AND OpportunityID =:oppId LIMIT 1];

        if( oppContact.size() > 0 )  
            return oppContact.get( 0 );  
        else  
            return null;  

    }

    @AuraEnabled(cacheable=true)
    public static List<CameleonCPQ__QuoteRelease__c> getReleases(String quoteId) {
    
        return [SELECT Id, Name,CameleonCPQ__ReleaseNumber__c, CreatedDate, CreatedBy.Name, CameleonCPQ__Status__c, Active__c FROM CameleonCPQ__QuoteRelease__c WHERE CameleonCPQ__QuoteId__c =:quoteId];

    }
}