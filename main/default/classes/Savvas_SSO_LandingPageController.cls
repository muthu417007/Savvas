/*
    @Author : Cognizant Team
    @Name : Savvas_SSO_LandingPageController
    @CreateDate : 30-May-2024
    @Description: This class is handler for Landing Page LWC.
    @ModifiedBy: Cognizant Team
    @ModifiedDate: 04-June-2024
    @Ticket Number: W-014599
*/
public with sharing class Savvas_SSO_LandingPageController {
    public class MetadataWrapper {
        // Wrapper Variables
        @AuraEnabled public String label{get; set;}
        @AuraEnabled public Decimal appSequence{get; set;}
        @AuraEnabled public String appIcon{get; set;}
        @AuraEnabled public String appTitle{get; set;}
        @AuraEnabled public String appDescription{get; set;}
        @AuraEnabled public String appActionVerbiage{get; set;}
        @AuraEnabled public String acsURL{get; set;}
        // Wrapper Constructor
        public MetadataWrapper(String label, Decimal appSequence, String appIcon, String appTitle, String appDescription, String appActionVerbiage, String acsURL){
            this.label = label;
            this.appSequence = appSequence;
            this.appIcon = appIcon;
            this.appTitle = appTitle;
            this.appDescription = appDescription;
            this.appActionVerbiage = appActionVerbiage;
            this.acsURL = acsURL;
        }
    }   
    /*
    *  Method Name : getUserAppAccessData
    *  Description : Method to fetch permission set access details for user
    *  param : NA
    *  return : List<MetadataWrapper>
    */
    @AuraEnabled
    public static List<MetadataWrapper> getUserAppAccessData(){
        try{
            List<MetadataWrapper> mwList = new List<MetadataWrapper>();
            List<PermissionSetAssignment> userPsaList = Savvas_SSO_Selector.getPSAListbyUserId();
            Set<String> psSet = new Set<String>();
            if(userPsaList!=null && userPsaList.size()>0){
                for(PermissionSetAssignment psa : userPsaList){
                    psSet.add(psa.PermissionSet.Name);
                }
            }
            List<Savvas_Single_Sign_On_Metadata__mdt> ssoMetadataList = Savvas_SSO_Selector.getAppDetailsBySequence();
            if(ssoMetadataList!=null && ssoMetadataList.size()>0){
                for(Savvas_Single_Sign_On_Metadata__mdt mdt : ssoMetadataList){
                    if(psSet.contains(mdt.Permission_Set__c)){
                        MetadataWrapper mw = new MetadataWrapper(mdt.Label, mdt.App_Sequence__c, mdt.App_Icon__c, mdt.App_Title__c, mdt.App_Description__c, mdt.App_Call_to_Action_Verbiage__c, mdt.ACS_URL__c);
                        mwList.add(mw);
                    }
                }
            }
            return mwList;            
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
}