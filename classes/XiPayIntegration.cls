public class XiPayIntegration {
    public void sendPreAuthorizationRequest() {
        // Create the endpoint and HTTP request
        Map<String, String> tokenResponse = new Map<String, String>();
        tokenResponse.put('cardType','vi');
        tokenResponse.put('expDate','12/25');
        tokenResponse.put('tokenizedCardNumber','-E803-4448-PZSPK02TTSZK2C');
        tokenResponse.put(''+tokenResponse.get('cardType')+'','Dhiya');
        tokenResponse.put('securityCode','999');
        
        String cardType = tokenResponse.get('cardType').toUpperCase();
        
        
        
        scc_Integration_Setting__mdt metadata = [SELECT scc_Method_Type__c, scc_Endpoint_URL__c, scc_Shared_Key__c, scc_Merchant_Guid__c FROM scc_Integration_Setting__mdt where Label = 'PreAuth API'];

        HttpRequest req = new HttpRequest();
        req.setEndpoint(metadata.scc_Endpoint_URL__c);
        req.setMethod(metadata.scc_Method_Type__c);
        
        // Set headers
        req.setHeader('Content-Type', 'text/xml');
        req.setHeader('SOAPAction', '\"Paymetric/XiPaySoap30/action/XiGGE.SoapOp\"');
        
        // Set body
        String requestBody = '<soapenv:Envelope xmlns:ns1="http://Paymetric/XiPaySoap30/message/" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">' +
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
                                '<ns1:MerchantID>SAVVAS_LC_USD</ns1:MerchantID>' +
                                '<ns1:Amount>0.00</ns1:Amount>' +  // $0 for Visa/MasterCard and $1 for American Express
                                '<ns1:CurrencyKey>USD</ns1:CurrencyKey>' +
                                '<ns1:CardDataSource>E</ns1:CardDataSource>' +
                                '<ns1:CardHolderAddress1>12115 LACKLAND</ns1:CardHolderAddress1>' +
                                '<ns1:CardHolderCity>Houston</ns1:CardHolderCity>' +
                                '<ns1:CardHolderCountry>US</ns1:CardHolderCountry>' +
                                '<ns1:CardHolderName>'+tokenResponse.get('cardHolderName')+'</ns1:CardHolderName>' +
                                '<ns1:CardHolderName1>JOHN</ns1:CardHolderName1>' +
                                '<ns1:CardHolderName2>SMITH</ns1:CardHolderName2>' +
                                '<ns1:CardHolderState>TX</ns1:CardHolderState>' +
                                '<ns1:CardHolderZip>85284</ns1:CardHolderZip>' +
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
        
        // Create and send the HTTP request
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        // Process the response
        if(res.getStatusCode() == 200) {
            System.debug('Response: ' + res.getBody());
            // Further processing of the response can be done here
        } else {
            System.debug('Error: ' + res.getStatusCode() + ' ' + res.getStatus());
            System.debug('Response: ' + res.getBody());
        }
    }
}