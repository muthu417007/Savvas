public without sharing class SendMail {
    
@AuraEnabled 
    public static void SendEmailTemplateWithTemplate(String email) {
       String emailid=email;
        system.debug('emailid is '+emailid+' 2nd emsil'+ email);
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        EmailTemplate emailTemp = [Select id, Subject, Body From EmailTemplate Where DeveloperName = 'Savvas_Sample_Resources_Forgot_Password_Template'];
        Contact con = [Select Id, Email from Contact where Email =:email];
      //  User currentuser = [SELECT Id, Name FROM User WHERE Id = :UserInfo.getUserId()];
        
       /* String emailBody = template.HtmlValue.replace('{!User.Name}', currentUser.Name)
            .replace('{!User.Email}', currentUser.Email); */
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTemplateId(emailTemp.Id);
        mail.setTargetObjectId(con.Id);
        emailList.add(mail);
        
        if(!emailList.isEmpty()){
            Messaging.sendEmail(emailList); 
        }    
    }
       
    public static void tetmethod(){
       // String sfdcURL = URL.getOrgDomainUrl().toExternalForm();
        //String communityUrl = System.Url.getSalesforceBaseUrl().toExternalForm();
        //
        User currentuser = [SELECT Id FROM User WHERE Id ='005W4000001QnkfIAC'];
       // String usrname = Test Contact2;
       // string url=Site.forgotPassword(currentuser.Name);
        //system.debug('    '+Site.forgotPassword(currentuser.Username)); 
        //PageReference pr = Page.CommunityForgotPasswordConfirm; 
        //string resetpasswordurl= system.resetpassword(currentuser.id,true);
         //system.debug('  byluck  '+resetpasswordurl); 
        //String forgotPasswordUrl = System.Url.getOrgDomainUrl().toExternalForm() + '/secur/forgotpassword.jsp?';
          String sfdcURL = URL.getOrgDomainUrl().toExternalForm(); 
        system.debug('  byluck2  '+sfdcURL);
        
    }
}