/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Apex REST callout test class designed provide a fake response.
*
* Apex REST callout test class designed provide a fake response to the buzz login callout.
* The response is formatted with the information that Buzz returns during successful login. 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Romer Pasag   	<Romer.Pasag@pearson.com>
* @modifiedBy     Romer Pasag   	<Romer.Pasag@pearson.com>
* @maintainedBy   Romer Pasag   	<Romer.Pasag@pearson.com>
* @version        1.0
* @created        2017-09-14
* @modified       
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* v1.0        	  Romer.Pasag@pearson.com
* 
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

@isTest
global class BuzzLoginCalloutMock implements HttpCalloutMock {
    protected Integer code;
    protected String body;
    protected string status;
    public BuzzLoginCalloutMock(string result){
        //Provide http callout result for different test scenario's  
        if(result.equalsIgnoreCase('Success')){
            this.code=200;
            this.status='OK';
            this.body= '{'+
                '  \"response\":{'+
                '    \"_token\":\"~HxTCEAAAAAwEz0YwKF6JFB.X610zcScCP2kURH6ZhLCKA\",'+
                '    \"code\":\"OK\",'+
                '    \"user\":{'+
                '      \"userid\":\"67714119\",'+
                '      \"username\":\"romer.pasag@pearson.com\",'+
                '      \"firstname\":\"Romer\",'+
                '      \"lastname\":\"Pasag\",'+
                '      \"email\":\"romer.pasag@pearson.com\",'+
                '      \"domainid\":\"67713473\",'+
                '      \"domainname\":\"Kimble Test\",'+
                '      \"userspace\":\"kimbletest\",'+
                '      \"token\":\"~HxTCEAAAAAwEz0YwKF6JFB.X610zcScCP2kURH6ZhLCKA\",'+
                '      \"authenticationexpirationminutes\":14'+
                '    }'+
                '  }'+
                '}';
        }else if(result.equalsIgnoreCase('ErrorURL')){
            this.code=400;
            this.status='Not Found';
            this.body= '{"response": {}}';
        }else if(result.equalsIgnoreCase('invalidCredential')){
            this.code=200;
            this.status='OK';
            this.body = '{'+
                '  \"response\":{'+
                '    \"code\":\"InvalidCredentials\",'+
                '    \"message\":\"Invalid username or password: Username=\'kimbletest/salesforce.integration\'\",'+
                '    \"errorId\":\"74a4feeab8e7491fa580d35643889c01\"'+
                '  }'+
                '}';
        }
    }
    
    // Implement this interface method
    global HttpResponse respond(HTTPRequest req){
        // Create a fake response
        
        HttpResponse res = new HttpResponse();
        res.setStatus(status);
        res.setStatusCode(code);
        res.setBody(body);
        return res;
    }
}