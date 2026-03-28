public class EAccessThresholdTriggerHandler { 
    private static Id emailTemplateId = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'scc_eaccess_threshold' LIMIT 1].Id;

    public static void processThresholds(List<EAccess_Threshold__c> thresholdList) {
        Set<Id> imprintIds = new Set<Id>();

        for (EAccess_Threshold__c threshold : thresholdList) {
            imprintIds.add(threshold.EAccess_Imprints__c);
        }

        List<EAccess_Imprints__c> imprintsList = [
            SELECT Id, Admin_Email1__c, Admin_Email2__c 
            FROM EAccess_Imprints__c 
            WHERE Id IN :imprintIds
        ];

        Map<Id, EAccess_Imprints__c> imprintMap = new Map<Id, EAccess_Imprints__c>();
        for (EAccess_Imprints__c imprint : imprintsList) {
            imprintMap.put(imprint.Id, imprint);
        }

        for (EAccess_Threshold__c threshold : thresholdList) {
            EAccess_Imprints__c imprint = imprintMap.get(threshold.EAccess_Imprints__c);
            if (imprint != null) {
                sendEmail(imprint, threshold);
            }
        }
    }

   private static void sendEmail(EAccess_Imprints__c imprint, EAccess_Threshold__c threshold) {
    List<String> toAddresses = new List<String>();
    if (imprint.Admin_Email1__c != null) {
        toAddresses.add(imprint.Admin_Email1__c);
    }
    if (imprint.Admin_Email2__c != null) {
        toAddresses.add(imprint.Admin_Email2__c);
    }

    if (toAddresses.isEmpty()) {
        return; // Exit if there are no email addresses to send to
    }

    // Create a temporary Contact record
    Contact tempContact = new Contact(Email='dummy@example.com',FirstName='Test',LastName='test'); 
    insert tempContact; 

    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    mail.setToAddresses(toAddresses);
    mail.setTemplateId(emailTemplateId);

    // Set the email merge fields
    mail.setWhatId(threshold.Id); // Associate with the EAccess_Threshold__c record
    mail.setTargetObjectId(tempContact.Id); // Temporary Contact record
    mail.setSaveAsActivity(false);

    Messaging.sendEmail(new List<Messaging.SingleEmailMessage> { mail });

    // Cleanup the temporary Contact record
    delete tempContact;
}

}