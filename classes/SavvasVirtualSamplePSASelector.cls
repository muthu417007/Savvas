/*
@Author : Cognizant Team
@Name : SavvasVirtualSamplePSASelector
@CreateDate : 21-Aug-2023
@Description: This class gets called to fetch PermissionSetAssignment details
@ModifiedBy: Cognizant Team
@ModifiedDate: 02-Nov-2023
@Ticket Number: VS-0011
*/
public without sharing class SavvasVirtualSamplePSASelector {
    
    /*
    *  Method Name : getPSAByUserId
    *  Description : getting PermissionSetAssignment details based on Id and user Id. Class is without sharing as user doesn’t have access to some objects which are referred in the class.
    *  param : psId, List of userIds
    *  return : List of permissionSetAssignment records
    */
    public static List<PermissionSetAssignment> getPSAByUserId(String psId, List<User> userIds){
            List<PermissionSetAssignment> psaList = new List<PermissionSetAssignment>();
            psaList = [SELECT Id,AssigneeId, Assignee.ProfileId,PermissionSet.Id
             FROM PermissionSetAssignment
             WHERE PermissionSet.Id =: psId 
             AND AssigneeId IN : userIds];
            return psaList;
          }
}