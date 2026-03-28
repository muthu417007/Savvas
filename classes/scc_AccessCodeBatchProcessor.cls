public class scc_AccessCodeBatchProcessor implements Database.Batchable<sObject>,Database.Stateful
 {
    private String ordId = '';
    Boolean outputboolean = false;
    Set<String> outputimprints = new Set<String>() ;
    List<Order> ord = new List<Order>();
    List<String> accessCodeforEmail = new List<String>();
    List<String> customerEmailCollection = new List<String>();
    List<EAccess_List__c> outputaccessList = new List<EAccess_List__c>();
    List<String> exCodes = new List<String>();
    String emailString = '';
    Map<String,Integer> isbnQntMap = new Map<String,Integer>();
    Map<String,Decimal> isbnQuantityMap = new Map<String,Decimal>();
    Map<String,Integer> isbnQntCodesMap = new Map<String,Integer>();
    Set<String> isbnCodes = new Set<String>();
    Map<String,Decimal> isbnQuantityMapCounter = new Map<String,Decimal>();
    List<EAccess_List__c> eaccessCodesReturn = new List<EAccess_List__c>();
    List<noAccessCodeWrapper> noaccessWrapper = new List<noAccessCodeWrapper>();
    Set<String> imprintcodes = new Set<String>();
    
    Map<String, String> accesscodeisbn = new Map<String, String>();
    Map<String, String> isbnImprintEmailsMap1 = new Map<String, String>();
    Map<String, String> isbnImprintEmailsMap2 = new Map<String, String>();
    Map<String, Id> isbnImprintIdMap = new Map<String, Id>();
    List<String> accessCodesList = new List<String>();
    public scc_AccessCodeBatchProcessor(String orderId) {
        this.ordId = orderId;
        ord = [SELECT id, Customer_Email__c,BillingName__c,SAP_Document_Number__c,PoNumber__c,Access_Code_Was_Sent__c from Order where Id=:ordId];
         List<OrderItem> ois = [SELECT id, quantity, Product2.ProductCode,Product2.Product_Type_ID__c FROM orderitem WHERE orderId = :ordId AND Product2.Product_Type_ID__c IN ('OLS','AMD','BOL','SUL','DSB','OLC')];
        // Calculate quantities needed per ISBN
        system.debug('Start12345678'+ois.size());

        
        Integer totalQuantityNeeded = 0;
        for(OrderItem oi : ois){
            this.isbnCodes.add(oi.Product2.ProductCode);
           
            // Track line items per ISBN
            if(isbnQntMap.containskey(oi.Product2.ProductCode)){
                isbnQntMap.put(oi.Product2.ProductCode, isbnQntMap.get(oi.Product2.ProductCode) + 1);
            } else {
                isbnQntMap.put(oi.Product2.ProductCode, 1);
            }
            // Track total quantity needed per ISBN
            if(isbnQuantityMap.containskey(oi.Product2.ProductCode)){
                isbnQuantityMap.put(oi.Product2.ProductCode, isbnQuantityMap.get(oi.Product2.ProductCode) + oi.quantity);
            } else {
                isbnQuantityMap.put(oi.Product2.ProductCode, oi.quantity);
            }
            totalQuantityNeeded += Integer.valueOf(oi.quantity);
        }
            this.isbnQuantityMapCounter = new Map<String,Decimal>(isbnQuantityMap);
        
    }
    
    @InvocableMethod
    public static void executeCustomBatch(List<FlowInput> request) {
        Id jobId = Database.executeBatch(new scc_AccessCodeBatchProcessor(request[0].ordFlowId),1);
        
        
    }
    public Database.QueryLocator start(Database.BatchableContext BC) {
        

        return Database.getQueryLocator([SELECT id, quantity, Product2.ProductCode,Product2.Product_Type_ID__c FROM orderitem WHERE orderId = :ordId AND Product2.Product_Type_ID__c IN ('OLS','AMD','BOL','SUL','DSB','OLC')]);
    }
    
    public void execute(Database.BatchableContext BC, List<OrderItem> scope) {
        
        Integer limitcheck = (Integer)scope[0].quantity;
        
        Map<String, List<EAccess_List__c>> isbnToAccessCodes = new Map<String, List<EAccess_List__c>>();
        List<EAccess_List__c> eacesslist = [
            SELECT Id, ProductId__r.ProductCode, EAccess_Imprints__c, 
            EAccess_Imprints__r.Admin_Email2__c, EAccess_Imprints__r.Admin_Email1__c, 
            EAccess_Code__c 
            FROM EAccess_List__c 
            WHERE IsMailSent__c = 'N' 
            AND ProductId__r.ProductCode = : scope[0].Product2.ProductCode 
            AND Order__c = '' LIMIT: limitcheck
        ];
         
        // Group access codes by ISBN
        for(EAccess_List__c ea : eacesslist) {
            if(isbnQuantityMapCounter.get(ea.ProductId__r.ProductCode) > 0){
                eaccessCodesReturn.add(ea);
                isbnQuantityMapCounter.put(ea.ProductId__r.ProductCode,isbnQuantityMapCounter.get(ea.ProductId__r.ProductCode) - 1);
            }
        }
         
    }
    
    public void finish(Database.BatchableContext BC) {
       
        for(EAccess_List__c ea : eaccessCodesReturn){
            imprintcodes.add(ea.EAccess_Imprints__c);
            accessCodesList.add(ea.Id);
            
            if (!isbnImprintEmailsMap1.containsKey(ea.ProductId__r.ProductCode)) {
                isbnImprintEmailsMap1.put(ea.ProductId__r.ProductCode, ea.EAccess_Imprints__r.Admin_Email2__c);
            }
            
            if (!isbnImprintEmailsMap2.containsKey(ea.ProductId__r.ProductCode)) {
                isbnImprintEmailsMap2.put(ea.ProductId__r.ProductCode, ea.EAccess_Imprints__r.Admin_Email1__c);
            }
            
            if (!accesscodeisbn.containsKey(ea.ProductId__r.ProductCode)) {
                accesscodeisbn.put(ea.ProductId__r.ProductCode, ea.ProductId__r.ProductCode);
            }			
            
            if (!isbnImprintIdMap.containsKey(ea.ProductId__r.ProductCode)) {
                isbnImprintIdMap.put(ea.ProductId__r.ProductCode,ea.EAccess_Imprints__c);
            }
            
            if(isbnQntCodesMap.containskey(ea.ProductId__r.ProductCode)){
                isbnQntCodesMap.put(ea.ProductId__r.ProductCode, isbnQntCodesMap.get(ea.ProductId__r.ProductCode) + 1);
            }
            else{
                isbnQntCodesMap.put(ea.ProductId__r.ProductCode, 1);
            }
        }
        
        outputboolean = false;
        Integer booleancheckcount = 0;
        
        List<EAccess_Threshold__c> eaccessThresolds1 = [select id,Avl_Stock__c,ProductCode__c,Threshold__c,IsSentRequest__c from EAccess_Threshold__c where ProductCode__c IN: isbnCodes];
       
        for(EAccess_Threshold__c ed : eaccessThresolds1){
            if (isbnQuantityMap.get(ed.ProductCode__c) > ed.Avl_Stock__c) {
                booleancheckcount = booleancheckcount + 1; 
            }
            if ((isbnQuantityMap.get(ed.ProductCode__c) > ed.Avl_Stock__c) && (ed.IsSentRequest__c == false)) {
                noAccessCodeWrapper accessWrapper = new noAccessCodeWrapper();
                accessWrapper.outputimprintemail1 = isbnImprintEmailsMap1.get(ed.ProductCode__c);
                accessWrapper.outputimprintemail2 = isbnImprintEmailsMap2.get(ed.ProductCode__c);
                accessWrapper.outputnoaccesscodeisbn=accesscodeisbn.get(ed.ProductCode__c);
                accessWrapper.outputnoaccesscodeimprintid=isbnImprintIdMap.get(ed.ProductCode__c);
                
                noaccessWrapper.add(accessWrapper);
                if(!noaccessWrapper.isEmpty())
                { 
                    ed.IsSentRequest__c = true;
                }                
            }          
        }
        if(booleancheckcount == 0 && eaccessThresolds1.size() > 0){
            outputboolean = true;            
        }
       
        Database.update(eaccessThresolds1);        
        if(!noaccessWrapper.isEmpty())
        { 
            sendnoaccesscodemail(noaccessWrapper);
        }               
        if(outputboolean){
            
            exCodes = accessCodesList;
         
            outputimprints = imprintcodes;
            
            outputaccessList = eaccessCodesReturn;
           
            List<EAccess_Threshold__c> eaccessThresolds = [select id,Avl_Stock__c,ProductCode__c  from EAccess_Threshold__c where ProductCode__c IN: isbnCodes];
            for(EAccess_Threshold__c ed : eaccessThresolds){
                if(isbnQuantityMap.get(ed.ProductCode__c) <= ed.Avl_Stock__c)
                { 
                    ed.Avl_Stock__c = ed.Avl_Stock__c - isbnQuantityMap.get(ed.ProductCode__c);
                }
            }            
            Database.update(eaccessThresolds);
            
            List<EAccess_Imprints__c> eaccess = [select id,Email_SpecificInstructions__c  from EAccess_Imprints__c where id IN: outputimprints ];
            for(EAccess_Imprints__c ei :eaccess){
    accessCodeforEmail = new List<String>(); 
    String currentIsbn = ''; 
                
    for(EAccess_List__c el:outputaccessList){
        if(el.EAccess_Imprints__c == ei.id){
            accessCodeforEmail.add(el.EAccess_Code__c);
            currentIsbn = el.ProductId__r.ProductCode; // Get ISBN for this set of codes
        }
    }
    String formattedAccessCodes = String.join(accessCodeforEmail, '<br/>');
    List<String> outputString = new List<String>();
               
    if(ord[0].Customer_Email__c != null && ord[0].Customer_Email__c != ''){
        outputString = ord[0].Customer_Email__c.split(' ');
    }
    List<Messaging.SingleEmailMessage> mList = new List<Messaging.SingleEmailMessage>();
    OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =: System.Label.Savvas_SSO_OrgWideEmailAddress];
    EmailTemplate emailTemplate = [SELECT Id, Name, Subject, HtmlValue, Body FROM EmailTemplate WHERE Name = 'scc_Access_Code_Template'];
    String htmlBody = emailTemplate.HtmlValue;
    String billingName = ord[0].BillingName__c != null ? ord[0].BillingName__c : '';
    htmlBody = htmlBody.replace('{!Order.BillingName__c}', billingName);
    htmlBody = htmlBody.replace('{!Order.PoNumber__c}', ord[0].PoNumber__c);
    htmlBody = htmlBody.replace('{!Order.SAP_Document_Number__c}', ord[0].SAP_Document_Number__c);
    htmlBody = htmlBody.replace('{!EAccess_Imprints__c.Email_SpecificInstructions__c}', ei.Email_SpecificInstructions__c);
    htmlBody = htmlBody.replace('{!EAccess_List__c.EAccess_Code__c}', formattedAccessCodes);
    htmlBody = htmlBody.replace('{!EAccess_List__c.ProductCode__c}', currentIsbn); // Use the ISBN for current set of codes

    // Do the same for plainBody
    String plainBody  = emailTemplate.HtmlValue;
    plainBody = plainBody.replace('{!Order.BillingName__c}', billingName);
    plainBody = plainBody.replace('{!Order.PoNumber__c}', ord[0].PoNumber__c);
    plainBody = plainBody.replace('{!Order.SAP_Document_Number__c}', ord[0].SAP_Document_Number__c);
    plainBody = plainBody.replace('{!EAccess_Imprints__c.Email_SpecificInstructions__c}', ei.Email_SpecificInstructions__c);
    plainBody = plainBody.replace('{!EAccess_List__c.EAccess_Code__c}', formattedAccessCodes);
    plainBody = plainBody.replace('{!EAccess_List__c.ProductCode__c}', currentIsbn); 
                for(String strco : outputString){
                    Messaging.SingleEmailMessage mCart = new Messaging.SingleEmailMessage();
                    mCart.setToAddresses(new List<String> { strco.trim() });
                    mCart.setTemplateId(emailTemplate.Id);
                     if ( owea.size() > 0 ) {
    				mCart.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    mCart.setTargetObjectId(UserInfo.getUserId());
                    mCart.setTreatTargetObjectAsRecipient(false); 
                    mCart.setSaveAsActivity(false);
                    mCart.setSubject(emailTemplate.Subject);
                    mCart.setHtmlBody(htmlBody);
                    mCart.setPlainTextBody(plainBody);
                    mList.add(mCart);
                }
                Messaging.sendEmail(mList);
                accessCodeforEmail = new List<String>();
            }
            
            ord[0].Access_Code_Was_Sent__c = true;
            List<EAccess_List__c> eacesslist2 = [
                SELECT Id 
                FROM EAccess_List__c 
                WHERE Id IN :exCodes	
            ];
            for(EAccess_List__c eas :eacesslist2){
                eas.IsMailSent__c = 'Y';
                eas.Order__c = ord[0].Id;
            }
            Database.update(eacesslist2);
           
            Database.update(ord);
            
            
            
            
        }
    }
    public class FlowInput{        
        @InvocableVariable
        public String ordFlowId;
        
    }
    public class noAccessCodeWrapper
    {
        
        public String outputimprintemail1;
        
        public String outputimprintemail2;
        
        public String outputnoaccesscodeisbn;
        
        public Id outputnoaccesscodeimprintid;
        
    }
    public static void sendnoaccesscodemail(List<noAccessCodeWrapper> noaccessWrapper) {
        try{
            EmailTemplate emailTemplate = [Select Id,Name,Subject, HtmlValue, Body from EmailTemplate where Name =: System.Label.scc_Noaccesscode_Email_Template];
            List<Messaging.SingleEmailMessage> mList = new List<Messaging.SingleEmailMessage>();
            Map<String,Set<String>> imprintMap = new Map<String,Set<String>>();         
            Set<String> uniqueEmails = new Set<String>();
            
            
            for(noAccessCodeWrapper noacc : noaccessWrapper)
            { 
                if(!imprintMap.containsKey(noacc.outputnoaccesscodeimprintid))
                {
                    imprintMap.put(noacc.outputnoaccesscodeimprintid,new Set<String>());
                }
                imprintMap.get(noacc.outputnoaccesscodeimprintid).add(noacc.outputnoaccesscodeisbn);
            }
            
            for(String imprintId : imprintMap.keySet())
            {            
                Set<String> uniqueisbn = imprintMap.get(imprintId);
                for(noAccessCodeWrapper wrapper : noaccessWrapper)
                {             
                    if(wrapper.outputnoaccesscodeimprintid == imprintId)
                    { 
                        if(wrapper.outputimprintemail1 != null) {
                            uniqueEmails.add(wrapper.outputimprintemail1);
                        }
                        if (wrapper.outputimprintemail2!= null) {
                            uniqueEmails.add(wrapper.outputimprintemail2);
                        }
                        
                    }
                }
                
                if (uniqueEmails.isEmpty()) {                
                    return; // Exit if there are no email addresses to send to
                }
                String isbnString;
                if(uniqueisbn.size()== 1)
                {
                    isbnString = uniqueisbn.iterator().next();
                }
                else
                {
                    isbnString =String.join(new List<String>(uniqueisbn),', ');
                }
                
                String subject = emailTemplate.Subject;
                String htmlBody = emailTemplate.HtmlValue;           
                htmlBody = htmlBody.replace('{Admin_Email}', String.join(new List<String>(uniqueEmails),', '));
                htmlBody = htmlBody.replace('{ISBN}', isbnString);
                htmlBody = htmlBody.replace('{Imprint_Id}', imprintId);
                
                String plainBody  = emailTemplate.HtmlValue;
                plainBody  = plainBody.replace('{Admin_Email}', String.join(new List<String>(uniqueEmails),', '));
                plainBody  = plainBody.replace('{ISBN}',isbnString);
                plainBody  = plainBody.replace('{Imprint_Id}', imprintId);
                
                Messaging.SingleEmailMessage accessCode = new Messaging.SingleEmailMessage();
                OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =: system.label.scc_org_wide_email_address];
                if ( owea.size() > 0 ) {
                    accessCode.setOrgWideEmailAddressId(owea.get(0).Id);   
                }
                accessCode.setToAddresses(new List<String>(uniqueEmails));
                accessCode.setTemplateId(emailTemplate.Id);
                
                accessCode.setSaveAsActivity(false);
                accessCode.setSubject(subject);
                accessCode.setHtmlBody(htmlBody);
                accessCode.setPlainTextBody(plainBody);
                mList.add(accessCode);
            } 
            
            if(!mList.isEmpty())
            { 
                Messaging.sendEmail(mList);
            }
        }
        catch(Exception e){
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());    // returns null
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());
            throw new AuraHandledException('Error while sending access code email:'+e.getMessage()+e.getCause());
        }        
    } 
}