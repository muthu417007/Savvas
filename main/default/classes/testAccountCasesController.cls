@isTest (SeeAllData=true)
public class testAccountCasesController {
	static testMethod void myUnitTest() {
		pagereference pageref = page.accountcases;
		test.setcurrentpage(pageref);
		account acct = new account(name='something',A_I_SFDC_Account_ID__c='abc123');
		insert acct;
		ApexPages.standardcontroller sc = new apexpages.standardcontroller(acct);
		accountcasescontroller controller = new accountcasescontroller(sc);
		//controller.getRecords();
	}
	static testMethod void myUnitTest2() {
        sobjectMashupSoapSforceCom somssfc = new sobjectMashupSoapSforceCom();
        sobjectMashupSoapSforceCom.sObject_x x = new sobjectMashupSoapSforceCom.sObject_x();
        x.Name='Something';
    }
    static testMethod void myUnitTest3() {
        mashupSoapSforceCom.AllOrNoneHeader_element aonhe = new mashupSoapSforceCom.AllOrNoneHeader_element();
		mashupSoapSforceCom.AllowFieldTruncationHeader_element afthe = new mashupSoapSforceCom.AllowFieldTruncationHeader_element();        
        mashupSoapSforceCom.AssignmentRuleHeader_element arhe = new mashupSoapSforceCom.AssignmentRuleHeader_element();
        mashupSoapSforceCom.DebuggingHeader_element dhe = new mashupSoapSforceCom.DebuggingHeader_element();
        mashupSoapSforceCom.DebuggingInfo_element die = new mashupSoapSforceCom.DebuggingInfo_element();
        mashupSoapSforceCom.DisableFeedTrackingHeader_element dfthe = new mashupSoapSforceCom.DisableFeedTrackingHeader_element();
        mashupSoapSforceCom.EmailHeader_element ehe = new mashupSoapSforceCom.EmailHeader_element();
        mashupSoapSforceCom.getUserInfo_element guie = new mashupSoapSforceCom.getUserInfo_element();
    	mashupSoapSforceCom.GetUserInfoResult guir = new mashupSoapSforceCom.GetUserInfoResult();
    	mashupSoapSforceCom.LocaleOptions_element loe = new mashupSoapSforceCom.LocaleOptions_element();
    	mashupSoapSforceCom.loginResponse_element lre = new mashupSoapSforceCom.loginResponse_element(); 
    	mashupSoapSforceCom.LoginResult lr = new mashupSoapSforceCom.LoginResult();
		mashupSoapSforceCom.LoginScopeHeader_element lshe = new mashupSoapSforceCom.LoginScopeHeader_element();
		mashupSoapSforceCom.MruHeader_element mhe = new mashupSoapSforceCom.MruHeader_element();
		mashupSoapSforceCom.PackageVersion pv = new mashupSoapSforceCom.PackageVersion();
		mashupSoapSforceCom.PackageVersionHeader_element pvhe = new mashupSoapSforceCom.PackageVersionHeader_element();
		mashupSoapSforceCom.query_element qe = new mashupSoapSforceCom.query_element();
		mashupSoapSforceCom.QueryOptions_element qoe = new mashupSoapSforceCom.QueryOptions_element();
		mashupSoapSforceCom.queryResponse_element qre = new mashupSoapSforceCom.queryResponse_element();
		mashupSoapSforceCom.QueryResult qr = new mashupSoapSforceCom.QueryResult();
		mashupSoapSforceCom.SessionHeader_element she = new mashupSoapSforceCom.SessionHeader_element();
		mashupSoapSforceCom.StreamingEnabledHeader_element sehe = new mashupSoapSforceCom.StreamingEnabledHeader_element();
		mashupSoapSforceCom.UserTerritoryDeleteHeader_element utdhe = new mashupSoapSforceCom.UserTerritoryDeleteHeader_element();
		
    }
 	static testMethod void myUnitTest4() {
        sobjectMashupSoapSforceCom.sObject_x s = new sobjectMashupSoapSforceCom.sObject_x();
    }
    static testMethod void testMashupLoginResult() {              
        // This causes a fake response to be generated 
    
    	mashupSoapSforceCom a = new mashupSoapSforceCom();
    	
    	mashupSoapSforceCom.Soap s = new mashupSoapSforceCom.Soap();
    
        Test.setMock(WebServiceMock.class, new mashupLoginResultMockImpl());
        
        // Call the method that invokes a callout 
    
        mashupSoapSforceCom.LoginResult lr = s.login('Hello', 'World');
        
        //assetMashupSoapSforceCom.GetUserInfoResult guir = lr.userInfo;
        
        // Verify that a fake result is returned 
    
        //System.assertEquals('Mock response', output); 
    }
    
    static testMethod void testMashupQueryResult() {              
        // This causes a fake response to be generated 
    
    	mashupSoapSforceCom a = new mashupSoapSforceCom();
    	
    	mashupSoapSforceCom.Soap s = new mashupSoapSforceCom.Soap();
    
        Test.setMock(WebServiceMock.class, new mashupQueryResultMockImpl());
        
        // Call the method that invokes a callout 
    
        mashupSoapSforceCom.QueryResult qr = s.query('Hello World!');
        
        // Verify that a fake result is returned 
    
        //System.assertEquals('Mock response', output); 
    }
}