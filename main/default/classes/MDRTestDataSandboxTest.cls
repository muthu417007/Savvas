/* -----------------------------------------------------------------------------------------------------------------------
 *  MDRTestDataSandbox
Name:       MDRTestDataSandboxTest
Description: This class is a test class for MDRTestDataSandboxTest class, this will be executed after refresh of the sandbox and 
it'll create test data in the sandbox

Date         Version         Author                          Summary of Changes
-----------  -------    -----------------           ------------------------------------------------------------------------------
12/09/2023     1.0    Pummy Kumari Gupta       December Biweekly release(W-012307)
-------------------------------------------------------------------------------------------------------------------------- *///MDRTestDataSandboxTest//
@isTest  private class MDRTestDataSandboxTest  {
     @isTest static void testMySandboxPrep() {
        Test.startTest();
    Test.testSandboxPostCopyScript(
            new MDRTestDataSandbox(),
            UserInfo.getOrganizationId(),
             UserInfo.getOrganizationId(),
            UserInfo.getOrganizationName()
        );
        Test.stopTest();
        System.assertEquals(8, [select count() from Account]);
        System.assertEquals(24, [select count() from Contact
                                  where AccountId <> null]);
    }
}