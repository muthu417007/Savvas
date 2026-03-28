/*
@Author : Cognizant Team
@Name : Savvas_SSO_LoginPageController
@CreateDate : 16-Apr-2024
@Description: This class is controller class for SSO Login Page 
@ModifiedBy: Cognizant Team
@ModifiedDate: 31-May-2024
@Ticket Number: W-014600
*/
public with sharing class Savvas_SSO_LoginPageController {

        /*
        *  Method Name : fetchRegistrationDetails
        *  Description : fetch Account Registration URL from custom metadata
        *  param : string appName
        *  return : string
        */
        @AuraEnabled(cacheable=true)
        public static String fetchRegistrationDetails(String appName){
            try {
                List<Savvas_Single_Sign_On_Metadata__mdt> registerAccountList =  Savvas_SSO_Selector.getRegUrlByAppName(appName);
                String redirectURL = registerAccountList[0].Account_Registration_URL__c;
                return redirectURL;
            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        }
}