/*
Apex Class:scc_EnosixOrderSubmissionErrors
Author: CTS (Dhiyaneswari)
Created Date: 16/07/2024
Reason: This class will create case and send email to user for error occurred during order submission and profile update request, update webcart and order data
Modified Date:
*/
public without sharing class scc_EnosixOrderSubmissionErrors {
    /**
*  Description: This method will get user details    
*  @name: getUserDetails
*  @param: String
*  @return: Map
*/
    @AuraEnabled
    public static Map<String,String> getUserDetails(String cartId) {
        
        Map<String,String> response = new Map<String,String>();
        try{
            if(UserInfo.getUserType() == scc_constantHelper.GUEST){
                List<WebCart> webCart = [select Id, Order_Id__r.Customer_Email__c, Order_Id__r.BillingName__c from WebCart where Id=:cartId LIMIT 1];
                if(!webCart.isEmpty()){ 
                    response.put('Email',webCart[0].Order_Id__r.Customer_Email__c);
                    response.put('Name',webCart[0].Order_Id__r.BillingName__c);
                }
            }else{
                Id userId=UserInfo.getUserId();
                User userNameData = [Select id,Name,Email from User where id=:userId LIMIT 1]; 
                response.put('Email',userNameData.Email);
                response.put('Name',userNameData.Name);
            }            
        }catch(Exception e){
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());
        }
        return response;
    }
    
    /**
*  Description: This method will get custom errors from custom metadata
*  @name: getUserFriendlyErrorMessage
*  @param: String, String
*  @return: Map
*/
    @AuraEnabled
    public static Map<String,String> getUserFriendlyErrorMessage(String errorCode, String cartId) {
        Map<String,String> response = new Map<String,String>();
        try{
            
            String support = 'true';
            String errorMsg = '';
            List<scc_Order_Submission_Errors__mdt> errorMessages = [SELECT scc_Error_Message__c, MasterLabel FROM scc_Order_Submission_Errors__mdt WHERE MasterLabel =: errorCode];
            
            if(!errorMessages.isEmpty()){
                errorMsg = errorMessages[0].scc_Error_Message__c;
                errorMsg = errorMsg.replace('Cart ID:999999', 'Cart ID:' + cartId);
            }else{
                errorMsg = Label.scc_Order_Submission_Error_Message;
                errorMsg = errorMsg.replace('Cart ID:999999', 'Cart ID:' + cartId);
                errorMsg = errorMsg.replace('error code', 'error code ' + errorCode);
            }
            
            if(errorCode == '152' || errorCode == '154' || errorCode == '155' || errorCode == '162'){
                support = 'false';
            }
            response.put('errorMessage',errorMsg);
            response.put('support',support);            
        }catch(Exception e){
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());
        }
        return response;
    }
    
    /**
*  Description: This method will createCase if error occurred during order submission
*  @name: createCase
*  @param: String, String, String, String, String
*  @return: String
*/
    @AuraEnabled
    public static String createCase (String cartId, String description, String name, String email, String type){
        String caseNumber = '';
        String recordTypeName = scc_constantHelper.IT_EXTERNAL_SUPPORT;
        RecordType caseRecordType =[SELECT Id From RecordType WHERE SobjectType ='Case' AND Name = :recordTypeName LIMIT 1];
        List<Webcart> orderId = [Select Order_Id__c from WebCart Where Id =: cartId LIMIT 1];
        
        try{         
            Case newCase = new Case();
            newCase.Subject = (type == Label.scc_Order_Submission_Error ? Label.scc_Order_Submission_Error+' '+cartId : '');
            newCase.status = scc_constantHelper.STATUS_NEW; 
            newCase.origin = scc_constantHelper.ORIGIN_WEB; 
            newCase.Cart_Id__c = cartId; 
            newCase.Order_Id__c = orderId[0].Order_Id__c; 
            newCase.Description = 
                'Name: ' + name +', ' +                   
                'Email: ' + email +', ' +
                'Type: ' + type + ': ' + 
                (type == Label.scc_Order_Submission_Error ? 'Reference: '+cartId +', ' : '')+
                'Description: ' + description;
            newCase.RequestedSource__c = scc_constantHelper.STORE_NAME; 
            newCase.RecordTypeId = caseRecordType.Id;
            newCase.SuppliedEmail = email; 
            newCase.SuppliedName = name;  
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            dmlOpts.assignmentRuleHeader.useDefaultRule= true;
            newCase.setOptions(dmlOpts);
            insert newCase;
            
            List<Case> cases = [Select CaseNumber from Case where Id =: newCase.Id LIMIT 1];
            if(!cases.isEmpty()){
                updateWebCartStatus(cartId);
                caseNumber = cases[0].CaseNumber;
            }
            
        }catch(Exception e){
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());
        }
        return caseNumber;
    }
    
    /**
*  Description: This method will createCase profile update request submitted by user
*  @name: createCaseProfile
*  @param: String, String, String, String
*  @return: String
*/
    @AuraEnabled
    public static String createCaseProfile (String description, String name, String email, String type){
        String caseNumber = '';
        String recordTypeName = scc_constantHelper.IT_EXTERNAL_SUPPORT;
        RecordType caseRecordType =[SELECT Id From RecordType WHERE SobjectType ='Case' AND Name = :recordTypeName LIMIT 1];
        
        try{         
            Case newCase = new Case();
            newCase.Subject = (type == Label.scc_profileUpdateType ? Label.scc_profileUpdateType : '');
            newCase.status = scc_constantHelper.STATUS_NEW; 
            newCase.origin = scc_constantHelper.ORIGIN_WEB;
            newCase.RequestedSource__c = scc_constantHelper.STORE_NAME; 
            newCase.Platform__c = 'my savvas orders';
            newCase.Description = 
                'Name: ' + name +', ' +                   
                'Email: ' + email +', ' +
                'Type: ' + type + ', '+
                'Description: ' + description;
            newCase.RequestedSource__c = scc_constantHelper.STORE_NAME; 
            newCase.RecordTypeId = caseRecordType.Id;
            
            newCase.SuppliedEmail = email;
            newCase.SuppliedName = name;      
            
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            dmlOpts.assignmentRuleHeader.useDefaultRule= true;
            newCase.setOptions(dmlOpts);
            insert newCase;
            
            List<Case> cases = [Select CaseNumber,Description,Platform__c,Account_Name__c from Case where Id =: newCase.Id LIMIT 1];
            if(!cases.isEmpty()){
                sendEmailToUserProfile(cases[0].CaseNumber,cases[0].Description,cases[0].Platform__c,cases[0].Account_Name__c,email,name);
                caseNumber = cases[0].CaseNumber;                
            }            
        }catch(Exception e){
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());
        }
        return caseNumber;
    }
    
    /**
*  Description: This method will update webcart fields  IsSecondary and Master_User__c
*  @name: updateWebCartStatus
*  @param: String
*  @return: NA
*/
    public static void updateWebCartStatus(String cartId){
        try{
            Id userId = null;
            WebCart webCartList = [select Id, IsSecondary from WebCart where Id=:cartId LIMIT 1];
            if(webCartList != null){
                webCartList.IsSecondary = true;
                webCartList.Master_User__c = userId;
            }
            update webCartList;
        }catch(Exception e){
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());
        }
    }
    
    /**
*  Description: This method will email to user for error occurred during order submission
*  @name: sendEmailToUser
*  @param: String, String
*  @return: NA
*/
    @AuraEnabled
    public static void sendEmailToUser(String caseNumber, String email) {
        try {
            // Get the case record first
            Case currentCase = [SELECT Id FROM Case WHERE CaseNumber = :caseNumber LIMIT 1];
            
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =: system.label.scc_org_wide_email_address];
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if (owea.size() > 0) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            
            EmailTemplate emailTemplate = [select Id, Subject, HtmlValue, Body from EmailTemplate 
                                           where Name =: system.label.scc_Order_Submission_Error_Email_Template LIMIT 1];
            
            String subject = emailTemplate.Subject;
            subject = subject.replace('{!Case.CaseNumber}', caseNumber);
            
            String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!Case.CaseNumber}', caseNumber);
            
            // Add thread tracking like in profile change
            String threadId = '<' + currentCase.Id + '.' + DateTime.now().getTime() + '.JavaMail.@' + UserInfo.getOrganizationId() + '>';
            mail.setInReplyTo(threadId);
            mail.setReferences(threadId);
            
            // Associate email with case
            mail.setWhatId(currentCase.Id);
            
            String[] toAddresses = new String[] {email}; 
                mail.setToAddresses(toAddresses);        
            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setSubject(subject);
            mail.setPlainTextBody(plainBody);
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail}); 
            
        } catch(Exception e) {
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());
        }
    }
    /**
*  Description: This method will email to user for profile update request
*  @name: sendEmailToUserProfile
*  @param: String, String, String, String, String, String
*  @return: NA
*/
    @AuraEnabled
    public static void sendEmailToUserProfile (String caseNumber, String Description, String Platform, String AccountName, String email, String name){
        try{
            Case currentCase = [SELECT Id FROM Case WHERE CaseNumber = :caseNumber LIMIT 1];
            
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =: system.label.scc_org_wide_email_address];
            String subjectReq = 'Profile Change Request';
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            if ( owea.size() > 0 ) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            
            // Unique thread identifier based on Case Id
            String threadId = '<' + currentCase.Id + '.' + DateTime.now().getTime() + '.JavaMail.@' + UserInfo.getOrganizationId() + '>';
            mail.setInReplyTo(threadId);
            mail.setReferences(threadId);
            
            EmailTemplate emailTemplate = [select Id, Subject, HtmlValue, Body from EmailTemplate 
                                           where Name =: system.label.scc_Profile_Update_Email_Template LIMIT 1];
            Messaging.reserveSingleEmailCapacity(2);
            
            String subject = emailTemplate.Subject;
            subject = subject.replace('{!Case.CaseNumber}', caseNumber);
            
            String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!Case.CaseNumber}', caseNumber);
            plainBody = plainBody.replace('{!Description}', Description);
            plainBody = plainBody.replace('{!Platform}', Platform);
            plainBody = plainBody.replace('{!AccountName}', AccountName);
            plainBody = plainBody.replace('{!Subject}', subjectReq);
            plainBody = plainBody.replace('{!UserName}', name);
            
            mail.setToAddresses(new String[] {email});
            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setSubject(subject);
            mail.setPlainTextBody(plainBody);
            mail.setWhatId(currentCase.Id);
            
            // Send the email
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail}); 
        } catch(Exception e){
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    /**
*  Description: This method will update cart and order fields
*  @name: updateCartAndOrder
*  @param: String, String
*  @return: NA
*/
    @AuraEnabled
    public static void updateCartAndOrder(String cartId, String orderId){
        try{
            List<WebCart> webCart = [select Id, Status, Master_User__c from WebCart where Id=:cartId LIMIT 1];
            if(!webCart.isEmpty()){
                webCart[0].Status = 'Closed';
                webCart[0].Master_User__c = null;
                update webCart;
            }
            List<Order> order = [select Id, Status, ActivatedDate,Order_Status_Code__c from Order where Id=:orderId LIMIT 1]; 
            if(!order.isEmpty()){
                order[0].Status = 'Activated';
                order[0].ActivatedDate = System.Today();
                order[0].Order_Status_Code__c = 'OPEN';
                update order;
            }
        }catch(Exception e){
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());
        }
    }
    
    @AuraEnabled
    public static boolean createCaseSendEmail(String caseCategory, String name, String userId, String email, String accountName, String accountZipCode, String caseDesc) {
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =: system.label.scc_org_wide_email_address];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String recordTypeName = 'IT External Support';
        RecordType caseRecordType = [SELECT Id From RecordType WHERE SobjectType ='Case' AND Name = :recordTypeName LIMIT 1];
        if (owea.size() > 0) {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        Case newCase = new Case();
        newCase.Subject = 'New case created for  ' + caseCategory;
        newCase.status = 'New'; 
        newCase.origin = 'Web';         
        newCase.Description = 
            'Name: ' + name + ', ' +  
            'User Id: ' + userId + ', ' +  
            'Email: ' + email + ', ' +
            'Account Name: ' + accountName + ', ' +
            'Account Zip/Postal code: ' + accountZipCode + ', ' +
            'Description: ' + caseDesc;            
        newCase.RequestedSource__c = 'MySavvasOrders';
        newCase.RecordTypeId = caseRecordType.Id;
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.useDefaultRule = true;
        newCase.setOptions(dmlOpts);
        insert newCase;
        
        List<Case> caseNumber = [Select CaseNumber from Case where Id =: newCase.Id LIMIT 1];
        EmailTemplate emailTemplate = [select Id, Subject, HtmlValue, Body from EmailTemplate where Name = 'Case - New Case Created'];
        Messaging.reserveSingleEmailCapacity(2);
        String subject = emailTemplate.Subject;
        subject = subject.replace('{!Case.CaseNumber}', caseNumber[0].CaseNumber);
        subject = subject.replace('School not found', '');
        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!Case.CaseNumber}', caseNumber[0].CaseNumber);
        String[] toAddresses = new String[] {email}; 
        mail.setToAddresses(toAddresses);		
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setSubject(subject);
        mail.setPlainTextBody(plainBody);
        mail.setSaveAsActivity(true); 
        mail.setWhatId(newCase.Id);    
        
        // email threading 
        String threadId = '<' + newCase.Id + '.' + DateTime.now().getTime() + '.JavaMail.@' + UserInfo.getOrganizationId() + '>';
        mail.setInReplyTo(threadId);
        mail.setReferences(threadId);
        
        try {
            Messaging.sendEmail(new Messaging.SingleEmailmessage[] {mail});
            
            // Added EmailMessage creation
            EmailMessage emailMsg = new EmailMessage();
            emailMsg.ParentId = newCase.Id;
            emailMsg.TextBody = plainBody;
            emailMsg.Subject = subject;
            emailMsg.FromAddress = System.Label.scc_org_wide_email_address;
            emailMsg.ToAddress = email;
            emailMsg.Status = '2';
            emailMsg.MessageDate = System.now();
            insert emailMsg;
        } catch (exception e) {
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());
            return false;
        }
        return true;
    }

	@AuraEnabled
    public static Id createCaseForInternalUser(String caseCategory, String name, String email, String caseDesc, String accountName, String accountZipCode, String internalUser, String guestUser, String accountid) {        
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =: system.label.scc_orgwide_email_add_IntExtGuestUser];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        String recordTypeName = scc_constantHelper.IT_EXTERNAL_SUPPORT;      
        String UserId = UserInfo.getUserId();
        
        RecordType caseRecordType = [SELECT Id From RecordType WHERE SobjectType ='Case' AND Name = :recordTypeName LIMIT 1];
        
        if (owea.size() > 0) {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        
        Case newCase = new Case();
        try {
        newCase.Subject = caseCategory ;
        newCase.status = scc_constantHelper.STATUS_NEW;
        newCase.SuppliedEmail = email;
        
        if (internalUser == 'true'){
           newCase.origin = scc_constantHelper.INTERAL;
        } else {            
           newCase.origin = scc_constantHelper.ORIGIN_WEB;
        }
        
        if (guestUser == 'false'){            
           	newCase.User__c = UserId;  
        }
        
        if (internalUser == 'true' || (internalUser == 'false' && guestUser == 'false')){
           newCase.Description = 
            'Name: ' + name + ', ' +
            'Category: ' + caseCategory + ', ' +            
            'Description: ' + caseDesc;
        } else {            
           newCase.Description = 
            'Name: ' + name + ', ' +
            'Category: ' + caseCategory + ', ' +
            'Account Name: ' + accountName + ', ' +
            'Zip code: ' + accountZipCode + ', ' +
            'Description: ' + caseDesc;
        }
        
        if (internalUser != 'true' && guestUser != 'true' && accountZipCode != 'I don\'t see my school'){
        	newCase.AccountId = accountid;  
        }
        
        if (guestUser == 'true' && accountZipCode != 'I don\'t see my school'){
        	newCase.AccountId = accountid;  
        }
                         
        newCase.RequestedSource__c = scc_constantHelper.STORE_NAME;
        newCase.RecordTypeId = caseRecordType.Id;
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.useDefaultRule = true;
        newCase.setOptions(dmlOpts);
        insert newCase;
        
        List<Case> caseNumber = [Select CaseNumber from Case where Id =: newCase.Id LIMIT 1];
        EmailTemplate emailTemplate = [select Id, Subject, HtmlValue, Body from EmailTemplate where Name =: system.label.scc_CreateCase_IntExterGuest_User_EmailTemplate];
        Messaging.reserveSingleEmailCapacity(2);
        String subject = emailTemplate.Subject;
        subject = subject.replace('{!Case.CaseNumber}', caseNumber[0].CaseNumber);
        subject = subject.replace('Case Category', caseCategory);
        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!Case.CaseNumber}', caseNumber[0].CaseNumber);
        plainBody = plainBody.replace('[category value]', caseCategory);
        String[] toAddresses = new String[] {email}; 
        mail.setToAddresses(toAddresses);		
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setSubject(subject);
        mail.setPlainTextBody(plainBody);
        mail.setSaveAsActivity(false); 
        mail.setWhatId(newCase.Id);    
        
        // email threading 
        String threadId = '<' + newCase.Id + '.' + DateTime.now().getTime() + '.JavaMail.@' + UserInfo.getOrganizationId() + '>';
        mail.setInReplyTo(threadId);
        mail.setReferences(threadId);
        
        
            Messaging.sendEmail(new Messaging.SingleEmailmessage[] {mail});
            
            // Added EmailMessage creation
            EmailMessage emailMsg = new EmailMessage();
            emailMsg.ParentId = newCase.Id;
            emailMsg.TextBody = plainBody;
            emailMsg.Subject = subject;
            emailMsg.FromAddress = System.Label.scc_orgwide_email_add_IntExtGuestUser	;
            emailMsg.ToAddress = email;
            emailMsg.Status = '2';
            emailMsg.MessageDate = System.now();
            insert emailMsg;
        } catch (exception e) {
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());
            return NULL;
        }
        
        return newCase.Id;
    }
    
    
    @AuraEnabled
    public static String uploadFile(String fileName, String base64Data, Id recordId) {
        // Decoding the base64Data
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        ContentVersion cv = new ContentVersion();
        cv.Title = fileName;
        cv.PathOnClient = '/' + fileName;
        cv.FirstPublishLocationId = recordId;
        cv.VersionData = EncodingUtil.base64Decode(base64Data);
        cv.IsMajorVersion = true;
        insert cv;
        return 'File uploaded successfully!';
    }
    
    
    @AuraEnabled
    public static String getCaseNumber(Id recordId) {
        String caseNumber;
        List<Case> caseList = [Select CaseNumber from Case where Id =: recordId LIMIT 1];
        caseNumber = caseList[0].CaseNumber;
        return caseNumber;
    }
}