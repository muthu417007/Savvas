/*********************************************************** 
* @Class Name  - scc_forgotPassword_controller_Test
* @description - Test class for scc_forgotPassword_controller
* @Created By  - CTS- balamurugan D
* @Created On - 2024-07-22
* **********************************************************/ 
@isTest
public class scc_forgotPassword_controller_Test {
    @isTest
    static void sccForgotPasswordTest(){
        System.assertEquals(false,scc_forgotPassword_controller.sccForgotPassword('test1@user.com'), Label.Site.invalid_email);
        System.assertEquals(false,scc_forgotPassword_controller.sccForgotPassword('1232'), Label.Site.invalid_email); 
    }
}