trigger CPQQuoteContentAfterUpdate on CameleonCPQ__QuoteContent__c (after update) {
    CPQQuoteMgr mgr = new CPQQuoteMgr();
    system.debug('  TRIGGER CPQQuoteContentAfterUpdate ');
    for (CameleonCPQ__QuoteContent__c content : [SELECT CameleonCPQ__QuoteId__c FROM 
        CameleonCPQ__QuoteContent__c WHERE Id IN: Trigger.newMap.keySet()]) {
        //mgr.processAfterSyncUpdate(content);
        mgr.processAfterSyncUpdate(content);
    }    
}