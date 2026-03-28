/*
@Author : Cognizant Team
@Name : Savvas_SSO_Selector
@CreateDate : 04-June-2024
@Description: This class is selector class for SSO
@ModifiedBy: Cognizant Team
@ModifiedDate: 04-June-2024
@Ticket Number: W-014599, W-014600
*/
public without sharing class Savvas_SSO_Selector {

    /*
    *  Method Name : getPSAListbyUserId
    *  Description : get PermissionSetAssignment list for specific user
    *  param : none
    *  return : list of PermissionSetAssignment records 
    */
    public static List<PermissionSetAssignment> getPSAListbyUserId(){
        List<PermissionSetAssignment> userPsaList = [
            SELECT PermissionSet.Name 
            FROM PermissionSetAssignment 
            WHERE AssigneeId =: UserInfo.getUserId()
        ];
        return userPsaList;
    }

    /*
    *  Method Name : getRegUrlByAppName
    *  Description : get Account Registration URL from custom metadata for specific app 
    *  param : String appName
    *  return : list of Savvas_Single_Sign_On_Metadata__mdt records
    */
    public static List<Savvas_Single_Sign_On_Metadata__mdt> getRegUrlByAppName(String appName){
        List<Savvas_Single_Sign_On_Metadata__mdt> registerAccountList =  [
            SELECT Account_Registration_URL__c  
            FROM Savvas_Single_Sign_On_Metadata__mdt 
            WHERE Label = :appName
        ];
        return registerAccountList;
    }

    /*
    *  Method Name : getAppDetailsBySequence
    *  Description : get app details from custom metadata order by sequence
    *  param : none
    *  return : list of Savvas_Single_Sign_On_Metadata__mdt records
    */
    public static List<Savvas_Single_Sign_On_Metadata__mdt> getAppDetailsBySequence(){
        List<Savvas_Single_Sign_On_Metadata__mdt> ssoMetadataList = [
                SELECT Label, App_Sequence__c, App_Icon__c, App_Title__c, App_Description__c, App_Call_to_Action_Verbiage__c, Permission_Set__c, ACS_URL__c 
                FROM Savvas_Single_Sign_On_Metadata__mdt 
                ORDER BY App_Sequence__c
            ];
        return ssoMetadataList;
    }

}