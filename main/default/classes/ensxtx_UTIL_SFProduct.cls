public class ensxtx_UTIL_SFProduct
{
    private static final ensxsdk.Logger logger = new ensxsdk.Logger(ensxtx_UTIL_SFProduct.class);

    // The material number field on SF Product2 table
    private static String MaterialFieldNameSave = null;

    public static String MaterialFieldName
    {
        get
        {
            if (MaterialFieldNameSave == null) {
                MaterialFieldNameSave = '';
                try
                {
                    ensxtx_UTIL_MaterialMapping.MaterialMapping mapping = ensxtx_UTIL_MaterialMapping.getMapping();
                    MaterialFieldNameSave = mapping.materialNumber.productField;
                }
                catch(Exception ex) 
                { 
                    System.debug('Material Field Name not found'); 
                }
                MaterialFieldNameSave = String.isNotEmpty(MaterialFieldNameSave) ? MaterialFieldNameSave : (String)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.EnterpriseApp, 'Product.MaterialFieldName', 'ProductCode');
            }

            return MaterialFieldNameSave;
        }
    }

    public static String getConfigurableMaterialField()
    {
        String fieldName;
        Set<String> productFields = Schema.SObjectType.Product2.fields.getMap().keySet();
        String configurableMaterialFieldName = (String)ensxtx_UTIL_AppSettings.getValue(
            ensxtx_UTIL_AppSettings.EnterpriseApp, 'Product.ConfigurableMaterialFieldName', 'ensxtx_Configurable_Material__c');

        if (productFields.contains(configurableMaterialFieldName.toLowerCase())) {
            fieldName = configurableMaterialFieldName;
        }

        return fieldName;
    }

    public static String getBOMMaterialField()
    {
        String fieldName;
        Set<String> productFields = Schema.SObjectType.Product2.fields.getMap().keySet();
        String bomMaterialFieldName = (String)ensxtx_UTIL_AppSettings.getValue(
            ensxtx_UTIL_AppSettings.EnterpriseApp, 'Product.BOMMaterialFieldName', 'ensxtx_BOM_Material__c');

        if (productFields.contains(bomMaterialFieldName.toLowerCase())) {
            fieldName = bomMaterialFieldName;
        }

        return fieldName;
    }

    public static Product2 getProductById(Id value, List<String> fields)
    {
        return ensxtx_UTIL_SFProduct.getProductByField('Id', value, fields);
    }

    public static Product2 getProductById(Id value)
    {
        return ensxtx_UTIL_SFProduct.getProductById(value, null);
    }

    public static Product2 getProductByMaterialNumber(String value, List<String> fields)
    {
        return ensxtx_UTIL_SFProduct.getProductByField(ensxtx_UTIL_SFProduct.MaterialFieldName, value, fields);
    }

    public static Product2 getProductByMaterialNumber(String value)
    {
        return ensxtx_UTIL_SFProduct.getProductByMaterialNumber(value, null);
    }

    public static Map<Id, Product2> getProductsByField(String selectField, List<String> values, List<String> fields){

        Map<Id, Product2> product2Id2Product = new Map<Id, Product2>();

        // These need to be lowercase so we can merge with `fields` var without duplicates
        // Duplicates cause SOQL exception
        Set<String> selectFields = new Set<String> {
            'name',
            'productcode',
            'description',
            'createddate',
            ensxtx_UTIL_SFProduct.MaterialFieldName.toLowerCase()
        };

        if (fields != null){
            Integer fieldTot = fields.size();
            for (Integer fieldCnt = 0 ; fieldCnt < fieldTot ; fieldCnt++)
            {
                String field = fields[fieldCnt];
                if (String.isNotBlank(field)){
                    selectFields.add(field.toLowerCase());
                }
            }
        }

        Map<String, Schema.SObjectField> fieldDefs = Schema.SObjectType.Product2.fields.getMap();
        Set<String> accessibleFields = getAccessibleFields(fieldDefs, selectFields);
        if (values.size() > 0){
            String query = 'SELECT ' +
                String.escapeSingleQuotes(String.join(new List<String>(accessibleFields), ', ')) +
                ' FROM Product2 WHERE ' +
                String.escapeSingleQuotes(selectField.toLowerCase()) +
                ' IN :values AND isActive = true';
            product2Id2Product = new Map<Id, Product2>((List<Product2>) Database.query(query));
        }
        return product2Id2Product;
    }

    public static Product2 getProductByField(String selectField, String value, List<String> fields)
    {
        List<String> values = new List<String>();
        values.add(value);
        Map<Id, Product2> product2Id2Product = getProductsByField(selectField, values, fields);
        return product2Id2Product.values().size() > 0 ? product2Id2Product.values()[0] : null;
    }

    public static Boolean canUserSetMaterialNumber()
    {
        Map<String, Schema.SObjectField> fields = Schema.SObjectType.Product2.fields.getMap();
        return fields.get(ensxtx_UTIL_SFProduct.MaterialFieldName).getDescribe().isUpdateable();
    }

    public static String getMaterialNumberFromProduct(Product2 product)
    {
        String materialFieldName = ensxtx_UTIL_SFProduct.MaterialFieldName;
        return (String) product.get(materialFieldName);
    }

    public static void setProductMaterialNumber(Product2 product, String materialNumber)
    {
        if (canUserSetMaterialNumber())
        {
            String materialField = ensxtx_UTIL_SFProduct.MaterialFieldName;
            product.put(materialField, materialNumber);
        }
    }

    public static Boolean isProductLinkedToMaterial(Product2 product)
    {
        if (product == null) return false;
        return getMaterialNumberFromProduct(product) != null;
    }

    /// Gets a value from a field on an opportunity
    public static Object getValueFromProductField(Product2 prod, string field, String warningMessageFormat)
    {
        String result = null;

        if (null == prod || String.isBlank(field))
        {
            return result;
        }

        Map<String, Schema.SObjectField> fields = Schema.SObjectType.Product2.fields.getMap();
        DescribeFieldResult fieldDef = fields.get(field) == null ? null : fields.get(field).getDescribe();
        if (fieldDef == null || !fieldDef.isAccessible())
        {
            String fieldLable = fieldDef == null ? 'Invalid Field' : fieldDef.getLabel();
            ensxtx_UTIL_PageMessages.addMessage(
                ensxtx_UTIL_PageMessages.WARNING,
                String.format(warningMessageFormat, new String[]{ fieldLable })
            );
            return result;
        }

        String productField = field.toLowerCase();
        Object value = prod.get(productField);

        if (null != value)
        {
            return String.valueOf(value);
        }

        return result;
    }

    private static Set<String> getAccessibleFields(Map<String, Schema.SObjectField> fieldDefs, Set<String> selectFields){
        Set<String> accessibleFields = new Set<String>();
        List<String> selectFieldsList = new List<String>(selectFields);
        Integer fieldTot = selectFieldsList.size();
        for (Integer fieldCnt = 0 ; fieldCnt < fieldTot ; fieldCnt++)
        {
            String field = selectFieldsList[fieldCnt];
            if (fieldDefs.get(field).getDescribe().isAccessible()){
                accessibleFields.add(field);
            }
        }
         return accessibleFields;
    }

    public class SalesDocActionProductException extends Exception {}

    public class ProductInfo {
        public Id prodId;
        public Decimal quantity;
    }

    public static ensxtx_DS_Document_Detail sObjectToSalesDocMapping(
        Id accountId,
        List<String> productJSONList,
        String productSimulationFieldsMapJSON,
        ensxtx_DS_Document_Detail salesDocDetail,
        ensxtx_DS_SalesDocAppSettings appSettings)
    {
        List<Account> acctList = Database.query('SELECT Id, ' + ensxtx_UTIL_SFAccount.CustomerFieldName + ' FROM Account WHERE Id = :accountId');
        if (acctList.size() == 0) throw new SalesDocActionProductException('Account for Id ' + accountId + ' not found');

        String soldToNumber = (String) acctList[0].get(ensxtx_UTIL_SFAccount.CustomerFieldName);
        if (String.isEmpty(soldToNumber)) throw new SalesDocActionProductException('Customer Number is not found on Account');

        Map<Id, ProductInfo> productInfoMap = new Map<Id, ProductInfo>();
        Set<Id> productIdSet = new Set<Id>();
        for (String prodJSON : productJSONList) {
            ProductInfo prodInfo = (ProductInfo) JSON.deserialize(prodJSON, ProductInfo.class);
            productIdSet.add(prodInfo.prodId);
            productInfoMap.put(prodInfo.prodId, prodInfo);
        }

        List<Product2> prodList = Database.query('SELECT Id, ' + ensxtx_UTIL_SFProduct.MaterialFieldName + ' FROM Product2 WHERE Id in :productIdSet AND ' + ensxtx_UTIL_SFProduct.MaterialFieldName + ' != null');
        if (prodList.size() == 0) throw new SalesDocActionProductException('No Products found');

        // Mapping of header fields from SObject
        salesDocDetail.SoldToParty = soldToNumber;
        salesDocDetail.SalesDocumentCurrency = String.isEmpty(UserInfo.getDefaultCurrency()) ? 'USD' : UserInfo.getDefaultCurrency();
        salesDocDetail.CustomerPurchaseOrderDate = Date.today();
        salesDocDetail.CustomerPurchaseOrderNumber = 'Product';

        salesDocDetail.NeedToSimulate = true;

        salesDocDetail.SALES.SalesDocumentType = appSettings.DefaultDocType;
        salesDocDetail.SALES.SalesOrganization = appSettings.DefaultSalesOrganization;
        salesDocDetail.SALES.DistributionChannel = appSettings.DefaultDistributionChannel;
        salesDocDetail.SALES.Division = appSettings.DefaultDivision;

        if (productSimulationFieldsMapJSON != null) {
            Map<String, String> productSimulationFieldsMap = (Map<String, String>) JSON.deserialize(productSimulationFieldsMapJSON, Map<String, String>.class);
            Map<String, Object> headerMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(salesDocDetail));
            for (String key : productSimulationFieldsMap.keySet()) {
                if (key.split(':')[0] == 'Header') {
                    headerMap.put(key.split(':')[1], productSimulationFieldsMap.get(key));
                    if (key.split(':')[1] == 'SoldToParty') soldToNumber = productSimulationFieldsMap.get(key);
                }
            }
            salesDocDetail = (ensxtx_DS_Document_Detail) JSON.deserialize(JSON.serialize(headerMap), ensxtx_DS_Document_Detail.class);
            Map<String, Object> salesMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(salesDocDetail.SALES));
            for (String key : productSimulationFieldsMap.keySet()) {
                if (key.split(':')[0] == 'Sales') salesMap.put(key.split(':')[1], productSimulationFieldsMap.get(key));
            }
            salesDocDetail.SALES = (ensxtx_DS_Document_Detail.SALES) JSON.deserialize(JSON.serialize(salesMap), ensxtx_DS_Document_Detail.SALES.class);
        }

        ensxtx_DS_Document_Detail.PARTNERS soldToPartner = ensxtx_UTIL_SalesDoc.getPartnerFromDocumentDetail(salesDocDetail.PARTNERS, ensxtx_UTIL_Customer.SOLD_TO_PARTNER_CODE, true);
        soldToPartner.CustomerNumber = soldToNumber;

        Integer increment = appSettings.itemNumberIncrement;
        Integer itemNumber = increment;

        Integer lineItemTot = prodList.size();
        for (Integer lineItemCnt = 0; lineItemCnt < lineItemTot; lineItemCnt++)
        {
            Product2 prod = prodList[lineItemCnt];
            ProductInfo prodInfo = productInfoMap.get(prod.Id);
            ensxtx_DS_Document_Detail.ITEMS salesDocItem = new ensxtx_DS_Document_Detail.ITEMS();

            // Mapping of item fields from Sobject line items
            salesDocItem.ItemNumber = String.valueOf(itemNumber);
            salesDocItem.HigherLevelItemNumber = '000000';
            salesDocItem.Material = (String) prod.get(ensxtx_UTIL_SFProduct.MaterialFieldName);
            salesDocItem.OrderQuantity = prodInfo.quantity != null && prodInfo.quantity > 0 ? prodInfo.quantity : 1;
            salesDocItem.SFId = prod.Id;
            salesDocItem.ProductId = prod.Id;
            salesDocDetail.ITEMS.add(salesDocItem);
            itemNumber += increment;
        }
 
        return salesDocDetail;
    }
}