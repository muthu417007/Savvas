public class ProcessForwardedEmailsToSupportCase {
    
    public static void setCaseWebAddressForForwardedEmails (List<EmailMessage> emailMessages) {
    	//get list of addresses from metadata that we want to filter for and check for FORWARDED message in email body
    	//on emails from those addresses:
    	//1. Set From address to customer address on forwarded emails
    	//2. Set case web email to customer address on forwarded emails
    	//3. set contact to valid contact if we can find one on forwarded emails. 
    	
        List<Email_To_Case_Forwarding_Address__mdt> caseForwardingAddresses = [SELECT MasterLabel, QualifiedApiName, Customer_Facing_Email_Address__c,Email_Field_Name__c,Customer_Email_in_Body__c FROM Email_To_Case_Forwarding_Address__mdt];
        Map<String,Email_To_Case_Forwarding_Address__mdt> emailsToFilter = new Map<String, Email_To_Case_Forwarding_Address__mdt>();
        List<Id> parentCaseIds = new List<Id>();
        Map<String,EmailMessage> forwardedMessages = new Map<String, EmailMessage>();
        List<String> customerEmailAddresses = new List<String>();
        Map<Id,Contact> contactIdsFromEmails;
        Map<Id,Case> parentCases;

        for(Email_To_Case_Forwarding_Address__mdt mdt: caseForwardingAddresses){
            emailsToFilter.put(mdt.Customer_Facing_Email_Address__c, mdt);

        }
        
        if(!emailsToFilter.isEmpty()) {
            for (EmailMessage msg: emailMessages) {

                if (emailsToFilter.containsKey(msg.FromAddress)) {
                    parentCaseIds.add(msg.ParentId);
                    
                    String email = '';
                    String field = emailsToFilter.get(msg.FromAddress).Email_Field_Name__c;

                    if(emailsToFilter.get(msg.FromAddress).Customer_Email_in_Body__c && emailsToFilter.get(msg.FromAddress).Email_Field_Name__c != '' ){
                        email = msg.TextBody.substring(msg.TextBody.indexOf(field)+field.length(), msg.TextBody.indexOf('^^')).trim();

                    } else {
                        email = msg.TextBody.substring(msg.Headers.indexOf('Reply-To:')+1,msg.TextBody.indexOf('\\n'));

                    }
                    
                    if(email != '') forwardedMessages.put(email,msg);
                }
        	}
        
            if(!parentCaseIds.isEmpty() && !forwardedMessages.isEmpty()) { 
                parentCases = new Map<Id,Case>([SELECT Id, SuppliedEmail,ContactId FROM Case WHERE id IN :parentCaseIds]);	
                contactIdsFromEmails = new Map<Id,Contact>([SELECT Id, Email FROM Contact WHERE Email IN :forwardedMessages.keySet()]);
                
                System.debug('Key Set: ' + forwardedMessages.keySet());

                for(String email: forwardedMessages.keySet()) {
                    EmailMessage msg = forwardedMessages.get(email);
                    Case parentCase = parentCases.get(msg.ParentId);
                    Id contactId = null;
                    
					parentCase.SuppliedEmail = email;

                    for(Contact c: contactIdsFromEmails.values()){
                        System.debug('Contact: ' + c.Id);
                        if(c.Email == email){
                            parentCase.ContactId = c.Id;
                            break;
                        } 
                    }
                    
                    parentCase.Problem_Resolution__c = ' Customer Email Found: ' + email;
                }
                
                update parentCases.values();
                
            }
        }
    }
}