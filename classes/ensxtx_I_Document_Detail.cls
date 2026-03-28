public interface ensxtx_I_Document_Detail
{
    String getSimulateCommand();
    String getReferenceDocumentCommand();
    String getMaterialBomCountCommand();
    
    ensxsdk.EnosixFramework.DetailObject removeAllConditions(
        ensxsdk.EnosixFramework.DetailObject detailObj);

    ensxsdk.EnosixFramework.DetailObject updateSimulateBeforeUpdate(
        ensxsdk.EnosixFramework.DetailObject detailObj, 
        ensxtx_DS_Document_Detail docObj,
        ensxtx_DS_SalesDocAppSettings appSettings);

    ensxsdk.EnosixFramework.DetailObject buildSBOForReference(
        String salesDocNumber, String salesDocType);

    ensxsdk.EnosixFramework.DetailObject convertToSBO(
        ensxsdk.EnosixFramework.DetailObject sboObject, 
        ensxtx_DS_Document_Detail docObj,
        Boolean isUpdate,
        ensxtx_DS_SalesDocAppSettings appSettings);

    void convertToObject(
        ensxsdk.EnosixFramework.DetailObject sboObject, 
        ensxtx_DS_Document_Detail docObj,
        Boolean isFromGetDetail,
        ensxtx_DS_SalesDocAppSettings appSettings,
        ensxtx_UTIL_Document_Detail.convertToObjectTrigger convertTrigger);
}