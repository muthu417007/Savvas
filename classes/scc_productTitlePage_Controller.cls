/*
Apex Class: scc_productTitlePage_Controller
Author: CTS (Sanika Sol)
Created Date: 04/04/2024
Reason: Backend logic for Scc_productTitlePage
Modified Date: 15/04/2024
*/
public without sharing class scc_productTitlePage_Controller {
    /**
*  Description: Retrieves the description of a sales restriction based on the product's Sales_Restriction_Code__c field.
*  @param productId (Id): The ID of the product.
*  @return String: The description of the sales restriction.
*/
    @AuraEnabled(cacheable=true)
    public static String getRestrictionDescription(Id productId) {
        String description = '';
        try {
            // Retrieve the product's Sales_Restriction_Code__c field
            Product2 product = [SELECT Sales_Restriction_Code__c FROM Product2 WHERE Id = :productId LIMIT 1];
            if (product != null && product.Sales_Restriction_Code__c != null) {
                // Define metadata type details
                String metadataTypeFullName = 'scc_sales_restriction__mdt';
                String metadataTypeNamespace = '';
                String metadataTypeName = metadataTypeNamespace + metadataTypeFullName;
                
                // Dynamically query custom metadata based on the product's Sales_Restriction_Code__c
                String query = 'SELECT Sales_Restriction_Description__c FROM ' + metadataTypeName + ' WHERE Code__c = \''+product.Sales_Restriction_Code__c+'\' LIMIT 1';
                List<SObject> metadataRecords = Database.query(query);
                
                if (!metadataRecords.isEmpty()) {
                    description = (String)metadataRecords[0].get('Sales_Restriction_Description__c');
                }
            }
        } catch (Exception e) {
            System.debug('Error fetching restriction description: ' + e.getMessage());
        }
        return description;
    }
    
    /**
*  Description: Retrieves details of a product based on its ID.
*  @param productId (Id): The ID of the product.
*  @return Product2: The product details.
*/
    @AuraEnabled(cacheable=true)
    public static Product2 getProductDetails(Id productId) {
        try {
            // Retrieve product details based on the productId
            return [SELECT Name, Grade_Range__c, Availability__c, IsActive, SAP_C__c, Carton_Quantity__c, Rights_Restriction_Code__c,Sales_Restriction_Code__c,Product_Status_ID__c, Program_Series__c FROM Product2 WHERE Id = :productId LIMIT 1];
        } catch (Exception e) {
            System.debug('Error fetching product details: ' + e.getMessage());
            return null;
        }
    }
    @AuraEnabled(cacheable=true)
    public static Account getUserdetails(Id userId) {
        List<User> userDetails = [SELECT Id, Contact.Id FROM User WHERE Id =: userId];
        Account accountDetails;
        if (!userDetails.isEmpty() && userDetails[0].Contact.Id != null) {
            Id contactId = userDetails[0].Contact.Id;
            List<Contact> contactDetails = [SELECT Id, AccountId FROM Contact WHERE Id = :contactId];
            
            if (!contactDetails.isEmpty() && contactDetails[0].AccountId != null) {
                Id accountId = contactDetails[0].AccountId;
                accountDetails = [SELECT Id, Name, Type FROM Account WHERE Id = :accountId];
                
                // Now you have the account details
                System.debug('Account Details: ' + accountDetails); 
            } else {
                System.debug('No account associated with this contact.');
            }
        } else {
            System.debug('No contact associated with this user.');
        }
        
        return accountDetails;
    }
    
    @AuraEnabled(cacheable=true)
    public static PricebookEntry getPricebookEntry(Id productId) {
        PricebookEntry pE = [SELECT Id, UnitPrice, Product2Id, ProductCode FROM PricebookEntry WHERE Product2Id =: productId LIMIT 1];
        system.debug('pricebookEntry'+ pE);
        return pE;
    }
    
}