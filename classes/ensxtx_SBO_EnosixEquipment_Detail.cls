/// enosiX Inc. Generated Apex Model
/// Generated On: 11/14/2022 6:02:49 PM
/// SAP Host: From REST Service On: https://efficiency-force-3506-dev-ed.scratch.my.salesforce.com
/// CID: From REST Service On: https://efficiency-force-3506-dev-ed.scratch.my.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework ensxapp.v1.2

public with sharing class ensxtx_SBO_EnosixEquipment_Detail extends ensxsdk.EnosixFramework.DetailSBO
{
        static void registerReflectionInfo()
    {
        ensxsdk.EnosixFramework.registerReflectionResource('ensxtx_SBO_EnosixEquipment_Detail_Meta', new Type[] {
            ensxtx_SBO_EnosixEquipment_Detail.EnosixEquipment.class
            , ensxtx_SBO_EnosixEquipment_Detail.LOCATION.class
            , ensxtx_SBO_EnosixEquipment_Detail.ORGANIZATION.class
            , ensxtx_SBO_EnosixEquipment_Detail.STRUCTURE.class
            , ensxtx_SBO_EnosixEquipment_Detail.WARRANTY.class
            , ensxtx_SBO_EnosixEquipment_Detail.SALES.class
            , ensxtx_SBO_EnosixEquipment_Detail.SERDATA.class
            , ensxtx_SBO_EnosixEquipment_Detail.PARTNERS.class
            } 
        );
    }

    public ensxtx_SBO_EnosixEquipment_Detail()
    {
        super('EnosixEquipment', ensxtx_SBO_EnosixEquipment_Detail.EnosixEquipment.class);
    }

    public override Type getType() { return ensxtx_SBO_EnosixEquipment_Detail.class; }

    public EnosixEquipment initialize(EnosixEquipment obj)
    {
        return (EnosixEquipment)this.executeInitialize(obj);
    }
    
    public EnosixEquipment getDetail(object key)
    {
        return (EnosixEquipment)this.executeGetDetail(key);
    }
    
    public EnosixEquipment save(EnosixEquipment obj)
    {
        return (EnosixEquipment) this.executeSave(obj);
    }

    public EnosixEquipment command(string command, EnosixEquipment obj)
    {
        return (EnosixEquipment) this.executeCommand(command, obj);
    }
    
    public with sharing class EnosixEquipment extends ensxsdk.EnosixFramework.DetailObject
    {
        public EnosixEquipment()
        {
            super('HEADER', new Map<string,type>
                {
                    'LOCATION' => ensxtx_SBO_EnosixEquipment_Detail.LOCATION.class
                    ,'ORGANIZATION' => ensxtx_SBO_EnosixEquipment_Detail.ORGANIZATION.class
                    ,'STRUCTURE' => ensxtx_SBO_EnosixEquipment_Detail.STRUCTURE.class
                    ,'WARRANTY' => ensxtx_SBO_EnosixEquipment_Detail.WARRANTY.class
                    ,'SALES' => ensxtx_SBO_EnosixEquipment_Detail.SALES.class
                    ,'SERDATA' => ensxtx_SBO_EnosixEquipment_Detail.SERDATA.class
                    ,'PARTNERS' => ensxtx_SBO_EnosixEquipment_Detail.PARTNERS_COLLECTION.class
                });	
        }

        public override Type getType() { return ensxtx_SBO_EnosixEquipment_Detail.EnosixEquipment.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_EnosixEquipment_Detail.registerReflectionInfo();
        }

                @AuraEnabled public String EquipmentNumber
        {
            get { return this.getString ('EQUNR'); } 
            set { this.Set (value, 'EQUNR'); }
        }

        @AuraEnabled public String EquipmentNumberDescription
        {
            get { return this.getString ('EQKTX'); } 
            set { this.Set (value, 'EQKTX'); }
        }

        @AuraEnabled public String Equipmentcategory
        {
            get { return this.getString ('EQTYP'); } 
            set { this.Set (value, 'EQTYP'); }
        }

        @AuraEnabled public String EquipmentcategoryText
        {
            get { return this.getString ('TYPTX'); } 
            set { this.Set (value, 'TYPTX'); }
        }

        @AuraEnabled public String UserStatus
        {
            get { return this.getString ('ESTAT'); } 
            set { this.Set (value, 'ESTAT'); }
        }

        @AuraEnabled public String UserStatusText
        {
            get { return this.getString ('USER_STATUS'); } 
            set { this.Set (value, 'USER_STATUS'); }
        }

        @AuraEnabled public Date ValidFromDate
        {
            get { return this.getDate ('DATAB'); } 
            set { this.Set (value, 'DATAB'); }
        }

        @AuraEnabled public Date ValidToDate
        {
            get { return this.getDate ('DATBI'); } 
            set { this.Set (value, 'DATBI'); }
        }

        @AuraEnabled public String TechnicalObjectType
        {
            get { return this.getString ('EQART'); } 
            set { this.Set (value, 'EQART'); }
        }

        @AuraEnabled public String AuthorizationGroup
        {
            get { return this.getString ('BEGRU'); } 
            set { this.Set (value, 'BEGRU'); }
        }

        @AuraEnabled public Decimal GrossWeight
        {
            get { return this.getDecimal ('BRGEW'); } 
            set { this.Set (value, 'BRGEW'); }
        }

        @AuraEnabled public String WeightUnit
        {
            get { return this.getString ('GEWEI'); } 
            set { this.Set (value, 'GEWEI'); }
        }

        @AuraEnabled public String SizeDimensions
        {
            get { return this.getString ('GROES'); } 
            set { this.Set (value, 'GROES'); }
        }

        @AuraEnabled public String InventoryNumber
        {
            get { return this.getString ('INVNR'); } 
            set { this.Set (value, 'INVNR'); }
        }

        @AuraEnabled public Decimal AcquisitionValue
        {
            get { return this.getDecimal ('ANSWT'); } 
            set { this.Set (value, 'ANSWT'); }
        }

        @AuraEnabled public String CurrencyKey
        {
            get { return this.getString ('WAERS'); } 
            set { this.Set (value, 'WAERS'); }
        }

        @AuraEnabled public Date AcquisitionDate
        {
            get { return this.getDate ('ANSDT'); } 
            set { this.Set (value, 'ANSDT'); }
        }

        @AuraEnabled public String AssetManufacturer
        {
            get { return this.getString ('HERST'); } 
            set { this.Set (value, 'HERST'); }
        }

        @AuraEnabled public String ManufactureCountry
        {
            get { return this.getString ('HERLD'); } 
            set { this.Set (value, 'HERLD'); }
        }

        @AuraEnabled public String ManufacturerModelNumber
        {
            get { return this.getString ('TYPBZ'); } 
            set { this.Set (value, 'TYPBZ'); }
        }

        @AuraEnabled public String ConstructionYear
        {
            get { return this.getString ('BAUJJ'); } 
            set { this.Set (value, 'BAUJJ'); }
        }

        @AuraEnabled public String ConstructionMonth
        {
            get { return this.getString ('BAUMM'); } 
            set { this.Set (value, 'BAUMM'); }
        }

        @AuraEnabled public String ManufacturerPartNumber
        {
            get { return this.getString ('MAPAR'); } 
            set { this.Set (value, 'MAPAR'); }
        }

        @AuraEnabled public String ManufacturerSerialNumber
        {
            get { return this.getString ('SERGE'); } 
            set { this.Set (value, 'SERGE'); }
        }

        @AuraEnabled public String LongText
        {
            get { return this.getString ('LONGTEXT'); } 
            set { this.Set (value, 'LONGTEXT'); }
        }

        @AuraEnabled public String ObjectNumber
        {
            get { return this.getString ('OBJNR'); } 
            set { this.Set (value, 'OBJNR'); }
        }

        @AuraEnabled public ensxtx_SBO_EnosixEquipment_Detail.LOCATION LOCATION 
        {
            get
            {
                return (ensxtx_SBO_EnosixEquipment_Detail.LOCATION)this.getStruct(ensxtx_SBO_EnosixEquipment_Detail.LOCATION.class);
            }
        }
                @AuraEnabled public ensxtx_SBO_EnosixEquipment_Detail.ORGANIZATION ORGANIZATION 
        {
            get
            {
                return (ensxtx_SBO_EnosixEquipment_Detail.ORGANIZATION)this.getStruct(ensxtx_SBO_EnosixEquipment_Detail.ORGANIZATION.class);
            }
        }
                @AuraEnabled public ensxtx_SBO_EnosixEquipment_Detail.STRUCTURE STRUCTURE 
        {
            get
            {
                return (ensxtx_SBO_EnosixEquipment_Detail.STRUCTURE)this.getStruct(ensxtx_SBO_EnosixEquipment_Detail.STRUCTURE.class);
            }
        }
                @AuraEnabled public ensxtx_SBO_EnosixEquipment_Detail.WARRANTY WARRANTY 
        {
            get
            {
                return (ensxtx_SBO_EnosixEquipment_Detail.WARRANTY)this.getStruct(ensxtx_SBO_EnosixEquipment_Detail.WARRANTY.class);
            }
        }
                @AuraEnabled public ensxtx_SBO_EnosixEquipment_Detail.SALES SALES 
        {
            get
            {
                return (ensxtx_SBO_EnosixEquipment_Detail.SALES)this.getStruct(ensxtx_SBO_EnosixEquipment_Detail.SALES.class);
            }
        }
                @AuraEnabled public ensxtx_SBO_EnosixEquipment_Detail.SERDATA SERDATA 
        {
            get
            {
                return (ensxtx_SBO_EnosixEquipment_Detail.SERDATA)this.getStruct(ensxtx_SBO_EnosixEquipment_Detail.SERDATA.class);
            }
        }
                @AuraEnabled public PARTNERS_COLLECTION PARTNERS
        {
            get 
            { 
                return (PARTNERS_COLLECTION)this.getCollection(ensxtx_SBO_EnosixEquipment_Detail.PARTNERS_COLLECTION.class); 
            }
        }

            }

    //Write child objects
        public class LOCATION extends ensxsdk.EnosixFramework.ValueObject 
    {
        public override Type getType() { return ensxtx_SBO_EnosixEquipment_Detail.LOCATION.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_EnosixEquipment_Detail.registerReflectionInfo();
        }

        public override List<string> getKeyFields()
        {
            List<string> keyFields = new List<string>{ 'EnosixObjKey' };
    
            return keyFields;
        }

                @AuraEnabled public String MaintenancePlant
        {
            get { return this.getString ('SWERK'); } 
            set { this.Set (value, 'SWERK'); }
        }

        @AuraEnabled public String MaintenanceObjectLocation
        {
            get { return this.getString ('STORT'); } 
            set { this.Set (value, 'STORT'); }
        }

        @AuraEnabled public String Room
        {
            get { return this.getString ('MSGRP'); } 
            set { this.Set (value, 'MSGRP'); }
        }

        @AuraEnabled public String PlantSection
        {
            get { return this.getString ('BEBER'); } 
            set { this.Set (value, 'BEBER'); }
        }

        @AuraEnabled public String WorkCenter
        {
            get { return this.getString ('ARBPL'); } 
            set { this.Set (value, 'ARBPL'); }
        }

        @AuraEnabled public String TechnicalObjectABCindicator
        {
            get { return this.getString ('ABCKZ'); } 
            set { this.Set (value, 'ABCKZ'); }
        }

        @AuraEnabled public String SortField
        {
            get { return this.getString ('EQFNR'); } 
            set { this.Set (value, 'EQFNR'); }
        }

        @AuraEnabled public String CustomerName
        {
            get { return this.getString ('NAME1'); } 
            set { this.Set (value, 'NAME1'); }
        }

        @AuraEnabled public String Name2
        {
            get { return this.getString ('NAME2'); } 
            set { this.Set (value, 'NAME2'); }
        }

        @AuraEnabled public String Street
        {
            get { return this.getString ('STREET'); } 
            set { this.Set (value, 'STREET'); }
        }

        @AuraEnabled public String PostalCode
        {
            get { return this.getString ('POST_CODE1'); } 
            set { this.Set (value, 'POST_CODE1'); }
        }

        @AuraEnabled public String City
        {
            get { return this.getString ('CITY1'); } 
            set { this.Set (value, 'CITY1'); }
        }

        @AuraEnabled public String Country
        {
            get { return this.getString ('COUNTRY'); } 
            set { this.Set (value, 'COUNTRY'); }
        }

        @AuraEnabled public String Region
        {
            get { return this.getString ('REGION'); } 
            set { this.Set (value, 'REGION'); }
        }

        @AuraEnabled public String TelephoneNumber
        {
            get { return this.getString ('TEL_NUMBER'); } 
            set { this.Set (value, 'TEL_NUMBER'); }
        }

        @AuraEnabled public String FaxNumber
        {
            get { return this.getString ('FAX_NUMBER'); } 
            set { this.Set (value, 'FAX_NUMBER'); }
        }

    }
    public class ORGANIZATION extends ensxsdk.EnosixFramework.ValueObject 
    {
        public override Type getType() { return ensxtx_SBO_EnosixEquipment_Detail.ORGANIZATION.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_EnosixEquipment_Detail.registerReflectionInfo();
        }

        public override List<string> getKeyFields()
        {
            List<string> keyFields = new List<string>{ 'EnosixObjKey' };
    
            return keyFields;
        }

                @AuraEnabled public String CompanyCode
        {
            get { return this.getString ('BUKRS'); } 
            set { this.Set (value, 'BUKRS'); }
        }

        @AuraEnabled public String BusinessArea
        {
            get { return this.getString ('GSBER'); } 
            set { this.Set (value, 'GSBER'); }
        }

        @AuraEnabled public String AssetNumber
        {
            get { return this.getString ('ANLNR'); } 
            set { this.Set (value, 'ANLNR'); }
        }

        @AuraEnabled public String AssetSubnumber
        {
            get { return this.getString ('ANLUN'); } 
            set { this.Set (value, 'ANLUN'); }
        }

        @AuraEnabled public String CostCenter
        {
            get { return this.getString ('KOSTL'); } 
            set { this.Set (value, 'KOSTL'); }
        }

        @AuraEnabled public String ControllingArea
        {
            get { return this.getString ('KOKRS'); } 
            set { this.Set (value, 'KOKRS'); }
        }

        @AuraEnabled public String WBSElement
        {
            get { return this.getString ('PROID'); } 
            set { this.Set (value, 'PROID'); }
        }

        @AuraEnabled public String StandingOrderNumber
        {
            get { return this.getString ('DAUFN'); } 
            set { this.Set (value, 'DAUFN'); }
        }

        @AuraEnabled public String SettlementOrder
        {
            get { return this.getString ('AUFNR'); } 
            set { this.Set (value, 'AUFNR'); }
        }

        @AuraEnabled public String PlanningPlant
        {
            get { return this.getString ('IWERK'); } 
            set { this.Set (value, 'IWERK'); }
        }

        @AuraEnabled public String PlannerGroup
        {
            get { return this.getString ('INGRP'); } 
            set { this.Set (value, 'INGRP'); }
        }

        @AuraEnabled public String MainWorkCenter
        {
            get { return this.getString ('GEWRK'); } 
            set { this.Set (value, 'GEWRK'); }
        }

        @AuraEnabled public String MainWorkCenterPlant
        {
            get { return this.getString ('WERGW'); } 
            set { this.Set (value, 'WERGW'); }
        }

        @AuraEnabled public String CatalogProfile
        {
            get { return this.getString ('RBNR'); } 
            set { this.Set (value, 'RBNR'); }
        }

    }
    public class STRUCTURE extends ensxsdk.EnosixFramework.ValueObject 
    {
        public override Type getType() { return ensxtx_SBO_EnosixEquipment_Detail.STRUCTURE.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_EnosixEquipment_Detail.registerReflectionInfo();
        }

        public override List<string> getKeyFields()
        {
            List<string> keyFields = new List<string>{ 'EnosixObjKey' };
    
            return keyFields;
        }

                @AuraEnabled public String FunctionalLocation
        {
            get { return this.getString ('TPLNR'); } 
            set { this.Set (value, 'TPLNR'); }
        }

        @AuraEnabled public String FunctionalLocationDescription
        {
            get { return this.getString ('TXT_TPLNR'); } 
            set { this.Set (value, 'TXT_TPLNR'); }
        }

        @AuraEnabled public String SuperordEquipment
        {
            get { return this.getString ('HEQUI'); } 
            set { this.Set (value, 'HEQUI'); }
        }

        @AuraEnabled public String SuperordEquipmentDescription
        {
            get { return this.getString ('TXT_HEQUI'); } 
            set { this.Set (value, 'TXT_HEQUI'); }
        }

        @AuraEnabled public String HEQNR
        {
            get { return this.getString ('HEQNR'); } 
            set { this.Set (value, 'HEQNR'); }
        }

        @AuraEnabled public String TechIdentNo
        {
            get { return this.getString ('TIDNR'); } 
            set { this.Set (value, 'TIDNR'); }
        }

        @AuraEnabled public String ConstType
        {
            get { return this.getString ('SUBMT'); } 
            set { this.Set (value, 'SUBMT'); }
        }

    }
    public class WARRANTY extends ensxsdk.EnosixFramework.ValueObject 
    {
        public override Type getType() { return ensxtx_SBO_EnosixEquipment_Detail.WARRANTY.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_EnosixEquipment_Detail.registerReflectionInfo();
        }

        public override List<string> getKeyFields()
        {
            List<string> keyFields = new List<string>{ 'EnosixObjKey' };
    
            return keyFields;
        }

                @AuraEnabled public Date CustomerWarrantyStartDate
        {
            get { return this.getDate ('CUSTOMER_GWLDT'); } 
            set { this.Set (value, 'CUSTOMER_GWLDT'); }
        }

        @AuraEnabled public Date CustomerWarrantyEndDate
        {
            get { return this.getDate ('CUSTOMER_GWLEN'); } 
            set { this.Set (value, 'CUSTOMER_GWLEN'); }
        }

        @AuraEnabled public String CustomerMasterWarranty
        {
            get { return this.getString ('CUSTOMER_MGANR'); } 
            set { this.Set (value, 'CUSTOMER_MGANR'); }
        }

        @AuraEnabled public Date ManufacturerWarrantyStartDate
        {
            get { return this.getDate ('MANUFAC_GWLDT'); } 
            set { this.Set (value, 'MANUFAC_GWLDT'); }
        }

        @AuraEnabled public Date ManufacturerWarrantyEndDate
        {
            get { return this.getDate ('MANUFAC_GWLEN'); } 
            set { this.Set (value, 'MANUFAC_GWLEN'); }
        }

        @AuraEnabled public String ManufacturerMasterWarranty
        {
            get { return this.getString ('MANUFAC_MGANR'); } 
            set { this.Set (value, 'MANUFAC_MGANR'); }
        }

    }
    public class SALES extends ensxsdk.EnosixFramework.ValueObject 
    {
        public override Type getType() { return ensxtx_SBO_EnosixEquipment_Detail.SALES.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_EnosixEquipment_Detail.registerReflectionInfo();
        }

        public override List<string> getKeyFields()
        {
            List<string> keyFields = new List<string>{ 'EnosixObjKey' };
    
            return keyFields;
        }

                @AuraEnabled public String SalesOrganization
        {
            get { return this.getString ('VKORG'); } 
            set { this.Set (value, 'VKORG'); }
        }

        @AuraEnabled public String SalesOrganizationText
        {
            get { return this.getString ('VKTXT'); } 
            set { this.Set (value, 'VKTXT'); }
        }

        @AuraEnabled public String DistributionChannel
        {
            get { return this.getString ('VTWEG'); } 
            set { this.Set (value, 'VTWEG'); }
        }

        @AuraEnabled public String DistributionChannelText
        {
            get { return this.getString ('VTTXT'); } 
            set { this.Set (value, 'VTTXT'); }
        }

        @AuraEnabled public String Division
        {
            get { return this.getString ('SPART'); } 
            set { this.Set (value, 'SPART'); }
        }

        @AuraEnabled public String DivisionText
        {
            get { return this.getString ('SPTXT'); } 
            set { this.Set (value, 'SPTXT'); }
        }

        @AuraEnabled public String SalesOffice
        {
            get { return this.getString ('VKBUR'); } 
            set { this.Set (value, 'VKBUR'); }
        }

        @AuraEnabled public String SalesOfficeText
        {
            get { return this.getString ('VKBUR_TXT'); } 
            set { this.Set (value, 'VKBUR_TXT'); }
        }

        @AuraEnabled public String SalesGroup
        {
            get { return this.getString ('VKGRP'); } 
            set { this.Set (value, 'VKGRP'); }
        }

        @AuraEnabled public String SalesGroupText
        {
            get { return this.getString ('VKGRP_TXT'); } 
            set { this.Set (value, 'VKGRP_TXT'); }
        }

        @AuraEnabled public String LicenseNumber
        {
            get { return this.getString ('LIZNR'); } 
            set { this.Set (value, 'LIZNR'); }
        }

        @AuraEnabled public String SoldTo
        {
            get { return this.getString ('SOLDTO_PARNR'); } 
            set { this.Set (value, 'SOLDTO_PARNR'); }
        }

        @AuraEnabled public String ShipTo
        {
            get { return this.getString ('SHIPTO_PARNR'); } 
            set { this.Set (value, 'SHIPTO_PARNR'); }
        }

    }
    public class SERDATA extends ensxsdk.EnosixFramework.ValueObject 
    {
        public override Type getType() { return ensxtx_SBO_EnosixEquipment_Detail.SERDATA.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_EnosixEquipment_Detail.registerReflectionInfo();
        }

        public override List<string> getKeyFields()
        {
            List<string> keyFields = new List<string>{ 'EnosixObjKey' };
    
            return keyFields;
        }

                @AuraEnabled public String Material
        {
            get { return this.getString ('MATNR'); } 
            set { this.Set (value, 'MATNR'); }
        }

        @AuraEnabled public String MaterialDescription
        {
            get { return this.getString ('MAKTX'); } 
            set { this.Set (value, 'MAKTX'); }
        }

        @AuraEnabled public String SerialNumber
        {
            get { return this.getString ('SERNR'); } 
            set { this.Set (value, 'SERNR'); }
        }

        @AuraEnabled public String LastSerialNo
        {
            get { return this.getString ('LSERNR'); } 
            set { this.Set (value, 'LSERNR'); }
        }

        @AuraEnabled public String StockType
        {
            get { return this.getString ('LBBSA'); } 
            set { this.Set (value, 'LBBSA'); }
        }

        @AuraEnabled public String Plant
        {
            get { return this.getString ('B_WERK'); } 
            set { this.Set (value, 'B_WERK'); }
        }

        @AuraEnabled public String CompanyCode
        {
            get { return this.getString ('BUKRS'); } 
            set { this.Set (value, 'BUKRS'); }
        }

        @AuraEnabled public String StorageLocation
        {
            get { return this.getString ('B_LAGER'); } 
            set { this.Set (value, 'B_LAGER'); }
        }

        @AuraEnabled public String StockBatch
        {
            get { return this.getString ('B_CHARGE'); } 
            set { this.Set (value, 'B_CHARGE'); }
        }

        @AuraEnabled public String MasterBatch
        {
            get { return this.getString ('CHARGE'); } 
            set { this.Set (value, 'CHARGE'); }
        }

        @AuraEnabled public String SpecialStockInd
        {
            get { return this.getString ('SOBKZ'); } 
            set { this.Set (value, 'SOBKZ'); }
        }

        @AuraEnabled public Date LastGoodsMvtDate
        {
            get { return this.getDate ('DATLWB'); } 
            set { this.Set (value, 'DATLWB'); }
        }

        @AuraEnabled public String CustomerNumber
        {
            get { return this.getString ('KUNNR'); } 
            set { this.Set (value, 'KUNNR'); }
        }

        @AuraEnabled public String Vendor
        {
            get { return this.getString ('LIFNR'); } 
            set { this.Set (value, 'LIFNR'); }
        }

        @AuraEnabled public String SalesDocument
        {
            get { return this.getString ('KDAUF'); } 
            set { this.Set (value, 'KDAUF'); }
        }

        @AuraEnabled public String SalesDocumentItem
        {
            get { return this.getString ('KDPOS'); } 
            set { this.Set (value, 'KDPOS'); }
        }

        @AuraEnabled public String WBSElementInternal
        {
            get { return this.getString ('PS_PSP_PNR'); } 
            set { this.Set (value, 'PS_PSP_PNR'); }
        }

        @AuraEnabled public String ShipTo
        {
            get { return this.getString ('SHIPTO_PARNR'); } 
            set { this.Set (value, 'SHIPTO_PARNR'); }
        }

    }
    public class PARTNERS extends ensxsdk.EnosixFramework.ValueObject 
    {
        public override Type getType() { return ensxtx_SBO_EnosixEquipment_Detail.PARTNERS.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_EnosixEquipment_Detail.registerReflectionInfo();
        }

        public override List<string> getKeyFields()
        {
            List<string> keyFields = new List<string>{ 'PARVW','PARVW_IN','PARVW_TEXT','COUNTER','KUNNR','LIFNR','PERNR','PARNR','NAME1','NAME2' };
    
            return keyFields;
        }

                @AuraEnabled public String PartnerFunction
        {
            get { return this.getString ('PARVW'); } 
            set { this.Set (value, 'PARVW'); }
        }

        @AuraEnabled public String PARVW_IN
        {
            get { return this.getString ('PARVW_IN'); } 
            set { this.Set (value, 'PARVW_IN'); }
        }

        @AuraEnabled public String PartnerFunctionDescription
        {
            get { return this.getString ('PARVW_TEXT'); } 
            set { this.Set (value, 'PARVW_TEXT'); }
        }

        @AuraEnabled public String Counter
        {
            get { return this.getString ('COUNTER'); } 
            set { this.Set (value, 'COUNTER'); }
        }

        @AuraEnabled public String CustomerNumber
        {
            get { return this.getString ('KUNNR'); } 
            set { this.Set (value, 'KUNNR'); }
        }

        @AuraEnabled public String Vendor
        {
            get { return this.getString ('LIFNR'); } 
            set { this.Set (value, 'LIFNR'); }
        }

        @AuraEnabled public String PersonnelNumber
        {
            get { return this.getString ('PERNR'); } 
            set { this.Set (value, 'PERNR'); }
        }

        @AuraEnabled public String ContactPersonNumber
        {
            get { return this.getString ('PARNR'); } 
            set { this.Set (value, 'PARNR'); }
        }

        @AuraEnabled public String CustomerName
        {
            get { return this.getString ('NAME1'); } 
            set { this.Set (value, 'NAME1'); }
        }

        @AuraEnabled public String PartnerName2
        {
            get { return this.getString ('NAME2'); } 
            set { this.Set (value, 'NAME2'); }
        }

        @AuraEnabled public String Name3
        {
            get { return this.getString ('NAME3'); } 
            set { this.Set (value, 'NAME3'); }
        }

        @AuraEnabled public String Name4
        {
            get { return this.getString ('NAME4'); } 
            set { this.Set (value, 'NAME4'); }
        }

        @AuraEnabled public String City
        {
            get { return this.getString ('CITY1'); } 
            set { this.Set (value, 'CITY1'); }
        }

        @AuraEnabled public String District
        {
            get { return this.getString ('CITY2'); } 
            set { this.Set (value, 'CITY2'); }
        }

        @AuraEnabled public String PostalCode
        {
            get { return this.getString ('POST_CODE1'); } 
            set { this.Set (value, 'POST_CODE1'); }
        }

        @AuraEnabled public String POBoxPostalCode
        {
            get { return this.getString ('POST_CODE2'); } 
            set { this.Set (value, 'POST_CODE2'); }
        }

        @AuraEnabled public String Country
        {
            get { return this.getString ('COUNTRY'); } 
            set { this.Set (value, 'COUNTRY'); }
        }

        @AuraEnabled public String Region
        {
            get { return this.getString ('REGION'); } 
            set { this.Set (value, 'REGION'); }
        }

        @AuraEnabled public String Street
        {
            get { return this.getString ('STREET'); } 
            set { this.Set (value, 'STREET'); }
        }

        @AuraEnabled public String POBox
        {
            get { return this.getString ('PO_BOX'); } 
            set { this.Set (value, 'PO_BOX'); }
        }

        @AuraEnabled public String Language
        {
            get { return this.getString ('LANGU'); } 
            set { this.Set (value, 'LANGU'); }
        }

        @AuraEnabled public String TelephoneNumber
        {
            get { return this.getString ('TEL_NUMBER'); } 
            set { this.Set (value, 'TEL_NUMBER'); }
        }

        @AuraEnabled public String AddressNotes
        {
            get { return this.getString ('REMARK'); } 
            set { this.Set (value, 'REMARK'); }
        }

        @AuraEnabled public String HouseNumber
        {
            get { return this.getString ('HOUSE_NUM1'); } 
            set { this.Set (value, 'HOUSE_NUM1'); }
        }

        @AuraEnabled public String EMailAddress
        {
            get { return this.getString ('SMTP_ADDR'); } 
            set { this.Set (value, 'SMTP_ADDR'); }
        }

    }
    public class PARTNERS_COLLECTION extends ensxsdk.EnosixFramework.FrameworkCollection
    {
        public PARTNERS_COLLECTION()
        {
            super('PARTNERS', ensxtx_SBO_EnosixEquipment_Detail.PARTNERS.class, null);
        }

        @AuraEnabled public List<ensxtx_SBO_EnosixEquipment_Detail.PARTNERS> getAsList()
        {
            return (List<ensxtx_SBO_EnosixEquipment_Detail.PARTNERS>)this.buildList(List<ensxtx_SBO_EnosixEquipment_Detail.PARTNERS>.class);
        }
    }
}