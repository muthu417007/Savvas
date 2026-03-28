/// enosiX Inc. Generated Apex Model
/// Generated On: 7/17/2018 8:36:26 PM
/// SAP Host: From REST Service On: https://computing-velocity-5898-dev-ed.cs54.my.salesforce.com
/// CID: From REST Service On: https://computing-velocity-5898-dev-ed.cs54.my.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework ensxapp.v1.2

@isTest
private class ensxtx_TSTC_CPQ_Partners
{
    @isTest
    static void test_getPartnerList()
    {
        Mockensxtx_SBO_EnosixCustomer_Detail cdmock = new Mockensxtx_SBO_EnosixCustomer_Detail();
        Mockensxtx_SBO_SFCICustomer_Search cmock = new Mockensxtx_SBO_SFCICustomer_Search(true);
        Mockensxtx_SBO_SFCIPartner_Search pmock = new Mockensxtx_SBO_SFCIPartner_Search();

        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_EnosixCustomer_Detail.class, cdmock);
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_SFCICustomer_Search.class, cmock);
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_SFCIPartner_Search.class, pmock);

        cdmock.setSuccess(false);
        Account acct = ensxtx_TSTU_SFTestObject.createTestAccount();
        acct.put(ensxtx_UTIL_SFAccount.CustomerFieldName,'CustNum');
    	ensxtx_TSTU_SFTestObject.upsertWithRetry(acct);
        SBQQ__Quote__c quote = ensxtx_TSTU_SFCPQQuote.createTestQuote();
        ensxtx_TSTU_SFTestObject.upsertWithRetry(quote);
        ensxtx_UTIL_Aura.Response rslt = ensxtx_CTRL_CPQ_Partners.getPartnerList(null, 'soldToParty');
        rslt = ensxtx_CTRL_CPQ_Partners.getPartnerList(quote.Id, 'soldToParty');
        quote.SBQQ__Account__c = acct.Id;
        quote.ensxtx_Sales_Organization__c = 'SO';
        quote.ensxtx_Distribution_Channel__c = 'DC';
        quote.ensxtx_Division__c = 'D';
        ensxtx_TSTU_SFTestObject.upsertWithRetry(quote);
        rslt = ensxtx_CTRL_CPQ_Partners.getPartnerList(quote.Id, 'soldToParty');
        rslt = ensxtx_CTRL_CPQ_Partners.getPartnerList(quote.Id, 'shipToParty');
        rslt = ensxtx_CTRL_CPQ_Partners.getPartnerList(quote.Id, 'billToParty');
        rslt = ensxtx_CTRL_CPQ_Partners.getPartnerList(quote.Id, 'payerParty');
        rslt = ensxtx_CTRL_CPQ_Partners.getPartnerList(quote.Id, 'badPartnerField');
        cdmock.setSuccess(true);
        cdmock.setThrowException(true);
        rslt = ensxtx_CTRL_CPQ_Partners.getPartnerList(quote.Id, 'soldToParty');
        cdmock.setThrowException(false);
        rslt = ensxtx_CTRL_CPQ_Partners.getPartnerList(quote.Id, 'soldToParty');
        pmock.setReturn(false);
        rslt = ensxtx_CTRL_CPQ_Partners.getPartnerList(quote.Id, 'soldToParty');
    }

    @isTest
    static void test_updatePartner()
    {
        Mockensxtx_SBO_EnosixCustomer_Detail cdmock = new Mockensxtx_SBO_EnosixCustomer_Detail();
        Mockensxtx_SBO_SFCICustomer_Search cmock = new Mockensxtx_SBO_SFCICustomer_Search(true);
        Mockensxtx_SBO_SFCIPartner_Search pmock = new Mockensxtx_SBO_SFCIPartner_Search();

        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_EnosixCustomer_Detail.class, cdmock);
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_SFCICustomer_Search.class, cmock);
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_SFCIPartner_Search.class, pmock);

        cdmock.setSuccess(false);
        Account acct = ensxtx_TSTU_SFTestObject.createTestAccount();
        acct.put(ensxtx_UTIL_SFAccount.CustomerFieldName,'CustNum');
    	ensxtx_TSTU_SFTestObject.upsertWithRetry(acct);
        SBQQ__Quote__c quote = ensxtx_TSTU_SFCPQQuote.createTestQuote();
        quote.ensxtx_Sales_Organization__c = 'SO';
        quote.ensxtx_Distribution_Channel__c = 'DC';
        quote.ensxtx_Division__c = 'D';
        ensxtx_TSTU_SFTestObject.upsertWithRetry(quote);
        Map<String, Object> params = new Map<String, Object>();
        ensxtx_UTIL_Aura.Response rslt = ensxtx_CTRL_CPQ_Partners.updatePartner(params);
        params.put('quoteId',quote.Id);
        rslt = ensxtx_CTRL_CPQ_Partners.updatePartner(params);
        Map<String, Object> partner = new Map<String, Object>();
        partner.put('partnerNumber','partnerNumber');
        params.put('partnerJSON',JSON.serialize(partner));
        rslt = ensxtx_CTRL_CPQ_Partners.updatePartner(params);
        params.put('partnerField','shipToParty');
        rslt = ensxtx_CTRL_CPQ_Partners.updatePartner(params);
        params.put('partnerField','billToParty');
        rslt = ensxtx_CTRL_CPQ_Partners.updatePartner(params);
        params.put('partnerField','payerParty');
        rslt = ensxtx_CTRL_CPQ_Partners.updatePartner(params);
        cdmock.setSuccess(true);
        cdmock.setThrowException(true);
        rslt = ensxtx_CTRL_CPQ_Partners.updatePartner(params);
        cdmock.setThrowException(false);
        rslt = ensxtx_CTRL_CPQ_Partners.updatePartner(params);
        pmock.setReturn(false);
        rslt = ensxtx_CTRL_CPQ_Partners.updatePartner(params);
        
    }

    public class Mockensxtx_SBO_SFCICustomer_Search implements ensxsdk.EnosixFramework.SearchSBOInitMock, ensxsdk.EnosixFramework.SearchSBOSearchMock
    {
        Boolean success = true;

        public Mockensxtx_SBO_SFCICustomer_Search(Boolean success)
        {
            this.success = success;
        }
        
        public ensxsdk.EnosixFramework.SearchContext executeInitialize(ensxsdk.EnosixFramework.SearchContext sc)
        {
            return null;
        }

        public ensxsdk.EnosixFramework.SearchContext executeSearch(ensxsdk.EnosixFramework.SearchContext searchContext)
        {
            ensxtx_SBO_SFCICustomer_Search.SFCICustomer_SR searchResult = new ensxtx_SBO_SFCICustomer_Search.SFCICustomer_SR();

            if (success)
            {
                ensxtx_SBO_SFCICustomer_Search.SEARCHRESULT row = new ensxtx_SBO_SFCICustomer_Search.SEARCHRESULT();
                row.CustomerNumber = 'TEST';
                row.Name = 'TEST';
                searchResult.SearchResults.add(row);
            }

            searchResult.setSuccess(success);
            searchContext.baseResult = searchResult;
            return searchContext;
        }
    }

    public class Mockensxtx_SBO_SFCIPartner_Search implements ensxsdk.EnosixFramework.SearchSBOInitMock, ensxsdk.EnosixFramework.SearchSBOSearchMock
    {
        private boolean returnResults = true;

        public void setReturn(boolean returnResults)
        {
            this.returnResults = returnResults;
        }
        
        public ensxsdk.EnosixFramework.SearchContext executeInitialize(ensxsdk.EnosixFramework.SearchContext sc)
        {
            return null;
        }

        public ensxsdk.EnosixFramework.SearchContext executeSearch(ensxsdk.EnosixFramework.SearchContext sc)
        {
            ensxtx_SBO_SFCIPartner_Search.SFCIPartner_SR search_result = new ensxtx_SBO_SFCIPartner_Search.SFCIPartner_SR();
            ensxtx_SBO_SFCIPartner_Search.SEARCHRESULT result = new ensxtx_SBO_SFCIPartner_Search.SEARCHRESULT();
            
            result.City='TEST';
            result.ContactFirstName = 'TEST';
            result.ContactLastName = 'TEST';
            result.ContactNumber = 'TEST';
            result.Country = 'TEST';
            result.DistributionChannel = 'TEST';
            result.Division = 'TEST';
            result.HouseNumber = 'TEST';
            result.PartnerName = 'TEST';
            result.PartnerNumber = 'TEST';
            result.PartnerFunction = 'TEST';
            result.PartnerFunctionName = 'TEST';
            result.PersonnelFirstName = 'TEST';
            result.PersonnelLastName = 'TEST';
            result.PersonnelNumber = 'TEST';
            result.PostalCode = 'TEST';
            result.Region = 'TEST';
            result.SalesOrganization = 'TEST';
            result.Street = 'TEST';
            result.VendorName = 'TEST';
            result.VendorNumber = 'TEST';

            if (this.returnResults)
            {
                search_result.SearchResults.add(result);
            }

            search_result.setSuccess(true);
            sc.baseResult = search_result;

            return sc;
        }
    }   
    
    public class Mockensxtx_SBO_EnosixCustomer_Detail implements
        ensxsdk.EnosixFramework.DetailSBOInitMock,
        ensxsdk.EnosixFramework.DetailSBOCommandMock,
        ensxsdk.EnosixFramework.DetailSBOGetMock,
        ensxsdk.EnosixFramework.DetailSBOSaveMock
    {
        private boolean success = true;

        public void setSuccess(boolean successful)
        {
            this.success = successful;
        }

        private boolean throwException = false;

        public void setThrowException(boolean throwException)
        {
            this.throwException = throwException;
        }

        public ensxsdk.EnosixFramework.DetailObject executeInitialize(ensxsdk.EnosixFramework.DetailObject initialState) 
        { 
            return null; 
        }

        public ensxsdk.EnosixFramework.DetailObject executeCommand(String command, ensxsdk.EnosixFramework.DetailObject obj) 
        { 
            return null; 
        }

        public ensxsdk.EnosixFramework.DetailObject executeGetDetail(object key) 
        { 
            if (throwException)
            {
                throw new CalloutException();
            }
            ensxtx_SBO_EnosixCustomer_Detail.EnosixCustomer result = new ensxtx_SBO_EnosixCustomer_Detail.EnosixCustomer();
            
            result.setSuccess(this.success);
            return result;
        }

        public ensxsdk.EnosixFramework.DetailObject executeSave(ensxsdk.EnosixFramework.DetailObject obj) 
        { 
            return null; 
        }
    }
}