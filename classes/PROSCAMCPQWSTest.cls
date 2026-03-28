@isTest
//------------------------------------------------------------------------------------//
//                     Unitary Test Methods for CAMCPQWS                              //
//------------------------------------------------------------------------------------//
private class PROSCAMCPQWSTest {
    static testMethod void testMockedOperations()
    {
        // Create default CPQ settings if do not exist yet
        CameleonCPQ__CAMCPQSettings__c[] CPQSettings = [SELECT CameleonCPQ__CPQSession_EmptyQuoteQuickAction__c FROM CameleonCPQ__CAMCPQSettings__c where SetupOwnerId=:UserInfo.getOrganizationId()];
        if (CPQSettings==null || CPQSettings.size()==0) {
            CPQSettings = new CameleonCPQ__CAMCPQSettings__c[]{new CameleonCPQ__CAMCPQSettings__c(SetupOwnerId=UserInfo.getOrganizationId(), CameleonCPQ__CPQServer_EndpointURL__c='https://localhost', CameleonCPQ__CPQSession_QuoteModel_Name__c='UNIT_TEST', CameleonCPQ__CPQSession_QuoteModel_Release__c=1, CameleonCPQ__CPQSession_Theme__c='UNIT_TEST', CameleonCPQ__CPQSession_Layout__c='UNIT_TEST', CameleonCPQ__CPQSession_EmptyQuoteQuickAction__c='', CameleonCPQ__StdTrigger_Enabled__c=true, CameleonCPQ__CPQMappingSet__c='UNIT_TEST', CameleonCPQ__CPQSession_AuthPwd__c='UNIT_TEST', CameleonCPQ__CPQSession_OverviewSyncAction__c='UNIT_TEST', CameleonCPQ__CPQSession_RefreshAction__c='UNIT_TEST')}; 
            insert CPQSettings; 
        }
        Test.startTest();
        Test.setMock(WebServiceMock.class, new PROSCAMCPQWSMockImpl()); 
        PROSCAMCPQWS.cartSOAP cart = new PROSCAMCPQWS.cartSOAP();
        PROSCAMCPQWS.QuoteKeyType quoteKey = new PROSCAMCPQWS.QuoteKeyType();
        quoteKey.domain = '-';
        quoteKey.quoteId = 'CLM';
        quoteKey.release = 1;

        PROSCAMCPQWS.isQuoteLockedResponse_element response_1 = cart.isQuoteLocked(quoteKey);
        System.assertEquals(response_1.isLocked,true);
        System.assertEquals(response_1.user_x,'test@cameleon-software.com');

        PROSCAMCPQWS.getQuoteResponse_element response_2 = cart.getQuote(quoteKey,new String[0],null);
        System.assertEquals(response_2.statusAction,'OK');

        PROSCAMCPQWS.unlockQuoteResponse_element response_3 = cart.unlockQuote(quoteKey,''); 
        PROSCAMCPQWS.runUIResponse_element response_4 = cart.runUI('<cartSession><cartSession>','<cartSessionResults></cartSessionResults>',null,null,null,null);
        System.assertEquals(response_4.statusAction,'OK');
        System.assert(response_4.url.startsWith('https://cpq.mycameleon.com'));

        Test.stopTest();
    }

    static testMethod void runTestWSOP1()
    {
        Test.startTest();
        Test.setMock(WebServiceMock.class, new PROSCAMCPQWSMockImpl());

        PROSCAMCPQWS.cartSOAP cart = new PROSCAMCPQWS.cartSOAP();
        PROSCAMCPQWS.getQuoteListResponse_element response = cart.getQuoteList('Default_FORCE-1', new PROSCAMCPQWS.QueryCriterionType[0], new PROSCAMCPQWS.CustomQueryCriterionType[0]);
        System.assertEquals(response.statusAction,'OK');
        System.assertEquals(response.results.count,1);

        Test.stopTest();
    }

    static testMethod void runTestWSOP2()
    {
        Test.startTest();
        Test.setMock(WebServiceMock.class, new PROSCAMCPQWSMockImpl());

        PROSCAMCPQWS.cartSOAP cart = new PROSCAMCPQWS.cartSOAP();
        PROSCAMCPQWS.getQuoteReleasesListResponse_element response = cart.getQuoteReleasesList('');
        System.assertEquals(response.statusAction,'OK');
        System.assert(response.xmlReleasesList.startsWith('<releasesList '));

        Test.stopTest();
    }
    
    static testMethod void runTestInitWSObjects()
    {
        // Create default CPQ settings if do not exist yet
        CameleonCPQ__CAMCPQSettings__c[] CPQSettings = [SELECT CameleonCPQ__CPQSession_EmptyQuoteQuickAction__c FROM CameleonCPQ__CAMCPQSettings__c where SetupOwnerId=:UserInfo.getOrganizationId()];
        if (CPQSettings==null || CPQSettings.size()==0) {
            CPQSettings = new CameleonCPQ__CAMCPQSettings__c[]{new CameleonCPQ__CAMCPQSettings__c(SetupOwnerId=UserInfo.getOrganizationId(), CameleonCPQ__CPQServer_EndpointURL__c='https://localhost', CameleonCPQ__CPQSession_QuoteModel_Name__c='UNIT_TEST', CameleonCPQ__CPQSession_QuoteModel_Release__c=1, CameleonCPQ__CPQSession_Theme__c='UNIT_TEST', CameleonCPQ__CPQSession_Layout__c='UNIT_TEST', CameleonCPQ__CPQSession_EmptyQuoteQuickAction__c='', CameleonCPQ__StdTrigger_Enabled__c=true, CameleonCPQ__CPQMappingSet__c='UNIT_TEST', CameleonCPQ__CPQSession_AuthPwd__c='UNIT_TEST', CameleonCPQ__CPQSession_OverviewSyncAction__c='UNIT_TEST', CameleonCPQ__CPQSession_RefreshAction__c='UNIT_TEST')}; 
            insert CPQSettings; 
        }
        Test.startTest();
        Test.setMock(WebServiceMock.class, new PROSCAMCPQWSMockImpl()); 
        PROSCAMCPQWS.isQuoteLockedResponse_element re1 = new PROSCAMCPQWS.isQuoteLockedResponse_element();
        System.assertNotEquals(re1,null);
        PROSCAMCPQWS.getQuoteResponse_element re2 = new PROSCAMCPQWS.getQuoteResponse_element();
        System.assertNotEquals(re2,null);
        PROSCAMCPQWS.QueryCriterionType o1 = new PROSCAMCPQWS.QueryCriterionType();   
        System.assertNotEquals(o1,null);
        PROSCAMCPQWS.CustomQueryCriterionType o2 = new PROSCAMCPQWS.CustomQueryCriterionType();   
        System.assertNotEquals(o2,null);
        PROSCAMCPQWS.QueryResultSetType o3 = new PROSCAMCPQWS.QueryResultSetType(); 
        System.assertNotEquals(o3,null);
        PROSCAMCPQWS.unlockQuoteResponse_element re3 = new PROSCAMCPQWS.unlockQuoteResponse_element();
        System.assertNotEquals(re3,null);
        PROSCAMCPQWS.QueryRecordType o4 = new PROSCAMCPQWS.QueryRecordType();
        System.assertNotEquals(o4,null);
        PROSCAMCPQWS.runUIResponse_element re4 = new PROSCAMCPQWS.runUIResponse_element();
        System.assertNotEquals(re4,null);        
        PROSCAMCPQWS.getQuoteListResponse_element re5 = new PROSCAMCPQWS.getQuoteListResponse_element();
        System.assertNotEquals(re5,null);
        PROSCAMCPQWS.getQuoteReleasesListResponse_element re6 = new PROSCAMCPQWS.getQuoteReleasesListResponse_element();
        System.assertNotEquals(re6,null);
        Test.stopTest();
    }   
}