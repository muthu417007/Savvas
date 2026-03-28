/*
@Author : Cognizant Team
@Name : SavvasVirtualSampleUserSelector
@CreateDate : 17-Aug-2023
@Description: This class gets called to fetch User details
@ModifiedBy: Cognizant Team
@ModifiedDate: 12-08-2024
@Ticket Number: VS-0011, W-015376
*/
public without sharing class SavvasVirtualSampleUserSelector{
    
    /*
	*  Method Name : getUserByContact
	*  Description : getting the User for specific contact
	*  param : contactId
	*  return : List of Users
	*/   
    public static List<User> getUserByContact(Id contactId){
            List<User> userRecords = new List<User>();
            userRecords = [SELECT Id,Name,Email,ContactId,FirstName,UserName,profileId,Profile.Name 
                           FROM User 
                           WHERE ContactId=: contactId 
                           AND ContactId!=null 
                           AND IsActive=true];
            return userRecords;
    }
    
    /*
	*  Method Name : getUserById
	*  Description : getting the User for specific contact
	*  param : NA
	*  return : List of Users
	*/   
    public static List<User> getUserById(){
            List<User> userRecords = new List<User>();
            userRecords = [SELECT Id,Name,ContactId,FirstName,UserName,profileId,Profile.Name
                           FROM User 
                           WHERE Id =: UserInfo.getUserId() 
                           LIMIT 1];
        return userRecords;
    }

    /*
    *  Method Name : getUserList
    *  Description : getting the User for specific email
    *  param : email
    *  return : List<User>
    *  Ticket Number : W-015376
    */
    public static List<User> getUserList(String email){
        List<User> userList = new List<User>();
            userList = [
                SELECT Id, ProfileId, ContactId, AccountId, Email, FirstName
                FROM USER 
                WHERE Username=:email 
                AND IsActive=true
                LIMIT 1
            ];
        return userList;
    }
}