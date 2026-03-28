/*
@Author : Cognizant Team
@Name : SavvasVirtualSampleFooterCtrl
@CreateDate : 27-July-2023
@Description: This class is controller class to fetch footer details and Savvas_Footer CSS.
@ModifiedBy: Cognizant Team
@ModifiedDate: 02-Nov-2023
@Ticket Number: VS-0024
*/
public without sharing class SavvasVirtualSampleFooterCtrl {
    
    /*
    *  Method Name : getFooterData
    *  Description : getting the Savvas_VS_Community_Footer__mdt records
    *  param : None
    *  return : Metadata: Savvas_VS_Community_Footer__mdt records
    */
	@AuraEnabled(cacheable=true)
    public static List <Savvas_VS_Community_Footer__mdt> getFooterData(){
       
           	List <Savvas_VS_Community_Footer__mdt> footerDetails=new List <Savvas_VS_Community_Footer__mdt>();
       			footerDetails= SavvasVirtualSamplesCommunityHelper.fetchFooterDetails();
                return footerDetails;
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
        }catch (Exception e) {
            SavvasVirtualSampleLogsUtilty.createApplicationLogs(e,UserInfo.getUserId());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
}