public class ensxtx_UTIL_VCPricingV2
{
    private static final ensxsdk.Logger logger = new ensxsdk.Logger(ensxtx_UTIL_VCPricingV2.class);
    
    public static String defaultMaterialgroup1 = (String)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.CPQV2, 'DefaultMaterialgroup1', '');    
    public static String defaultMaterialgroup2 = (String)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.CPQV2, 'DefaultMaterialgroup2', '');
    public static Boolean isIncompleteAllowed = (Boolean)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.CPQV2, 'isIncompleteAllowed', false);

    /// Actually executes a pricing simulation for a a configured SBO.
    public static void simulatePricing(
        ensxtx_DS_Document_Detail salesDocDetail
    ) {
        logger.enter('simulatePricing', new Map<String, Object> {
            'salesDocDetail' => salesDocDetail
        });

        try
        {            
            ensxtx_DS_Document_Detail.PARTNERS soldToPartner = null;
            Integer partTot = salesDocDetail.PARTNERS.size();
            for (Integer partCnt = 0 ; partCnt < partTot ; partCnt++) {
                ensxtx_DS_Document_Detail.PARTNERS partner = salesDocDetail.PARTNERS[partCnt];
                if (partner.PartnerFunction == ensxtx_UTIL_Customer.SOLD_TO_PARTNER_CODE) soldToPartner = partner;
            }
            if (soldToPartner == null) {
                soldToPartner = new ensxtx_DS_Document_Detail.PARTNERS();
                soldToPartner.PartnerFunction = ensxtx_UTIL_Customer.SOLD_TO_PARTNER_CODE;
                salesDocDetail.PARTNERS.add(soldToPartner);
            }

            Integer itemTot = salesDocDetail.ITEMS.size();
            for (Integer itemCnt = 0 ; itemCnt < itemTot ; itemCnt++) {
                ensxtx_DS_Document_Detail.ITEMS item = salesDocDetail.ITEMS[itemCnt];
                if (String.isEmpty(item.Materialgroup1)) item.Materialgroup1 = defaultMaterialgroup1;
                if (String.isEmpty(item.Materialgroup2)) item.Materialgroup2 = defaultMaterialgroup2;
            }

            ensxtx_DS_SalesDocAppSettings appSettings = new ensxtx_DS_SalesDocAppSettings();
            appSettings.SBODetailType = (String)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.CPQV2, 'SBODetailType', 'Pricing');
            appSettings.enableBoMItemEdit = true;

            List<ensxtx_DS_Document_Detail.ITEMS> incompleteItemList = new List<ensxtx_DS_Document_Detail.ITEMS>();
            for (Integer itemCnt = itemTot - 1 ; itemCnt >= 0 ; itemCnt--) {
                ensxtx_DS_Document_Detail.ITEMS item = salesDocDetail.ITEMS[itemCnt];
                if (item.isConfigurationFromVCComplete != null && !item.isConfigurationFromVCComplete && isIncompleteAllowed) {
                    incompleteItemList.add(item);
                    salesDocDetail.ITEMS.remove(itemCnt);
                }
            }

            ensxsdk.EnosixFramework.DetailObject result = null;

            if (salesDocDetail.ITEMS.size() > 0) {
                Integer startCpu = Limits.getCpuTime();
                Integer startHeap = Limits.getHeapSize();
                System.debug('Start getCpuTime(): '+ startCpu);
                System.debug('Start getHeapSize(): '+ startHeap);

                result = ensxtx_UTIL_Document_Detail.convertToSBO(null, salesDocDetail, false, appSettings);
                String simulateCommand = ensxtx_UTIL_Document_Detail.getSimulateCommand(appSettings.SBODetailType);

                DateTime startTimer = System.now();
                System.debug('Start Timer: '+ startTimer);

                result.setBoolean(true,'useTextSerialize');
                ensxsdk.EnosixFramework.DetailSBO sbo = ensxtx_UTIL_SalesDocCreateUpdate.initializeSBODetail(appSettings.SBODetailType);
                result = sbo.executeCommand(simulateCommand, result);

                DateTime endTimer = System.now();
                System.debug('End Timer: '+ endTimer);
                System.debug('MilliSecond Simulate: ' + (endTimer.getTime() - startTimer.getTime()));

                ensxtx_UTIL_Document_Detail.convertToObject(result, salesDocDetail, false, appSettings, ensxtx_UTIL_Document_Detail.convertToObjectTrigger.simulateSalesDoc);

                Integer endCpu = Limits.getCpuTime();
                Integer endHeap = Limits.getHeapSize();
                System.debug('End getHeapSize(): '+ endHeap);
                System.debug('End getCpuTime(): '+ endCpu);
                System.debug('Heap diff: ' + (endHeap - startHeap));
                System.debug('CPU diff: ' + (endCpu - startCpu));
    
                ensxtx_UTIL_PageMessages.addFrameworkMessages(result.getMessages());
            } else salesDocDetail.isSuccess = true;
            if (incompleteItemList.size() > 0) {
                salesDocDetail.ITEMS.addAll(incompleteItemList);
                itemTot = salesDocDetail.ITEMS.size();
                Map<Integer, ensxtx_DS_Document_Detail.ITEMS> salesDocItemsMap = new Map<Integer, ensxtx_DS_Document_Detail.ITEMS>();
                for (Integer itemCnt = 0 ; itemCnt < itemTot ; itemCnt++) {
                    ensxtx_DS_Document_Detail.ITEMS item = salesDocDetail.ITEMS[itemCnt];
                    salesDocItemsMap.put(Integer.valueOf(item.ItemNumber), item);
                }
                List<Integer> itemNumberList = new List<Integer>(salesDocItemsMap.keySet());
                itemNumberList.sort();
                salesDocDetail.ITEMS.clear();
                for (Integer itemCnt = 0 ; itemCnt < itemTot ; itemCnt++) {
                    ensxtx_DS_Document_Detail.ITEMS item = salesDocItemsMap.get(itemNumberList[itemCnt]);
                    salesDocDetail.ITEMS.add(item);
                }
            }

            if (salesDocDetail.isSuccess && (result == null || !hasErrorMessages(result.getMessages())))
            {
                System.debug('simulation was a success');
                if (result != null) System.debug(result.getMessages());
                System.debug('fetched ' + salesDocDetail.ITEMS.size() +' items from SAP');
            }
            else
            {
                handleSimulateFailure(result.getMessages());
            }
        } catch (Exception ex) {
            logger.log(LoggingLevel.ERROR, 'There was an exception thrown when attempting to simulatePricing.', ex);
            throw ex;
        } finally { 
            logger.exit();
        }
    }

    @testVisible
    private static Boolean hasErrorMessages(List<ensxsdk.EnosixFramework.Message> messages) {
        Integer messageSize = messages == null ? 0 : messages.size();
        if (messageSize > 0) {
            for (Integer i = 0 ; i < messageSize ; i++) {
                switch on messages[i].Type {
                    when ERROR, ABNORMALEND, SAPEXIT {
                        return true;
                    }
                }
            }
        }
        return false;
    }

    @testVisible
    private static void handleSimulateFailure(List<ensxsdk.EnosixFramework.Message> messages)
    {
        System.debug('simulation failure');
        System.debug(messages);
        string exceptionMessage = '';
        integer messageSize = messages == null ? 0 : messages.size();
        if (messageSize == 0 )
        {
            exceptionMessage = 'Quote Calculation Failed';
        }
        else
        {
            for (integer i = 0 ; i < messageSize ; i++) {
                exceptionMessage += messages[i].Text;
                if (i != messageSize - 1) exceptionMessage += '; ';
            }
        }
        throw new ensxtx_ENSX_Exceptions.SimulationException(exceptionMessage);
    }
}