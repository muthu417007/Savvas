/*
@Author : Cognizant Team
@Name : SavvasVirtualSamplesSCAssetSelector
@CreateDate : 17-Aug-2023
@Description: This class gets called to fetch Samples Category Assets
@ModifiedBy: Cognizant Team
@ModifiedDate: 02-Nov-2023
@Ticket Number: VS-0031
*/
public without sharing class SavvasVirtualSamplesSCAssetSelector {
    /*
*  Method Name : getSampleCategoryAssetByCollectionId
*  Description : getting the Samples Category Asset based on Collection Ids. Class is without sharing as user doesn’t have access to some objects which are referred in the class.
*  param : List of collectionIds
*  return : List of Samples Category Asset 
*/    
    public static List<Samples_Category_Asset__c> getSampleCategoryAssetByCollectionId(Set<String> collectionIds){
        
        List<Samples_Category_Asset__c> sampleCategoryAssetRecords = new List<Samples_Category_Asset__c>();
        sampleCategoryAssetRecords = [SELECT Name,Sample_Category_Name__c,Asset_Name__c,Sequence__c,Sample_Category_Name__r.Parent_Program__r.Collection_Id__c,Sample_Category_Name__r.Name,
                                      Sample_Category_Name__r.Parent_Program__r.Name,Sample_Category_Name__r.Parent_Program__r.Program_Description__c,Sample_Category_Name__r.Sequence__c,
                                      Sample_Category_Name__r.Parent_Program__r.Program_Banner_Image_URL__c,Sample_Category_Name__r.Parent_Program__r.Program_Banner_Source_URL__c,
                                      Sample_Category_Name__r.Parent_Program__r.Program_Right_Banner__c,Asset_Name__r.Display_Title__c,LastModifiedDate,
                                      Asset_Name__r.Asset_Url__c,Asset_Name__r.Asset_Type__c, Asset_Name__r.Sitecore_Id__c,Asset_Name__r.Name,Asset_Name__r.Video_Asset__c,Asset_Name__r.Virtual_Samples_Program__r.Name,
                                      Asset_Name__r.Thumbnail_URL__c, Asset_Name__r.Usage_Description__c, Asset_Name__r.Entity_Id__c, Asset_Name__r.Resource_Type__c,Asset_Name__r.Virtual_Samples_Program__c
                                      FROM Samples_Category_Asset__c 
                                      WHERE Sample_Category_Name__r.Parent_Program__r.Collection_Id__c IN: collectionIds 
                                      ORDER BY Sequence__c];
        return sampleCategoryAssetRecords;
        
    }
}