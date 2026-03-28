trigger SAV_CameleonQuote on CameleonCPQ__Quote__c (before insert, after insert, before update, after update, before delete, after delete){

    Map<Id,CameleonCPQ__Quote__c> oldMap;
    Map<Id,CameleonCPQ__Quote__c> quoteMap;
    List<CameleonCPQ__QuoteRelease__c> quoteReleasesToProcess;

    if (Trigger.isInsert ) {
        if (Trigger.isBefore) {

            oldMap = new Map<Id,CameleonCPQ__Quote__c>();
            CPQQuoteMgr.CameleonQuoteBeforeInsert(Trigger.New, oldMap, Trigger.isInsert, Trigger.isUpdate);

        }else if (Trigger.isAfter) {

            List<Id> trgNewQuoteIDs = new List<Id>(Trigger.newMap.keySet());
            CPQQuoteMgr.CPQCameleonQuoteAfterInsert(trgNewQuoteIDs);
        }
    } else if (Trigger.isUpdate) {
        if (Trigger.isBefore) {

            oldMap = new Map<Id,CameleonCPQ__Quote__c>(Trigger.OldMap); 
            CPQQuoteMgr.CameleonQuoteBeforeInsert(Trigger.New, oldMap, Trigger.isInsert, Trigger.isUpdate);

        } else if (Trigger.isAfter) {
            CPQQuoteMgr.CPQUpdatePrimaryQuote(Trigger.New, Trigger.Old);
            
            quoteMap = new map<id,cameleoncpq__quote__c>();
        
            for(CameleonCPQ__Quote__c q:Trigger.new){
                if(q.CameleonCPQ__Status__c == 'Released'){
                    if (trigger.oldmap.get(q.id).CameleonCPQ__Status__c <> 'Released'){
                        quoteMap.put(q.id,q);
                    }      
                }
            }

            //Async Action, this will enqueue a future action for each quote with an updated release number 
            //List<CameleonCPQ__Quote__c> quotesQueuedForRefresh = new List<CameleonCPQ__Quote__c>();
            //for(CameleonCPQ__Quote__c newQuote: Trigger.New) {
            //    if (newQuote.CameleonCPQ__ActiveRelease__c   != Trigger.OldMap.get(newQuote.id).CameleonCPQ__ActiveRelease__c){
            //        quotesQueuedForRefresh.add(newQuote);
            //    }
            //}

            //if (!quotesQueuedForRefresh.IsEmpty()) {
            //    CPQQuoteRefresher.synchronizeQuotes(quotesQueuedForRefresh);
            //}
        
            quoteReleasesToProcess = new List<CameleonCPQ__QuoteRelease__c>([SELECT Id, CameleonCPQ__QuoteId__c, Active__c, Order__c, CameleonCPQ__ReleaseNumber__c    
                                                                                                        FROM CameleonCPQ__QuoteRelease__c 
                                                                                                        WHERE CameleonCPQ__QuoteId__c IN :quoteMap.keyset()]); 
            if(!(quoteReleasesToProcess.IsEmpty())){
                CPQQuoteMgr.createOrderFromReleasedQuote(quoteReleasesToProcess);
            }
        }
    }

}