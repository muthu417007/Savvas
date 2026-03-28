/**
* @File Name : CSMAutomation_PDDataTableController_Test.cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : September 18, 2024
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | September 18, 2024 |   | Initial Version
**/

@isTest
public class CSMAutomation_PDDataTableController_Test {
    
    static testMethod void getMetadataColumns() {
        Test.startTest();
        CSMAutomation_PDDataTableController.getMetadataColumns();
        Test.stopTest();
    }
    static testMethod void getStatusPicklistValues() { 
        List<String> picklistValues = new List<String>();
        Test.startTest();
        picklistValues = CSMAutomation_PDDataTableController.getPicklistValues('Status');
        Test.stopTest();
    }
    static testMethod void getSARecords() {

        Account parentAccount = new Account(Name='parentAccounttest acc',billingcity = 'New York');
        insert parentAccount;

        Account acc = new Account(Name='test acc',billingcity = 'New York',ParentId = parentAccount.Id);
        insert acc;
        
        WorkOrder testWorkOrder = new WorkOrder(Subject = 'Test Work Order', AccountId = acc.Id, Sav_FSL_Order_Date__c =  System.today());
        insert testWorkOrder;
        
        ServiceAppointment testServiceAppointment = new ServiceAppointment(
            ParentRecordId = testWorkOrder.Id,
            Sav_FSL_SA_Program__c = System.Label.Sav_FSL_SA_Program_enVision_Math,
            Sav_FSL_Requested_Delivery_Date__c = Date.today(),
            SchedEndTime=system.now().addHours(6),
            SchedStartTime= system.now(),
            Service_Delivery_Address__c = 'Test Address', 
            Sav_FSL_Created_from_SSR_Form__c=TRUE,
            Sav_FSL_Customer_Time_Zone__c = 'Arizona',
            Sav_FSL_Service_Type__c='Sales - Presentation',
            Sav_FSL_Alternate_Date_Time3__c =system.now()+ 10,
            Sav_FSL_Alternate_DateTime1__c =system.now() + 11,
            Sav_FSL_Alternate_Date_Time2__c=system.now() + 12,
            Status = 'On Hold');
        insert testServiceAppointment;
        
        Test.startTest();
        CSMAutomation_PDDataTableController.getServiceAppointmentWORecords(acc.Id,'');
        acc.ParentId = null;
        update acc;
        CSMAutomation_PDDataTableController.getServiceAppointmentWORecords(acc.Id,'');
       // CSMAutomation_PDDataTableController.getServiceAppointmentWORecords(acc.Id,'');
        acc.ParentId = parentAccount.Id;
        update acc;
        Test.stopTest();   
    }
    
}