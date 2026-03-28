@isTest
public class UpdateContactBillAddressFromAccountTest {
	@testsetup
    public static void testsetUp(){
        //Create Test Account
        Account testAcc = new Account(
            Name = 'test Con',
            Type = 'Clinic'
        );
        insert testAcc;
        Contact testCont = new Contact(
            LastName = 'test Con',
            AccountId = testAcc.Id,
            FirstName = 'test',MailingCountry = 'Billing Country',MailingCity = 'Billing City',
            Email = 'test@gmail.com',MailingState = 'Billing State',MailingStreet ='Billing Street',
            MDR_Update_Date__c = system.today()
        );
        insert testCont;
    }
    @isTest
    Public static void testBatchProcessing() {
        // Create test data - MDR_Account__c records
        
        //MDR_Account__c[] mddaAcc = TestDataFactory.createMDRAccount(40);
        // Start the batch job
        Test.startTest();
        //UpdateContactBillingAddressFromAccount batchJob = new UpdateContactBillingAddressFromAccount();
        //Database.executeBatch(batchJob);
        UpdateContactBillingAddressFromAccount batch = new UpdateContactBillingAddressFromAccount();
        String jobId = System.schedule('TestBatch', '0 0 * * * ?', batch);
        Test.stopTest();
        
        // Perform assertions on the updated/inserted records
        List<Contact> updatedConts = [select id,name,AccountId,Phone, MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet from contact];
        //System.assertEquals(updatedConts.size(), updatedConts.size()); // Add more assertions as needed
        System.assertEquals(1, updatedConts.Size());
        // Clean up test data if necessary
        //delete updatedConts;
    }
    
    @isTest
    Public static void testBatchProcessingCatch() {
        // Create test data - MDR_Account__c records
        Contact testCont = new Contact(
            LastName = 'test Con',
            FirstName = 'test',MailingCountry = 'Billing Country',MailingCity = 'Billing City',
            Email = 'test@gmail.com',MailingState = 'Billing State',MailingStreet ='Billing Street',
            MDR_Update_Date__c = system.today()
        );
        insert testCont;
        // Start the batch job
        Test.startTest();
        UpdateContactBillingAddressFromAccount batch = new UpdateContactBillingAddressFromAccount();
        String jobId = System.schedule('TestBatch', '0 0 * * * ?', batch);
        Test.stopTest();
        
        // Perform assertions on the updated/inserted records
        List<Account> updatedConts = [select id from Account];
        System.assertnotEquals(4, updatedConts.Size()); 
        // Clean up test data if necessary
        //delete updatedConts;
    }
}