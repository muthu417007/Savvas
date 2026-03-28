public class scc_userExistEmail {
 @future
     public static void SendEmailUserExistEmail(String email) {
       
      System.debug('email template called'+ email); 
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        EmailTemplate emailTemp = [Select id, Subject, Body From EmailTemplate Where DeveloperName = 'MySavvasOrder_UserExist_LicenseUpgrade'];
        Contact con = [Select Id, Email from Contact where Email =:email];
              
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        Map<String, String> templateData = new Map<String, String>();
        mail.setTemplateId(emailTemp.Id);
        mail.setTargetObjectId(con.Id);
       //  mail.setSubject('Single Email message Example');
		//mail.setPlainTextBody('Hello!!!!!!!!!!This is a test email to test single email message program');
		
         
        emailList.add(mail);
        
        if(!emailList.isEmpty()){
            Messaging.sendEmail(emailList); 
              System.debug('email template called'  ); 
        }    
    }
}