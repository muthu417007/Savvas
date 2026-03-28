/*
@Author : Cognizant Team
@Name : Savvas_SSO_LoginPageControllerTest
@CreateDate : 31-May-2024
@Description: This class is test class for Savvas_SSO_LoginPageController
@ModifiedBy: Cognizant Team
@ModifiedDate: 31-May-2024
@Ticket Number: W-014600
*/
@isTest
public class Savvas_SSO_LoginPageControllerTest {
       
    /*
    *  Method Name : fetchRegistrationDetailsTest1
    *  Description : test fetchRegistrationDetails method positive scenario
    *  param : none
    *  return : none
    */   
    @isTest
    public static void fetchRegistrationDetailsTest1() {
        try{
            String appName = Savvas_SSO_ConstantsUtil.worktext;
            Test.startTest();
            String result = Savvas_SSO_LoginPageController.fetchRegistrationDetails(appName);
            Test.stopTest();
            System.assert(!String.isEmpty(result));
        } 
        catch(Exception e){
            Assert.areEqual('System.AuraHandledException',e.getTypeName(),'Exception');
        }
    }
    
    /*
    *  Method Name : fetchRegistrationDetailsTest2
    *  Description : test fetchRegistrationDetails method negetive scenario
    *  param : none
    *  return : none
    */   
    @isTest
    public static void fetchRegistrationDetailsTest2() {
        String appName = 'Worktext';
        try{
            String result = Savvas_SSO_LoginPageController.fetchRegistrationDetails(appName);
            System.assert(!String.isEmpty(result));
        }
        catch (Exception e) {
                System.assertequals(e.getMessage(), 'Script-thrown exception');        
            }

    }
}