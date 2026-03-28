@isTest
public class Milestone1_Charts_Gantt_Helper_test {

    static testMethod void testController() {
		
		Milestone1_Project__c proj = Milestone1_Test_Utility.sampleProject('Basic Sample For Test' + DateTime.now().getTime());
		insert proj;
		
		ApexPages.StandardController stc = new ApexPages.StandardController(proj);
        Milestone1_Charts_Gantt_Helper cont = new Milestone1_Charts_Gantt_Helper(stc);
		System.assert(cont.myId != null);
		
		
	}

}