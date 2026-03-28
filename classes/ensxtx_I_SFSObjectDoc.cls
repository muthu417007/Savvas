// ensxtx_I_SFSObjectDoc
//
// This interface is implemented by SalesForce Objects which are used to create
// SAP Documents with items such as Quote and Order
public interface ensxtx_I_SFSObjectDoc
{
    Object callReturnMethod(String method, Map<String, Object> params);
	SObject getSObject(Id id);
	SObject getSObject(String sapType, String sapDocNum);
  	Map<Id, SObject> getSObjectLineItems(Id id);
    Map<Id, SObject> getSObjectContacts(Id id);
    String getAccountId(SObject sfSObject);
    String getCustomerNumber(SObject sfSObject);
    String getName(SObject sfSObject);
    String getQuoteNumber(SObject sfSObject);
    String getOrderNumber(SObject sfSObject);
    String getContractNumber(SObject sfSObject);
    String getInquiryNumber(SObject sfSObject);
    String getCreditMemoNumber(SObject sfSObject);
    String getDebitMemoNumber(SObject sfSObject);
    String getReturnOrderNumber(SObject sfSObject);
    String getStatus(SObject sfSObject);
    String getOpportunityId(SObject sfSObject);    
    Id getPriceBookId(SObject sfSObject);
    Id getProductId(SObject sfsObjectLine);
    String getMaterial(SObject sfSObject, SObject sfsObjectLine);
    String getItemNumber(SObject sfsObjectLine);
    ensxtx_DS_Document_Detail sObjectToSalesDocMapping(
        SObject sfSObject,
        List<SObject> sfLineItems,
        ensxtx_DS_Document_Detail salesDocDetail,
        ensxtx_DS_SalesDocAppSettings appSettings);
    SObject salesDocMappingToSObject(
        SObject sfSObject, 
        ensxtx_DS_Document_Detail salesDocDetail,
        ensxtx_DS_SalesDocAppSettings appSettings);
    Void salesDocLineItemMappingToSObject(
        SObject sfSObject,
        ensxtx_DS_SalesDocAppSettings appSettings, 
        Map<String,Map<String,Object>> lineItemsMap);
    ensxtx_UTIL_SalesDoc.compareSAPSimulateVsSObject compareSAPSimulateVsSObject(
        ensxtx_DS_Document_Detail salesDocDetail,
        ensxtx_DS_Document_Detail salesDocDetailFromSF,
        ensxtx_DS_SalesDocAppSettings appSettings);
    Void mapCustomPricingToSalesDoc(
        ensxtx_DS_Document_Detail salesDocDetail,
        ensxtx_DS_SalesDocAppSettings appSettings);
    ensxtx_DS_Document_Detail mapChildBomFields(
        ensxtx_DS_Document_Detail salesDocDetail,
        ensxtx_DS_Document_Detail salesDocDetailFromSF,
        ensxtx_DS_SalesDocAppSettings appSettings);
}