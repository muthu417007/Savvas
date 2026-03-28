/*
Apex Trigger:scc_ERPNotificationTrigger
Author: CTS (Dhiyaneshwari)
Created Date: 26/07/2024
Modified Date:
*/
trigger scc_ERPNotificationTrigger on Order_Notification_from_ERP__e (after insert) {
    for (Order_Notification_from_ERP__e event : Trigger.New) {
        String orderId = event.Order_ID__c;
        String accountId = event.Account_ID__c;
        String token = event.Token__c;
        String poNumber = event.PO_Number__c;

        scc_ERPNotificationHandler.updateOrder(accountId, orderId, token, poNumber);
    }
}