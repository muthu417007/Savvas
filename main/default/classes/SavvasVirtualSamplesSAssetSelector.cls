/*
@Author : Cognizant Team
@Name : SavvasVirtualSamplesSAssetSelector
@CreateDate : 11-Jan-2023
@Description: This class gets called to create User, CollectionAccess and SitecoreAsset
@ModifiedBy: Cognizant Team
@ModifiedDate: 02-Nov-2023
@Ticket Number: VS-0011
*/
public without sharing class SavvasVirtualSamplesSAssetSelector {
    /*
*  Method Name : getsitecoreAssetsByContactId
*  Description : getting the Sitecore Asset for specific contact
*  param : collectionId,contactId
*  return : List of Sitecore Asset 
*/    
    public static List<Sitecore_Asset__c> getsitecoreAssetsByContactId(String collectionId, String contactId){
            List<Sitecore_Asset__c> SitecoreAssetRecords = new List<Sitecore_Asset__c>();
            SitecoreAssetRecords = [SELECT Id, Name, Entity_Id__c,Sitecore_Id__c 
                                    FROM Sitecore_Asset__c 
                    				WHERE Collection_Access__c =: collectionId 
                                    AND contact__c=: contactId];
            return SitecoreAssetRecords;
         
    }
    /*
*  Method Name : getSitecoreAssetByCA
*  Description : getting the Sitecore Asset based on collection
*  param : collectionId
*  return : List of Sitecore Asset 
*/  
    Public static List<Sitecore_Asset__c> getSitecoreAssetByCA(String collectionId){
            List<Sitecore_Asset__c> SitecoreAssetRecords = new List<Sitecore_Asset__c>();
            SitecoreAssetRecords = [SELECT Id, Name, Entity_Id__c,Sitecore_Id__c 
                                    FROM Sitecore_Asset__c 
                    				WHERE Collection_Access__c =:collectionId];
            return SitecoreAssetRecords;
    }
    /*
*  Method Name : getSitecoreAssetByCAName
*  Description : getting the Sitecore Asset based on collection
*  param : collectionName
*  return : List of Sitecore Asset 
*/  
    Public static List<Sitecore_Asset__c> getSitecoreAssetByCAName(String collectionName){
            List<Sitecore_Asset__c> SitecoreAssetRecords = new List<Sitecore_Asset__c>();
            SitecoreAssetRecords = [SELECT 
                                    Id, Name,Entity_Id__c,Collection_Access__c,Collection_Access__r.Name,Asset_Url__c,Sitecore_Id__c,
                    				Collection_Access__r.Access_Granted_On__c,Collection_Access__r.Access_Valid_Till__c,Thumbnail_Id__c,
                    				Collection_Access__r.Program_Description__c,Usage_Description__c,Collection_Access__r.Collection_Item_Id__c,Contact__c
                    				FROM Sitecore_Asset__c
                    				WHERE Collection_Access__r.contact__r.Email =: UserInfo.getUserEmail()
                    				AND Collection_Access__r.Access_Valid_Till__c >=: Date.today() 
                    				AND Collection_Access__r.Name=:collectionName ORDER By CreatedDate DESC];
            return SitecoreAssetRecords;
   
    }
    /*
*  Method Name : getSitecoreAssetById
*  Description : getting the Sitecore Asset based on Id
*  param : sitecordId,contactId
*  return : List of Sitecore Asset 
*/  
    Public static List<Sitecore_Asset__c> getSitecoreAssetById(String sitecoreId,String contatId){
            List<Sitecore_Asset__c> SitecoreAssetRecords = new List<Sitecore_Asset__c>();
            SitecoreAssetRecords = [SELECT ID,Is_SF_Launched__c
                                    FROM Sitecore_Asset__c 
                    				WHERE Sitecore_Id__c=:sitecoreId 
                                    AND Contact__c =: contatId LIMIT 1];
            return SitecoreAssetRecords;
    }  
}