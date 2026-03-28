/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Apex REST callout test class designed provide a fake response.
*
* Apex REST callout test class designed provide a fake response to the Buzz Update Callout.
* The fake response is formatted according to the HTTP response that Buzz returns when successfully
* updating an enrollment record
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
global class BuzzUpdateCalloutMock implements HttpCalloutMock {
    protected Integer code;
    protected String body;
    protected string status;
    public BuzzUpdateCalloutMock(string result){
        //Provide http callout result for different test scenario's  
        if(result.equalsIgnoreCase('Success')){
            this.code=200;
            this.status='OK';
            this.body = '{'+
                '  \"response\":{'+
                '    \"code\": \"OK\",'+
                '    \"responses\":{'+
                '      \"response\":[{'+
                '        \"code\": \"OK\"'+
                '      }]'+
                '    }'+
                '  }'+
                '}';
        }else if(result.equalsIgnoreCase('badRequest')){
            this.code=200;
            this.status='OK';
            this.body = '{'+
                '  \"response\":{'+
                '    \"code\":\"BadRequest\",'+
                '    \"message\":\"No POST data was provided.  Expected XML or JSON POST data.\",'+
                '    \"errorId\":\"812c3b960c954506985e3d8ba52e53ac\"'+
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