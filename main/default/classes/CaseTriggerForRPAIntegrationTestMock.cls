/*
* class name: CaseTriggerForRPAIntegrationTestMock
* description: Mock class for CaseTriggerForRPAIntegrationTest
* created by: Praveen Tharala
*/

@isTest
global class CaseTriggerForRPAIntegrationTestMock implements HttpCalloutMock {
    Map<String, String> requests;
    public CaseTriggerForRPAIntegrationTestMock(Map<String, String> requests){
        this.requests = requests;
        system.debug('request === '+requests);
    }
    //Fake response
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        if(req.getEndpoint().contains('base64_upload') || req.getEndpoint().contains('file_path_request'))
        	res.setBody('{"data" : [["1","2","3"]]}');
        else if(req.getEndpoint().contains('DataExtraction')){
            if(requests.containsKey('dummy')){
                res.setBody(requests.get('dummy'));
            }
            else if(requests.containsKey('nondummy')){
                res.setBody(requests.get('nondummy'));
            }
        }
        else if(req.getEndpoint().contains('InsertFeedbackData')){
            res.setStatus('Success');
        }
        else
            res.setBody('{"text": "test", "labels": [{"label": "Others", "confidence": 1.0}]}');
        res.setStatusCode(200);
        return res;
    }
}