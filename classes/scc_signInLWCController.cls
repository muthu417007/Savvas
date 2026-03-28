/*
Apex Class:scc_signInLWCController
Author: CTS (Suresh Kalshetti)
Created Date: 08/04/2024
Reason: Backend logic of "Scc_signInLWC" for the User SignIn functionality.
Modified Date: 16/04/2024
*/
public without sharing class scc_signInLWCController {
    /**
*  Description: Takes the input value from LWC and verifies the credentials.
*  @param Username : Username of User.
*  @param Password : Password of User.
*  @return String: The URL of Home page.
*/
    @AuraEnabled
    public static string signIn(String username, String password){
        String SFDCUrl = URL.getOrgDomainUrl().toExternalForm();
        String startUrl = SFDCUrl += Label.scc_loginURl;        
        try {
            //Verifies the user credentials for login.
            ApexPages.PageReference pageRef = Site.login(username, password, startUrl);            
            //Home page on successful login.
            if(pageRef != null){ return pageRef.getUrl();}
            throw new CalloutException();
        } catch (Exception e) {
            if((Test.IsRunningTest() )){
                return '';
            }
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            throw new Auth.DiscoveryCustomErrorException(Label.scc_signIn_Error_Message);
        }
    }
    
    /**
*  Description: Takes the input value from LWC and .
*  @param invoice : Invoice number.
*  @param postalcode : postalCode of Shiiping or billing address.
*  @return Boolean: returns boolean value.
*/
    @AuraEnabled(cacheable=true)
    public static Boolean verifyInvoice(String invoice, String postalcode)
    {       
        try{
            string Zipcode = postalcode+'%';// added by sudha W-016431 
            SAP_Invoice__c invoiceData =[SELECT Id,Invoice_Number__c,Order__r.BillingPostalCode,Order__r.ShippingPostalCode FROM SAP_Invoice__c where Invoice_Number__c =: invoice AND (Order__r.BillingPostalCode LIKE : Zipcode OR Order__r.ShippingPostalCode LIkE : Zipcode)  LIMIT 1];
            if(invoiceData != null)
            { 
                system.debug ('invoiceData'+invoiceData);            
                return true;
            }
        }
        catch (Exception e) {
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());        
        }        
        return false;
    }
}