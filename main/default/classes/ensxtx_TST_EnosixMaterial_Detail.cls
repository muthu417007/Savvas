/// enosiX Inc. Generated Apex Model
/// Generated On: 3/29/2023 2:18:04 PM
/// SAP Host: From REST Service On: https://app-momentum-3977-dev-ed.scratch.my.salesforce.com
/// CID: From REST Service On: https://app-momentum-3977-dev-ed.scratch.my.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework ensxapp.v1.2

@isTest
public with sharing class ensxtx_TST_EnosixMaterial_Detail
{
    public class Mockensxtx_SBO_EnosixMaterial_Detail implements
        ensxsdk.EnosixFramework.DetailSBOInitMock,
        ensxsdk.EnosixFramework.DetailSBOCommandMock,
        ensxsdk.EnosixFramework.DetailSBOGetMock,
        ensxsdk.EnosixFramework.DetailSBOSaveMock
    {
        public ensxsdk.EnosixFramework.DetailObject executeInitialize(ensxsdk.EnosixFramework.DetailObject initialState) { return null; }
        public ensxsdk.EnosixFramework.DetailObject executeCommand(String command, ensxsdk.EnosixFramework.DetailObject obj) { return null; }
        public ensxsdk.EnosixFramework.DetailObject executeGetDetail(object key) { return null; }
        public ensxsdk.EnosixFramework.DetailObject executeSave(ensxsdk.EnosixFramework.DetailObject obj) { return null; }
    }

    @isTest
    static void testSBO()
    {
        ensxtx_SBO_EnosixMaterial_Detail sbo = new ensxtx_SBO_EnosixMaterial_Detail();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_EnosixMaterial_Detail.class, new Mockensxtx_SBO_EnosixMaterial_Detail());
        System.assertEquals(null, sbo.initialize(null));
        System.assertEquals(null, sbo.command(null, null));
        System.assertEquals(null, sbo.getDetail(null));
        System.assertEquals(null, sbo.save(null));
    }

    @isTest
    static void testEnosixMaterial()
    {
        ensxtx_SBO_EnosixMaterial_Detail.EnosixMaterial result = new ensxtx_SBO_EnosixMaterial_Detail.EnosixMaterial();
        System.assertEquals(ensxtx_SBO_EnosixMaterial_Detail.EnosixMaterial.class, result.getType(), 'getType() does not match object type.');

        result.registerReflectionForClass();

        result.Material = 'X';
        System.assertEquals('X', result.Material);

        result.MaterialDescription = 'X';
        System.assertEquals('X', result.MaterialDescription);

        result.MaterialDescriptionUpperCase = 'X';
        System.assertEquals('X', result.MaterialDescriptionUpperCase);

        //Test child collections
        System.assertNotEquals(null,result.BASIC_DATA_1);
        System.assertNotEquals(null,result.BASIC_DATA_2);
        System.assertNotEquals(null,result.PLANT_DATA.getAsList());
        System.assertNotEquals(null,result.SALES_DATA.getAsList());
        System.assertNotEquals(null,result.MATL_AVAILABILITY.getAsList());
    }

    @isTest
    static void testBASIC_DATA_1()
    {
        ensxtx_SBO_EnosixMaterial_Detail.BASIC_DATA_1 childObj = new ensxtx_SBO_EnosixMaterial_Detail.BASIC_DATA_1();
        System.assertEquals(ensxtx_SBO_EnosixMaterial_Detail.BASIC_DATA_1.class,childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        childObj.Material = 'X';
        System.assertEquals('X', childObj.Material);

        childObj.BaseUnitOfMeasure = 'X';
        System.assertEquals('X', childObj.BaseUnitOfMeasure);

        childObj.OldMaterialNumber = 'X';
        System.assertEquals('X', childObj.OldMaterialNumber);

        childObj.Division = 'X';
        System.assertEquals('X', childObj.Division);

        childObj.AllocationDeterminationProcedure = 'X';
        System.assertEquals('X', childObj.AllocationDeterminationProcedure);

        childObj.CrossPlantMaterialStatus = 'X';
        System.assertEquals('X', childObj.CrossPlantMaterialStatus);

        childObj.OverrideChangeNumbers = true;
        System.assertEquals(true, childObj.OverrideChangeNumbers);

        childObj.MaterialGroup = 'X';
        System.assertEquals('X', childObj.MaterialGroup);

        childObj.ExternalMaterialGroup = 'X';
        System.assertEquals('X', childObj.ExternalMaterialGroup);

        childObj.Laboratory = 'X';
        System.assertEquals('X', childObj.Laboratory);

        childObj.CrossPlantStatusValidDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.CrossPlantStatusValidDate);

        childObj.GeneralItemCategoryGroup = 'X';
        System.assertEquals('X', childObj.GeneralItemCategoryGroup);

        childObj.AuthorizationGroup = 'X';
        System.assertEquals('X', childObj.AuthorizationGroup);

        childObj.GrossWeight = 1.5;
        System.assertEquals(1.5, childObj.GrossWeight);

        childObj.WeightUnit = 'X';
        System.assertEquals('X', childObj.WeightUnit);

        childObj.Netweight = 1.5;
        System.assertEquals(1.5, childObj.Netweight);

        childObj.Volume = 1.5;
        System.assertEquals(1.5, childObj.Volume);

        childObj.VolumeUnit = 'X';
        System.assertEquals('X', childObj.VolumeUnit);

        childObj.SizeDimensions = 'X';
        System.assertEquals('X', childObj.SizeDimensions);

        childObj.ArticleNumber = 'X';
        System.assertEquals('X', childObj.ArticleNumber);

        childObj.InternationalArticleNumber = 'X';
        System.assertEquals('X', childObj.InternationalArticleNumber);

        childObj.MaterialGroupPackagingMaterials = 'X';
        System.assertEquals('X', childObj.MaterialGroupPackagingMaterials);

        childObj.ReferenceMaterialPackedInSameWay = 'X';
        System.assertEquals('X', childObj.ReferenceMaterialPackedInSameWay);

        List<string> keyFields = new List<string>{ 'EnosixObjKey' };
    
        List<string> keys = childObj.getKeyFields();
        for(Integer i = 0; i < keys.size(); i++)
        {
            system.assertEquals(keyFields[i],keys[i]);
        }
    }
    @isTest
    static void testBASIC_DATA_2()
    {
        ensxtx_SBO_EnosixMaterial_Detail.BASIC_DATA_2 childObj = new ensxtx_SBO_EnosixMaterial_Detail.BASIC_DATA_2();
        System.assertEquals(ensxtx_SBO_EnosixMaterial_Detail.BASIC_DATA_2.class,childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        childObj.ANSIISODescription = 'X';
        System.assertEquals('X', childObj.ANSIISODescription);

        childObj.CADIndicator = true;
        System.assertEquals(true, childObj.CADIndicator);

        childObj.BasicMaterial = 'X';
        System.assertEquals('X', childObj.BasicMaterial);

        childObj.IntrastatDataTransportMedium = 'X';
        System.assertEquals('X', childObj.IntrastatDataTransportMedium);

        childObj.DangerousGoodsIndicator = 'X';
        System.assertEquals('X', childObj.DangerousGoodsIndicator);

        childObj.DangerousGoodsPackagingStatus = 'X';
        System.assertEquals('X', childObj.DangerousGoodsPackagingStatus);

        childObj.PackagingCode = 'X';
        System.assertEquals('X', childObj.PackagingCode);

        childObj.EnvironmentallyRelevant = true;
        System.assertEquals(true, childObj.EnvironmentallyRelevant);

        childObj.InBulkIndicator = 'X';
        System.assertEquals('X', childObj.InBulkIndicator);

        childObj.HighlyViscousIndicator = 'X';
        System.assertEquals('X', childObj.HighlyViscousIndicator);

        childObj.NonDMSDocumentNumber = 'X';
        System.assertEquals('X', childObj.NonDMSDocumentNumber);

        childObj.NonDMSDocumentType = 'X';
        System.assertEquals('X', childObj.NonDMSDocumentType);

        childObj.NonDMSDocumentVersion = 'X';
        System.assertEquals('X', childObj.NonDMSDocumentVersion);

        childObj.NonDMSDocumentPageNumber = 'X';
        System.assertEquals('X', childObj.NonDMSDocumentPageNumber);

        childObj.NonDMSDocumentChangeNumber = 'X';
        System.assertEquals('X', childObj.NonDMSDocumentChangeNumber);

        childObj.NonDMSDocumentPageFormat = 'X';
        System.assertEquals('X', childObj.NonDMSDocumentPageFormat);

        childObj.NonDMSDocumentNumberOfSheets = 'X';
        System.assertEquals('X', childObj.NonDMSDocumentNumberOfSheets);

        childObj.CrossPlantConfigurableMaterial = 'X';
        System.assertEquals('X', childObj.CrossPlantConfigurableMaterial);

        childObj.ConfigurableMaterial = true;
        System.assertEquals(true, childObj.ConfigurableMaterial);

        childObj.GlobalDataSyncIndicator = true;
        System.assertEquals(true, childObj.GlobalDataSyncIndicator);

        List<string> keyFields = new List<string>{ 'EnosixObjKey' };
    
        List<string> keys = childObj.getKeyFields();
        for(Integer i = 0; i < keys.size(); i++)
        {
            system.assertEquals(keyFields[i],keys[i]);
        }
    }
    @isTest
    static void testPLANT_DATA()
    {
        ensxtx_SBO_EnosixMaterial_Detail.PLANT_DATA childObj = new ensxtx_SBO_EnosixMaterial_Detail.PLANT_DATA();
        System.assertEquals(ensxtx_SBO_EnosixMaterial_Detail.PLANT_DATA.class,childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        childObj.Plant = 'X';
        System.assertEquals('X', childObj.Plant);

        childObj.Name = 'X';
        System.assertEquals('X', childObj.Name);

        childObj.SalesOrganization = 'X';
        System.assertEquals('X', childObj.SalesOrganization);

        childObj.SalesOrgDescription = 'X';
        System.assertEquals('X', childObj.SalesOrgDescription);

        childObj.DistributionChannel = 'X';
        System.assertEquals('X', childObj.DistributionChannel);

        childObj.DistributionChannelDescription = 'X';
        System.assertEquals('X', childObj.DistributionChannelDescription);

        childObj.MaterialPrice = 1.5;
        System.assertEquals(1.5, childObj.MaterialPrice);

        childObj.FieldCurrency = 'X';
        System.assertEquals('X', childObj.FieldCurrency);

        List<string> keyFields = new List<string>{ 'WERKS','VKORG','VTWEG' };
    
        List<string> keys = childObj.getKeyFields();
        for(Integer i = 0; i < keys.size(); i++)
        {
            system.assertEquals(keyFields[i],keys[i]);
        }
    }
    @isTest
    static void testSALES_DATA()
    {
        ensxtx_SBO_EnosixMaterial_Detail.SALES_DATA childObj = new ensxtx_SBO_EnosixMaterial_Detail.SALES_DATA();
        System.assertEquals(ensxtx_SBO_EnosixMaterial_Detail.SALES_DATA.class,childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        childObj.SalesOrganization = 'X';
        System.assertEquals('X', childObj.SalesOrganization);

        childObj.SalesOrgDescription = 'X';
        System.assertEquals('X', childObj.SalesOrgDescription);

        childObj.DistributionChannel = 'X';
        System.assertEquals('X', childObj.DistributionChannel);

        childObj.DistributionChannelDescription = 'X';
        System.assertEquals('X', childObj.DistributionChannelDescription);

        childObj.MaterialPrice = 1.5;
        System.assertEquals(1.5, childObj.MaterialPrice);

        childObj.FieldCurrency = 'X';
        System.assertEquals('X', childObj.FieldCurrency);

        List<string> keyFields = new List<string>{ 'VKORG','VKORG_TEXT','VTWEG','VTWEG_TEXT','KONWA' };
    
        List<string> keys = childObj.getKeyFields();
        for(Integer i = 0; i < keys.size(); i++)
        {
            system.assertEquals(keyFields[i],keys[i]);
        }
    }
    @isTest
    static void testMATL_AVAILABILITY()
    {
        ensxtx_SBO_EnosixMaterial_Detail.MATL_AVAILABILITY childObj = new ensxtx_SBO_EnosixMaterial_Detail.MATL_AVAILABILITY();
        System.assertEquals(ensxtx_SBO_EnosixMaterial_Detail.MATL_AVAILABILITY.class,childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        childObj.Plant = 'X';
        System.assertEquals('X', childObj.Plant);

        childObj.CommittedDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.CommittedDate);

        childObj.CommittedQuantity = 1.5;
        System.assertEquals(1.5, childObj.CommittedQuantity);

        List<string> keyFields = new List<string>{ 'WERKS','COM_DATE' };
    
        List<string> keys = childObj.getKeyFields();
        for(Integer i = 0; i < keys.size(); i++)
        {
            system.assertEquals(keyFields[i],keys[i]);
        }
    }
}