// Note: salesforce limits us to 10 email sends per execution context
global class ScheduleRenewalSvcContractEmails implements Schedulable {
    global void execute(SchedulableContext ctx) {
        sendRenewalEmailForServiceContract s = new sendRenewalEmailForServiceContract();
        s.sendEmails();
    }
}