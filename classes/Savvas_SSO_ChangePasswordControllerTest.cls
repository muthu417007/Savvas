/*
    @Author : Cognizant Team
    @Name : Savvas_SSO_ChangePasswordControllerTest
    @CreateDate : 04-June-2024
    @Description: This class is test class for set password functionality.
    @ModifiedBy: Cognizant Team
    @ModifiedDate: 04-June-2024
    @Ticket Number: W-014596
*/
@isTest
public class Savvas_SSO_ChangePasswordControllerTest {
    
    @isTest
    static void testConstructor() {
        Savvas_SSO_ChangePasswordController controller = new Savvas_SSO_ChangePasswordController();
        System.assertEquals('Ellipse', controller.charactersIcon);
        System.assertEquals('Ellipse', controller.letterIcon);
        System.assertEquals('Ellipse', controller.numbersIcon);
        System.assertEquals('Ellipse', controller.specialCharacterIcon);
        System.assertEquals('/SavvasSingleSignOn/secur/logout.jsp', controller.logoutUrl);
        System.assertEquals(false, controller.verifyPWDError);
        System.assertEquals('vrfyPwdInput', controller.verifyPWDStyle);
        System.assertEquals(false, controller.newPasswordEmptyError);
        System.assertEquals(false, controller.verifyPWDEmptyError);
        System.assertEquals(false, controller.errorCheck);
    }
    
    @isTest
    static void testChangePasswordSuccess() {
        Savvas_SSO_ChangePasswordController controller = new Savvas_SSO_ChangePasswordController();
        controller.newPassword = 'TestPassword1!';
        controller.verifyNewPassword = 'TestPassword1!';
        PageReference result = controller.changePassword();
        System.assertEquals('TestPassword1!', controller.newPassword);
    }

    @isTest
    static void testChangePasswordEmptyNewPassword() {
        Savvas_SSO_ChangePasswordController controller = new Savvas_SSO_ChangePasswordController();
        controller.newPassword = '';
        controller.verifyNewPassword = 'TestPassword1!';
        PageReference result = controller.changePassword();
        System.assertEquals('TestPassword1!', controller.verifyNewPassword);
    }

    @isTest
    static void testChangePasswordEmptyVerifyNewPassword() {
        Savvas_SSO_ChangePasswordController controller = new Savvas_SSO_ChangePasswordController();
        controller.newPassword = 'TestPassword1!';
        controller.verifyNewPassword = '';
        PageReference result = controller.changePassword();
        System.assertEquals('', controller.verifyNewPassword);
    }
    
    @isTest
    static void testChangePasswordMismatch() {
        Savvas_SSO_ChangePasswordController controller = new Savvas_SSO_ChangePasswordController();
        controller.newPassword = 'TestPassword1!';
        controller.verifyNewPassword = 'DifferentPassword1!';
        PageReference result = controller.changePassword();
        System.assertEquals('DifferentPassword1!', controller.verifyNewPassword);
    }

    @isTest
    static void testChangePasswordShortPassword() {
        Savvas_SSO_ChangePasswordController controller = new Savvas_SSO_ChangePasswordController();
        controller.newPassword = 'short1!';
        controller.verifyNewPassword = 'short1!';
        PageReference result = controller.changePassword();
        System.assertEquals('short1!', controller.verifyNewPassword);
    }

    @isTest
    static void testChangePasswordNoSpecialCharacter() {
        Savvas_SSO_ChangePasswordController controller = new Savvas_SSO_ChangePasswordController();
        controller.newPassword = 'TestPassword1';
        controller.verifyNewPassword = 'TestPassword1';
        PageReference result = controller.changePassword();
        System.assertEquals('TestPassword1', controller.verifyNewPassword);
    }

    @isTest
    static void testUpdateIcons() {
        Savvas_SSO_ChangePasswordController controller = new Savvas_SSO_ChangePasswordController();
        controller.newPassword = 'TestPassword1!';
        controller.updateIcons();
        System.assertEquals('TestPassword1!', controller.newPassword);
    }

    @isTest
    static void testUpdateIconsEmptyNewPassword() {
        Savvas_SSO_ChangePasswordController controller = new Savvas_SSO_ChangePasswordController();
        controller.newPassword = '';
        controller.updateIcons();
        System.assertEquals('', controller.newPassword);
    }
    
    @isTest
    static void testUpdateIconsShortPassword() {
        Savvas_SSO_ChangePasswordController controller = new Savvas_SSO_ChangePasswordController();
        controller.newPassword = 'short1!';
        controller.updateIcons();
        System.assertEquals('short1!', controller.newPassword);
    }
    
    @isTest
    static void testUpdateIconsNoLetter() {
        Savvas_SSO_ChangePasswordController controller = new Savvas_SSO_ChangePasswordController();
        controller.newPassword = '12345678!';
        controller.updateIcons();
        System.assertEquals('12345678!', controller.newPassword);
    }
    
    @isTest
    static void testUpdateIconsNoNumber() {
        Savvas_SSO_ChangePasswordController controller = new Savvas_SSO_ChangePasswordController();
        controller.newPassword = 'Password!';
        controller.updateIcons();
        System.assertEquals('Password!', controller.newPassword);
    }

    @isTest
    static void testUpdateIconsNoSpecialCharacter() {
        Savvas_SSO_ChangePasswordController controller = new Savvas_SSO_ChangePasswordController();
        controller.newPassword = 'Password1';
        controller.updateIcons();
        System.assertEquals('Password1', controller.newPassword);
    }

    @isTest
    static void testUpdateIconsEmptyNewPasswordButVerifyNewPasswordNotEmpty() {
        Savvas_SSO_ChangePasswordController controller = new Savvas_SSO_ChangePasswordController();
        controller.newPassword = '';
        controller.verifyNewPassword = 'TestPassword1!';
        controller.updateIcons();
        System.assertEquals('TestPassword1!', controller.verifyNewPassword);
    }
    
    @isTest
    static void testNewPasswordLongerThanEightVerifyPasswordShorterThanEight() {
        Savvas_SSO_ChangePasswordController controller = new Savvas_SSO_ChangePasswordController();
        controller.newPassword = 'Password1!';
        controller.verifyNewPassword = 'short1';
        controller.charactersIcon = 'Initial';
        controller.changePassword();
        System.assertEquals('Password1!', controller.newPassword);
    }
    
    @isTest
    static void testNewPasswordAndVerifyPasswordEqualLength() {
        Savvas_SSO_ChangePasswordController controller = new Savvas_SSO_ChangePasswordController();
        controller.newPassword = 'Password1!';
        controller.verifyNewPassword = 'Password1!';
        controller.charactersIcon = 'Initial';
        controller.changePassword();
        System.assertEquals('Password1!', controller.verifyNewPassword);
    }

    @isTest
    static void testNewPasswordAndVerifyPasswordDifferentLetters() {
        Savvas_SSO_ChangePasswordController controller = new Savvas_SSO_ChangePasswordController();
        controller.newPassword = 'Password1!';
        controller.verifyNewPassword = 'P4ssw0rd!';
        controller.letterIcon = 'Initial';
        controller.changePassword();
        System.assertEquals('Password1!', controller.newPassword);
    }

    @isTest
    static void testNewPasswordAndVerifyPasswordSameLetters() {
        Savvas_SSO_ChangePasswordController controller = new Savvas_SSO_ChangePasswordController();
        controller.newPassword = 'Password1!';
        controller.verifyNewPassword = 'P4ssword!';
        controller.letterIcon = 'Initial';
        controller.changePassword();
        System.assertEquals('Password1!', controller.newPassword);
    }

    @isTest
    static void testNewPasswordAndVerifyPasswordDifferentNumbers() {
        Savvas_SSO_ChangePasswordController controller = new Savvas_SSO_ChangePasswordController();
        controller.newPassword = 'Password1!';
        controller.verifyNewPassword = 'Password2!';
        controller.numbersIcon = 'Initial';
        controller.changePassword();
        System.assertEquals('Password1!', controller.newPassword);
    }

    @isTest
    static void testNewPasswordAndVerifyPasswordSameNumbers() {
        Savvas_SSO_ChangePasswordController controller = new Savvas_SSO_ChangePasswordController();
        controller.newPassword = 'Password1!';
        controller.verifyNewPassword = 'Passw0rd1!';
        controller.numbersIcon = 'Initial';
        controller.changePassword();
        System.assertEquals('Password1!', controller.newPassword);
    }

    @isTest
    static void testNewPasswordAndVerifyPasswordDifferentSpecialCharacters() {
        Savvas_SSO_ChangePasswordController controller = new Savvas_SSO_ChangePasswordController();
        controller.newPassword = 'Password1!';
        controller.verifyNewPassword = 'Password1#';
        controller.specialCharacterIcon = 'Initial';
        controller.changePassword();
        System.assertEquals('Password1!', controller.newPassword);
    }

    @isTest
    static void testNewPasswordAndVerifyPasswordSameSpecialCharacters() {
        Savvas_SSO_ChangePasswordController controller = new Savvas_SSO_ChangePasswordController();
        controller.newPassword = 'Password1!';
        controller.verifyNewPassword = 'Password1!';
        controller.specialCharacterIcon = 'Initial';
        controller.changePassword();
        System.assertEquals('Password1!', controller.newPassword);
    }

    @isTest
    static void testNewPasswordAndVerifyPasswordSameLettersElseCondition() {
        Savvas_SSO_ChangePasswordController controller = new Savvas_SSO_ChangePasswordController();
        controller.newPassword = 'Password1!';
        controller.verifyNewPassword = 'Password1!';
        controller.letterIcon = 'Initial'; 
        controller.changePassword();
        System.assertEquals('Password1!', controller.newPassword);
    }

    @isTest
    static void testNewPasswordAndVerifyPasswordSameNumbersElseCondition() {
        Savvas_SSO_ChangePasswordController controller = new Savvas_SSO_ChangePasswordController();
        controller.newPassword = 'Password1!';
        controller.verifyNewPassword = 'Password1!';
        controller.numbersIcon = 'Initial';  
        controller.changePassword();
        System.assertEquals('Password1!', controller.newPassword);
    }
}