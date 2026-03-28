/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Test class for SelfSamplingController
* 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Romer Pasag   	<Romer.Pasag@pearson.com>
* @modifiedBy     Romer Pasag   	<Romer.Pasag@pearson.com>
* @maintainedBy   Romer Pasag   	<Romer.Pasag@pearson.com>
* @version        1.0
* @created        2017-09-11
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* v1.0        	  Romer.Pasag@pearson.com
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/


@isTest
public class testSelfSampling {
    static testMethod void myUnitTestSelfSampling(){
        // Create a test user Role
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
        
        //Create a user to be used as a the manager user
        User mgr = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'ICOM Sales Mgr'].Id,
            LastName = 'last',
            Email = 'mgrUser000@test.com',
            Username = 'mgrUser@test.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/New_YORK',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = r.Id
        );
        
        //Create a test user
        insert mgr;
        User usr = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'ICOM Sales Rep'].Id,
            LastName = 'last',
            Email = 'puser000@test.com',
            Username = 'puser000@test.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/New_YORK',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = r.Id,
            Alternate_Sample_Approver__c='altmgrUser000@test.com',
            managerId=mgr.Id
        );
        insert usr;
        
        //Run as the user
        system.runas(usr){
            PageReference pageRef = Page.SelfSampleIFRAME;
            Test.setCurrentPage(pageRef);
            Test.startTest();
            selfSamplingController controller = new selfSamplingController();
            Test.stopTest();
        }
        
    }
}