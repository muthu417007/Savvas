public with sharing class AccountSupportNotesController {

    private final String  objId;
    public List<MessageWrapper> messages {get; protected set;}

    public AccountSupportNotesController() {
        objId       = ApexPages.currentPage().getParameters().get('id');
        messages    = new List<MessageWrapper>();
        if (String.isNotBlank(objId) && String.valueOf(objId).startsWith('001')) {
            List<Account_Support_Note__c> accSupportNotes = [SELECT Message__c, Type__c, ExpirationDate__c, StartDate__c FROM Account_Support_Note__c 
                WHERE Account__c =: objId AND ExpirationDate__c >= TODAY AND StartDate__c <= TODAY];
            for (Account_Support_Note__c accSupportNote : accSupportNotes) {
                messages.add(new MessageWrapper(accSupportNote));
            }
        } else if (String.isNotBlank(objId) && String.valueOf(objId).startsWith('500')) {
            List<Case> cases = [SELECT AccountId FROM Case WHERE Id =: objId];
            if (cases.size()>0 && String.isNotBlank(cases[0].AccountId)) {
                List<Account_Support_Note__c> accSupportNotes = [SELECT Message__c, Type__c, ExpirationDate__c, StartDate__c FROM Account_Support_Note__c 
                    WHERE Account__c =: cases[0].AccountId AND ExpirationDate__c >= TODAY AND StartDate__c <= TODAY];
                for (Account_Support_Note__c accSupportNote : accSupportNotes) {
                    messages.add(new MessageWrapper(accSupportNote));
                }
            }
        }
        
    }

    public class MessageWrapper {
        public String content {get; protected set;}
        public String type {get; protected set;}
        public Date expirationDate {get; protected set;}
        public Date startDate {get; protected set;}
        public MessageWrapper(Account_Support_Note__c accSupportNote) {
            content         = accSupportNote.Message__c;
            type            = accSupportNote.Type__c;
            expirationDate  = accSupportNote.ExpirationDate__c;
            startDate       = accSupportNote.StartDate__c;
        }
    }
}