/*
@Author : Cognizant Team
@Name : SavvasVirtualSamplesCAccessSelector
@CreateDate : 17-Aug-2023
@Description: This class gets called to fetch CollectionAccess details
@ModifiedBy: Cognizant Team
@ModifiedDate: 18-Sep-2024
@Ticket Number: VS-0011
*/
public without sharing class SavvasVirtualSamplesCAccessSelector{
    
    /*
*  Method Name : getCollectionAccessList
*  Description : getting all the collection access list based on user email.    Class is without sharing as user doesn’t have access to some objects which are referred in the class.
*  param : None
*  return : List of Collection Access
*/
    public static List<Collection_Access__c> getCollectionAccessList(String accountId){
            List<Collection_Access__c>  collectionList = new List<Collection_Access__c>();
           collectionList = [SELECT Id,Name,Access_Granted_On__c,Access_Valid_Till__c,Program_Type__c, 
                    			Program_Description__c,Collection_Id__c,Access_Expiry_Duration__c 
                             FROM Collection_Access__c
                    		WHERE contact__r.Email =: UserInfo.getUserEmail() 
                            AND Contact__r.AccountId =: accountId //W-015376: added AccountId as part of SSO Implementation
                            ORDER BY LastModifiedDate ASC];  
            return  collectionList;
    }
    /*
*  Method Name : getCAListByContact
*  Description : getting all the collection access list based on contact. Class is without sharing as user doesn’t have access to some objects which are referred in the class.
*  param : contactId,productOfInterest
*  return : List of Collection Access
*/
    public static List<Collection_Access__c> getCAListByContact(Id contactId, String collectionId){
             List<Collection_Access__c> collectionList = new List<Collection_Access__c>();
          collectionList =[SELECT Id, Name,Collection_Id__c FROM Collection_Access__c 
                    	  WHERE Contact__c =: contactId 
                          AND Collection_Id__c <>: collectionId
                          LIMIT 1];
            return collectionList;
    }
    /*
*  Method Name : getCAListByName
*  Description : getting all the collection access list based on contact and name. Class is without sharing as user doesn’t have access to some objects which are referred in the class. 
*  param : contactId,productOfInterest
*  return : List of Collection Access
*/
    public static List<Collection_Access__c> getCAListByName(Id contactId, String collectionId){
            List<Collection_Access__c> collectionList = new List<Collection_Access__c>();
           collectionList = [SELECT Id, Name,Collection_Id__c FROM Collection_Access__c 
                   			 WHERE Contact__c =: contactId 
                             AND Collection_Id__c =: collectionId
                             LIMIT 1];
            return collectionList;
    }
}