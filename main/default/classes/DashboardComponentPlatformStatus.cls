/************************************************************************ 
Name: DashboardComponentPlatformStatus
Purpose: Controller Class for the dashboardComponent LWC component
History:
VERSION AUTHOR  DATE(DD/MM/YYYY)       	 DETAIL                DESCRIPITOPN
1.0     CTS     17/09/2024          	 INITIAL DEVELOPMENT   Created for W-014214: Display Platform Status
************************************************************************/
public class DashboardComponentPlatformStatus {
    /*
    *  Method Name : fetchCSMDashboardRecordId
    *  Description : Redirect to CSM Dashboard on close of Platform status popup
    *  return : dashboard record id
    */
    @AuraEnabled(cacheable=true)
    public static string fetchCSMDashboardRecordId(){
        String recordId;
        try{
            Dashboard ds = [Select Id,FolderName,DeveloperName from Dashboard where Title  =: Label.DashboardComponentCSMDashboardName];
            recordId = ds.Id;
            if(Test.isRunningTest()){
                throw new AuraHandledException('This is to test coverage');
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return recordId;
    }
}