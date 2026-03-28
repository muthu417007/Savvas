public with sharing class ensxtx_CTRL_CPQ_Sales_Org
{
    private static final ensxsdk.Logger logger = new ensxsdk.Logger(ensxtx_CTRL_CPQ_Sales_Org.class);

    private static String defaultCustomerNumber = (String)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.CPQV2, 'DefaultCustomerNumber', '');
    private static Set<String> genericSalesOrgs = (Set<String>)ensxtx_UTIL_AppSettings.getSet(ensxtx_UTIL_AppSettings.CPQV2, 'GenericCustomerSalesOrgs', String.class, new Set<String>{''});
    private static List<String> salesOrgList = (List<String>)ensxtx_UTIL_AppSettings.getList(ensxtx_UTIL_AppSettings.CPQV2, 'SalesOrgList', String.class, new List<String>());
    private static List<String> distributionChannelList = (List<String>)ensxtx_UTIL_AppSettings.getList(ensxtx_UTIL_AppSettings.CPQV2, 'DistributionChannelList', String.class, new List<String>());
    private static List<String> divisionList = (List<String>)ensxtx_UTIL_AppSettings.getList(ensxtx_UTIL_AppSettings.CPQV2, 'DivisionList', String.class, new List<String>());

    @AuraEnabled
    public static ensxtx_UTIL_Aura.Response getInfo(Id quoteId) 
    {   
        Object responseData = null;
        logger.enterAura('getInfo', new Map<String, Object> {
            'quoteId' => quoteId
        });
        string selectCmd = 'SELECT Id, ensxtx_Sold_To_Number__c, ensxtx_Sales_Organization__c, ' +
            ' ensxtx_Distribution_Channel__c, ensxtx_Division__c ' +
            ' FROM SBQQ__Quote__c WHERE Id = :quoteId';
        List<SBQQ__Quote__c> resultList = Database.query(selectCmd);
        String soldToNumber = null;
        String salesOrg = null;
        String salesDistChannel = null;
        String salesDivision = null;
        if (resultList.size() > 0)
        {
            soldToNumber = (String) resultList[0].ensxtx_Sold_To_Number__c;
            salesOrg = String.isEmpty(resultList[0].ensxtx_Sales_Organization__c) ? 
                (String)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.CPQV2, 'DefaultSalesOrg', '') :
                resultList[0].ensxtx_Sales_Organization__c;
            salesDistChannel = String.isEmpty(resultList[0].ensxtx_Distribution_Channel__c) ? 
                (String)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.CPQV2, 'DefaultDistributionChannel', '') :
                resultList[0].ensxtx_Distribution_Channel__c;
            salesDivision = String.isEmpty(resultList[0].ensxtx_Division__c) ? 
                (String)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.CPQV2, 'DefaultDivision', '') :
                resultList[0].ensxtx_Division__c;
        }

        return ensxtx_UTIL_Aura.createResponse(JSON.serialize(new Map<String,String> {
            'soldToNumber' => soldToNumber,
            'salesOrg' => salesOrg,
            'salesDistChannel' => salesDistChannel,
            'salesDivision' => salesDivision
        }));
    }

    @AuraEnabled
    public static ensxtx_UTIL_Aura.Response getSalesAreaList(String soldToNumber) 
    {   
        Object responseData = null;
        logger.enterAura('getSalesAreaList', new Map<String, Object> {
            'soldToNumber' => soldToNumber
        });
        try
        {   
            if(soldToNumber == null)
            {
                ensxtx_UTIL_PageMessages.addMessage(ensxtx_UTIL_PageMessages.ERROR, System.Label.ensxtx_CustomerNumber_Not_Found);
            }
            else
            {
                ensxtx_SBO_EnosixCustomer_Detail.EnosixCustomer cpqCustomer = ensxtx_CTRL_CPQ_Partners.getCustomerByNumber(soldToNumber);
                if (cpqCustomer == null)
                {
                    ensxtx_UTIL_PageMessages.addMessage(ensxtx_UTIL_PageMessages.ERROR, System.Label.ensxtx_CPQ_Quote_ErrorNotLinked);
                }
                else
                {
                    List<ensxtx_SBO_EnosixCustomer_Detail.SALES_DATA> sdList = cpqCustomer.SALES_DATA.getAsList();
                    Integer sdTot = sdList.size();
                    Integer soTot = salesOrgList.size();
                    Integer dcTot = distributionChannelList.size();
                    Integer dTot = divisionList.size();
                    for (Integer sdCnt = 0 ; sdCnt < sdTot ; sdCnt++)
                    {
                        ensxtx_SBO_EnosixCustomer_Detail.SALES_DATA sd = sdList[sdCnt];
                        boolean isValid = true;
                        if (soTot > 0)
                        {
                            boolean isFound = false;
                            for (Integer soCnt = 0 ; soCnt < soTot ; soCnt++)
                            {
                                String so = salesOrgList[soCnt];
                                if (so == sd.SalesOrganization) isFound = true;
                            }
                            if (!isFound) isValid = false;
                        }
                        if (dcTot > 0 && isValid)
                        {
                            boolean isFound = false;
                            for (Integer dcCnt = 0 ; dcCnt < dcTot ; dcCnt++)
                            {
                                String dc = distributionChannelList[dcCnt];
                                if (dc == sd.DistributionChannel) isFound = true;
                            }
                            if (!isFound) isValid = false;
                        }
                        if (dTot > 0 && isValid)
                        {
                            boolean isFound = false;
                            for (Integer dCnt = 0 ; dCnt < dTot ; dCnt++)
                            {
                                String div = divisionList[dCnt];
                                if (div == sd.Division) isFound = true;
                            }
                            if (!isFound) isValid = false;
                        }
                        if (cpqCustomer.CustomerNumber == defaultCustomerNumber && isValid)
                        {
                            if (!genericSalesOrgs.contains(sd.SalesOrganization)) isValid = false;
                        }
                        if (!isValid) cpqCustomer.SALES_DATA.remove(sd);
                    }
                    if(cpqCustomer.SALES_DATA.size() == 0)
                    {
                        ensxtx_UTIL_PageMessages.addMessage(ensxtx_UTIL_PageMessages.ERROR, System.Label.ensxtx_CPQ_Quote_ErrorNoSalesOrgs);
                    }
                    responseData = cpqCustomer; 
                }
            }

        }
        catch(Exception ex)
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
    public static ensxtx_UTIL_Aura.Response updateInfo(Map<String,Object> params) 
    {   
        Id quoteId = (String) params.get('quoteId');
        String salesOrg = (String) params.get('salesOrg');
        String salesDistChannel = (String) params.get('salesDistChannel');
        String salesDivision = (String) params.get('salesDivision');

        Boolean responseData = true;
        logger.enterAura('getInfo', new Map<String, Object> {
            'quoteId' => quoteId,
            'salesOrg' => salesOrg,
            'salesDistChannel' => salesDistChannel,
            'salesDivision' => salesDivision
        });
        try
        {
            SBQQ__Quote__c quote = new SBQQ__Quote__c();
            quote.Id = quoteId;
            quote.ensxtx_Sales_Organization__c = salesOrg;
            quote.ensxtx_Distribution_Channel__c = salesDistChannel;
            quote.ensxtx_Division__c = salesDivision;
            upsert quote;
        }
        catch (Exception ex)
        {
            ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
            responseData = false;
        }
        finally
        {
            logger.exit();
        }

        return ensxtx_UTIL_Aura.createResponse(responseData);
    }
}