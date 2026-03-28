/*Apex Class:scc_Internal_UserInfoController
Author: zubiya
Created Date: 22/07/2024
Reason: .this  class used for geting  internal user info
Description: 
*/
@IsTest
public class scc_Internal_UserInfoControllerTest {
    @IsTest
    static void testGetUserInformation() {
        // Create a test user
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'ICOM System Administrator' LIMIT 1];
        User testUser = new User(
            LastName = 'Test User',
            Email = 'test$intuser@savvas.com',
            Username = 'test$intuser@savvas.com',
            Alias = 'tuser',
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = profile.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
        // Set the context user to test user
        System.runAs(testUser) {
            // Call the method and deserialize the response
            String jsonResult = scc_Internal_UserInfoController.getUserInformation();
            scc_Internal_UserInfoController.UserInfoWrapper userInfo = (scc_Internal_UserInfoController.UserInfoWrapper) JSON.deserialize(jsonResult, scc_Internal_UserInfoController.UserInfoWrapper.class);
            scc_Internal_UserInfoController.getOrderStatusData();
            // Assert the results
            System.assertEquals(testUser.Id, userInfo.userId, 'User ID should match');
           // System.assertEquals('ICOM System Administrator', userInfo.profileName, 'Profile name should match');
            //System.assertEquals(userInfo.isAdmin, 'User should be an admin');
        }
    }
}