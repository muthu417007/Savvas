/*
*********************************************************
Class Name       : Sbqq_QuoteLine_TriggerHandler
Created Date     : 12/02/2024  
Author           : Frank Berni - Cognizant
Description      : Handler class for the SBQQ__QuoteLine__c Trigger

History:
<Date>          <Authors Name>              <Brief Description of Change>
12/02/2024       Frank Berni                 Initial creation: Ticket W-016653 
**********************************************************/
public with sharing class Sbqq_QuoteLine_TriggerHandler {
    
    
    public static void beforeDeleteMethod(List<SBQQ__QuoteLine__c> oldList) {
        
        // W-016653: Call method to prevent non-admin users from deleting quote lines when quote is not in "Draft" status
        preventNonDraftDelete(oldList);

    }

    /*****************************************************************************************************
    ***********************************   Helper Methods     *********************************************
    *****************************************************************************************************/

    /*
    *********************************************************
    Method Name    : preventNonDraftDelete
    Author         : Frank Berni
    Description    : W-016653: Prevents non-admin users from deleting quote lines when quote is not in "Draft" status
    Param          : List<SBQQ__Quote__c> oldQlList
    return         : Error
    ********************************************************
    */
    public static void preventNonDraftDelete(List<SBQQ__QuoteLine__c> oldQlList) {
        for (SBQQ__QuoteLine__c qline : oldQlList){
            // Checking if Quote's Status is not Draft AND user's Running Profile is not System Admin
            if(qline.Quote_Status__c != 'Draft' && qline.Running_Profile__c != 'System Administrator') {

                // Throw error to prevent delete
                qline.addError('You can only delete Quote Lines when Quote is in Draft status');
            }  

        }
    }
}