/*
@Author : Cognizant Team
@Name : SavvasVirtualSampleVSPSelector
@CreateDate : 21-Aug-2023
@Description: This class gets called to fetch Virtual Samples Program
@ModifiedBy: Cognizant TeamgetVSPByCollection
@ModifiedDate: 02-Nov-2023
@Ticket Number: VS-0011
*/
public without sharing class SavvasVirtualSampleVSPSelector {

    /*
    *  Method Name : getVSPByCollection
    *  Description : getting the Virtual Samples Program based on Collection Id. Class is without sharing as user doesn’t have access to some objects which are referred in the class.
    *  param : collectionId
    *  return : List of Virtual Samples Program
    */
    public static List<Virtual_Samples_Program__c> getVSPByCollection(String collectionId){
            List<Virtual_Samples_Program__c> vspRecords = new List<Virtual_Samples_Program__c>();
            vspRecords = [SELECT Id, Collection_Id__c, Program_Sample_Expiry__c, Name
                          FROM Virtual_Samples_Program__c 
                          WHERE Collection_Id__c =:collectionId 
                          LIMIT 1];
            return vspRecords;
    }
}