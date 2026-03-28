@isTest
public class Sav_FSL_ScheduleBatchWOStatusUpdateTest {
 @isTest
    static void testSchedule(){
        Test.startTest();
         String jobId = system.schedule('TestSchedule','0 0 0 * * ?', new Sav_FSL_ScheduleBatchWOStatusUpdate());
       
        Test.stopTest();
         
        System.assertNotEquals(null,jobId);
    }
}