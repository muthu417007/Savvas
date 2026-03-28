public class PaymetricIntegrationController {
    @AuraEnabled(cacheable=true)
    public static String getCountrysOptions(){
        List<ZVC__Country_Phone_Code__c> getCountrysOptionsData = [SELECT ZVC__Country_Code__c,CurrencyIsoCode FROM ZVC__Country_Phone_Code__c WHERE ZVC__Country_Code__c NOT IN ('United States','Canada')  ORDER BY Name ASC];        
        List<getCountrysOptionsWrapper> getCountrysOptionsWrap = new List<getCountrysOptionsWrapper>();       
        for(Integer i=0;i<getCountrysOptionsData.size();i++){
            getCountrysOptionsWrap.add(new getCountrysOptionsWrapper(getCountrysOptionsData[i].ZVC__Country_Code__c,getCountrysOptionsData[i].CurrencyIsoCode)); 
        }       
        return JSON.serialize(getCountrysOptionsWrap);
    }
    
    @AuraEnabled(cacheable=true)
    public static String getStatesOptions(String countryCode){
        List<SCC_StateInfo__c> getStatesOptionsData = [SELECT Name,State_Code__c FROM SCC_StateInfo__c WHERE CurrencyIsoCode =: countryCode ORDER BY Name ASC];        
        List<geStatesOptionsWrapper> geStatesOptionsWrap = new List<geStatesOptionsWrapper>();       
        for(Integer i=0;i<getStatesOptionsData.size();i++){
            geStatesOptionsWrap.add(new geStatesOptionsWrapper(getStatesOptionsData[i].Name,getStatesOptionsData[i].State_Code__c)); 
        }       
        return JSON.serialize(geStatesOptionsWrap);
    }
	
    @AuraEnabled(cacheable=true)
    public static Map<String, String> getAccessToken(){
        Map<String, String> responseData = new Map<String, String>();
        try{
            scc_Integration_Setting__mdt metadata = [SELECT scc_Packet_Xml__c, scc_Shared_Key__c, scc_Merchant_Guid__c, scc_Named_Credential__c,scc_Method_Type__c FROM scc_Integration_Setting__mdt where Label = 'Paymetric API'];            
            String merchantGuid = metadata.scc_Merchant_Guid__c;
            String packet = metadata.scc_Packet_Xml__c;
            String sharedKey = metadata.scc_Shared_Key__c;
            String signature = generateHmacSHA256Signature(sharedKey, packet);
            system.debug('signature:'+signature);
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:'+metadata.scc_Named_Credential__c);
            req.setMethod(metadata.scc_Method_Type__c);
            req.setHeader('Content-Type','application/x-www-form-urlencoded');
            req.setBody('MerchantGuid='+merchantGuid+'&SessionRequestType=1&Packet='+EncodingUtil.urlEncode(packet, 'UTF-8')+'&Signature='+signature+'&MerchantDevelopmentEnvironment=Apex');
            
            Http http = new Http();
            HttpResponse res = http.send(req);
            if(res.getStatusCode() == 200){
                system.debug('res body'+res.getBody());
                Dom.Document doc = new Dom.Document();
                doc.load(res.getBody());
                
                Dom.XmlNode accessTokenNode = doc.getRootElement().getChildElement('ResponsePacket',null).getChildElement('AccessToken',null);
                Dom.XmlNode signatureNode = doc.getRootElement().getChildElement('ResponsePacket',null).getChildElement('Signature',null);
                if(accessTokenNode != null){ 
                    system.debug('AccessToken:'+accessTokenNode.getText());
                    responseData.put('accessToken',accessTokenNode.getText());
					responseData.put('merchantGuid',metadata.scc_Merchant_Guid__c); 
                    responseData.put('signature',signatureNode.getText());
                    system.debug('responseData:'+responseData);
                }else{
                    throw new CalloutException('Access token not found.');
                }
                return responseData;
            }else{
                throw new CalloutException('Error:'+res.getBody());
            }
        }catch(Exception e){
            system.debug('Exception:'+e.getMessage());
            throw new AuraHandledException('Failed to retrieve access token:'+e.getMessage());
        }
    }
    
    private static String generateHmacSHA256Signature(String key, String input) {  
		String algorithmName = 'HmacSHA256';
    	Blob mac = Crypto.generateMac(algorithmName, Blob.valueOf(input), Blob.valueOf(key));
    	String base64Mac = EncodingUtil.base64Encode(mac);
        String urlEncodedSignature = EncodingUtil.urlEncode(base64Mac, 'UTF-8');
    	return urlEncodedSignature;  
    } 
    
    @AuraEnabled
    public static Map<String, String> getCreditCardToken(String accessToken, String signature, String merchantGuid){
        Map<String, String> responseData = new Map<String, String>();
        try{
            system.debug('accessToken:'+accessToken);
			system.debug('signature:'+signature);
			system.debug('merchantGuid:'+merchantGuid);            
            HttpRequest req = new HttpRequest();
            String parameters = '?MerchantGUID='+merchantGuid+'&Signature='+EncodingUtil.urlEncode(signature, 'UTF-8')+'&AccessToken='+accessToken;
            req.setEndpoint('callout:Credit_Card_Token_API'+parameters);
            req.setMethod('GET');
            req.setHeader('Content-Type','application/x-www-form-urlencoded');
            
            Http http = new Http();
            HttpResponse res = http.send(req);
            system.debug('res:'+res);
            if(res.getStatusCode() == 200){
                system.debug('response: '+res.getBody());
                Dom.Document doc = new Dom.Document();
                doc.load(res.getBody());
				Dom.XmlNode root = doc.getRootElement();

                for(Dom.XMLNode field : root.getChildElement('Fields',null).getChildElements()){
                Dom.XMLNode nameNode = field.getChildElement('Name', null);
                Dom.XMLNode valueNode = field.getChildElement('Value', null);
                if(nameNode != null && valueNode != null){  
                    if(nameNode.getText() == 'Card Type'){
                        responseData.put('cardType',valueNode.getText());
                    }else if(nameNode.getText() == 'Expiration Month'){
                        responseData.put('expMonth',valueNode.getText());
                    }else if(nameNode.getText() == 'Expiration Year'){
                        responseData.put('expYear',valueNode.getText());
                    }else if(nameNode.getText() == 'Card Number'){
                        responseData.put('tokenizedCardNumber',valueNode.getText());
                    }else if(nameNode.getText() == 'Card Holder Name'){
                        responseData.put('cardHolderName',valueNode.getText());
                    }else if(nameNode.getText() == 'Card Security Code'){
                        responseData.put('securityCode',valueNode.getText());
                    }
                }
            
            }
                return responseData;
            }else{
                throw new CalloutException('Error:'+res.getBody());
            }
        }catch(Exception e){
            system.debug('Exception:'+e.getMessage());
            throw new AuraHandledException('Failed to retrieve access token:'+e.getMessage());
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