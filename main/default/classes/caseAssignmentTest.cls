@isTest
public class caseAssignmentTest {
    @testSetup
    static void setup() {
        Account acc=new Account();
        acc.Name='Test Case Assignment';
        acc.Type='College';
        Contact con=new Contact();
        con.AccountId=acc.id;
        con.FirstName='test';
        con.LastName='test';
        con.Email='test@test.com';
        Case myCase = new Case();
        myCase.Subject = 'Test Case';
        myCase.Status='New';
        myCase.RPA_ORDER_AMOUNT__c=1000;
        myCase.Origin='Phone';
        myCase.ContactId=con.Id;
        myCase.AccountId=acc.Id;
        insert myCase;
    }
    
    @isTest
    static void testCaseAssign() {
        List<Case> cases = [SELECT Id FROM Case LIMIT 1];
        Id caseId = cases[0].Id;
        List<Id> caseIds = new List<Id>{caseId};
        CaseAssignmentusingFlow.caseAssign(caseIds);
        Case updatedCase = [SELECT Id, OwnerId FROM Case WHERE Id = :caseId];
        System.assertEquals(true, updatedCase.OwnerId != null);
    }



}