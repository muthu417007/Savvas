global class scheduledSendRenewalEmail implements Schedulable{
    global void execute(SchedulableContext sc){

        sendRenewalEmailForServiceContract s = new sendRenewalEmailForServiceContract();
		s.sendEmails(); 
    }
}