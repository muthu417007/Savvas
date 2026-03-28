public class ensxtx_CTRL_SalesDocCreateUpdate
{
    private static final ensxsdk.Logger logger = new ensxsdk.Logger(ensxtx_CTRL_SalesDocCreateUpdate.class);

    @AuraEnabled
    public static ensxtx_UTIL_Aura.Response initSFObject(Id recordId, String sapDocType)
    {
        ensxtx_UTIL_SalesDoc.SFObject result = ensxtx_UTIL_SalesDocCreateUpdate.initSFObject(recordId, sapDocType);

        return ensxtx_UTIL_Aura.createResponse(result);
    }

    @AuraEnabled
    public static ensxtx_UTIL_Aura.Response initSalesDocDetailFromSFObject(ensxtx_DS_Document_Detail salesDocDetail,
        ensxtx_UTIL_SalesDoc.SFObject sfObject, ensxtx_DS_SalesDocAppSettings appSettings)
    {

        salesDocDetail = ensxtx_UTIL_SalesDocCreateUpdate.initSalesDocDetailFromSFObject(salesDocDetail, sfObject, appSettings);

        return ensxtx_UTIL_Aura.createResponse(salesDocDetail);
    }

    @AuraEnabled
    public static ensxtx_UTIL_Aura.Response getSalesDocDetail(String salesDocNumber, ensxtx_DS_SalesDocAppSettings appSettings,
        ensxtx_UTIL_SalesDoc.SFObject sfObject)
    {
        ensxtx_DS_Document_Detail salesDocDetail = ensxtx_UTIL_SalesDocCreateUpdate.getSalesDocDetail(salesDocNumber, appSettings, sfObject);

        return ensxtx_UTIL_Aura.createResponse(salesDocDetail);
    }

    @AuraEnabled
    public static ensxtx_UTIL_Aura.Response getCustomerDetail(String customerNumber)
    {
        ensxtx_SBO_EnosixCustomer_Detail.EnosixCustomer customerDetail = ensxtx_UTIL_SalesDocCreateUpdate.getCustomerDetail(customerNumber);

        return ensxtx_UTIL_Aura.createResponse(customerDetail);
    }

    @AuraEnabled
    public static ensxtx_UTIL_Aura.Response compareSAPSimulateVsSObject(ensxtx_DS_Document_Detail salesDocDetail, ensxtx_DS_Document_Detail salesDocDetailFromSF, ensxtx_DS_SalesDocAppSettings appSettings)
    {
        return ensxtx_UTIL_Aura.createResponse(ensxtx_UTIL_SalesDocCreateUpdate.compareSAPSimulateVsSObject(salesDocDetail, salesDocDetailFromSF, appSettings));
    }

    @AuraEnabled
    public static ensxtx_UTIL_Aura.Response mapChildBomFields(ensxtx_DS_Document_Detail salesDocDetail, ensxtx_DS_Document_Detail salesDocDetailFromSF, ensxtx_DS_SalesDocAppSettings appSettings)
    {
        return ensxtx_UTIL_Aura.createResponse(ensxtx_UTIL_SalesDocCreateUpdate.mapChildBomFields(salesDocDetail, salesDocDetailFromSF, appSettings));
    }
    
    @AuraEnabled
    public static ensxtx_UTIL_Aura.Response getShipInfo()
    {        
        logger.enterAura('getShipInfo', null);
        
        ensxtx_RFC_SD_GET_SHIP_INFO.RESULT result = new ensxtx_RFC_SD_GET_SHIP_INFO.RESULT();
        try
        {           
            ensxtx_RFC_SD_GET_SHIP_INFO rfc = new ensxtx_RFC_SD_GET_SHIP_INFO();
            result = rfc.execute();
        }
        catch (Exception ex)
        {
            ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
            return ensxtx_UTIL_Aura.createResponse(null);
        }
        finally
        {
            logger.exit();
        }

        return ensxtx_UTIL_Aura.createResponse(result);
    }

    @AuraEnabled
    public static ensxtx_UTIL_Aura.Response getPricingStat()
    {        
        logger.enterAura('getPricingStat', null);

        ensxtx_RFC_SD_GET_PRICING_STAT.RESULT result;
        try
        {
            ensxtx_RFC_SD_GET_PRICING_STAT rfc = new ensxtx_RFC_SD_GET_PRICING_STAT();            
            result = rfc.execute();
        }        
        catch (Exception ex)
        {
            ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
            return ensxtx_UTIL_Aura.createResponse(null);
        }
        finally
        {
            logger.exit();
        }

        return ensxtx_UTIL_Aura.createResponse(result);
    }

    @AuraEnabled
    public static ensxtx_UTIL_Aura.Response getGroupOffice()
    {        
        logger.enterAura('getGroupOffice', null);

        ensxtx_RFC_SD_GET_GROUP_OFFICE.RESULT result;
        try
        {
            ensxtx_RFC_SD_GET_GROUP_OFFICE rfc = new ensxtx_RFC_SD_GET_GROUP_OFFICE();            
            result = rfc.execute();
        }        
        catch (Exception ex)
        {
            ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
            return ensxtx_UTIL_Aura.createResponse(null);
        }
        finally
        {
            logger.exit();
        }

        return ensxtx_UTIL_Aura.createResponse(result);
    }

    @AuraEnabled
    public static ensxtx_UTIL_Aura.Response getConditionTypes(Boolean isHeader, String pricingProcedure)
    {
        logger.enterAura('getConditionTypes', new Map<String, Object>{
            'isHeader' => isHeader,
            'pricingProcedure' => pricingProcedure
        });

        ensxtx_RFC_SD_GET_CONDITION_TYPES.RESULT result;
        try
        {
            ensxtx_RFC_SD_GET_CONDITION_TYPES rfc = new ensxtx_RFC_SD_GET_CONDITION_TYPES();
            rfc.PARAMS.IV_HEADER = isHeader ? 'B' : 'A';
            rfc.PARAMS.IV_KALSM = pricingProcedure;            
            result = rfc.execute();
        }        
        catch (Exception ex)
        {
            ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
            return ensxtx_UTIL_Aura.createResponse(null);
        }
        finally
        {
            logger.exit();
        }

        return ensxtx_UTIL_Aura.createResponse(result);
    }

    @AuraEnabled
    public static ensxtx_UTIL_Aura.Response getRejectionReasons()
    {
        logger.enterAura('getRejectionReasons', null);

        ensxtx_RFC_SD_GET_REJECTION_REASONS.RESULT result;
        try
        {
            ensxtx_RFC_SD_GET_REJECTION_REASONS rfc = new ensxtx_RFC_SD_GET_REJECTION_REASONS();            
            result = rfc.execute();
        }
        catch (Exception ex)
        {
            ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
            return ensxtx_UTIL_Aura.createResponse(null);
        }
        finally
        {
            logger.exit();
        }

        return ensxtx_UTIL_Aura.createResponse(result);
    }

    @AuraEnabled
    public static ensxtx_UTIL_Aura.Response getBillingPlans()
    {
        logger.enterAura('getBillingPlans', null);

        ensxtx_RFC_SD_GET_PERIO.RESULT result;
        try
        {
            ensxtx_RFC_SD_GET_PERIO rfc = new ensxtx_RFC_SD_GET_PERIO();            
            result = rfc.execute();
        }
        catch (Exception ex)
        {
            ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
            return ensxtx_UTIL_Aura.createResponse(null);
        }
        finally
        {
            logger.exit();
        }

        return ensxtx_UTIL_Aura.createResponse(result);
    }

    @AuraEnabled
    public static ensxtx_UTIL_Aura.Response getCountries()
    {
        logger.enterAura('getCountries', null);

        ensxtx_RFC_SD_GET_COUNTRIES.RESULT result;
        try
        {
            ensxtx_RFC_SD_GET_COUNTRIES rfc = new ensxtx_RFC_SD_GET_COUNTRIES();
            result = rfc.execute();
        }
        catch (Exception ex)
        {
            ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
            return ensxtx_UTIL_Aura.createResponse(null);
        }
        finally
        {
            logger.exit();
        }

        return ensxtx_UTIL_Aura.createResponse(result);
    }

    @AuraEnabled
    public static ensxtx_UTIL_Aura.Response getItemCategories(ensxtx_DS_Document_Detail.SALES salesDetail, String material)
    {
        logger.enterAura('getItemCategories', null);

        ensxtx_RFC_SD_GET_ITEMCAT_VALUES.RESULT result;
        try
        {
            ensxtx_RFC_SD_GET_ITEMCAT_VALUES rfc = new ensxtx_RFC_SD_GET_ITEMCAT_VALUES();            
            rfc.PARAMS.IV_AUART = salesDetail.SalesDocumentType;
            rfc.PARAMS.IV_VKORG = salesDetail.SalesOrganization;
            rfc.PARAMS.IV_VTWEG = salesDetail.DistributionChannel;
            rfc.PARAMS.IV_MATNR = material;
            result = rfc.execute();
        }
        catch (Exception ex)
        {
            ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
            return ensxtx_UTIL_Aura.createResponse(null);
        }
        finally
        {
            logger.exit();
        }

        return ensxtx_UTIL_Aura.createResponse(result);
    }

    @AuraEnabled
    public static ensxtx_UTIL_Aura.Response getMaterialUOM(String material)
    {
        logger.enterAura('getMaterialUOM', new Map<String, Object>{
            'material' => material
        });

        ensxtx_RFC_SD_GET_MATERIAL_UOM.RESULT result;
        try
        {
            ensxtx_RFC_SD_GET_MATERIAL_UOM rfc = new ensxtx_RFC_SD_GET_MATERIAL_UOM();
            rfc.PARAMS.IV_MATNR = material;
            result = rfc.execute();
        }
        catch (Exception ex)
        {
            ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
            return ensxtx_UTIL_Aura.createResponse(null);
        }
        finally
        {
            logger.exit();
        }

        return ensxtx_UTIL_Aura.createResponse(result);
    }

    @AuraEnabled
    public static ensxtx_UTIL_Aura.Response validateProductsInSalesforce(List<String> materials, Id pricebookId, String salesDocumentCurrency)
    {
        logger.enterAura('validateProductsInSalesforce', new Map<String, Object>{
            'materials' => materials,
            'pricebookId' => pricebookId,
            'salesDocumentCurrency' => salesDocumentCurrency
        });

        Set<String> materialNumbers = new Set<String>(materials);

        Map<String, PricebookEntry> materialNumberPbe = new Map<String, PricebookEntry>();

        try
        {
            ensxtx_UTIL_SalesDoc.validateMaterials(materialNumbers, pricebookId, materialNumberPbe, salesDocumentCurrency);
        }
        catch (ensxtx_UTIL_SalesDoc.MissingMaterialsException ex) { ensxtx_UTIL_PageMessages.addExceptionMessage(ex); }
        catch (Exception ex) { ensxtx_UTIL_PageMessages.addExceptionMessage(ex); }

        return ensxtx_UTIL_Aura.createResponse(materialNumberPbe.keySet());
    }

    @AuraEnabled
    public static ensxtx_UTIL_Aura.Response getMaterialsDetail(List<String> materials, String salesOrg, String distChannel)
    {
        logger.enterAura('getMaterialsDetail', new Map<String, Object>{
            'materials' => materials,
            'salesOrg' => salesOrg,
            'distChannel' => distChannel
        });

        Map<String, MaterialDetail> materialsDetail = new Map<String, MaterialDetail>();
        ensxtx_SBO_EnosixMaterial_Detail sbo = new ensxtx_SBO_EnosixMaterial_Detail();
        ensxtx_SBO_EnosixMaterial_Detail.EnosixMaterial result = new ensxtx_SBO_EnosixMaterial_Detail.EnosixMaterial();

        Integer matTot = materials.size();
        for (Integer matCnt = 0 ; matCnt < matTot ; matCnt++)
        {
            String material = materials[matCnt];
            try
            {
                result = sbo.getDetail(material);

                if (result.isSuccess() != null && !result.isSuccess()) {
                    ensxtx_UTIL_PageMessages.addFrameworkMessages(result.getMessages());
                    continue;
                }
                MaterialDetail matDetail = new MaterialDetail(result.MaterialDescription, result.BASIC_DATA_2.ConfigurableMaterial);

                List<ensxtx_SBO_EnosixMaterial_Detail.PLANT_DATA> plantList = result.PLANT_DATA.getAsList();
                Integer plantTot = plantList.size();
                for (Integer plantCnt = 0 ; plantCnt < plantTot ; plantCnt++)
                {
                    ensxtx_SBO_EnosixMaterial_Detail.PLANT_DATA plant = plantList[plantCnt];
                    MaterialPlant newPlant = new MaterialPlant();
                    newPlant.Plant = plant.Plant;
                    newPlant.PlantName = plant.Name;
                    newPlant.SalesOrganization = plant.SalesOrganization;
                    newPlant.DistributionChannel = plant.DistributionChannel;
                    matDetail.Plants.add(newPlant);
                }

                materialsDetail.put(material, matDetail);
            }
            catch(Exception ex)
            {
                System.debug('Invalid Material: ' + ex);
                ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
            }
        }
        logger.exit();
        return ensxtx_UTIL_Aura.createResponse(materialsDetail);
    }

    // Simple object for Material Detail
    public class MaterialDetail {

        public MaterialDetail(String MaterialDescription, Boolean ConfigurableMaterial) 
        {
            this.MaterialDescription = MaterialDescription;
            this.ConfigurableMaterial = ConfigurableMaterial;
            this.Plants = new List<MaterialPlant>();
        }

        @AuraEnabled public String MaterialDescription { get; set; }
        @AuraEnabled public Boolean ConfigurableMaterial { get; set; }
        @AuraEnabled public List<MaterialPlant> Plants { get; set; }
    }

    public class MaterialPlant {
        @AuraEnabled public String Plant { get; set; }
        @AuraEnabled public String PlantName { get; set; }
        @AuraEnabled public String SalesOrganization { get; set; }
        @AuraEnabled public String DistributionChannel { get; set; }
    }

    @AuraEnabled
    public static ensxtx_UTIL_Aura.Response getMaterialAvailability(String material, String plant)
    {
        logger.enterAura('getMaterialAvailability', new Map<String, Object>{
            'material' => material,
            'plant' => plant
        });

        ensxtx_SBO_EnosixMaterial_Detail sbo = new ensxtx_SBO_EnosixMaterial_Detail();
        ensxtx_SBO_EnosixMaterial_Detail.EnosixMaterial materialDetail = new ensxtx_SBO_EnosixMaterial_Detail.EnosixMaterial();
        try
        {
            materialDetail.Material = material;
            ensxtx_SBO_EnosixMaterial_Detail.MATL_AVAILABILITY matAvailability = new ensxtx_SBO_EnosixMaterial_Detail.MATL_AVAILABILITY();
            matAvailability.Plant = plant;
            materialDetail.MATL_AVAILABILITY.add(matAvailability);
            materialDetail = (ensxtx_SBO_EnosixMaterial_Detail.EnosixMaterial) sbo.executeCommand('CMD_GET_MAT_AVAILABILITY', materialDetail);
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
        return ensxtx_UTIL_Aura.createResponse(materialDetail);
    }

    @AuraEnabled
    public static ensxtx_UTIL_Aura.Response getReferenceDocument(String salesDocNumber, ensxtx_DS_SalesDocAppSettings appSettings)
    {
        ensxtx_DS_Document_Detail salesDocDetail = ensxtx_UTIL_SalesDocCreateUpdate.getReferenceDocument(salesDocNumber, appSettings);

        return ensxtx_UTIL_Aura.createResponse(salesDocDetail);
    }

    @AuraEnabled
    public static ensxtx_UTIL_Aura.Response getBomItemsCount(ensxtx_DS_Document_Detail salesDocDetail, ensxtx_DS_SalesDocAppSettings appSettings)
    {
        salesDocDetail = ensxtx_UTIL_SalesDocCreateUpdate.getBomItemsCount(salesDocDetail, appSettings);

        return ensxtx_UTIL_Aura.createResponse(salesDocDetail);
    }

    @AuraEnabled
    public static ensxtx_UTIL_Aura.Response simulateSalesDoc(ensxtx_DS_Document_Detail salesDocDetail, ensxtx_DS_SalesDocAppSettings appSettings)
    {
        salesDocDetail = ensxtx_UTIL_SalesDocCreateUpdate.simulateSalesDoc(salesDocDetail, appSettings);

        return ensxtx_UTIL_Aura.createResponse(salesDocDetail);
    }

    @AuraEnabled
    public static ensxtx_UTIL_Aura.Response saveToSObject(ensxtx_UTIL_SalesDoc.SFObject sfObject,
        ensxtx_DS_Document_Detail salesDocDetail, ensxtx_DS_SalesDocAppSettings appSettings)
    {
        Boolean isSuccess = ensxtx_UTIL_SalesDocCreateUpdate.saveToSObject(sfObject, salesDocDetail, appSettings);

        return ensxtx_UTIL_Aura.createResponse(isSuccess);
    }

    @AuraEnabled
    public static ensxtx_UTIL_Aura.Response createSAPDocument(ensxtx_UTIL_SalesDoc.SFObject sfObject,
        ensxtx_DS_Document_Detail salesDocDetail, ensxtx_DS_SalesDocAppSettings appSettings)
    {
        salesDocDetail = ensxtx_UTIL_SalesDocCreateUpdate.createSAPDocument(sfObject, salesDocDetail, appSettings);

        return ensxtx_UTIL_Aura.createResponse(salesDocDetail);
    }

    @AuraEnabled
    public static ensxtx_UTIL_Aura.Response updateSAPDocument(ensxtx_UTIL_SalesDoc.SFObject sfObject,
        ensxtx_DS_Document_Detail salesDocDetail, ensxtx_DS_SalesDocAppSettings appSettings)
    {
        salesDocDetail = ensxtx_UTIL_SalesDocCreateUpdate.updateSAPDocument(sfObject, salesDocDetail, appSettings);

        return ensxtx_UTIL_Aura.createResponse(salesDocDetail);
    }

    @AuraEnabled
    public static void closeSession(String sessionData)
    {
        logger.enterAura('closeSession', new Map<String, Object> {
            'sessionData' => sessionData
        });

        try
        {
            //ensxtx_UTIL_VCRequest.closeSession(sessionData);
        }
        catch (Exception ex) {
            ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
        }
        finally
        {
            logger.exit();
        }
    }
}