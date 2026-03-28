/*
    @Author : Cognizant Team
    @Name : Savvas_SSO_ConstantsUtil
    @CreateDate : 11-June-2024
    @Description: Constants Utility Class for Savvas_SSO Apex Classes
    @ModifiedBy: Cognizant Team
    @ModifiedDate: 02-July-2024
    @Ticket Number: --
*/
public with sharing class Savvas_SSO_ConstantsUtil {
    public static String worktext = 'Worktext_Subscription';
    public static String ellipse = 'Ellipse';
    public static String logoutUrl = '/SavvasSingleSignOn/secur/logout.jsp';
    public static String vrfyPwdInput = 'vrfyPwdInput';
    public static String vrfyPwdInputError = 'vrfyPwdInputError';
    public static String redCross = 'Red_Cross';
    public static String colorRed = 'color:Red';
    public static String greenTick = 'Green_Tick';
    public static String colorGreen = 'color:Green';
    public static String passwordErrorMsg = 'Error: You cannot reuse this old password.';
    public static String userProvisioninglogType = 'SSO User Registration';
    public static String accountsSearchLogType = 'Accounts Search';
    public static String successUserRegLog = 'USER_REGISTRATION_SUCCEEDED';
    public static String failedUserRegLog = 'USER_REGISTRATION_FAILED';
    public static String success = 'Success';
    public static String error = 'Error';
    public static String contactNotFoundLog = 'CONTACT_NOT_FOUND';
    public static String accountNotFoundLog = 'ACCOUNT_NOT_FOUND';
    public static String accountFound = 'ACCOUNT_FOUND';
    public static String apiErrorLog = 'An error occured. Please contact your Salesforce Org Admin.';
    public static String psAssignmentFailLog = 'ACCESS_NOTIFICATION_EMAIL_FAILED';
    public static String duplicateAccessFailLog = 'DUPLICATE_ACCESS_UPDATE_REQUEST';
    public static String appMetadataNotFoundFailLog = 'APP_METADATA_NOT_FOUND';
    public static String emailTemplateFirstName = '{!Receiving_User.FirstName}';
    public static String userInsertFailLog = 'USER_INSERT_FAILED';
    public static String customSettingFailLog = 'CUSTOM_SETTING_NOT_FOUND';
    public static String isActive = 'Active';
    public static String accessNotificationEmailFailLog = 'ACCESS_NOTIFICATION_EMAIL_FAILED';
}