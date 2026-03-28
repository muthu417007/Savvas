@isTest
private class clsKimble_Process_Scheduling_test{
 static testMethod void validateDates() {
     List<string> dateParams = new List<string>();
     dateParams.add(String.ValueOf(Date.Today()) +',7:00 AM,8:00 AM,Dev Test');
     clsKimble_Process_Scheduling.validateDates(dateParams );
 }
 static testMethod void testtrg_SetTimeTrigger() {
     Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Kimble_Scheduling_Request__c; 
     Map<String,Schema.RecordTypeInfo> KSR = cfrSchema.getRecordTypeInfosByName(); 
     Id rtId = KSR.get('Non Opportunity Request').getRecordTypeId();

     Kimble_Scheduling_Request__c obj= new Kimble_Scheduling_Request__c();
     obj.Delivery_Date__c=Date.Today();
     obj.Start__c='8:00 AM';
     obj.End__c='8:00 PM';
     obj.Non_Opps_Service_Type__c='Sales - District Presentation';
     obj.RecordTypeId=rtId ;
     try{
        insert obj; 
     } catch(exception ex){}
 }
}