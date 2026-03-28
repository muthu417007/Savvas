@isTest
public class Milestone1_Summary2_Test {
 
    static TestMethod void testController() {
        
        //make sure it shows active projects
        Milestone1_Summary2 summary2 = new Milestone1_Summary2();
        
        //important for new installs
        if (summary2.settings == null) {
            summary2.settings = new Milestone1_Settings__c();
        }
        
        if (summary2.settings.Report_Id_Blocked_Tasks_by_Project__c == null) {
            summary2.settings.Report_Id_Blocked_Tasks_by_Project__c = 'a';
            summary2.settings.Report_Id_My_tasks_by_project__c = 'b';
            summary2.settings.Report_Id_Overdue_Tasks_by_Project__c = 'c';
        }
        
        Integer i = summary2.getProjects().size();
        
        Milestone1_Project__c p1 = Milestone1_Test_Utility.sampleProjectActive('Controller Test');
        insert p1;


        
        //make sure we get page references back
        summary2.targetProject = p1.id;
        
        System.assert(summary2.view() != null);
        System.assert(summary2.viewMyTasks() != null);
        System.assert(summary2.viewBlockedTasks() != null);
        System.assert(summary2.viewOverdueTasks() != null);
        
        summary2.initialize();
        System.assert(summary2.recentItems != null);
        
        //Test.setFixedSearchResults(new Id[] {p1.Id});
        summary2.searchText = 's';
        summary2.searchProjects();
        System.assertEquals(true, summary2.hasSearchLengthError);
        
        
        summary2.searchText = 'Test';
        summary2.searchProjects();
        System.assert(summary2.hasSearchResultsError);
        System.assert(!summary2.hasProjectResults);
        System.assert(!summary2.hasMilestoneResults);
        System.assert(!summary2.hasTaskResults);
        
        
        
        System.assertEquals(1, summary2.pageNumber);
        
        
        if(summary2.hasNext == true)
        {
        	summary2.next();
        }
        if(summary2.hasPrevious == true)
        {
        	summary2.previous();
        }
        
    }
}