/*
    *Trigger Name: CaseTriggerForRPAIntegration
    *Description: Trigger on Case object to update RPA fields from web service calls
    *Created by: Praveen Tharala
*/

trigger CaseTriggerForRPAIntegration on Case (after insert, after update) {
    if(!System.isFuture() && !System.isBatch() && !System.isQueueable()){
        List<Id> uploadFileCaseIds = new List<Id>();
        List<Id> rPAAmountUpdateCaseIds = new List<Id>();
        List<Id> rPAClassificationCaseIds = new List<Id>();
        List<Id> rPAClassificationNullCaseIds = new List<Id>();
        List<RPACaseQueues__mdt> rPACaseQueues = [select MasterLabel, DeveloperName, RPACaseQueueId__c from RPACaseQueues__mdt];
        List<String> rPAQueueIds = new List<String>();
        for(RPACaseQueues__mdt rPAQueue : rPACaseQueues){
            rPAQueueIds.add(rPAQueue.RPACaseQueueId__c);
        }
        if(Trigger.isAfter){
            for(Case insertedCase : Trigger.New) {
                if(Trigger.isInsert && !rPAQueueIds.contains(insertedCase.OwnerId))
                    continue;
                if(insertedCase.origin == 'Email' || insertedCase.origin == 'Email-Indirect' || insertedCase.origin == 'Fax' || insertedCase.origin == 'Web'){
                    if((Trigger.isInsert /*|| Trigger.isUpdate Commented in Phase#3*/) && insertedCase.RPA_ORDER_AMOUNT__c == null)
                        uploadFileCaseIds.add(insertedCase.Id);
                    if(Trigger.isUpdate && Trigger.oldMap.get(insertedCase.Id).RPA_ORDER_AMOUNT__c != insertedCase.RPA_ORDER_AMOUNT__c)
                        rPAAmountUpdateCaseIds.add(insertedCase.Id);
                    if((Trigger.isInsert /*|| Trigger.isUpdate Commented in Phase#3*/) && insertedCase.RPA_Classification__c == null)
                        rPAClassificationNullCaseIds.add(insertedCase.Id);
                    if(Trigger.isUpdate && Trigger.oldMap.get(insertedCase.Id).RPA_Classification__c != insertedCase.RPA_Classification__c)
                        rPAClassificationCaseIds.add(insertedCase.Id);
                }
            }
        }
        
         if(!EmailToCaseHandler.isCaseTriggerRPAIntegrationExecuted && (!uploadFileCaseIds.isEmpty() || !rPAAmountUpdateCaseIds.isEmpty() || !rPAClassificationCaseIds.isEmpty() || !rPAClassificationNullCaseIds.isEmpty())){
             EmailToCaseHandler.isCaseTriggerRPAIntegrationExecuted = true;
            System.enqueueJob(new CaseTriggerCalloutQueueable(uploadFileCaseIds, rPAAmountUpdateCaseIds, rPAClassificationCaseIds, rPAClassificationNullCaseIds));
        }
    }
}