/*
Class Name: ScheduleApexReport_Test 
Purpose : This test class is used to do code coverage for below classes.
         1) ScheduleApexReport 
         2) cls_EmailService 
         3) cls_sendreport_to_extUsers 
 
*/
@isTest(seeAllData='true') // Made this true, because in dependant classes we are fetching report names via SOQL to send in email
public class ScheduleApexReport_Test {
    public static testMethod void Test_SendingReport(){
        Test.startTest();  
        ScheduleApexReport  obj = new ScheduleApexReport();  
        obj.execute(null);  
        Test.stopTest();  
    }
}