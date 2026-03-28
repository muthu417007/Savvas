public class ensxtx_UTIL_SalesDocCreateUpdate
{
    private static final ensxsdk.Logger logger = new ensxsdk.Logger(ensxtx_UTIL_SalesDocCreateUpdate.class);

    public static ensxtx_DS_SalesDocAppSettings getAppSettings(String appSettingsName, String appSettingsKey, String appSettingsTypeName)
    {
        logger.enterAura('getAppSettings', new Map<String, Object>{
            'appSettingsName' => appSettingsName,
            'appSettingsKey' => appSettingsKey,
            'appSettingsTypeName' => appSettingsTypeName
        });

        ensxtx_DS_SalesDocAppSettings appSettings = null;

        try {
            Map<String, ensxtx_DS_SalesDocAppSettings> typeNameAppSettings = (Map<String, ensxtx_DS_SalesDocAppSettings>)ensxtx_UTIL_AppSettings.getMap(
                appSettingsName, appSettingsKey, String.class, ensxtx_DS_SalesDocAppSettings.class);

            appSettings = typeNameAppSettings.get(appSettingsTypeName);
        }
        catch (Exception ex)
        {
            ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
        }
        finally
        {
            logger.exit();
        }

        return appSettings;
    }

    public static ensxtx_UTIL_SalesDoc.SFObject initSFObject(Id recordId, String sapDocType)
    {
        logger.enterAura('initSFObject', new Map<String, Object>{
            'recordId' => recordId,
            'sapDocType' => sapDocType
        });
        try {
            ensxtx_UTIL_SalesDoc.SFObject result = ensxtx_UTIL_SalesDoc.getSFObjectInfo(recordId, sapDocType);
            return result;
        } finally {
            logger.exit();
        }
    }

    public static ensxtx_SBO_EnosixCustomer_Detail.EnosixCustomer getCustomerDetail(String customerNumber)
    {
        logger.enterAura('getCustomerDetail', new Map<String, Object>{
            'customerNumber' => customerNumber
        });

        ensxtx_SBO_EnosixCustomer_Detail.EnosixCustomer customerDetail = new ensxtx_SBO_EnosixCustomer_Detail.EnosixCustomer();
        ensxtx_SBO_EnosixCustomer_Detail sbo = new ensxtx_SBO_EnosixCustomer_Detail();

        try
        {
            customerDetail = sbo.getDetail(customerNumber);
        }
        catch (Exception ex)
        {
            ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
            return null;
        }
        finally
        {
            logger.exit();
        }

        return customerDetail;
    }

    public static ensxtx_UTIL_SalesDoc.compareSAPSimulateVsSObject compareSAPSimulateVsSObject(ensxtx_DS_Document_Detail salesDocDetail, ensxtx_DS_Document_Detail salesDocDetailFromSF, 
        ensxtx_DS_SalesDocAppSettings appSettings)
    {
        logger.enterAura('compareSAPSimulateVsSObject', new Map<String, Object>{
            'salesDocDetail' => salesDocDetail,
            'salesDocDetailFromSF' => salesDocDetailFromSF,
            'appSettings' => appSettings
        });
        ensxtx_UTIL_SalesDoc.compareSAPSimulateVsSObject result = new ensxtx_UTIL_SalesDoc.compareSAPSimulateVsSObject();
        try {
            result = ensxtx_UTIL_SalesDoc.compareSAPSimulateVsSObject(salesDocDetail, salesDocDetailFromSF, appSettings);
        }
        catch (Exception ex)
        {
            ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
        } 
        finally 
        {
            logger.exit();
        }
        return result;
    }

    public static ensxtx_DS_Document_Detail mapChildBomFields(ensxtx_DS_Document_Detail salesDocDetail, ensxtx_DS_Document_Detail salesDocDetailFromSF, 
        ensxtx_DS_SalesDocAppSettings appSettings)
    {
        logger.enterAura('mapChildBomFields', new Map<String, Object>{
            'salesDocDetail' => salesDocDetail,
            'salesDocDetailFromSF' => salesDocDetailFromSF,
            'appSettings' => appSettings
        });
        ensxtx_DS_Document_Detail result = null;
        try {
            result = ensxtx_UTIL_SalesDoc.mapChildBomFields(salesDocDetail, salesDocDetailFromSF, appSettings);
        }
        catch (Exception ex)
        {
            ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
        } 
        finally 
        {
            logger.exit();
        }
        return result;
    }

    public static ensxtx_DS_Document_Detail initSalesDocDetailFromSFObject(ensxtx_DS_Document_Detail salesDocDetail,
        ensxtx_UTIL_SalesDoc.SFObject sfObject, ensxtx_DS_SalesDocAppSettings appSettings)
    {
        logger.enterAura('initSalesDocDetailFromSFObject', new Map<String, Object>{
            'salesDocDetail' => salesDocDetail,
            'sfObject' => sfObject,
            'appSettings' => appSettings
        });

        try
        {
            ensxtx_DS_Document_Detail newSalesDocDetail = ensxtx_UTIL_SalesDoc.mapSalesDocDetailFromSFObject(salesDocDetail, sfObject, appSettings);
            if (newSalesDocDetail != null) salesDocDetail = newSalesDocDetail;
        }
        catch (Exception ex)
        {
            salesDocDetail.IsSuccess = false;
            ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
            return null;
        }
        finally
        {
            logger.exit();
        }

        return salesDocDetail;
    }

    public static ensxtx_DS_Document_Detail getSalesDocDetail(String salesDocNumber, ensxtx_DS_SalesDocAppSettings appSettings,
        ensxtx_UTIL_SalesDoc.SFObject sfObject)
    {
        logger.enterAura('getSalesDocDetail', new Map<String, Object>{
            'salesDocNumber' => salesDocNumber,
            'appSettings' => appSettings,
            'sfObject' => sfObject
        });

        ensxsdk.EnosixFramework.DetailSBO sbo = initializeSBODetail(appSettings.SBODetailType);
        ensxtx_DS_Document_Detail salesDocDetail = new ensxtx_DS_Document_Detail();

        try
        {
            ensxsdk.EnosixFramework.DetailObject result = sbo.executeGetDetail(salesDocNumber);
            ensxtx_UTIL_Document_Detail.convertToObject(result, salesDocDetail, true, appSettings, ensxtx_UTIL_Document_Detail.convertToObjectTrigger.getSalesDocDetail);

            SObject sfSObject = sfObject.sfMainObject;
            if (sfSObject != null && sfObject.initFromSObject == true)
            {
                if (sfObject.sfLineItems != null) {
                    Integer solTot = sfObject.sfLineItems.size();
                    Integer itemTot = salesDocDetail.ITEMS.size();
                    for (Integer solCnt = 0 ; solCnt < solTot ; solCnt++)
                    {
                        SObject sfsObjectLine = sfObject.sfLineItems[solCnt];
                        String itemNumber = ensxtx_UTIL_SFSObjectDoc.getItemNumber(sfSObject, sfsObjectLine);
                        boolean isFound = false;
                        string materialNumber = ensxtx_UTIL_SFSObjectDoc.getMaterial(sfSObject, sfsObjectLine);
                        for (Integer itemCnt = 0 ; itemCnt < itemTot ; itemCnt++)
                        {
                            ensxtx_DS_Document_Detail.ITEMS item = salesDocDetail.ITEMS[itemCnt];
                            if (itemNumber != null && itemNumber.replaceFirst('^0+(?!$)', '').leftPad(6, '0') == item.ItemNumber.replaceFirst('^0+(?!$)', '').leftPad(6, '0') && materialNumber == item.MaterialEntered) 
                            {
                                item.SFId = sfsObjectLine.Id;
                                break;
                            }
                        }
                    }
                }

                if (appSettings.mapUpdateFromSObject == true) {
                    salesDocDetail = ensxtx_UTIL_SalesDoc.mapSalesDocDetailFromSFObject(salesDocDetail, sfObject, appSettings);
                }
            }

            ensxtx_UTIL_PageMessages.addFrameworkMessages(result.getMessages());
        }
        catch (Exception ex)
        {
            salesDocDetail.IsSuccess = false;
            ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
            return null;
        }
        finally
        {
            logger.exit();
        }

        return salesDocDetail;
    }

    public static ensxtx_DS_Document_Detail getReferenceDocument(String salesDocNumber, ensxtx_DS_SalesDocAppSettings appSettings)
    {
        logger.enterAura('getReferenceDocument', new Map<String, Object>{
            'salesDocNumber' => salesDocNumber,
            'appSettings' => appSettings
        });

        ensxsdk.EnosixFramework.DetailSBO sbo = initializeSBODetail(appSettings.SBODetailType);
        ensxtx_DS_Document_Detail salesDocDetail = new ensxtx_DS_Document_Detail();

        try
        {
            ensxsdk.EnosixFramework.DetailObject result = ensxtx_UTIL_Document_Detail.buildSBOForReference(
                salesDocNumber, appSettings.DefaultDocType, appSettings.SBODetailType);

            String referenceCommand = ensxtx_UTIL_Document_Detail.getReferenceDocumentCommand(appSettings.SBODetailType);

            result = sbo.executeCommand(referenceCommand, result);

            if (result.isSuccess()) {
                ensxtx_UTIL_Document_Detail.convertToObject(result, salesDocDetail, true, appSettings, ensxtx_UTIL_Document_Detail.convertToObjectTrigger.getReferenceDocument);
            }

            ensxtx_UTIL_PageMessages.addFrameworkMessages(result.getMessages());
        }
        catch (Exception ex)
        {
            salesDocDetail.IsSuccess = false;
            ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
            return null;
        }
        finally
        {
            logger.exit();
        }

        return salesDocDetail;
    }

    @AuraEnabled
    public static ensxtx_DS_Document_Detail getBomItemsCount(ensxtx_DS_Document_Detail salesDocDetail, ensxtx_DS_SalesDocAppSettings appSettings)
    {
        // Log size can be too big
        logger.enterAura('getBomItemsCount', new Map<String, Object>{
        //     'salesDocDetail' => salesDocDetail,
        //     'appSettings' => appSettings
        });

        ensxsdk.EnosixFramework.DetailSBO sbo = initializeSBODetail(appSettings.SBODetailType);

        try
        {
            if (appSettings.enableBoMCountCommand) {
                Integer startCpu = Limits.getCpuTime();
                Integer startHeap = Limits.getHeapSize();
                System.debug('Start getCpuTime(): '+ startCpu);
                System.debug('Start getHeapSize(): '+ startHeap);

                if (salesDocDetail == null) salesDocDetail = new ensxtx_DS_Document_Detail();
                ensxsdk.EnosixFramework.DetailObject result = ensxtx_UTIL_Document_Detail.convertToSBO(null, salesDocDetail, false, appSettings);
                String command = ensxtx_UTIL_Document_Detail.getMaterialBomCountCommand(appSettings.SBODetailType);

                DateTime startTimer = System.now();
                System.debug('Start Timer: '+ startTimer);

                result.setBoolean(true,'useTextSerialize');
                result = sbo.executeCommand(command, result);

                DateTime endTimer = System.now();
                System.debug('End Timer: '+ endTimer);
                System.debug('MilliSecond Bom Count Command: ' + (endTimer.getTime() - startTimer.getTime()));

                if (result.isSuccess()) {
                    ensxtx_UTIL_Document_Detail.convertToObject(result, salesDocDetail, false, appSettings, ensxtx_UTIL_Document_Detail.convertToObjectTrigger.simulateSalesDoc);
                }

                ensxtx_UTIL_PageMessages.addFrameworkMessages(result.getMessages());

                Integer endCpu = Limits.getCpuTime();
                Integer endHeap = Limits.getHeapSize();
                System.debug('End getHeapSize(): '+ endHeap);
                System.debug('End getCpuTime(): '+ endCpu);
                System.debug('Heap diff: ' + (endHeap - startHeap));
                System.debug('CPU diff: ' + (endCpu - startCpu));
            }
        }
        catch (Exception ex)
        {
            salesDocDetail.IsSuccess = false;
            ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
        }
        finally
        {
            logger.exit();
        }

        return salesDocDetail;
    }
    
    public static ensxtx_DS_Document_Detail setItemNumberBasedOnBOMCount(ensxtx_DS_Document_Detail salesDocDetail, ensxtx_DS_SalesDocAppSettings appSettings)
    {
        try
        {
            if (appSettings.enableBoMCountCommand) {
                salesDocDetail = ensxtx_UTIL_SalesDocCreateUpdate.getBomItemsCount(salesDocDetail, appSettings);
                Integer itemNumberIncrement = appSettings.itemNumberIncrement;
                Integer bomItemNumberIncrement = appSettings.bomItemNumberIncrement;
                Integer nextItemNumber = itemNumberIncrement;
                for (ensxtx_DS_Document_Detail.ITEMS item : salesDocDetail.ITEMS) {
                    item.ItemNumber = String.valueOf(nextItemNumber);
        
                    Integer bomCount = String.isEmpty(item.BOMCount) ? 0 : Integer.valueOf(item.BOMCount);
        
                    nextItemNumber += Integer.valueOf(Math.floor((bomItemNumberIncrement * bomCount) / itemNumberIncrement)) * itemNumberIncrement;
                    nextItemNumber += itemNumberIncrement;
                }
            }
        }
        catch (Exception ex)
        {
            salesDocDetail.IsSuccess = false;
            ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
        }
        return salesDocDetail;
    }
    
    @AuraEnabled
    public static ensxtx_DS_Document_Detail simulateSalesDoc(ensxtx_DS_Document_Detail salesDocDetail, ensxtx_DS_SalesDocAppSettings appSettings)
    {
        // Log size can be too big
        logger.enterAura('simulateSalesDoc', new Map<String, Object>{
            // 'salesDocDetail' => salesDocDetail,
            // 'appSettings' => appSettings
        });

        ensxsdk.EnosixFramework.DetailSBO sbo = initializeSBODetail(appSettings.SBODetailType);

        try
        {
            Integer startCpu = Limits.getCpuTime();
            Integer startHeap = Limits.getHeapSize();
            System.debug('Start getCpuTime(): '+ startCpu);
            System.debug('Start getHeapSize(): '+ startHeap);

            if (salesDocDetail == null) salesDocDetail = new ensxtx_DS_Document_Detail();
            ensxsdk.EnosixFramework.DetailObject result = ensxtx_UTIL_Document_Detail.convertToSBO(null, salesDocDetail, false, appSettings);
            String simulateCommand = ensxtx_UTIL_Document_Detail.getSimulateCommand(appSettings.SBODetailType);

            DateTime startTimer = System.now();
            System.debug('Start Timer: '+ startTimer);

            result.setBoolean(true,'useTextSerialize');
            result = sbo.executeCommand(simulateCommand, result);

            DateTime endTimer = System.now();
            System.debug('End Timer: '+ endTimer);
            System.debug('MilliSecond Simulate: ' + (endTimer.getTime() - startTimer.getTime()));

            Boolean isFromGetDetail = appSettings.InvokeMethod == 'Simulate' ? true : false;
            ensxtx_UTIL_Document_Detail.convertToObject(result, salesDocDetail, isFromGetDetail, appSettings, ensxtx_UTIL_Document_Detail.convertToObjectTrigger.simulateSalesDoc);

            if (appSettings.compareSAPSimulateVsSObject != null && appSettings.compareSAPSimulateVsSObject) {
                ensxtx_UTIL_SalesDoc.mapCustomPricingToSalesDoc(salesDocDetail, appSettings);
            }

            ensxtx_UTIL_PageMessages.addFrameworkMessages(result.getMessages());

            Integer endCpu = Limits.getCpuTime();
            Integer endHeap = Limits.getHeapSize();
            System.debug('End getHeapSize(): '+ endHeap);
            System.debug('End getCpuTime(): '+ endCpu);
            System.debug('Heap diff: ' + (endHeap - startHeap));
            System.debug('CPU diff: ' + (endCpu - startCpu));
        }
        catch (Exception ex)
        {
            salesDocDetail.IsSuccess = false;
            ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
        }
        finally
        {
            logger.exit();
        }

        return salesDocDetail;
    }

    public static Boolean saveToSObject(ensxtx_UTIL_SalesDoc.SFObject sfObject,
        ensxtx_DS_Document_Detail salesDocDetail, ensxtx_DS_SalesDocAppSettings appSettings)
    {
        logger.enterAura('saveToSObject', new Map<String, Object>{
            'sfObject' => sfObject,
            'salesDocDetail' => salesDocDetail,
            'appSettings' => appSettings
        });

        Boolean isSuccess = true;
        try
        {
            ensxtx_UTIL_SalesDoc.saveHeaderAndLineItems(sfObject, salesDocDetail, appSettings);
        }
        catch (Exception ex)
        {
            isSuccess = false;
            ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
        }
        finally
        {
            logger.exit();
        }

        return isSuccess;
    }

    public static ensxtx_DS_Document_Detail createSAPDocument(ensxtx_UTIL_SalesDoc.SFObject sfObject,
        ensxtx_DS_Document_Detail salesDocDetail, ensxtx_DS_SalesDocAppSettings appSettings)
    {
        // Log size can be too big
        logger.enterAura('createSAPDocument', new Map<String, Object>{
        //     'sfObject' => sfObject,
        //     'salesDocDetail' => salesDocDetail,
        //     'appSettings' => appSettings
        });

        if (salesDocDetail == null) return null;

        ensxsdk.EnosixFramework.DetailSBO sbo = initializeSBODetail(appSettings.SBODetailType);

        try
        {
            Integer startCpu = Limits.getCpuTime();
            Integer startHeap = Limits.getHeapSize();
            System.debug('Start getCpuTime(): '+ startCpu);
            System.debug('Start getHeapSize(): '+ startHeap);

            ensxsdk.EnosixFramework.DetailObject result = ensxtx_UTIL_Document_Detail.convertToSBO(null, salesDocDetail, false, appSettings);

            DateTime startTimer = System.now();
            System.debug('Start Timer: '+ startTimer);

            result.setBoolean(true,'useTextSerialize');
            result = sbo.executeSave(result);

            DateTime endTimer = System.now();
            System.debug('End Timer: '+ endTimer);
            System.debug('MilliSecond Create: ' + (endTimer.getTime() - startTimer.getTime()));

            ensxtx_UTIL_Document_Detail.convertToObject(result, salesDocDetail, false, appSettings, ensxtx_UTIL_Document_Detail.convertToObjectTrigger.createSAPDocument);

            ensxtx_UTIL_PageMessages.addFrameworkMessages(result.getMessages());

            if (sfObject.initFromSObject)
            {
                ensxtx_UTIL_SalesDoc.saveHeaderAndLineItems(sfObject, salesDocDetail, appSettings);
            }

            Integer endCpu = Limits.getCpuTime();
            Integer endHeap = Limits.getHeapSize();
            System.debug('End getHeapSize(): '+ endHeap);
            System.debug('End getCpuTime(): '+ endCpu);
            System.debug('Heap diff: ' + (endHeap - startHeap));
            System.debug('CPU diff: ' + (endCpu - startCpu));
        }
        catch (Exception ex)
        {
            salesDocDetail.IsSuccess = false;
            ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
        }
        finally
        {
            logger.exit();
        }

        return salesDocDetail;
    }

    @AuraEnabled
    public static ensxtx_DS_Document_Detail updateSAPDocument(ensxtx_UTIL_SalesDoc.SFObject sfObject,
        ensxtx_DS_Document_Detail salesDocDetail, ensxtx_DS_SalesDocAppSettings appSettings)
    {
        // Log size can be too big
        logger.enterAura('updateSAPDocument', new Map<String, Object>{
        //     'sfObject' => sfObject,
        //     'salesDocDetail' => salesDocDetail,
        //     'appSettings' => appSettings
        });

        ensxsdk.EnosixFramework.DetailSBO sbo = initializeSBODetail(appSettings.SBODetailType);

        try
        {
            Integer startCpu = Limits.getCpuTime();
            Integer startHeap = Limits.getHeapSize();
            System.debug('Start getCpuTime(): '+ startCpu);
            System.debug('Start getHeapSize(): '+ startHeap);

            ensxsdk.EnosixFramework.DetailObject result = sbo.executeGetDetail(salesDocDetail.SalesDocument);
            result = ensxtx_UTIL_Document_Detail.removeAllConditions(result, appSettings.SBODetailType);
            result = ensxtx_UTIL_Document_Detail.convertToSBO(result, salesDocDetail, true, appSettings);

            // Need to call Simulate before update because there are new added items
            if (salesDocDetail.callSimulateBeforeUpdate == true) {
                System.debug('Calling simulate before update');
                String simulateCommand = ensxtx_UTIL_Document_Detail.getSimulateCommand(appSettings.SBODetailType);
                result.setBoolean(true,'useTextSerialize');
                result = sbo.executeCommand(simulateCommand, result);
                result = ensxtx_UTIL_Document_Detail.updateSimulateBeforeUpdate(result, salesDocDetail, appSettings);
            }

            DateTime startTimer = System.now();
            System.debug('Start Timer: '+ startTimer);

            result.setBoolean(true,'useTextSerialize');
            result = sbo.executeSave(result);

            DateTime endTimer = System.now();
            System.debug('End Timer: '+ endTimer);
            System.debug('MilliSecond Updated: ' + (endTimer.getTime() - startTimer.getTime()));

            ensxtx_UTIL_Document_Detail.convertToObject(result, salesDocDetail, false, appSettings, ensxtx_UTIL_Document_Detail.convertToObjectTrigger.updateSAPDocument);
            ensxtx_UTIL_PageMessages.addFrameworkMessages(result.getMessages());

            if (sfObject.initFromSObject)
            {
                ensxtx_UTIL_SalesDoc.saveHeaderAndLineItems(sfObject, salesDocDetail, appSettings);
            }

            Integer endCpu = Limits.getCpuTime();
            Integer endHeap = Limits.getHeapSize();
            System.debug('End getHeapSize(): '+ endHeap);
            System.debug('End getCpuTime(): '+ endCpu);
            System.debug('Heap diff: ' + (endHeap - startHeap));
            System.debug('CPU diff: ' + (endCpu - startCpu));
        }
        catch (Exception ex)
        {
            salesDocDetail.IsSuccess = false;
            ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
        }
        finally
        {
            logger.exit();
        }

        return salesDocDetail;
    }

    public static ensxsdk.EnosixFramework.DetailSBO initializeSBODetail(String sboDetailType)
    {
        String className = 'ensxtx_SBO_Enosix' + sboDetailType + '_Detail';
        System.Type detailType = Type.forName(className);
        return (ensxsdk.EnosixFramework.DetailSBO) detailType.newInstance();
    }
}