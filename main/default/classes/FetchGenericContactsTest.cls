/* -----------------------------------------------------------------------------------------------------------------------
Name:        FetchGenericContactsTest
WI:			 W-010962
Description: This is the test class for 'FetchGenericContacts'

Date         Version  Author             Summary of Changes
-----------  -------  -----------------  ------------------------------------------------------------------------------
12/14/2022     1.0    Soundhariya     Initial Release
------------------------------------------------------------------------------------------------------------------*/
@isTest
public class FetchGenericContactsTest {
    @testsetup
    public static void testsetUp(){
        Account acc = new Account(name = 'Test');
        insert acc;
        
		SampleRequest__c samReq = new SampleRequest__c();
		insert samReq;
		
		Mass_Sample_Generic_Contacts__c samReqGenCon = new Mass_Sample_Generic_Contacts__c();
		samReqGenCon.Account__c = acc.Id;
		samReqGenCon.Generic_Contact__c = 'TestCon';
		samReqGenCon.Mass_Sample_Generic__c = samReq.Id;
		insert samReqGenCon;
    }
    
	@isTest(seeAllData = false)
    static void getSampleContacts()
    {
        String samReq = [SELECT Id FROM SampleRequest__c LIMIT 1].Id;
        Test.startTest();
        	system.assert(FetchGenericContacts.searchSampleContacts(samReq).size() > 0);
        Test.stopTest();
    }
}