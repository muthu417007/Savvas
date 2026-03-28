/**************************************************************************************** 
* @Class Name  - scc_welcomeEmailTrigger
* @description - Trigger to send welcome email if internal user create a User record
* @Created By  - CTS-Muthukumar
* @Created On - 2024-10-26
* ***************************************************************************************/ 
trigger scc_welcomeEmailTrigger on User (after insert) {    
    
    Profile  p =[select id from profile where Name='Savvas External Users Base Profile' limit 1];
    for(User newUser : Trigger.new) {        
        try{
        Id updatedUserId = newUser.Id;
        Id profileId=newUser.ProfileId;
        if(profileId == p.Id){
            if(newUser.Ordering_Enabled__c == true || newUser.checkStatusPriceAvailability__c  == true  ){
                Set <Id> customIds= new Set <Id>();
                for(scc_EnableUserAdmins__c enableuserIds: [SELECT SetupOwnerId FROM scc_EnableUserAdmins__c WHERE Trigger_welcome_email__c = true ]){
                    customIds.add(enableuserIds.SetupOwnerId);
                }
                if(customIds.contains(newUser.CreatedById)){
                   String welcomeTemplateName = System.Label.scc_WelcomeEmailTemplateName   ;
                  // scc_registrationformController.sendWelcomeEmail(updatedUserId,welcomeTemplateName);
                   System.ResetPasswordResult result = System.resetPasswordWithEmailTemplate(updatedUserId, true, welcomeTemplateName);
               }
            }
           } 
        }catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());   
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
        }
    }
}