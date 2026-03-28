/*
Class Name: ScheduleApexReport
Purpose : This class is used to send report to external users(Pearson Employees) who are not in salesforce.
          Utilize ApexReport__mdt metadata type to configure Email addresses, Email body and Subject. Use Metadata lable
          to configure report(use report developer name) which to send in email.
*/
global class ScheduleApexReport implements System.Schedulable {
global void execute(SchedulableContext sc) {
        //Collecting email configurations and report details.
       List<ApexReport__mdt> lstar=[select id,label,SendToEmails__c,EmailBody__c,Email_Subject__c from ApexReport__mdt];
       for(ApexReport__mdt ar:lstar){
         List<string> sendEmail=new List<string>();
         if(ar.SendToEmails__c!=null){
             sendEmail = ar.SendToEmails__c.split(',');
             if(sendEmail.size()>0){
                 System.debug('ar.label+++'+ar.label);
                 //below class untilized to send email, "SendReport" function is @Future method.
                 cls_sendreport_to_extUsers.sendReport(ar.label,sendEmail,ar.EmailBody__c,ar.Email_Subject__c);
             }
         }
        
       }
   }
}