public with sharing class ReportEmailBatch implements Database.Batchable<SObject>, Database.Stateful {

    // Variables to store email information and report data
    private List<String> emailAddresses;
    private String reportType;
    private List<String> reportData;
    private String reportName;
    
    // String to accumulate CSV data
    private String csvData = '';

    // Constructor to initialize the batch
    public ReportEmailBatch(List<String> emailAddresses, String reportType, List<String> reportData, String reportName) {
        this.emailAddresses = emailAddresses;
        this.reportType = reportType;
        this.reportData = reportData;
        this.reportName = reportName;
    }
    
    // Start method to begin batch processing
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT Id FROM Account LIMIT 1');  // Dummy query to start the batch
    }
    
    // Execute method - process each batch of records
    public void execute(Database.BatchableContext BC, List<SObject> scope) {
        Integer batchSize = 500;  // Set batch size to process in chunks
        List<String> currentBatch = new List<String>();
		if (String.isEmpty(csvData)) {
            if (reportType == 'Order Status Report – Summary') {
                csvData += 'PO #,ISBN,Title Description,Order Date,Order #,Ordered Qty,Shipped Qty,Backorder Qty,Due Date,On Hold Qty,Shippable Quantity,Cancelled Quantity,Ship-to Account #,Ship-to Account Name,City,State\n';
            } else if (reportType == 'Order Status Report – Detail') {
                csvData += 'PO #,ISBN,Title Description,Order Date,Order #,Ordered Qty,Invoice #,Status,Quantity,Reason,Ship Date,Due Date,Backorder Cancel Date,Future Ship Date,Ship-to Account #,Ship-to Account Name,City,State\n';
            } else if (reportType == 'Order Status Report – Tracking') {
                csvData += 'PO #,ISBN,Title Description,Order Date,Order #,Ordered Qty,Invoice #,Ship Date,Shipping Method,Parcel ID,Tracking #,Signature,Ship-to Account #,Ship-to Account Name,City,State\n';
            }
        }
        // Process reportData in smaller batches (500 records per batch)
        for (Integer i = 0; i < reportData.size(); i++) {
            currentBatch.add(reportData[i]); // Add current record to batch

            // When batch size limit is reached or it's the last element, process batch
            if (currentBatch.size() == batchSize || i == reportData.size() - 1) {
                for (String recordStr : currentBatch) {
                    Map<String, Object> record = (Map<String, Object>) JSON.deserializeUntyped(recordStr);
                    csvData += processRecordAsCSV(record, reportType) + '\n';
                }
                currentBatch.clear();  // Clear batch after processing
            }
        }
    }
    
    // Finish method to send the email after batch processing is done
    public void finish(Database.BatchableContext BC) {
        String subject = 'Report: ' + reportName;
        String emailBody = 'Please find the attached ' + reportName + ' report.';

        // Send the email with CSV attachment
        sendEmailWithAttachment(emailAddresses, subject, emailBody, csvData, reportName);
    }
    
    // Method to process each record into CSV format based on report type
    private static String processRecordAsCSV(Map<String, Object> record, String reportType) {
        List<String> csvRowData = new List<String>();

        if (reportType == 'Order Status Report – Summary') {
            csvRowData.add(String.valueOf(record.get('PO')));
            csvRowData.add(extractField(String.valueOf(record.get('isbn13'))));
            csvRowData.add(extractField(String.valueOf(record.get('productDescription'))));
            csvRowData.add(String.valueOf(record.get('orderDate')));
            csvRowData.add(String.valueOf(record.get('orderNumber')));
            csvRowData.add(String.valueOf(record.get('orderedQuantity')));
            csvRowData.add(String.valueOf(record.get('shippedQuantity')));
            csvRowData.add(String.valueOf(record.get('backorderQuantity')));
            csvRowData.add(String.valueOf(record.get('dueDate')));
            csvRowData.add(String.valueOf(record.get('holdQuantity')));
            csvRowData.add(String.valueOf(record.get('shippableQuantity')));
            csvRowData.add(String.valueOf(record.get('cancelledQuantity')));
            csvRowData.add(String.valueOf(record.get('shipAccount')));
            csvRowData.add(String.valueOf(record.get('shipAccountName')));
            csvRowData.add(String.valueOf(record.get('city')));
            csvRowData.add(String.valueOf(record.get('state')));
        }
        
        return String.join(csvRowData, ',');
    }
    
    // Safely extract fields with commas
    private static String extractField(String value) {
        if (value != null && value.contains(',')) {
            return '"' + value + '"';  // Surround with quotes if there's a comma
        } else {
            return value != null ? value : '';
        }
    }
    
    // Method to send email with CSV attachment
    private static void sendEmailWithAttachment(List<String> emailAddresses, String subject, String body, String csvData, String reportName) {
        try {
            OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = :system.label.scc_org_wide_email_address];
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if (owea.size() > 0) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }

            mail.setToAddresses(emailAddresses);
            mail.setSubject(subject);
            mail.setPlainTextBody(body);

            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            attachment.setFileName(reportName + '.csv');
            attachment.setBody(Blob.valueOf(csvData));
            mail.setFileAttachments(new List<Messaging.EmailFileAttachment>{attachment});

            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail});
        } catch (Exception e) {
            System.debug('Error while sending report email: ' + e.getMessage());
            throw new AuraHandledException('Error while sending report email: ' + e.getMessage());
        }
    }
}