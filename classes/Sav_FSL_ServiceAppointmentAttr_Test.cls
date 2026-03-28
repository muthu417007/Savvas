@isTest
public class Sav_FSL_ServiceAppointmentAttr_Test {

    static testMethod void AddAttr() {
        WorkOrder wo = new WorkOrder();
        wo.Sav_FSL_Customer_Time_Zone__c = 'Eastern';
        insert wo;
        Service_Appointment_Attributes__c attr = new Service_Appointment_Attributes__c();
        attr.Sav_FSL_Requested_Delivery_Dates__c =system.now()+ 10;
        attr.Sav_FSL_Alternate_Delivery_Dates3__c =system.now() + 11 ;
        attr.Sav_FSL_Alternate_Delivery_Dates1__c = system.now() + 12 ;
        attr.Sav_FSL_Alternate_Delivery_Dates2__c = system.now() + 13 ;
        attr.Work_Order__c = wo.Id;
        
        insert attr;
    }
}