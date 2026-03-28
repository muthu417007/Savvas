/******************************************************************************** 
* Description: Test class for RPAMatchedAccountController
*********************************************************************************/
@isTest
public class RPAMatchedAccountControllerTest {

    @testSetup
    static void testDataMethod(){
        EmailServiceConfig__c sConfig = new EmailServiceConfig__c();
        sConfig.host_url__c = 'http://1.1.1.1/infer';
        sConfig.RPAReConsciliation__c = 'http://1.1.1.1/token';
        sConfig.Content_Type__c = 'application/json';
        sConfig.SetupOwnerId = UserInfo.getOrganizationId();
        insert sConfig;
        
        map<String, String> mapMockResponse = new map<String, String>();
        Test.setMock(HttpCalloutMock.class, new CaseTriggerForRPAIntegrationTestMock(mapMockResponse));
        
        //insert Accounts
        List<Account> accountsToInsert = new list<Account>();
        accountsToInsert.add( new Account(Name = 'RPA Dummy Account', Type = 'Internal'));
        accountsToInsert.add( new Account(Name = 'Kacee Torgerson', Type = 'Clinic', BillingCity = 'Placerville', BillingState = 'CA', BillingPostalCode = '95667', BillingStreet = 'PO Box 1387', BillingCountry = 'United States'));
        accountsToInsert.add( new Account(Name = 'Shaena Torgerson', Type = 'Individual Educ', BillingCity = 'Corona', BillingState = 'CA', BillingPostalCode = '92880', BillingStreet = '7226 Spindlewood Drive', BillingCountry = 'United States'));
        insert accountsToInsert;
        //Erie 1 BOCES
        //insert Contacts 
        List<Contact> contactsToInsert = new list<Contact>();
        contactsToInsert.add( new Contact(AccountId = accountsToInsert[1].Id, FirstName = 'Terrie', LastName = 'Licht', Email = 'office@stjohnnt.com'));
        insert contactsToInsert;
        
        //insert Account Address
        List<Account_Addresses__c> acntAddrsToInsert = new List<Account_Addresses__c>();
        acntAddrsToInsert.add(new Account_Addresses__c(Account__c = accountsToInsert[1].Id, 
                                                       Address_1__c ='355 HARLEM ROAD', 
                                                       Address_2__c = 'SERV EDUCATION CAMPUS SERVICE CTR',
                                                       Address_Type__c ='Billing',
                                                       City__c = 'WEST SENECA',
                                                       Country__c ='US',
                                                       ERP_Account_Name__c = 'ERIE 1 BD OF COOPERATIVE EDUCATION',ERP_Account_Number__c = '0002157046',
                                                       Source__c = 'SAP_USK12',
                                                       State__c = 'NY',
                                                       Zip_Code__c = '14224-1892'));

        acntAddrsToInsert.add(new Account_Addresses__c(Account__c = accountsToInsert[2].Id, 
                                                       Address_1__c ='355 HARLEM ROAD', 
                                                       Address_Type__c ='Shipping',
                                                       City__c = 'WEST SENECA',
                                                       Country__c ='US',
                                                       ERP_Account_Name__c = 'ST JOHN LUTHERAN SCHOOL',
                                                       ERP_Account_Number__c = '0002156407',
                                                       Source__c = 'SAP_USK12',
                                                       State__c = 'NY',
                                                       Zip_Code__c = '14224-1892'));
        
        
        insert acntAddrsToInsert;
        
        list<Order__c> ordersToInsert = new list<Order__c>();
        ordersToInsert.add( new Order__c(OrderType__c = 'RPA', Account__c = accountsToInsert[0].Id, Account_Address_Ids__c = acntAddrsToInsert[0].Id+','+acntAddrsToInsert[1].Id));
        ordersToInsert.add( new Order__c(OrderType__c = 'RPA', Account__c = accountsToInsert[0].Id, Account_Address_Ids__c = accountsToInsert[1].Id+','+accountsToInsert[2].Id));
        insert ordersToInsert;
    }
    
    @isTest
    static void testaccountaddressmatch(){ 
        Test.startTest();
        	RPAMatchedAccountController.getMatchedAccounts([SELECT Account_Address_Ids__c FROM Order__c][0].Id);
        Test.stopTest();
    }
    
     @isTest
    static void testaccountmatch(){ 
        Test.startTest();
        	RPAMatchedAccountController.getMatchedAccounts([SELECT Account_Address_Ids__c FROM Order__c][1].Id);
        Test.stopTest();
    }
}