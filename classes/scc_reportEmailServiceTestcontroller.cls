/*
Apex Test Class:scc_reportEmailServiceTest
Author: CTS (Sudharani)
Created Date: 09/07/2024
Modified Date:
*/
@isTest
public class scc_reportEmailServiceTestcontroller {
    /**
*  Description: Below method is test method that tests sending report email
*  @name: testsendReportEmail
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/


    @isTest
    static void testSendReportEmail() {
        // Step 1: Create mock data for the test
        List<String> emailAddresses = new List<String> { 'test@example.com', 'user@example.com' };
        String reportType = 'Order Status Report – Summary';
        String reportName = 'Test Summary Report';
        List<String> reportData = new List<String>();
        
        // Add sample report data
        reportData.add(JSON.serialize(new Map<String, Object>{
            'PO' => 'PO12345',
            'isbn13' => '9781234567890',
            'productDescription' => 'Test Product',
            'orderDate' => '2023-10-01',
            'orderNumber' => 'ORD123',
            'orderedQuantity' => 10,
            'shippedQuantity' => 8,
            'backorderQuantity' => 2,
            'dueDate' => '2023-11-01',
            'holdQuantity' => 0,
            'shippableQuantity' => 0,
            'cancelledQuantity' => 0,
            'shipAccount' => 'SHIP123',
            'shipAccountName' => 'Test Ship Account',
            'city' => 'New York',
            'state' => 'NY'
        }));

        // Step 2: Execute the test
        Test.startTest();
        // Call the method to test
        scc_reportEmailService.sendReportEmail(emailAddresses, reportType, reportData, reportName);
        Test.stopTest();

        // Step 3: Validate the result
        // Ensure that the job was added to the queue
        Integer numberOfJobs = [SELECT COUNT() FROM AsyncApexJob WHERE JobType = 'Queueable'];
        System.assertEquals(1, numberOfJobs, 'A Queueable job should have been enqueued.');
    }
}