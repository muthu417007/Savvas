/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Apex class that contains methods shared between integration classes
*
* Apex class that contains methods shared between integration classes
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Romer Pasag   	<Romer.Pasag@pearson.com>
* @modifiedBy     Romer Pasag   	<Romer.Pasag@pearson.com>
* @maintainedBy   Romer Pasag   	<Romer.Pasag@pearson.com>
* @version        1.0
* @created        2017-09-18
* @modified       
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* v1.0        	  Romer.Pasag@pearson.com
* 		
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

public class BuzzIntegrationUtility {
    
    // Send email to integration admin public group that there was an errors
    public static void sendEmailError(String errorCode){
        List<string> toAddresses=new List<string>();
        
        for(user u:[select email from user where isActive=true and id in (select userorgroupid from groupmember where group.name like '%ICOM Admin%')]){
            toAddresses.add(u.email);
        }
        system.debug(toAddresses.size());
        if(toAddresses.size()>0){
            
            Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddresses);
            mail.setReplyTo('donotreply.customersupport@pearson.com	');
            mail.setSenderDisplayName('Do Not Reply');
            if(errorCode.equalsIgnoreCase('ErrorURL')){
            	mail.setSubject('Login error into Buzz Agilix: Invalid URL');
            	mail.setPlainTextBody('Invalid URL encountered login into Buzz Agilix.  Please check configuration at the BuzzLoginCallout Apex Class');
            }else if(errorCode.equalsIgnoreCase('invalidCredential')){
                mail.setSubject('Error Login into Buzz Agilix: Invalid Credential');
            	mail.setPlainTextBody('Error encountered login into Buzz Agilix.  Please check credential at the Buzz API Named Credential');
            }else if(errorCode.containsIgnoreCase('Kimble')){
                mail.setSubject('Error Calling the Kimble Resource Capability Import Interface. '+errorCode);
            	mail.setPlainTextBody('Error Calling the Kimble Resource Capability Import Interface.  Cannot Process Import');
            }else if(errorCode.equalsIgnoreCase('buzzUpdateError')){
                mail.setSubject('Error updating an Enrollment on Buzz.');
            	mail.setPlainTextBody('Error updating an Enrollment on Buzz.  Cannot Process Update');
            }else{
                mail.setSubject('Bad Request encountered with Buzz Integration');
            	mail.setPlainTextBody('Bad Request encountered with Buzz Integration');
            }
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
}