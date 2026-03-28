/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Apex REST callout class designed login to Buzz Agilix and return token.
*
* Apex REST callout class designed login to Buzz Agilix and return token.
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Romer Pasag   	<Romer.Pasag@pearson.com>
* @modifiedBy     Romer Pasag   	<Romer.Pasag@pearson.com>
* @maintainedBy   Romer Pasag   	<Romer.Pasag@pearson.com>
* @version        1.0
* @created        2017-09-13
* @modified       
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* v1.0        	  Romer.Pasag@pearson.com
* 
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

public class BuzzLoginCallout {
    // Variable used to pass which http callout scenario to be used during testing
    public string testVariable;
    // List that contains the login information.  
    // The List contains the authentication token and Buzz domainId
    public List<string> basicAuthCallout(){
        List<string> AuthInfo=new list<string>();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        //Buzz API Named credential contains the endpoint URL and credentials to use
        request.setEndpoint('callout:Buzz_API'); 
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Accept','application/json');
        // Set the body as a JSON object
        // Used the username and password that is at the Buzz API Named Credential
        request.setBody('{"request":{"cmd":"login","username":"{!HTMLENCODE($Credential.Username)}","password":"{!HTMLENCODE($Credential.Password)}"}}');
        //If a test class is running, create a mock test data and use data for http callout
        //the if statement handles multiple test scenario's based on http response
        if (Test.isRunningTest() && String.isBlank(testVariable)) {
            BuzzLoginCalloutMock fakeResponse=new BuzzLoginCalloutMock('Success');
            Test.setMock(HttpCalloutMock.class, fakeResponse); 
        }else if(Test.isRunningTest() && testVariable.equalsIgnoreCase('404')) {
            BuzzLoginCalloutMock fakeResponse=new BuzzLoginCalloutMock('ErrorURL');
            Test.setMock(HttpCalloutMock.class, fakeResponse); 
        }else if(Test.isRunningTest() && testVariable.equalsIgnoreCase('badCredential')) {
            BuzzLoginCalloutMock fakeResponse=new BuzzLoginCalloutMock('invalidCredential');
            Test.setMock(HttpCalloutMock.class, fakeResponse); 
        }
        HttpResponse response= http.send(request);     
        // Parse the JSON response
        //system.debug(response.getStatus());
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
            // Call Utility class that sends emails message
            BuzzIntegrationUtility.sendEmailError('ErrorURL');
        } else {
            // Deserialize the JSON response into Maps
            Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Map<String,Object> responseData=(Map<String,Object>)result.get('response');
            
            // Get the token and domain Id from the body
            if(responseData.get('_token')!=null){
                AuthInfo.add((String)responseData.get('_token'));
                // Get the domain Id from the body
                Map<String,Object> userData=(Map<String,Object>)responseData.get('user');
                if(userData.get('domainid')!=null){
                	AuthInfo.add((String)userData.get('domainid')); 
                }
            }else{
                // Call Utility class that sends emails message
                BuzzIntegrationUtility.sendEmailError('invalidCredential');
            }
        }
        return AuthInfo;
    }
}