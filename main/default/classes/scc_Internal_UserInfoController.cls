/*Apex Class:scc_Internal_UserInfoController
        Author: zubiya
        Created Date: 22/07/2024
        Reason: .this  class used for geting  internal user info
        Description: 
        */
        public with sharing class scc_Internal_UserInfoController {
        @AuraEnabled(cacheable=true)
        public static String getOrderStatusData() {
        return null;
        }
        @AuraEnabled(cacheable=true)
        public static String getUserInformation() {
        User currentUser = [SELECT Id, Profile.Name, SAP_Account__c, IsEmployee__c  FROM User 
        WHERE Id = :UserInfo.getUserId() LIMIT 1];
        // Check if the current user is an admin
        Boolean isAdmin = currentUser.Profile.Name == 'ICOM System Administrator';
        // Create a UserInfoWrapper instance with the required details
        UserInfoWrapper userInfo = new UserInfoWrapper(currentUser.Id,  isAdmin);
        // Return serialized JSON object
        return JSON.serialize(userInfo);
        }
        // Wrapper class for user information
        public class UserInfoWrapper {
        public String userId;
        /// public String profileName;
        // public String sapAccount;
        // public Boolean isEmployee;
        public Boolean isAdmin;
        // public UserInfoWrapper(String userId, String profileName, String sapAccount, Boolean isEmployee, Boolean isAdmin) {
        public UserInfoWrapper(String userId,Boolean isAdmin) {
        this.userId = userId;
        /*this.profileName = profileName;
        this.sapAccount = sapAccount;
        this.isEmployee = isEmployee;*/
        this.isAdmin = isAdmin;
        }
        }
        }