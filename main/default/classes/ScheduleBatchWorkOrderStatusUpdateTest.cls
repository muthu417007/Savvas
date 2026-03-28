@isTest
private class ScheduleBatchWorkOrderStatusUpdateTest {
    @isTest
    static void testSchedule(){
        Test.startTest();
         String jobId = system.schedule('TestSchedule','0 0 0 * * ?', new ScheduleBatchWorkOrderStatusUpdate());
       
        Test.stopTest();
         
        System.assertNotEquals(null,jobId);
    }

}