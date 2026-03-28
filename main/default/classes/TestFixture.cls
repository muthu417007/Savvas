@isTest public with sharing class TestFixture {
 
    // All fields in this class are used only in unit tests.
    // No need to change, but make sure to change the unit tests respectively if you change these values.
    public static String baseUrl = 'http://jira.com';
    public static String systemId = '1';
    public static String username = 'yourJIRAusername';
    public static String password = 'yourJIRApassword';
 
    public static String objectType = 'Case';
    public static String objectId = '1';
    public static String projectKey = 'salesforce';
    public static String issueType = 'bug';
    public static String caseId = '1';
 
    public static String jiraIssueResponseBody = '[{"summary": "Project One", "project": "project one", ' +
        '"reporter": "admin@gmail.com", "key": "PO-1", "status": "open", ' +
        '"resolution": "yes", "url": "www.google.com", "type": "bug", "assignee": "admin", ' +
        '"description": "issue 1", "priority": "high", "due_date": "12-12-2015" },' +
        '{"summary": "Project Two", "project": "project two"}]';
     
}