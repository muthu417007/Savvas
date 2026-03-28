@isTest
Public class SchoolFinderTest {
    @testSetup static void setup() {
        Account newAccount = new Account(Name='TestParentAccount', 
                                         BillingCity='Texas',BillingStreet='100 Hudson Street',
                                         BillingPostalCode='10013', BillingState='NY',Type='County School',
                                         BillingCountry='United States',MDR_PID__c='897',Account_Status__c='Active');
        insert newAccount;
        Savvas_Sample_Resources_Account_Type__c accountType = new Savvas_Sample_Resources_Account_Type__c(Name='County School',Type__c='\'County School\'');
        Insert accountType;
    }
    @isTest
    Public static void fetchSchoolOptions(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/userregistration';
        req.httpMethod = 'Post';
        req.requestBody=Blob.valueOf('{ "isEmailAvailable" : true, "email" : "dummy@dummy.com", "zipCode":"10013" }');
        RestContext.request = req;
        RestContext.response= res;
        SchoolFinder.fetchSchoolOptions(); 
        String responseBody = res.responseBody.toString();
        System.debug('responseBody---> '+responseBody);
    }
    @isTest
    Public static void fetchSchoolOptionsNegative(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/userregistration';
        req.httpMethod = 'Post';
        req.requestBody=Blob.valueOf('{ "isEmailAvailable" : false, "email" : "dummy@dummy.com", "zipCode":"5000" }');
        RestContext.request = req;
        RestContext.response= res;
        SchoolFinder.fetchSchoolOptions(); 
        String responseBody = res.responseBody.toString();
    }
    @isTest
    Public static void fetchSchoolOptionsPositive(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/userregistration';
        req.httpMethod = 'Post';
        req.requestBody=Blob.valueOf('{ "isEmailAvailable" : false, "email" : "dummy@dummy.com", "zipCode":"10013" }');
        RestContext.request = req;
        RestContext.response= res;
        SchoolFinder.fetchSchoolOptions(); 
        String responseBody = res.responseBody.toString();
    }
    @isTest
    Public static void fetchSchoolOptionsState(){
        Account account = [SELECT Id,Name from Account where Name='TestParentAccount'];
        Contact newContact = new Contact(FirstName ='TestDummy',LastName='Test'+Integer.valueOf((Math.random())),
                                         Email = 'dummy@dummy.com',AccountId=account.Id);
        insert newContact;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/userregistration';
        req.httpMethod = 'Post';
        req.requestBody=Blob.valueOf('{ "isEmailAvailable" : false, "email" : "dummy@dummy.com", "zipCode":"Texas" }');
        RestContext.request = req;
        RestContext.response= res;
        SchoolFinder.fetchSchoolOptions(); 
        String responseBody = res.responseBody.toString();
    }
    
    @isTest
    Public static void fetchSchoolOption(){
        Account account = [SELECT Id,Name from Account where Name='TestParentAccount'];
        Contact newContact = new Contact(FirstName ='TestDummy',LastName='Test'+Integer.valueOf((Math.random())),
                                         Email = 'dummy@dummy.com',AccountId=account.Id);
        insert newContact;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/userregistration';
        req.httpMethod = 'Post';
        req.requestBody=Blob.valueOf('{ "isEmailAvailable" : null, "email" : null, "zipCode":null }');
        RestContext.request = req;
        RestContext.response= res;
        SchoolFinder.fetchSchoolOptions(); 
        String responseBody = res.responseBody.toString();
    }
}