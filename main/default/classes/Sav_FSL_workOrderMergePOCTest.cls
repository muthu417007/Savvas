@isTest
private class Sav_FSL_workOrderMergePOCTest {
    @isTest
    static void testMergeWorkOrders() {
        // test data Account
        Account testAccount = new Account(Name = 'Test Account', BillingCity = 'Arizona');
        insert testAccount;

        WorkOrder masterWorkOrder = new WorkOrder();
        masterWorkOrder.AccountId = testAccount.Id;
        masterWorkOrder.Sav_FSL_Sessions__c=1;
        masterWorkOrder.Status = 'New';
        insert masterWorkOrder;

        WorkOrder mergeWorkOrder = new WorkOrder();
        mergeWorkOrder.AccountId = testAccount.Id;
        mergeWorkOrder.Sav_FSL_Sessions__c=1;
        mergeWorkOrder.Status = 'On Hold';
        insert mergeWorkOrder;

        Service_Appointment_Attributes__c saa = new Service_Appointment_Attributes__c(Work_Order__c = mergeWorkOrder.Id);
        insert saa;

        ServiceAppointment sa = new ServiceAppointment();
        sa.ParentRecordId = mergeWorkOrder.Id;
        insert sa;

        // Call the mergeWorkOrders method
        List<List<WorkOrder>> selectedWorkOrder = new List<List<WorkOrder>>();
        List<WorkOrder> workOrderList = new List<WorkOrder>();
        workOrderList.add(masterWorkOrder);
        workOrderList.add(mergeWorkOrder);
        selectedWorkOrder.add(workOrderList);
        Test.startTest();
        Sav_FSL_workOrderMergePOC.mergeWorkOrders(selectedWorkOrder);
        Test.stopTest();

        // Verify the results
        masterWorkOrder = [SELECT Id, Status FROM WorkOrder WHERE Id = :masterWorkOrder.Id];
        saa = [SELECT Id, Work_Order__c FROM Service_Appointment_Attributes__c WHERE Id = :saa.Id];
       

        System.assertEquals('New', masterWorkOrder.Status, 'Master work order should have status "New"');       
        System.assertEquals(masterWorkOrder.Id, saa.Work_Order__c, 'SAA should be updated with the master work order');
       
    }
}