@isTest
/**
 * Class with helper method for UT
 */
global class PortalTestHelper {
    /**
     * Community user profile name
     * @type String
     */
    //public static String portalUserProfil = 'Community Connection External User';
    public static String portalUserProfil = 'Savvas External Users Base Profile';//SSO Implementation changes
    
    /**
     * Returns community guest user
     * 
     * @return User Guest user
     */
    public static User getGuestUser() {
        return [SELECT Id FROM User WHERE UserType = 'Guest' LIMIT 1];
    }

    /**
     * Set environment variable like custom settings
     * 
     * @return void
     */
    public static void setEnv() {
        Id profileId = [SELECT Id FROM Profile WHERE Name =:  portalUserProfil LIMIT 1].Id; 
        CommunityRegistrationSettings__c registrationSettings = new CommunityRegistrationSettings__c(
            userNameSuffix__c   = '-UT-suffix',
            ProfileId__c        = profileId,
            TimeZone__c         = 'America/Chicago',
            Locale__c           = 'en_US',
            EmailEncoding__c    = 'ISO-8859-1',
            LanguageLocale__c   = 'en_US'
        );
        insert registrationSettings;
    }

    /**
     * Returns test accounts
     *
     * @param Integer size number of account to create
     * @return List<Account> list of test accounts ready to insert into database
     */
    public static List<Account> createAccounts(Integer size) {
        List<Account> accounts = new List<Account>();
        for (Integer i=0; i<size; i++) {
            accounts.add(
                new Account(
                    name = 'Test Acccount' + String.valueOf(i), BillingCity = 'city'
                )
            ); 
        }
        return accounts;
    }

    /**
     * Returns test contacts. Default account is automatically created
     *
     * @param Integer size number of contacts to create
     * @return List<Contact> list of test contacts ready to insert into database
     */
    public static List<Contact> createContacts(Integer size) {
        Account acc = createAccounts(1)[0];
        insert acc;
        return createContacts(size, acc.Id);
    }

    /**
     * Returns test contacts. 
     *
     * @param Integer size number of contacts to create
     * @param Id AccountId Contact's account id
     * @return List<Contact> list of test contacts ready to insert into database
     */
    public static List<Contact> createContacts(Integer size, Id accountId) {
        List<Contact> contacts = new List<Contact>();
        for (integer i=0; i<size; i++) {
            contacts.add(
                new Contact(
                    FirstName   = 'John',
                    LastName    = 'Doe' + i,
                    email       = 'johndoe' + i + '@test.com',
                    accountId   = accountId
                )
            );            
        }
        return contacts;        
    }

    /**
     * Returns test cases for given contactId
     * 
     * @param Integer size number of cases to create
     * @param Id contactId Contact id
     * @return List<Case> list of test cases ready to insert into database
     */
    public static List<Case> createCases(Integer size, Id contactId) {
        List<Case> cases = new List<Case>();
        ID accountId = [SELECT AccountId FROM Contact WHERE Id =: contactId].AccountId;
        for (integer i=0; i<size; i++) {
            cases.add(
                new Case(
                    Subject     = 'UT_SUBJECT-' + String.valueOf(i),
                    Platform__c = 'UT_Platform' + String.valueOf(i),
                    ContactId   = contactId,
                    AccountId   = accountId
                )
            );
        }
        return cases;
    }

    /**
     * Returns test account suport notes for given accountId
     * 
     * @param Integer size number of account suport notes to create
     * @param Id accountId Account id
     * @return List<Account_Support_Note__c> list of test account suport notes ready to insert into database
     */
    public static List<Account_Support_Note__c> createAccountSuportNotes(Integer size, Id accountId) {
        List<Account_Support_Note__c> notes = new List<Account_Support_Note__c>();
        for (integer i=0; i<size; i++) {
            notes.add(
                new Account_Support_Note__c(
                    Type__c             = '<Case></Case>',
                    Message__c          = 'UT_MESSAGE-' + String.valueOf(i),
                    Account__c          = accountId,
                    StartDate__c        = Date.today(),
                    ExpirationDate__c   = Date.today().addDays(2)
                )
            );
        }
        return notes;
    }

    /**
     * Returns test contact suport notes for given accountId
     * 
     * @param Integer size number of account suport notes to create
     * @param Id contactId Contact id
     * @return List<Contact_Support_Note__c> list of test contact suport notes ready to insert into database
     */
    public static List<Contact_Support_Note__c> createContactSuportNotes(Integer size, Id contactId) {
        List<Contact_Support_Note__c> notes = new List<Contact_Support_Note__c>();
        for (integer i=0; i<size; i++) {
            notes.add(
                new Contact_Support_Note__c(
                    Type__c             = '<Case></Case>',
                    Message__c          = 'UT_MESSAGE-' + String.valueOf(i),
                    Contact__c          = contactId,
                    StartDate__c        = Date.today(),
                    ExpirationDate__c   = Date.today().addDays(2)
                )
            );
        }
        return notes;
    }

    /**
     * Creates test portal user
     * 
     * @param Contact c Contact object
     * @return User Portal user
     */
    public static User createPortalUser(Contact c) {
    system.debug('****[portalTestHelper.createPortalUser - contact: ]' + c);
        Id PrfId = [SELECT Id FROM Profile WHERE Name='Savvas External Users Base Profile Temp'].Id;
        CommunityRegistrationSettings__c registrationSettings = CommunityRegistrationSettings__c.getInstance();
        User u = new User(
            UserName            = c.Email + (String.isBlank(registrationSettings.userNameSuffix__c) ? '' : registrationSettings.userNameSuffix__c),
            Email               = c.Email,
            Alias               = c.FirstName.left(1) + c.LastName.Left(7),
            //community nickname must be unique, that is why we use email address
            CommunityNickName   = (c.Email + ' ' + c.FirstName + ' ' + c.LastName).left(40),
            LastName            = c.LastName, 
            FirstName           = c.FirstName, 
            ContactId           = c.Id,
            ProfileId           = PrfId,
            TimeZoneSidKey      = registrationSettings.TimeZone__c,
            LocaleSidKey        = registrationSettings.Locale__c,
            EmailEncodingKey    = registrationSettings.EmailEncoding__c,
            LanguageLocaleKey   = registrationSettings.LanguageLocale__c,
            IsActive            = true
        );
        insert u;
    system.debug('****[portalTestHelper.createPortalUser - user: ]' + u);
        return u;
    }
}