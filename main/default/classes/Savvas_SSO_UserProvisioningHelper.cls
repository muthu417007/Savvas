/*
    @Author : Cognizant Team
    @Name : Savvas_SSO_UserProvisioningHelper
    @CreateDate : 04-June-2024
    @Description: Helper class for Savvas_SSO_UserProvisioningApi class
    @ModifiedBy: Cognizant Team
    @ModifiedDate: 02-July-2024
    @Ticket Number: W-014599
*/
public without sharing class Savvas_SSO_UserProvisioningHelper {
    // Wrapper class - LogDetailsWrapper
    public class LogDetailsWrapper{
        public String message;
        public Boolean status;
        public String userId;
        public String permId;
    }
    /*
    *  Method Name : getUserList
    *  Description : Fetch User Records
    *  param : email
    *  return : List<User>
    */
    public static List<User> getUserList(String email){
        List<User> userList = new List<User>();
        try{
            userList = [
                SELECT Id, ProfileId, ContactId, Email, FirstName
                FROM USER 
                WHERE Username=:email 
                AND IsActive=true
                LIMIT 1
            ];
        }
        catch(Exception e){
            System.debug(e.getLineNumber() + ' ==>' + e.getMessage());
        }
        return userList;
    }
    /*
    *  Method Name : getContactList
    *  Description : Fetch Contact Records
    *  param : email, accountID
    *  return : List<Contact>
    */
    public static List<Contact> getContactList(String email, String accountId, String contactId){
        List<Contact> contactList = new List<Contact>();
        try{
            // Executed from Batch class only
            if(contactId!=null){
                contactList = [
                    SELECT Id from Contact 
                    WHERE AccountId=:String.escapeSingleQuotes(accountId) 
                    AND Email=:String.escapeSingleQuotes(email) 
                    AND Id=:contactId
                    LIMIT 1
                ];
            }
            // Executed from User Provisioning Api
            else{
                contactList = [
                    SELECT Id from Contact 
                    WHERE AccountId=:String.escapeSingleQuotes(accountId) 
                    AND Email=:String.escapeSingleQuotes(email) 
                    AND Account.Account_Status__c=:Savvas_SSO_ConstantsUtil.isActive
                    AND Inactive__c=false
                    LIMIT 1
                ];
            }
        }
        catch (Exception e){
            System.debug(e.getLineNumber() + ' ==>' + e.getMessage());
        }
        return contactList;
    }
    /*
    *  Method Name : updateUserAccess
    *  Description : Updates User access using Permission Set Assignment
    *  param : user, appName
    *  return : LogDetailsWrapper
    */
    public static LogDetailsWrapper updateUserAccess(User user, String appName){
        appName = String.escapeSingleQuotes(appName);
        LogDetailsWrapper ldw = new LogDetailsWrapper();
        try{
            List<Savvas_Single_Sign_On_Metadata__mdt> registerMetadataList = [
                SELECT Permission_Set__c, Notification_Email_Template__c 
                FROM Savvas_Single_Sign_On_Metadata__mdt 
                WHERE Label=:appName
                LIMIT 1
            ];
            if(!registerMetadataList.isEmpty() && registerMetadataList[0].Permission_Set__c!=null && registerMetadataList[0].Notification_Email_Template__c!=null){
                String appPermissionSetName = registerMetadataList[0].Permission_Set__c;
                String notificationEmailTemplateName = registerMetadataList[0].Notification_Email_Template__c;
                List<PermissionSetAssignment> userPSAList = [
                    SELECT PermissionSetId 
                    FROM PermissionSetAssignment 
                    WHERE AssigneeId =:user.Id 
                    AND PermissionSet.Name =:appPermissionSetName
                ];
                if(userPSAList.isEmpty()){
                    List<PermissionSet> psIdList = [
                        SELECT Id 
                        FROM PermissionSet 
                        WHERE Name =: appPermissionSetName 
                        LIMIT 1
                    ];
                    PermissionSetAssignment appPsa = new PermissionSetAssignment(PermissionSetId = psIdList[0].Id, AssigneeId = user.Id);
                    Database.SaveResult sr = Database.insert(appPsa);
                    if(sr.isSuccess()){
                        ldw.permId = sr.getId();
                        Database.SaveResult userSr = Database.update(user);
                        if(userSr.isSuccess()){
                            ldw.userId = userSr.getId();
                            ldw.message = Savvas_SSO_ConstantsUtil.success.toUpperCase();
                            ldw.status = true;
                        }
                        if(System.Label.Savvas_SSO_BypassNotificationEmail=='false'){
                            Boolean emailStatus = sendNotificationEmail(user, notificationEmailTemplateName);
                            if (emailStatus){
                                ldw.message = Savvas_SSO_ConstantsUtil.success.toUpperCase();
                                ldw.status = true;
                            }
                            else{
                                ldw.message = Savvas_SSO_ConstantsUtil.accessNotificationEmailFailLog;
                                ldw.status = true;
                            }
                        }
                    }
                    else{
                        ldw.message = Savvas_SSO_ConstantsUtil.psAssignmentFailLog;
                        ldw.status = false;
                    }
                }
                else{
                    ldw.message = Savvas_SSO_ConstantsUtil.duplicateAccessFailLog;
                    ldw.status = false;
                }
            }
            else{
                ldw.message = Savvas_SSO_ConstantsUtil.appMetadataNotFoundFailLog;
                ldw.status = false;
            }
            return ldw;
        }
        catch(Exception e){
            ldw.message = e.getLineNumber() + ': ' + e.getMessage();
            ldw.status = false;
            return ldw;
        }
    }
    /*
    *  Method Name : sendNotificationEmail
    *  Description : Send User Email for access update using Permission Set Assignment
    *  param : user, notificationEmailTemplateName
    *  return : Boolean
    */
    public static Boolean sendNotificationEmail(User user, String notificationEmailTemplateName){
        OrgWideEmailAddress[] owea = [
            SELECT Id from OrgWideEmailAddress 
            WHERE Address =: System.Label.Savvas_SSO_OrgWideEmailAddress 
            LIMIT 1
        ];
        EmailTemplate emailTemplate = [
            SELECT Id,DeveloperName, Subject, htmlValue 
            FROM EmailTemplate 
            WHERE DeveloperName=:notificationEmailTemplateName 
            LIMIT 1
        ];
        if(!owea.isEmpty() && emailTemplate!=null && user.ContactId!=null && user.Email!=null && user.FirstName!=null){
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setTemplateID(emailTemplate.Id); 
            message.setTargetObjectId(user.ContactId); 
            message.setOrgWideEmailAddressId(owea.get(0).Id);
            message.setUseSignature(false); 
            message.setBccSender(false); 
            message.setSaveAsActivity(false);
            message.toAddresses = new String[]{user.Email}; 
            String htmlBody = emailTemplate.HtmlValue;
            String subject = emailTemplate.Subject;
            message.setSubject(subject);
            htmlBody = htmlBody.replace(Savvas_SSO_ConstantsUtil.emailTemplateFirstName, user.FirstName);
            message.setHtmlBody(htmlBody);
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages); 
            LogDetailsWrapper ldw = new LogDetailsWrapper();
            if(results[0].success){
                return true;
            }
            else{
                return false;
            }
        }
        else{
            return false;
        }
    }
    /*
    *  Method Name : registerNewUser
    *  Description : Create New User 
    *  param : email, firstName, lastName, contact, appName
    *  return : LogDetailsWrapper
    */
    public static LogDetailsWrapper registerNewUser(String email, String firstName, String lastName, Contact c, String appName){
        email = String.escapeSingleQuotes(email);
        appName = String.escapeSingleQuotes(appName);
        LogDetailsWrapper ldw = new LogDetailsWrapper();
        try{
            SavvasSSORegistrationSettings__c registrationSettings = SavvasSSORegistrationSettings__c.getInstance();
            Datetime datetimeNow = Datetime.now();
			String epochTime = String.valueof(datetimeNow.getTime());
            if(registrationSettings!=null && registrationSettings.ProfileId__c!=null && registrationSettings.TimeZone__c!=null && registrationSettings.Locale__c!=null && registrationSettings.EmailEncoding__c!=null && registrationSettings.LanguageLocale__c!=null){
                User u = new User(
		            UserName = email,
		            Email = email,
		            Alias = firstName.left(1) + lastName.Left(7),
		            CommunityNickName = (epochTime + ' ' + firstName + ' ' + lastName).left(40),
		            LastName = lastName, 
		            FirstName = firstName, 
		            ContactId = c.Id,
		            ProfileId = registrationSettings.ProfileId__c,
		            TimeZoneSidKey = registrationSettings.TimeZone__c,
		            LocaleSidKey = registrationSettings.Locale__c,
		            EmailEncodingKey = registrationSettings.EmailEncoding__c,
		            LanguageLocaleKey = registrationSettings.LanguageLocale__c,
		            IsActive = true
		        );
                Savepoint sp = Database.setSavepoint();
                Database.SaveResult sr = Database.insert(u);
                if(sr.isSuccess()){
                    String userId = sr.getId();
                    ldw.userId = userId;
                    List<Savvas_Single_Sign_On_Metadata__mdt> registerMetadataList = [
                        SELECT Permission_Set__c, Welcome_Email_Template__c
                        FROM Savvas_Single_Sign_On_Metadata__mdt 
                        WHERE Label=:appName 
                        LIMIT 1
                    ];
                    if(!registerMetadataList.isEmpty() && registerMetadataList[0].Permission_Set__c!=null && registerMetadataList[0].Welcome_Email_Template__c!=null){
                        List<PermissionSet> permissionSetList = [
                            SELECT Id 
                            FROM PermissionSet 
                            WHERE Name =: registerMetadataList[0].Permission_Set__c
                            LIMIT 1
                        ];
                        String appPermissionSetId = permissionSetList[0].Id;
                        String welcomeEmailTemplateName = registerMetadataList[0].Welcome_Email_Template__c;
                        PermissionSetAssignment appPsa = new PermissionSetAssignment (PermissionSetId=appPermissionSetId, AssigneeId=userId);
                        Database.SaveResult psaAssignmentSR = Database.insert(appPsa);
                        if(psaAssignmentSR.isSuccess()){
                            ldw.permId = psaAssignmentSR.getId();
                            sendActivationEmail(userId, welcomeEmailTemplateName);
                            ldw.message = Savvas_SSO_ConstantsUtil.success;
                            ldw.status = true;                            
                        }
                        else{
                            Database.rollback(sp);
                            ldw.message = Savvas_SSO_ConstantsUtil.psAssignmentFailLog;
                            ldw.status = false;
                        }
                    }
                    else{
                        Database.rollback(sp);
                        ldw.message = Savvas_SSO_ConstantsUtil.appMetadataNotFoundFailLog;
                        ldw.status = false;
                    }
                }
                else{
                    ldw.message = Savvas_SSO_ConstantsUtil.userInsertFailLog;
                    ldw.status = false;
                }
            }
            else{
                ldw.message = Savvas_SSO_ConstantsUtil.customSettingFailLog;
                ldw.status = false;
            }
            return ldw;
        }
        catch(Exception e){
            ldw.message = e.getLineNumber() + ': ' + e.getMessage();
            ldw.status = false;
            return ldw;
        }
    }
    /*
    *  Method Name : sendActivationEmail
    *  Description : Send User Email for new user activation
    *  param : userId, emailTemplateName
    *  return : void
    */
    public static void sendActivationEmail(String userId, String emailTemplateName){
        System.ResetPasswordResult result = System.resetPasswordWithEmailTemplate(userId, true, emailTemplateName);
    }    
}