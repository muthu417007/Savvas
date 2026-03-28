global with sharing class ensxtx_CTRL_SAP_Sales_Doc_Actions 
{
    private static final ensxsdk.Logger logger = new ensxsdk.Logger(ensxtx_CTRL_SAP_Sales_Doc_Actions.class);

    @AuraEnabled(cacheable=true)
    public static ensxtx_UTIL_Aura.Response getDetail(String docNum) 
    {
        logger.enterAura('getDetail', new Map<String, Object> {
            'docNum' => docNum
        });

        ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument responseData = null;
        try
        {
            ensxtx_SBO_EnosixSalesDocument_Detail sbo = new ensxtx_SBO_EnosixSalesDocument_Detail();
            responseData = sbo.getDetail(docNum);
        }
        catch (Exception ex)
        {
            ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
        }
        finally
        {
            logger.exit();
        }

        return ensxtx_UTIL_Aura.createResponse(responseData);
    }

    @AuraEnabled
    public static ensxtx_UTIL_Aura.Response getButtons (
        Id SFRecordId, 
        String SAPDocNum, 
        String SAPDocType,
        Boolean allowBackToLinkedObject,
        Boolean allowBackToAccount,
        Boolean allowBackToOpportunity,
        Boolean allowClone,
        Boolean allowUpdate,
        Boolean allowAddAttachment
    ) 
    {
        logger.enterAura('getButtons', new Map<String, Object> {
            'SFRecordId' => SFRecordId,
            'SAPDocNum' => SAPDocNum,
            'SAPDocType' => SAPDocType,
            'allowBackToLinkedObject' => allowBackToLinkedObject,
            'allowBackToAccount' => allowBackToAccount,
            'allowBackToOpportunity' => allowBackToOpportunity,
            'allowClone' => allowClone,
            'allowUpdate' => allowUpdate,
            'allowAddAttachment' => allowAddAttachment
        });

        SObject sfsObject = ensxtx_UTIL_SFSObjectDoc.initObjectsForSAP(SFRecordId, SAPDocNum, SAPDocType);
        List<ButtonClass> buttonList = new List<ButtonClass>();
        Map <String, Object> pageReference = new Map<String, Object>();
        Map <String, Object> attributes = new Map<String, Object>();
        String acctId;
        String sObjectName = null;

        if (sfsObject != null) {
            createReferenceButton(sfsObject, buttonList, pageReference, attributes,
                allowBackToLinkedObject, allowBackToAccount, allowBackToOpportunity);
        }

        if (sfSobject == null) {
            sfSobject = ensxtx_UTIL_SFAccount.getAccountById(SFRecordId);
            if (sfSobject != null) acctId = sfSobject.Id;
        }

        Schema.SObjectType sobjectType = sfsObject.Id.getSObjectType();
        sObjectName = sobjectType.getDescribe().getName();

        attributes.clear();

        if (allowClone != null && allowClone)
        {
            buttonList.add(new ButtonClass('Clone', 'Clone ' + SAPDocType, SAPDocType, null));
        }

        if (allowUpdate != null && allowUpdate)
        {
            buttonList.add(new ButtonClass('Update', 'Update ' + SAPDocType, SAPDocType, null));
        }

        if ( allowAddAttachment != null && allowAddAttachment)
        {
            buttonList.add(new ButtonClass('Add Attachment', 'Add Attachment', 'Add Attachment', null));
        }

        return ensxtx_UTIL_Aura.createResponse(buttonList);
    }

    @TestVisible
    private static void createReferenceButton(
        SObject sfsObject,
        List<ButtonClass> buttonList,
        Map <String, Object> pageReference,
        Map <String, Object> attributes,
        Boolean allowBackToLinkedObject,
        Boolean allowBackToAccount,
        Boolean allowBackToOpportunity)
    {
        String sObjectName = null;
        pageReference.put('type', 'standard__recordPage');
        attributes.put('actionName', 'view');

        if (String.isNotEmpty(sfsObject.Id) && allowBackToLinkedObject != null && allowBackToLinkedObject)
        {
            Schema.SObjectType sobjectType = sfsObject.Id.getSObjectType();
            sObjectName = sobjectType.getDescribe().getName();
            String recordName = ensxtx_UTIL_SFSObjectDoc.getName(sfsObject);
            attributes.put('recordId', sfsObject.Id);
            attributes.put('objectApiName', sObjectName);
            pageReference.put('attributes', attributes);
            buttonList.add(new ButtonClass('LinkedRecord', 'Back to ' + recordName, null, JSON.serialize(pageReference)));
        }

        Id acctId = ensxtx_UTIL_SFSObjectDoc.getAccountId(sfsObject);
        if(Test.isRunningTest() && acctId == null) acctId = ensxtx_TSTU_SFTestObject.getFakeId(Account.SObjectType);
        if (acctId != null && sObjectName != 'Account' && allowBackToAccount != null && allowBackToAccount)
        {
            attributes.put('recordId', acctId);
            attributes.put('objectApiName', 'Account');
            pageReference.put('attributes', attributes);
            buttonList.add(new ButtonClass('Account', 'Back to Account', null, JSON.serialize(pageReference)));
        }

        Id oppId = ensxtx_UTIL_SFSObjectDoc.getOpportunityId(sfsObject);
        if(Test.isRunningTest() && oppId == null) oppId = ensxtx_TSTU_SFTestObject.getFakeId(Opportunity.SObjectType);
        if (oppId != null && sObjectName != 'Opportunity' && allowBackToOpportunity != null && allowBackToOpportunity)
        {
            attributes.put('recordId', oppId);
            attributes.put('objectApiName', 'Opportunity');
            pageReference.put('attributes', attributes);
            buttonList.add(new ButtonClass('Opportunity', 'Back to Opportunity', null, JSON.serialize(pageReference)));
        }
    }

    global with sharing class ButtonClass 
    {
        @AuraEnabled global String Value { get; private set; }
        @AuraEnabled global String Label { get; private set; }
        @AuraEnabled global String SAPDocType { get; private set; }
        @AuraEnabled global String PageReference { get; private set; }

        global ButtonClass(
            String Value,
            String Label,
            String SAPDocType,
            String PageReference)
        {
            this.Value = Value;
            this.Label = Label;
            this.SAPDocType = SAPDocType;
            this.PageReference = PageReference;
        }
    }
}