@isTest (SeeAllData=true)
public class testAccountImplOppController {
    static testMethod void myUnitTest() {
        pagereference pageref = page.accountimplopp;
        test.setcurrentpage(pageref);
        account acct = new account(name='something',A_I_SFDC_Account_ID__c='abc123');
        insert acct;
        ApexPages.standardcontroller sc = new apexpages.standardcontroller(acct);
        accountimploppcontroller controller = new accountimploppcontroller(sc);
        //controller.getRecords();
    }
    static testMethod void myUnitTest2() {
        implOppSobjectMashupSoapSforceCom somssfc = new implOppSobjectMashupSoapSforceCom();
        implOppSobjectMashupSoapSforceCom.sObject_x x = new implOppSobjectMashupSoapSforceCom.sObject_x();
        x.Name='Something';
    }
    static testMethod void myUnitTest3() {
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
        
    }
    static testMethod void myUnitTest4() {
        implOppSobjectMashupSoapSforceCom.sObject_x s = new implOppSobjectMashupSoapSforceCom.sObject_x();
    }
    static testMethod void testMashupLoginResult() {              
        // This causes a fake response to be generated 
    
    	implOppMashupSoapSforceCom a = new implOppMashupSoapSforceCom();
    	
    	implOppMashupSoapSforceCom.Soap s = new implOppMashupSoapSforceCom.Soap();
    
        Test.setMock(WebServiceMock.class, new implOppMashupLoginResultMockImpl());
        
        // Call the method that invokes a callout 
    
        implOppMashupSoapSforceCom.LoginResult lr = s.login('Hello', 'World');
        
        //assetMashupSoapSforceCom.GetUserInfoResult guir = lr.userInfo;
        
        // Verify that a fake result is returned 
    
        //System.assertEquals('Mock response', output); 
    }
    
    static testMethod void testMashupQueryResult() {              
        // This causes a fake response to be generated 
    
    	implOppMashupSoapSforceCom a = new implOppMashupSoapSforceCom();
    	
    	implOppMashupSoapSforceCom.Soap s = new implOppMashupSoapSforceCom.Soap();
    
        Test.setMock(WebServiceMock.class, new implOppMashupQueryResultMockImpl());
        
        // Call the method that invokes a callout 
    
        implOppMashupSoapSforceCom.QueryResult qr = s.query('Hello World!');
        
        // Verify that a fake result is returned 
    
        //System.assertEquals('Mock response', output); 
    }
}