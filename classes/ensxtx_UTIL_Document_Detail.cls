public class ensxtx_UTIL_Document_Detail
{
    public enum convertToObjectTrigger {getSalesDocDetail, getReferenceDocument, simulateSalesDoc, createSAPDocument, updateSAPDocument}

    // removeAllConditions
    //
    // Removing all the conditions that is in the SBO
    // Primarily use for update transaction
    public static ensxsdk.EnosixFramework.DetailObject removeAllConditions(
        ensxsdk.EnosixFramework.DetailObject sboObject, String sboDetailType)
    {
        Object detailInstance = getDetailInstace(sboDetailType);
        ensxsdk.EnosixFramework.DetailObject detailObject;

        if (detailInstance instanceof ensxtx_I_Document_Detail) {
            detailObject = ((ensxtx_I_Document_Detail) detailInstance).removeAllConditions(sboObject);
        }
        return detailObject;
    }

    // updateSimulateBeforeUpdate()
    //
    // Update the Text fields, (Header and Item)
    // Primarily use for update transaction
    public static ensxsdk.EnosixFramework.DetailObject updateSimulateBeforeUpdate(
        ensxsdk.EnosixFramework.DetailObject sboObject, ensxtx_DS_Document_Detail docObj, ensxtx_DS_SalesDocAppSettings appSettings)
    {
        Object detailInstance = getDetailInstace(appSettings.SBODetailType);
        ensxsdk.EnosixFramework.DetailObject detailObject;

        if (detailInstance instanceof ensxtx_I_Document_Detail) {
            detailObject = ((ensxtx_I_Document_Detail) detailInstance).updateSimulateBeforeUpdate(sboObject, docObj, appSettings);
        }
        return detailObject;
    }

    // buildSBOForReference()
    //
    // Returns the SBO detail object
    // Use before calling the the command to clone document
    public static ensxsdk.EnosixFramework.DetailObject buildSBOForReference(
        String salesDocNumber, String salesDocType, String sboDetailType)
    {
        Object detailInstance = getDetailInstace(sboDetailType);
        ensxsdk.EnosixFramework.DetailObject detailObject;

        if (detailInstance instanceof ensxtx_I_Document_Detail) {
            detailObject = ((ensxtx_I_Document_Detail) detailInstance).buildSBOForReference(salesDocNumber, salesDocType);
        }
        return detailObject;
    }

    // convertToSBO
    //
    // Convert DS Object to SBO Detail object
    // Use to build SBO Object for simulation and creation
    public static ensxsdk.EnosixFramework.DetailObject convertToSBO(ensxsdk.EnosixFramework.DetailObject sboObject,
        ensxtx_DS_Document_Detail docObj, Boolean isUpdate, ensxtx_DS_SalesDocAppSettings appSettings)
    {
        Object detailInstance = getDetailInstace(appSettings.SBODetailType);
        ensxsdk.EnosixFramework.DetailObject detailObject;

        if (detailInstance instanceof ensxtx_I_Document_Detail) {
            detailObject = ((ensxtx_I_Document_Detail) detailInstance).convertToSBO(sboObject, docObj, isUpdate, appSettings);
        }
        return detailObject;
    }

    // convertToObject()
    //
    // Convert SBO Detail object to DS Object
    public static void convertToObject(ensxsdk.EnosixFramework.DetailObject sboObject,
        ensxtx_DS_Document_Detail docObj, Boolean isFromGetDetail, ensxtx_DS_SalesDocAppSettings appSettings, convertToObjectTrigger convertTrigger)
    {
        Object detailInstance = getDetailInstace(appSettings.SBODetailType);

        if (detailInstance instanceof ensxtx_I_Document_Detail) {
            ((ensxtx_I_Document_Detail) detailInstance).convertToObject(sboObject, docObj, isFromGetDetail, appSettings, convertTrigger);
        }
    }

    // getSimulateCommand()
    //
    // Returns the simulate command of the Detail SBO
    public static String getSimulateCommand(String sboDetailType)
    {
        Object detailInstance = getDetailInstace(sboDetailType);
        String simulateCommand = '';

        if (detailInstance instanceof ensxtx_I_Document_Detail) {
            simulateCommand = ((ensxtx_I_Document_Detail) detailInstance).getSimulateCommand();
        }
        return simulateCommand;
    }

    // getReferenceDocumentCommand()
    //
    // Returns the reference document command of the detail SBO
    // The command is use for cloning a document
    public static String getReferenceDocumentCommand(String sboDetailType)
    {
        Object detailInstance = getDetailInstace(sboDetailType);
        String referenceDocumentCommand = '';

        if (detailInstance instanceof ensxtx_I_Document_Detail) {
            referenceDocumentCommand = ((ensxtx_I_Document_Detail) detailInstance).getReferenceDocumentCommand();
        }
        return referenceDocumentCommand;
    }
    
    // getMaterialBomCountCommand()
    //
    // Returns the reference document command of the detail SBO
    // The command is use for cloning a document
    public static String getMaterialBomCountCommand(String sboDetailType)
    {
        Object detailInstance = getDetailInstace(sboDetailType);
        String referenceDocumentCommand = '';

        if (detailInstance instanceof ensxtx_I_Document_Detail) {
            referenceDocumentCommand = ((ensxtx_I_Document_Detail) detailInstance).getMaterialBomCountCommand();
        }
        return referenceDocumentCommand;
    }

    // getDetailInstace()
    //
    // Returns the instance of the detail adapter
    private static Object getDetailInstace(String sboDetailType)
    {
        String className = 'ensxtx_UTIL_' + sboDetailType + '_Detail';
        System.Type detailType = Type.forName(className);
        return detailType.newInstance();
    }

    public static ensxsdk.EnosixFramework.DetailSBO initializeSBODetail(String sboDetailType)
    {
        String className = 'ensxtx_SBO_Enosix' + sboDetailType + '_Detail';
        System.Type detailType = Type.forName(className);
        return (ensxsdk.EnosixFramework.DetailSBO) detailType.newInstance();
    }
}