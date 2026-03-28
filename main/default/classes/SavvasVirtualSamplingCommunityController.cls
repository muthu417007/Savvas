/*
@Author : Cognizant Team
@Name : SavvasVirtualSamplingCommunityController
@CreateDate : 24-July-2023
@Description: This class is controller class for Virtual Sampling Community
@ModifiedBy: Cognizant Team
@ModifiedDate: 02-Nov-2023
@Ticket Number: VS-0012, VS-0013
*/
public with sharing class SavvasVirtualSamplingCommunityController {
    /*
*  Method Name : getProgramDetails
*  Description : getting the Program details for Virtual Sampling Community
*  param : None
*  return : Program Content
*/
    @AuraEnabled
    public Static SavvasVirtualSamplingCommunityHelper.ProgramContainer getProgramDetails(){
        try{
            SavvasVirtualSamplingCommunityHelper.ProgramContainer programContainer = SavvasVirtualSamplingCommunityHelper.getProgramDetails();
            return programContainer;
        }catch (Exception e) {
            System.debug('ex---> '+e.getMessage());
            SavvasVirtualSampleLogsUtilty.createApplicationLogs(e,UserInfo.getUserId());
            throw new AuraHandledException(e.getMessage());
        }
    }
}