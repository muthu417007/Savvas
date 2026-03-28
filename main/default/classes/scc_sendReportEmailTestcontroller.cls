/*
Apex Test Class:scc_sendReportEmailTestcontroller
Author: CTS (Sudharani)
Created Date: 09/07/2024
Modified Date:
*/




@isTest
public class scc_sendReportEmailTestcontroller {
   /**
*  Description: Below method is test method that tests sending report email
*  @name: testSendReportEmail_SummaryReport
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/
   /* @isTest
    static void testSendReportEmail_SummaryReport() {
        // Create test data for the report
        List<String> emailAddresses = new List<String> { 'test@example.com' };
            String reportType = 'Order Status Report – Summary';
        String reportName = 'Test Summary Report';
        List<String> reportData = new List<String>();
        
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
        
        // Execute the test
        Test.startTest();
        scc_sendReportEmail emailJob = new scc_sendReportEmail(emailAddresses, reportType, reportData, reportName);
        System.enqueueJob(emailJob); // Queueable job for sending email
        Test.stopTest();
        
        // Validation
        // Verify if the email has been sent (you can mock this if needed)
        // In production, this might involve checking if the email was really sent or using platform events for testing
    }
    
    @isTest
    static void testSendReportEmail_DetailReport() {
        // Create test data for the report
        List<String> emailAddresses = new List<String> { 'test@example.com' };
            String reportType = 'Order Status Report – Detail';
        String reportName = 'Test Detail Report';
        List<String> reportData = new List<String>();
        
        reportData.add(JSON.serialize(new Map<String, Object>{
            'PO' => 'PO54321',
                'isbn13' => '9789876543210',
                'productDescription' => 'Another Product',
                'orderDate' => '2023-09-01',
                'orderNumber' => 'ORD987',
                'orderedQuantity' => 15,
                'invoiceNumber' => 'INV98765',
                'status' => 'Shipped',
                'quantity' => 12,
                'reason' => '',
                'shipDate' => '2023-09-10',
                'dueDate' => '2023-10-01',
                'backorderCancelDate' => '',
                'futureShipDate' => '',
                'shipAccount' => 'SHIP987',
                'shipAccountName' => 'Test Ship Account 2',
                'city' => 'San Francisco',
                'state' => 'CA'
                }));
        
        // Execute the test
        Test.startTest();
        scc_sendReportEmail emailJob = new scc_sendReportEmail(emailAddresses, reportType, reportData, reportName);
        System.enqueueJob(emailJob); // Queueable job for sending email
        Test.stopTest();
        
        // Validation
    }
    
    @isTest
    static void testSendReportEmail_TrackingReport() {
        // Create test data for the report
        List<String> emailAddresses = new List<String> { 'test@example.com' };
            String reportType = 'Order Status Report – Tracking';
        String reportName = 'Test Tracking Report';
        List<String> reportData = new List<String>();
        
        reportData.add(JSON.serialize(new Map<String, Object>{
            'PO' => 'PO67890',
                'isbn13' => '9781230987654',
                'productDescription' => 'Tracking Product',
                'orderDate' => '2023-08-01',
                'orderNumber' => 'ORD456',
                'orderedQuantity' => 20,
                'invoiceNumber' => 'INV54321',
                'shipDate' => '2023-08-15',
                'carrierName' => 'FedEx',
                'parcelID' => 'P123456',
                'trackingNumber' => 'T789456123',
                'signature' => 'Customer A',
                'shipAccount' => 'SHIP678',
                'shipAccountName' => 'Test Ship Account 3',
                'city' => 'Los Angeles',
                'state' => 'CA'
                }));
        
        // Execute the test
        Test.startTest();
        scc_sendReportEmail emailJob = new scc_sendReportEmail(emailAddresses, reportType, reportData, reportName);
        System.enqueueJob(emailJob); // Queueable job for sending email
        Test.stopTest();
        
        // Validation
    }*/
    
}