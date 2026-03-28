/* -----------------------------------------------------------------------------------------------------------------------
Name:        CustomLookupLwcControllerTest
Description: Test class for CustomLookupLwcController.

Date         Version  Author             Summary of Changes
-----------  -------  -----------------  ------------------------------------------------------------------------------
03/12/2022     1.0     Soundhariya       Initial Release
13/02/2022     2.0     Soundhariya       February First Biweekly Release
----------------------------------------------------------*/

@isTest
public class CustomLookupLwcControllerTest {
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
		
    }
    
	@isTest(seeAllData = false)
    static void getAccountDataWithoutFilter()
    {
        String accName = [SELECT Id,Name FROM Account LIMIT 1].Name;
        Test.startTest();
        	system.assert(CustomLookupLwcController.fetchLookupData(accName,'Account','','','BillingState,BillingCity').size() > 0);
        	system.assert(CustomLookupLwcController.fetchLookupData('','Account','','','BillingState,BillingCity').size() >= 0);
        Test.stopTest();
    }
	@isTest(seeAllData = false)
    static void getContactData()
    {
        String accID = [SELECT Id,AccountId FROM Contact LIMIT 1].AccountId;
        Test.startTest();
        	system.assert(CustomLookupLwcController.fetchLookupData('','Contact',accID,'AccountId','Account.Name').size() > 0);
       		system.assert(CustomLookupLwcController.fetchLookupData('Sample','Contact',accID,'AccountId','Account.name').size() > 0);
        Test.stopTest();
    }
}