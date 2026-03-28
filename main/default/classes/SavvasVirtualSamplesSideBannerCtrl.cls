/*
@Author : Cognizant Team
@Name : SavvasVirtualSamplesSideBannerCtrl
@CreateDate : 02-Aug-2023
@Description: This is controller class to fetch Side Banner
@ModifiedBy: Cognizant Team
@ModifiedDate: 02-Nov-2023
@Ticket Number: VS-0025
*/
public without sharing class SavvasVirtualSamplesSideBannerCtrl{
    /*
*  Method Name : getContent
*  Description : getting the Side Banner content
*  param : contentId,page,pageSize,language,filterby
*  return : content
*/
    @AuraEnabled(cacheable=true)
    public static Map<String, ConnectApi.ManagedContentNodeValue> getContent(SavvasVirtualSamplesCommunityHelper.ContentDetails contentDetails) {  
        try{
            Map<String, ConnectApi.ManagedContentNodeValue> getContents = new Map<String, ConnectApi.ManagedContentNodeValue>();
            getContents =SavvasVirtualSamplesCommunityHelper.getContent(contentDetails);
            return getContents;
        }
        catch (Exception e) {
            SavvasVirtualSampleLogsUtilty.createApplicationLogs(e,UserInfo.getUserId());
            throw new AuraHandledException(e.getMessage());
        }
    }
    /*
*  Method Name : fetchCssFileFromAttachment
*  Description : getting the css file from attachment
*  param : title
*  return : css content
*/
    @AuraEnabled(cacheable=true)
    public static string fetchCssFileFromAttachment(String title){
        try{
            return SavvasVirtualSamplesCommunityHelper.fetchCssFileFromAttachment(title);
        }
        catch (Exception e) {
            SavvasVirtualSampleLogsUtilty.createApplicationLogs(e,UserInfo.getUserId());
            throw new AuraHandledException(e.getMessage());
        }
    }    
}