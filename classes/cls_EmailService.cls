/*
Class Name: cls_EmailService
Purpose : This class is used to send report to external users(Pearson Employees) who are not in salesforce.
          Utilize ApexReport__mdt metadata type to configure Email addresses, Email body and Subject. Use Metadata lable
          to configure report(use report developer name) which to send in email.
          
          Common class to send emails. 
          Refferred classes : cls_sendreport_to_extUsers
          
*/
public class cls_EmailService {
    public string subject{get;set;} // mail subject
    public List<String> toAddresses{get;set;} // send to emails
   // public List<String> CCAddresses{get;set;} // cc emails
    public String body{set;get;} // mail plain body
    public string displayName{set;get;} // from email name
    public boolean isAttachment {set;get;} // if we have to send attachment file in mail
   // public Map<String,String> attachFiles {set;get;} // key = attachmentName and value =attachmentBody 
    public boolean isHtml{set;get;}
    public List<Messaging.EmailFileAttachment> attachments; 
    public Messaging.SingleEmailMessage email;
    public cls_EmailService (Messaging.SingleEmailMessage mailMessage){
        attachments = new List<Messaging.EmailFileAttachment>();
        email =mailMessage;
        this.isAttachment=false;  
    }
    public void sendMail(){
        email.setSubject(subject);
        email.setToAddresses(toAddresses);
        email.setSenderDisplayName(displayName);
        if(isHtml){
            email.setHtmlBody(body);
        }
        else{
            email.setPlainTextBody(body);
        }
        if(isAttachment){
            email.setFileAttachments(attachments);  
        }
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
        system.debug('Email sent');
    }
}