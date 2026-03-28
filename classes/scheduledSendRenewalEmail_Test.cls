@isTest public class scheduledSendRenewalEmail_Test {
    @isTest static void testScheduledSendEmail() 
    {
         Test.startTest();
         scheduledSendRenewalEmail scheduleEmail = new scheduledSendRenewalEmail ();   
         String chron = '0 0 23 * * ?';        
         system.schedule('Test Schedule Email', chron, scheduleEmail);
         Test.stopTest();
    }    
}