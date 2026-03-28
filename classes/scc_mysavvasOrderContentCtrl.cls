public without sharing class scc_mysavvasOrderContentCtrl {
    /* 
*  Method Name : getContent
*  Description : getting the Side Banner content
*  param : contentId,page,pageSize,language,filterby
*  return : content
*/
    @AuraEnabled
    public static Map<String, ConnectApi.ManagedContentNodeValue> getContent(scc_mySavvasOrderCMSContent.ContentDetails contentDetails) {  
        try{
            Map<String, ConnectApi.ManagedContentNodeValue> getContents = new Map<String, ConnectApi.ManagedContentNodeValue>();
            getContents =scc_mySavvasOrderCMSContent.getContentData(contentDetails);
            return getContents;
        }
        catch (Exception e) {
            SavvasVirtualSampleLogsUtilty.createApplicationLogs(e,UserInfo.getUserId());
            throw new AuraHandledException(e.getMessage());
        }
    }

}