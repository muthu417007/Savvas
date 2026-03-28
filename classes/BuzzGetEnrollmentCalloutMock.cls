/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Apex REST callout test class designed provide a fake response.
*
* Apex REST callout test class designed provide a fake response to the Buzz Get Enrollment Callout.
* The response is formatted with the information that Buzz returns during successfully querying
* enrollment with course and user information. 
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
global class BuzzGetEnrollmentCalloutMock implements HttpCalloutMock {
    protected Integer code;
    protected String body;
    protected string status;
    public BuzzGetEnrollmentCalloutMock(string result){
        //Provide http callout result for different test scenario's  
        if(result.equalsIgnoreCase('Success')){
            this.code=200;
            this.status='OK';
            this.body = '{'+
                '  \"response\":{'+
                '    \"_token\":\"~K8lDEAAAAAAYZArZm3ySFA.fHXb7dGilH7XDdm1aNJfND\",'+
                '    \"code\":\"OK\",'+
                '    \"invalid\":\"Response\",'+
                '    \"enrollments\":{'+
                '      \"enrollment\":[{'+
                '        \"id\":\"67904626\",'+
                '        \"userid\":\"67741087\",'+
                '        \"courseid\":\"67740483\",'+
                '        \"roleid\":\"40079552\",'+
                '        \"domainid\":\"67713473\",'+
                '        \"reference\":\"\",'+
                '        \"guid\":\"1587934c-9f71-419d-b898-32b467a848d4\",'+
                '        \"privileges\":\"2228225\",'+
                '        \"status\":7,'+
                '        \"startdate\":\"2017-09-12T15:11:54Z\",'+
                '        \"enddate\":\"2018-01-10T15:11:54Z\",'+
                '        \"flags\":0,'+
                '        \"firstactivitydate\":\"2017-09-12T15:14:19.937Z\",'+
                '        \"lastactivitydate\":\"2017-09-12T15:15:50.223Z\",'+
                '        \"creationdate\":\"2017-09-12T15:11:54.667Z\",'+
                '        \"creationby\":\"55203470\",'+
                '        \"modifieddate\":\"2017-09-20T19:38:41.393Z\",'+
                '        \"modifiedby\":\"67714119\",'+
                '        \"version\":\"37\",'+
                '    	 \"invalid\":\"Enrollment\",'+
                '        \"course\":{'+
                '          \"id\":\"67740483\",'+
                '          \"title\":\"Kimble Test Course\",'+
                '          \"domainid\":\"67713473\",'+
                '          \"reference\":\"a4W5C000000CcJR\",'+
                '          \"guid\":\"fc652826-3fc6-4c18-8d31-6fd50e3a1037\",'+
                '          \"schema\":3,'+
                '          \"baseid\":\"0\",'+
                '          \"type\":\"Continuous\",'+
                '          \"startdate\":\"2017-09-08T05:00:00Z\",'+
                '          \"enddate\":\"2020-09-09T04:59:59Z\",'+
                '          \"days\":120,'+
                '          \"term\":\"\",'+
                '          \"protection\":0,'+
                '          \"flags\":0,'+
                '          \"creationdate\":\"2017-09-08T13:46:59.48Z\",'+
                '          \"creationby\":\"55203470\",'+
                '          \"modifieddate\":\"2017-09-20T19:07:26.553Z\",'+
                '          \"modifiedby\":\"67714119\",'+
                '          \"mainmodifieddate\":\"2017-09-20T19:07:26.553Z\",'+
                '          \"mainmodifiedby\":\"67714119\",'+
                '          \"version\":\"4\",'+
                '    	   \"invalid\":\"course\"'+
                '        },'+
                '        \"user\":{'+
                '          \"id\":\"67741087\",'+
                '          \"firstname\":\"Shanna\",'+
                '          \"lastname\":\"Stribling\",'+
                '          \"domainid\":\"67713473\",'+
                '          \"reference\":\"a7X5C000000DA2M\",'+
                '          \"guid\":\"856d3636-c393-499a-a3bd-f151d6343a67\",'+
                '          \"username\":\"shanna.stribling@pearson.com\",'+
                '          \"email\":\"shanna.stribling@pearson.com\",'+
                '          \"flags\":0,'+
                '          \"lastpasswordchangeddate\":\"2017-09-08T13:56:07Z\",'+
                '          \"firstlogindate\":\"2017-09-12T15:14:10.563Z\",'+
                '          \"lastlogindate\":\"2017-09-12T15:14:10.563Z\",'+
                '          \"creationdate\":\"2017-09-08T13:56:07Z\",'+
                '          \"creationby\":\"55203470\",'+
                '          \"modifieddate\":\"2017-09-12T15:21:18.283Z\",'+
                '          \"modifiedby\":\"67714119\",'+
                '          \"version\":\"3\",'+
                '    	   \"invalid\":\"User\"'+
                '        }'+
                '      },{'+
                '        \"id\":\"67909234\",'+
                '        \"userid\":\"67741087\",'+
                '        \"courseid\":\"67909148\",'+
                '        \"roleid\":\"40079552\",'+
                '        \"domainid\":\"67713473\",'+
                '        \"reference\":\"\",'+
                '        \"guid\":\"237ffb31-71b2-4466-b44c-a2b944a93930\",'+
                '        \"privileges\":\"2228225\",'+
                '        \"status\":7,'+
                '        \"startdate\":\"2017-09-12T04:00:00Z\",'+
                '        \"enddate\":\"2018-09-13T03:59:59Z\",'+
                '        \"flags\":0,'+
                '        \"firstactivitydate\":\"0001-01-01T00:00:00Z\",'+
                '        \"lastactivitydate\":\"0001-01-01T00:00:00Z\",'+
                '        \"creationdate\":\"2017-09-12T16:03:47.257Z\",'+
                '        \"creationby\":\"67714119\",'+
                '        \"modifieddate\":\"2017-09-20T19:38:11.023Z\",'+
                '        \"modifiedby\":\"67714119\",'+
                '        \"version\":\"4\",'+
                '        \"course\":{'+
                '          \"id\":\"67909148\",'+
                '          \"title\":\"Multiple Resource Capability\",'+
                '          \"domainid\":\"67713473\",'+
                '          \"reference\":\"a4W5C000000CcJb,a4W5C000000CcHO\",'+
                '          \"guid\":\"f34cd77d-d6a2-4482-8d0a-e42bd266c3c3\",'+
                '          \"schema\":3,'+
                '          \"baseid\":\"0\",'+
                '          \"type\":\"Range\",'+
                '          \"startdate\":\"2017-09-12T04:00:00Z\",'+
                '          \"enddate\":\"2018-09-13T03:59:59Z\",'+
                '          \"days\":365,'+
                '          \"term\":\"\",'+
                '          \"protection\":0,'+
                '          \"flags\":0,'+
                '          \"creationdate\":\"2017-09-12T16:01:13.18Z\",'+
                '          \"creationby\":\"67714119\",'+
                '          \"modifieddate\":\"2017-09-20T19:38:28.03Z\",'+
                '          \"modifiedby\":\"67714119\",'+
                '          \"mainmodifieddate\":\"2017-09-20T19:38:28.03Z\",'+
                '          \"mainmodifiedby\":\"67714119\",'+
                '          \"version\":\"5\"'+
                '        },'+
                '        \"user\":{'+
                '          \"id\":\"67741087\",'+
                '          \"firstname\":\"Shanna\",'+
                '          \"lastname\":\"Stribling\",'+
                '          \"domainid\":\"67713473\",'+
                '          \"reference\":\"a7X5C000000DA2M\",'+
                '          \"guid\":\"856d3636-c393-499a-a3bd-f151d6343a67\",'+
                '          \"username\":\"shanna.stribling@pearson.com\",'+
                '          \"email\":\"shanna.stribling@pearson.com\",'+
                '          \"flags\":0,'+
                '          \"lastpasswordchangeddate\":\"2017-09-08T13:56:07Z\",'+
                '          \"firstlogindate\":\"2017-09-12T15:14:10.563Z\",'+
                '          \"lastlogindate\":\"2017-09-12T15:14:10.563Z\",'+
                '          \"creationdate\":\"2017-09-08T13:56:07Z\",'+
                '          \"creationby\":\"55203470\",'+
                '          \"modifieddate\":\"2017-09-12T15:21:18.283Z\",'+
                '          \"modifiedby\":\"67714119\",'+
                '          \"version\":\"3\"'+
                '        }'+
                '      }],'+
                ' 	\"BadField1\":\"EnrollmentsLevel\"'+ 
                '    },'+
                ' 	\"BadField2\":\"ResponseLevel\"'+  
                '  },'+
                ' \"invalidField\":\"Test\"'+    
                '}';
        }else if(result.equalsIgnoreCase('badRequest')){
            this.code=200;
            this.status='OK';
            this.body = '{'+
                '  \"response\":{'+
                '    \"code\":\"BadRequest\",'+
                '    \"message\":\"This API requires a domainid parameter.\",'+
                '    \"errorId\":\"9d3889e088924814a1c5f3eb03a9714e\"'+
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