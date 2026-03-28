public class TestAPIClass {
    public static void preparePostRequest() {
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setEndpoint('http://qa.selfhelp.lsk12.com//radartoken');
        httpRequest.setMethod('POST');
        httpRequest.setTimeout(120000);
        httpRequest.setHeader('Content-Type','application/x-www-form-urlencoded');
        httpRequest.setBody('username=radar&password=radar&grant_type=password');
        /*String body = '"mode": "formdata", ' +
              '  "formdata": [ ' +
              '        { ' +
              '            "username": "radar", ' +
              '            "password": "radar", ' +
              '              "src": "...",   ' +
              '            "disabled": true' +
              '        }' +
              '      ]';*/
        Http http = new Http();
        HttpResponse res = http.send(httpRequest);
        system.debug(res.getBody());
    }
}