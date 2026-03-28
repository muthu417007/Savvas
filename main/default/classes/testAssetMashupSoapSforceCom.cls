/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class testAssetMashupSoapSforceCom {

    static testMethod void myUnitTest() {
        assetMashupSoapSforceCom.AllOrNoneHeader_element aonhe = new assetMashupSoapSforceCom.AllOrNoneHeader_element();
        assetMashupSoapSforceCom.AllowFieldTruncationHeader_element afthe = new assetMashupSoapSforceCom.AllowFieldTruncationHeader_element();        
        assetMashupSoapSforceCom.AssignmentRuleHeader_element arhe = new assetMashupSoapSforceCom.AssignmentRuleHeader_element();
        assetMashupSoapSforceCom.DebuggingHeader_element dhe = new assetMashupSoapSforceCom.DebuggingHeader_element();
        assetMashupSoapSforceCom.DebuggingInfo_element die = new assetMashupSoapSforceCom.DebuggingInfo_element();
        assetMashupSoapSforceCom.DisableFeedTrackingHeader_element dfthe = new assetMashupSoapSforceCom.DisableFeedTrackingHeader_element();
        assetMashupSoapSforceCom.EmailHeader_element ehe = new assetMashupSoapSforceCom.EmailHeader_element();
        assetMashupSoapSforceCom.getUserInfo_element guie = new assetMashupSoapSforceCom.getUserInfo_element();
        assetMashupSoapSforceCom.GetUserInfoResult guir = new assetMashupSoapSforceCom.GetUserInfoResult();
        assetMashupSoapSforceCom.LocaleOptions_element loe = new assetMashupSoapSforceCom.LocaleOptions_element();
        assetMashupSoapSforceCom.loginResponse_element lre = new assetMashupSoapSforceCom.loginResponse_element(); 
        assetMashupSoapSforceCom.LoginResult lr = new assetMashupSoapSforceCom.LoginResult();
        assetMashupSoapSforceCom.LoginScopeHeader_element lshe = new assetMashupSoapSforceCom.LoginScopeHeader_element();
        assetMashupSoapSforceCom.MruHeader_element mhe = new assetMashupSoapSforceCom.MruHeader_element();
        assetMashupSoapSforceCom.PackageVersion pv = new assetMashupSoapSforceCom.PackageVersion();
        assetMashupSoapSforceCom.PackageVersionHeader_element pvhe = new assetMashupSoapSforceCom.PackageVersionHeader_element();
        assetMashupSoapSforceCom.query_element qe = new assetMashupSoapSforceCom.query_element();
        assetMashupSoapSforceCom.QueryOptions_element qoe = new assetMashupSoapSforceCom.QueryOptions_element();
        assetMashupSoapSforceCom.queryResponse_element qre = new assetMashupSoapSforceCom.queryResponse_element();
        assetMashupSoapSforceCom.QueryResult qr = new assetMashupSoapSforceCom.QueryResult();
        assetMashupSoapSforceCom.SessionHeader_element she = new assetMashupSoapSforceCom.SessionHeader_element();
        assetMashupSoapSforceCom.StreamingEnabledHeader_element sehe = new assetMashupSoapSforceCom.StreamingEnabledHeader_element();
        assetMashupSoapSforceCom.UserTerritoryDeleteHeader_element utdhe = new assetMashupSoapSforceCom.UserTerritoryDeleteHeader_element();
        
        //sobjectMashupSoapSforceCom.sObject_x = new sobjectMashupSoapSforceCom.sObject_x();
    }
}