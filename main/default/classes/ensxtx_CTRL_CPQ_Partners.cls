public with sharing class ensxtx_CTRL_CPQ_Partners
{
    private static final ensxsdk.Logger logger = new ensxsdk.Logger(ensxtx_CTRL_CPQ_Partners.class);

    @AuraEnabled
    public static ensxtx_UTIL_Aura.Response getPartnerList(
            Id quoteId, 
            String partnerField
        )
    {   
        String partnerLabel = 'NA';
        String currentPartnerNumber = null;
        List <ensxtx_SBO_SFCIPartner_Search.SEARCHRESULT> responseData = null;

        logger.enterAura('getPartnerList', new Map<String, Object> {
            'quoteId' => quoteId,
            'partnerField' => partnerField
        });

        string selectCmd = 'SELECT Id, ensxtx_Sold_To_Number__c, ensxtx_Ship_To_Number__c, ensxtx_Bill_To_Number__c, ' +
            ' ensxtx_Payer_Number__c, ensxtx_Sales_Organization__c, ensxtx_Distribution_Channel__c, ensxtx_Division__c ' +
            ' FROM SBQQ__Quote__c WHERE Id = :quoteId';
        List<SBQQ__Quote__c> resultList = Database.query(selectCmd);
        if (resultList.size() == 0)
        {
            ensxtx_UTIL_PageMessages.addMessage(ensxtx_UTIL_PageMessages.ERROR, System.Label.ensxtx_No_Quote_Found + ' ' + quoteId);
        }
        else
        {
            String soldToNumber = null;
            String salesOrg = null;
            String salesDistChannel = null;
            String salesDivision = null;
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

            if (soldToNumber == null)
            {
                ensxtx_UTIL_PageMessages.addMessage(ensxtx_UTIL_PageMessages.ERROR, System.Label.ensxtx_Account_Sold_To_Blank);
            }
            else
            {
                String partnerFunction = null;
                if (partnerField == 'soldToParty')
                {
                    partnerFunction = ensxtx_UTIL_Customer.SOLD_TO_PARTNER_CODE;
                    partnerLabel = System.Label.ensxtx_CPQ_Quote_SoldToParty;
                    currentPartnerNumber = (String) resultList[0].ensxtx_Sold_To_Number__c;
                } 
                else if (partnerField == 'shipToParty')
                {
                    partnerFunction = ensxtx_UTIL_Customer.SHIP_TO_PARTNER_CODE;
                    partnerLabel = System.Label.ensxtx_CPQ_Quote_ShipToParty;
                    currentPartnerNumber = (String) resultList[0].ensxtx_Ship_To_Number__c;
                }
                else if (partnerField == 'billToParty')
                {
                    partnerFunction = ensxtx_UTIL_Customer.BILL_TO_PARTNER_CODE;
                    partnerLabel = System.Label.ensxtx_CPQ_Quote_BillToParty;
                    currentPartnerNumber = (String) resultList[0].ensxtx_Bill_To_Number__c;
                }
                else if (partnerField == 'payerParty')
                {
                    partnerFunction = ensxtx_UTIL_Customer.PAYER_PARTNER_CODE;
                    partnerLabel = System.Label.ensxtx_CPQ_Quote_PayerParty;
                    currentPartnerNumber = (String) resultList[0].ensxtx_Payer_Number__c;
                }

                if (partnerFunction == null)
                {
                    ensxtx_UTIL_PageMessages.addMessage(ensxtx_UTIL_PageMessages.ERROR, System.Label.ensxtx_PartnerFunction_Not_Found);
                }
                else
                {
                    ensxtx_SBO_SFCIPartner_Search sbo = new ensxtx_SBO_SFCIPartner_Search();
                    ensxtx_SBO_SFCIPartner_Search.SFCIPartner_SC sc = new ensxtx_SBO_SFCIPartner_Search.SFCIPartner_SC();
                    try
                    {  
                        ensxtx_SBO_EnosixCustomer_Detail.EnosixCustomer cpqCustomer = getCustomerByNumber(soldToNumber);
                        if (cpqCustomer == null)
                        {
                            ensxtx_UTIL_PageMessages.addMessage(ensxtx_UTIL_PageMessages.ERROR, System.Label.ensxtx_CPQ_Quote_ErrorNotLinked);
                        }
                        else
                        {
                            sc.SEARCHPARAMS.CustomerNumber = soldToNumber;
                            sc.SEARCHPARAMS.PartnerFunction = partnerFunction;
                            sc.SEARCHPARAMS.SalesOrganization = salesOrg;
                            sc.SEARCHPARAMS.DistributionChannel = salesDistChannel;
                            sc.SEARCHPARAMS.Division = salesDivision;
                            sbo.search(sc);
                            responseData = sc.result.getResults();
                            
                            if(responseData.size() == 0)
                            {
                                ensxtx_UTIL_PageMessages.addMessage(ensxtx_UTIL_PageMessages.ERROR, System.Label.ensxtx_CPQ_Quote_ErrorNoPartners);
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
                }
            }
        }
        return ensxtx_UTIL_Aura.createResponse(JSON.serialize(new Map<String,String> {
                'results' => JSON.serialize(responseData),
                'partnerLabel' => partnerLabel,
                'currentPartnerNumber' => currentPartnerNumber
            }));
    }

    public static ensxtx_SBO_EnosixCustomer_Detail.EnosixCustomer getCustomerByNumber(String id)
    {
        ensxtx_SBO_EnosixCustomer_Detail sbo = new ensxtx_SBO_EnosixCustomer_Detail();
        ensxtx_SBO_EnosixCustomer_Detail.EnosixCustomer result = sbo.getDetail(id);

        if (!result.isSuccess())
        {
        	ensxtx_UTIL_ViewHelper.displayResultMessages(
                result.getMessages(), ensxsdk.EnosixFramework.MessageType.INFO);
            return null;
        }

        return result;
    }

    @AuraEnabled
    public static ensxtx_UTIL_Aura.Response updatePartner(Map<String,Object> params)
    {   
        Id quoteId = (String) params.get('quoteId');
        String partnerField = (String) params.get('partnerField');
        String partnerJSON = (String) params.get('partnerJSON');

        Boolean responseData = true;
        logger.enterAura('updatePartner', new Map<String, Object> {
            'quoteId' => quoteId,
            'partnerField' => partnerField,
            'partnerJSON' => partnerJSON
        });

        if (quoteId != null) 
        {
            try
            {
                Map<String, Object> partnerInfo = (Map<String, Object>) JSON.deserializeUntyped(partnerJSON);

                Boolean isNeedUpdate = false;
                string selectCmd = 'SELECT Id, ensxtx_Sold_To_Number__c, ensxtx_Ship_To_Number__c, ensxtx_Bill_To_Number__c, ' +
                    ' ensxtx_Payer_Number__c, ensxtx_Sales_Organization__c, ensxtx_Distribution_Channel__c, ensxtx_Division__c ' +
                    ' FROM SBQQ__Quote__c WHERE Id = :quoteId';
                List<SBQQ__Quote__c> resultList = Database.query(selectCmd);
                SBQQ__Quote__c quote = resultList[0];
                String partnerNumber = (String) partnerInfo.get('partnerNumber');
                if (partnerField == 'shipToParty')
                {
                    if (quote.ensxtx_Ship_To_Number__c != partnerNumber) {
                        isNeedUpdate = true;
                        quote.ensxtx_Ship_To_Number__c = partnerNumber;
                        quote.SBQQ__ShippingName__c = (String) partnerInfo.get('name');
                        quote.SBQQ__ShippingStreet__c = (String) partnerInfo.get('street');
                        quote.SBQQ__ShippingCity__c = (String) partnerInfo.get('city');
                        quote.SBQQ__ShippingState__c = (String) partnerInfo.get('region');
                        quote.SBQQ__ShippingPostalCode__c = (String) partnerInfo.get('postalCode');
                        quote.SBQQ__ShippingCountry__c = (String) partnerInfo.get('country');
                    }
                }
                else if (partnerField == 'billToParty')
                {
                    if (quote.ensxtx_Bill_To_Number__c != partnerNumber) {
                        isNeedUpdate = true;
                        quote.ensxtx_Bill_To_Number__c = partnerNumber;
                        quote.SBQQ__BillingName__c = (String) partnerInfo.get('name');
                        quote.SBQQ__BillingStreet__c = (String) partnerInfo.get('street');
                        quote.SBQQ__BillingCity__c = (String) partnerInfo.get('city');
                        quote.SBQQ__BillingState__c = (String) partnerInfo.get('region');
                        quote.SBQQ__BillingPostalCode__c = (String) partnerInfo.get('postalCode');
                        quote.SBQQ__BillingCountry__c = (String) partnerInfo.get('country');
                    }
                }
                else if (partnerField == 'payerParty')
                {
                    if (quote.ensxtx_Payer_Number__c != partnerNumber) {
                        isNeedUpdate = true;
                        quote.ensxtx_Payer_Number__c = partnerNumber;
                    }
                }

                if (isNeedUpdate) 
                {
                    update quote;
                }
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
        }

        return ensxtx_UTIL_Aura.createResponse(responseData);
    }
}