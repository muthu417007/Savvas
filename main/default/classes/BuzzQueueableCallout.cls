/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Apex Queueable Class that does callout and update the Buzz Agilix Enrollment.
*
* The class login to Buzz and updates the enrollment external ID with a 
* Salesforce Resource Capability ID
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

public class BuzzQueueableCallout implements Queueable,Database.AllowsCallouts{
    // Variable used to pass which http callout scenario to be used during testing
    public string testVariable;
	private String JSONBodyString;
    
    public BuzzQueueableCallout(String JSONString,string testVar){
        this.JSONBodyString=JSONString;
        this.testVariable=testVar;
    }
    
    public void execute(QueueableContext context){
        //Authenticate to Buzz and get the token
        BuzzLoginCallout callout=new BuzzloginCallout();
        list<String> loginInfo=callout.basicAuthCallout();
        //If successfully login to buzz and received a token
        if(loginInfo.size()>0){
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            // Endpoint to update enrollments
            request.setEndpoint('https://api.agilixbuzz.com/cmd?cmd=updateenrollments');
            request.setMethod('POST');
            request.setHeader('Cookie','AZT='+loginInfo[0]);
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Accept','application/json');
            // Set the body as a JSON object
            request.setBody(JSONBodyString); 
            //If a test class is running, create a mock test data and use data for http callout
            //the if statement handles multiple test scenario's based on http response
            if (Test.isRunningTest() && String.isBlank(testVariable)) {
                BuzzUpdateCalloutMock fakeResponse=new BuzzUpdateCalloutMock('Success');
                Test.setMock(HttpCalloutMock.class, fakeResponse); 
            }else if(Test.isRunningTest() && testVariable.equalsIgnoreCase('badRequest')) {
                BuzzUpdateCalloutMock fakeResponse=new BuzzUpdateCalloutMock('badRequest');
                Test.setMock(HttpCalloutMock.class, fakeResponse); 
            }
            HttpResponse response = http.send(request);
            // If the request is successful, parse the JSON response.
            // Parse the JSON response
            if (response.getStatusCode() != 200) {
                System.debug('The status code returned was not expected: ' +
                             response.getStatusCode() + ' ' + response.getStatus());
            } else {            
                Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                Map<String,Object> responseData=(Map<String,Object>)result.get('response');
				if(responseData.get('code')=='BadRequest'){
                    BuzzIntegrationUtility.sendEmailError('buzzUpdateError');
                }
            }
        } 
    }
}