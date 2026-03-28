/*
Apex Class:scc_ScheduleEAccessThresholdBatchTest
Author: CTS (Sanika)
Created Date: 15/07/2024
Reason: Test class created to test scc_ScheduleEAccessThresholdBatch
Modified Date:
*/
@isTest
public class scc_ScheduleEAccessThresholdBatchTest {
    @isTest
    static void testScheduledBatch() {
        // Schedule the job
        String cronExp = '0 0 1 * * ?';
        String jobId = System.schedule('Test Scheduled Batch', cronExp, new scc_ScheduleEAccessThresholdBatch());

        // Verify the job was scheduled
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                          FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals(cronExp, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        System.assertNotEquals(null, ct.NextFireTime);
    }
}