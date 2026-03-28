/// enosiX Inc. Generated Apex Model
/// Generated On: 11/14/2022 6:02:49 PM
/// SAP Host: From REST Service On: https://efficiency-force-3506-dev-ed.scratch.my.salesforce.com
/// CID: From REST Service On: https://efficiency-force-3506-dev-ed.scratch.my.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework ensxapp.v1.2

@isTest
public with sharing class ensxtx_TST_EnosixEquipment_Detail
{
    public class Mockensxtx_SBO_EnosixEquipment_Detail implements
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
        ensxtx_SBO_EnosixEquipment_Detail sbo = new ensxtx_SBO_EnosixEquipment_Detail();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_EnosixEquipment_Detail.class, new Mockensxtx_SBO_EnosixEquipment_Detail());
        System.assertEquals(null, sbo.initialize(null));
        System.assertEquals(null, sbo.command(null, null));
        System.assertEquals(null, sbo.getDetail(null));
        System.assertEquals(null, sbo.save(null));
    }

    @isTest
    static void testEnosixEquipment()
    {
        ensxtx_SBO_EnosixEquipment_Detail.EnosixEquipment result = new ensxtx_SBO_EnosixEquipment_Detail.EnosixEquipment();
        System.assertEquals(ensxtx_SBO_EnosixEquipment_Detail.EnosixEquipment.class, result.getType(), 'getType() does not match object type.');

        result.registerReflectionForClass();

        result.EquipmentNumber = 'X';
        System.assertEquals('X', result.EquipmentNumber);

        result.EquipmentNumberDescription = 'X';
        System.assertEquals('X', result.EquipmentNumberDescription);

        result.Equipmentcategory = 'X';
        System.assertEquals('X', result.Equipmentcategory);

        result.EquipmentcategoryText = 'X';
        System.assertEquals('X', result.EquipmentcategoryText);

        result.UserStatus = 'X';
        System.assertEquals('X', result.UserStatus);

        result.UserStatusText = 'X';
        System.assertEquals('X', result.UserStatusText);

        result.ValidFromDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), result.ValidFromDate);

        result.ValidToDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), result.ValidToDate);

        result.TechnicalObjectType = 'X';
        System.assertEquals('X', result.TechnicalObjectType);

        result.AuthorizationGroup = 'X';
        System.assertEquals('X', result.AuthorizationGroup);

        result.GrossWeight = 1.5;
        System.assertEquals(1.5, result.GrossWeight);

        result.WeightUnit = 'X';
        System.assertEquals('X', result.WeightUnit);

        result.SizeDimensions = 'X';
        System.assertEquals('X', result.SizeDimensions);

        result.InventoryNumber = 'X';
        System.assertEquals('X', result.InventoryNumber);

        result.AcquisitionValue = 1.5;
        System.assertEquals(1.5, result.AcquisitionValue);

        result.CurrencyKey = 'X';
        System.assertEquals('X', result.CurrencyKey);

        result.AcquisitionDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), result.AcquisitionDate);

        result.AssetManufacturer = 'X';
        System.assertEquals('X', result.AssetManufacturer);

        result.ManufactureCountry = 'X';
        System.assertEquals('X', result.ManufactureCountry);

        result.ManufacturerModelNumber = 'X';
        System.assertEquals('X', result.ManufacturerModelNumber);

        result.ConstructionYear = 'X';
        System.assertEquals('X', result.ConstructionYear);

        result.ConstructionMonth = 'X';
        System.assertEquals('X', result.ConstructionMonth);

        result.ManufacturerPartNumber = 'X';
        System.assertEquals('X', result.ManufacturerPartNumber);

        result.ManufacturerSerialNumber = 'X';
        System.assertEquals('X', result.ManufacturerSerialNumber);

        result.LongText = 'X';
        System.assertEquals('X', result.LongText);

        result.ObjectNumber = 'X';
        System.assertEquals('X', result.ObjectNumber);

        //Test child collections
        System.assertNotEquals(null,result.LOCATION);
        System.assertNotEquals(null,result.ORGANIZATION);
        System.assertNotEquals(null,result.STRUCTURE);
        System.assertNotEquals(null,result.WARRANTY);
        System.assertNotEquals(null,result.SALES);
        System.assertNotEquals(null,result.SERDATA);
        System.assertNotEquals(null,result.PARTNERS.getAsList());
    }

    @isTest
    static void testLOCATION()
    {
        ensxtx_SBO_EnosixEquipment_Detail.LOCATION childObj = new ensxtx_SBO_EnosixEquipment_Detail.LOCATION();
        System.assertEquals(ensxtx_SBO_EnosixEquipment_Detail.LOCATION.class,childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        childObj.MaintenancePlant = 'X';
        System.assertEquals('X', childObj.MaintenancePlant);

        childObj.MaintenanceObjectLocation = 'X';
        System.assertEquals('X', childObj.MaintenanceObjectLocation);

        childObj.Room = 'X';
        System.assertEquals('X', childObj.Room);

        childObj.PlantSection = 'X';
        System.assertEquals('X', childObj.PlantSection);

        childObj.WorkCenter = 'X';
        System.assertEquals('X', childObj.WorkCenter);

        childObj.TechnicalObjectABCindicator = 'X';
        System.assertEquals('X', childObj.TechnicalObjectABCindicator);

        childObj.SortField = 'X';
        System.assertEquals('X', childObj.SortField);

        childObj.CustomerName = 'X';
        System.assertEquals('X', childObj.CustomerName);

        childObj.Name2 = 'X';
        System.assertEquals('X', childObj.Name2);

        childObj.Street = 'X';
        System.assertEquals('X', childObj.Street);

        childObj.PostalCode = 'X';
        System.assertEquals('X', childObj.PostalCode);

        childObj.City = 'X';
        System.assertEquals('X', childObj.City);

        childObj.Country = 'X';
        System.assertEquals('X', childObj.Country);

        childObj.Region = 'X';
        System.assertEquals('X', childObj.Region);

        childObj.TelephoneNumber = 'X';
        System.assertEquals('X', childObj.TelephoneNumber);

        childObj.FaxNumber = 'X';
        System.assertEquals('X', childObj.FaxNumber);

        List<string> keyFields = new List<string>{ 'EnosixObjKey' };
    
        List<string> keys = childObj.getKeyFields();
        for(Integer i = 0; i < keys.size(); i++)
        {
            system.assertEquals(keyFields[i],keys[i]);
        }
    }
    @isTest
    static void testORGANIZATION()
    {
        ensxtx_SBO_EnosixEquipment_Detail.ORGANIZATION childObj = new ensxtx_SBO_EnosixEquipment_Detail.ORGANIZATION();
        System.assertEquals(ensxtx_SBO_EnosixEquipment_Detail.ORGANIZATION.class,childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        childObj.CompanyCode = 'X';
        System.assertEquals('X', childObj.CompanyCode);

        childObj.BusinessArea = 'X';
        System.assertEquals('X', childObj.BusinessArea);

        childObj.AssetNumber = 'X';
        System.assertEquals('X', childObj.AssetNumber);

        childObj.AssetSubnumber = 'X';
        System.assertEquals('X', childObj.AssetSubnumber);

        childObj.CostCenter = 'X';
        System.assertEquals('X', childObj.CostCenter);

        childObj.ControllingArea = 'X';
        System.assertEquals('X', childObj.ControllingArea);

        childObj.WBSElement = 'X';
        System.assertEquals('X', childObj.WBSElement);

        childObj.StandingOrderNumber = 'X';
        System.assertEquals('X', childObj.StandingOrderNumber);

        childObj.SettlementOrder = 'X';
        System.assertEquals('X', childObj.SettlementOrder);

        childObj.PlanningPlant = 'X';
        System.assertEquals('X', childObj.PlanningPlant);

        childObj.PlannerGroup = 'X';
        System.assertEquals('X', childObj.PlannerGroup);

        childObj.MainWorkCenter = 'X';
        System.assertEquals('X', childObj.MainWorkCenter);

        childObj.MainWorkCenterPlant = 'X';
        System.assertEquals('X', childObj.MainWorkCenterPlant);

        childObj.CatalogProfile = 'X';
        System.assertEquals('X', childObj.CatalogProfile);

        List<string> keyFields = new List<string>{ 'EnosixObjKey' };
    
        List<string> keys = childObj.getKeyFields();
        for(Integer i = 0; i < keys.size(); i++)
        {
            system.assertEquals(keyFields[i],keys[i]);
        }
    }
    @isTest
    static void testSTRUCTURE()
    {
        ensxtx_SBO_EnosixEquipment_Detail.STRUCTURE childObj = new ensxtx_SBO_EnosixEquipment_Detail.STRUCTURE();
        System.assertEquals(ensxtx_SBO_EnosixEquipment_Detail.STRUCTURE.class,childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        childObj.FunctionalLocation = 'X';
        System.assertEquals('X', childObj.FunctionalLocation);

        childObj.FunctionalLocationDescription = 'X';
        System.assertEquals('X', childObj.FunctionalLocationDescription);

        childObj.SuperordEquipment = 'X';
        System.assertEquals('X', childObj.SuperordEquipment);

        childObj.SuperordEquipmentDescription = 'X';
        System.assertEquals('X', childObj.SuperordEquipmentDescription);

        childObj.HEQNR = 'X';
        System.assertEquals('X', childObj.HEQNR);

        childObj.TechIdentNo = 'X';
        System.assertEquals('X', childObj.TechIdentNo);

        childObj.ConstType = 'X';
        System.assertEquals('X', childObj.ConstType);

        List<string> keyFields = new List<string>{ 'EnosixObjKey' };
    
        List<string> keys = childObj.getKeyFields();
        for(Integer i = 0; i < keys.size(); i++)
        {
            system.assertEquals(keyFields[i],keys[i]);
        }
    }
    @isTest
    static void testWARRANTY()
    {
        ensxtx_SBO_EnosixEquipment_Detail.WARRANTY childObj = new ensxtx_SBO_EnosixEquipment_Detail.WARRANTY();
        System.assertEquals(ensxtx_SBO_EnosixEquipment_Detail.WARRANTY.class,childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        childObj.CustomerWarrantyStartDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.CustomerWarrantyStartDate);

        childObj.CustomerWarrantyEndDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.CustomerWarrantyEndDate);

        childObj.CustomerMasterWarranty = 'X';
        System.assertEquals('X', childObj.CustomerMasterWarranty);

        childObj.ManufacturerWarrantyStartDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.ManufacturerWarrantyStartDate);

        childObj.ManufacturerWarrantyEndDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.ManufacturerWarrantyEndDate);

        childObj.ManufacturerMasterWarranty = 'X';
        System.assertEquals('X', childObj.ManufacturerMasterWarranty);

        List<string> keyFields = new List<string>{ 'EnosixObjKey' };
    
        List<string> keys = childObj.getKeyFields();
        for(Integer i = 0; i < keys.size(); i++)
        {
            system.assertEquals(keyFields[i],keys[i]);
        }
    }
    @isTest
    static void testSALES()
    {
        ensxtx_SBO_EnosixEquipment_Detail.SALES childObj = new ensxtx_SBO_EnosixEquipment_Detail.SALES();
        System.assertEquals(ensxtx_SBO_EnosixEquipment_Detail.SALES.class,childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        childObj.SalesOrganization = 'X';
        System.assertEquals('X', childObj.SalesOrganization);

        childObj.SalesOrganizationText = 'X';
        System.assertEquals('X', childObj.SalesOrganizationText);

        childObj.DistributionChannel = 'X';
        System.assertEquals('X', childObj.DistributionChannel);

        childObj.DistributionChannelText = 'X';
        System.assertEquals('X', childObj.DistributionChannelText);

        childObj.Division = 'X';
        System.assertEquals('X', childObj.Division);

        childObj.DivisionText = 'X';
        System.assertEquals('X', childObj.DivisionText);

        childObj.SalesOffice = 'X';
        System.assertEquals('X', childObj.SalesOffice);

        childObj.SalesOfficeText = 'X';
        System.assertEquals('X', childObj.SalesOfficeText);

        childObj.SalesGroup = 'X';
        System.assertEquals('X', childObj.SalesGroup);

        childObj.SalesGroupText = 'X';
        System.assertEquals('X', childObj.SalesGroupText);

        childObj.LicenseNumber = 'X';
        System.assertEquals('X', childObj.LicenseNumber);

        childObj.SoldTo = 'X';
        System.assertEquals('X', childObj.SoldTo);

        childObj.ShipTo = 'X';
        System.assertEquals('X', childObj.ShipTo);

        List<string> keyFields = new List<string>{ 'EnosixObjKey' };
    
        List<string> keys = childObj.getKeyFields();
        for(Integer i = 0; i < keys.size(); i++)
        {
            system.assertEquals(keyFields[i],keys[i]);
        }
    }
    @isTest
    static void testSERDATA()
    {
        ensxtx_SBO_EnosixEquipment_Detail.SERDATA childObj = new ensxtx_SBO_EnosixEquipment_Detail.SERDATA();
        System.assertEquals(ensxtx_SBO_EnosixEquipment_Detail.SERDATA.class,childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        childObj.Material = 'X';
        System.assertEquals('X', childObj.Material);

        childObj.MaterialDescription = 'X';
        System.assertEquals('X', childObj.MaterialDescription);

        childObj.SerialNumber = 'X';
        System.assertEquals('X', childObj.SerialNumber);

        childObj.LastSerialNo = 'X';
        System.assertEquals('X', childObj.LastSerialNo);

        childObj.StockType = 'X';
        System.assertEquals('X', childObj.StockType);

        childObj.Plant = 'X';
        System.assertEquals('X', childObj.Plant);

        childObj.CompanyCode = 'X';
        System.assertEquals('X', childObj.CompanyCode);

        childObj.StorageLocation = 'X';
        System.assertEquals('X', childObj.StorageLocation);

        childObj.StockBatch = 'X';
        System.assertEquals('X', childObj.StockBatch);

        childObj.MasterBatch = 'X';
        System.assertEquals('X', childObj.MasterBatch);

        childObj.SpecialStockInd = 'X';
        System.assertEquals('X', childObj.SpecialStockInd);

        childObj.LastGoodsMvtDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.LastGoodsMvtDate);

        childObj.CustomerNumber = 'X';
        System.assertEquals('X', childObj.CustomerNumber);

        childObj.Vendor = 'X';
        System.assertEquals('X', childObj.Vendor);

        childObj.SalesDocument = 'X';
        System.assertEquals('X', childObj.SalesDocument);

        childObj.SalesDocumentItem = 'X';
        System.assertEquals('X', childObj.SalesDocumentItem);

        childObj.WBSElementInternal = 'X';
        System.assertEquals('X', childObj.WBSElementInternal);

        childObj.ShipTo = 'X';
        System.assertEquals('X', childObj.ShipTo);

        List<string> keyFields = new List<string>{ 'EnosixObjKey' };
    
        List<string> keys = childObj.getKeyFields();
        for(Integer i = 0; i < keys.size(); i++)
        {
            system.assertEquals(keyFields[i],keys[i]);
        }
    }
    @isTest
    static void testPARTNERS()
    {
        ensxtx_SBO_EnosixEquipment_Detail.PARTNERS childObj = new ensxtx_SBO_EnosixEquipment_Detail.PARTNERS();
        System.assertEquals(ensxtx_SBO_EnosixEquipment_Detail.PARTNERS.class,childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        childObj.PartnerFunction = 'X';
        System.assertEquals('X', childObj.PartnerFunction);

        childObj.PARVW_IN = 'X';
        System.assertEquals('X', childObj.PARVW_IN);

        childObj.PartnerFunctionDescription = 'X';
        System.assertEquals('X', childObj.PartnerFunctionDescription);

        childObj.Counter = 'X';
        System.assertEquals('X', childObj.Counter);

        childObj.CustomerNumber = 'X';
        System.assertEquals('X', childObj.CustomerNumber);

        childObj.Vendor = 'X';
        System.assertEquals('X', childObj.Vendor);

        childObj.PersonnelNumber = 'X';
        System.assertEquals('X', childObj.PersonnelNumber);

        childObj.ContactPersonNumber = 'X';
        System.assertEquals('X', childObj.ContactPersonNumber);

        childObj.CustomerName = 'X';
        System.assertEquals('X', childObj.CustomerName);

        childObj.PartnerName2 = 'X';
        System.assertEquals('X', childObj.PartnerName2);

        childObj.Name3 = 'X';
        System.assertEquals('X', childObj.Name3);

        childObj.Name4 = 'X';
        System.assertEquals('X', childObj.Name4);

        childObj.City = 'X';
        System.assertEquals('X', childObj.City);

        childObj.District = 'X';
        System.assertEquals('X', childObj.District);

        childObj.PostalCode = 'X';
        System.assertEquals('X', childObj.PostalCode);

        childObj.POBoxPostalCode = 'X';
        System.assertEquals('X', childObj.POBoxPostalCode);

        childObj.Country = 'X';
        System.assertEquals('X', childObj.Country);

        childObj.Region = 'X';
        System.assertEquals('X', childObj.Region);

        childObj.Street = 'X';
        System.assertEquals('X', childObj.Street);

        childObj.POBox = 'X';
        System.assertEquals('X', childObj.POBox);

        childObj.Language = 'X';
        System.assertEquals('X', childObj.Language);

        childObj.TelephoneNumber = 'X';
        System.assertEquals('X', childObj.TelephoneNumber);

        childObj.AddressNotes = 'X';
        System.assertEquals('X', childObj.AddressNotes);

        childObj.HouseNumber = 'X';
        System.assertEquals('X', childObj.HouseNumber);

        childObj.EMailAddress = 'X';
        System.assertEquals('X', childObj.EMailAddress);

        List<string> keyFields = new List<string>{ 'PARVW','PARVW_IN','PARVW_TEXT','COUNTER','KUNNR','LIFNR','PERNR','PARNR','NAME1','NAME2' };
    
        List<string> keys = childObj.getKeyFields();
        for(Integer i = 0; i < keys.size(); i++)
        {
            system.assertEquals(keyFields[i],keys[i]);
        }
    }
}