/*
@Author : Cognizant Team
@Name : savvasVirtualSamplesCommunityHelperTest
@CreateDate : 04-Aug-2023
@Description: This class is test class for savvasVirtualSamplesCommunityHelper
@ModifiedBy: Cognizant Team
@ModifiedDate: 02-Nov-2023
@Ticket Number: VS-0012, VS-0013, VS-0024, VS-0025, VS-0029
*/

@isTest
public class SavvasVirtualSamplesCommunityHelperTest {
    @isTest
    public static void footerCtrlTest(){
        try{
            List <Savvas_VS_Community_Footer__mdt> footerDetails = SavvasVirtualSampleFooterCtrl.getFooterData();
            String cssFile = SavvasVirtualSampleFooterCtrl.fetchCssFileFromAttachment('Savvas_Footer_CSS');
            Assert.areNotEqual(null,cssFile,'cssFile is null');
        }
        catch(Exception e){
            Assert.areEqual('System.AuraHandledException',e.getTypeName(),'Exception');
        }
    }
    @isTest
    public static void programBannerCtrlTest(){
        try{
            String cssFile = SavvasVirtualSamplesProgramBannerCtrl.fetchCssFileFromAttachment('Savvas_Virtual_Sample_Program_Banner_CSS');
            Assert.areNotEqual(null,cssFile,'cssFile is null');
        }
        catch(Exception e){
            Assert.areEqual('System.AuraHandledException',e.getTypeName(),'Exception');
        }
        
    }
    @isTest(seeAllData=true)
    public static void sideBannerCtrlTest(){
        UserRole role=[SELECT Id from UserRole where name='CEO' Limit 1];
        Profile profile = [SELECT Id FROM Profile where Name='System Administrator'];
        User systemAdmin = SavvasVirtualSamplingTestFactory.getUser(profile.Id);
        systemAdmin.UserRoleId = role.Id;
        Insert systemAdmin;
        System.runAs(systemAdmin){
            Account portalAccount = SavvasVirtualSamplingTestFactory.getAccount();
            insert portalAccount;
            Contact contact = SavvasVirtualSamplingTestFactory.getContact(portalAccount.Id);
            contact.Email = 'testdummy@test.com';
            insert contact;
            Profile portalProfile = [SELECT Id FROM Profile where name = 'Savvas Sample Resources'];
            User user1 = SavvasVirtualSamplingTestFactory.getUser(portalProfile.Id);
            user1.ContactId = contact.Id;
            User1.Email = contact.Email;
            insert user1;
        }
        User user1=[select ID from User where Email='testdummy@test.com'];
        System.runAs(user1){
            String networkId = [Select Id from Network where Name = 'Savvas Sample Resources'].Id;
            SavvasVirtualSamplesCommunityHelper.ContentDetails contentDetails= new SavvasVirtualSamplesCommunityHelper.ContentDetails();
            Test.startTest();
            try{	
                contentDetails.contentId = 'Savvas CMS Default Side Banner';
                contentDetails.page = 0;
                contentDetails.pageSize = 15;
                contentDetails.language = 'en_US';
                contentDetails.filterby = 'news';
                Map<String, ConnectApi.ManagedContentNodeValue> content1 = SavvasVirtualSamplesSideBannerCtrl.getContent(ContentDetails);
                Assert.areNotEqual(null,content1,'content1 is empty');
                
                contentDetails.filterby = 'savvas_CMS_Default_Side_Banner';
                Map<String, ConnectApi.ManagedContentNodeValue> content2 = SavvasVirtualSamplesSideBannerCtrl.getContent(ContentDetails);
                Assert.areNotEqual(null,content2,'content2 is empty');
                
                contentDetails.contentId = 'Savvas Virtual CMS Side Banner';
                contentDetails.filterby = 'savvas_Virtual_CMS_Side_Banner';
                Map<String, ConnectApi.ManagedContentNodeValue> content3 = SavvasVirtualSamplesSideBannerCtrl.getContent(ContentDetails);
                Assert.areNotEqual(null,content3,'content3 is empty');
                contentDetails.language = '';
                contentDetails.filterby = 'news';  
                Map<String, ConnectApi.ManagedContentNodeValue> content4 = SavvasVirtualSamplesSideBannerCtrl.getContent(ContentDetails);
                contentDetails.contentId = 'TEST';
                contentDetails.filterby = 'savvas_Virtual_CMS_Side_Banner';
                Map<String, ConnectApi.ManagedContentNodeValue> content5 = SavvasVirtualSamplesSideBannerCtrl.getContent(ContentDetails);
            }
            catch(Exception e){
                Assert.areEqual('System.AuraHandledException', e.getTypeName(),'Exception');
            }
            try{
                String cssFile1 = SavvasVirtualSamplesSideBannerCtrl.fetchCssFileFromAttachment('Savvas_Side_Banner_Default_CSS');
                Assert.areNotEqual(null,cssFile1,'cssFile1 is null');
                String cssFile2 = SavvasVirtualSamplesSideBannerCtrl.fetchCssFileFromAttachment('Savvas_Side_Banner_Realize_CSS');
                Assert.areNotEqual(null,cssFile2,'cssFile2 is null');
                String cssEmptyFile =SavvasVirtualSamplesSideBannerCtrl.fetchCssFileFromAttachment('');
                Assert.areEqual(null,cssEmptyFile,'cssEmptyFile is not empty');
            }
            catch(Exception e){
                Assert.areEqual('System.AuraHandledException', e.getTypeName(),'Exception');
            }
            Test.stopTest();
        }
    }
    @isTest
    public static void callFlowTest(){
        try{
            SavvasVirtualSamplesCommunityHelper.FlowDetails flowDetails = new SavvasVirtualSamplesCommunityHelper.FlowDetails();
            flowDetails.sampleAssetName = '3D Issue Program Overview';
            flowDetails.sampleAssetSitecoreId = '7407e185-8a1b-4a0c-8a94-c1b0f77bee86';
            flowDetails.virtualsampleProgramName = 'enVision Mathematics';
            SavvasVirtualSampleAssetTrackingCtrl.invokeAssetTrackingFlow(flowDetails);
        }
        catch(Exception e){
            Assert.areEqual('System.AuraHandledException',e.getTypeName(),'Exception');
        }
        
    }    
}