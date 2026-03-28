/*Apex Class:scc_PaymetricIntegrationController
Author: CTS (	Dhiyaneshwari Karthikeyan)
Created Date: 27/05/2024
Reason: This Controller is used for paymetric purpose.  
Modified Date: 17/10/2024
*/
public without sharing class scc_PaymetricIntegrationController {
    
    public static String contactId='';
    public static String contactEmail='';
    public static String userType='';
    public static String userID='';
    public static List<Integration_Logs__c> paymetricIntegrationLog = new List<Integration_Logs__c>();
    public static String entryPoint ='';
    
    /********************************************************************** 
    Method Name :  getGuestCartDetails
    Description : used to fetch current cart details
    Input       : cartId , AccountId
    Return type : Map of cart data
    ***********************************************************************/ 
    @AuraEnabled
    public static Map<String, String> getGuestCartDetails(String guestCartId,String guestAccountId){
        try{
            Map<String, String> guestCartDetails = new Map<String, String>();
            Decimal discount = 0.00;
            Decimal shipping = 0.00;
            Decimal subTotal = 0.00;
            Decimal tax = 0.00;
            
            String rubicon = [SELECT API_Account_Name__c FROM scc_API_Connected_Accounts__mdt where Label = 'Rubicon'].API_Account_Name__c;
            WebCart guestCart = [SELECT Id, TotalProductAmount, Coupon_Discount__c, Shipping_Amount__c, TotalAmount, Coupon__c, API_Source__c,License_Partner__c FROM WebCart where Id =: guestCartId LIMIT 1];
            Account guestAccount = [SELECT Id, Name FROM Account where Id =: guestAccountId LIMIT 1];
            String homeschool = [SELECT API_Account_Name__c FROM scc_API_Connected_Accounts__mdt where Label = 'Homeschool'].API_Account_Name__c;
            String pnp = [SELECT API_Account_Name__c FROM scc_API_Connected_Accounts__mdt where Label = 'PNP'].API_Account_Name__c;
            try{
            if(guestCart.License_Partner__c != ''){
                String institutionName = [SELECT Id, Name FROM Account where AccountNumber =: guestCart.License_Partner__c LIMIT 1].Name;
                if(institutionName != ''){
                guestCartDetails.put('institutionName', institutionName);
                }
            }
            }
            catch(QueryException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            } 
            AggregateResult[] cartItemsAgg = [SELECT SUM(Tax__c) totalTax FROM CartItem where CartId =: guestCartId];
            AggregateResult cartItemAgg = cartItemsAgg[0];
            Decimal totalTax= (Decimal)cartItemAgg.get('totalTax');    
           
            guestCartDetails.put('Coupon', guestCart.Coupon__c);
            guestCartDetails.put('DisplayInstitution', 'false');
            
            if(guestCart.API_Source__c == rubicon){
                guestCartDetails.put('isRubiconAccount', 'true');
                Double coversionRate = [SELECT Id, ConversionRate FROM CurrencyType where IsoCode = 'CAD' LIMIT 1].ConversionRate;
                
                if(guestCart.Coupon_Discount__c != null){
                    discount = (guestCart.Coupon_Discount__c * coversionRate).setScale(2, System.RoundingMode.HALF_UP);
                    String cartDiscount = String.valueof(guestCart.Coupon_Discount__c);
                    if(cartDiscount.contains('-')){ 
                        cartDiscount = cartDiscount.remove('-');
                    }
                    guestCartDetails.put('CouponDiscount', String.valueof(cartDiscount));
                }
                if(guestCart.Shipping_Amount__c != null && guestCart.Shipping_Amount__c > 0){
                    shipping = (guestCart.Shipping_Amount__c * coversionRate).setScale(2, System.RoundingMode.HALF_UP);
                    guestCartDetails.put('ShippingAmount', String.valueof(shipping));
                }
                if(guestCart.TotalProductAmount != null){
                    subTotal = (guestCart.TotalProductAmount * coversionRate).setScale(2, System.RoundingMode.HALF_UP);
                    guestCartDetails.put('SubTotal', String.valueof(subTotal));
                }
                if(totalTax != null){
                    tax = (totalTax * coversionRate).setScale(2, System.RoundingMode.HALF_UP);
                    guestCartDetails.put('Tax', String.valueof(tax));
                }
                Decimal finalAmount = subTotal + discount + shipping + tax;
                guestCartDetails.put('Total', String.valueof(finalAmount));
            }else{
                if(guestCart.API_Source__c == homeschool || guestCart.API_Source__c == pnp){
                    guestCartDetails.put('DisplayInstitution', 'true');
                }
                if(guestCart.Coupon_Discount__c != null){
                    discount = guestCart.Coupon_Discount__c;
                    String cartDiscount = String.valueof(guestCart.Coupon_Discount__c);
                    if(cartDiscount.contains('-')){ 
                        cartDiscount = cartDiscount.remove('-');
                    }
                    guestCartDetails.put('CouponDiscount', cartDiscount);
                }
                if(guestCart.Shipping_Amount__c != null && guestCart.Shipping_Amount__c > 0){
                    shipping = guestCart.Shipping_Amount__c;
                    guestCartDetails.put('ShippingAmount', String.valueof(guestCart.Shipping_Amount__c));
                }
                if(guestCart.TotalProductAmount != null){
                    subTotal = guestCart.TotalProductAmount;
                    guestCartDetails.put('SubTotal', String.valueof(guestCart.TotalProductAmount));
                }
                if(totalTax != null){
                    tax = totalTax;
                    guestCartDetails.put('Tax', String.valueof(totalTax));
                }
                Decimal finalAmount = subTotal + discount + shipping + tax;
                guestCartDetails.put('Total', String.valueof(finalAmount));
            }
            return guestCartDetails;
        }catch(Exception e){
            system.debug('Exception:'+e.getMessage());
            throw new AuraHandledException('Failed to retrieve cart details :'+e.getMessage());
        }
    }
    /********************************************************************** 
    Method Name :  getCountrysOptions
    Description : used to fetch country option
    Input       : NA
    Return type : String(Json serialize) country option 
    ***********************************************************************/ 
    @AuraEnabled(cacheable=true)
    public static String getCountrysOptions(){
        List<ZVC__Country_Phone_Code__c> getCountrysOptionsData = [SELECT Name, ZVC__Country_Code__c,CurrencyIsoCode FROM ZVC__Country_Phone_Code__c WHERE ZVC__Country_Code__c NOT IN ('United States','Canada')  ORDER BY ZVC__Country_Code__c ASC];        
        List<getCountrysOptionsWrapper> getCountrysOptionsWrap = new List<getCountrysOptionsWrapper>();       
        for(Integer i=0;i<getCountrysOptionsData.size();i++){
            getCountrysOptionsWrap.add(new getCountrysOptionsWrapper(getCountrysOptionsData[i].ZVC__Country_Code__c,getCountrysOptionsData[i].Name)); 
        }       
        return JSON.serialize(getCountrysOptionsWrap);
    }
    /********************************************************************** 
    Method Name :  getStatesOptions
    Description : used to fetch state option
    Input       : Country code
    Return type : String(Json serialize) State option 
    ***********************************************************************/ 

    @AuraEnabled(cacheable=true)
    public static String getStatesOptions(String countryCode){
        List<SCC_StateInfo__c> getStatesOptionsData = [SELECT Name,State_Code__c FROM SCC_StateInfo__c WHERE CurrencyIsoCode =: countryCode ORDER BY Name ASC];        
        List<geStatesOptionsWrapper> geStatesOptionsWrap = new List<geStatesOptionsWrapper>();       
        for(Integer i=0;i<getStatesOptionsData.size();i++){
            geStatesOptionsWrap.add(new geStatesOptionsWrapper(getStatesOptionsData[i].Name,getStatesOptionsData[i].State_Code__c)); 
        }       
        return JSON.serialize(geStatesOptionsWrap);
    }
   /********************************************************************** 
    Method Name :  getAccessToken
    Description : used to get access token
    Input       : NA
    Return type : Map of responsedata
    ***********************************************************************/ 
    @AuraEnabled
    public static Map<String, String> getAccessToken(){
        Map<String, String> responseData = new Map<String, String>();
        HttpRequest req = new HttpRequest();
        HttpResponse res;
        try{
            entryPoint ='Scc_checkOutLWC/handleiFrameLoad/scc_PaymetricIntegrationController.getAccessToken';
            List<User> usr = [SELECT ID,Email, Profile.Name, IsEmployee__c,Contact.Id, Contact.AccountID,Contact.Email,Contact.Account.SAP_Account_Id__c, contact.name, contact.Account.name FROM User WHERE Id = :UserInfo.getUserId()];
            
            if(usr[0].Profile.Name =='Savvas External Users Base Profile'){
                contactId = usr[0].Contact.Id;
                contactEmail = usr[0].Contact.Email;
                userType = 'External User';
            }else if(usr[0].Profile.Name =='MySavvasOrders Profile'){
                contactEmail = 'MySavvasOrders Guest User';
                userType = 'Guest User';
            }else{
                contactEmail = '';
                userType = 'Internal User';
                userID = usr[0].ID;
            }
                        
            scc_Integration_Setting__mdt metadata = [SELECT scc_Packet_Xml__c, scc_Shared_Key__c, scc_Merchant_Guid__c, scc_Endpoint_URL__c, scc_Method_Type__c FROM scc_Integration_Setting__mdt where Label = 'Paymetric API'];            
            String merchantGuid = metadata.scc_Merchant_Guid__c;
            String packet = metadata.scc_Packet_Xml__c;
            String sharedKey = metadata.scc_Shared_Key__c;
            String signature = generateHmacSHA256Signature(sharedKey, packet);
            system.debug('signature:'+signature);
            
            req.setEndpoint(metadata.scc_Endpoint_URL__c);
            req.setMethod(metadata.scc_Method_Type__c);
            req.setHeader('Content-Type','application/x-www-form-urlencoded');
            req.setBody('MerchantGuid='+merchantGuid+'&SessionRequestType=1&Packet='+EncodingUtil.urlEncode(packet, 'UTF-8')+'&Signature='+signature+'&MerchantDevelopmentEnvironment=Apex');
            system.debug('getAccessToken set request :'+req);
            
            Http http = new Http();
            res = http.send(req);
            if(res.getStatusCode() == 200){
                system.debug('getAccessToken res body'+res.getBody());
                Dom.Document doc = new Dom.Document();
                doc.load(res.getBody());
                
                Dom.XmlNode accessTokenNode = doc.getRootElement().getChildElement('ResponsePacket',null).getChildElement('AccessToken',null);
                Dom.XmlNode signatureNode = doc.getRootElement().getChildElement('ResponsePacket',null).getChildElement('Signature',null);
                if(accessTokenNode != null){ 
                    responseData.put('accessToken',accessTokenNode.getText());
					responseData.put('merchantGuid',metadata.scc_Merchant_Guid__c); 
                    responseData.put('signature',signatureNode.getText());
                    system.debug('responseData:'+responseData);
                }else{
                    throw new CalloutException('Access token not found.');
                }
                if(Boolean.valueOf(Label.scc_Insert_Logs)){
            		createIntegrationLogs('Paymetric Access token',req.getBody(),res.getBody(),'Success',String.valueOf(res.getStatusCode()),contactId,contactEmail,true,userType);                
                }
                return responseData;
            }else{
                if(Boolean.valueOf(Label.scc_Insert_Logs)){
                	createIntegrationLogs('Paymetric Access token',req.getBody(),res.getBody(),'Success',String.valueOf(res.getStatusCode()),contactId,contactEmail,true,userType);                
                }
                throw new CalloutException('Error:'+res.getBody());
            }
            
        }catch(Exception e){
            system.debug('Exception:'+e.getMessage());
            if(Boolean.valueOf(Label.scc_Insert_Logs)){
                if(res !=null){
                    createIntegrationLogs('Paymetric Access token',req.getBody(),String.isBlank(res.getBody())?'NULL':res.getBody(),'Error',e.getLineNumber() + ': ' + e.getMessage(),contactId,contactEmail,true,userType);                             
                }else{
                    createIntegrationLogs('Paymetric Access token',req.getBody(),'','Error',e.getLineNumber() + ': ' + e.getMessage(),contactId,contactEmail,true,userType);                                                 
                }
            }
            return null;
        }
    }
    /********************************************************************** 
    Method Name :  generateHmacSHA256Signature
    Description : used to generate Signature
    Input       : key and input
    Return type : String
    ***********************************************************************/ 
    private static String generateHmacSHA256Signature(String key, String input) {  
		String algorithmName = 'HmacSHA256';
    	Blob mac = Crypto.generateMac(algorithmName, Blob.valueOf(input), Blob.valueOf(key));
    	String base64Mac = EncodingUtil.base64Encode(mac);
        String urlEncodedSignature = EncodingUtil.urlEncode(base64Mac, 'UTF-8');
    	return urlEncodedSignature;  
    } 
   /********************************************************************** 
    Method Name :  getCreditCardToken
    Description : used to get creditcard token
    Input       : combination of string, Boolean and map
    Return type : Map of responsedata
    ***********************************************************************/     
    @AuraEnabled
    public static Map<String, String> getCreditCardToken(String accessToken, String signature, String merchantGuid, Boolean isAddressDifferent,Map<String, String> cardAddressMap, String cartId){
        Map<String, String> responseData = new Map<String, String>();
        Map<String, String> tokenResponse = new Map<String, String>();
        Map<String, String> addressDetails = new Map<String, String>();
        Map<String, Map<String, String>> cardDetails = new Map<String, Map<String, String>>();
        String endpoint;
        HttpResponse res;
        try{
           entryPoint ='Scc_checkOutLWC/submitform/scc_PaymetricIntegrationController.getCreditCardToken';
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
                userID = usr[0].ID;
           }            
            if(isAddressDifferent){
                addressDetails = cardAddressMap;
            }else{
                Boolean guestCheck=scc_checkOutLWC_Controller.isGuestUser();
                if(guestCheck == true){
                     addressDetails = cardAddressMap;
                }else{
                WebCart currCart = [SELECT CurrencyIsoCode, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry FROM WebCart where Id =: cartId LIMIT 1];
                String countryCode = currCart.BillingCountry;
                if(countryCode.length() > 3){
                    countryCode = [SELECT Name FROM ZVC__Country_Phone_Code__c WHERE ZVC__Country_Code__c =: countryCode LIMIT 1].Name;
                }                
                addressDetails.put('cardStreet',currCart.BillingStreet);
                addressDetails.put('cardCity',currCart.BillingCity);
                addressDetails.put('cardCountry',countryCode);
                addressDetails.put('cardState',currCart.BillingState);
                addressDetails.put('cardZip',currCart.BillingPostalCode);
                addressDetails.put('currencyCode',currCart.CurrencyIsoCode);
            }}
            scc_Integration_Setting__mdt metadata = [SELECT scc_Method_Type__c, scc_Endpoint_URL__c FROM scc_Integration_Setting__mdt where Label = 'Credit Card Token API'];  
            HttpRequest req = new HttpRequest();
            endpoint = metadata.scc_Endpoint_URL__c+'?MerchantGUID='+merchantGuid+'&Signature='+EncodingUtil.urlEncode(signature, 'UTF-8')+'&AccessToken='+accessToken;
            req.setEndpoint(endpoint);
            req.setMethod(metadata.scc_Method_Type__c);
            req.setHeader('Content-Type','application/x-www-form-urlencoded');
            system.debug('getCreditCardToken set request :'+req);
            
            Http http = new Http();
            res = http.send(req);
            system.debug('getCreditCardToken res:'+res);
            if(res.getStatusCode() == 200){
                Dom.Document doc = new Dom.Document();
                doc.load(res.getBody());
				Dom.XmlNode root = doc.getRootElement();

                for(Dom.XMLNode field : root.getChildElement('Fields',null).getChildElements()){
                    Dom.XMLNode nameNode = field.getChildElement('Name', null);
                    Dom.XMLNode valueNode = field.getChildElement('Value', null);
                    if(nameNode != null && valueNode != null){  
                        if(nameNode.getText() == 'Card Type'){
                            tokenResponse.put('cardType',(valueNode.getText()).toUpperCase());
                        }else if(nameNode.getText() == 'Expiration Month'){
                            tokenResponse.put('expMonth',valueNode.getText());
                        }else if(nameNode.getText() == 'Expiration Year'){
                            tokenResponse.put('expYear',valueNode.getText());
                        }else if(nameNode.getText() == 'Card Number'){
                            tokenResponse.put('tokenizedCardNumber',valueNode.getText());
                        }else if(nameNode.getText() == 'Card Holder Name'){
                            tokenResponse.put('cardHolderName',(valueNode.getText()).toUpperCase());
                        }else if(nameNode.getText() == 'Card Security Code'){
                            tokenResponse.put('securityCode',valueNode.getText());
                        }
                    }
                }
            }
            if(!tokenResponse.isEmpty()){
                cardDetails.put('tokenResponse', tokenResponse);
            }                
            if(!addressDetails.isEmpty()){
                cardDetails.put('addressDetails', addressDetails);
            }                
            if(!cardDetails.isEmpty()){
                Map<String, String> preAuthResponse = scc_XiPayIntegration.sendPreAuthorizationRequest(cardDetails);
                system.debug('**Pre Auth response: '+preAuthResponse);
                responseData = tokenResponse;
                responseData.put('preAuthResponse',preAuthResponse.get('response'));
                
            }else{
                throw new CalloutException('Error:'+res.getBody());
            }
            if(Boolean.valueOf(Label.scc_Insert_Logs)){
            	createIntegrationLogs('Paymetric Credit card token',endpoint,res.getBody(),'Success',String.valueOf(res.getStatusCode()),contactId,contactEmail,true,userType);                            
            }
            return responseData;
        }catch(Exception e){
            system.debug('Exception:'+e.getMessage());
            if(Boolean.valueOf(Label.scc_Insert_Logs)){
                if(res !=null){
            		 createIntegrationLogs('Paymetric Credit card token',endpoint,String.isBlank(res.getBody())?'NULL':res.getBody(),'Error',e.getLineNumber() + ': ' + e.getMessage(),contactId,contactEmail,true,userType);                                                
                }else{
                     createIntegrationLogs('Paymetric Credit card token',endpoint,'','Error',e.getLineNumber() + ': ' + e.getMessage(),contactId,contactEmail,true,userType);                                                
                }
            }
            return null;
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
        paymetricIntegrationLog.add(integrationLog);
        if(insertNow == true){
            scc_IntegrationLogs_Helper.createSFCCIntegrationLogs(JSON.serialize(paymetricIntegrationLog));
        }
    }
    
    public class getCountrysOptionsWrapper{
            public String label;
            public String value;
           getCountrysOptionsWrapper(String label,String value){
               this.label = label;
               this.value = value;
           }    
       }
    
    public class geStatesOptionsWrapper{
            public String label;
            public String value;
           geStatesOptionsWrapper(String label,String value){
               this.label = label;
               this.value = value;
           }    
       }
}