@isTest
public class scc_registrationformControllerTest {
     @isTest
    static void testClassMethod(){
        Account acc= scc_TestDataFactory.accountCreation2('testAccount300');
        Contact con = scc_TestDataFactory.contactCreation( acc.Id, 'firstname300', 'testlastname300', 'testemail300@abc.com');
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Customer Community Plus Login User' LIMIT 1];
        User testUserrr = new User();
        testUserrr.ProfileId=profileId.Id;          
        testUserrr.LastName = 'Test User';
        testUserrr.Email = 'testemail300@abc.com';
        testUserrr.Username = 'testemail300@abc.com' + System.currentTimeMillis();
        testUserrr.Alias = 'tuser';
        testUserrr.TimeZoneSidKey = 'America/Los_Angeles';
        testUserrr.LocaleSidKey = 'en_US';
        testUserrr.EmailEncodingKey = 'UTF-8';
        testUserrr.LanguageLocaleKey = 'en_US';
        testUserrr.ContactId=con.id;
        insert testUserrr;

        System.runAs(testUserrr){
            Scc_RegistrationFormController.RegistrationResponse response01 =Scc_RegistrationFormController.verifyRegistration('firstname300','testlastname300', 'testemail300@abc.com', '12345', 'testAccount300');
           
            
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
        testUserr.Email = 'testuser101@example.com';
        testUserr.Username = 'testuser101@example.com' + System.currentTimeMillis();
        testUserr.Alias = 'tuser';
        testUserr.TimeZoneSidKey = 'America/Los_Angeles';
        testUserr.LocaleSidKey = 'en_US';
        testUserr.EmailEncodingKey = 'UTF-8';
        testUserr.LanguageLocaleKey = 'en_US';
        testUserr.ContactId=con1.id;
        insert testUserr;
        BuyerAccount buyrAcc = new BuyerAccount();
        buyrAcc.Name = acc1.Name;
        buyrAcc.BuyerId = acc1.Id;
        buyrAcc.IsActive = false;
        insert buyrAcc;  
        System.runAs(testUserr){
            Scc_RegistrationFormController.RegistrationResponse response02 =Scc_RegistrationFormController.verifyRegistration('firstname400','lastname400','testemail440@abc.com','12345','testAccount400');
            
        }       
    }
    
    @TestSetup
    public static void setup() {
        
        String testEmail = 'test00@example.com';
        String testZipCode = '1234500';
        
        Account testAccount = new Account(Name = 'TestAccount00',type='public school',BillingStreet = '123 Test St00', BillingCity = 'Test City00', BillingState = 'MH', BillingPostalCode = '12300', BillingCountry = 'United States', MDR_PID__c = '12345600',Account_Status__c='Active' );
        insert testAccount;
        Contact  testContact = new Contact(FirstName = 'Test00', LastName = 'Contact00', Email = testEmail, AccountId = testAccount.Id);
        insert testContact;
        
        Account testAccount1 = new Account(
            Name = 'TestAccount100',BillingStreet = '123 Test St00', BillingCity = 'Test City00', BillingState = 'MH', BillingPostalCode = '12300', BillingCountry = 'United States', 
            MDR_PID__c = '12345700',Account_Status__c='Inactive',type='public school'
            
            
        );
        insert testAccount1;
        
       
           Account testAccount2 = new Account(
            Name = 'TestAccount1003',BillingStreet = '123 Test St00', BillingCity = 'Test City00', BillingState = 'MH', BillingPostalCode = '12300', BillingCountry = 'United States', 
            MDR_PID__c = '123457006',Account_Status__c='active',type='private'  
        );
        insert testAccount2;
        
         Contact  testContact3 = new Contact(FirstName = 'Test006', LastName = 'Contact006', Email = 'test001@example.com', AccountId = testAccount2.Id);
        insert testContact3;
        Contact testContact2= new Contact(
            FirstName = 'Test100',
            LastName = 'Contact100',
            Email = 'test100test@example.com',
            AccountId = testAccount2.Id
           
        );
        insert testContact2;
        WebStore webStr = new WebStore();
        webStr.Name = 'MySavvasOrders';
        webStr.PricingStrategy = 'LowestPrice';
        insert webStr;
        
        scc_TestDataFactory.initialStorefrontSetup(webStr.Id, testAccount.Id, testAccount.Name);
        
    }
    
     @isTest
    static void testVerifyRegistration3() {
        Account acct = [SELECT Id,BillingPostalCode,type,Name FROM Account WHERE Name='TestAccount1003' LIMIT 1];
        contact cct = [SELECT Id,Email,FirstName,LastName FROM contact WHERE Accountid=:acct.id LIMIT 1];
        contact cct1 = [SELECT Id,Email,FirstName,LastName FROM contact WHERE Email=:'test001@example.com'LIMIT 1];
        Scc_RegistrationFormController.RegistrationResponse response = Scc_RegistrationFormController.verifyRegistration(
            cct.FirstName,
            cct.LastName,
            cct.Email,
            acct.BillingPostalCode,
            acct.Name
        );
        system.debug(response);
       
                
    }

    
    
    @isTest
    static void testVerifyRegistration() {
        Account acct = [SELECT Id,BillingPostalCode,type,Name FROM Account WHERE Name='TestAccount00' LIMIT 1];
        contact cct = [SELECT Id,Email,FirstName,LastName FROM contact WHERE Accountid=:acct.id LIMIT 1];
        contact cct1 = [SELECT Id,Email,FirstName,LastName FROM contact WHERE Email=:'test00@example.com'LIMIT 1];
        Scc_RegistrationFormController.RegistrationResponse response = Scc_RegistrationFormController.verifyRegistration(
            cct.FirstName,
            cct.LastName,
            cct.Email,
            acct.BillingPostalCode,
            acct.Name
        );
        system.debug(response);
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
                                list< user> tobeinsert = new list<user>();
        
                                User testUserr = new User();
        testUserr.ProfileId=profileId.Id;          
        testUserr.LastName = 'Test User';
        testUserr.Email = 'testuser202@example.com';
        testUserr.Username = 'testuser202@example.com' + System.currentTimeMillis();
        testUserr.Alias = 'tuser';
        testUserr.TimeZoneSidKey = 'America/Los_Angeles';
        testUserr.LocaleSidKey = 'en_US';
        testUserr.EmailEncodingKey = 'UTF-8';
        testUserr.LanguageLocaleKey = 'en_US';
        testUserr.ContactId=cct.id;
       
        //User testUserr = new User();
        
         
        insert testUserr;
        list<user> listofusers =[select id from  user where email='testuser202@example.com' limit 1 ];
        String userId = scc_RegistrationFormController.createUser(responseMap);
        //id userIdone= scc_RegistrationFormController.createUser(responseMap);
        scc_RegistrationFormController.createUser(responseMap1);
        
        scc_RegistrationFormController.assignPermissionSets(new list<Id>{listofusers[0].id});
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

} */
    
    @isTest
    static void testVerifyRegistration_ContactAndAccountNotValidated1() {
        Account acct = [SELECT Id,BillingPostalCode,Name FROM Account WHERE Name='TestAccount100' LIMIT 1];
        //contact cct = [SELECT Id,Email,FirstName,LastName FROM contact WHERE Accountid=:acct.id LIMIT 1];
        contact cct1 = [SELECT Id,Email,FirstName,LastName FROM contact WHERE Email=:'test100test@example.com'LIMIT 1];
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
        system.debug(response1);
        
        
        
        System.assertEquals(false, response1.isContactValid);
        System.assertEquals(false, response1.isAccountValid);
        System.assertEquals(false, response1.isUserValid);
        System.assertEquals(false, response1.isNewUser);
        System.assertEquals(false, response1.userExists);
         System.assertnotEquals(false, response1.IsaccountTypenotincluded);
        System.assert(response1.message.contains('User is not validated.'));
    }
    
     @isTest
    static void testMorethanOneEmail(){
        // Create test data
        Account acc = scc_TestDataFactory.accountCreation2('testAccount300');
        Contact con1 = scc_TestDataFactory.contactCreation(acc.Id, 'firstname300', 'testlastname300', 'testemail300@abc.com');
        Contact con2 = scc_TestDataFactory.contactCreation(acc.Id, 'firstname300', 'testlastname300', 'testemail300@abc.com');
        
        // Set up email template
        EmailTemplate emailTemplate = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE Name = 'Case - New Case Created'];
        
        // Create a test case
        Case newCase = new Case(
            Subject = 'schoolEmail@gmail.com',
            Status = 'New',
            Origin = 'Web',
            Description = 'Name: firstName lastName, ' +
                          'Email: schoolEmail, ' +
                          'Type: Request to add school, ' +
                          'School Name: companySchoolName, ' +
                          'School Address: address, ' +
                          'Description: description'
        );
        insert newCase;
        
        // Set up test parameters
        String firstName = 'firstname';
        String lastName = 'lastName';
        String schoolEmail = 'schoolEmail@gmail.com';
        String selectedZipCode = '94107';
        String companySchoolName = 'High School ABC';
        String description = 'Test description';
        String street = 'street123';
        String city = 'Chicago';
        String state = 'IL';
        String postalCode = '94107';
        String country = 'USA';
        Boolean isContactValid = true;
        Boolean isAccountValid = false;
        string  message = 'duplicateusername';

        Test.startTest();
        // Call the method being tested
        Boolean result = scc_registrationformController.sendEmailtoCaseForMoreThanOneEmailId(
            firstName, lastName, schoolEmail, selectedZipCode, companySchoolName, description,
            street, city, state, postalCode, country, isContactValid, isAccountValid, message
        );
        Test.stopTest();

        // Debug statements instead of assertions
        System.debug('Email send result: ' + result);

        // Check created cases
        List<Case> createdCases = [SELECT Id, Subject FROM Case WHERE Subject LIKE 'Email ID found at different account%'];
        System.debug('Number of cases created: ' + createdCases.size());
        if (!createdCases.isEmpty()) {
            System.debug('Case subject: ' + createdCases[0].Subject);
        }

        // Check sent emails
        List<EmailMessage> sentEmails = [SELECT Id, Subject FROM EmailMessage WHERE ParentId IN :createdCases];
        System.debug('Number of emails sent: ' + sentEmails.size());
        if (!sentEmails.isEmpty()) {
            System.debug('Email subject: ' + sentEmails[0].Subject);
        }

        // Additional debug information
        System.debug('All Cases: ' + [SELECT Id, Subject FROM Case]);
        System.debug('All EmailMessages: ' + [SELECT Id, Subject, ParentId FROM EmailMessage]);
    }
    @isTest
    static void testMorethanOneEmail1(){
        // Create test data
        Account acc = scc_TestDataFactory.accountCreation2('testAccount300');
        Contact con1 = scc_TestDataFactory.contactCreation(acc.Id, 'firstname300', 'testlastname300', 'testemail300@abc.com');
        Contact con2 = scc_TestDataFactory.contactCreation(acc.Id, 'firstname300', 'testlastname300', 'testemail300@abc.com');
        
        // Set up email template
        EmailTemplate emailTemplate = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE Name = 'Case - New Case Created'];
        
        // Create a test case
        Case newCase = new Case(
            Subject = 'schoolEmail@gmail.com',
            Status = 'New',
            Origin = 'Web',
            Description = 'Name: firstName lastName, ' +
                          'Email: schoolEmail, ' +
                          'Type: Request to add school, ' +
                          'School Name: companySchoolName, ' +
                          'School Address: address, ' +
                          'Description: description'
        );
        insert newCase;
        
        // Set up test parameters
        String firstName = 'firstname';
        String lastName = 'lastName';
        String schoolEmail = 'schoolEmail@gmail.com';
        String selectedZipCode = '94107';
        String companySchoolName = 'High School ABC';
        String description = 'Test description';
        String street = 'street123';
        String city = 'Chicago';
        String state = 'IL';
        String postalCode = '94107';
        String country = 'USA';
        Boolean isContactValid = true;
        Boolean isAccountValid = false;
        string  message = 'schoolnotmatched';

        Test.startTest();
        // Call the method being tested
        Boolean result = scc_registrationformController.sendEmailtoCaseForMoreThanOneEmailId(
            firstName, lastName, schoolEmail, selectedZipCode, companySchoolName, description,
            street, city, state, postalCode, country, isContactValid, isAccountValid, message
        );
        Test.stopTest();

        // Debug statements instead of assertions
        System.debug('Email send result: ' + result);

        // Check created cases
        List<Case> createdCases = [SELECT Id, Subject FROM Case WHERE Subject LIKE 'Email ID found at different account%'];
        System.debug('Number of cases created: ' + createdCases.size());
        if (!createdCases.isEmpty()) {
            System.debug('Case subject: ' + createdCases[0].Subject);
        }

        // Check sent emails
        List<EmailMessage> sentEmails = [SELECT Id, Subject FROM EmailMessage WHERE ParentId IN :createdCases];
        System.debug('Number of emails sent: ' + sentEmails.size());
        if (!sentEmails.isEmpty()) {
            System.debug('Email subject: ' + sentEmails[0].Subject);
        }

        // Additional debug information
        System.debug('All Cases: ' + [SELECT Id, Subject FROM Case]);
        System.debug('All EmailMessages: ' + [SELECT Id, Subject, ParentId FROM EmailMessage]);
    }
        @isTest
    static void testMorethanOneEmail2(){
       Test.startTest();
        // Call the method being tested
        Boolean result = scc_registrationformController.sendEmailtoCaseForMoreThanOneEmailId(
            'sudha', 'k', 'kschool2@gmail.com', '94107', 'kschool', 'text',
            'help', 'honda', 'kalamkari', '94107', 'us', true, false, 'user is not validated'
        );
        Test.stopTest();  
    }
        @isTest
     static void testMorethanOneEmail3(){
       Test.startTest();
        // Call the method being tested
        Boolean result = scc_registrationformController.sendEmailtoCaseForMoreThanOneEmailId(
            'sudha', 'k', 'kschool2@gmail.com', '94107', 'kschool', 'text',
            'help', 'honda', 'kalamkari', '94107', 'us', true, false, 'schoolnotvalid'
        );
        Test.stopTest();  
    }
        @isTest
     static void testMorethanOneEmail4(){
       Test.startTest();
        // Call the method being tested
        Boolean result = scc_registrationformController.sendEmailtoCaseForMoreThanOneEmailId(
            'sudha', 'k', 'kschool2@gmail.com', '94107', 'kschool', 'text',
            'help', 'honda', 'kalamkari', '94107', 'us', true, false, 'usercreation'
        );
        Test.stopTest();  
    }
        @isTest
    static void testMorethanOneEmail5(){
       Test.startTest();
        // Call the method being tested
        Boolean result = scc_registrationformController.sendEmailtoCaseForMoreThanOneEmailId(
            'sudha', 'k', 'kschool2@gmail.com', '94107', 'kschool', 'text',
            'help', 'honda', 'kalamkari', '94107', 'us', true, false, ''
        );
        Test.stopTest();  
    }
    @isTest
    static void testSchoolNotFound(){
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'SavvasAccessDoNotReply@savvas.com' LIMIT 1];
       // System.assertEquals(1, owea.size());
        
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
        
        
    }
}