public class reCAPTCHA {

    /* Configuration */

    // The API endpoint for the reCAPTCHA service
    private static String baseUrl = 'https://www.google.com/recaptcha/api/verify'; 

    private static reCAPTCHASettings__c settings {
        get { 
            if(settings ==null) {
                return reCAPTCHASettings__c.getInstance();
            }
            return settings; 
        }
    }
    // The keys you get by signing up for reCAPTCHA for your domain
    private static String privateKey = reCAPTCHASettings__c.getInstance().Private_Key__c;
    public static String publicKey = reCAPTCHASettings__c.getInstance().Public_Key__c;

    // Method to verify Captcha
    public static boolean verify(String challenge, String response) {
        //System.debug('reCAPTCHA verification attempt');
        /*System.debug(baseUrl + 
            'privatekey=' + privateKey + 
            '&remoteip='  + remoteHost + 
            '&challenge=' + challenge +
            '&response='  + response);*/
        // On first page load, form is empty, so no request to make yet
        HttpResponse r = makeRequest(baseUrl,
            'privatekey=' + privateKey + 
            '&remoteip='  + remoteHost + 
            '&challenge=' + challenge +
            '&response='  + response
        );
        
        if ( r!= null ) {
            return (r.getBody().startsWithIgnoreCase('true'));
        }
        return false;
    }    
    
    
    /* Private helper methods */
    
    private static HttpResponse makeRequest(string url, string body)  {
        HttpResponse response = null;
        HttpRequest req = new HttpRequest();   
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setBody (body);
        try {
            Http http = new Http();
            response = http.send(req);
            //System.debug('reCAPTCHA response: ' + response);
            //System.debug('reCAPTCHA body: ' + response.getBody());
        } catch(System.Exception e) {
            System.debug('ERROR: ' + e);
        }
        return response;
    }   
        
    private static String remoteHost { 
        get { 
            String ret = '127.0.0.1';
            // also could use x-original-remote-host 
            Map<String, String> hdrs = ApexPages.currentPage().getHeaders();
            if (hdrs.get('x-original-remote-addr')!= null)
                ret =  hdrs.get('x-original-remote-addr');
            else if (hdrs.get('X-Salesforce-SIP')!= null)
                ret =  hdrs.get('X-Salesforce-SIP');
            return ret;
        }
    }
}