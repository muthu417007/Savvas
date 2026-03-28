global class EAccessThresholdBatch implements Database.Batchable<sObject>, Database.Stateful {
     
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // Fetch all records initially
        return Database.getQueryLocator([
            SELECT Id, Avl_Stock__c, Threshold__c, ISBN__c 
            FROM EAccess_Threshold__c
        ]);
    }

    global void execute(Database.BatchableContext BC, List<EAccess_Threshold__c> scope) {
        // Filter records where Avl_Stock__c <= Threshold__c
        List<EAccess_Threshold__c> filteredScope = new List<EAccess_Threshold__c>();
        for (EAccess_Threshold__c record : scope) {
            if (record.Avl_Stock__c <= record.Threshold__c) {
                filteredScope.add(record);
            }
        }

        if (!filteredScope.isEmpty()) {
            EAccessThresholdTriggerHandler.processThresholds(filteredScope);
        }
    }

    global void finish(Database.BatchableContext BC) {
        // Optional: add finish logic if needed
    }
}