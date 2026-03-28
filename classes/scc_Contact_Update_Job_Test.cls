@isTest
public class scc_Contact_Update_Job_Test {
   @IsTest
 static void testBatchUpdate() {
 // Create test data
Account acc= scc_TestDataFactory.accountCreation('testAccount2');
        Contact con = scc_TestDataFactory.contactCreation( acc.Id, 'firstname2', 'testlastname2', 'testemail@abc.com');
            
        User testUser = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Customer Community Login User' LIMIT 1].Id,
            LastName = 'Test User',
            Email = 'uniqueemailid1@savvas.com',
            Username = 'uniqueemailid1@savvas.com' + System.currentTimeMillis(),
            Alias = 'tuser',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ContactId=con.Id
        );
        insert testUser;
 // Run the batch
 Test.startTest();
 scc_Contact_Update_Job batchJob = new scc_Contact_Update_Job();
 Database.executeBatch(batchJob, 2); 
// Adjust batch size as needed
 Test.stopTest();

 } 
 }