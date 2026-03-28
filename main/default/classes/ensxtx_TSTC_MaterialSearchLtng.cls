@isTest
public class ensxtx_TSTC_MaterialSearchLtng
{
    public class MOC_ensxtx_SBO_EnosixMaterial_Search implements ensxsdk.EnosixFramework.SearchSBOSearchMock
    {
        private boolean success = true;

        public void setSuccess(boolean successful)
        {
            this.success = successful;
        }

        private boolean throwException = false;

        public void setThrowException(boolean throwException)
        {
            this.throwException = throwException;
        }

        public ensxsdk.EnosixFramework.SearchContext executeSearch(ensxsdk.EnosixFramework.SearchContext searchContext)
        {
            if (throwException)
            {
                throw new CalloutException();
            }

            ensxtx_SBO_EnosixMaterial_Search.EnosixMaterial_SR sr = new ensxtx_SBO_EnosixMaterial_Search.EnosixMaterial_SR();

            ensxtx_SBO_EnosixMaterial_Search.SEARCHRESULT result = new ensxtx_SBO_EnosixMaterial_Search.SEARCHRESULT();
            result.Material = 'Material';
            result.MaterialDescription = 'MaterialDescription';
            result.MaterialType = 'MaterialType';
            result.MaterialTypeDescription = 'MaterialTypeDescription';
            result.MaterialGroup = 'MaterialGroup';
            result.SalesOrganization = 'SalesOrganization';
            result.DistributionChannel = 'DistributionChannel';
            result.BaseUnitOfMeasure = 'BaseUnitOfMeasure';
            sr.SearchResults.add(result);
            sr.setSuccess(this.success);
            searchContext.baseResult = sr;
			return searchContext;
        }
    }

    public class MOC_ensxtx_RFC_MM_GET_PROD_HIERARCHY implements ensxsdk.EnosixFramework.RFCMock
    {
        public ensxsdk.EnosixFramework.FunctionObject executeFunction()
        {
            ensxtx_RFC_MM_GET_PROD_HIERARCHY.RESULT funcObj =
                new ensxtx_RFC_MM_GET_PROD_HIERARCHY.RESULT();

            ensxtx_RFC_MM_GET_PROD_HIERARCHY.ET_PROD_HIERARCHY ph1 =
                new ensxtx_RFC_MM_GET_PROD_HIERARCHY.ET_PROD_HIERARCHY();
            ph1.PRODH = 'PH1';
            ph1.VTEXT = 'Hierarchy 1';
            ph1.STUFE = '1';

            ensxtx_RFC_MM_GET_PROD_HIERARCHY.ET_PROD_HIERARCHY ph2 =
                new ensxtx_RFC_MM_GET_PROD_HIERARCHY.ET_PROD_HIERARCHY();
            ph2.PRODH = 'PH2';
            ph2.VTEXT = 'Hierarchy 2';
            ph2.STUFE = '2';

            ensxtx_RFC_MM_GET_PROD_HIERARCHY.ET_MATERIAL_TYPE mt1 =
                new ensxtx_RFC_MM_GET_PROD_HIERARCHY.ET_MATERIAL_TYPE();
            mt1.MTART = 'FERT';
            mt1.MTBEZ = 'Material Type 1';

            ensxtx_RFC_MM_GET_PROD_HIERARCHY.ET_MATERIAL_TYPE mt2 =
                new ensxtx_RFC_MM_GET_PROD_HIERARCHY.ET_MATERIAL_TYPE();
            mt2.MTART = 'ZMT2';
            mt2.MTBEZ = 'Material Type 2';

            ensxtx_RFC_MM_GET_PROD_HIERARCHY.ET_PRODUCT_ATTRIB pa1 =
                new ensxtx_RFC_MM_GET_PROD_HIERARCHY.ET_PRODUCT_ATTRIB();
            pa1.PRODUCT_ATTRIB = 'PA1';

            ensxtx_RFC_MM_GET_PROD_HIERARCHY.ET_PRODUCT_ATTRIB pa2 =
                new ensxtx_RFC_MM_GET_PROD_HIERARCHY.ET_PRODUCT_ATTRIB();
            pa2.PRODUCT_ATTRIB = 'PA2';

            funcObj.getCollection(ensxtx_RFC_MM_GET_PROD_HIERARCHY.ET_PROD_HIERARCHY.class).add(ph1);
            funcObj.getCollection(ensxtx_RFC_MM_GET_PROD_HIERARCHY.ET_PROD_HIERARCHY.class).add(ph2);
            funcObj.getCollection(ensxtx_RFC_MM_GET_PROD_HIERARCHY.ET_MATERIAL_TYPE.class).add(mt1);
            funcObj.getCollection(ensxtx_RFC_MM_GET_PROD_HIERARCHY.ET_MATERIAL_TYPE.class).add(mt2);
            funcObj.getCollection(ensxtx_RFC_MM_GET_PROD_HIERARCHY.ET_PRODUCT_ATTRIB.class).add(pa1);
            funcObj.getCollection(ensxtx_RFC_MM_GET_PROD_HIERARCHY.ET_PRODUCT_ATTRIB.class).add(pa2);
            funcObj.setSuccess(false);

            return funcObj;
        }
    }
    
    @isTest
    public static void test_searchMaterials()
    {
        MOC_ensxtx_SBO_EnosixMaterial_Search mocSboEnosixMaterialSearch = new MOC_ensxtx_SBO_EnosixMaterial_Search();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_EnosixMaterial_Search.class, mocSboEnosixMaterialSearch);

        Map<String, Object> searchParams = new Map<String, Object>{
            'MaterialDescription' => 'MaterialDescription',
            'MaterialNumber' => 'MaterialNumber',
            'SalesOrganization' => 'SalesOrganization',
            'DistributionChannel' => 'DistributionChannel',
            'MaterialTypeValues' => new List<String> {'FERT'}
        };

        Map<String, Object> pagingOptions = new Map<String, Object>{
            'pageSize' => '10',
            'pageNumber' => '2'
        };

        ensxtx_UTIL_Aura.Response response = ensxtx_CTRL_MaterialSearchLtng.searchMaterials(searchParams, pagingOptions);
        System.assert(response != null);
        mocSboEnosixMaterialSearch.setThrowException(true);
        response = ensxtx_CTRL_MaterialSearchLtng.searchMaterials(searchParams, pagingOptions);
    }   
    
    @isTest
    public static void test_loadMaterialTypes()
    {
        MOC_ensxtx_RFC_MM_GET_PROD_HIERARCHY mocRfcMmGetProdHierarcy = new MOC_ensxtx_RFC_MM_GET_PROD_HIERARCHY();
        ensxsdk.EnosixFramework.setMock(ensxtx_RFC_MM_GET_PROD_HIERARCHY.class, mocRfcMmGetProdHierarcy);

        ensxtx_UTIL_Aura.Response response = ensxtx_CTRL_MaterialSearchLtng.loadMaterialTypes(null);
        System.assert(response != null);
    }   
    
    @isTest
    public static void test_loadProductHierarchies()
    {
        MOC_ensxtx_RFC_MM_GET_PROD_HIERARCHY mocRfcMmGetProdHierarcy = new MOC_ensxtx_RFC_MM_GET_PROD_HIERARCHY();
        ensxsdk.EnosixFramework.setMock(ensxtx_RFC_MM_GET_PROD_HIERARCHY.class, mocRfcMmGetProdHierarcy);

        ensxtx_UTIL_Aura.Response response = ensxtx_CTRL_MaterialSearchLtng.loadProductHierarchies();
        System.assert(response != null);
    }   
}