/*
@Author : Cognizant Team
@Name : SavvasVirtualSampleAssetTrackingCtrl
@CreateDate : 13-Sep-2023
@Description: This class is to call the flow on asset clicks
@ModifiedBy: Cognizant Team
@ModifiedDate: 02-Nov-2023
@Ticket Number: VS-0037
*/
public with sharing class SavvasVirtualSampleAssetTrackingCtrl {
    /*
    *  Method Name : invokeAssetTrackingFlow
    *  Description : calling the flow based on Asset Clicks
    *  param : sampleAssetName, sampleAssetSitecoreId & virtualsampleProgramName
    *  return : None
    */
    @AuraEnabled
    public static void invokeAssetTrackingFlow(SavvasVirtualSamplesCommunityHelper.FlowDetails flowDetails){
        try{   
            SavvasVirtualSamplesCommunityHelper.callFlow(flowDetails);
        }catch(Exception e) {
            SavvasVirtualSampleLogsUtilty.createApplicationLogs(e,UserInfo.getUserId());
            throw new AuraHandledException(e.getMessage());
        }
    }
        
}