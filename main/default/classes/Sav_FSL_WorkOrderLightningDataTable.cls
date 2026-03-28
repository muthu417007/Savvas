/*
Class Name : Sav_FSL_WorkOrderLightningDataTable
Purpose : 
Created by : 
Modified by/date :
Lines Modified and Purpose: 
*/
public With Sharing class Sav_FSL_WorkOrderLightningDataTable {
	public static final string SUCCESS_LABEL = System.Label.Sav_FSL_Success;
    @AuraEnabled(cacheable=true)
    public static AuraResponse getWorkOrderList(String OpportunityId) {
        list<WorkOrder> listOfWorkorders = new List<WorkOrder>();
            listOfWorkorders = [SELECT Id, Status, WorkOrderNumber, Sav_FSL_Material_Number_Title__c,Sav_FSL_Service_Type__c, Sav_FSL_SAP_Order_Quantity__c, Subject, Parent_Account__c, Priority, Sav_FSL_Sessions__c, Sav_FSL_Hours_per_Session__c, ServiceAppointmentCount, Sav_FSL_Opportunity__r.Name FROM WorkOrder WHERE Status = 'New' AND Sav_FSL_Opportunity__c =: OpportunityId AND Sav_FSL_Service_Type__c IN ('Prof Dev - Impl Essnt or PD', 'Prof Dev - Job Embedded Services', 'Prog Act - Paid')];
        if(!listOfWorkorders.isEmpty()){
            return new AuraResponse(true, SUCCESS_LABEL, listOfWorkorders);
        }else{
            return new AuraResponse(false, System.Label.Sav_FSL_No_Records, null);
        }
	}
}