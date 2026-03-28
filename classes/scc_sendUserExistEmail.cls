/*
Apex Class:scc_sendUserExistEmail
Author: CTS (Muthukumar)
Created Date: 19/06/2024
Reason: Send email to existing user when permission set us assigned
*/
public with sharing class scc_sendUserExistEmail {
    /**
*  Description: This method send email to existing user when permission set us assigned    
*  @name: SendEmailUserExistEmail
*  @param:email
*  @return: NA
*  @throws exception- 
*/
    @AuraEnabled
    public static void SendEmailUserExistEmail(String email) {
        try{
            String emailid=email;      
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = : system.label.scc_org_wide_email_address];
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if ( owea.size() > 0 ) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);          
            }
            
            Messaging.reserveSingleEmailCapacity(2);
            
            List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
            EmailTemplate emailTemp = [Select id, Subject, Body From EmailTemplate Where DeveloperName =: System.Label.scc_UserExist_LicenseUpgrade_EmailTemplate Limit 1];
            Contact con = [Select Id, Email from Contact where Email =:email WITH SECURITY_ENFORCED Limit 1];        
            Map<String, String> templateData = new Map<String, String>();
            mail.setTemplateId(emailTemp.Id);
            mail.setTargetObjectId(con.Id);
            mail.setSaveAsActivity(false);
            emailList.add(mail);
            
            if(!emailList.isEmpty()){
                Messaging.sendEmail(emailList);               
            }  
        }
        catch(Exception e){
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());    // returns null
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());
            throw new AuraHandledException('Failed to send email to existing user :'+e.getMessage()+e.getCause());
        }
    }
}