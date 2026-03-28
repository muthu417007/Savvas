trigger EAccessThresholdTrigger on EAccess_Threshold__c (after insert, after update) {
    /**List<EAccess_Threshold__c> thresholdsToProcess = new List<EAccess_Threshold__c>();

    for (EAccess_Threshold__c threshold : Trigger.new) {
        if (threshold.Threshold__c > threshold.Avl_Stock__c) {
            thresholdsToProcess.add(threshold);
        }
    }

    if (!thresholdsToProcess.isEmpty()) {
        EAccessThresholdTriggerHandler.processThresholds(thresholdsToProcess);
    }**/
}