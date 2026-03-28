public class ensxtx_CTRL_MaterialSearchLtng
{
    private static final ensxsdk.Logger logger = new ensxsdk.Logger(ensxtx_CTRL_MaterialSearchLtng.class);

    @AuraEnabled
    public static ensxtx_UTIL_Aura.Response loadMaterialTypes (List<String> defaultMaterialTypes)
    {
        logger.enterAura('loadMaterialTypes', new Map<String, Object> {
            'defaultMaterialTypes' => defaultMaterialTypes
        });

        if (defaultMaterialTypes == null || defaultMaterialTypes.size() == 0)
        {
            defaultMaterialTypes = (List<String>)ensxtx_UTIL_AppSettings.getList(ensxtx_UTIL_AppSettings.EnterpriseApp,
                'DefaultMaterialTypes', String.class, new String[] { 'FERT' });
        }
        Set<String> defMaterialTypesSet = new Set<String>(defaultMaterialTypes);

        List<MaterialTypeResult> responseData = new List<MaterialTypeResult>();
        List<ensxtx_RFC_MM_GET_PROD_HIERARCHY.ET_MATERIAL_TYPE> matList = rfcSearchOptions.ET_MATERIAL_TYPE_List;
        Integer matTot = matList.size();
        for (Integer matCnt = 0 ; matCnt < matTot ; matCnt++)
        {
            ensxtx_RFC_MM_GET_PROD_HIERARCHY.ET_MATERIAL_TYPE materialType = matList[matCnt];
            if (defMaterialTypesSet.contains(materialType.MTART))
            {
                responseData.add(new MaterialTypeResult(materialType.MTART, materialType.MTBEZ));
            }
        }

        return ensxtx_UTIL_Aura.createResponse(responseData);      
    }

    @AuraEnabled
    public static ensxtx_UTIL_Aura.Response loadProductHierarchies()
    {
        logger.enterAura('loadProductHierarchies', null);

        return ensxtx_UTIL_Aura.createResponse(rfcSearchOptions.ET_PROD_HIERARCHY_List);
    }

    public class MaterialTypeResult
    {
        @AuraEnabled
        public String value { get; set; }
        @AuraEnabled
        public String label { get; set; }

        public MaterialTypeResult (String value, String label)
        {
            this.value = value;
            this.label = label;
        }
    }

    private static ensxtx_RFC_MM_GET_PROD_HIERARCHY.RESULT cache_rfcSearchOptions;
    private static ensxtx_RFC_MM_GET_PROD_HIERARCHY.RESULT rfcSearchOptions
    {
        get
        {
            if (null == cache_rfcSearchOptions)
            {
                ensxtx_RFC_MM_GET_PROD_HIERARCHY rfc = new ensxtx_RFC_MM_GET_PROD_HIERARCHY();
                // Only get 3 levels of product hierarchy
                rfc.Params.IV_LEVEL_NUMBER = '3';
                cache_rfcSearchOptions = rfc.execute();

                if (!cache_rfcSearchOptions.isSuccess())
                {
                    ensxtx_UTIL_PageMessages.addFrameworkMessages(cache_rfcSearchOptions.getMessages());
                }
            }
            return cache_rfcSearchOptions;
        }
    }

    @AuraEnabled
    public static ensxtx_UTIL_Aura.Response searchMaterials(Map<String, Object> searchParams, Map<String, Object> pagingOptions)
    {
        logger.enterAura('searchMaterials', new Map<String, Object> {
            'searchParams' => searchParams,
            'pagingOptions' => pagingOptions
        });

        List<ensxtx_SBO_EnosixMaterial_Search.SEARCHRESULT> responseData =
            new List<ensxtx_SBO_EnosixMaterial_Search.SEARCHRESULT>();
        Object responsePagingOptions = null;

        try
        {
            ensxtx_SBO_EnosixMaterial_Search sbo = new ensxtx_SBO_EnosixMaterial_Search();
            ensxtx_SBO_EnosixMaterial_Search.EnosixMaterial_SC context = new ensxtx_SBO_EnosixMaterial_Search.EnosixMaterial_SC();

            String materialDescription = (String) searchParams.get('MaterialDescription');
            if (null == materialDescription) materialDescription = '';
            if (!materialDescription.startsWith('*')) materialDescription = '*' + materialDescription;
            if (!materialDescription.endsWith('*')) materialDescription += '*';

            context.SEARCHPARAMS.MaterialDescription = materialDescription;
            String materialNumber = (String) searchParams.get('MaterialNumber');
            if (String.isNotEmpty(materialNumber)) context.SEARCHPARAMS.MaterialNumberFrom = materialNumber.toUpperCase();

            Boolean useSalesOrganization = (Boolean)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.MaterialSearch,
                'UseSalesOrganization', true);
            if (useSalesOrganization) context.SEARCHPARAMS.SalesOrganization = (String) searchParams.get('SalesOrganization');

            Boolean useDistributionChannel = (Boolean)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.MaterialSearch,
                'UseDistributionChannel', true);
            if (useDistributionChannel) context.SEARCHPARAMS.DistributionChannel = (String) searchParams.get('DistributionChannel');

            context.SEARCHPARAMS.ProductHierarchy = (String) searchParams.get('ProductHierarchy');

            Object materialTypeValuesObject = searchParams.get('MaterialTypeValues');
            if (materialTypeValuesObject != null && materialTypeValuesObject instanceof List<Object>)
            {
                List<Object> materialTypeValues = (List<Object>) materialTypeValuesObject;
                Integer matTot = materialTypeValues.size();
                if (matTot > 0)
                {
                    for (Integer matCnt = 0 ; matCnt < matTot ; matCnt++)
                    {
                        Object materialTypeValue = MaterialTypeValues[matCnt];
                        ensxtx_SBO_EnosixMaterial_Search.MATERIAL_TYPE type =
                                new ensxtx_SBO_EnosixMaterial_Search.MATERIAL_TYPE();
                        type.MaterialType = (String) materialTypeValue;
                        context.MATERIAL_TYPE.add(type);
                    }
                }
            }

            ensxtx_UTIL_Aura.setSearchContextPagingOptions(context, pagingOptions);
            sbo.search(context);

            responseData = context.result.getResults();
            responsePagingOptions = context.pagingOptions;
        }
        catch (Exception ex)
        {
            ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
        }
        finally
        {
            logger.exit();
        }

        return ensxtx_UTIL_Aura.createResponse(responseData, responsePagingOptions);      
    }
}