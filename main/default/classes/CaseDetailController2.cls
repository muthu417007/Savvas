/**
 * An apex page controller that extends a default case detail page
 */
public with sharing class CaseDetailController2 {

    private final Case caseObj;

    public Id caseId {get;protected set;}

    public List<MessageWrapper> messages {get; protected set;}
    
    /**
     * Class constructor
     * Check if there are any support notes for associated account
     * 
     * @date 2014-08-28
     * @author Wojciech Migas
     * @return void
     *
     * Class modified 2014-09-08 by Joanne Hicks to include Contact Support Notes
     *
     */
    public CaseDetailController2(ApexPages.StandardController stdController) {
        //add AccountId to SOQL
        LIST<String> fieldNames = new List<String>();
        fieldNames.add('AccountId');
        fieldNames.add('ContactId');
        if (!Test.isRunningTest()) {
            stdController.addFields(fieldNames);
        }
        
        //initialize variables
        messages    = new List<MessageWrapper>();        
        caseObj     = (Case)stdController.getRecord();
        caseId      = caseObj != null ? caseObj.Id : null;

        CommunityRegistrationSettings__c crs = CommunityRegistrationSettings__c.getInstance();        
        //get messages
        //do not display account support messages for community users "UserInfo.getProfileId() != (Id)crs.ProfileId__c"
        if (caseObj != null && String.isNotBlank(caseObj.AccountId) && UserInfo.getProfileId() != (Id)crs.ProfileId__c) {
            List<Account_Support_Note__c> accSupportNotes = [SELECT Message__c, Type__c, ExpirationDate__c, StartDate__c FROM Account_Support_Note__c 
                WHERE Account__c =: caseObj.AccountId AND (ExpirationDate__c >= TODAY OR ExpirationDate__c = null) AND (StartDate__c <= TODAY OR StartDate__c = null)];
            if (accSupportNotes.size() > 0)
                messages.add(new MessageWrapper('Account Support Notes'));
            for (Account_Support_Note__c accSupportNote : accSupportNotes) {
                messages.add(new MessageWrapper(accSupportNote));
            }
    
            //repeat for Contact Support Notes
            List<Contact_Support_Note__c> conSupportNotes = [SELECT Message__c, Type__c, ExpirationDate__c, StartDate__c FROM Contact_Support_Note__c 
                WHERE Contact__c =: caseObj.ContactId AND (ExpirationDate__c >= TODAY OR ExpirationDate__c = null) AND (StartDate__c <= TODAY OR StartDate__c = null)];
            if (conSupportNotes.size() > 0)
                messages.add(new MessageWrapper('Contact Support Notes'));
            for (Contact_Support_Note__c conSupportNote : conSupportNotes) {
                messages.add(new MessageWrapper(conSupportNote));
            }
        }
    }

    /**
     * Wrapper class for account support notes
     */
    public class MessageWrapper {
        public String content {get; protected set;}
        public String type {get; protected set;}
        public Date expirationDate {get; protected set;}
        public Date startDate {get; protected set;}
        public boolean isTitle {get; protected set;}
        public MessageWrapper(sObject supportNote) {
            content         = (string) supportNote.get('Message__c');
            type            = (string) supportNote.get('Type__c');
            expirationDate  = (Date) supportNote.get('ExpirationDate__c');
            startDate       = (Date) supportNote.get('StartDate__c');
            isTitle         = false;
        }
        public MessageWrapper(String title)  {
            content = title;
            isTitle = true;
        }
    }
}