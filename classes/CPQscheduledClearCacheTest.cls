@isTest (SeeAllData=true)
class CPQscheduledClearCacheTest {
 
    public static CronTrigger fetchCronTrigger(String jobId) {
        return [
            select CronExpression,
                TimesTriggered,
                NextFireTime
            from CronTrigger
            where Id = :jobId
        ];
    }
 
    static testMethod void testClearCache() {
    
       String sch = '0'+ ' ' + '0' + ' ' + '0' + ' ' + '*' + ' ' + '*' + ' ' + '?' + ' ' + '*';
        
        Test.startTest();
               
        String jobId = System.schedule(
            '_unittest_clearCache_: 001',
            sch,
            new CPQ_CalloutCacheClearScheduler()
        );
        
        CronTrigger ct = fetchCronTrigger(jobId);
        
        DateTime today = DateTime.now();
        String dateString = ''+today.year()+'-'+today.addDays(1).month()+'-' + today.addDays(1).day() +' 00:00:00';
        System.assertEquals(String.valueOf(DateTime.valueOf(dateString)), String.valueOf(ct.NextFireTime), 'Did not get the right fire date');

        
        System.assertEquals(sch, ct.CronExpression, 'Did not get the same Cron Expression back');
        System.assertEquals(0, ct.TimesTriggered, 'The job has been run and should not have');
 
        Test.stopTest();
 
    }
}