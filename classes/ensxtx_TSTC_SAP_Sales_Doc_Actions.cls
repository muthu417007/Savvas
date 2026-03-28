@isTest
public with sharing class ensxtx_TSTC_SAP_Sales_Doc_Actions
{
    public class MOC_EnosixSalesDocument_Detail implements ensxsdk.EnosixFramework.DetailSBOGetMock
    {
        public boolean success = true;

        public void setSuccess(boolean successful)
        {
            this.success = successful;
        }

        private boolean throwException = false;

        public void setThrowException(boolean throwException)
        {
            this.throwException = throwException;
        }

        public ensxsdk.EnosixFramework.DetailObject executeGetDetail(object key)
        {
            if (throwException)
            {
                throw new CalloutException();
            }

            ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument result = new ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument();
			result.setSuccess(this.success);
            return result;
        }
    }

    @isTest
    public static void test_getDetail()
    {
        MOC_EnosixSalesDocument_Detail moc = new MOC_EnosixSalesDocument_Detail();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_EnosixSalesDocument_Detail.class, moc);
        ensxtx_CTRL_SAP_Sales_Doc_Actions.getDetail('TEST');
        moc.setThrowException(true);
        ensxtx_CTRL_SAP_Sales_Doc_Actions.getDetail('TEST');
    }

    @isTest
    public static void test_getButtons()
    {
        SObject sfObject = testSetup();

        ensxtx_CTRL_SAP_Sales_Doc_Actions.getButtons(acct.Id, '1111', 'Quote', true, true, true, true, true, true);
        ensxtx_CTRL_SAP_Sales_Doc_Actions.getButtons(acct.Id, '1112', 'Order', false, true, true, true, true, true);
        ensxtx_CTRL_SAP_Sales_Doc_Actions.getButtons(acct.Id, 'bad number', 'bad type', false, true, true, true, true, true);
    }

    @isTest
    public static void test_createReferenceButton()
    {
        SObject sfObject = testSetup();
        List<ensxtx_CTRL_SAP_Sales_Doc_Actions.ButtonClass> buttonList = new List<ensxtx_CTRL_SAP_Sales_Doc_Actions.ButtonClass>();
        Map <String, Object> pageReference = new Map<String, Object>();
        Map <String, Object> attributes = new Map<String, Object>();
        ensxtx_CTRL_SAP_Sales_Doc_Actions.createReferenceButton(sfObject, buttonList, pageReference, attributes, true, true, true);
    }

    private static Account acct;

    private static SObject testSetup()
    {
        acct = ensxtx_TSTU_SFTestObject.createTestAccount();
    	acct.Name='Acme';
    	acct.BillingCity='Cincinnatti';
        acct.put(ensxtx_UTIL_SFAccount.CustomerFieldName,'CustNum');
    	ensxtx_TSTU_SFTestObject.upsertWithRetry(acct);

        Id pricebookId = ensxtx_TSTU_SFTestObject.createTestPriceBook2();
        Opportunity opp = ensxtx_TSTU_SFTestObject.createTestOpportunity();
        opp.Name = 'Test Opp';
        opp.StageName ='Prospect';
        opp.CloseDate = system.today();
        opp.AccountId = acct.Id;
        opp.Pricebook2Id = pricebookId;
        ensxtx_TSTU_SFTestObject.upsertWithRetry(opp);
        return opp;
    }
}