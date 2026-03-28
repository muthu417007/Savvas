@isTest (SeeAllData=true)
public class testAccountAssetsController {
    static testMethod void myUnitTest() {
        pagereference pageref = page.accountassets;
        test.setcurrentpage(pageref);
        account acct = new account(name='something',A_I_SFDC_Account_ID__c='abc123');
        insert acct;
        ApexPages.standardcontroller sc = new apexpages.standardcontroller(acct);
        accountassetscontroller controller = new accountassetscontroller(sc);
        //controller.getRecords();
    }
    static testMethod void myUnitTest2() {
        assetSobjectMashupSoapSforceCom somssfc = new assetSobjectMashupSoapSforceCom();
        assetSobjectMashupSoapSforceCom.sObject_x x = new assetSobjectMashupSoapSforceCom.sObject_x();
        x.Name='Something';
    }
    static testMethod void myUnitTest3() {
    	assetMashupSoapSforceCom a;
        assetMashupSoapSforceCom.AllOrNoneHeader_element aonhe;
        assetMashupSoapSforceCom.AllowFieldTruncationHeader_element afthe;        
        assetMashupSoapSforceCom.AssignmentRuleHeader_element arhe;
        assetMashupSoapSforceCom.DebuggingHeader_element dhe;
        assetMashupSoapSforceCom.DebuggingInfo_element die;
        assetMashupSoapSforceCom.DisableFeedTrackingHeader_element dfthe;
        assetMashupSoapSforceCom.EmailHeader_element ehe;
        assetMashupSoapSforceCom.getUserInfo_element guie;
        assetMashupSoapSforceCom.GetUserInfoResult guir;
        assetMashupSoapSforceCom.LocaleOptions_element loe;
        assetMashupSoapSforceCom.loginResponse_element lre; 
        assetMashupSoapSforceCom.LoginResult lr;
        assetMashupSoapSforceCom.LoginScopeHeader_element lshe;
        assetMashupSoapSforceCom.MruHeader_element mhe;
        assetMashupSoapSforceCom.PackageVersion pv;
        assetMashupSoapSforceCom.PackageVersionHeader_element pvhe;
        assetMashupSoapSforceCom.query_element qe;
        assetMashupSoapSforceCom.QueryOptions_element qoe;
        assetMashupSoapSforceCom.queryResponse_element qre;
        assetMashupSoapSforceCom.QueryResult qr;
        assetMashupSoapSforceCom.SessionHeader_element she;
        assetMashupSoapSforceCom.StreamingEnabledHeader_element sehe;
        assetMashupSoapSforceCom.UserTerritoryDeleteHeader_element utdhe;
    }
    static testMethod void myUnitTest4() {
        assetSobjectMashupSoapSforceCom.sObject_x s = new assetSobjectMashupSoapSforceCom.sObject_x();
    }
    static testMethod void testAssetMashupLoginResult() {              
        // This causes a fake response to be generated 
    
    	assetMashupSoapSforceCom a = new assetMashupSoapSforceCom();
    	
    	assetMashupSoapSforceCom.Soap s = new assetMashupSoapSforceCom.Soap();
    
        Test.setMock(WebServiceMock.class, new assetMashupLoginResultMockImpl());
        
        // Call the method that invokes a callout 
    
        assetMashupSoapSforceCom.LoginResult lr = s.login('Hello', 'World');
        
        //assetMashupSoapSforceCom.GetUserInfoResult guir = lr.userInfo;
        
        // Verify that a fake result is returned 
    
        //System.assertEquals('Mock response', output); 
    }
    
    static testMethod void testAssetMashupQueryResult() {              
        // This causes a fake response to be generated 
    
    	assetMashupSoapSforceCom a = new assetMashupSoapSforceCom();
    	
    	assetMashupSoapSforceCom.Soap s = new assetMashupSoapSforceCom.Soap();
    
        Test.setMock(WebServiceMock.class, new assetMashupQueryResultMockImpl());
        
        // Call the method that invokes a callout 
    
        assetMashupSoapSforceCom.QueryResult qr = s.query('Hello World!');
        
        // Verify that a fake result is returned 
    
        //System.assertEquals('Mock response', output); 
    }
}