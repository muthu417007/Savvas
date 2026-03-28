/*Apex Class:scc_registrationformController
    Author: CTS (Sudharani Pathivada)
    Created Date: 22/03/2024
    Reason: This Controller referered in LWC "scc_registrationformController" for the savvas LWC component.
    Description: This apex helps the user do self-registration.   
    Modified Date: 24/04/2024
    */
global without sharing class scc_registrationformController  {
    /*
RegistrationResponse Logic start
*  Description: this metod declaring  variables
*  @name: RegistrationResponse
*/
    global class RegistrationResponse {
        @AuraEnabled
        public Boolean isContactValid;
        @AuraEnabled
        public Boolean isSendEmail;
        @AuraEnabled
        public Boolean isAccountValid;
        @AuraEnabled
        public Boolean isUserValid;
        @AuraEnabled
        public Boolean isNewUser;
        @AuraEnabled
        public Boolean userExists;
        @AuraEnabled
        public String contactId;
        @AuraEnabled
        public String accountId;
        @AuraEnabled
        public String message;
        @AuraEnabled
        public String Email;
        @AuraEnabled
        public String Email1;
        @AuraEnabled
        public Boolean success;
        @AuraEnabled
        public Boolean isMoreThanOneContactFound;
        @AuraEnabled
        public Boolean orderingEnabled;
        @AuraEnabled
        public Boolean checkStatusPriceAvailability;
        @AuraEnabled
        public Boolean isPermissionUpdated;
        @AuraEnabled
        public Boolean IsaccountTypenotincluded;
    }
    /*
verifyRegistration Logic start
*  Description: this metod  validate  the account contact and user based on user inputs  
*  @name: 	verifyRegistration
*  @param:	String firstName, String lastName, String schoolEmail, String selectedZipCode, String companySchoolName
*  @return: response
*/
    @AuraEnabled
    global static RegistrationResponse verifyRegistration(String firstName, String lastName, String schoolEmail, String selectedZipCode, String companySchoolName) {
        RegistrationResponse response = new RegistrationResponse();
        response.isMoreThanOneContactFound = false;
        response.orderingEnabled = false;
        response.checkStatusPriceAvailability = true;
        String varAccountStatus = 'Active';
        String varUnitedStates = 'United States';
        String varCanada = 'Canada';
        response.isSendEmail = false;
        List<User> useIdentification = [SELECT Id, ContactId, Email, IsActive FROM User WHERE UserName = :schoolEmail AND ContactId = null AND IsActive = true];  
        // Case 1: checkes user name alredy existed  or not added by sudha 
        if (!useIdentification.isEmpty()) {
            response.isContactValid = false;
            response.isAccountValid = false;
            response.IsaccountTypenotincluded = false;
            response.message = 'duplicateUsername';
            return response;  // Early exit
        }
        // Case 2 : checkes selected school type  valid or not 
        List<scc_validSchoolType__mdt> validSchoolTypes = [SELECT scc_validSchoolType__c FROM scc_validSchoolType__mdt LIMIT 1];
        String validSchoolTypeStr = validSchoolTypes.isEmpty() ? '' : validSchoolTypes[0].scc_validSchoolType__c;
        Set<String> validSchoolTypesSet = new Set<String>();
        if (!String.isBlank(validSchoolTypeStr)) {
            validSchoolTypesSet.addAll(validSchoolTypeStr.split(','));
        }
        Set<String> trimmedValidSchoolTypes = new Set<String>();
        for (String type : validSchoolTypesSet) {
            trimmedValidSchoolTypes.add(type.trim());
        }
        list<user>listofusers= new list<user>();
        List<Contact> contacts = [SELECT Id, Email, AccountId, Account.Name,  Account.BillingPostalCode ,Account.MDR_PID__c,Account.BillingCountry,
                                  Account.Account_Status__c ,Account.type FROM Contact 
                                  WHERE Email = :schoolEmail];
        if (!contacts.isEmpty()) {
            Account acc = [SELECT Id, BillingPostalCode,Name,Type FROM Account WHERE Id = :contacts[0].AccountId LIMIT 1];
            if(!acc.BillingPostalCode.startsWith(selectedZipCode) || acc.Name != companySchoolName){
                response.isContactValid = false;
                response.isAccountValid = false;
                response.IsaccountTypenotincluded = false;
                response.message = 'schoolnotmatched';
                return response;  // Early exit
            }
            // Check if the account type is in the metadata
            if (!trimmedValidSchoolTypes.contains(acc.Type)) {
                response.isContactValid = false;
                response.isAccountValid = false;
                response.IsaccountTypenotincluded = true;
                response.message = 'schoolnotvalid';
                return response;  // Early exit
            }
        }  
        // Case 3 : checkes  contacts are duplicate or not // added by sudha 
        if(contacts.size() > 1){
            response.isContactValid = false;
            response.message='duplicatecontact';
            // Case 4 : if not duplicate checks buyer account 
        }else {
            if (!contacts.isEmpty()) {
                Contact contact = contacts[0];
                Account acc = [SELECT Id,IsBuyer,Name FROM Account where Id =: contact.AccountId LIMIT 1];
                if(acc.IsBuyer !=true)
                {
                    updateBuyerAccountAsync(acc.id,acc.name);
                }
                // Case 5 : after buyer updating checks permissions 
                // Continue with the contact and permission set logic
                if (contact.Account != null && contact.Account.BillingPostalCode == selectedZipCode) {
                    if (contact.Account.Name == companySchoolName && contact.Account.MDR_PID__c != null) {
                        response.isContactValid = true;
                    }
                }
                Account accc= [select id,name , BillingPostalCode,MDR_PID__c,BillingCountry,Account_Status__c from account where id=: contacts[0].AccountId];
                if (contact.Account != null && 
                    (contact.Account.BillingPostalCode == selectedZipCode || contact.Account.BillingPostalCode.startsWith(selectedZipCode))&&
                    contact.Account.Name == companySchoolName && 
                    contact.Account.MDR_PID__c!=null && (contact.Account.BillingCountry== varUnitedStates || contact.Account.BillingCountry== varCanada) &&
                    contact.Account.Account_Status__c== varAccountStatus)
                {
                    response.isContactValid = true;
                    response.isAccountValid = true;
                    List<User> users = [SELECT Id,Name,ProfileId,Email,CommunityNickname, FirstName, LastName  FROM User WHERE ContactId = :contact.Id  And AccountId=:contact.AccountId  And IsActive =true LIMIT 1];
                    if (!users.isEmpty()) {
                        response.isUserValid = true;
                        response.isPermissionUpdated = false;
                        response.isNewUser = false;
                        response.userExists = true;
                        Profile  p =[select id from profile where Name='Savvas External Users Base Profile' limit 1];
                        if(users[0].ProfileId == p.Id){
                            String buyerPermissionSetName = 'B2BBuyer';
                            String buyerPermissionSetLabel ='Buyer';
                            String sccPermissionSetName = 'Savvas_Commerce_Cloud_External_Users_Permissions';
                            String sccPermissionSetLabel = 'Savvas Commerce Cloud External Users Permissions';
                            Id buyerPermissionSetId = getPermissionSetId(buyerPermissionSetName,buyerPermissionSetLabel);
                            Id sccPermissionSetId = getPermissionSetId(sccPermissionSetName,sccPermissionSetLabel);
                            Set<Id> assignedPermissionSetIds = new Set<Id>();
                            for (PermissionSetAssignment psa : [SELECT PermissionSetId 
                                                                FROM PermissionSetAssignment 
                                                                WHERE AssigneeId = :users[0].id]) {
                                                                    assignedPermissionSetIds.add(psa.PermissionSetId);
                                                                }
                            List<PermissionSetAssignment> psAssignmentsToInsert = new List<PermissionSetAssignment>();  
                            if (!assignedPermissionSetIds.contains(buyerPermissionSetId)) {
                                PermissionSetAssignment psa = new PermissionSetAssignment(
                                    AssigneeId = users[0].Id,
                                    PermissionSetId = buyerPermissionSetId
                                );
                                psAssignmentsToInsert.add(psa);
                            }
                            if (!assignedPermissionSetIds.contains(sccPermissionSetId)) {
                                PermissionSetAssignment psa2 = new PermissionSetAssignment(
                                    AssigneeId = users[0].Id,
                                    PermissionSetId = sccPermissionSetId
                                );
                                psAssignmentsToInsert.add(psa2);
                            }
                            try{
                                // scc_userExistEmail.SendEmailUserExistEmail(users[0].Email);
                                insert psAssignmentsToInsert;
                                response.Email1 = contact.Email;
                                String email =users[0].Email;
                                String name = users[0].FirstName +' '+ users[0].LastName;
                                if(!psAssignmentsToInsert.isEmpty()){
                                    response.isPermissionUpdated = true;
                                    response.isUserValid = false;
                                    response.isSendEmail = true;
                                    response.contactId = contact.Id;
                                    response.accountId = contact.AccountId;
                                    response.message ='Existing user';
                                    sendEmailToExistingUser(name,email);
                                    return response;
                                }
                            }
                            catch(DmlException e) {
                            } 
                        }else{ 
                            User assignProfile = new User(
                                Id=users[0].id,
                                ProfileId=p.Id   
                            );
                            try{
                                update assignProfile;
                                String emaill =users[0].Email;
                                //scc_sendUserExistEmail.SendEmailUserExistEmail(emaill);
                                response.isSendEmail = true;
                                response.Email1 = contact.Email;
                            } catch(DmlException e) {
                            }  
                            String buyerPermissionSetName = 'B2BBuyer';
                            String buyerPermissionSetLabel ='Buyer';
                            String sccPermissionSetName = 'Savvas_Commerce_Cloud_External_Users_Permissions';
                            String sccPermissionSetLabel = 'Savvas Commerce Cloud External Users Permissions';
                            Id buyerPermissionSetId = getPermissionSetId(buyerPermissionSetName,buyerPermissionSetLabel);
                            Id sccPermissionSetId = getPermissionSetId(sccPermissionSetName,sccPermissionSetLabel);
                            Set<Id> assignedPermissionSetIds = new Set<Id>();
                            for (PermissionSetAssignment psa : [SELECT PermissionSetId 
                                                                FROM PermissionSetAssignment 
                                                                WHERE AssigneeId = :users[0].id]) {
                                                                    assignedPermissionSetIds.add(psa.PermissionSetId);
                                                                }
                            List<PermissionSetAssignment> psAssignmentsToInsert = new List<PermissionSetAssignment>();  
                            if (!assignedPermissionSetIds.contains(buyerPermissionSetId)) {
                                PermissionSetAssignment psa = new PermissionSetAssignment(
                                    AssigneeId = users[0].Id,
                                    PermissionSetId = buyerPermissionSetId
                                );
                                psAssignmentsToInsert.add(psa);
                            }
                            if (!assignedPermissionSetIds.contains(sccPermissionSetId)) {
                                PermissionSetAssignment psa2 = new PermissionSetAssignment(
                                    AssigneeId = users[0].Id,
                                    PermissionSetId = sccPermissionSetId
                                );
                                psAssignmentsToInsert.add(psa2);
                            }
                            try{
                                insert psAssignmentsToInsert;
                                String email =users[0].Email;
                                String name = users[0].Name;
                                sendEmailToExistingUser(name,email);
                                if(!psAssignmentsToInsert.isEmpty()){
                                    response.isUserValid = false;
                                    response.isPermissionUpdated = true;
                                    response.isSendEmail = true;
                                    response.contactId = contact.Id;
                                    response.accountId = contact.AccountId;
                                    response.message ='Existing user with different profile';
                                    return response;
                                }
                            }
                            catch(DmlException e) {
                                System.debug('The following exception has occurred: ' + e.getMessage());
                            }                
                        }
                    } 
                    else {
                        response.isUserValid = false;
                        response.isNewUser = true;
                        response.userExists = false;
                        response.isPermissionUpdated = false;
                    }
                    response.Email = contact.Email;
                    response.contactId = contact.Id;
                    response.accountId = contact.AccountId;
                    response.isPermissionUpdated=false;
                    response.message='usercreation';
                } else {
                    response.isContactValid = false;
                    response.isAccountValid = false;
                    response.isUserValid = false;
                    response.isNewUser = false;
                    response.userExists = false;
                    response.isPermissionUpdated = false;
                    response.message = 'Contact or Account is not validated.';
                }
            } else {
                response.isContactValid = false;
                response.isAccountValid = false;
                response.isUserValid = false;
                response.isNewUser = false;
                response.userExists = false;
                response.isPermissionUpdated = false;
                response.message = 'User is not validated.';
            }
        }
        return response;
    } 
    @future
    public static void updateBuyerAccountAsync(Id accountId, String accountName) {
        try {
            List<BuyerAccount> existingBuyerAccounts = [SELECT Id FROM BuyerAccount WHERE BuyerId = :accountId LIMIT 1];
            String MemberBuyerGroupId = System.Label.scc_MySavvasOrders_Buyer_Group;
            BuyerGroup bg =[select id,name from BuyerGroup where Name= :MemberBuyerGroupId];
            id  bgId =[select id from BuyerGroup where Name= :MemberBuyerGroupId limit 1].id;
            if (existingBuyerAccounts.isEmpty()) {
                // Insert a new BuyerAccount
                BuyerAccount buyerAcc = new BuyerAccount(
                    BuyerId = accountId,
                    Name = accountName,
                    BuyerStatus ='Active',
                    isActive = true
                );
                insert buyerAcc;
                BuyerGroupMember member = new BuyerGroupMember();
                member.buyerId = accountId; 
                member.BuyerGroupId = bgId; 
                insert member;
            } else {
                // Update the existing BuyerAccount
                BuyerAccount existingBuyerAcc = existingBuyerAccounts[0];
                existingBuyerAcc.Name = accountName;
                existingBuyerAcc.isActive = true;
                update existingBuyerAcc;
            }
        } catch (DmlException e) {
            System.debug('Error updating/inserting BuyerAccount: ' + e.getMessage());
        }
    } 
   @AuraEnabled
    public static boolean sendEmailtoCaseForMoreThanOneEmailId(String firstName, String lastName, String schoolEmail, String selectedZipCode,
                                                          String companySchoolName, String description,
                                                          String street, String city, String state, String postalCode, String country, Boolean isContactValid, 
                                                          Boolean isAccountValid, String message) {
    String recordTypeName = 'IT External Support';
    RecordType caseRecordType = [SELECT Id From RecordType WHERE SobjectType ='Case' AND Name = :recordTypeName LIMIT 1];
    OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =: system.label.scc_org_wide_email_address];
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    if (owea.size() > 0) {
        mail.setOrgWideEmailAddressId(owea.get(0).Id);
    }
    Case newCase = new Case();                                    
    String subjectLine;
    String cleanedMessage = message.toLowerCase().trim();
    switch on cleanedMessage {
        when 'duplicateusername' {
            subjectLine = 'Duplicate username found with same email ID - ' + schoolEmail;
        }
        when 'schoolnotmatched' {
            subjectLine = 'Email ID found at different account - ' + schoolEmail;
        }
        when 'user is not validated.' {
            subjectLine = 'Email ID not found - ' + schoolEmail;
        }
        when 'schoolnotvalid' {
            subjectLine = 'Home School Selected - Registration blocked ' + schoolEmail;
        }
        when 'usercreation' {
            subjectLine = 'User creation is  failed  - ' + schoolEmail;
        }
        when else {
            subjectLine = 'More than one contact with same email ID - ' + schoolEmail;
        }
    }
    newCase.Subject = subjectLine;
    newCase.status = 'New';
    newCase.origin = 'Web';
    newCase.SuppliedEmail = schoolEmail; 
    newCase.SuppliedName = firstName + ' ' + lastName; 

    newCase.Description =
        'Name: ' + firstName + ' ' + lastName + ', ' +                                            
        'Type: ' + subjectLine + ': ' +
        'Email: ' + schoolEmail + ', ' +
        'School Name: ' + companySchoolName + ', ' +
        'School Address: ' + street + ', ' + city + ', ' + state + ', ' + postalCode + ', ' + country + ', ' +
        'Description: ' + description;
    newCase.RequestedSource__c = 'MySavvasOrders';
    newCase.RecordTypeId = caseRecordType.Id;
    Database.DMLOptions dmlOpts = new Database.DMLOptions();
    dmlOpts.assignmentRuleHeader.useDefaultRule = true;
    newCase.setOptions(dmlOpts);
    insert newCase;

    List<Case> caseNumber = [Select CaseNumber from Case where Id =: newCase.Id LIMIT 1];
    EmailTemplate emailTemplate = [select Id, Subject, HtmlValue, Body from EmailTemplate where Name = 'Case - New Case Created'];
    Messaging.reserveSingleEmailCapacity(2);
    String subject = emailTemplate.Subject;
    subject = subject.replace('{!Case.CaseNumber}', caseNumber[0].CaseNumber);
    subject = subject.replace('School not found', subjectLine);
    String plainBody = emailTemplate.Body;
    plainBody = plainBody.replace('{!Case.CaseNumber}', caseNumber[0].CaseNumber);
    String[] toAddresses = new String[] {schoolEmail};
    mail.setToAddresses(toAddresses);      
    mail.setBccSender(false);
    mail.setUseSignature(false);
    mail.setSubject(subject);
    mail.setPlainTextBody(plainBody);
    mail.setSaveAsActivity(true);  
    mail.setWhatId(newCase.Id);   

       // email threading 
    String threadId = '<' + newCase.Id + '.' + DateTime.now().getTime() + '.JavaMail.@' + UserInfo.getOrganizationId() + '>';
    mail.setInReplyTo(threadId);
    mail.setReferences(threadId);
    
    try {
        Messaging.sendEmail(new Messaging.SingleEmailmessage[] {mail});
        
        // Added EmailMessage creation
        EmailMessage emailMsg = new EmailMessage();
        emailMsg.ParentId = newCase.Id;
        emailMsg.TextBody = plainBody;
        emailMsg.Subject = subject;
        emailMsg.FromAddress = System.Label.scc_org_wide_email_address;
        emailMsg.ToAddress = schoolEmail;
        emailMsg.Status = '2';
        emailMsg.MessageDate = System.now();
        insert emailMsg;
    } catch (exception e) {
        return false;
    }
    return true;
}
   @AuraEnabled
public static boolean sendEmailtoCaseForSchoolNotFound(String firstName, String lastName, String schoolEmail, String selectedZipCode, String companySchoolName, String description, String address) {
    OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =: system.label.scc_org_wide_email_address];
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    String recordTypeName = 'IT External Support';
    RecordType caseRecordType = [SELECT Id From RecordType WHERE SobjectType ='Case' AND Name = :recordTypeName LIMIT 1];
    if (owea.size() > 0) {
        mail.setOrgWideEmailAddressId(owea.get(0).Id);
    }
    Case newCase = new Case();
    newCase.Subject = 'Request to add an Account  ' + companySchoolName;
    newCase.status = 'New'; 
    newCase.origin = 'Web';
    newCase.Type = 'Customer Service';
    newCase.SuppliedEmail = schoolEmail;
    newCase.SuppliedName = firstName + ' ' + lastName;  
    newCase.Description = 
        'Name: ' + firstName + ' ' + lastName + ', ' +                   
        'Email: ' + schoolEmail + ', ' +
        'Type: ' + 'Add an Account' + ': ' + 
        'School Name: ' + companySchoolName + ', ' +
        'School Address: ' + address + ', ' +
        'Description: ' + description;
    newCase.RequestedSource__c = 'MySavvasOrders';
    newCase.RecordTypeId = caseRecordType.Id;
    Database.DMLOptions dmlOpts = new Database.DMLOptions();
    dmlOpts.assignmentRuleHeader.useDefaultRule = true;
    newCase.setOptions(dmlOpts);
    insert newCase;

    List<Case> caseNumber = [Select CaseNumber from Case where Id =: newCase.Id LIMIT 1];
    EmailTemplate emailTemplate = [select Id, Subject, HtmlValue, Body from EmailTemplate where Name = 'Case - New Case Created'];
    Messaging.reserveSingleEmailCapacity(2);
    String subject = emailTemplate.Subject;
    subject = subject.replace('{!Case.CaseNumber}', caseNumber[0].CaseNumber);
    String plainBody = emailTemplate.Body;
    plainBody = plainBody.replace('{!Case.CaseNumber}', caseNumber[0].CaseNumber);
    String[] toAddresses = new String[] {schoolEmail}; 
    mail.setToAddresses(toAddresses);		
    mail.setBccSender(false);
    mail.setUseSignature(false);
    mail.setSubject(subject);
    mail.setPlainTextBody(plainBody);
    mail.setSaveAsActivity(true); 
    mail.setWhatId(newCase.Id);    

     // email threading 
    String threadId = '<' + newCase.Id + '.' + DateTime.now().getTime() + '.JavaMail.@' + UserInfo.getOrganizationId() + '>';
    mail.setInReplyTo(threadId);
    mail.setReferences(threadId);
    
    try {
        Messaging.sendEmail(new Messaging.SingleEmailmessage[] {mail});
        
        // Added EmailMessage creation
        EmailMessage emailMsg = new EmailMessage();
        emailMsg.ParentId = newCase.Id;
        emailMsg.TextBody = plainBody;
        emailMsg.Subject = subject;
        emailMsg.FromAddress = System.Label.scc_org_wide_email_address;
        emailMsg.ToAddress = schoolEmail;
        emailMsg.Status = '2';
        emailMsg.MessageDate = System.now();
        insert emailMsg;
    } catch (exception e) {
        return false;
    }
    return true;
}
    public class inputVariables{
        @InvocableVariable
        public list<String> schoolEmails;
    }
    private static Id getPermissionSetId(String permissionSetName, String permissionSetLabel) {
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = :permissionSetName AND label=:permissionSetLabel];
        return ps != null ? ps.Id : null;
    }    
    /*
createUser Logic start
*  Description: if the response got as account and contact valid then user eligible for creating user 
*  @name: verifyRegistration
*  @param: String firstName, String lastName, String schoolEmail, String selectedZipCode, String companySchoolName
*  @return: response
*/
    @AuraEnabled(cacheable=false)
    public static string createUser(Map<string, Object> response) {
        Boolean isContactValid = (Boolean)response.get('isContactValid');
        Boolean isAccountValid = (Boolean)response.get('isAccountValid');
        Boolean isUserValid = (Boolean)response.get('isUserValid');
        Boolean userExists = (Boolean)response.get('userExists');
        Id contactId = (id)response.get('contactId');
        Id accountId = (id)response.get('accountId');
        Boolean isNewUser = (Boolean)response.get('isNewUser');
        string Email =(string)response.get('Email'); 
        Boolean orderingEnabled = (Boolean)response.get('orderingEnabled');		        
        Boolean checkStatusPriceAvailability = (Boolean)response.get('checkStatusPriceAvailability');
        Boolean isPermissionUpdated = (Boolean)response.get('isPermissionUpdated');
        if(isPermissionUpdated){
            User user=[select id, checkStatusPriceAvailability__c, ordering_Enabled__c from user where ContactId=:contactId LIMIT 1];
            user.checkStatusPriceAvailability__c = checkStatusPriceAvailability;
            user.Ordering_Enabled__c = orderingEnabled;
            try{
                update user;
                return user.Id;
            }
            catch(Exception ex){
                return 'failed'+ex.getMessage();
            }        
        }
        else{
            list<User>listofusers= new list<User>();
            List<PermissionSetAssignment> psAssignmentsToInsert = new List<PermissionSetAssignment>();
            Id permissionSetId = [SELECT Id FROM PermissionSet WHERE Name = 'Savvas_Commerce_Cloud_External_Users_Permissions' LIMIT 1].id;
            List<PermissionSet> psId =[SELECT Id FROM PermissionSet WHERE (Name = 'Savvas_Commerce_Cloud_External_Users_Permissions' AND Label='Savvas Commerce Cloud External Users Permissions') OR (Name = 'B2BBuyer' AND Label='Buyer')];
            id  pid =[select id from profile where Name='Savvas External Users Base Profile' limit 1].id;
            Contact   contactrecord =[SELECT Id, Name, LastName, Email, FirstName FROM Contact WHERE AccountId =:accountId AND Email =:Email LIMIT 1];
            string  alias = contactRecord.lastName;
            if (alias != null && alias.length() > 8)
                alias = alias.substring(0, 8);
            if (isContactValid && isAccountValid) {
                User newUser = new User(ContactId = contactRecord.Id,  FirstName = contactRecord.FirstName,LastName = contactRecord.LastName,
                                        Email = contactRecord.Email,ProfileId = pid,   Username = contactRecord.Email, EmailEncodingKey = 'UTF-8',
                                        LanguageLocaleKey = 'en_US',  LocaleSidKey = 'en_US', TimeZoneSidKey = 'GMT', IsActive = true , Alias =alias, Ordering_Enabled__c=orderingEnabled, CheckStatusPriceAvailability__c=checkStatusPriceAvailability);
                listofusers.add(newUser);  
                try {
                    insert listofusers;
                    List<Id> userIds = new List<Id>();
                    for (User u : listofusers) {
                        userIds.add(u.Id);
                    }
                    assignPermissionSets(userIds);
                    return newUser.id;
                } catch (Exception e) {
                    system.debug('DMLExpection'+e.getMessage());
                    system.debug('DMLExpection'+e.getLineNumber());
                    return 'failed'+e.getMessage();
                }
            } else {
                return 'Invalid account or contact.';
            }
        }
    }
    @future
    @AuraEnabled
    public static void assignPermissionSets(list<Id> userIds) {
        String welcomeTemplateName = System.Label.scc_WelcomeEmailTemplateName	;
        try {
            List<PermissionSet> psId = [SELECT Id FROM PermissionSet 
                                        WHERE (Name = 'Savvas_Commerce_Cloud_External_Users_Permissions' AND Label = 'Savvas Commerce Cloud External Users Permissions') 
                                        OR (Name = 'B2BBuyer' AND Label = 'Buyer')];
            List<PermissionSetAssignment> psAssignmentsToInsert = new List<PermissionSetAssignment>();
            for( id userId: userIds){
                for (PermissionSet permsetId : psId) {
                    PermissionSetAssignment psAssignment = new PermissionSetAssignment(
                        PermissionSetId = permsetId.Id,
                        AssigneeId = userId
                    ); 
                    psAssignmentsToInsert.add(psAssignment);
                }
            }
            insert psAssignmentsToInsert;
            for( id userId: userIds){
                sendWelcomeEmail(userId, welcomeTemplateName);
            }
        } catch (Exception e) {
            system.debug('DMLException in assignPermissionSets: ' + e.getMessage());
            system.debug('DMLExpection'+e.getLineNumber());
        }
    }
    public static void sendWelcomeEmail(String userId, String welcomeTemplateName){
          if(!Test.isRunningTest()) {
        System.ResetPasswordResult result = System.resetPasswordWithEmailTemplate(userId, true, welcomeTemplateName);
          }
    }   
    @future
    @AuraEnabled
    public static void sendEmailToExistingUser (String name,String email){
        try{
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =: system.label.scc_org_wide_email_address];
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if ( owea.size() > 0 ) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            EmailTemplate emailTemplate = [select Id, Subject, HtmlValue, Body from EmailTemplate where Name  = 'scc_Existing_User_SignUp' LIMIT 1];
            Messaging.reserveSingleEmailCapacity(2);
            String subject = emailTemplate.Subject;
            subject = subject.replace('{!Receiving_User.FirstName}', name);
            String plainBody  = emailTemplate.Body;
            plainBody  = plainBody.replace('{!Receiving_User.FirstName}', name);
            String htmlBody = emailTemplate.HtmlValue;           
            htmlBody = htmlBody.replace('{!Receiving_User.FirstName}', name);
            String[] toAddresses = new String[] {email}; 
                mail.setToAddresses(toAddresses);		
            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setSubject(subject);
            mail.setHtmlBody(htmlBody);
            mail.setPlainTextBody(plainBody);
            Messaging.sendEmail(new Messaging.SingleEmailmessage[] {mail}); 
        }catch(Exception e){
            system.debug('Exception:'+e.getMessage());
        }
    }
}