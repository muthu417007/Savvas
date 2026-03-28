global class BatchWorkOrderStatusUpdate implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query;
        
        query = 'Select id, status, Sav_FSL_Expiration_Date__c, Extended_Expiration_Date__c from WorkOrder where (Extended_Expiration_Date__c!=null AND Extended_Expiration_Date__c<today) OR Sav_FSL_Expiration_Date__c<today'; 
		//WorkOrder w = [Select id, Sav_FSL_Expiration_Date__c, Extended_Expiration_Date__c from WorkOrder where Sav_FSL_Expiration_Date__c!=null AND Sav_FSL_Expiration_Date__c<today limit 1];
        return Database.getQueryLocator(query);        
    } 
    
    global void execute(Database.BatchableContext BC, List<WorkOrder> scope)
    {
        List<WorkOrder> workOrdersToUpdate = new List<WorkOrder>();
        for(WorkOrder w : scope){
            w.Status = 'Expired';
            workOrdersToUpdate.add(w);
        }
        try {
            update workOrdersToUpdate;
        } catch (DmlException e) {
            System.debug('An error has occurred: ' + e.getMessage());
        }
    }
    
    global void finish(Database.BatchableContext BC) {
    }
}