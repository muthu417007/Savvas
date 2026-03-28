/*Apex Class:scc_registrationformController
        Author: CTS (Sudharani Pathivada)
        Created Date: 22/03/2024
        Reason: This Controller referered in LWC "scc_registrationformController" for the savvas LWC component.
        Description: This apex helps the user do self-registration.   
        Modified Date: 24/04/2024
        */

global without sharing class testreg  {
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
        response.orderingEnabled = false;
        response.checkStatusPriceAvailability = true;
         				String varAccountStatus = 'Active';
                        String varUnitedStates = 'United States';
                        String varCanada = 'Canada';
                        response.isSendEmail = false;
        list<user>listofusers= new list<user>();
   List<Contact> contacts = [SELECT Id, Email, AccountId, Account.Name,  Account.BillingPostalCode ,Account.MDR_PID__c,Account.BillingCountry,
                                  Account.Account_Status__c FROM Contact 
                                  WHERE Email = :schoolEmail];
        system.debug('contacts'+contacts);
                       
        
        if(contacts.size() > 1){
            response.isMoreThanOneContactFound = true;
        }else {
            if (!contacts.isEmpty()) {
            Contact contact = contacts[0];
            Account acc = [SELECT Id,IsBuyer,Name FROM Account where Id =: contact.AccountId LIMIT 1];
        if(acc.IsBuyer !=true)
         {
           List<BuyerAccount> existingBuyerAccounts = [SELECT Id FROM BuyerAccount WHERE BuyerId = :acc.Id LIMIT 1];

          /*  if (existingBuyerAccounts.isEmpty()) {
                BuyerAccount buyerAcc = new BuyerAccount(
                    BuyerId = acc.Id,
                    Name=acc.Name,
                    isActive=true
                );
                insert buyerAcc;

            }*/
                if (existingBuyerAccounts.isEmpty()) {

                // If no BuyerAccount exists, insert a new one

                BuyerAccount buyerAcc = new BuyerAccount(

                    BuyerId = acc.Id,

                    Name = acc.Name,

                    isActive = true

                );

                insert buyerAcc;

            } else {

                // If a BuyerAccount exists, update the existing one
 				BuyerAccount existingBuyerAcc = existingBuyerAccounts[0];
				existingBuyerAcc.Name = acc.Name;
                existingBuyerAcc.isActive=true;
				//existingBuyerAcc.isActive = true;  // Update the fields you need to update
				update existingBuyerAcc;
            }
            }    
                
           // acc.IsBuyer = true;
            system.debug('contact'+contact);
            if (contact.Account != null && 
                (contact.Account.BillingPostalCode == selectedZipCode || contact.Account.BillingPostalCode.startsWith(selectedZipCode))&&
                contact.Account.Name == companySchoolName && 
                contact.Account.MDR_PID__c!=null && (contact.Account.BillingCountry== varUnitedStates || contact.Account.BillingCountry== varCanada) &&
                contact.Account.Account_Status__c== varAccountStatus)
            
            {
                response.isContactValid = true;
                response.isAccountValid = true;
                List<User> users = [SELECT Id,ProfileId,Email,Name FROM User WHERE ContactId = :contact.Id  And AccountId=:contact.AccountId  And IsActive =true LIMIT 1];

                if (!users.isEmpty()) {
                     // scc_sendUserExistEmail.SendEmailUserExistEmail(users[0].Email);
                    system.debug('user is available');
                    response.isUserValid = true;
                    response.isPermissionUpdated = false;
                    response.isNewUser = false;
                    response.userExists = true;
                    Profile  p =[select id from profile where Name='Savvas External Users Base Profile' limit 1];
                    //system.debug('pid>>>>'+pid);
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
                            response.isSendEmail = true;
                             response.Email1 = contact.Email;
                             String email =users[0].Email;
                            String name = users[0].Name;
                            sendEmailToExistingUser(name,email);
                            if(!psAssignmentsToInsert.isEmpty()){
                                system.debug('psAssignmentsToInsert1 '+psAssignmentsToInsert);
                                response.isPermissionUpdated = true;
                            	response.isUserValid = false;
                            }
                            System.debug('The following exception has occurred: '+users+'     email is'+email);
                            
                        }
                        catch(DmlException e) {
                            System.debug('The following exception has occurred: ' + e.getMessage());
                        } 
                    }else{ 
                        system.debug('user is available different profile');
                        User assignProfile = new User(
                            Id=users[0].id,
                            ProfileId=p.Id   
                        );
                        try{
                            update assignProfile;
                            system.debug('user is available different profile update');
                            String emaill =users[0].Email;
                            //scc_sendUserExistEmail.SendEmailUserExistEmail(emaill);
                              response.isSendEmail = true;
                                response.Email1 = contact.Email;
                        } catch(DmlException e) {
                            System.debug('The following exception has occurred: ' + e.getMessage());
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
                                system.debug('psAssignmentsToInsert2 '+psAssignmentsToInsert);
                                response.isPermissionUpdated = true;
                            	response.isUserValid = false;
                            }
                            //scc_sendUserExistEmail.SendEmailTemplateWithTemplate(users[0].Email);
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
                System.debug('Contact not found.');
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

    @AuraEnabled
    public static boolean sendEmailtoCaseForMoreThanOneEmailId (String firstName, String lastName, String schoolEmail, String selectedZipCode, 
                                                                String companySchoolName, String description, 
                                           String street, String city, String state, String postalCode, String country
                                          ){
                                              
        
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'salesforce.noreply@savvas.com'];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if ( owea.size() > 0 ) {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
        }
                                              
       	Case newCase = new Case();
        newCase.Subject = 'More than one contact with same email Id - ' + schoolEmail;
        newCase.status = 'New'; 
        newCase.origin = 'Web'; 
        newCase.Description = 
            			 'Name: ' + firstName + ' ' + lastName + ', ' +                                            
                         'Type: ' + 'More than one contact with same email Id' + ': ' + 
            			 'Email: ' + schoolEmail +', ' +
            			 'School Name: ' + companySchoolName +', ' +
                         'School Address: ' + street + ', ' + city + ', ' + state + ', ' + postalCode + ', ' + country + ', ' +
                         'Description: ' + description;
        insert newCase;
        
        List<Case> caseNumber = [Select CaseNumber from Case where Id =: newCase.Id LIMIT 1];
        //EmailTemplate emailTemplate = [select Id, Subject, HtmlValue, Body from EmailTemplate where Name  = 'Case - IT External Customer Support to Customer Case Creation'];
        EmailTemplate emailTemplate = [select Id, Subject, HtmlValue, Body from EmailTemplate where Name  = 'Case - New Case Created'];
        
        Messaging.reserveSingleEmailCapacity(2);
        String subject = emailTemplate.Subject;
    	subject = subject.replace('{!Case.CaseNumber}', caseNumber[0].CaseNumber);
        subject = subject.replace('School not found', 'More than one contact with same email Id');
        
        //String htmlBody = emailTemplate.HtmlValue;
    	//htmlBody = htmlBody.replace('{!Case.CaseNumber}', caseNumber[0].CaseNumber);
        
        String plainBody  = emailTemplate.Body;
    	plainBody  = plainBody.replace('{!Case.CaseNumber}', caseNumber[0].CaseNumber);
        
        String[] toAddresses = new String[] {schoolEmail}; 
        
        mail.setToAddresses(toAddresses);		
        
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setSubject(subject);
        //mail.setHtmlBody(htmlBody);
        mail.setPlainTextBody(plainBody);
        
            try{
                 Messaging.sendEmail(new Messaging.SingleEmailmessage[] {mail});  
        		                                
            }catch (exception e){
                return false;
            }
            return true; 
    }
    
    @AuraEnabled
    public static boolean sendEmailtoCaseForSchoolNotFound (String firstName, String lastName, String schoolEmail, String selectedZipCode, String companySchoolName, String description, String address){
        
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'salesforce.noreply@savvas.com'];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if ( owea.size() > 0 ) {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
        }
                                              
       	Case newCase = new Case();
        newCase.Subject = 'Request to add school  ' + companySchoolName;
        newCase.status = 'New'; 
        newCase.origin = 'Web'; 
        newCase.Description = 
            			 'Name: ' + firstName + ' ' + lastName + ', ' +                   
                         'Email: ' + schoolEmail +', ' +
                         'Type: ' + 'Request to add school' + ': ' + 
            			 'School Name: ' + companySchoolName +', ' +
                         'School Address: ' + address + ', ' +
                         'Description: ' + description;
        insert newCase;
        
        List<Case> caseNumber = [Select CaseNumber from Case where Id =: newCase.Id LIMIT 1];
        //EmailTemplate emailTemplate = [select Id, Subject, HtmlValue, Body from EmailTemplate where Name  = 'Case - IT External Customer Support to Customer Case Creation'];
        EmailTemplate emailTemplate = [select Id, Subject, HtmlValue, Body from EmailTemplate where Name  = 'Case - New Case Created'];
        Messaging.reserveSingleEmailCapacity(2);
        String subject = emailTemplate.Subject;
    	subject = subject.replace('{!Case.CaseNumber}', caseNumber[0].CaseNumber);
        
        //String htmlBody = emailTemplate.HtmlValue;
    	//htmlBody = htmlBody.replace('{!Case.CaseNumber}', caseNumber[0].CaseNumber);
        
        String plainBody  = emailTemplate.Body;
    	plainBody  = plainBody.replace('{!Case.CaseNumber}', caseNumber[0].CaseNumber);
        
        String[] toAddresses = new String[] {schoolEmail}; 
        
        mail.setToAddresses(toAddresses);		
        
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setSubject(subject);
        //mail.setHtmlBody(htmlBody);
        mail.setPlainTextBody(plainBody);
        
            try{
                 Messaging.sendEmail(new Messaging.SingleEmailmessage[] {mail});  
        		                                
            }catch (exception e){
                return false;
            }
            return true; 
    }
    
    /*
    @AuraEnabled
    public static void callEmailInvokableMethod(String schoolEmail){
        List<String> email1 = new List<String>{schoolEmail};
        scc_registrationformController.sendPromoCodeEmail(email1);
    } 
   */
    public class inputVariables{
        @InvocableVariable
        public list<String> schoolEmails;
    }
    
    /*@InvocableMethod(label='Send Promo Code' description='Send Promo Code on Successful rgistration')
    //public static List<String> sendPromoCodeEmail(list<inputVariables> inputVariables){
    public static void sendPromoCodeEmail(list<inputVariables> inputVariables){
     //public static void sendPromoCodeEmail(String schoolEmail){   
		list<String> schoolEmail = inputVariables.get(0).schoolEmails;
            
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'salesforce.noreply@savvas.com'];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if ( owea.size() > 0 ) {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        
        EmailTemplate emailTemplate1 = [select Id, Subject, HtmlValue, Body from EmailTemplate where Name  = 'scc_PromoCode_For_Sucessful_Registration'];
        
        Messaging.reserveSingleEmailCapacity(2);
        String subject = emailTemplate1.Subject;
        
        //String htmlBody = emailTemplate1.HtmlValue;
    	//htmlBody = htmlBody.replace('{!Case.CaseNumber}', caseNumber[0].CaseNumber);
        
        String plainBody  = emailTemplate1.Body;
    	//plainBody  = plainBody.replace('{!Case.CaseNumber}', caseNumber[0].CaseNumber);//
        
         //List<String> toAddresses = new List<String>[0].schoolEmail; 
         //List<String> toAddresses = new List<String>[0].schoolEmail; 
        List<String> email2 = new List<String>{'vaibhav.saptal@savvas.com'};
        mail.setToAddresses(schoolEmail);
        
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setSubject(subject);
        //mail.setHtmlBody(htmlBody);
        mail.setPlainTextBody(plainBody);
        
            try{
                 Messaging.sendEmail(new Messaging.SingleEmailmessage[] {mail});  
        		                                
            }catch (exception e){
                //return 'false';
            }
          // return email2; 
    }*/
    
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
    public static string createUser(Map<String, Object> response) {
     	Boolean isContactValid = (Boolean)response.get('isContactValid');
        Boolean isAccountValid = (Boolean)response.get('isAccountValid');
        Boolean isUserValid = (Boolean)response.get('isUserValid');
        Boolean userExists = (Boolean)response.get('userExists');
        Id contactId = (id)response.get('contactId');
        Id accountId = (id)response.get('accountId');
        system.debug(accountId);
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
                return 'User update is failed';
            }
            
            
        }
        else{
            list<user>listofusers= new list<user>();
        List<PermissionSetAssignment> psAssignmentsToInsert = new List<PermissionSetAssignment>();
        
        Id permissionSetId = [SELECT Id FROM PermissionSet WHERE Name = 'Savvas_Commerce_Cloud_External_Users_Permissions' LIMIT 1].id;
        List<PermissionSet> psId =[SELECT Id FROM PermissionSet WHERE (Name = 'Savvas_Commerce_Cloud_External_Users_Permissions' AND Label='Savvas Commerce Cloud External Users Permissions') OR (Name = 'B2BBuyer' AND Label='Buyer')];
        
        
         id  pid =[select id from profile where Name='Savvas External Users Base Profile' limit 1].id;
        system.debug(pid);
  
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
             system.debug('newuser1'+newuser);
                insert newUser;
                List<Id> userIds = new List<Id>();
				for (User u : listofusers) {
    			userIds.add(u.Id);
			}

		for (PermissionSet permsetId : psId) {
    		PermissionSetAssignment psAssignment = new PermissionSetAssignment(
        	PermissionSetId = permsetId.Id,
        	AssigneeId = listofusers[0].id
    		);

    	psAssignmentsToInsert.add(psAssignment);
			}

				insert psAssignmentsToInsert;
                 return newUser.id;
            } catch (Exception e) {
               
                 return 'Registration failed.';
               
            }
        } else {
           return 'Invalid account or contact.';
           
        }
        }
        
    }
    
     @AuraEnabled
    public static void sendEmailToExistingUser (String name,String email){
        try{
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'salesforce.noreply@savvas.com'];
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
            
            String[] toAddresses = new String[] {email}; 
                
            mail.setToAddresses(toAddresses);		
            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setSubject(subject);
            mail.setPlainTextBody(plainBody);
            
            Messaging.sendEmail(new Messaging.SingleEmailmessage[] {mail}); 
       	}catch(Exception e){
            system.debug('Exception:'+e.getMessage());
        }
    }
 
}