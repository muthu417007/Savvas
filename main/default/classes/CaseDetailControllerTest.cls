@isTest
private class CaseDetailControllerTest
{
  /************ no longer needed
    @isTest
    static void itShouldHideSidebarForCommunityUser()
    { 
        PortalTestHelper.setEnv();
        Contact c = PortalTestHelper.createContacts(1)[0];
        insert c;
        User u = PortalTestHelper.createPortalUser(c);
        Case caseVar = PortalTestHelper.createCases(1, u.ContactId)[0];
        insert caseVar;

        CaseDetailController2 ctrl;
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(caseVar);        
        system.runAs(u) {
            ctrl = new CaseDetailController2(stdCtrl);
        }

       // system.assertEquals(false, ctrl.showSidebar);

    }

    @isTest
    static void itShouldShowSidebarForAllUsers()
    {
        PortalTestHelper.setEnv();
        Contact c = PortalTestHelper.createContacts(1)[0];
        insert c;
        Case caseVar = PortalTestHelper.createCases(1, c.Id)[0];
        insert caseVar;

        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(caseVar);        
        CaseDetailController2 ctrl = new CaseDetailController2(stdCtrl);

      //  system.assertEquals(true, ctrl.showSidebar);
    }
    *************************************/
    
    
    @isTest
    static void itShouldNotDisplayAccountNotesForCommunityUser()
    {
        PortalTestHelper.setEnv();
        Contact c = PortalTestHelper.createContacts(1)[0];
        insert c;
        User u = PortalTestHelper.createPortalUser(c);
        Case caseVar = PortalTestHelper.createCases(1, u.ContactId)[0];
        insert caseVar;
        List<Account_Support_Note__c> notes = PortalTestHelper.createAccountSuportNotes(2, c.AccountId);
        insert notes;

        CaseDetailController2 ctrl;
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(caseVar);        
        system.runAs(u) {
            ctrl = new CaseDetailController2(stdCtrl);
        }

        system.assertEquals(0, ctrl.messages.size());

    }
    
    @isTest
    static void itShouldDisplay2AccountNotesForUser()
    {
        PortalTestHelper.setEnv();
        Contact c = PortalTestHelper.createContacts(1)[0];
        insert c;
        Case caseVar = PortalTestHelper.createCases(1, c.Id)[0];
        insert caseVar;
        List<Account_Support_Note__c> notes = PortalTestHelper.createAccountSuportNotes(2, c.AccountId);
        insert notes;

        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(caseVar);        
        CaseDetailController2 ctrl = new CaseDetailController2(stdCtrl);

        system.assertEquals(notes.size() + 1, ctrl.messages.size());
    }

    @isTest
    static void checkStartDateConditionForASN()
    {
        PortalTestHelper.setEnv();
        Contact c = PortalTestHelper.createContacts(1)[0];
        insert c;
        Case caseVar = PortalTestHelper.createCases(1, c.Id)[0];
        insert caseVar;
        Account_Support_Note__c note = PortalTestHelper.createAccountSuportNotes(1, c.AccountId)[0];
        note.StartDate__c = Date.today().addDays(2);
        insert note;

        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(caseVar);        
        CaseDetailController2 ctrl = new CaseDetailController2(stdCtrl);
        system.assertEquals(0, ctrl.messages.size());

        note.StartDate__c = Date.today().addDays(-2);
        update note;

        stdCtrl = new ApexPages.StandardController(caseVar);        
        ctrl = new CaseDetailController2(stdCtrl);
        system.assertEquals(2, ctrl.messages.size());
    }
    
    @isTest
    static void checkExpirationDateConditionForASN()
    {
        PortalTestHelper.setEnv();
        Contact c = PortalTestHelper.createContacts(1)[0];
        insert c;
        Case caseVar = PortalTestHelper.createCases(1, c.Id)[0];
        insert caseVar;
        Account_Support_Note__c note = PortalTestHelper.createAccountSuportNotes(1, c.AccountId)[0];
        note.StartDate__c = Date.today().addDays(-10);
        insert note;

        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(caseVar);        
        CaseDetailController2 ctrl = new CaseDetailController2(stdCtrl);
        system.assertEquals(2, ctrl.messages.size());

        note.ExpirationDate__c = Date.today().addDays(-2);
        update note;

        stdCtrl = new ApexPages.StandardController(caseVar);        
        ctrl = new CaseDetailController2(stdCtrl);
        system.assertEquals(0, ctrl.messages.size());
    }

    @isTest
    static void checkFieldMappingForAccountNotes()
    {
        PortalTestHelper.setEnv();
        Contact c = PortalTestHelper.createContacts(1)[0];
        insert c;
        Case caseVar = PortalTestHelper.createCases(1, c.Id)[0];
        insert caseVar;
        Account_Support_Note__c note = PortalTestHelper.createAccountSuportNotes(1, c.AccountId)[0];
        note.StartDate__c = Date.today().addDays(-10);
        insert note;

        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(caseVar);        
        CaseDetailController2 ctrl = new CaseDetailController2(stdCtrl);
        system.assertEquals(2, ctrl.messages.size());
        system.assertEquals(true, ctrl.messages[0].isTitle);
        system.assertEquals('Account Support Notes', ctrl.messages[0].content);
        system.assertEquals(false, ctrl.messages[1].isTitle);
        system.assertEquals(note.Message__c, ctrl.messages[1].content);
        system.assertEquals(note.Type__c, ctrl.messages[1].type);
        system.assertEquals(note.ExpirationDate__c, ctrl.messages[1].expirationDate);
        system.assertEquals(note.StartDate__c, ctrl.messages[1].startDate);
    }
    
    @isTest
    static void itShouldNotDisplayContactNotesForCommunityUser()
    {
        PortalTestHelper.setEnv();
        Contact c = PortalTestHelper.createContacts(1)[0];
        insert c;
        User u = PortalTestHelper.createPortalUser(c);
        Case caseVar = PortalTestHelper.createCases(1, u.ContactId)[0];
        insert caseVar;
        List<Contact_Support_Note__c> notes = PortalTestHelper.createContactSuportNotes(2, c.Id);
        insert notes;

        CaseDetailController2 ctrl;
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(caseVar);        
        system.runAs(u) {
            ctrl = new CaseDetailController2(stdCtrl);
        }

        system.assertEquals(0, ctrl.messages.size());

    }
    
    @isTest
    static void itShouldDisplay2ContactNotesForUser()
    {
        PortalTestHelper.setEnv();
        Contact c = PortalTestHelper.createContacts(1)[0];
        insert c;
        Case caseVar = PortalTestHelper.createCases(1, c.Id)[0];
        insert caseVar;
        List<Contact_Support_Note__c> notes = PortalTestHelper.createContactSuportNotes(2, c.Id);
        insert notes;

        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(caseVar);        
        CaseDetailController2 ctrl = new CaseDetailController2(stdCtrl);

        system.assertEquals(notes.size() + 1, ctrl.messages.size());
    }

    @isTest
    static void checkStartDateConditionForCSN()
    {
        PortalTestHelper.setEnv();
        Contact c = PortalTestHelper.createContacts(1)[0];
        insert c;
        Case caseVar = PortalTestHelper.createCases(1, c.Id)[0];
        insert caseVar;
        Contact_Support_Note__c note = PortalTestHelper.createContactSuportNotes(1, c.Id)[0];
        note.StartDate__c = Date.today().addDays(2);
        insert note;

        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(caseVar);        
        CaseDetailController2 ctrl = new CaseDetailController2(stdCtrl);
        system.assertEquals(0, ctrl.messages.size());

        note.StartDate__c = Date.today().addDays(-2);
        update note;

        stdCtrl = new ApexPages.StandardController(caseVar);        
        ctrl = new CaseDetailController2(stdCtrl);
        system.assertEquals(2, ctrl.messages.size());
    }
    
    @isTest
    static void checkExpirationDateConditionForCSN()
    {
        PortalTestHelper.setEnv();
        Contact c = PortalTestHelper.createContacts(1)[0];
        insert c;
        Case caseVar = PortalTestHelper.createCases(1, c.Id)[0];
        insert caseVar;
        Contact_Support_Note__c note = PortalTestHelper.createContactSuportNotes(1, c.Id)[0];
        note.StartDate__c = Date.today().addDays(-10);
        insert note;

        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(caseVar);        
        CaseDetailController2 ctrl = new CaseDetailController2(stdCtrl);
        system.assertEquals(2, ctrl.messages.size());

        note.ExpirationDate__c = Date.today().addDays(-2);
        update note;

        stdCtrl = new ApexPages.StandardController(caseVar);        
        ctrl = new CaseDetailController2(stdCtrl);
        system.assertEquals(0, ctrl.messages.size());
    }

    @isTest
    static void checkFieldMappingForContactNotes()
    {
        PortalTestHelper.setEnv();
        Contact c = PortalTestHelper.createContacts(1)[0];
        insert c;
        Case caseVar = PortalTestHelper.createCases(1, c.Id)[0];
        insert caseVar;
        Contact_Support_Note__c note = PortalTestHelper.createContactSuportNotes(1, c.Id)[0];
        note.StartDate__c = Date.today().addDays(-10);
        insert note;

        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(caseVar);        
        CaseDetailController2 ctrl = new CaseDetailController2(stdCtrl);
        system.assertEquals(2, ctrl.messages.size());
        system.assertEquals(true, ctrl.messages[0].isTitle);
        system.assertEquals('Contact Support Notes', ctrl.messages[0].content);
        system.assertEquals(false, ctrl.messages[1].isTitle);
        system.assertEquals(note.Message__c, ctrl.messages[1].content);
        system.assertEquals(note.Type__c, ctrl.messages[1].type);
        system.assertEquals(note.ExpirationDate__c, ctrl.messages[1].expirationDate);
        system.assertEquals(note.StartDate__c, ctrl.messages[1].startDate);
    }
    
}