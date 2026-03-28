trigger createOrderFromReleasedQuote on CameleonCPQ__Quote__c (after update) {

    Map<Id,CameleonCPQ__Quote__c> quoteMap = new map<id,cameleoncpq__quote__c>();

    for(CameleonCPQ__Quote__c q:Trigger.new){
        if(q.CameleonCPQ__Status__c == 'Released'){
            if (trigger.oldmap.get(q.id).CameleonCPQ__Status__c <> 'Released'){
                quoteMap.put(q.id,q);
            }      
        }
    }

    List<CameleonCPQ__QuoteRelease__c> quoteReleasesToProcess = new List<CameleonCPQ__QuoteRelease__c>([SELECT Id, CameleonCPQ__QuoteId__c, Active__c, Order__c   
                                                                                                FROM CameleonCPQ__QuoteRelease__c 
                                                                                                WHERE CameleonCPQ__QuoteId__c IN :quoteMap.keyset()]); 
        If(!(quoteReleasesToProcess.IsEmpty())){
            CreateOrderFromQuoteInvocable.createOrderFromReleasedQuote(quoteReleasesToProcess);
        }

}