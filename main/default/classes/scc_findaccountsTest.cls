/*********************************************************** 
* @Class Name  - scc_findaccountsTest
* @description - Test class for scc_findaccounts
* @Created By  - CTS-Suresh Kalshetti
* @Created On - 2024-05-21
* **********************************************************/ 
@isTest
public class scc_findaccountsTest {
    /**
*  Description: Below method is test findAccountNames from class scc_findaccounts
*  @name: testFindAccountNames
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void testFindAccountNames(){
        //Create Test Data
        String testEmail = 'test@example.com';
        String testZipCode = '12345';
        
        // Create Test Contact and Account Data
        Account testAccount = new Account(Name = 'Test Account');
         insert testAccount;
        Contact testContact = new Contact(FirstName = 'Test', LastName = 'Contact', Email = testEmail, AccountId = testAccount.Id);
        insert testContact;
        
        Test.startTest();
        //Call the FindAccountsNames method with test Data
        List<Map<String, String>> accountOptions = Scc_FindAccounts.findAccountNames(testEmail, testZipCode);
        Test.stopTest();
        
        //Verify that the correct account options are returned 
        System.assertEquals(1, accountOptions.size());
        System.assertEquals(testAccount.Id, accountOptions[0].get('accountId'));
        System.assertEquals(testAccount.Name, accountOptions[0].get('accountName'));
        
    }
    
    /**
*  Description: Below method is test getBuildingAddress from class scc_findaccounts
*  @name: testGetBuildingAddress
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void testGetBuildingAddress(){
        //Create test account
        Account testAccount = new Account(Name = 'Test Account',BillingStreet = '123 Test St', BillingCity = 'Test City', BillingState = 'MH', BillingPostalCode = '12345', BillingCountry = 'United States', MDR_PID__c = '123456' );
        insert testAccount;
        
        Test.startTest();
        // Call the getBuildingAddress method with test data
        Map<String, String> addressMap = Scc_FindAccounts.getBuildingAddress(testAccount.Id);
        Test.stopTest();
        
        //Verify that the correct address details are returned 
        System.assertEquals('123 Test St', addressMap.get('street'));
        System.assertEquals('Test City', addressMap.get('city'));
        System.assertEquals('MH', addressMap.get('state'));        
        System.assertEquals('United States', addressMap.get('country'));
        System.assertEquals('Test Account', addressMap.get('companyName'));
    }
    @IsTest
    static void testFindAccountNames_ExceptionCase() {
        Test.startTest();
        // Call the method with null values and capture the result
        List<Map<String, String>> result = scc_findaccounts.findAccountNames(null, null);
        Test.stopTest();
    
        // Since no exception is thrown, verify the result or expected logs if needed
        System.assertEquals(0, result.size(), 'Expected no results when null values are passed');
    }

    @IsTest
static void testGetBuildingAddress_ExceptionCase() {
    Test.startTest();
    // Call the method with an invalid account ID
    Map<String, String> result = scc_findaccounts.getBuildingAddress('invalidAccountId');
    Test.stopTest();

    // Verify that the method handled the invalid ID and returned an empty map
    System.assertEquals(0, result.size(), 'Expected an empty map when an invalid account ID is passed');
}

}