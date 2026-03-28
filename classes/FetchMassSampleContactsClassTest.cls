/* -----------------------------------------------------------------------------------------------------------------------
Name:        FetchMassSampleContactsClassTest
WI:			 W-010962
Description: This is the test class for 'FetchMassSampleContactsClass'

Date         Version  Author             Summary of Changes
-----------  -------  -----------------  ------------------------------------------------------------------------------
12/14/2022     1.0    Soundhariya     Initial Release
------------------------------------------------------------------------------------------------------------------*/
@isTest
public class FetchMassSampleContactsClassTest {
    @testsetup
    public static void testsetUp(){
        Account acc = new Account(name = 'Test');
        insert acc;
		
		Contact con = new Contact();
		con.firstname = 'Test';
		con.LastName = 'Sample';
		con.accountId = acc.id;
		con.email= 'testsample@test.com';
		insert con;
        
		SampleRequest__c samReq = new SampleRequest__c();
		insert samReq;
		
		SampleRequestContact__c samReqCon = new SampleRequestContact__c();
		samReqCon.Account__c = acc.Id;
		samReqCon.Contact__c = con.Id;
		samReqCon.SampleRequest__c = samReq.Id;
		insert samReqCon;
    }
    
	@isTest(seeAllData = false)
    static void getSampleContacts()
    {
        String samReq = [SELECT Id FROM SampleRequest__c LIMIT 1].Id;
        Test.startTest();
        	system.assert(FetchMassSampleContactsClass.searchSampleContacts(samReq).size() > 0);
        Test.stopTest();
    }
	
	@isTest(seeAllData = false)
    static void getContactAccount()
    {
        String conRec = [SELECT Id,AccountId FROM Contact LIMIT 1].Id;
        Test.startTest();
        	system.assert(FetchMassSampleContactsClass.fetchContactAccount(conRec).size() > 0);
        Test.stopTest();
    }
    @isTest(seeAllData = false)
    static void getParentData()
    {
        String parentId = [SELECT Id FROM SampleRequest__c LIMIT 1].Id;
        Test.startTest();
        	system.assert(FetchMassSampleContactsClass.fetchParentData(parentId).size() > 0);
        Test.stopTest();
    }
}