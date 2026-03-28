public with sharing class ensxtx_UTIL_Invocable
{
    public static void insertSalesDocLog(List<ensxtx_UTIL_PageMessages.Message> messageList, SObject sfSObject, String appSettingsInvokeMethod, ensxtx_DS_Document_Detail salesDocDetail)
    {
        if (messageList.size() > 0) {
            String sObjectType = sfSObject.getSObjectType().getDescribe().getName();
            String recordIdField = objectTypeIdFieldName.get(sObjectType);
            Id recordId = sfSObject.Id;

            Decimal instanceNumber = 1;
            if (String.isNotEmpty(recordIdField)) {
                String query = 'SELECT Id, Name, ensxtx_InstanceNumber__c FROM ensxtx_SAP_Transact_Log__c ' +
                    'WHERE ' + recordIdField + ' = :recordId ORDER BY CreatedDate DESC LIMIT 1';
                List<ensxtx_SAP_Transact_Log__c> previousLog = Database.query(query);

                if (previousLog.size() > 0) {
                    if (previousLog[0].ensxtx_InstanceNumber__c != null) {
                        instanceNumber = previousLog[0].ensxtx_InstanceNumber__c + 1;
                    }
                }
            }

            List<ensxtx_SAP_Transact_Log__c> transactLogs = loadTransactLogs(messageList, appSettingsInvokeMethod, salesDocDetail, sObjectType, recordId, instanceNumber);

            insert transactLogs;
        }
    }

    public static void getSalesDocLog(List<ensxtx_UTIL_PageMessages.Message> messageList, Id recordId, String appSettingsInvokeMethod, ensxtx_DS_Document_Detail salesDocDetail)
    {
        if (messageList.size() > 0) {
            String sObjectType = recordId.getSObjectType().getDescribe().getName();
            Decimal instanceNumber = 1;

            loadTransactLogs(messageList, appSettingsInvokeMethod, salesDocDetail, sObjectType, recordId, instanceNumber);
        }
    }

    private static List<ensxtx_SAP_Transact_Log__c> loadTransactLogs(List<ensxtx_UTIL_PageMessages.Message> messageList, String appSettingsInvokeMethod, ensxtx_DS_Document_Detail salesDocDetail, String sObjectType, Id recordId, Decimal instanceNumber) {
        
        List<ensxtx_SAP_Transact_Log__c> transactLogs = new List<ensxtx_SAP_Transact_Log__c>();

        for (ensxtx_UTIL_PageMessages.Message message : messageList)
        {
            ensxtx_SAP_Transact_Log__c newLog = new ensxtx_SAP_Transact_Log__c();
            newLog.ensxtx_MessageType__c = message.messageType;
            newLog.ensxtx_Message__c = message.message;
            newLog.ensxtx_SObjectType__c = sObjectType;
            newLog.ensxtx_InvokeType__c = appSettingsInvokeMethod;
            newLog.ensxtx_InstanceNumber__c = instanceNumber;
            newLog.ensxtx_ExtendedText1__c = message.extendedText1;
            newLog.ensxtx_ExtendedText2__c = message.extendedText2;
            newLog.ensxtx_ExtendedText3__c = message.extendedText3;
            newLog.ensxtx_ExtendedText4__c = message.extendedText4;
            newLog.ensxtx_SAP_Error_Code__c = message.MsgNumber;
            String referenceField = objectTypeIdFieldName.get(sObjectType);
            if (String.isNotEmpty(referenceField)) newLog.put(referenceField, recordId);
            transactLogs.add(newLog);
        }

        if (salesDocDetail != null) salesDocDetail.TransactLogs.addAll(transactLogs);
        return transactLogs;
    }

    public static void saveSalesDocMessageTable(Id recordId, SObject sfSObject)
    {
        SObject newSObject = sfSObject.getSObjectType().newSObject();
        newSObject.Id = recordId;
        if (!Test.isRunningTest()) newSObject.put('ensxtx_SAP_SalesDocument_Messages__c', ensxtx_UTIL_PageMessages.buildMesssageTableString());
        if (!Test.isRunningTest()) update newSObject;
    }

    @testVisible
    private static final Map<String, String> objectTypeIdFieldName = new Map<String, String>{
        'SBQQ__Quote__c' => 'ensxtx_CPQQuote__c',
        'WebCart' => 'ensxtx_WebCart__c',
        'Order' => 'ensxtx_Order__c',
        'ContactPointAddress' => 'ensxtx_ContactPointAddress__c',
        'Account' => 'ensxtx_Account__c'
    };
}