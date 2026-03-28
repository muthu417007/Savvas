@isTest
public class Milestone1_Time_Trigger_Utility_Test {
static testMethod void testTriggerUtility()
    {
        List<Milestone1_Time__c> recs = new List<Milestone1_Time__c>{new Milestone1_Time__c()};
        Milestone1_Time_Trigger_Utility.handleTimeBeforeTrigger(recs);
        for(Milestone1_Time__c rec : recs)
        {
            System.assertEquals(UserInfo.getUserId(),rec.Incurred_By__c);
            System.assertEquals(Date.today(),rec.Date__c);
        }
    }
}