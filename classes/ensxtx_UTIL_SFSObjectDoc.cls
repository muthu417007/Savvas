public without sharing class ensxtx_UTIL_SFSObjectDoc
{
    private static final ensxsdk.Logger logger = new ensxsdk.Logger(ensxtx_UTIL_SFSObjectDoc.class);

    public static final String STATUS_CREATE = 'Create';

    // Indexed by sObject type name
    private static Map<String,Object> sfSObjectDocMap = new Map<String,Object>();

    @testVisible
    public static SObject sfsObject { get; private set; }

    @testVisible
    private static ensxtx_I_SFSObjectDoc loadSfsObjectDoc(SObject sfSObject)
    {
        if (sfSObject == null) return null;
        return loadSfsObjectDoc(sfSObject.getSObjectType().getDescribe().getName());
    }

    @testVisible
    private static ensxtx_I_SFSObjectDoc loadSfsObjectDoc(Id sfSObjectId)
    {
        if (sfSObjectId == null) return null;
        return loadSfsObjectDoc(sfSObjectId.getSObjectType().getDescribe().getName());
    }

    @testVisible
    private static ensxtx_I_SFSObjectDoc loadSfsObjectDoc(String sObjectTypeName)
    {
        if (String.isEmpty(sObjectTypeName)) return null;
        Object sfSObjectDoc = sfSObjectDocMap.get(sObjectTypeName);
        if (sfSObjectDoc == null)
        {
            String clsName = (String)ensxtx_UTIL_AppSettings.getValue(
                ensxtx_UTIL_AppSettings.EnterpriseApp, 
                'UTIL_SFSObjectDoc.' + sObjectTypeName,
                'ensxtx_UTIL_SF' + sObjectTypeName
            );
            Type sfsObjectDocType = Type.forName(clsName);
            if (sfsObjectDocType != null) {
                sfSObjectDoc = sfsObjectDocType.newInstance();
                if (sfSObjectDoc instanceof ensxtx_I_SFSObjectDoc) {
                    sfSObjectDocMap.put(sObjectTypeName, sfSObjectDoc);
                }
            }
        }
        return (ensxtx_I_SFSObjectDoc) sfSObjectDoc;
    }

    static List<String> SFSObjectNameList = new List<String> {
        'Opportunity', 'Quote', 'Order', 'Case', 'SBQQ__Quote__c'
    };

	public static SObject initObjectsForSAP(Id SFRecordId, String SAPDocNum, String SAPDocType)
	{
        sfsObject = null;
        if (SFRecordId != null)
        {
            sfSObject = ensxtx_UTIL_SFSObjectDoc.getSObject(SFRecordId);
        }
        if (sfSObject == null)
        {
            Integer nameTot = SFSObjectNameList.size();
            for (Integer nameCnt = 0 ; nameCnt < nameTot ; nameCnt++)
            {
                String sfsObjectName = SFSObjectNameList[nameCnt];
                sfSObject = ensxtx_UTIL_SFSObjectDoc.getSObject(sfsObjectName, SAPDocType, SAPDocNum);
                if (null != sfSObject) break;
            }
        }
        return sfsObject;
    }

    public static Object callReturnMethod(SObject sfSObject, String method, Map<String, Object> params)
	{
        ensxtx_I_SFSObjectDoc sfSObjectDoc = loadSfsObjectDoc(sfSObject);
        return sfSObjectDoc == null ? null : sfSObjectDoc.callReturnMethod(method, params);
	}

	public static SObject getSObject(Id idString)
	{
        SObject result = null;
        try 
        {
            ensxtx_I_SFSObjectDoc sfSObjectDoc = loadSfsObjectDoc(idString);
            result = sfSObjectDoc == null ? null : sfSObjectDoc.getSObject(idString);
        } 
        catch (Exception e) {}
        return result;
	}

	public static SObject getSObject(String sObjectType, String sapType, String sapDocNum)
	{
        ensxtx_I_SFSObjectDoc sfSObjectDoc = loadSfsObjectDoc(sObjectType);
        return sfSObjectDoc == null ? null : sfSObjectDoc.getSObject(sapType, sapDocNum);
	}

	public static Map<Id, SObject> getSObjectLineItems(SObject sfSObject)
	{
        ensxtx_I_SFSObjectDoc sfSObjectDoc = loadSfsObjectDoc(sfSObject);
        return sfSObjectDoc == null ? new Map<Id, SObject>() : sfSObjectDoc.getSObjectLineItems(sfSObject.Id);
	}

    public static Map<Id, SObject> getSObjectContacts(SObject sfSObject)
	{
        ensxtx_I_SFSObjectDoc sfSObjectDoc = loadSfsObjectDoc(sfSObject);
        return sfSObjectDoc == null ? new Map<Id, SObject>() : sfSObjectDoc.getSObjectContacts(sfSObject.Id);
	}

	public static Id getAccountId(SObject sfSObject)
	{
        ensxtx_I_SFSObjectDoc sfSObjectDoc = loadSfsObjectDoc(sfSObject);
        return sfSObjectDoc == null ? null : sfSObjectDoc.getAccountId(sfSObject);
	}

    public static String getCustomerNumber(SObject sfSObject)
	{
        ensxtx_I_SFSObjectDoc sfSObjectDoc = loadSfsObjectDoc(sfSObject);
        return sfSObjectDoc == null ? null : sfSObjectDoc.getCustomerNumber(sfSObject);
	}

	public static String getName(SObject sfSObject)
	{
        ensxtx_I_SFSObjectDoc sfSObjectDoc = loadSfsObjectDoc(sfSObject);
        return sfSObjectDoc == null ? '' : sfSObjectDoc.getName(sfSObject);
	}

    public static String getQuoteNumber(SObject sfSObject)
    {
        ensxtx_I_SFSObjectDoc sfSObjectDoc = loadSfsObjectDoc(sfSObject);
        return sfSObjectDoc == null ? '' : sfSObjectDoc.getQuoteNumber(sfSObject);
    }

    public static String getOrderNumber(SObject sfSObject)
    {
        ensxtx_I_SFSObjectDoc sfSObjectDoc = loadSfsObjectDoc(sfSObject);
        return sfSObjectDoc == null ? '' : sfSObjectDoc.getOrderNumber(sfSObject);
    }

    public static String getContractNumber(SObject sfSObject)
    {
        ensxtx_I_SFSObjectDoc sfSObjectDoc = loadSfsObjectDoc(sfSObject);
        return sfSObjectDoc == null ? '' : sfSObjectDoc.getContractNumber(sfSObject);
    }

    public static String getInquiryNumber(SObject sfSObject)
    {
        ensxtx_I_SFSObjectDoc sfSObjectDoc = loadSfsObjectDoc(sfSObject);
        return sfSObjectDoc == null ? '' : sfSObjectDoc.getInquiryNumber(sfSObject);
    }

    public static String getCreditMemoNumber(SObject sfSObject)
    {
        ensxtx_I_SFSObjectDoc sfSObjectDoc = loadSfsObjectDoc(sfSObject);
        return sfSObjectDoc == null ? '' : sfSObjectDoc.getCreditMemoNumber(sfSObject);
    }

    public static String getDebitMemoNumber(SObject sfSObject)
    {
        ensxtx_I_SFSObjectDoc sfSObjectDoc = loadSfsObjectDoc(sfSObject);
        return sfSObjectDoc == null ? '' : sfSObjectDoc.getDebitMemoNumber(sfSObject);
    }

    public static String getReturnOrderNumber(SObject sfSObject)
    {
        ensxtx_I_SFSObjectDoc sfSObjectDoc = loadSfsObjectDoc(sfSObject);
        return sfSObjectDoc == null ? '' : sfSObjectDoc.getReturnOrderNumber(sfSObject);
    }

    public static String getStatus(SObject sfSObject)
	{
        ensxtx_I_SFSObjectDoc sfSObjectDoc = loadSfsObjectDoc(sfSObject);
        return sfSObjectDoc == null ? null : sfSObjectDoc.getStatus(sfSObject);
	}

	public static Id getOpportunityId(SObject sfSObject)
	{
        ensxtx_I_SFSObjectDoc sfSObjectDoc = loadSfsObjectDoc(sfSObject);
        return sfSObjectDoc == null ? null : sfSObjectDoc.getOpportunityId(sfSObject);
	}

    public static Id getPriceBookId(SObject sfSObject)
    {
        ensxtx_I_SFSObjectDoc sfSObjectDoc = loadSfsObjectDoc(sfSObject);
        return sfSObjectDoc == null ? null : sfSObjectDoc.getPriceBookId(sfSObject);
    }

    public static Id getProductId(SObject sfSObject, SObject sfsObjectLine)
    {
        ensxtx_I_SFSObjectDoc sfSObjectDoc = loadSfsObjectDoc(sfSObject);
        return sfSObjectDoc == null ? null : sfSObjectDoc.getProductId(sfsObjectLine);
    }

    public static String getMaterial(SObject sfSObject, SObject sfsObjectLine)
    {
        ensxtx_I_SFSObjectDoc sfSObjectDoc = loadSfsObjectDoc(sfSObject);
        return sfSObjectDoc == null ? null : sfSObjectDoc.getMaterial(sfSObject, sfsObjectLine);
    }

    public static String getItemNumber(SObject sfSObject, SObject sfsObjectLine)
    {
        ensxtx_I_SFSObjectDoc sfSObjectDoc = loadSfsObjectDoc(sfSObject);
        return sfSObjectDoc == null ? '' : sfSObjectDoc.getItemNumber(sfsObjectLine);
    }

    public static ensxtx_DS_Document_Detail sObjectToSalesDocMapping(
        SObject sfSObject,
        List<SObject> sfLineItems,
        ensxtx_DS_Document_Detail salesDocDetail,
        ensxtx_DS_SalesDocAppSettings appSettings)
    {
        ensxtx_I_SFSObjectDoc sfSObjectDoc = loadSfsObjectDoc(sfSObject);
        return sfSObjectDoc == null ? null : sfSObjectDoc.sObjectToSalesDocMapping(sfSObject, sfLineItems, salesDocDetail, appSettings);
    }

    public static SObject salesDocMappingToSObject(
        SObject sfSObject, 
        ensxtx_DS_Document_Detail salesDocDetail,
        ensxtx_DS_SalesDocAppSettings appSettings)
    {
        ensxtx_I_SFSObjectDoc sfSObjectDoc = loadSfsObjectDoc(sfSObject);
        return sfSObjectDoc == null ? null : sfSObjectDoc.salesDocMappingToSObject(sfSObject, salesDocDetail, appSettings);
    }

    public static Void salesDocLineItemMappingToSObject(
        SObject sfSObject, 
        ensxtx_DS_SalesDocAppSettings appSettings, 
        Map<String,Map<String,Object>> lineItemsMap)
    {
        ensxtx_I_SFSObjectDoc sfSObjectDoc = loadSfsObjectDoc(sfSObject);
        if (sfSObjectDoc != null) sfSObjectDoc.salesDocLineItemMappingToSObject(sfSObject, appSettings, lineItemsMap);
    }

    public static ensxtx_UTIL_SalesDoc.compareSAPSimulateVsSObject compareSAPSimulateVsSObject(
        ensxtx_DS_Document_Detail salesDocDetail,
        ensxtx_DS_Document_Detail salesDocDetailFromSF,
        ensxtx_DS_SalesDocAppSettings appSettings)
    {
        ensxtx_I_SFSObjectDoc sfSObjectDoc = loadSfsObjectDoc(salesDocDetail.SFId);
        return sfSObjectDoc == null ? new ensxtx_UTIL_SalesDoc.compareSAPSimulateVsSObject() : sfSObjectDoc.compareSAPSimulateVsSObject(salesDocDetail, salesDocDetailFromSF, appSettings);
    }

    public static Void mapCustomPricingToSalesDoc(
        ensxtx_DS_Document_Detail salesDocDetail,
        ensxtx_DS_SalesDocAppSettings appSettings)
    {
        ensxtx_I_SFSObjectDoc sfSObjectDoc = loadSfsObjectDoc(salesDocDetail.SFId);
        if (sfSObjectDoc != null) sfSObjectDoc.mapCustomPricingToSalesDoc(salesDocDetail, appSettings);
    }

    public static ensxtx_DS_Document_Detail mapChildBomFields(
        ensxtx_DS_Document_Detail salesDocDetail,
        ensxtx_DS_Document_Detail salesDocDetailFromSF,
        ensxtx_DS_SalesDocAppSettings appSettings)
    {
        ensxtx_DS_Document_Detail result = null;
        ensxtx_I_SFSObjectDoc sfSObjectDoc = loadSfsObjectDoc(salesDocDetail.SFId);
        return sfSObjectDoc == null ? null : sfSObjectDoc.mapChildBomFields(salesDocDetail, salesDocDetailFromSF, appSettings);
    }
}