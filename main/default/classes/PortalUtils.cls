/**
 * Helper class for Community
 * 
 * @date 2014-08-25
 * @author Wojciech Migas
 * @Modified Date 2024-08-06
 * @Modified By Cognizant Team
 * @Ticket Number: W-014716
 */
public without sharing class PortalUtils {
    /**
     * Populate user based on contact object. It uses usernameprefix from custom settings
     * 
     * @date 2014-08-25
     * @author Wojciech Migas
     * @param Contact c Contact with base
     * @return User portal User object to insert
     */
    public static user createPortalUserFromContact(Contact c) {
        CommunityRegistrationSettings__c registrationSettings = CommunityRegistrationSettings__c.getInstance();
        return createPortalUserFromContact(c, registrationSettings.userNameSuffix__c);
    }

    /**
     * Populate user based on contact object.
     * 
     * @date 2014-08-25
     * @author Wojciech Migas
     * @param Contact c Contact with base
     * @param String userNameSuffix User name suffix. Can be null
     * @return User portal User object to insert
     */
    public static user createPortalUserFromContact(Contact c, String userNameSuffix) {
        CommunityRegistrationSettings__c registrationSettings = CommunityRegistrationSettings__c.getInstance();
        try {
		        User u = new User(
		            UserName            = c.Email + (String.isBlank(userNameSuffix) ? '' : userNameSuffix),
		            Email               = c.Email,
		            Alias               = c.FirstName.left(1) + c.LastName.Left(7),
		            //community nickname must be unique, that is why we use email address
		            CommunityNickName   = (c.Email + ' ' + c.FirstName + ' ' + c.LastName).left(40),
		            LastName            = c.LastName, 
		            FirstName           = c.FirstName, 
		            ContactId           = c.Id,
		            ProfileId           = registrationSettings.ProfileId__c,
		            TimeZoneSidKey      = registrationSettings.TimeZone__c,
		            LocaleSidKey        = registrationSettings.Locale__c,
		            EmailEncodingKey    = registrationSettings.EmailEncoding__c,
		            LanguageLocaleKey   = registrationSettings.LanguageLocale__c,
		            IsActive            = true
		        );
		        return u;
        }
        catch(exception e) {
        	return null;
        }
    }

    /**
     * Search contact by case number and contact email address
     *
     * @date 2014-08-25
     * @author Wojciech Migas
     * @param String caseNumber Case number
     * @param String email Email address of contact associated with case number
     * @return Contact Contact object
     */
    public static Contact getContactByCaseNumberAndEmail(String caseNumber, String email) {
        List<Case> cases = [SELECT Contact.Id, Contact.FirstName, Contact.LastName, Contact.Email  FROM Case WHERE CaseNumber =: caseNumber AND Contact.Email =: email];
        if (cases.isEmpty()) {
            return null;
        } else {
            return cases[0].Contact;
        }
    }

    /**
     * Methods returns true, if there is a user associated with given contact Id
     * 
     * @date 2014-08-26
     * @author Wojciech Migas
     * @param Id contactId Contact Id
     * @return Boolean true if there is a user associated with given contact Id
     */
    public static Boolean checkIfContactHasAssociatedUser(Id contactId) {
        List<User> users = [SELECT Id FROM User WHERE ContactId =: contactId];
        return users.size()>0;
    }

    /**
     * Methods returns true, if there is nick name is avaialble
     * 
     * @date 2014-08-26
     * @author Wojciech Migas
     * @param String nickName Nick name
     * @return Boolean if there is nick name is avaialble
     */
    public static Boolean checkNickNameAvailability(String nickName) {
        List<User> users = [SELECT Id FROM User WHERE CommunityNickName =: nickName];
        return users.isEmpty();
    }

    /**
     * Methods returns relative community URL to the given page
     * 
     * @date 2014-08-26
     * @author Wojciech Migas
     * @param PageReference pr Page reference
     * @return String Relative community URL to the given page
     */
    public static String getUrlForPage(PageReference pr) {
        String res = Site.getPathPrefix();
        res += Page.ForgotPassword.getUrl().replace('/apex/', '/');
        return res;
    }

    public static void logException(Exception e) {
        logException(e, '');
    }

    public static void logException(Exception e, String developerMessage) {
        log(developerMessage, e.getMessage(), e.getStackTraceString(), e.getTypeName());
    }
    
    public static void logException(String developerMessage) {
        logException(developerMessage, 'DEVELOPER_MESSAGE');
    }

    public static void logException(String developerMessage, String type) {
        log(developerMessage, '', '', type);
    }

    private static void log(String developerMessage, String exceptionMessage, String stackTrace, String exceptionType) {
        ErrorLoggingSettings__c els = ErrorLoggingSettings__c.getInstance();
        if (els.enabled__c) {
            Exception_Log__c log = new Exception_Log__c(
                DeveloperMessage__c = developerMessage,
                Message__c          = exceptionMessage,
                StackTrace__c       = stackTrace,
                Type__c             = exceptionType
            );        
            insert log;
        }
    }

    /** W-014715: SSO Implementation changes**/
    /**
     * Methods returns true, if there is PS assigned and mail send to given user
     * 
     * @date 2024-05-10
     * @author Cognizant Team
     * @param User user
     * @return Boolean true if CC PS assigned and send Activation Mail to given user
     */
    public static Boolean assignPSAndSendMail(User user) {
        try{
            PermissionSet permSet = [SELECT id FROM PermissionSet WHERE Name=: Label.Savvas_Customer_Care_Permissions];
                PermissionSetAssignment pemSetAss = new PermissionSetAssignment (PermissionSetId=permSet.Id, AssigneeId=user.Id);
            	Database.SaveResult sr = Database.insert(pemSetAss);
                if(sr.isSuccess()){
                    System.resetPasswordWithEmailTemplate(user.Id, true, Label.Savvas_Customer_Care_Welcome_Email);
                    return true;
                } 
                else{
                    return false;
                }
            }
            catch(Exception e){
                throw new AuraHandledException(e.getMessage());
            }
    }

    /** W-014716: SSO App Access Management for Customer Care**/
    /**
     * Methods returns integer, based on user associated with given contact Id
     * 
     * @date 2024-05-10
     * @author Cognizant Team
     * @param Id contactId Contact Id
     * @return Integer based on user associated with given contact Id
     */
    public static Integer checkIfContactHasExistingUser(Id contactId) {
        try{
        	List<User> users = [SELECT Id, FirstName, Profile.name, Email, ContactId FROM User WHERE ContactId =: contactId];
			if(!users.isEmpty()){
            	PermissionSet permSet = [SELECT id FROM PermissionSet WHERE Name=: Label.Savvas_Customer_Care_Permissions];
                List<PermissionSetAssignment> listPSAss = [SELECT Id from PermissionSetAssignment WHERE PermissionSetId =: permSet.Id AND AssigneeId =: users[0].Id];
				if(listPSAss.isEmpty()){
					PermissionSetAssignment pubSetAss = new PermissionSetAssignment(PermissionSetId = permSet.Id, AssigneeId = users[0].Id);
					Insert pubSetAss;
   
                    OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =: Label.Savvas_Customer_Care_Email_Address];
       			 	EmailTemplate emailTemplate = [SELECT Id, Name, htmlValue, Subject FROM EmailTemplate WHERE Name =: Label.Savvas_Customer_Care_Access_Notification_Email];
        			Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        			message.setTemplateID(emailTemplate.Id); 
        			message.setTargetObjectId(users[0].Id); 
        			message.setOrgWideEmailAddressId(owea.get(0).Id);
        			message.setUseSignature(false); 
        			message.setBccSender(false); 
        			message.setSaveAsActivity(false);
        			message.toAddresses = new String[]{users[0].Email}; 
        			String htmlBody = emailTemplate.HtmlValue;
        			String subject = emailTemplate.Subject;
        			htmlBody = htmlBody.replace('communityName',Label.Savvas_Customer_Care_Community);
                    htmlbody= htmlBody.replace('[[userFirstName]]',users[0].firstName);
                    subject = subject.replace('communityName',Label.Savvas_Customer_Care_Community);
        			message.setHtmlBody(htmlBody);
                    message.setSubject(subject);
        			Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{message};
        			Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                    return 2;
				}
                return 1;
			}
            return 0;
            
		}
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
        
    }
}