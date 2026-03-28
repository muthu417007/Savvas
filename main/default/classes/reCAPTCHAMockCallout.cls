@isTest
public class reCAPTCHAMockCallout implements HttpCalloutMock {
    // Implement this interface method
    public HTTPResponse respond(HTTPRequest req) {
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setBody('true');
        res.setStatusCode(200);
        return res;
    }
}