/*
Apex Class: scc_emailCart_Controller
Author: CTS 
Created Date: 2024-05-25
Reason: To provide functionality for emailing cart details to users, including generating CSV attachments of cart items.
Modified Date: 15/04/2024
*/
public without sharing class scc_emailCart_Controller {
    /**
* Sends an email with cart details to specified email addresses.
* 
* @param eAddrs A comma-separated string of email addresses to send the cart details to.
* @throws AuraHandledException if there's an error during the email sending process.
*/
    @AuraEnabled 
    public static void sendEmailCart(String eAddrs) {
        try {
            Id uId = UserInfo.getUserId();
            List<emailCartWrapper> webCart = getWebCartId(uId);
            List<String> eList = eAddrs.split(',');
            EmailTemplate emailTemplate = [SELECT Id, Name, Subject, HtmlValue, Body FROM EmailTemplate WHERE Name = 'Scc_Email_Cart_External'];
            List<Messaging.SingleEmailMessage> mList = new List<Messaging.SingleEmailMessage>();
            
            String subject = emailTemplate.Subject;
            String htmlBody = emailTemplate.HtmlValue.replace('{!WebCart.User_Cart_Name__c}', webCart[0].cartName);
            String plainBody = emailTemplate.HtmlValue.replace('{!WebCart.User_Cart_Name__c}', webCart[0].cartName);
            
            Messaging.SingleEmailMessage mCart = new Messaging.SingleEmailMessage();
                OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = :system.label.scc_org_wide_email_address];
                if (!owea.isEmpty()) {
                    mCart.setOrgWideEmailAddressId(owea[0].Id);
                }
            
            for (String e : eList) {    
                mCart.setToAddresses(new List<String> { e.trim() });
                mCart.setTemplateId(emailTemplate.Id);
                mCart.setTargetObjectId(UserInfo.getUserId());
                mCart.setSaveAsActivity(false);
                mCart.setSubject(subject);
                mCart.setHtmlBody(htmlBody);
                mCart.setPlainTextBody(plainBody);
                
                String csvContent = generateCSV(uId);
                Messaging.EmailFileAttachment att = new Messaging.EmailFileAttachment();
                att.setFileName('CartDetails.csv');
                att.setBody(Blob.valueOf(csvContent));
                mCart.setFileAttachments(new Messaging.EmailFileAttachment[] { att });
                mList.add(mCart);
            } 
            Messaging.sendEmail(mList);
        } catch (Exception e) {
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            throw new AuraHandledException('Error sending email cart: ' + e.getMessage());
        }
    } 
    
    /**
* Generates a CSV string containing cart item details for the current user's active cart.
* 
* @param CartId The ID of the user for whom to generate the CSV (not actually used in the method).
* @return A CSV string containing cart item details.
* @throws AuraHandledException if there's an error during CSV generation.
*/
    public static String generateCSV(Id CartId) { 
        try {
            Id userId = UserInfo.getUserId();        
            List<WebCart> webCartItem = [SELECT Id, User_Cart_Name__c, Cart_Name_Auto_Number__c 
                                         FROM Webcart
                                         WHERE AccountId IN (SELECT AccountId FROM User WHERE Id = :userId) 
                                         AND OwnerId = :userId 
                                         AND Status = :scc_constantHelper.STATUS_ACTIVE 
                                         AND IsSecondary = :scc_constantHelper.FALSE_VALUE 
                                         ORDER BY CreatedDate DESC LIMIT 1];
            
            String activeCartId = webCartItem[0].Id;
            
            List<CartItem> cartItems = [SELECT Id, SalesPrice, NetUnitPrice, cart.Coupon_Discount__c, cart.ID, cart.User_Cart_Name__c, 
                                        cart.Cart_Name_Auto_Number__c, Quantity, TotalPrice, Product2.Id, Product2.Availability__c, 
                                        Product2.Copyright_Year__c, Product2.Grade_Level__c, Product2.ISBN13__c, Product2.Product_Status__c, 
                                        Product2.Description, Product2.ISBN10__c
                                        FROM CartItem
                                        WHERE CartId = :activeCartId];
            
            String csvContent = 'Sales Price,Net Unit Price,Coupon Discount,Cart ID,Cart Name,Quantity,TotalPrice,Product Id,Availability,Copy Right,Grade Level,Product ISBN 13,Product Status,Product Description,Product ISBN 10\n';
            
            for (CartItem i : cartItems) {
                String cartName = (String.isBlank(i.cart.User_Cart_Name__c)) ? i.cart.Cart_Name_Auto_Number__c : i.cart.User_Cart_Name__c;
                csvContent += '"' + i.SalesPrice + '",' + i.NetUnitPrice + ',' + i.cart.Coupon_Discount__c + ',' + 
                    '"' + i.cart.ID + '",' + '"' + cartName + '",' + '"' + i.Quantity + '",' + 
                    '"' + i.TotalPrice + '",' + '"' + i.Product2.Id + '",' + '"' + i.Product2.Availability__c + '",' + 
                    '"' + i.Product2.Copyright_Year__c + '",' + '"' + i.Product2.Grade_Level__c + '",' + 
                    '"' + i.Product2.ISBN13__c + '",' + '"' + i.Product2.Product_Status__c + '",' + 
                    '"' + i.Product2.Description + '",' + '"' + i.Product2.ISBN10__c + '"\n';
            }
            return csvContent; 
        } catch (Exception e) {
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            throw new AuraHandledException('Error generating CSV: ' + e.getMessage());
        }
    }
    
    /**
* Retrieves the WebCart ID and name for the current user's active cart.
* 
* @param uId The ID of the user for whom to retrieve the WebCart.
* @return A List of emailCartWrapper containing the cart name.
* @throws AuraHandledException if there's an error retrieving the WebCart ID.
*/
    public static List<emailCartWrapper> getWebCartId(Id uId) {
        try {
            List<WebCart> webCartItem = [SELECT Id, User_Cart_Name__c, Cart_Name_Auto_Number__c 
                                         FROM Webcart
                                         WHERE AccountId IN (SELECT AccountId FROM User WHERE Id = :uId) 
                                         AND OwnerId = :uId 
                                         AND Status = :scc_constantHelper.STATUS_ACTIVE 
                                         AND IsSecondary = :scc_constantHelper.FALSE_VALUE 
                                         ORDER BY CreatedDate DESC LIMIT 1];
            
            String cartName = String.isBlank(webCartItem[0].User_Cart_Name__c) ? webCartItem[0].Cart_Name_Auto_Number__c : webCartItem[0].User_Cart_Name__c;
            
            emailCartWrapper emailCartItems = new emailCartWrapper();
            emailCartItems.cartName = cartName;
            
            return new List<emailCartWrapper>{emailCartItems};
                } catch (Exception e) {
                    System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
                    System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
                    System.debug(scc_constantHelper.CAUSE+ e.getCause());
                    System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
                    System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
                    throw new AuraHandledException('Error getting WebCart ID: ' + e.getMessage());
                }
    }
    
    /**
* Wrapper class to hold cart information.
*/
    public class emailCartWrapper {
        @AuraEnabled public String cartName;
    }
}