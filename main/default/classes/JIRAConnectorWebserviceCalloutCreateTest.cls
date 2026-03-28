@isTest private class JIRAConnectorWebserviceCalloutCreateTest {
 
    // Tests createIssue method in JIRAConnectorWebserviceCalloutCreate.
    static testMethod void createIssueTest() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseJIRAConnector());
        JIRAConnectorWebserviceCalloutCreate.createIssue(TestFixture.baseUrl, TestFixture.systemId,
                TestFixture.objectType, TestFixture.objectId, TestFixture.projectKey, TestFixture.issueType);
        Test.stopTest();
    }
 
    // Tests buildRequest method in JIRAConnectorWebserviceCalloutCreate.
    static testMethod void buildRequestTest() {
        HttpRequest req = JIRAConnectorWebserviceCalloutCreate.buildRequest(TestFixture.baseUrl, TestFixture.username,
                TestFixture.password, TestFixture.systemId, TestFixture.objectType, TestFixture.objectId,
                TestFixture.projectKey, TestFixture.issueType);
        System.assertEquals(req.getMethod(), 'POST');
        System.assertEquals(req.getEndpoint(), 'http://jira.com/rest/customware/connector/1.0/1/Case/1/issue/create.json');
    }
 
}