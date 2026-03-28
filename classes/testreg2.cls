@isTest
public class testreg2 {
        
     /* @isTest
    static void testClassMethod(){
        Account acc= scc_TestDataFactory.accountCreation2('testAccount300');
        Contact con = scc_TestDataFactory.contactCreation( acc.Id, 'firstname300', 'testlastname300', 'testemail300@abc.com');
        User testUser= scc_TestDataFactory.userCreation(con.Id);
        User testUser1 = [SELECT Id FROM User WHERE Email = 'testuser@example.com' LIMIT 1];
        
         System.runAs(testUser){
 	Scc_RegistrationFormController.RegistrationResponse response01 =Scc_RegistrationFormController.verifyRegistration('firstname300','testlastname300', 'testuser@example.com', '12345', 'companySchoolName');
           //BuyerAccount existingBuyerAccounts = [SELECT Id FROM BuyerAccount WHERE BuyerId = :acc.id LIMIT 1];
             //system.assertNotEquals(Null,existingBuyerAccounts, 'buyeraccount');
             //system.assertNotEquals('New Buyer Account',existingBuyerAccounts.Name, 'buyeraccount');
             //system.assertNotEquals(Null,existingBuyerAccounts, 'buyeraccount');
             //system.assertEquals(true, existingBuyerAccounts.isActive, 'BuyerAccount should be active'); 
             //MySavvasOrders Buyer Group
            // Test.startTest();
             //Scc_RegistrationFormController.updateBuyerAccountAsync(acc.Id,'Updated Buyer Account');
            // Test.stopTest();
                                                                                                         
        
    }
               
	
}
        @isTest
    static void testClassMethod2(){
        
         Account acc1= scc_TestDataFactory.accountCreation2('testAccount400');
        Contact con1 = scc_TestDataFactory.contactCreation( acc1.Id, 'firstname400', 'testlastname400', 'testemail440@abc.com');
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Savvas External Users Base Profile' LIMIT 1];
           User testUserr = new User();
    		testUserr.ProfileId=profileId.Id;          
            testUserr.LastName = 'Test User';
            testUserr.Email = 'testuser@example.com';
            testUserr.Username = 'testuser@example.com' + System.currentTimeMillis();
            testUserr.Alias = 'tuser';
            testUserr.TimeZoneSidKey = 'America/Los_Angeles';
            testUserr.LocaleSidKey = 'en_US';
            testUserr.EmailEncodingKey = 'UTF-8';
            testUserr.LanguageLocaleKey = 'en_US';
            testUserr.ContactId=con1.id;
        insert testUserr;
          System.runAs(testUserr){
                Scc_RegistrationFormController.RegistrationResponse response02 =Scc_RegistrationFormController.verifyRegistration('firstname400','lastname400','testemail440@abc.com','12345','testAccount400');
              
		 }       
    }

@TestSetup
   public static void setup() {
       
        String testEmail = 'test00@example.com';
        String testZipCode = '1234500';
       
         Account testAccount = new Account(Name = 'TestAccount00',BillingStreet = '123 Test St00', BillingCity = 'Test City00', BillingState = 'MH', BillingPostalCode = '12300', BillingCountry = 'United States', MDR_PID__c = '12345600',Account_Status__c='Active' );
        insert testAccount;
        Contact  testContact = new Contact(FirstName = 'Test00', LastName = 'Contact00', Email = testEmail, AccountId = testAccount.Id);
        insert testContact;
      
        Account testAccount1 = new Account(
       Name = 'TestAccount100',BillingStreet = '123 Test St00', BillingCity = 'Test City00', BillingState = 'MH', BillingPostalCode = '12300', BillingCountry = 'United States', MDR_PID__c = '12345700',Account_Status__c='Inactive'
        
       
    );
    insert testAccount1;

   
    Contact testContact2= new Contact(
        FirstName = 'Test100',
        LastName = 'Contact100',
        Email = 'test100@example.com',
        AccountId = testAccount.Id
    );
    insert testContact2;
   }
    
    
    

    @isTest
    static void testVerifyRegistration() {
      Account acct = [SELECT Id,BillingPostalCode,Name FROM Account WHERE Name='TestAccount00' LIMIT 1];
        contact cct = [SELECT Id,Email,FirstName,LastName FROM contact WHERE Accountid=:acct.id LIMIT 1];
         contact cct1 = [SELECT Id,Email,FirstName,LastName FROM contact WHERE Email=:'test100@example.com'LIMIT 1];
           Scc_RegistrationFormController.RegistrationResponse response = Scc_RegistrationFormController.verifyRegistration(
            cct.FirstName,
            cct.LastName,
            cct.Email,
            acct.BillingPostalCode,
            acct.Name
        );
        System.assertEquals(true, response.isContactValid);
        System.assertEquals(true, response.isAccountValid);
        System.assertEquals(false, response.isUserValid);
        System.assertEquals(true, response.isNewUser);
        System.assertEquals(false, response.userExists);
        System.assertEquals(cct.Id, response.contactId);
        System.assertEquals(acct.Id, response.accountId);
        System.assertEquals(cct.Email, response.Email);

    }

    @isTest
    static void testCreateUser() {
      Account acct = [SELECT Id,BillingPostalCode,Name FROM Account WHERE Name='TestAccount00' LIMIT 1];
        contact cct = [SELECT Id,Email,FirstName,LastName FROM contact WHERE Accountid=:acct.id LIMIT 1];
         Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Savvas External Users Base Profile' LIMIT 1];
        Map<String, Object> responseMap = new Map<String, Object>{
            'isContactValid' => true,
            'isAccountValid' => true,
            'isUserValid' => false,
            'isNewUser' => true,
            'userExists' => false,
            'contactId' => cct.Id,
            'accountId' => acct.Id,
            'Email' => cct.Email,
            'isPermissionUpdated' => false
        };
            
         Map<String, Object> responseMap1 = new Map<String, Object>{
            'isContactValid' => false,
            'isAccountValid' => true,
            'isUserValid' => false,
            'isNewUser' => true,
            'userExists' => false,
            'contactId' => cct.Id,
            'accountId' => acct.Id,
            'Email' => cct.Email,
            'isPermissionUpdated' => false
        };
			User testUserr = new User();
    		testUserr.ProfileId=profileId.Id;          
            testUserr.LastName = 'Test User';
            testUserr.Email = 'testuser@example.com';
            testUserr.Username = 'testuser@example.com' + System.currentTimeMillis();
            testUserr.Alias = 'tuser';
            testUserr.TimeZoneSidKey = 'America/Los_Angeles';
            testUserr.LocaleSidKey = 'en_US';
            testUserr.EmailEncodingKey = 'UTF-8';
            testUserr.LanguageLocaleKey = 'en_US';
            testUserr.ContactId=cct.id;
            
        String userId = scc_RegistrationFormController.createUser(responseMap);
         //id userIdone= scc_RegistrationFormController.createUser(responseMap);
     scc_RegistrationFormController.createUser(responseMap1);
        
        scc_RegistrationFormController.assignPermissionSets(testUserr.id);
     System.assertNotEquals('Registration failed', userId);
    System.assertNotEquals(null, userId);
    }
    
     @isTest
    static void testCreateUser1() {
      Account acct = [SELECT Id,BillingPostalCode,Name FROM Account WHERE Name='TestAccount00' LIMIT 1];
        contact cct = [SELECT Id,Email,FirstName,LastName FROM contact WHERE Accountid=:acct.id LIMIT 1];
             User testUser= scc_TestDataFactory.userCreation(cct.Id);
          Map<String, Object> responseMap2 = new Map<String, Object>{
            'isContactValid' => false,
            'isAccountValid' => true,
            'isUserValid' => false,
            'isNewUser' => false,
            'userExists' => false,
            'contactId' => cct.Id,
            'accountId' => acct.Id,
            'Email' => cct.Email,
            'isPermissionUpdated' => true,
             'orderingEnabled'=>true,
             'checkStatusPriceAvailability'=>true
        };
			
            
        String userId = scc_RegistrationFormController.createUser(responseMap2);
     
       
       
     System.assertNotEquals('Registration failed', userId);
    System.assertNotEquals(null, userId);
    }
   /* @isTest
   static void testVerifyRegistration_ContactAndAccountNotValidated() {
       
        Scc_RegistrationFormController.RegistrationResponse response = Scc_RegistrationFormController.verifyRegistration(
            'InvalidFirstName',
            'InvalidLastName',
            'invalid_email@example.com',
            'invalid_zipcode',
            'Invalid Account Name'
        );

       
        System.assertEquals(false, response.isContactValid);
        System.assertEquals(false, response.isAccountValid);
        System.assertEquals(false, response.isUserValid);
        System.assertEquals(false, response.isNewUser);
        System.assertEquals(false, response.userExists);
        System.assert(response.message.contains('User is not validated.'));

    } 
    
     @isTest
    static void testVerifyRegistration_ContactAndAccountNotValidated1() {
       Account acct = [SELECT Id,BillingPostalCode,Name FROM Account WHERE Name='TestAccount100' LIMIT 1];
       //contact cct = [SELECT Id,Email,FirstName,LastName FROM contact WHERE Accountid=:acct.id LIMIT 1];
         contact cct1 = [SELECT Id,Email,FirstName,LastName FROM contact WHERE Email=:'test100@example.com'LIMIT 1];
        scc_RegistrationFormController.RegistrationResponse response = scc_RegistrationFormController.verifyRegistration(
        cct1.FirstName,
        cct1.LastName,
        cct1.Email,
        acct.BillingPostalCode,
        acct.Name
    );
        scc_RegistrationFormController.RegistrationResponse response1 = scc_RegistrationFormController.verifyRegistration(
        'Test',
        'User',
        'test001@user.com',
        '87223',
        'ShoolName'
    );

       
       System.assertEquals(false, response.isContactValid);
    System.assertEquals(false, response.isAccountValid);
    System.assertEquals(false, response.isUserValid);
    System.assertEquals(false, response.isNewUser);
    System.assertEquals(false, response.userExists);
    System.assert(response.message.contains('Contact or Account is not validated.'));
    System.assertEquals(false, response1.isContactValid);
    System.assertEquals(false, response1.isAccountValid);
    System.assertEquals(false, response1.isUserValid);
    System.assertEquals(false, response1.isNewUser);
    System.assertEquals(false, response1.userExists);
	System.assert(response1.message.contains('User is not validated.'));
    }

    @isTest
    static void testMorethanOneEmail(){
        Account acc= scc_TestDataFactory.accountCreation2('testAccount300');
        Contact con1 = scc_TestDataFactory.contactCreation( acc.Id, 'firstname300', 'testlastname300', 'testemail300@abc.com');
        Contact con2 = scc_TestDataFactory.contactCreation( acc.Id, 'firstname300', 'testlastname300', 'testemail300@abc.com');
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'salesforce.noreply@savvas.com' LIMIT 1];
        System.assertEquals(1, owea.size());
        
        EmailTemplate emailTemplate = [select Id, Subject, HtmlValue, Body from EmailTemplate where Name  = 'Case - New Case Created'];
        
        //email.setOrgWideEmailAddressId(owea.Id);
        
        email.setTemplateID(emailTemplate.Id);
        
        Case newCase = new Case();
        newCase.Subject = 'schoolEmail@gmail.com';
        newCase.status = 'New'; 
        newCase.origin = 'Web'; 
        newCase.Description = 
            			 'Name: firstName lastName,' +                   
                         'Email: schoolEmail,' +
                         'Type: Request to add school,' + 
            			 'School Name: companySchoolName,' +
                         'School Address:address,' +
                         'Description: description';
        insert newCase;
        
        scc_registrationformController.sendEmailtoCaseForMoreThanOneEmailId('firstname', 'lastName', 'schoolEmail@gmail.com', 
                                                                            '94107', 
                                                                'High School ABC', 'Test description', 
                                           'street123', 'Chicago','IL', '94107','USA');
        
        //emailMessagesToSend.add(email);
        
        
    }
    
    @isTest
    static void testSchoolNotFound(){
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'salesforce.noreply@savvas.com' LIMIT 1];
        System.assertEquals(1, owea.size());
        
        EmailTemplate emailTemplate = [select Id, Subject, HtmlValue, Body from EmailTemplate where Name  = 'Case - New Case Created'];
        
        //email.setOrgWideEmailAddressId(owea.Id);
        
        email.setTemplateID(emailTemplate.Id);
        
        Case newCase = new Case();
        newCase.Subject = 'schoolEmail@gmail.com';
        newCase.status = 'New'; 
        newCase.origin = 'Web'; 
        newCase.Description = 
            			 'Name: firstName lastName,' +                   
                         'Email: schoolEmail,' +
                         'Type: Request to add school,' + 
            			 'School Name: companySchoolName,' +
                         'School Address:address,' +
                         'Description: description';
        insert newCase;
        
        scc_registrationformController.sendEmailtoCaseForSchoolNotFound('firstname', 'lastName', 'schoolEmail@gmail.com', 
                                                                            '94107', 
                                                                'High School ABC', 'Test description', 
                                           'street123, Chicago,IL,94107,USA');
        
        //emailMessagesToSend.add(email);
        
        
    }*/
	
    
   }