public class MVLogin{

    public String apiurl;
    private string result;
    private string user;
    private string sso;
    private string customerID;
    private string accesstoken;

    public MVLogin() {

        customerID = 'MarketView';
        user = UserInfo.getUserName();
        sso = userInfo.getSessionId();
        string serverURL = ApexPages.currentPage().getHeaders().get('X-Salesforce-Forwarded-To');
        apiurl = 'https://'+serverURL+'/services/Soap/u/16.0';
        result = retrieve();

    }
    public string retrieve() {
        //we'll call the REST API here
        http h = new http();
 
        httprequest req = new httprequest();
        String data;
        
        data = '{"data":"'+customerID + '|'+ user  +'|' +sso  +'|'+ apiurl +'"}';
        req.setBody(data);

        req.setEndpoint('http://uc.crmdp.com:1024/Service1.svc/TestLogIn');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Host','uc.crmdp.com:1024');

        httpresponse res;
        
 try{
        res = h.send(req);
    }
         catch (exception e){
           
        e.getmessage();
        return 'https://uc.crmdp.com/InvalidLogin.aspx';
        
        }  

        //resp is a JSON string
        JSONParser parser = JSON.createParser(res.getBody());
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
                    String fieldName = parser.getText();
                    parser.nextToken();
                if(fieldName == 'TestLogInResult') {
                    accesstoken = parser.getText();
                    
                    if (accesstoken == 'true'){
                        result = String.valueOf(getSSO());
                    }else{
                        result = 'https://uc.crmdp.com/InvalidLogin.aspx';
                    }
                }else{
                result = 'https://uc.crmdp.com/InvalidLogin.aspx';
                
                }
            }
        }

        return result;
    
    }
 
    public string getResult() {
        return this.result;
    }
    
        public static directconnectauthServicecontracts.UserAuthenticationService service;
         private string Separator = '#';
         String url ='http://apps.schooldata.com/Marketview/MarketViewSSO.aspx?lkey=';
         String sb;
         string UserId { get; set; }
         string UserPassword { get; set; }
         string marketViewUrl = 'http://apps.schooldata.com/Marketview/MarketViewSSO.aspx?lkey={0}';


        public string getSSO()
        {
            service = new directconnectauthServicecontracts.UserAuthenticationService();
            InitializeServiceHeader();
            string result = url + MarketViewLogin();
            return result;
        }

        private void InitializeServiceHeader()
        {
            // Create Service Authentication Header. These values assigned to you.
            UserId = '1741f1f3ff5143c09d43780083bc3491';
            UserPassword = 's2g78hat';
            directconnectauthServicecontracts.AuthHeader header = new directconnectauthServicecontracts.AuthHeader();
            header.UserId = UserId;
            header.Password = UserPassword;
            header.UserSite = 'SalesForce';
            service.AuthHeader = header;
        }
        
        private String MarketViewLogin()
        {
            string email = UserInfo.getUserName();
            string ipAddress = '127.0.0.1';
            datetime requestTime = datetime.now();
            string UTCDateTime = requestTime.format('M/d/yyyy h:mm:ss a','GMT'); //datetime conversion to MDR requiered format
            
            directconnectauthServicecontracts.AuthSignOn signOn = new directconnectauthServicecontracts.AuthSignOn();
            signOn.Email = email;
            signOn.IpAddress = ipAddress;
            signOn.RequestTime = requestTime;
            signOn.HashValue = CreateHash(email, ipAddress, UTCDateTime);

            //WebService call
            try
            {
            directconnectauthServicecontracts.MarketViewAuthenticationResponse response = service.MarketViewAutoLogin(signOn);
                if (response.SignOnKey == null)
                {
                   return response.message;
                }
                return response.SignOnKey; 
            }
            catch (Exception ex)
            {        
            return ex.getMessage();
            }
        }

        private string CreateHash(string email, string ipAddress, string requestTime)
        {
            sb=
            Separator  + 
            email + 
            Separator  + 
            UserId + 
            Separator  + 
            UserPassword  +
            Separator  + 
            ipAddress + 
            Separator  + 
            requestTime + 
            Separator ;
            return CalculateMD5Hash(sb); 
        }

        private static string CalculateMD5Hash(string input)
        {
            Blob bPrehash = Blob.valueOf(input);
            Blob bsig = Crypto.generateDigest('MD5', bPrehash ); // create the md5 algotithm
            string key= EncodingUtil.convertToHex(bsig); //covert to hexadecimal
            return key.toUpperCase();
        }
}