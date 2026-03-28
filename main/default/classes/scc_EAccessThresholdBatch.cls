/*
Apex Class:scc_EAccessThresholdBatch
Author: CTS (Sanika)
Created Date: 15/07/2024
Reason: Create a daily batch to check the threshold
Modified Date: 16/04/2024
*/
global class scc_EAccessThresholdBatch implements Database.Batchable<sObject>, Database.Stateful {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([
            SELECT Id, Avl_Stock__c, Threshold__c, ISBN__c, StockAlerted__c, EAccess_Imprints__r.Imprint_ID__c
            FROM EAccess_Threshold__c
        ]);
    }

    global void execute(Database.BatchableContext BC, List<EAccess_Threshold__c> scope) {
        List<EAccess_Threshold__c> filteredScope = new List<EAccess_Threshold__c>();
        List<EAccess_Threshold__c> resetScope = new List<EAccess_Threshold__c>();

        for (EAccess_Threshold__c record : scope) {
            if (record.Avl_Stock__c < record.Threshold__c && !record.StockAlerted__c) {
                filteredScope.add(record);
            } else if (record.Avl_Stock__c >= record.Threshold__c && record.StockAlerted__c) {
                resetScope.add(record);
            }
        }

        if (!filteredScope.isEmpty()) {
            List<EAccess_Threshold__c> thresholdsToUpdate = scc_EAccessThresholdTriggerHandler.processThresholds(filteredScope);

            // Set StockAlerted__c to true for records where email is sent
            for (EAccess_Threshold__c record : thresholdsToUpdate) {
                record.StockAlerted__c = true;
            }
            update thresholdsToUpdate;
        }

        if (!resetScope.isEmpty()) {
            // Reset StockAlerted__c to false for records where stock is now above the threshold
            for (EAccess_Threshold__c record : resetScope) {
                record.StockAlerted__c = false;
            }
            update resetScope;
        }
    }

    global void finish(Database.BatchableContext BC) {
        // Optional: add finish logic if needed
    }
}