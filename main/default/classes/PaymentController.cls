public class PaymentController {
    public String iframeSrc { get; set;}
    
    public PaymentController(){
        Map<String, String> responseData = new Map<String, String>();
        try{
            scc_Integration_Setting__mdt metadata = [SELECT scc_Packet_Xml__c, scc_Shared_Key__c, scc_Merchant_Guid__c, scc_Endpoint_URL__c, scc_Method_Type__c FROM scc_Integration_Setting__mdt where Label = 'Paymetric API'];            
            String merchantGuid = metadata.scc_Merchant_Guid__c;
            String packet = metadata.scc_Packet_Xml__c;
            String sharedKey = metadata.scc_Shared_Key__c;
            String signature = generateHmacSHA256Signature(sharedKey, packet);
            system.debug('signature:'+signature);
            HttpRequest req = new HttpRequest();
            req.setEndpoint(metadata.scc_Endpoint_URL__c);
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
                    String baseUrl = 'https://cert-xiecomm.paymetric.com/diecomm/view/iframe/';
                    iframeSrc = baseUrl+metadata.scc_Merchant_Guid__c+'/'+accessTokenNode.getText()+'/true';
                    system.debug('responseData:'+responseData);
                }else{
                    throw new CalloutException('Access token not found.');
                }
            }else{
                throw new CalloutException('Error:'+res.getBody());
            }
        }catch(Exception e){
            system.debug('Exception:'+e.getMessage());
            throw new AuraHandledException('Failed to retrieve access token:'+e.getMessage());
        }
    }
    
    public String getIframeSrc(){
        return iframeSrc;
    }
    
    private static String generateHmacSHA256Signature(String key, String input) {  
		String algorithmName = 'HmacSHA256';
    	Blob mac = Crypto.generateMac(algorithmName, Blob.valueOf(input), Blob.valueOf(key));
    	String base64Mac = EncodingUtil.base64Encode(mac);
        String urlEncodedSignature = EncodingUtil.urlEncode(base64Mac, 'UTF-8');
    	return urlEncodedSignature;  
    } 
}