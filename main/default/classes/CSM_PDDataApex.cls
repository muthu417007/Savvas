public with sharing class CSM_PDDataApex {

    @AuraEnabled(cacheable=true)
    public static List<CSM_Automation_Metadata__mdt> getMetadataColumns(){
        return [SELECT Field_Name__c,Label__c,Order__c,Type__c FROM CSM_Automation_Metadata__mdt ORDER BY Order__c];
    }
    @AuraEnabled(cacheable=true)
    public static List<PicklistSet> getPicklistValues1(String fieldName) {
        system.debug('getPicklistValues<><> '+fieldName);
        String objectName = 'ServiceAppointment';
            Schema.SObjectType objectType =   getSObjectTypeFromObjectName(objectName);
    Schema.DescribeSObjectResult result =   objectType.getDescribe();
    Map<String, Schema.SObjectField> fields = result.fields.getMap();
    Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    List<PicklistSet> picklistValues = new List<PicklistSet>();
    for (Schema.PicklistEntry picklistVal : ple) {
        PicklistSet tempPicklist = new PicklistSet(picklistVal.getLabel(), picklistVal.getValue());
            picklistValues.add(tempPicklist);
    }
    system.debug('picklistValues<><> '+picklistValues);
        return picklistValues;

    }
    @AuraEnabled(cacheable=true)
    public static List<String> getPicklistValues(String fieldName) {
        // Logic to fetch picklist values for the given fieldName
        List<Schema.PicklistEntry> picklistValues = Schema.SObjectType.ServiceAppointment.fields.getMap().get(fieldName).getDescribe().getPicklistValues();
        List<String> values = new List<String>();
        for (Schema.PicklistEntry entry : picklistValues) {
            values.add(entry.getLabel());
        }
        system.debug('values<><> '+values);
        return values;
    }

     public static SObjectType getSObjectTypeFromObjectName(String objectName) {
       return ((SObject) Type.forName('Schema', objectName).newInstance()).getSObjectType();
    }
    public class PicklistSet {
        @AuraEnabled public String label { get; set; }
        @AuraEnabled public String value { get; set; }

        public PicklistSet(String label, String value){
            this.label = label;
            this.value = value;
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<ServiceAppointmentWOWrapper> getServiceAppointmentWORecords(){
        List<ServiceAppointmentWOWrapper> combinedRecords = new List<ServiceAppointmentWOWrapper>();
        List<ServiceAppointment> lstAppointments = [Select Id,ParentRecordId,ParentRecord.Name,AccountId,Sav_FSL_Service_Type__c,Sav_FSL_SA_Program__c,Sav_FSL_ISBN_Product_Text__c,Sav_FSL_Appointment_Number__c,SchedStartTime,Status from ServiceAppointment where AccountId='0015300000U1s4IAAR'];
        Set<Id> appointmentID = new Set<Id>();
        Set<Id> workOrderId = new Set<Id>();
        Map<Id,String> woPurchaseOrder = new Map<Id,String>();
        Map<Id,DateTime> woExpiration_Date = new Map<Id,DateTime>();
        Map<Id,String> assignedResourceMap = new Map<Id,String>();
        for(ServiceAppointment sa:lstAppointments){
            workOrderId.add(sa.ParentRecordId);
            appointmentID.add(sa.Id);
        }
        if(appointmentID!=null && !appointmentID.isEmpty()){
            List<AssignedResource> lstAR = [Select id,ServiceAppointmentId,ServiceResource.Name from AssignedResource where ServiceAppointmentId=:appointmentID];
            if(lstAR.size() > 0 && !lstAR.isEmpty()){
                for(AssignedResource asr:lstAR){
                    assignedResourceMap.put(asr.ServiceAppointmentId, asr.ServiceResource.Name);
                }
            }
        }
        if(workOrderId!=null && !workOrderId.isEmpty()){
            List<WorkOrder> lstWO = [Select Id,WorkOrderNumber,Sav_FSL_Program__c,Sav_FSL_Product__r.Name,Sav_FSL_Expiration_Date__c,Sav_FSL_Service_Type__c,Sav_FSL_Purchase_Order__c from WorkOrder where id=:workOrderId];
            for(WorkOrder wo:lstWO){
                woPurchaseOrder.put(wo.id,wo.Sav_FSL_Purchase_Order__c);
                woExpiration_Date.put(wo.id,wo.Sav_FSL_Expiration_Date__c);
            }
            
        }
        for(ServiceAppointment sa:lstAppointments){
           ServiceAppointmentWOWrapper wrapper = new ServiceAppointmentWOWrapper();
            wrapper.Program = sa.Sav_FSL_SA_Program__c;
            wrapper.ISBNProduct = sa.Sav_FSL_ISBN_Product_Text__c;
            wrapper.AppointmentNumber = sa.Sav_FSL_Appointment_Number__c;
            wrapper.Status = sa.Status;
            if(sa.SchedStartTime!=null){
                wrapper.ScheduleDate = sa.SchedStartTime;
            }
            else{
                wrapper.ScheduleDate = null;
            }
            if(woExpiration_Date!=null && woExpiration_Date.get(sa.ParentRecordId)!=null){
                wrapper.ExpirationDate = woExpiration_Date.get(sa.ParentRecordId).date();
            }
            else{
                wrapper.ExpirationDate = null;
            }
            
            if(assignedResourceMap !=null && assignedResourceMap.containskey(sa.Id) && assignedResourceMap.get(sa.Id)!=null){
                wrapper.ServiceResource = assignedResourceMap.get(sa.Id);
            }
            else{
                wrapper.ServiceResource = null;
            }
            
            wrapper.ServiceType = sa.Sav_FSL_Service_Type__c;
            wrapper.CustomerPO = woPurchaseOrder.get(sa.ParentRecordId);
            combinedRecords.add(wrapper);  
        }
        system.debug('combinedRecords<> '+combinedRecords);
        return combinedRecords;
        
    }
    public class ServiceAppointmentWOWrapper {
        @AuraEnabled
        public String Program {get; set;}
        @AuraEnabled
        public String ISBNProduct {get; set;}
        @AuraEnabled
        public String AppointmentNumber {get; set;}
        @AuraEnabled
        public String Status {get; set;}
        @AuraEnabled
        public DateTime ScheduleDate {get; set;}
        @AuraEnabled
        public Date ExpirationDate {get; set;}
        @AuraEnabled
        public String ServiceResource {get; set;}
        @AuraEnabled
        public String ServiceType {get; set;}
        @AuraEnabled
        public String CustomerPO {get; set;}
        
       /* public ServiceAppointmentWOWrapper(String Program,String ISBNProduct, String AppointmentNumber,date ExpirationDate,String ServiceResource,String ServiceType,String CustomerPO){
            this.Program = Program;
            this.ISBNProduct = ISBNProduct;
            this.AppointmentNumber = AppointmentNumber;
            this.ExpirationDate = ExpirationDate;
            this.Program = ServiceResource;
            this.Program = ServiceType;
            this.Program = CustomerPO;
        }*/
            
            
            
            
        }
        
    }