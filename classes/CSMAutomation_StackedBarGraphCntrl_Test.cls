@isTest
public class CSMAutomation_StackedBarGraphCntrl_Test {
    
     static testMethod void getMetadataColors() {
        Test.startTest();
        CSMAutomation_StackedBarGraphController.getColorAndStatus();
        Test.stopTest();
     }
    
     static testMethod void getAcc() {
        Account acc = new Account(Name='test acc',billingcity = 'New York');
        insert acc;
        CSM_Project__c csm = new CSM_Project__c();
        csm.Account_Name_V2__c = acc.id;
        insert csm;
        Test.startTest();
        CSMAutomation_StackedBarGraphController.getCSMRecord(csm.id);
        Test.stopTest();
    }
    
   static testMethod void getSA() {
        Account acc = new Account(Name='test acc',billingcity = 'New York');
        insert acc;
        WorkOrder testWorkOrder = new WorkOrder(Subject = 'Test Work Order', AccountId = acc.Id, Sav_FSL_Order_Date__c =  System.today());
        insert testWorkOrder;
        Opportunity opp = new Opportunity(Name = 'test Opportunity', AccountId = acc.Id, 
                                          StageName = 'Prospect', CloseDate = Date.today(), CurrencyIsoCode = 'USD');
        insert opp;
                
        List<ServiceAppointment> testServiceAppointmentList = new List<ServiceAppointment>();       
       // insert testServiceAppointment;
       
       for(integer i=0; i<10; i++){
            ServiceAppointment testServiceAppointment = new ServiceAppointment(
            ParentRecordId = testWorkOrder.Id,
            Opportunity__c = opp.Id,
            Sav_FSL_SA_Program__c = System.Label.Sav_FSL_SA_Program_enVision_Math,
            Sav_FSL_Requested_Delivery_Date__c = Date.today()+i,
            SchedEndTime=system.now().addHours(6),
            SchedStartTime= system.now(),
            Service_Delivery_Address__c = 'Test Address', 
            Sav_FSL_Created_from_SSR_Form__c=TRUE,
            Sav_FSL_Customer_Time_Zone__c = 'Arizona',
            Sav_FSL_Service_Type__c='Sales - Presentation',
            Sav_FSL_Alternate_Date_Time3__c =system.now()+ 10,
            Sav_FSL_Alternate_DateTime1__c =system.now() + 11,
            Sav_FSL_Alternate_Date_Time2__c=system.now() + 12,
            Sav_FSL_ISBN_Product_Text__c = 'test'+ i,
            Status = 'On Hold');
           testServiceAppointmentList.add(testServiceAppointment);
       }
       if(testServiceAppointmentList!=null){
           Insert testServiceAppointmentList;
           List<ServiceAppointment> testServiceAppointmentListInsert = [Select Id, AccountId From ServiceAppointment
                                                                       where AccountId=:acc.Id];
       }
        Test.startTest();
        List<CSMAutomation_StackedBarGraphController.ServiceAppointmentGroupedData> data = CSMAutomation_StackedBarGraphController.getServiceAppointmentData(acc.id);
        CSMAutomation_StackedBarGraphController.ServiceAppointmentGroupedData testdata = new CSMAutomation_StackedBarGraphController.ServiceAppointmentGroupedData('test','On Hold',10);
        Test.stopTest();   
    }
    
    static testMethod void getChildAccountsTest() {
   
        Account parentAcc = new Account(Name = 'Parent Account', BillingCity = 'New York');
        insert parentAcc;

        Account childAcc1 = new Account(Name = 'Child Account 1', BillingCity = 'Los Angeles', ParentId = parentAcc.Id);
        Account childAcc2 = new Account(Name = 'Child Account 2', BillingCity = 'Chicago', ParentId = parentAcc.Id);
        insert new List<Account>{childAcc1, childAcc2};

        Test.startTest();
        List<Account> childAccounts = CSMAutomation_StackedBarGraphController.getChildAccounts(parentAcc.Id);
        Test.stopTest();

        System.assertNotEquals(null, childAccounts, 'Child accounts should not be null');
        System.assertEquals(2, childAccounts.size(), 'There should be exactly 2 child accounts');

        Set<Id> childAccountIds = new Set<Id>();
        for (Account acc : childAccounts) {
            childAccountIds.add(acc.Id);
        }
        System.assert(childAccountIds.contains(childAcc1.Id), 'Child Account 1 should be in the result');
        System.assert(childAccountIds.contains(childAcc2.Id), 'Child Account 2 should be in the result');
    }
}