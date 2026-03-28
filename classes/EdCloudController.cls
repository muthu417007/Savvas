public class EdCloudController {
    
    Id accountId;
    public Ed_Cloud__c objEdCloud{get; set;}
    
    public EdCloudController(ApexPages.StandardController sc) {
        accountId = sc.getId();
        objEdCloud = new Ed_Cloud__c();
        
        List<Ed_Cloud__c> lstEdCloud = [
            SELECT Id, of_Errors_within_last_export__c, of_Warning_within_last_export__c, District_Edcloud_ID__c,
            District_Name_in_Edcloud_Tenant__c, District_Student_Information_System__c, EasyBridge_Integration_Status__c,
            Edcloud_Last_Successful_Import_Date_Time__c, Integration_Types__c, Is_Customer_Integration_Live_Is_API_On__c,
            Is_School_in_Deleted_State__c, Last_Ingestion_Import_Date__c, Matched_Easybridge_District_Rumba_ID__c,
            Matched_Easybridge_School_Rumba_ID__c, Setup_Has_Teacher_Matching_Started__c, Setup_Is_Rumba_Pi_Domain_Complete__c,
            Setup_Rumba_District_Matched__c, Setup_Rumba_School_Matched__c, Setup_Teacher_Matching_Complete__c,
            SIS_Administrator_Email_Address__c
            FROM Ed_Cloud__c 
            WHERE Account__c = :accountId order by CreatedDate desc limit 1];
        
        if(lstEdCloud != null && !lstEdCloud.isEmpty()) {
            objEdCloud = lstEdCloud[0];
        }
    }
}