/**************************************************************************************** 
* @Class Name  - scc_resend_AccessCode_Controller
* @description - This class will send resend access code via email
* @Created By  - CTS-Sagar Verma
* @Created On - 2024-07-26 
* ***************************************************************************************/ 
public without sharing class scc_resend_AccessCode_Controller {
    /********************************************************************** 
Method Name :  sendResendAccess
Description :  Method to send resend access code via email
Input       :   String, String, List
Return type :  N/A
***********************************************************************/ 
    @AuraEnabled 
    public static void sendResendAccess(String eAddrs, String orderNumber, List<String> eAccessCodes) {
        
        String orderId = [SELECT Id FROM Order WHERE SAP_Document_Number__c = :orderNumber LIMIT 1].Id;
        List<EAccess_List__c> eAccessList = [
            SELECT Id, EAccess_Code__c, ISBN__c, ProductId__r.Description, Order__c, Order__r.BillingName__c,
            SAP_Doc_Number__c, Order__r.OrderNumber, EAccess_Imprints__r.Email_SpecificInstructions__c,
            ProductId__r.ProductCode
            FROM EAccess_List__c 
            WHERE Order__c = :orderId AND EAccess_Code__c IN :eAccessCodes
        ];
        
        if(eAccessList.size() > 0){
            String activeOrderList = eAccessList[0].Id;  
            
            
            String tableContent = '<table style="border-collapse: collapse; width:100%;">';
            tableContent += '<tr><th style="border: 1px solid black; padding:8px;">ISBN</th><th style="border: 1px solid black; padding:8px;">DESCRIPTION</th><th style="border: 1px solid black; padding:8px;">CODE</th></tr>';
            for (EAccess_List__c eac : eAccessList) { 
                tableContent += '<tr>';
                tableContent += '<td style="border: 1px solid black; padding:8px;">' + (eac.ProductId__r.ProductCode != null ? eac.ProductId__r.ProductCode:'')+ '</td>';
                tableContent += '<td style="border: 1px solid black; padding:8px;">' + (eac.ProductId__r.Description != null ? eac.ProductId__r.Description:'') + '</td>';
                tableContent += '<td style="border: 1px solid black; padding:8px;">' + (eac.EAccess_Code__c != null ? eac.EAccess_Code__c:'') + '</td>';
                tableContent += '</tr>';
            } 
            tableContent += '</table>';
            List<String> eList = eAddrs.split(',');
            EmailTemplate emailTemplate = [SELECT Id, Body,Subject, HtmlValue FROM EmailTemplate where Name = 'Scc_Resend_Access_Code_Internal' LIMIT 1];    
            String subject = emailTemplate.Subject;
            subject = subject.replace('{!Eaacess}', 'E-Access Codes');
            String emailBody = emailTemplate.HtmlValue;
            emailBody = emailBody.replace('{!TableContent}', tableContent);        
            emailBody = eAccessList[0].Order__c != null && eAccessList[0].Order__r.OrderNumber != null ?emailBody.replace('{!Order__r.OrderNumber}', eAccessList[0].Order__r.OrderNumber):emailBody.replace('{!Order__r.OrderNumber}','');
            emailBody = emailBody.replace('{!SAP_Doc_Number__c}', eAccessList[0].SAP_Doc_Number__c);
            emailBody = eAccessList[0].Order__c != null && eAccessList[0].Order__r.BillingName__c != null ?emailBody.replace('{!Order__r.BillingName__c}', eAccessList[0].Order__r.BillingName__c):emailBody.replace('{!Order__r.BillingName__c}','');
            emailBody = eAccessList[0].EAccess_Imprints__c != null && eAccessList[0].EAccess_Imprints__r.Email_SpecificInstructions__c != null ?emailBody.replace('{!EAccess_Imprints__r.Email_SpecificInstructions__c}', eAccessList[0].EAccess_Imprints__r.Email_SpecificInstructions__c):emailBody.replace('{!EAccess_Imprints__r.Email_SpecificInstructions__c}','');
            
            List<Messaging.SingleEmailMessage> mList = new List<Messaging.SingleEmailMessage>();
            for (String e : eList) {
                Messaging.SingleEmailMessage mCart = new Messaging.SingleEmailMessage();
                mCart.setToAddresses(new List<String> { e.trim() });
                mCart.setTemplateId(emailTemplate.Id);
                mCart.setTargetObjectId(UserInfo.getUserId());
                mCart.setSaveAsActivity(false);
                mCart.setSubject(subject);
                mCart.setHtmlBody(emailBody);
                mList.add(mCart);            
            } 
            Messaging.sendEmail(mList);
        }
    }
}