/*
 * Version: 8/9/2021 Charles Teague 
 * Note: salesforce limits us to 10 email sends per execution context
 * Purpose: send emails to customers whose subscriptions will expire.
 * Objects used: mainly ServiceContract, ContractLineItem. Also gets info from Account.
 * Updates ServiceContract; adds to Account an Attachment (PDF) and an Activity History entry showing
 * that the email was sent. 
 * Data used for the email is loaded from external source to ServiceContract and ContractLineItem
 * (currently this data comes from SAP), so correctness of data is dependent on that data load.
 * Query to get ServiceContracts to process checks for Renewal_Email_Sent_Date__c = null;
 * code updates this to the current day as final step, so the record will be ignored on next run. 
 * This means we only expect to send an email to the customer once.
 */
public class SendRenewalEmailForServiceContract {

    public void sendEmails()
    {
    Map<Id,ServiceContract> serviceContractsToProcess = new Map<Id,ServiceContract>([Select Id, Account_Number__c,  
                        Renewal_Contract_ID__c, Renewal_Contract_Version__c, StartDate, EndDate, 
                        Bill_To_SAP_ID__c, Bill_To_Name__c, Contact_Name__c, AE_Name_For_Display__c, 
                        Email_Recipients__c, Email_Reply_To_Address__c, Email_CC_addresses__c, Email_Addressess_BCC__c, 
                        AE_Email_For_Display__c, Name, AccountId, AccountOwnerId__c,
                        Bill_To_Address__c, Bill_To_City__c, Bill_To_State__c, Bill_To_Zip__c, 
                        Renewal_Email_Sent_Date__c, Total_Line_Item_Dollars__c                                                                   
                        from ServiceContract 
                        where Renewal_Email_Sent_Date__c = null 
                        Order by Id Limit 10]); 
   // system.debug(' GOT SERVICE CONTRACTS');
    EmailTemplate emailBodyTmplt = [select Id from EmailTemplate where Name = 'Contract Renewal Email from Service Contract'];
    EmailTemplate contractDetailsTmplt = [select Id from EmailTemplate where Name = 'Contract Renewal Details'];

    List<Event> emailSentEvents = new List<Event>();
    List<ServiceContract> serviceContractsToUpdate = new List<ServiceContract>();
    List<Attachment> acctAttachments = new List<Attachment>();

    List<string> aeEmailList = new List<String>(); 
    //system.debug(' GOT AE EMAIL LIST');
    String aeEmailAddress = ''; 
    String firstAEemail = ''; 
    User tmpltWhoUser;
    String poEmailSubmissions = 'k12customerservice@savvas.com'; 
    OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'k12customerservice@savvas.com'];

    for(ServiceContract svc : serviceContractsToProcess.values())
    {
            aeEmailAddress = svc.AE_Email_For_Display__c;
            aeEmailList = aeEmailAddress.split(';');
            firstAEemail = aeEmailList[0];  
           // system.debug('firstAEemail >> ' + firstAEemail);
            tmpltWhoUser = [select Id, Email from User where Email =: firstAEemail Limit 1];
           // System.Debug('tmpltWhoUser - retrieved');
            Messaging.SingleEmailMessage msg = Messaging.renderStoredEmailTemplate(contractDetailsTmplt.Id, null, svc.Id);
            String contractAttachment = msg.getHtmlBody(); // need to insert the customer service email address into the attachment
            String finishedAttachment = contractAttachment.replace('[[WillBeReplacedWithCustomerServiceEmailAddress]]',poEmailSubmissions);

            msg = Messaging.renderStoredEmailTemplate(emailBodyTmplt.Id, null, svc.Id);
           // system.debug('owea: '+owea);
            if (owea.size() > 0){
                msg.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            String body = msg.getHtmlBody();
            String finishedBody = body.Replace('[[WillBeReplacedWithCustomerServiceEmailAddress]]',poEmailSubmissions);
            msg.setTargetObjectId(tmpltWhoUser.Id);
            msg.setHtmlBody(finishedBody);
            msg.saveAsActivity = false;
            
                String sender = svc.AE_Name_For_Display__c;
                if(String.isEmpty(sender))
                {
                    sender = 'Savvas Contract Renewal';
                }
                //msg.SetSenderDisplayName(sender);
            
                String replyToaddr = svc.Email_Reply_To_Address__c;
                if(String.isEmpty(replyToaddr))
                {
                    replyToaddr = 'k12customerservice@savvas.com';
                }
                msg.setReplyTo(replyToaddr);
            
                String subjectLine = svc.Name;
                if(String.isNotEmpty(subjectLine))
                {
                    subjectLine = subjectLine.Replace('contract','');
                    subjectLine = subjectLine.Replace('Contract','');
                    subjectLine = subjectLine.Replace('CONTRACT','');
                    subjectLine = subjectLine.Replace('customer','');
                    subjectLine = subjectLine.Replace('Customer','');
                    subjectLine = subjectLine.Replace('CUSTOMER','');
                    subjectLine = subjectLine.Replace(':','');
                } 
                else 
                {
                    subjectLine = '';
                }
                msg.SetSubject('Contract Renewal: ' + subjectLine);
             //   System.Debug('emailRecipients - next');
                            list<string> emailRecipients = svc.Email_Recipients__c.split(';');
                        //    System.Debug('emailRecipients set');
                            msg.SetToAddresses(emailRecipients);
                            
                            if(String.isNotEmpty(svc.Email_CC_addresses__c))
                            {
                                list<string> ccRecipients = svc.Email_CC_addresses__c.split(';'); 
                                msg.setCcAddresses(ccRecipients);
                            }
                            if(String.isNotEmpty(svc.Email_Addressess_BCC__c))
                            {
                                list<string> bccRecipients = svc.Email_Addressess_BCC__c.split(';'); 
                                msg.setBccAddresses(bccRecipients);
                            } 

            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.body = blob.toPdf(finishedAttachment);
            efa.filename = 'ContractRenewalDetails.pdf';
             //       System.Debug(' file attachments next');
            List<Messaging.EmailFileAttachment> faList = new List<Messaging.EmailFileAttachment>();
            faList.add(efa);
            msg.setFileAttachments(faList);
             //       System.Debug('message next');
        try{

     

            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {msg});

                svc.Renewal_Email_Sent_Date__c = date.today();
                serviceContractsToUpdate.add(svc);

                Attachment attachmentPDF = new Attachment();
                attachmentPDF.parentId = svc.AccountId;
                attachmentPDF.name = 'ContractRenewalEmail_' + svc.Renewal_Contract_ID__c + '.pdf';
                attachmentPDF.Body = efa.body; 
                acctAttachments.add(attachmentPDF);
                
                Event event = new Event(
                    OwnerId = svc.AccountOwnerId__c,
                    CreatedById = svc.AccountOwnerId__c,
                    WhatId = svc.AccountId,
                    StartDateTime = datetime.now(),
                    EndDateTime = datetime.now(),
                    Subject = 'Contract Renewal Email Sent Contract: ' + svc.Renewal_Contract_ID__c, 
                    Description = 'Renewal Contract ID: ' + svc.Renewal_Contract_ID__c + ', Start Date: ' + svc.StartDate.format()  
                    + ', End Date: ' + svc.EndDate.format() + ', Email to: ' + svc.Email_Recipients__c 
                    + ', Email CC to: ' + svc.Email_CC_addresses__c);

                emailSentEvents.Add(event);

      } Catch (EmailException ex){
          System.Debug('ERROR - ERROR');
          System.Debug(ex.getCause());
      }

        aeEmailAddress = '';
        firstAEemail = '';
          
    }

    if(emailSentEvents.Size() > 0) {insert emailSentEvents;}
    if(acctAttachments.Size() > 0) {insert acctAttachments;}
    if(serviceContractsToUpdate.Size() > 0){update serviceContractsToUpdate;}
 }
 }