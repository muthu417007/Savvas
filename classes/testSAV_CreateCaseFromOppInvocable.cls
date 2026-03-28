@isTest
public class testSAV_CreateCaseFromOppInvocable {

    @testSetup static void setup() {
        // Create common test accounts and Opportunities
        List<account> acclist = new List<account>();
        Account[] accts = TestDataFactory.createAccountsWithOppsAndCont(1,1,0);
        List<Opportunity> oppList=new list<Opportunity>();
        
        for(Opportunity o:[Select Id,Name from Opportunity where accountId =:accts]){
            o.Name='Opportunity ' + o.Name + ' Closed';
            o.Discipline_and_Grade_Band__c = 'Intervention 6-8';
            oppList.add(o);
        }
        update oppList;
    }
    
    public static testMethod void createCaseFromRenewalOpportunity() {
        
        list<Account> acctList = [SELECT Id FROM Account Limit 1];
        
        list<Opportunity> testOppList = [SELECT Id, Name FROM Opportunity WHERE accountId IN :acctList Limit 1];
        system.debug('test opp list size: ' + testOppList.size());
        list<Id> oppIds  = new list<Id>();
        String testOppName;
        //list<Case> testCase = new list<Case>();
        for(Opportunity o : testOppList){
            oppIds.add(o.Id);
            testOppName = o.Name;
            system.debug('test opp name: ' + testOppName);
        }

        List<Group> queueGroup = [select Id from Group where Type = 'Queue' AND 
                                  NAME = 'Intervention System Cleanup' Limit 1];
        Id qId;
        for(Group g : queueGroup){
            qId = g.Id;
        }
        system.debug('id of queue for case ownership:' + qId);        
        integer caseCount;
        caseCount = [select count() from Case where OwnerId =:qId];
        system.debug('case count: '  + caseCount);
        
        Test.startTest();
        system.debug(' call SAV_OpportunityToCase next');
        SAV_CreateCaseFromOpportunityInvocable.createCaseFromRenewalOpportunity(oppIds);
        system.debug('back in test method');

        integer newCaseCount = [select count() from Case where OwnerId =:qId];
        system.debug('newCaseCount: ' + newCaseCount);
        integer expectedCount = caseCount + 1;
        system.assert(expectedCount == newCaseCount);
        Test.stopTest();
        system.debug('test method end');
        
    }

}