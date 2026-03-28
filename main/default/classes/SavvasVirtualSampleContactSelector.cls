/*
@Author : Cognizant Team
@Name : savvasVirtualSampleContactSelector
@CreateDate : 17-Aug-2023
@Description: This class gets called to fetch Contact details
@ModifiedBy: Cognizant Team
@ModifiedDate: 16-Aug-2024
@Ticket Number: VS-0011,W-014602,W-015376
*/
public without sharing class SavvasVirtualSampleContactSelector {
    
    /*
	*  Method Name : getContactBySchoolId
	*  Description : getting the contact based on email and accountId. Class is without sharing as user doesn’t have access to some objects which are referred in the class.
	*  param : email, accountId
	*  return : List of Contacts
    *  Ticket Number : W-015376
	*/
    public static List<contact> getContactBySchoolId(string email, string accountId){
            List<contact> contactRecords = new List<contact>();
            contactRecords =[SELECT Id, FirstName, LastName, Email 
                          FROM Contact WHERE Email =: email 
                          AND AccountId =:accountId 
                          AND Account.Account_Status__c = 'Active'
                          AND Inactive__c = false 
                          LIMIT 1
                         ]; //W-015376: Fecth contact using registering user's email and accountId
            return contactRecords;
    }
    //The main classes SavvasDigitalSamplesService,SavvasDigitalSamplesUserRegistration have been deprecated as part of SSO project. So these methods are deprecated as well.
    /*
	*  Method Name : getContactByEmail
	*  Description : getting the contact based on email. Class is without sharing as user doesn’t have access to some objects which are referred in the class.
	*  param : email
	*  return : List of Contacts
	*/
    /*
    public static List<contact> getContactByEmail(string email){
            List<contact> userRecords = new List<contact>();
            userRecords =[SELECT Id, Email FROM Contact WHERE Email =: email LIMIT 1];
            return userRecords;
    }*/
    /*
	*  Method Name : getContactById
	*  Description : getting the List of contact based on contactId. Class is without sharing as user doesn’t have access to some objects which are referred in the class.
	*  param : contactId
	*  return : List<Contact>
	*/
    /*
    Public static List<contact> getContactById(String contactId){
            return [SELECT Id,FirstName,LastName FROM contact WHERE Id=:contactId LIMIT 1];
    }  */
}