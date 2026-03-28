/**************************************************************************************** 
* @Class Name  - scc_addItemsToCartController
* @description - class to get payment related token's
* @Created By  - CTS-Dhiyaneshwari Karthikeyan
* @Created On - 2024-06-11
* ***************************************************************************************/ 
public with sharing class scc_XiPayIntegration {
    
    public static String contactId;
    public static String contactEmail;
    public static String userType;
    public static List<Integration_Logs__c> paymetricIntegrationLog = new List<Integration_Logs__c>();
    public static String entryPoint ='';
    /********************************************************************** 
    Method Name :  sendPreAuthorizationRequest
    Description :  Method to perform update external site user checkout address
    Input       :  Map<String, Map<String, String>> cardDetails
    Return type :  Map<String, String>
    ***********************************************************************/ 
    @AuraEnabled   
    public static Map<String, String> sendPreAuthorizationRequest(Map<String, Map<String, String>> cardDetails) {
        Map<String, String> responseData = new Map<String, String>();
        Decimal amount = 0.00;
        String requestBody;
        HttpResponse res;
        try {
            entryPoint ='scc_PaymetricIntegrationController.getCreditCardToken/scc_XiPayIntegration.sendPreAuthorizationRequest';
            List<User> usr = [SELECT ID,Email, Profile.Name, IsEmployee__c,Contact.Id, Contact.AccountID,Contact.Email,Contact.Account.SAP_Account_Id__c, contact.name, contact.Account.name FROM User WHERE Id = :UserInfo.getUserId()];
            
            if(usr[0].Profile.Name =='Savvas External Users Base Profile'){
                contactId = usr[0].Contact.Id;
                contactEmail = usr[0].Contact.Email;
                userType = 'External User';
            }else if(usr[0].Profile.Name =='MySavvasOrders Profile'){
                contactEmail = 'MySavvasOrders Guest User';
                userType = 'Guest User';
            }else{
                contactEmail = usr[0].Email;
                userType = 'Internal User';
            }
            
            Map<String, String> tokenResponse = cardDetails.get('tokenResponse');
            system.debug('tokenResponse'+tokenResponse);
            String expDate = '';
            String expYear = tokenResponse.get('expYear');
            expYear = (expYear.length() == 4 ? expYear.right(2) : expYear);
            expDate = tokenResponse.get('expMonth')+'/'+expYear;
            tokenResponse.put('expDate',expDate);
            List<String> name = (tokenResponse.get('cardHolderName')).split(' ');
            String firstName = name[0];
            String lastName = (name.size() == 2 ? name[1] : '');
            Map<String, String> addressDetails = cardDetails.get('addressDetails');
            system.debug('addressDetails'+addressDetails);
            String merchantId = 'SAVVAS_LC_'+addressDetails.get('currencyCode');
            scc_Integration_Setting__mdt metadata = [SELECT scc_Method_Type__c, scc_Endpoint_URL__c, scc_Shared_Key__c, scc_Merchant_Guid__c FROM scc_Integration_Setting__mdt where Label = 'PreAuth API'];
    		String cardType = tokenResponse.get('cardType');
            if(cardType == 'AX' || cardType == 'DI'){
                amount = 1.00;
            }
            HttpRequest req = new HttpRequest();
            req.setEndpoint(metadata.scc_Endpoint_URL__c);
            req.setMethod(metadata.scc_Method_Type__c);
            
            req.setHeader('Content-Type', 'text/xml');
            req.setHeader('SOAPAction', '\"Paymetric/XiPaySoap30/action/XiGGE.SoapOp\"');
            
            requestBody = '<soapenv:Envelope xmlns:ns1="http://Paymetric/XiPaySoap30/message/" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">' +
                '<soapenv:Header>' +
                    '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">' +
                        '<wsse:UsernameToken>' +
                            '<wsse:Username>'+metadata.scc_Merchant_Guid__c+'</wsse:Username>' +
                            '<wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">'+metadata.scc_Shared_Key__c+'</wsse:Password>' +
                        '</wsse:UsernameToken>' +
                    '</wsse:Security>' +
                '</soapenv:Header>' +
                '<soapenv:Body>' +
                    '<ns1:SoapOp>' +
                        '<ns1:pPacketsIn>' +
                            '<ns1:count>1</ns1:count>' +
                            '<ns1:xipayvbresult>false</ns1:xipayvbresult>' +
                            '<ns1:packets>' +
                                '<ns1:ITransactionHeader>' +
                                    '<ns1:MerchantID>'+merchantId+'</ns1:MerchantID>' +
                                    '<ns1:Amount>'+amount+'</ns1:Amount>' +  // $0 for Visa/MasterCard and $1 for American Express
                                    '<ns1:CurrencyKey>'+addressDetails.get('currencyCode')+'</ns1:CurrencyKey>' +
                                    '<ns1:CardDataSource>E</ns1:CardDataSource>' +
                                    '<ns1:CardHolderAddress1>'+addressDetails.get('cardStreet')+'</ns1:CardHolderAddress1>' +
                                    '<ns1:CardHolderCity>'+addressDetails.get('cardCity')+'</ns1:CardHolderCity>' +
                                    '<ns1:CardHolderCountry>'+addressDetails.get('cardCountry')+'</ns1:CardHolderCountry>' +
                                    '<ns1:CardHolderName>'+tokenResponse.get('cardHolderName')+'</ns1:CardHolderName>' +
                                    '<ns1:CardHolderName1>'+firstName+'</ns1:CardHolderName1>' +
                                    '<ns1:CardHolderName2>'+lastName+'</ns1:CardHolderName2>' +
                                    '<ns1:CardHolderState>'+addressDetails.get('cardState')+'</ns1:CardHolderState>' +
                                    '<ns1:CardHolderZip>'+addressDetails.get('cardZip')+'</ns1:CardHolderZip>' +
                                    '<ns1:CardExpirationDate>'+tokenResponse.get('expDate')+'</ns1:CardExpirationDate>' +
                                    '<ns1:CardType>'+tokenResponse.get('cardType')+'</ns1:CardType>' +
                                    '<ns1:CardNumber>'+tokenResponse.get('tokenizedCardNumber')+'</ns1:CardNumber>' +  // Credit card token
                                    '<ns1:CardCVV2>'+tokenResponse.get('securityCode')+'</ns1:CardCVV2>' +
                                    '<ns1:PONumber></ns1:PONumber>' +
                                    '<ns1:SalesDocNumber></ns1:SalesDocNumber>' +
                                    '<ns1:PacketOperation>1</ns1:PacketOperation>' +
                                    '<ns1:InfoItems>' +
                                        '<ns1:InfoItem>' +
                                            '<ns1:Key>TR_TRANS_TYPE</ns1:Key>' +  // Ecommerce indicator required for all ecomm originated transactions
                                            '<ns1:Value>7</ns1:Value>' +  // Ecomm indicator value will be always 7
                                        '</ns1:InfoItem>' +
                                    '</ns1:InfoItems>' +
                                '</ns1:ITransactionHeader>' +
                            '</ns1:packets>' +
                        '</ns1:pPacketsIn>' +
                    '</ns1:SoapOp>' +
                '</soapenv:Body>' +
            '</soapenv:Envelope>';
            
            req.setBody(requestBody);
            system.debug('sendPreAuthorizationRequest set request :'+req);
            
            Http http = new Http();
            res = http.send(req);
            
            if(res.getStatusCode() == 200) {
                System.debug('sendPreAuthorizationRequest Response: ' + res.getBody());
                responseData = parseXML(res.getBody());
            } else {
                throw new CalloutException('Error:'+res.getBody());
            }
            if(Boolean.valueOf(Label.scc_Insert_Logs)){
            	createIntegrationLogs('Paymetric PreAuth',requestBody,res.getBody(),'Success',String.valueOf(res.getStatusCode()),contactId,contactEmail,true,userType);                                        
            }
            return responseData;
         } catch (Exception e) {
            System.debug('Error in preauth: ' + e.getMessage());
             if(Boolean.valueOf(Label.scc_Insert_Logs)){
                 if(res !=null){
                    createIntegrationLogs('Paymetric PreAuth',requestBody,String.isBlank(res.getBody())?'NULL':res.getBody(),'Error',e.getLineNumber() + ': ' + e.getMessage(),contactId,contactEmail,true,userType);                            
                 }else{
                    createIntegrationLogs('Paymetric PreAuth',requestBody,'','Error',e.getLineNumber() + ': ' + e.getMessage(),contactId,contactEmail,true,userType);                            
                 }
             }
			return null;            
        }
    }
    
    public static Map<String, String> parseXML(String xmlString) {
        Map<String, String> responseData = new Map<String, String>();
        try {
            Dom.Document doc = new Dom.Document();
            doc.load(xmlString);            
            Dom.XmlNode root = doc.getRootElement();
            // Navigate to the required nodes
            Dom.XmlNode bodyNode = root.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
            System.debug('**bodyNode: ' + bodyNode);
            Dom.XmlNode soapOpResponseNode = bodyNode.getChildElement('SoapOpResponse', 'http://Paymetric/XiPaySoap30/message/');
            System.debug('**soapOpResponseNode: ' + soapOpResponseNode);
            Dom.XmlNode soapOpResultNode = soapOpResponseNode.getChildElement('SoapOpResult', 'http://Paymetric/XiPaySoap30/message/');
            System.debug('**soapOpResultNode: ' + soapOpResultNode);
            Dom.XmlNode packetsNode = soapOpResultNode.getChildElement('packets', 'http://Paymetric/XiPaySoap30/message/');
            System.debug('**packetsNode: ' + packetsNode);
            Dom.XmlNode iTransactionHeaderNode = packetsNode.getChildElement('ITransactionHeader', 'http://Paymetric/XiPaySoap30/message/');
            System.debug('**iTransactionHeaderNode: ' + iTransactionHeaderNode);
            
            // Extract values
            String statusCode = iTransactionHeaderNode.getChildElement('StatusCode', 'http://Paymetric/XiPaySoap30/message/').getText();
            System.debug('StatusCode: ' + statusCode);
            if(statusCode == '100'){
                String avsCode = iTransactionHeaderNode.getChildElement('AVSCode', 'http://Paymetric/XiPaySoap30/message/').getText();
                System.debug('AVSCode: ' + avsCode);
                scc_Payment_Response__mdt avsResponse = [SELECT Id, Label, scc_Validation_type__c, scc_Valid_Response__c, scc_Error_Message__c FROM scc_Payment_Response__mdt where scc_Validation_type__c = 'AVS' and Label =: avsCode LIMIT 1];
                if(avsResponse.scc_Valid_Response__c){
                    String trCardCidRespCode = '';
                    Dom.XmlNode infoItemsNode = iTransactionHeaderNode.getChildElement('InfoItems', 'http://Paymetric/XiPaySoap30/message/');
                    for (Dom.XmlNode infoItemNode : infoItemsNode.getChildElements()) {
                        Dom.XmlNode keyNode = infoItemNode.getChildElement('Key', 'http://Paymetric/XiPaySoap30/message/');
                        if (keyNode != null && keyNode.getText() == 'TR_CARD_CIDRESPCODE') {
                            trCardCidRespCode = infoItemNode.getChildElement('Value', 'http://Paymetric/XiPaySoap30/message/').getText();
                            System.debug('TR_CARD_CIDRESPCODE: ' + trCardCidRespCode);
                            if(trCardCidRespCode == 'M'){
                                responseData.put('response','Success');
                            }else{
                                String errorMessage = 'Card Validation FALSEure - Please re-enter card details.';
                                responseData.put('response',errorMessage);
                            }
                        }
                    }
                }else{
                    String errorMessage = avsResponse.scc_Error_Message__c;
                    responseData.put('response',errorMessage);
                }                
            }else if(statusCode != '100'){
                String errorMessage = iTransactionHeaderNode.getChildElement('Message', 'http://Paymetric/XiPaySoap30/message/').getText();
                responseData.put('response',errorMessage);
            }
            return responseData;
            
        } catch (Exception e) {
            System.debug('Error parsing XML: ' + e.getMessage());
            throw new AuraHandledException('Failed to complete pre auth:'+e.getMessage());
        }
    }
        
    /**
    *  Description: This method creates Integration Logs    
    *  @name: createIntegrationLogs
    *  @param:parameters like logType,requestBody etc.
    *  @return: void
    *  @throws exception- 
    */
    
    public static void createIntegrationLogs(String logType, String requestBody, String responseBody, String status, String internalStatus, String contactId, String contactEmail,Boolean insertNow,String userType){
        String transactionId = '';
        if(status == 'Success'){
            Dom.Document doc = new Dom.Document();
            doc.load(responseBody);
            Dom.XmlNode root = doc.getRootElement();
            
            Dom.XmlNode bodyNode = root.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
            Dom.XmlNode soapOpResponseNode = bodyNode.getChildElement('SoapOpResponse', 'http://Paymetric/XiPaySoap30/message/');
            Dom.XmlNode soapOpResultNode = soapOpResponseNode.getChildElement('SoapOpResult', 'http://Paymetric/XiPaySoap30/message/');
            Dom.XmlNode packetsNode = soapOpResultNode.getChildElement('packets', 'http://Paymetric/XiPaySoap30/message/');
            Dom.XmlNode iTransactionHeaderNode = packetsNode.getChildElement('ITransactionHeader', 'http://Paymetric/XiPaySoap30/message/');
            transactionId = iTransactionHeaderNode.getChildElement('TransactionID', 'http://Paymetric/XiPaySoap30/message/').getText();
        }
        Integration_Logs__c integrationLog = new Integration_Logs__c(
            Type__c = logType,
            Request_Body__c = requestBody,
            Response_Body__c = responseBody.toString().length()>1000 ? responseBody.toString().subString(0,1000) : responseBody.toString(),
            Status__c = status,
            scc_TransactionID__c = transactionId,
            Internal_Status__c = internalStatus,
            contact__c = String.isBlank(contactId)?NULL:contactId,
            Contact_Email__c = contactEmail,
            scc_User_Type__c = userType,
            Entry_Point__c = entryPoint
        );        
        paymetricIntegrationLog.add(integrationLog);
        
        if(insertNow == true){
            scc_IntegrationLogs_Helper.createSFCCIntegrationLogs(JSON.serialize(paymetricIntegrationLog));
        }
    }    
}