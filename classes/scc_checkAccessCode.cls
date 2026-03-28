/**************************************************************************************** 
* @Class Name  - scc_checkAccessCode
* @description - Class to check if access code provided by user is valid or not
* @Created By  - CTS-Sameer Pujari
* @Created On - 2024-05-16 
* ***************************************************************************************/ 
public without sharing class scc_checkAccessCode {
    public static String contactId='';
    public static String contactEmail='';
    public static String userType='';
    public static String userID='';
    public static List<Integration_Logs__c> accessCodeIntegrationLogs = new List<Integration_Logs__c>();
    public static String entryPoint = scc_constantHelper.ENTRY_POINT;    
    
    /********************************************************************** 
Method Name :  checkAccessCode
Description :  Method to check if access code provided by user is valid or not
Input       :   N/A
Return type :  string
***********************************************************************/ 
    
    @AuraEnabled
    public static accessCodeRespWrapper checkAccessCode(string searchAccessCode){
        httpRequest req = new HttpRequest();
        HTTPResponse res;
        String status;
        Date CashedInDate;
        Date expirationDate;
        String cashedInDatestr;
        String expirationDatestr;
        Date CurrentDate = Date.today();
        String numTimesCashedIn;
        String numCashins;
        Integer numTimesCashedInNum;
        Integer numCashinsNum;
        try{            
            List<User> usr = [SELECT ID,Email, Profile.Name, IsEmployee__c,Contact.Id, Contact.AccountID,Contact.Email,Contact.Account.SAP_Account_Id__c, contact.name, contact.Account.name FROM User WHERE Id = :UserInfo.getUserId()];            
            accessCodeRespWrapper accCodeResp = new accessCodeRespWrapper();
            if(usr[0].Profile.Name ==scc_constantHelper.SAVVAS_EXTERNAL_USERS_BASE_PROFILE){
                contactId = usr[0].Contact.Id;
                contactEmail = usr[0].Contact.Email;
                userType = scc_constantHelper.EXTERNAL_USER;
            }else if(usr[0].Profile.Name == scc_constantHelper.MY_SAVVAS_ORDERS_PROFILE){
                contactEmail = scc_constantHelper.MYSAVVASORDERS_GUEST_USER;
                userType = scc_constantHelper.GUEST_USER;
            }else{
                contactEmail = '';
                userType = scc_constantHelper.INTERNAL_USER;
                userID = usr[0].ID;
            }  
            
            List<scc_checkAccessCode__mdt> accessCodeUserNamePswd = [SELECT UserName__c, Pswd__c, Url__c from scc_checkAccessCode__mdt];
            String url = accessCodeUserNamePswd[0].Url__c;
            String username = accessCodeUserNamePswd[0].UserName__c;
            String password = accessCodeUserNamePswd[0].Pswd__c;        		
            
            req.setEndpoint(url+searchAccessCode);            
            req.setMethod('GET');
            Blob headerValue = Blob.valueOf(username + ':' + password);
            String authorizationHeader = 'BASIC ' +
                EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization', authorizationHeader);
            req.setHeader('Content-Type', 'application/JSON');
            
            Http http = new Http();
            res = http.send(req);            
            if(res.getStatusCode() == 200){                
                Dom.Document doc = new Dom.Document();
                doc.load(res.getBody());
                Dom.XmlNode root = doc.getRootElement();
                Dom.XmlNode accessCodeDetailsNode = root.getChildElement('AccessCodeDetails', null);                
                status = root.getChildElement('status', null).getText();
                if(status == 'Not found'){
                    status = scc_constantHelper.NOT_FOUND;
                    accCodeResp.status = scc_constantHelper.NOT_FOUND;
                    accCodeResp.CashedInDate = null;
                    accCodeResp.ExpirationDate = null;
                    accCodeResp.NumTimesCashedIn = null;
                    accCodeResp.NumCashins = null; 
                    return accCodeResp;
                }
                if(root.getChildElement('AccessCodeDetails', null).getChildElement('CashedInDate', null) != null
                  ){
                      cashedInDatestr = root.getChildElement('AccessCodeDetails', null).getChildElement('CashedInDate', null).getText();
                  }else{
                      cashedInDatestr ='';
                  }
                
                if(root.getChildElement('AccessCodeDetails', null).getChildElement('ExpirationDate', null) !=null
                  ){
                      expirationDatestr = root.getChildElement('AccessCodeDetails', null).getChildElement('ExpirationDate', null).getText();
                  }else{
                      expirationDatestr = '' ;
                  }
                                
                numTimesCashedIn = root.getChildElement('AccessCodeDetails', null).getChildElement('NumTimesCashedIn', null).getText();
                numCashins = root.getChildElement('AccessCodeDetails', null).getChildElement('NumCashins', null).getText();
                
                if (cashedInDatestr != null && cashedInDatestr != '') {
                    cashedInDate = Date.valueOf(cashedInDatestr.replace('Z', ''));
                }else {
                    cashedInDate = null; // Handle null case as needed
                }
                if (expirationDatestr != null && expirationDatestr != '') {
                    expirationDate = Date.valueOf(expirationDatestr.replace('Z', ''));
                }else {
                    expirationDate = null; // Handle null case as needed
                }
                
                if (numTimesCashedIn != null) {
                    numTimesCashedInNum = Integer.valueOf(numTimesCashedIn);
                }
                
                if (numCashins != null) {
                    numCashinsNum = Integer.valueOf(numCashins);
                }                
                
                if(expirationDate.format() < Date.Today().format()){                    
                    status = 'Code has EXPIRED';
                } else if (status == 'Found' && expirationDate.format() > Date.Today().format() 
                           && numCashinsNum >= 1 && numTimesCashedInNum == 0){
                               status = 'Code has NOT been activated';                               
                           }else if (status == 'Found' && CashedInDate.format() != null && expirationDate.format() > Date.Today().format()){
                               status = 'Code has been activated' + '\r\n' +'Activation Date: ' +  CashedInDate.format();
                           } else if (status == 'Not found') {
                               status = 'Code NOT found';
                           }                
                
                
                // Populate accCodeResp with data
                accCodeResp.status = status;
                accCodeResp.CashedInDate = CashedInDate;
                accCodeResp.ExpirationDate = ExpirationDate;
                accCodeResp.NumTimesCashedIn = NumTimesCashedIn;
                accCodeResp.NumCashins = NumCashins;                                
                
                if(Boolean.valueOf(Label.scc_Insert_Logs)){
                    createIntegrationLogs('Pearson Access code',searchAccessCode,res.getBody(),'Success',String.valueOf(res.getStatusCode()),contactId,contactEmail,true,userType);            
                }
            }else{
                status = scc_constantHelper.NOT_FOUND;
                accCodeResp.status = scc_constantHelper.NOT_FOUND;
                accCodeResp.CashedInDate = null;
                accCodeResp.ExpirationDate = null;
                accCodeResp.NumTimesCashedIn = null;
                accCodeResp.NumCashins = null; 
                if(Boolean.valueOf(Label.scc_Insert_Logs)){
                    createIntegrationLogs('Pearson Access code',searchAccessCode,res.getBody(),'Error',String.valueOf(res.getStatusCode()),contactId,contactEmail,true,userType);            
                }
            }           
            return accCodeResp;
        }
        catch (Exception e) 
        {               
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            if(Boolean.valueOf(Label.scc_Insert_Logs)){
                if(res !=null){
                    createIntegrationLogs('Pearson Access code',searchAccessCode,String.isBlank(res.getBody())?'NULL':res.getBody(),'Error',e.getLineNumber() + ': ' + e.getMessage(),contactId,contactEmail,true,userType);
                }else{
                    createIntegrationLogs('Pearson Access code',searchAccessCode,'','Error',e.getLineNumber() + ': ' + e.getMessage(),contactId,contactEmail,true,userType);
                }
            }
            return null;
        }
    }
    
    /**
*  Description: This method creates Integration Logs    
*  @name: createIntegrationLogs
*  @param:parameters like logType,requestBody etc.
*  @return: 
*  @throws exception- 
*/    
    
    public static void createIntegrationLogs(String logType, String requestBody, String responseBody, String status, String internalStatus, String contactId, String contactEmail,Boolean insertNow,String userType){
        Integration_Logs__c integrationLog = new Integration_Logs__c(
            Type__c = logType,
            Request_Body__c = requestBody,
            Response_Body__c = responseBody.toString().length()>1000 ? responseBody.toString().subString(0,1000) : responseBody.toString(),
            Status__c = status,
            Internal_Status__c = internalStatus,
            contact__c = String.isBlank(contactId)?NULL:contactId,
            Contact_Email__c = contactEmail,
            scc_User_Type__c = userType,
            User__c = String.isBlank(userID)?NULL:userID,
            Entry_Point__c = entryPoint
        );
        
        accessCodeIntegrationLogs.add(integrationLog);
        
        if(insertNow == true){
            scc_IntegrationLogs_Helper.createSFCCIntegrationLogs(JSON.serialize(accessCodeIntegrationLogs));
        }
    }
    
    public class accessCodeRespWrapper {
        @AuraEnabled public String status;
        @AuraEnabled public Date CashedInDate;
        @AuraEnabled public Date ExpirationDate;
        @AuraEnabled public Date CurrentDate = Date.today();
        @AuraEnabled public String NumTimesCashedIn;
        @AuraEnabled public String NumCashins;
    }
}