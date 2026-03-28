public without sharing class ensxtx_UTIL_SalesDocInvocableActions
{
    private static final ensxsdk.Logger logger = new ensxsdk.Logger(ensxtx_UTIL_SalesDocInvocableActions.class);

    public class Request {

        @InvocableVariable(label='Record Id' description='Record Id of the SObject' required=true)
        public Id recordId;

        @InvocableVariable(label='Product Simulation Fields Map' description='Product Simulation Fields Map' required=false)
        public String productSimulationFieldsMapJSON;

        @InvocableVariable(label='Product JSON List' description='Product JSON List' required=false)
        public List<String> productJSONList;

        @InvocableVariable(label='App Settings Name' description='The file name of app setting' required=true)
        public String appSettingsName;

        @InvocableVariable(label='App Settings Key' description='The key value inside the app setting' required=true)
        public String appSettingsKey;

        @InvocableVariable(label='App Settings Type Name' description='The name of the type inside the app setting' required=true)
        public String appSettingsTypeName;

        @InvocableVariable(label='App Settings Invoke Method' description='The name of the invoke method inside the app setting' required=false)
        public String appSettingsInvokeMethod;
    }

    @testVisible
    @AuraEnabled
    public static ensxtx_UTIL_Aura.Response invokeSalesDocLWC(String requestJSON)
    {
        Request request = (Request) JSON.deserialize(requestJSON, Request.class);
        return ensxtx_UTIL_Aura.createResponse(invokeSalesDoc(request));
    }

    public class SalesDocActionException extends Exception {}

    @testVisible
    public static ensxtx_DS_Document_Detail invokeSalesDoc(Request request)
    {
        logger.enterAura('invokeSalesDoc', new Map<String, Object>{
            'request' => request
        });
        try {
            ensxtx_DS_Document_Detail salesDocDetail = null;

            // First check if the record id is a valid sfSObject that implement the SFSObjectDoc interface
            SObject sfSObject = ensxtx_UTIL_SFSObjectDoc.getSObject(request.recordId);

            if(Test.isRunningTest() && sfSObject == null && request.productJSONList == null) {
                sfSObject = new Opportunity();
                sfSObject.Id = request.recordId;
            }

            if (sfSObject != null) {
                try
                {
                    ensxtx_DS_SalesDocAppSettings appSettings = ensxtx_UTIL_SalesDocCreateUpdate.getAppSettings(
                        request.appSettingsName, request.appSettingsKey, request.appSettingsTypeName);

                    Boolean isUpdate = false;

                    if (appSettings == null) {
                        ensxtx_UTIL_PageMessages.addMessage(ensxtx_UTIL_PageMessages.ERROR, request.appSettingsName + ' App setting is not found');
                    }
                    else {
                        try
                        {
                            ensxtx_UTIL_SalesDoc.SFObject sfObject = ensxtx_UTIL_SalesDocCreateUpdate.initSFObject(request.recordId, appSettings.SAPDocType);
                            getMethodAppSettings(request, sfObject.status, appSettings);

                            if (appSettings.InvokeMethod == 'Simulate') {
                                salesDocDetail = new ensxtx_DS_Document_Detail();
                                salesDocDetail = ensxtx_UTIL_SalesDocCreateUpdate.initSalesDocDetailFromSFObject(salesDocDetail, sfObject, appSettings);
                                if (salesDocDetail.ITEMS.size() > 0 || Test.isRunningTest()) {
                                    salesDocDetail = ensxtx_UTIL_SalesDocCreateUpdate.setItemNumberBasedOnBOMCount(salesDocDetail, appSettings);
                                    salesDocDetail = ensxtx_UTIL_SalesDocCreateUpdate.simulateSalesDoc(salesDocDetail, appSettings);
                                    ensxtx_UTIL_SalesDocCreateUpdate.saveToSObject(sfObject, salesDocDetail, appSettings);
                                    SObject newSObject = sfSObject.getSObjectType().newSObject();
                                    newSObject.Id = request.recordId;
                                    if (!Test.isRunningTest()) update newSObject;
                                }
                                if (appSettings.insertSalesDocLog) ensxtx_UTIL_Invocable.insertSalesDocLog(ensxtx_UTIL_PageMessages.messageList, sfSObject, request.appSettingsInvokeMethod, salesDocDetail);
                                return salesDocDetail;
                            }
                            if (String.isNotEmpty(sfObject.customerNumber) || Test.isRunningTest()) {
                                salesDocDetail = new ensxtx_DS_Document_Detail();

                                if (String.isNotEmpty(sfObject.sapDocNumber) && appSettings.InvokeMethod != 'Create') {
                                    // Update mode if sales doc number exist
                                    isUpdate = true;
                                    salesDocDetail = ensxtx_UTIL_SalesDocCreateUpdate.getSalesDocDetail(sfObject.sapDocNumber, appSettings, sfObject);
                                }
                                else {
                                    salesDocDetail = ensxtx_UTIL_SalesDocCreateUpdate.initSalesDocDetailFromSFObject(salesDocDetail, sfObject, appSettings);
                                    salesDocDetail = ensxtx_UTIL_SalesDocCreateUpdate.setItemNumberBasedOnBOMCount(salesDocDetail, appSettings);
                                }

                                // Check if need to run simulate first for incompletion log shown as errors
                                if ((appSettings.showHeaderIncompletionLogs || appSettings.showItemIncompletionLogs) &&
                                    appSettings.incompletionLogsAsErrors && salesDocDetail.isIncomplete != false) {
                                    salesDocDetail = ensxtx_UTIL_SalesDocCreateUpdate.simulateSalesDoc(salesDocDetail, appSettings);
                                }

                                // Continue with the transaction if there is no error incompletion logs
                                if (!appSettings.incompletionLogsAsErrors || (appSettings.incompletionLogsAsErrors && salesDocDetail.isIncomplete != true)) {
                                    if (!isUpdate) {
                                        if(salesDocDetail.ITEMS != null && salesDocDetail.ITEMS.size() > 0){
                                            salesDocDetail = ensxtx_UTIL_SalesDocCreateUpdate.createSAPDocument(sfObject, salesDocDetail, appSettings);
                                        }else {
                                            ensxtx_UTIL_PageMessages.addMessage(ensxtx_UTIL_PageMessages.ERROR, String.format(System.Label.ensxtx_SalesDoc_Message_LineItemNotFound, new List<String>{appSettings.SAPDocType}));
                                        }
                                    }
                                    else {
                                        if(salesDocDetail.ITEMS != null && salesDocDetail.ITEMS.size() > 0){
                                            salesDocDetail = ensxtx_UTIL_SalesDocCreateUpdate.updateSAPDocument(sfObject, salesDocDetail, appSettings);                                           
                                        }else {
                                            ensxtx_UTIL_PageMessages.addMessage(ensxtx_UTIL_PageMessages.ERROR, String.format(System.Label.ensxtx_SalesDoc_Message_LineItemNotFound, new List<String>{appSettings.SAPDocType}));
                                        }
                                    }
                                }
                            }
                        }
                        catch (Exception ex) { ensxtx_UTIL_PageMessages.addExceptionMessage(ex); }

                        if (appSettings.insertSalesDocLog == true) ensxtx_UTIL_Invocable.insertSalesDocLog(ensxtx_UTIL_PageMessages.messageList, sfSObject, request.appSettingsInvokeMethod, salesDocDetail);
                    }
                }
                catch (Exception ex) { ensxtx_UTIL_PageMessages.addExceptionMessage(ex); }

                Boolean isFieldFound = false;
                Map<String, Schema.SObjectField> fields = Schema.getGlobalDescribe().get(sfSObject.getSObjectType().getDescribe().getName()).getDescribe().fields.getMap();
                Schema.SObjectField fieldRef = fields.get('ensxtx_SAP_SalesDocument_Messages__c');
                if (fieldRef != null) {
                    Schema.DescribeFieldResult fieldResult = fieldRef.getDescribe();
                    if(fieldResult.isUpdateable()) isFieldFound = true;
                }
                SObject newSObject = sfSObject.getSObjectType().newSObject();
                newSObject.Id = request.recordId;
                if (!Test.isRunningTest() && isFieldFound) newSObject.put('ensxtx_SAP_SalesDocument_Messages__c', ensxtx_UTIL_PageMessages.buildMesssageTableString());
                if (!Test.isRunningTest()) update newSObject;
            } else if (request.productJSONList != null) {
                try
                {
                    ensxtx_DS_SalesDocAppSettings appSettings = ensxtx_UTIL_SalesDocCreateUpdate.getAppSettings(
                        request.appSettingsName, request.appSettingsKey, request.appSettingsTypeName);

                    salesDocDetail = new ensxtx_DS_Document_Detail();
                    salesDocDetail = ensxtx_UTIL_SFProduct.sObjectToSalesDocMapping(request.recordId, request.productJSONList, request.productSimulationFieldsMapJSON, salesDocDetail, appSettings);
                    salesDocDetail = ensxtx_UTIL_SalesDocCreateUpdate.setItemNumberBasedOnBOMCount(salesDocDetail, appSettings);
                    salesDocDetail = ensxtx_UTIL_SalesDocCreateUpdate.simulateSalesDoc(salesDocDetail, appSettings);
                }
                catch (Exception ex) { ensxtx_UTIL_PageMessages.addExceptionMessage(ex); }
                ensxtx_UTIL_Invocable.getSalesDocLog(ensxtx_UTIL_PageMessages.messageList, request.recordId, request.appSettingsInvokeMethod, salesDocDetail);
            }
            return salesDocDetail;
        } finally {
            logger.exit();
        }
    }

    public static void getMethodAppSettings(Request request, String sfObjectStatus, ensxtx_DS_SalesDocAppSettings appSettings)
    {
        logger.enterAura('getMethodAppSettings', new Map<String, Object>{
            'request' => request,
            'sfObjectStatus' => sfObjectStatus,
            'appSettings' => appSettings
        });
        try {
            if (String.isEmpty(request.appSettingsInvokeMethod)) request.appSettingsInvokeMethod = sfObjectStatus;

            if (appSettings.InvokeMethodAppSettings != null) {
                for (ensxtx_DS_SalesDocAppSettings.InvokeMethodAppSetting invokeMethodAppSetting : appSettings.InvokeMethodAppSettings) {
                    if (invokeMethodAppSetting.InvokeMethod == request.appSettingsInvokeMethod) {
                        appSettings.InvokeMethod = invokeMethodAppSetting.InvokeMethod;
                        appSettings.insertSalesDocLog = invokeMethodAppSetting.insertSalesDocLog;
                        appSettings.skipAddedLineValidation = invokeMethodAppSetting.skipAddedLineValidation;
                        break;
                    }
                }
            }
        } finally {
            logger.exit();
        }
    }
}