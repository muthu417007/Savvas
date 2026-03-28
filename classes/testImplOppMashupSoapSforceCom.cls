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
private class testImplOppMashupSoapSforceCom {

    static testMethod void myUnitTest() {
        implOppMashupSoapSforceCom.AllOrNoneHeader_element aonhe = new implOppMashupSoapSforceCom.AllOrNoneHeader_element();
        implOppMashupSoapSforceCom.AllowFieldTruncationHeader_element afthe = new implOppMashupSoapSforceCom.AllowFieldTruncationHeader_element();        
        implOppMashupSoapSforceCom.AssignmentRuleHeader_element arhe = new implOppMashupSoapSforceCom.AssignmentRuleHeader_element();
        implOppMashupSoapSforceCom.DebuggingHeader_element dhe = new implOppMashupSoapSforceCom.DebuggingHeader_element();
        implOppMashupSoapSforceCom.DebuggingInfo_element die = new implOppMashupSoapSforceCom.DebuggingInfo_element();
        implOppMashupSoapSforceCom.DisableFeedTrackingHeader_element dfthe = new implOppMashupSoapSforceCom.DisableFeedTrackingHeader_element();
        implOppMashupSoapSforceCom.EmailHeader_element ehe = new implOppMashupSoapSforceCom.EmailHeader_element();
        implOppMashupSoapSforceCom.getUserInfo_element guie = new implOppMashupSoapSforceCom.getUserInfo_element();
        implOppMashupSoapSforceCom.GetUserInfoResult guir = new implOppMashupSoapSforceCom.GetUserInfoResult();
        implOppMashupSoapSforceCom.LocaleOptions_element loe = new implOppMashupSoapSforceCom.LocaleOptions_element();
        implOppMashupSoapSforceCom.loginResponse_element lre = new implOppMashupSoapSforceCom.loginResponse_element(); 
        implOppMashupSoapSforceCom.LoginResult lr = new implOppMashupSoapSforceCom.LoginResult();
        implOppMashupSoapSforceCom.LoginScopeHeader_element lshe = new implOppMashupSoapSforceCom.LoginScopeHeader_element();
        implOppMashupSoapSforceCom.MruHeader_element mhe = new implOppMashupSoapSforceCom.MruHeader_element();
        implOppMashupSoapSforceCom.PackageVersion pv = new implOppMashupSoapSforceCom.PackageVersion();
        implOppMashupSoapSforceCom.PackageVersionHeader_element pvhe = new implOppMashupSoapSforceCom.PackageVersionHeader_element();
        implOppMashupSoapSforceCom.query_element qe = new implOppMashupSoapSforceCom.query_element();
        implOppMashupSoapSforceCom.QueryOptions_element qoe = new implOppMashupSoapSforceCom.QueryOptions_element();
        implOppMashupSoapSforceCom.queryResponse_element qre = new implOppMashupSoapSforceCom.queryResponse_element();
        implOppMashupSoapSforceCom.QueryResult qr = new implOppMashupSoapSforceCom.QueryResult();
        implOppMashupSoapSforceCom.SessionHeader_element she = new implOppMashupSoapSforceCom.SessionHeader_element();
        implOppMashupSoapSforceCom.StreamingEnabledHeader_element sehe = new implOppMashupSoapSforceCom.StreamingEnabledHeader_element();
        implOppMashupSoapSforceCom.UserTerritoryDeleteHeader_element utdhe = new implOppMashupSoapSforceCom.UserTerritoryDeleteHeader_element();
        
        //sobjectMashupSoapSforceCom.sObject_x = new sobjectMashupSoapSforceCom.sObject_x();
    }
}