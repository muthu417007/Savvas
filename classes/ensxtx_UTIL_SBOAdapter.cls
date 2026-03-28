public class ensxtx_UTIL_SBOAdapter
{
    // Filter the next that only needs to be shown on the view
    public static List<ensxtx_DS_Document_Detail.TEXTS> filterTexts(
        List<ensxtx_DS_Document_Detail.TEXTS> currentTexts, 
        List<ensxtx_DS_Document_Detail.TEXTS> textList,
        List<ensxtx_DS_SalesDocAppSettings.TextSetting> textSettings)
    {
        Set<String> textIds = new Set<String>();
        if (currentTexts.isEmpty()) {
            addDefaultTexts(currentTexts, textSettings);
        }

        Integer textTot = currentTexts == null ? 0 : currentTexts.size();
        for (Integer textCnt = 0 ; textCnt < textTot ; textCnt++)
        {
            ensxtx_DS_Document_Detail.TEXTS currentText = currentTexts[textCnt];
            textIds.add(currentText.TextID);
        }

        Map<String, ensxtx_DS_Document_Detail.TEXTS> textIdValue = new Map<String, ensxtx_DS_Document_Detail.TEXTS>();
        textTot = textList == null ? 0 : textList.size();
        for (Integer textCnt = 0 ; textCnt < textTot ; textCnt++)
        {
            ensxtx_DS_Document_Detail.TEXTS text = textList[textCnt];
            if (textIds.contains(text.TextID)) {
                textIdValue.put(text.TextID, text);
            }
        }

        textTot = currentTexts.size();
        for (Integer textCnt = 0 ; textCnt < textTot ; textCnt++)
        {
            ensxtx_DS_Document_Detail.TEXTS currentText = currentTexts[textCnt];
            ensxtx_DS_Document_Detail.TEXTS text = textIdValue.get(currentText.TextID);
            if (text != null) {
                currentText.Text = text.Text;
                currentText.TextLanguage = text.TextLanguage;
            }
        }

        return currentTexts;
    }

    private static void addDefaultTexts(List<ensxtx_DS_Document_Detail.TEXTS> currentTexts, List<ensxtx_DS_SalesDocAppSettings.TextSetting>  defaultTexts)
    {
        Integer textTot = defaultTexts.size();
        for (Integer textCnt = 0 ; textCnt < textTot ; textCnt++) 
        {
            ensxtx_DS_SalesDocAppSettings.TextSetting defText = defaultTexts[textCnt];

            ensxtx_DS_Document_Detail.TEXTS newText = new ensxtx_DS_Document_Detail.TEXTS();
            newText.TextID = defText.Id;
            newText.TextIDDescription = defText.Description;
            newText.Required = defText.Required;
            currentTexts.add(newText);
        }
    }

    // Get the list of Added Conditions from the SBO
    // Conditions that are marked 'C' in ConditionOrigin are manually added
    public static List<ensxtx_DS_Document_Detail.CONDITIONS> getAddedConditions(List<ensxtx_DS_Document_Detail.CONDITIONS> conditions, Boolean HeaderCondition)
    {
        List<ensxtx_DS_Document_Detail.CONDITIONS> addedConditions = new List<ensxtx_DS_Document_Detail.CONDITIONS>();

        Integer condTot = conditions.size();
        for (Integer condCnt = 0 ; condCnt < condTot ; condCnt++)
        {
            ensxtx_DS_Document_Detail.CONDITIONS condition = conditions[condCnt];
            if((condition.ConditionControl == 'C' && HeaderCondition== true) || (condition.ConditionControl == 'C' && condition.OriginOfCondition !='D' && HeaderCondition== false)){
                addedConditions.add(condition);
            }
        }

        return addedConditions;
    }
    
        // Get the ZNET or ZCON Added Conditions from the SBO
    public static List<ensxtx_DS_Document_Detail.CONDITIONS> getfilteredSBOConditions(List<ensxtx_DS_Document_Detail.CONDITIONS> conditions, Boolean HeaderCondition)
    {
        List<ensxtx_DS_Document_Detail.CONDITIONS> addedConditions = new List<ensxtx_DS_Document_Detail.CONDITIONS>();

        Integer condTot = conditions.size();
        for (Integer condCnt = 0 ; condCnt < condTot ; condCnt++)
        {
            ensxtx_DS_Document_Detail.CONDITIONS condition = conditions[condCnt];
            if((condition.ConditionType == 'ZNET' || condition.ConditionType== 'ZCON')){
                addedConditions.add(condition);
                break;
            }
        }

        return addedConditions;
    }


    // Filter the Partners that only needs to be shown on the view
    public static List<ensxtx_DS_Document_Detail.PARTNERS> filterPartners(
        List<ensxtx_DS_SalesDocAppSettings.PartnerSetting> appSettingPartners, 
        List<ensxtx_DS_Document_Detail.PARTNERS> objPartners,
        List<ensxtx_DS_Document_Detail.PARTNERS> partners)
    {
        if (objPartners == null) objPartners = new List<ensxtx_DS_Document_Detail.PARTNERS>();

        if (appSettingPartners != null) 
        {
            Integer appSettingTot = appSettingPartners.size();
            for (Integer appSettingCnt = 0; appSettingCnt < appSettingTot; appSettingCnt++) 
            {
                ensxtx_DS_SalesDocAppSettings.PartnerSetting partnerSetting = appSettingPartners[appSettingCnt];
                ensxtx_DS_Document_Detail.PARTNERS partner = ensxtx_UTIL_SalesDoc.getPartnerFromDocumentDetail(partners, partnerSetting.PartnerFunction, true);
                partner.PartnerFunctionName = partnerSetting.PartnerFunctionName;
                partner.CustomLabel_PartnerFunctionName = partnerSetting.CustomLabel_PartnerFunctionName;
                partner.ComponentType = partnerSetting.ComponentType;
                partner.SearchType = partnerSetting.SearchType;
                partner.autoSearch = partnerSetting.autoSearch;
                partner.allowSearch = partnerSetting.allowSearch;
                partner.allowAddressOverride = partnerSetting.allowAddressOverride;
                partner.autoPopulateAddressOverrideFromCustomer = partnerSetting.autoPopulateAddressOverrideFromCustomer;
                ensxtx_DS_Document_Detail.PARTNERS objPartner = ensxtx_UTIL_SalesDoc.getPartnerFromDocumentDetail(objPartners, partnerSetting.PartnerFunction, true);
                ensxtx_DS_Document_Detail.clonePartner(partner, objPartner);
            }
        }

        return objPartners;
    }
}