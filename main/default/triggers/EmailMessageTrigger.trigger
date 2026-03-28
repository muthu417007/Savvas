trigger EmailMessageTrigger on EmailMessage (before insert,before update,after insert,after update) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            ProcessForwardedEmailsToSupportCase.setCaseWebAddressForForwardedEmails(Trigger.new);   
        }
    }
}