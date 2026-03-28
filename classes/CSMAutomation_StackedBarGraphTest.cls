@isTest
public class CSMAutomation_StackedBarGraphTest {
 @testSetup
    static void setup() {
        // Create an Account
        Account acc = new Account(Name='Test Account');
        insert acc;
        
        // Create a WorkOrder linked to the Account
        WorkOrder workOrder = new WorkOrder(Subject='Test Work Order', AccountId=acc.Id);
        insert workOrder;
        
        // Create a single ServiceAppointment linked to the WorkOrder and Account
        ServiceAppointment serviceAppointment = new ServiceAppointment(
            ParentRecordId=workOrder.Id,
            Sav_FSL_ISBN_Product_Text__c='ISBN123',
            Status='On Hold'
        );
        insert serviceAppointment;
        
        // Create a CSM_Project record linked to the Account
        CSM_Project__c csmProject = new CSM_Project__c(Account_Name_V2__c=acc.Id);
        insert csmProject;
    }
    
    @isTest
    static void getColorAndStatusTest() {

		Test.startTest();
        CSMAutomation_StackedBarGraphController.getColorAndStatus();
        Test.stopTest();
    }
    
    @isTest
    static void getAcct() {
        // Fetch the Account created in @testSetup
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];

        CSM_Project__c csmobjId = [Select Id, Account_Name_V2__c FROM CSM_Project__c WHERE Account_Name_V2__c =:acc.Id LIMIT 1];
        // Call the methoD
		Test.startTest();
        	CSMAutomation_StackedBarGraphController.getAccountId(csmobjId.id);
        Test.stopTest();

    }
    
    @isTest
    static void testGetServiceAppointmentData() {
        // Fetch the Account created in @testSetup
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        
        // Call the method to get Service Appointment data
        CSMAutomation_StackedBarGraphController.ServiceAppointmentGroupedData testdata = new CSMAutomation_StackedBarGraphController.ServiceAppointmentGroupedData('ISBN123','On Hold',20);
        Test.startTest();
        	CSMAutomation_StackedBarGraphController.getServiceAppointmentData(acc.id);
        Test.stopTest();
    }       
}