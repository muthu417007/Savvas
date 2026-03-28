global class CPQ_CalloutCache{

      
     @future(callout=true)
     public static void clearCache() {
        String ErrorMessage;
        String request= '[{"jsonrpc":"2.0","id":"clearAllCaches","method":"clearAllCaches"}]';
        try{
        
            //system.debug('***********getOrganizationId>'+UserInfo.getOrganizationId());
                            
            CameleonCPQ__CAMCPQSettings__c[] AuthInfo = [SELECT CameleonCPQ__CPQSession_AuthPwd__c,CameleonCPQ__CPQServer_EndpointURL__c FROM CameleonCPQ__CAMCPQSettings__c LIMIT 1];
            String authUser = UserInfo.getOrganizationId();
            authUser = authUser.substring(0,15);
            
            String EncodedauthPassword = EncodingUtil.urlEncode(AuthInfo[0].CameleonCPQ__CPQSession_AuthPwd__c,'UTF-8');
            String url = ''+AuthInfo[0].CameleonCPQ__CPQServer_EndpointURL__c+'/ProductSync/login?wsusername='+authUser+'&wspassword='+EncodedauthPassword+'';
            //system.debug('***********URL Login >'+url);  
            
            //Create Http instances to make a web service call
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setTimeOut(60000);
            req.setEndPoint(url); 
            
            Http http = new Http();
            HTTPResponse resp = new HTTPResponse();  
            
            //login req
            if (!Test.IsRunningTest()){
                resp = http.send(req);
                //system.debug('***********Login result >'+resp.getBody());
            }else{
                resp= new HttpResponse();
                resp.setStatus('OK');
                resp.setStatusCode(200);
            
                String httpResBody = '[{"jsonrpc":"2.0","result":"OK","id":"clearAllCaches"}]';
                resp.setBody(httpResBody); 
            }
            String setCookie = null;
            for (String key : resp.getHeaderKeys()) {
                 if(key != null){
                    if(key.equals('Set-Cookie')){
                        // Extract of the jsessionid provided by cameleon server
                        setCookie = resp.getHeader(key).substring(resp.getHeader(key).indexOf('=') +1, resp.getHeader(key).indexOf(';'));
                    }
                 }
            }
            
            //HttpRequest req2 = new HttpRequest();
            url = AuthInfo[0].CameleonCPQ__CPQServer_EndpointURL__c+'/ProductSync/ProductSync;jsessionid=' + setCookie;
            req.setMethod('POST');
            req.setEndpoint(url);
            //system.debug('***********Url Clear Cache >'+url); 
            //system.debug('*********** with jsonRequests >'+request); 
            req.setBody('jsonRequests='+request);

             //fake response if this is a test case
            if (!Test.IsRunningTest()){
                resp = http.send(req); 
                //System.debug('*********** Clear cache result>'+resp.getBody()); 
            }
            else {
                resp= new HttpResponse();
                resp.setStatus('OK');
                resp.setStatusCode(200);
            
                String httpResBody = '[{"jsonrpc":"2.0","result":"OK","id":"clearAllCaches"}]';
                resp.setBody(httpResBody); 
            }
                   
            /* Code added for error handling in future call */
           
            
            ErrorMessage='success';       
            //system.debug('>>>><<<<'+string.valueof(resp.getBody()));
            if(string.valueof(resp.getBody()).contains('Error') || string.valueof(resp.getBody()).contains('error')){
                ErrorMessage=string.valueof(resp.getBody()).substring(resp.getBody().indexOf('"error":{'),resp.getBody().indexOf('}'));
                //system.debug('>>>><<<<'+ErrorMessage);
            }  
           
            //return ErrorMessage;
            
        }catch(Exception e){
            system.debug('>>>error'+e);
            //return ErrorMessage;
        }
    }  
}