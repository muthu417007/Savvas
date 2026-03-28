public with sharing class scc_reportEmailService {
    @AuraEnabled
    public static void sendReportEmail(List<String> emailAddresses, String reportType, String reportData, String reportName) {
        try {
            System.debug('Report Data Content: ' + reportData);
            
            // Retrieve the organization-wide email address
            OrgWideEmailAddress[] owea = [
                SELECT Id 
                FROM OrgWideEmailAddress 
                WHERE Address = :System.Label.scc_org_wide_email_address
            ];
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            // Set the organization-wide email address if available
            if (owea.size() > 0) {
                mail.setOrgWideEmailAddressId(owea[0].Id);
            }

            
            mail.setToAddresses(emailAddresses);
            mail.setSubject('Report: ' + reportName);
            mail.setPlainTextBody('Please find the attached report.');

            // Create the email attachment
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            attachment.setFileName(reportName + '.csv'); 
            attachment.setBody(Blob.valueOf(reportData)); 
            attachment.setContentType('text/csv'); 

            // Attach the CSV file to the email
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });

            // Send the email
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        } catch (Exception e) {
           System.debug('Line number: ' + e.getLineNumber());
            System.debug('Message: ' + e.getMessage());    
        }
    }
}