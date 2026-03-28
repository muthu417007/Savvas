@isTest private class JIRAConnectorWebserviceCalloutSyncTest {
 
    // Tests synchronizeWithJIRAIssue method in JIRAConnectorWebserviceCalloutSync.
    static testMethod void synchronizeWithJIRAIssueTest() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseJIRAConnector());
        JIRAConnectorWebserviceCalloutSync.synchronizeWithJIRAIssue(TestFixture.baseUrl, TestFixture.systemId, TestFixture.objectType, TestFixture.caseId);
        Test.stopTest();
    }
 
    // Tests buildRequest method in JIRAConnectorWebserviceCalloutSync.
    static testMethod void buildRequestTest() {
        HttpRequest req = JIRAConnectorWebserviceCalloutSync.buildRequest(TestFixture.baseUrl, TestFixture.username,
                TestFixture.password, TestFixture.systemId, TestFixture.objectType, TestFixture.caseId);
        System.assertEquals(req.getMethod(), 'PUT');
        System.assertEquals(req.getEndpoint(), 'http://jira.com/rest/customware/connector/1.0/1/Case/1/issue/synchronize.json');
    }
 
    // Tests SynchronizeWithJIRAIssue trigger.
    static testMethod void synchronizeWithJIRAIssueTriggerTest() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseJIRAConnector());
        // insert case
        Case case1 = new Case();
        case1.Subject = 'Test Jira Case';
        insert case1;
 
        //update case
        case1.Description = 'updated case description';
        update case1;
    }
 
    // Tests caseCommentSync trigger.
    static testMethod void caseCommentSyncTriggerTest() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseJIRAConnector());
        // insert case
        Case case1 = new Case();
        case1.Subject = 'Test Jira Case';
        insert case1;
 
        // insert casecomment
        CaseComment caseComment = new CaseComment();
        caseComment.ParentId = case1.id;
        insert caseComment;   
    }
     
}