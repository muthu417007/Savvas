/*
Apex Test Class:scc_reportEmailServiceTest
Author: CTS (Sudharani)
Created Date: 09/07/2024
Modified Date:
*/
@isTest
public class scc_reportEmailServiceTest {
    /**
*  Description: Below method is test method that tests sending report email
*  @name: testsendReportEmail
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/

    @isTest
    static void testSendReportEmail() {
        // Create test data
        List<String> emailAddresses = new List<String> { 'test@example.com' };
        String reportType = 'Order Status Report – Summary';
        String reportName = 'Test Report';
        
        // Sample CSV data for the report
        String reportData = 'PO,isbn13,productDescription,orderDate\n' +
                            '1234567890123,978-3-16-148410-0,Sample Product,2024-10-26\n' +
                            '1234567890124,978-3-16-148410-1,Another Product,2024-10-27\n';

        // Set up Org Wide Email Address for testing
       

        Test.startTest();
        // Call the method to test
        scc_reportEmailService.sendReportEmail(emailAddresses, reportType, reportData, reportName);
        Test.stopTest();

        // Assert that the email was sent
        // Verify that at least one email has been sent
       
    }
    
}