/*
@Author : Cognizant Team
@Name : SavvasVirtualSamplesProgramBannerCtrl
@CreateDate : 04-Aug-2023
@Description: This class is controller class to fetch program banner css
@ModifiedBy: Cognizant Team
@ModifiedDate: 02-Nov-2023
@Ticket Number: VS-0029
*/
public without sharing class SavvasVirtualSamplesProgramBannerCtrl{

    /*
    *  Method Name : fetchCssFileFromAttachment
    *  Description : getting the css file for program banner
    *  param : title
    *  return : Css Content
    */
    @AuraEnabled(cacheable=true)
    public static string fetchCssFileFromAttachment(String title){
        try{
            return SavvasVirtualSamplesCommunityHelper.fetchCssFileFromAttachment(title);
        } catch (Exception e) {
            SavvasVirtualSampleLogsUtilty.createApplicationLogs(e,UserInfo.getUserId());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
}