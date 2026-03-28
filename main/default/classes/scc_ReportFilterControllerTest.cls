/*
Apex Test Class: scc_ReportFilterControllerTest
Author: CTS (Sudharani)
Created Date: 12/08/2024
Modified Date: 
*/
@isTest
public class scc_ReportFilterControllerTest {
    /**
*  Description: Below method is test setup test data for scc_ReportFilterController
*  @name: setup
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @testSetup
    static void setup() {
        // Create test data for User, Account, and Contact
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Schools Account'].Id;
        
        // Creating test Account
        Account SchoolAccount = new Account();
        SchoolAccount.name = 'TestR';
        SchoolAccount.RecordTypeId = strRecordTypeId;
        SchoolAccount.SAP_Account_Id__c = 'TestSAN';
        insert SchoolAccount;
        
        // Creating test Contact
        Contact cont = new Contact();
        cont.AccountId = SchoolAccount.id;
        cont.LastName = 'Testing';
        cont.Email = 'abc@xyz.com';
        cont.FirstName = 'Test';
        insert cont;
        
        // Creating User and associating it with the Contact
        Profile pd2 = [Select id From profile where name = 'Savvas External Users Base Profile' limit 1];
        
        User testUser1 = new User(
            ProfileId = pd2.Id,          
            LastName = 'Test User',
            Email = 'testuser@example.com',
            Username = 'testusersavvaswer@example.com',
            Alias = 'tuser',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ContactId = cont.Id  // Link the User to the Contact
        );
        insert testUser1;          
    }
   /**
*  Description: Below method is test setup test save or update report filters
*  @name: testSaveOrUpdateReportFilters_CreateNewFilter
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/
    @isTest
    static void testSaveOrUpdateReportFilters_CreateNewFilter() {
        // Retrieve the created User, Contact, and Account from the test setup
        User testUser1 = [SELECT Id, ContactId FROM User WHERE Username ='testusersavvaswer@example.com' LIMIT 1];
        Contact cont = [SELECT Id, AccountId FROM Contact WHERE Id = :testUser1.ContactId LIMIT 1];        
        
        // Prepare filter parameters
        List<Map<String, String>> filterParamsList = new List<Map<String, String>>();
        Map<String, String> filterParams = new Map<String, String>{
            'userId' => testUser1.id,
            'Name' => 'New Report [custom]',
            'isbnList' => '9780132154116,9780132154215',
            'poList' => 'PO11111,PO22222',
            'startDate' => Date.today().addDays(-7).format(),
            'endDate' => Date.today().format(),
            'orderStatus' => 'All',
            'orderEntryPeriod' => '6',
            'sortOrder1' => 'ISBN',
            'sortOrder2' => 'ISBN',
            'sortOrder3' => 'ISBN',
            'Description' => 'Test Description',
            'orginalReport' => 'Custom',
            'standardReport' => 'false'
        };
        filterParamsList.add(filterParams);
        
        // Call the method with test data
        Test.startTest();
        List<Id> savedFilterIds = scc_ReportFilterController.saveOrUpdateReportFilters(filterParamsList);
        Test.stopTest();

        // Assertions
        System.assertNotEquals(savedFilterIds.size(), 0, 'Expected at least one filter to be saved.');
        Custom_Report_Filter__c savedFilter = [SELECT Id, Name, ISBN_To_Include__c, PO_To_Include__c FROM Custom_Report_Filter__c WHERE Id = :savedFilterIds[0]];
        System.assertEquals(savedFilter.Name, 'New Report [custom]');
        System.assertEquals(savedFilter.ISBN_To_Include__c, '9780132154116,9780132154215');
        System.assertEquals(savedFilter.PO_To_Include__c, 'PO11111,PO22222');
    }
    
    
    @IsTest
    static void testSaveOrUpdateReportFilters_ExceptionHandling() {
        
       

      
        List<Map<String, String>> filterParamsList = new List<Map<String, String>>();
        Map<String, String> invalidFilterParams = new Map<String, String>{
            'userId' => UserInfo.getUserId(),  
            'Name' => 'Invalid Report Name',  
            'isbnList' => '123',       
            'poList' => '23467',
            'orderStatus' => 'InvalidStatus',
            'startDate' => '2024-12-31',
            'endDate' => '2025-01-01',
            'orderEntryPeriod' => 'Quarterly',
            'sortOrder1' => 'Asc',
            'sortOrder2' => 'Desc',
            'sortOrder3' => 'Asc',
            'Description' => 'Test Description',
            'originalReport' => 'ReportType',
            'standardReport' => 'false'
        };
        filterParamsList.add(invalidFilterParams);

        Test.startTest();
        try {
            // Call the method, expecting it to throw an AuraHandledException.
            scc_ReportFilterController.saveOrUpdateReportFilters(filterParamsList);
            System.assert(false, 'Expected an AuraHandledException to be thrown');
        } catch (AuraHandledException e) {
         
         System.assertEquals('Script-thrown exception', e.getMessage());
		
            // (Optional) Assert or verify any other relevant details.
        } catch (Exception ex) {
            System.assert(false, 'Unexpected exception type caught: ' + ex.getTypeName());
        }
        Test.stopTest();
    }
}