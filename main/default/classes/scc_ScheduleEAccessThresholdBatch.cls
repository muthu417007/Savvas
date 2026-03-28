/*
Apex Class:scc_ScheduleEAccessThresholdBatch
Author: CTS (Sanika)
Created Date: 15/07/2024
Reason: Create a scheduled batch to check the threshold
Modified Date:
*/
global class scc_ScheduleEAccessThresholdBatch implements Schedulable {
    global void execute(SchedulableContext SC) {
        scc_EAccessThresholdBatch batch = new scc_EAccessThresholdBatch();
        Database.executeBatch(batch, 200);
    }
}