/// enosiX Inc. Generated Apex Model
/// Generated On: 5/16/2024 8:31:49 PM
/// SAP Host: From REST Service On: https://savvas--dev3.sandbox.my.salesforce.com
/// CID: From REST Service On: https://savvas--dev3.sandbox.my.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework ensxapp.v1.2

global with sharing class ensxtx_SBO_SFCIDelivery_Detail extends ensxsdk.EnosixFramework.DetailSBO
{
        static void registerReflectionInfo()
    {
        ensxsdk.EnosixFramework.registerReflectionResource('ensxtx_SBO_SFCIDelivery_Detail_Meta', new Type[] {
            ensxtx_SBO_SFCIDelivery_Detail.SFCIDelivery.class
            , ensxtx_SBO_SFCIDelivery_Detail.PARTNERS.class
            , ensxtx_SBO_SFCIDelivery_Detail.CUSTOMER.class
            , ensxtx_SBO_SFCIDelivery_Detail.ITEMS.class
            , ensxtx_SBO_SFCIDelivery_Detail.HU.class
            , ensxtx_SBO_SFCIDelivery_Detail.HU_ITEMS.class
            , ensxtx_SBO_SFCIDelivery_Detail.HEADER_TEXTS.class
            , ensxtx_SBO_SFCIDelivery_Detail.ITEMS_TEXT.class
            , ensxtx_SBO_SFCIDelivery_Detail.USER_DEFINED.class
            , ensxtx_SBO_SFCIDelivery_Detail.ITEM_USER_DEFINED.class
            } 
        );
    }

    global ensxtx_SBO_SFCIDelivery_Detail()
    {
        super('SFCIDelivery', ensxtx_SBO_SFCIDelivery_Detail.SFCIDelivery.class);
    }

    public override Type getType() { return ensxtx_SBO_SFCIDelivery_Detail.class; }

    public SFCIDelivery initialize(SFCIDelivery obj)
    {
        return (SFCIDelivery)this.executeInitialize(obj);
    }
    
    public SFCIDelivery getDetail(object key)
    {
        return (SFCIDelivery)this.executeGetDetail(key);
    }
    
    public SFCIDelivery save(SFCIDelivery obj)
    {
        return (SFCIDelivery) this.executeSave(obj);
    }

    public SFCIDelivery command(string command, SFCIDelivery obj)
    {
        return (SFCIDelivery) this.executeCommand(command, obj);
    }
    
    global with sharing class SFCIDelivery extends ensxsdk.EnosixFramework.DetailObject
    {
        global SFCIDelivery()
        {
            super('HEADER', new Map<string,type>
                {
                    'PARTNERS' => ensxtx_SBO_SFCIDelivery_Detail.PARTNERS_COLLECTION.class
                    ,'CUSTOMER' => ensxtx_SBO_SFCIDelivery_Detail.CUSTOMER.class
                    ,'ITEMS' => ensxtx_SBO_SFCIDelivery_Detail.ITEMS_COLLECTION.class
                    ,'HU' => ensxtx_SBO_SFCIDelivery_Detail.HU_COLLECTION.class
                    ,'HU_ITEMS' => ensxtx_SBO_SFCIDelivery_Detail.HU_ITEMS_COLLECTION.class
                    ,'HEADER_TEXTS' => ensxtx_SBO_SFCIDelivery_Detail.HEADER_TEXTS_COLLECTION.class
                    ,'ITEMS_TEXT' => ensxtx_SBO_SFCIDelivery_Detail.ITEMS_TEXT_COLLECTION.class
                    ,'USER_DEFINED' => ensxtx_SBO_SFCIDelivery_Detail.USER_DEFINED_COLLECTION.class
                    ,'ITEM_USER_DEFINED' => ensxtx_SBO_SFCIDelivery_Detail.ITEM_USER_DEFINED_COLLECTION.class
                });	
        }

        public override Type getType() { return ensxtx_SBO_SFCIDelivery_Detail.SFCIDelivery.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCIDelivery_Detail.registerReflectionInfo();
        }

                @AuraEnabled public String Delivery
        {
            get { return this.getString ('VBELN'); } 
            set { this.Set (value, 'VBELN'); }
        }

        @AuraEnabled public String MeansOfTransportID
        {
            get { return this.getString ('TRAID'); } 
            set { this.Set (value, 'TRAID'); }
        }

        @AuraEnabled public String ShippingPoint
        {
            get { return this.getString ('VSTEL'); } 
            set { this.Set (value, 'VSTEL'); }
        }

        @AuraEnabled public String ShippingPointDescription
        {
            get { return this.getString ('VSTEL_VTEXT'); } 
            set { this.Set (value, 'VSTEL_VTEXT'); }
        }

        @AuraEnabled public String LoadingPoint
        {
            get { return this.getString ('LSTEL'); } 
            set { this.Set (value, 'LSTEL'); }
        }

        @AuraEnabled public String LoadingPointText
        {
            get { return this.getString ('LSTEL_VTEXT'); } 
            set { this.Set (value, 'LSTEL_VTEXT'); }
        }

        @AuraEnabled public String UnloadingPoint
        {
            get { return this.getString ('ABLAD'); } 
            set { this.Set (value, 'ABLAD'); }
        }

        @AuraEnabled public String Route
        {
            get { return this.getString ('ROUTE'); } 
            set { this.Set (value, 'ROUTE'); }
        }

        @AuraEnabled public String RouteText
        {
            get { return this.getString ('ROUTE_TEXT'); } 
            set { this.Set (value, 'ROUTE_TEXT'); }
        }

        @AuraEnabled public String BillofLading
        {
            get { return this.getString ('BOLNR'); } 
            set { this.Set (value, 'BOLNR'); }
        }

        @AuraEnabled public Date CreateDate
        {
            get { return this.getDate ('ERDAT'); } 
            set { this.Set (value, 'ERDAT'); }
        }

        @AuraEnabled public Date DeliveryDate
        {
            get { return this.getDate ('LFDAT'); } 
            set { this.Set (value, 'LFDAT'); }
        }

        @AuraEnabled public Date PGIDate
        {
            get { return this.getDate ('WADAT_IST'); } 
            set { this.Set (value, 'WADAT_IST'); }
        }

        @AuraEnabled public String DeliveryType
        {
            get { return this.getString ('LFART'); } 
            set { this.Set (value, 'LFART'); }
        }

        @AuraEnabled public String DeliveryTypeText
        {
            get { return this.getString ('LFART_TEXT'); } 
            set { this.Set (value, 'LFART_TEXT'); }
        }

        @AuraEnabled public String SoldToParty
        {
            get { return this.getString ('KUNAG'); } 
            set { this.Set (value, 'KUNAG'); }
        }

        @AuraEnabled public String SoldToPartyText
        {
            get { return this.getString ('KUNAG_TXTPA'); } 
            set { this.Set (value, 'KUNAG_TXTPA'); }
        }

        @AuraEnabled public String ShipToParty
        {
            get { return this.getString ('KUNWE'); } 
            set { this.Set (value, 'KUNWE'); }
        }

        @AuraEnabled public String ShipToPartyText
        {
            get { return this.getString ('KUNWE_TXTPA'); } 
            set { this.Set (value, 'KUNWE_TXTPA'); }
        }

        @AuraEnabled public String ShippingConditions
        {
            get { return this.getString ('VSBED'); } 
            set { this.Set (value, 'VSBED'); }
        }

        @AuraEnabled public String ShipConditionText
        {
            get { return this.getString ('VSBED_TEXT'); } 
            set { this.Set (value, 'VSBED_TEXT'); }
        }

        @AuraEnabled public String DeliveryPriority
        {
            get { return this.getString ('LPRIO'); } 
            set { this.Set (value, 'LPRIO'); }
        }

        @AuraEnabled public String DeliveryPriorityText
        {
            get { return this.getString ('LPRIO_TEXT'); } 
            set { this.Set (value, 'LPRIO_TEXT'); }
        }

        @AuraEnabled public Decimal NetOrderValue
        {
            get { return this.getDecimal ('NETWR'); } 
            set { this.Set (value, 'NETWR'); }
        }

        @AuraEnabled public String SalesDocumentCurrency
        {
            get { return this.getString ('WAERK'); } 
            set { this.Set (value, 'WAERK'); }
        }

        @AuraEnabled public String DeliveryBlock
        {
            get { return this.getString ('LIFSK'); } 
            set { this.Set (value, 'LIFSK'); }
        }

        @AuraEnabled public String DeliveryStatus
        {
            get { return this.getString ('DELV_STAT'); } 
            set { this.Set (value, 'DELV_STAT'); }
        }

        @AuraEnabled public Integer DecimalPlaces
        {
            get { return this.getInteger ('DECIMAL_PLACES'); } 
            set { this.Set (value, 'DECIMAL_PLACES'); }
        }

        @AuraEnabled public String CarrierName
        {
            get { return this.getString ('LIFEX'); } 
            set { this.Set (value, 'LIFEX'); }
        }

        @AuraEnabled public String Carton
        {
            get { return this.getString ('ANZPK'); } 
            set { this.Set (value, 'ANZPK'); }
        }

        @AuraEnabled public Decimal ExtWeight
        {
            get { return this.getDecimal ('BTGEW'); } 
            set { this.Set (value, 'BTGEW'); }
        }

        @AuraEnabled public String FreightTerms
        {
            get { return this.getString ('INCO1'); } 
            set { this.Set (value, 'INCO1'); }
        }

        @AuraEnabled public Decimal NetWeight
        {
            get { return this.getDecimal ('NTGEW'); } 
            set { this.Set (value, 'NTGEW'); }
        }

        @AuraEnabled public PARTNERS_COLLECTION PARTNERS
        {
            get 
            { 
                return (PARTNERS_COLLECTION)this.getCollection(ensxtx_SBO_SFCIDelivery_Detail.PARTNERS_COLLECTION.class); 
            }
        }

                @AuraEnabled public ensxtx_SBO_SFCIDelivery_Detail.CUSTOMER CUSTOMER 
        {
            get
            {
                return (ensxtx_SBO_SFCIDelivery_Detail.CUSTOMER)this.getStruct(ensxtx_SBO_SFCIDelivery_Detail.CUSTOMER.class);
            }
        }
                @AuraEnabled public ITEMS_COLLECTION ITEMS
        {
            get 
            { 
                return (ITEMS_COLLECTION)this.getCollection(ensxtx_SBO_SFCIDelivery_Detail.ITEMS_COLLECTION.class); 
            }
        }

                @AuraEnabled public HU_COLLECTION HU
        {
            get 
            { 
                return (HU_COLLECTION)this.getCollection(ensxtx_SBO_SFCIDelivery_Detail.HU_COLLECTION.class); 
            }
        }

                @AuraEnabled public HU_ITEMS_COLLECTION HU_ITEMS
        {
            get 
            { 
                return (HU_ITEMS_COLLECTION)this.getCollection(ensxtx_SBO_SFCIDelivery_Detail.HU_ITEMS_COLLECTION.class); 
            }
        }

                @AuraEnabled public HEADER_TEXTS_COLLECTION HEADER_TEXTS
        {
            get 
            { 
                return (HEADER_TEXTS_COLLECTION)this.getCollection(ensxtx_SBO_SFCIDelivery_Detail.HEADER_TEXTS_COLLECTION.class); 
            }
        }

                @AuraEnabled public ITEMS_TEXT_COLLECTION ITEMS_TEXT
        {
            get 
            { 
                return (ITEMS_TEXT_COLLECTION)this.getCollection(ensxtx_SBO_SFCIDelivery_Detail.ITEMS_TEXT_COLLECTION.class); 
            }
        }

                @AuraEnabled public USER_DEFINED_COLLECTION USER_DEFINED
        {
            get 
            { 
                return (USER_DEFINED_COLLECTION)this.getCollection(ensxtx_SBO_SFCIDelivery_Detail.USER_DEFINED_COLLECTION.class); 
            }
        }

                @AuraEnabled public ITEM_USER_DEFINED_COLLECTION ITEM_USER_DEFINED
        {
            get 
            { 
                return (ITEM_USER_DEFINED_COLLECTION)this.getCollection(ensxtx_SBO_SFCIDelivery_Detail.ITEM_USER_DEFINED_COLLECTION.class); 
            }
        }

            }

    //Write child objects
        global class PARTNERS extends ensxsdk.EnosixFramework.ValueObject 
    {
        global PARTNERS() { super(); }
        public override Type getType() { return ensxtx_SBO_SFCIDelivery_Detail.PARTNERS.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCIDelivery_Detail.registerReflectionInfo();
        }

        public override List<string> getKeyFields()
        {
            List<string> keyFields = new List<string>{ 'EnosixObjKey','iindex' };
    
            return keyFields;
        }

                @AuraEnabled public String PartnerFunction
        {
            get { return this.getString ('PARVW'); } 
            set { this.Set (value, 'PARVW'); }
        }

        @AuraEnabled public String PartnerFunctionName
        {
            get { return this.getString ('PARVW_VTEXT'); } 
            set { this.Set (value, 'PARVW_VTEXT'); }
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

        @AuraEnabled public String PartnerName
        {
            get { return this.getString ('NAME1'); } 
            set { this.Set (value, 'NAME1'); }
        }

        @AuraEnabled public String PartnerName2
        {
            get { return this.getString ('NAME2'); } 
            set { this.Set (value, 'NAME2'); }
        }

        @AuraEnabled public String HouseNumber
        {
            get { return this.getString ('HOUSE_NUM1'); } 
            set { this.Set (value, 'HOUSE_NUM1'); }
        }

        @AuraEnabled public String Street
        {
            get { return this.getString ('STREET'); } 
            set { this.Set (value, 'STREET'); }
        }

        @AuraEnabled public String City
        {
            get { return this.getString ('CITY1'); } 
            set { this.Set (value, 'CITY1'); }
        }

        @AuraEnabled public String PostalCode
        {
            get { return this.getString ('POST_CODE1'); } 
            set { this.Set (value, 'POST_CODE1'); }
        }

        @AuraEnabled public String Region
        {
            get { return this.getString ('REGION'); } 
            set { this.Set (value, 'REGION'); }
        }

        @AuraEnabled public String RegionDescription
        {
            get { return this.getString ('REGIO_BEZEI'); } 
            set { this.Set (value, 'REGIO_BEZEI'); }
        }

        @AuraEnabled public String Country
        {
            get { return this.getString ('COUNTRY'); } 
            set { this.Set (value, 'COUNTRY'); }
        }

        @AuraEnabled public String CountryName
        {
            get { return this.getString ('COUNTRY_LANDX'); } 
            set { this.Set (value, 'COUNTRY_LANDX'); }
        }

        @AuraEnabled public String TimeZone
        {
            get { return this.getString ('TIME_ZONE'); } 
            set { this.Set (value, 'TIME_ZONE'); }
        }

        @AuraEnabled public String TimeZoneText
        {
            get { return this.getString ('TIME_ZONE_TEXT'); } 
            set { this.Set (value, 'TIME_ZONE_TEXT'); }
        }

        @AuraEnabled public String TransportationZone
        {
            get { return this.getString ('TRANSPZONE'); } 
            set { this.Set (value, 'TRANSPZONE'); }
        }

        @AuraEnabled public String TransportationZoneDescription
        {
            get { return this.getString ('TRANSPZONE_VTEXT'); } 
            set { this.Set (value, 'TRANSPZONE_VTEXT'); }
        }

        @AuraEnabled public String POBox
        {
            get { return this.getString ('PO_BOX'); } 
            set { this.Set (value, 'PO_BOX'); }
        }

        @AuraEnabled public String POBoxPostalCode
        {
            get { return this.getString ('POST_CODE2'); } 
            set { this.Set (value, 'POST_CODE2'); }
        }

        @AuraEnabled public String CompanyPostalCode
        {
            get { return this.getString ('POST_CODE3'); } 
            set { this.Set (value, 'POST_CODE3'); }
        }

        @AuraEnabled public String Language
        {
            get { return this.getString ('LANGU'); } 
            set { this.Set (value, 'LANGU'); }
        }

        @AuraEnabled public String LanguageDesc
        {
            get { return this.getString ('LANGU_SPTXT'); } 
            set { this.Set (value, 'LANGU_SPTXT'); }
        }

        @AuraEnabled public String TelephoneNumber
        {
            get { return this.getString ('TEL_NUMBER'); } 
            set { this.Set (value, 'TEL_NUMBER'); }
        }

        @AuraEnabled public String TelephoneNumberExtension
        {
            get { return this.getString ('TEL_EXTENS'); } 
            set { this.Set (value, 'TEL_EXTENS'); }
        }

        @AuraEnabled public String MobileNumber
        {
            get { return this.getString ('MOB_NUMBER'); } 
            set { this.Set (value, 'MOB_NUMBER'); }
        }

        @AuraEnabled public String FaxNumber
        {
            get { return this.getString ('FAX_NUMBER'); } 
            set { this.Set (value, 'FAX_NUMBER'); }
        }

        @AuraEnabled public String FaxNumberExtension
        {
            get { return this.getString ('FAX_EXTENS'); } 
            set { this.Set (value, 'FAX_EXTENS'); }
        }

        @AuraEnabled public String EMailAddress
        {
            get { return this.getString ('SMTP_ADDR'); } 
            set { this.Set (value, 'SMTP_ADDR'); }
        }

        @AuraEnabled public String DefaultCommunicationMethod
        {
            get { return this.getString ('DEFLT_COMM'); } 
            set { this.Set (value, 'DEFLT_COMM'); }
        }

        @AuraEnabled public String DefaultCommunicationMethodDescription
        {
            get { return this.getString ('DEFLT_COMM_TEXT'); } 
            set { this.Set (value, 'DEFLT_COMM_TEXT'); }
        }

        @AuraEnabled public String Extension1
        {
            get { return this.getString ('EXTENSION1'); } 
            set { this.Set (value, 'EXTENSION1'); }
        }

        @AuraEnabled public String Extension2
        {
            get { return this.getString ('EXTENSION2'); } 
            set { this.Set (value, 'EXTENSION2'); }
        }

        @AuraEnabled public String AddressNotes
        {
            get { return this.getString ('REMARK'); } 
            set { this.Set (value, 'REMARK'); }
        }

    }
    global class PARTNERS_COLLECTION extends ensxsdk.EnosixFramework.FrameworkCollection
    {
        global PARTNERS_COLLECTION()
        {
            super('PARTNERS', ensxtx_SBO_SFCIDelivery_Detail.PARTNERS.class, null);
        }

        @AuraEnabled public List<ensxtx_SBO_SFCIDelivery_Detail.PARTNERS> getAsList()
        {
            return (List<ensxtx_SBO_SFCIDelivery_Detail.PARTNERS>)this.buildList(List<ensxtx_SBO_SFCIDelivery_Detail.PARTNERS>.class);
        }
    }
    global class CUSTOMER extends ensxsdk.EnosixFramework.ValueObject 
    {
        global CUSTOMER() { super(); }
        public override Type getType() { return ensxtx_SBO_SFCIDelivery_Detail.CUSTOMER.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCIDelivery_Detail.registerReflectionInfo();
        }

        public override List<string> getKeyFields()
        {
            List<string> keyFields = new List<string>{ 'EnosixObjKey','iindex' };
    
            return keyFields;
        }

                @AuraEnabled public String ShipToParty
        {
            get { return this.getString ('KUNWE'); } 
            set { this.Set (value, 'KUNWE'); }
        }

        @AuraEnabled public String Name
        {
            get { return this.getString ('NAME1'); } 
            set { this.Set (value, 'NAME1'); }
        }

        @AuraEnabled public String HouseNumber
        {
            get { return this.getString ('HOUSE_NUM1'); } 
            set { this.Set (value, 'HOUSE_NUM1'); }
        }

        @AuraEnabled public String Street
        {
            get { return this.getString ('STREET'); } 
            set { this.Set (value, 'STREET'); }
        }

        @AuraEnabled public String City
        {
            get { return this.getString ('CITY1'); } 
            set { this.Set (value, 'CITY1'); }
        }

        @AuraEnabled public String Region
        {
            get { return this.getString ('REGION'); } 
            set { this.Set (value, 'REGION'); }
        }

        @AuraEnabled public String PostalCode
        {
            get { return this.getString ('POST_CODE1'); } 
            set { this.Set (value, 'POST_CODE1'); }
        }

        @AuraEnabled public Integer OpenDeliveries
        {
            get { return this.getInteger ('NUM_DELVS'); } 
            set { this.Set (value, 'NUM_DELVS'); }
        }

    }
    global class ITEMS extends ensxsdk.EnosixFramework.ValueObject 
    {
        global ITEMS() { super(); }
        public override Type getType() { return ensxtx_SBO_SFCIDelivery_Detail.ITEMS.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCIDelivery_Detail.registerReflectionInfo();
        }

        public override List<string> getKeyFields()
        {
            List<string> keyFields = new List<string>{ 'EnosixObjKey','iindex' };
    
            return keyFields;
        }

                @AuraEnabled public String DeliveryItem
        {
            get { return this.getString ('POSNR'); } 
            set { this.Set (value, 'POSNR'); }
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

        @AuraEnabled public Decimal DeliveryQuantity
        {
            get { return this.getDecimal ('LFIMG'); } 
            set { this.Set (value, 'LFIMG'); }
        }

        @AuraEnabled public Decimal PickedQuantity
        {
            get { return this.getDecimal ('PIKMG'); } 
            set { this.Set (value, 'PIKMG'); }
        }

        @AuraEnabled public String SalesUnit
        {
            get { return this.getString ('VRKME'); } 
            set { this.Set (value, 'VRKME'); }
        }

        @AuraEnabled public String SalesUOMText
        {
            get { return this.getString ('VRKME_MSEHT'); } 
            set { this.Set (value, 'VRKME_MSEHT'); }
        }

        @AuraEnabled public String BaseUnitOfMeasure
        {
            get { return this.getString ('MEINS'); } 
            set { this.Set (value, 'MEINS'); }
        }

        @AuraEnabled public String UOMText
        {
            get { return this.getString ('MEINS_MSEHT'); } 
            set { this.Set (value, 'MEINS_MSEHT'); }
        }

        @AuraEnabled public String ItemDescription
        {
            get { return this.getString ('ARKTX'); } 
            set { this.Set (value, 'ARKTX'); }
        }

        @AuraEnabled public String CustomerMaterialNumber
        {
            get { return this.getString ('KDMAT'); } 
            set { this.Set (value, 'KDMAT'); }
        }

        @AuraEnabled public String CustomerPurchaseOrderNumber
        {
            get { return this.getString ('BSTKD'); } 
            set { this.Set (value, 'BSTKD'); }
        }

        @AuraEnabled public String ItemCategory
        {
            get { return this.getString ('PSTYV'); } 
            set { this.Set (value, 'PSTYV'); }
        }

        @AuraEnabled public String ItemCategoryDescription
        {
            get { return this.getString ('PSTYV_VTEXT'); } 
            set { this.Set (value, 'PSTYV_VTEXT'); }
        }

        @AuraEnabled public String DangerousGoodsIndicator
        {
            get { return this.getString ('PROFL'); } 
            set { this.Set (value, 'PROFL'); }
        }

        @AuraEnabled public String HigherLevelItemNumber
        {
            get { return this.getString ('UEPOS'); } 
            set { this.Set (value, 'UEPOS'); }
        }

        @AuraEnabled public String Plant
        {
            get { return this.getString ('WERKS'); } 
            set { this.Set (value, 'WERKS'); }
        }

        @AuraEnabled public String PlantName
        {
            get { return this.getString ('WERKS_NAME'); } 
            set { this.Set (value, 'WERKS_NAME'); }
        }

        @AuraEnabled public String MaterialType
        {
            get { return this.getString ('MTART'); } 
            set { this.Set (value, 'MTART'); }
        }

        @AuraEnabled public String MaterialGroup
        {
            get { return this.getString ('MATKL'); } 
            set { this.Set (value, 'MATKL'); }
        }

        @AuraEnabled public String ProductHierarchy
        {
            get { return this.getString ('PRODH'); } 
            set { this.Set (value, 'PRODH'); }
        }

        @AuraEnabled public String StorageLocation
        {
            get { return this.getString ('LGORT'); } 
            set { this.Set (value, 'LGORT'); }
        }

        @AuraEnabled public String BatchNumber
        {
            get { return this.getString ('CHARG'); } 
            set { this.Set (value, 'CHARG'); }
        }

        @AuraEnabled public Decimal ConditionPricingUnit
        {
            get { return this.getDecimal ('KPEIN'); } 
            set { this.Set (value, 'KPEIN'); }
        }

        @AuraEnabled public String ConditionUnit
        {
            get { return this.getString ('KMEIN'); } 
            set { this.Set (value, 'KMEIN'); }
        }

        @AuraEnabled public Decimal NetItemPrice
        {
            get { return this.getDecimal ('NETPR'); } 
            set { this.Set (value, 'NETPR'); }
        }

        @AuraEnabled public Decimal NetOrderValue
        {
            get { return this.getDecimal ('NETWR'); } 
            set { this.Set (value, 'NETWR'); }
        }

        @AuraEnabled public Decimal NetWeight
        {
            get { return this.getDecimal ('NTGEW'); } 
            set { this.Set (value, 'NTGEW'); }
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

        @AuraEnabled public String SalesOrder
        {
            get { return this.getString ('VGBEL'); } 
            set { this.Set (value, 'VGBEL'); }
        }

        @AuraEnabled public String SalesOrderItem
        {
            get { return this.getString ('VGPOS'); } 
            set { this.Set (value, 'VGPOS'); }
        }

        @AuraEnabled public String LoadingGroup
        {
            get { return this.getString ('LADGR'); } 
            set { this.Set (value, 'LADGR'); }
        }

        @AuraEnabled public String TransportationGroup
        {
            get { return this.getString ('TRAGR'); } 
            set { this.Set (value, 'TRAGR'); }
        }

        @AuraEnabled public String StorageType
        {
            get { return this.getString ('LGTYP'); } 
            set { this.Set (value, 'LGTYP'); }
        }

        @AuraEnabled public String StorageBin
        {
            get { return this.getString ('LGPLA'); } 
            set { this.Set (value, 'LGPLA'); }
        }

        @AuraEnabled public String MovementType
        {
            get { return this.getString ('BWART'); } 
            set { this.Set (value, 'BWART'); }
        }

        @AuraEnabled public Boolean BatchManagmentRequired
        {
            get { return this.getBoolean('XCHPF'); } 
            set { this.setBoolean(value, 'XCHPF'); }
        }

        @AuraEnabled public String DistributionChannel
        {
            get { return this.getString ('VTWEG'); } 
            set { this.Set (value, 'VTWEG'); }
        }

        @AuraEnabled public String DistributionChannelName
        {
            get { return this.getString ('VTWEG_VTEXT'); } 
            set { this.Set (value, 'VTWEG_VTEXT'); }
        }

        @AuraEnabled public String Division
        {
            get { return this.getString ('SPART'); } 
            set { this.Set (value, 'SPART'); }
        }

        @AuraEnabled public String DivisionName
        {
            get { return this.getString ('SPART_VTEXT'); } 
            set { this.Set (value, 'SPART_VTEXT'); }
        }

        @AuraEnabled public String SpecialStockInd
        {
            get { return this.getString ('SOBKZ'); } 
            set { this.Set (value, 'SOBKZ'); }
        }

        @AuraEnabled public Decimal CumulBatchQuantity
        {
            get { return this.getDecimal ('KCMENG'); } 
            set { this.Set (value, 'KCMENG'); }
        }

        @AuraEnabled public String HigerLevelBatchSplitItem
        {
            get { return this.getString ('UECHA'); } 
            set { this.Set (value, 'UECHA'); }
        }

        @AuraEnabled public String InspectionLot
        {
            get { return this.getString ('QPLOS'); } 
            set { this.Set (value, 'QPLOS'); }
        }

        @AuraEnabled public String QtyInInspectionStock
        {
            get { return this.getString ('INSMK'); } 
            set { this.Set (value, 'INSMK'); }
        }

        @AuraEnabled public String ReservationNumber
        {
            get { return this.getString ('RSNUM'); } 
            set { this.Set (value, 'RSNUM'); }
        }

        @AuraEnabled public String ReservationItem
        {
            get { return this.getString ('RSPOS'); } 
            set { this.Set (value, 'RSPOS'); }
        }

        @AuraEnabled public Decimal NumeratorConvSalesToSKU
        {
            get { return this.getDecimal ('UMVKZ'); } 
            set { this.Set (value, 'UMVKZ'); }
        }

        @AuraEnabled public Decimal DenominatorConvSalesToSKU
        {
            get { return this.getDecimal ('UMVKN'); } 
            set { this.Set (value, 'UMVKN'); }
        }

        @AuraEnabled public Decimal ConversionSalesToBaseUOM
        {
            get { return this.getDecimal ('UMREV'); } 
            set { this.Set (value, 'UMREV'); }
        }

        @AuraEnabled public String PickingStatus
        {
            get { return this.getString ('KOSTA'); } 
            set { this.Set (value, 'KOSTA'); }
        }

        @AuraEnabled public String PackingStatus
        {
            get { return this.getString ('PKSTA'); } 
            set { this.Set (value, 'PKSTA'); }
        }

        @AuraEnabled public String ProofofDelivery
        {
            get { return this.getString ('PDSTA'); } 
            set { this.Set (value, 'PDSTA'); }
        }

        @AuraEnabled public Decimal QtyShipped
        {
            get { return this.getDecimal ('LGMNG'); } 
            set { this.Set (value, 'LGMNG'); }
        }

        @AuraEnabled public Date RequestedShippedDate
        {
            get { return this.getDate ('VDATU'); } 
            set { this.Set (value, 'VDATU'); }
        }

        @AuraEnabled public Decimal HUItemQuantity
        {
            get { return this.getDecimal ('VEMNG'); } 
            set { this.Set (value, 'VEMNG'); }
        }

        @AuraEnabled public String ISBN
        {
            get { return this.getString ('ZZLTITLE'); } 
            set { this.Set (value, 'ZZLTITLE'); }
        }


    }
    global class ITEMS_COLLECTION extends ensxsdk.EnosixFramework.FrameworkCollection
    {
        global ITEMS_COLLECTION()
        {
            super('ITEMS', ensxtx_SBO_SFCIDelivery_Detail.ITEMS.class, null);
        }

        @AuraEnabled public List<ensxtx_SBO_SFCIDelivery_Detail.ITEMS> getAsList()
        {
            return (List<ensxtx_SBO_SFCIDelivery_Detail.ITEMS>)this.buildList(List<ensxtx_SBO_SFCIDelivery_Detail.ITEMS>.class);
        }
    }
    global class HU extends ensxsdk.EnosixFramework.ValueObject 
    {
        global HU() { super(); }
        public override Type getType() { return ensxtx_SBO_SFCIDelivery_Detail.HU.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCIDelivery_Detail.registerReflectionInfo();
        }

        public override List<string> getKeyFields()
        {
            List<string> keyFields = new List<string>{ 'EnosixObjKey','iindex' };
    
            return keyFields;
        }

                @AuraEnabled public String IntHUNumber
        {
            get { return this.getString ('VENUM'); } 
            set { this.Set (value, 'VENUM'); }
        }

        @AuraEnabled public String HUContentDescription
        {
            get { return this.getString ('INHALT'); } 
            set { this.Set (value, 'INHALT'); }
        }

        @AuraEnabled public String ExtHUID
        {
            get { return this.getString ('EXIDV'); } 
            set { this.Set (value, 'EXIDV'); }
        }

        @AuraEnabled public String ExtHUIDType
        {
            get { return this.getString ('EXIDA'); } 
            set { this.Set (value, 'EXIDA'); }
        }

        @AuraEnabled public String ShippingPoint
        {
            get { return this.getString ('VSTEL'); } 
            set { this.Set (value, 'VSTEL'); }
        }

        @AuraEnabled public String ShippingPointDescription
        {
            get { return this.getString ('VSTEL_VTEXT'); } 
            set { this.Set (value, 'VSTEL_VTEXT'); }
        }

        @AuraEnabled public String LoadingPoint
        {
            get { return this.getString ('LSTEL'); } 
            set { this.Set (value, 'LSTEL'); }
        }

        @AuraEnabled public String LoadingPointText
        {
            get { return this.getString ('LSTEL_VTEXT'); } 
            set { this.Set (value, 'LSTEL_VTEXT'); }
        }

        @AuraEnabled public String HUStatus
        {
            get { return this.getString ('STATUS'); } 
            set { this.Set (value, 'STATUS'); }
        }

        @AuraEnabled public String HUStatusDescription
        {
            get { return this.getString ('STATUS_VTEXT'); } 
            set { this.Set (value, 'STATUS_VTEXT'); }
        }

        @AuraEnabled public Decimal GrossWeight
        {
            get { return this.getDecimal ('BRGEW'); } 
            set { this.Set (value, 'BRGEW'); }
        }

        @AuraEnabled public Decimal NetWeight
        {
            get { return this.getDecimal ('NTGEW'); } 
            set { this.Set (value, 'NTGEW'); }
        }

        @AuraEnabled public Decimal HUAllowedWeight
        {
            get { return this.getDecimal ('MAGEW'); } 
            set { this.Set (value, 'MAGEW'); }
        }

        @AuraEnabled public Decimal TareWeight
        {
            get { return this.getDecimal ('TARAG'); } 
            set { this.Set (value, 'TARAG'); }
        }

        @AuraEnabled public String WeightUnit
        {
            get { return this.getString ('GEWEI'); } 
            set { this.Set (value, 'GEWEI'); }
        }

        @AuraEnabled public String CreatedBy
        {
            get { return this.getString ('ERNAM'); } 
            set { this.Set (value, 'ERNAM'); }
        }

        @AuraEnabled public Date CreateDate
        {
            get { return this.getDate ('ERDAT'); } 
            set { this.Set (value, 'ERDAT'); }
        }

        @AuraEnabled public Time EntryTime
        {
            get { return this.getTime ('ERUHR'); } 
            set { this.Set (value, 'ERUHR'); }
        }

        @AuraEnabled public String SortField
        {
            get { return this.getString ('SORTL'); } 
            set { this.Set (value, 'SORTL'); }
        }

        @AuraEnabled public String PackagingMaterial
        {
            get { return this.getString ('VHILM'); } 
            set { this.Set (value, 'VHILM'); }
        }

        @AuraEnabled public String PackagingMaterialDescritpion
        {
            get { return this.getString ('VHILM_MAKTX'); } 
            set { this.Set (value, 'VHILM_MAKTX'); }
        }

        @AuraEnabled public String LengthWidthHeightUOM
        {
            get { return this.getString ('MEABM'); } 
            set { this.Set (value, 'MEABM'); }
        }

        @AuraEnabled public String PackingMaterialType
        {
            get { return this.getString ('VHART'); } 
            set { this.Set (value, 'VHART'); }
        }

        @AuraEnabled public String MaterialGroupPackagingMaterials
        {
            get { return this.getString ('MAGRV'); } 
            set { this.Set (value, 'MAGRV'); }
        }

        @AuraEnabled public String Plant
        {
            get { return this.getString ('WERKS'); } 
            set { this.Set (value, 'WERKS'); }
        }

        @AuraEnabled public String StorageLocation
        {
            get { return this.getString ('LGORT'); } 
            set { this.Set (value, 'LGORT'); }
        }

        @AuraEnabled public String GlobalUniqueID
        {
            get { return this.getString ('HANDLE'); } 
            set { this.Set (value, 'HANDLE'); }
        }

    }
    global class HU_COLLECTION extends ensxsdk.EnosixFramework.FrameworkCollection
    {
        global HU_COLLECTION()
        {
            super('HU', ensxtx_SBO_SFCIDelivery_Detail.HU.class, null);
        }

        @AuraEnabled public List<ensxtx_SBO_SFCIDelivery_Detail.HU> getAsList()
        {
            return (List<ensxtx_SBO_SFCIDelivery_Detail.HU>)this.buildList(List<ensxtx_SBO_SFCIDelivery_Detail.HU>.class);
        }
    }
    global class HU_ITEMS extends ensxsdk.EnosixFramework.ValueObject 
    {
        global HU_ITEMS() { super(); }
        public override Type getType() { return ensxtx_SBO_SFCIDelivery_Detail.HU_ITEMS.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCIDelivery_Detail.registerReflectionInfo();
        }

        public override List<string> getKeyFields()
        {
            List<string> keyFields = new List<string>{ 'EnosixObjKey','iindex' };
    
            return keyFields;
        }

                @AuraEnabled public String IntHUNumber
        {
            get { return this.getString ('VENUM'); } 
            set { this.Set (value, 'VENUM'); }
        }

        @AuraEnabled public String HUItem
        {
            get { return this.getString ('VEPOS'); } 
            set { this.Set (value, 'VEPOS'); }
        }

        @AuraEnabled public String HUContentType
        {
            get { return this.getString ('VELIN'); } 
            set { this.Set (value, 'VELIN'); }
        }

        @AuraEnabled public String Delivery
        {
            get { return this.getString ('VBELN'); } 
            set { this.Set (value, 'VBELN'); }
        }

        @AuraEnabled public String DeliveryItem
        {
            get { return this.getString ('POSNR'); } 
            set { this.Set (value, 'POSNR'); }
        }

        @AuraEnabled public String SDDocumentCategory
        {
            get { return this.getString ('VBTYP'); } 
            set { this.Set (value, 'VBTYP'); }
        }

        @AuraEnabled public String LowerLevelHU
        {
            get { return this.getString ('UNVEL'); } 
            set { this.Set (value, 'UNVEL'); }
        }

        @AuraEnabled public Decimal HUItemQuantity
        {
            get { return this.getDecimal ('VEMNG'); } 
            set { this.Set (value, 'VEMNG'); }
        }

        @AuraEnabled public String HUItemUOM
        {
            get { return this.getString ('VEMEH'); } 
            set { this.Set (value, 'VEMEH'); }
        }

        @AuraEnabled public String HUUOMText
        {
            get { return this.getString ('VEMEH_MSEHT'); } 
            set { this.Set (value, 'VEMEH_MSEHT'); }
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

        @AuraEnabled public String CustomerPart
        {
            get { return this.getString ('P_MATERIAL'); } 
            set { this.Set (value, 'P_MATERIAL'); }
        }

        @AuraEnabled public String CustomerPartDescription
        {
            get { return this.getString ('P_MAKTX'); } 
            set { this.Set (value, 'P_MAKTX'); }
        }

        @AuraEnabled public String BatchNumber
        {
            get { return this.getString ('CHARG'); } 
            set { this.Set (value, 'CHARG'); }
        }

        @AuraEnabled public String Plant
        {
            get { return this.getString ('WERKS'); } 
            set { this.Set (value, 'WERKS'); }
        }

        @AuraEnabled public String StorageLocation
        {
            get { return this.getString ('LGORT'); } 
            set { this.Set (value, 'LGORT'); }
        }

        @AuraEnabled public String StockCategory
        {
            get { return this.getString ('BESTQ'); } 
            set { this.Set (value, 'BESTQ'); }
        }

        @AuraEnabled public String SpecialStockInd
        {
            get { return this.getString ('SOBKZ'); } 
            set { this.Set (value, 'SOBKZ'); }
        }

        @AuraEnabled public String SpecialStockNumber
        {
            get { return this.getString ('SONUM'); } 
            set { this.Set (value, 'SONUM'); }
        }

        @AuraEnabled public String InspectionLot
        {
            get { return this.getString ('QPLOS'); } 
            set { this.Set (value, 'QPLOS'); }
        }

        @AuraEnabled public String SerialNumberProfile
        {
            get { return this.getString ('SERAIL'); } 
            set { this.Set (value, 'SERAIL'); }
        }

        @AuraEnabled public String ItemCategory
        {
            get { return this.getString ('PSTYV'); } 
            set { this.Set (value, 'PSTYV'); }
        }

        @AuraEnabled public Date GoodsReceiptDate
        {
            get { return this.getDate ('WDATU'); } 
            set { this.Set (value, 'WDATU'); }
        }

        @AuraEnabled public Date ShelfLifeExpirationDate
        {
            get { return this.getDate ('VFDAT'); } 
            set { this.Set (value, 'VFDAT'); }
        }

        @AuraEnabled public Boolean HUTenativeAssignment
        {
            get { return this.getBoolean('XCHAR'); } 
            set { this.setBoolean(value, 'XCHAR'); }
        }

    }
    global class HU_ITEMS_COLLECTION extends ensxsdk.EnosixFramework.FrameworkCollection
    {
        global HU_ITEMS_COLLECTION()
        {
            super('HU_ITEMS', ensxtx_SBO_SFCIDelivery_Detail.HU_ITEMS.class, null);
        }

        @AuraEnabled public List<ensxtx_SBO_SFCIDelivery_Detail.HU_ITEMS> getAsList()
        {
            return (List<ensxtx_SBO_SFCIDelivery_Detail.HU_ITEMS>)this.buildList(List<ensxtx_SBO_SFCIDelivery_Detail.HU_ITEMS>.class);
        }
    }
    global class HEADER_TEXTS extends ensxsdk.EnosixFramework.ValueObject 
    {
        global HEADER_TEXTS() { super(); }
        public override Type getType() { return ensxtx_SBO_SFCIDelivery_Detail.HEADER_TEXTS.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCIDelivery_Detail.registerReflectionInfo();
        }

        public override List<string> getKeyFields()
        {
            List<string> keyFields = new List<string>{ 'EnosixObjKey','iindex' };
    
            return keyFields;
        }

                @AuraEnabled public String TextID
        {
            get { return this.getString ('TDID'); } 
            set { this.Set (value, 'TDID'); }
        }

        @AuraEnabled public String TextLanguage
        {
            get { return this.getString ('TDSPRAS'); } 
            set { this.Set (value, 'TDSPRAS'); }
        }

        @AuraEnabled public String TextIDDescription
        {
            get { return this.getString ('TDTEXT'); } 
            set { this.Set (value, 'TDTEXT'); }
        }

        @AuraEnabled public String Text
        {
            get { return this.getString ('TEXT'); } 
            set { this.Set (value, 'TEXT'); }
        }

    }
    global class HEADER_TEXTS_COLLECTION extends ensxsdk.EnosixFramework.FrameworkCollection
    {
        global HEADER_TEXTS_COLLECTION()
        {
            super('HEADER_TEXTS', ensxtx_SBO_SFCIDelivery_Detail.HEADER_TEXTS.class, null);
        }

        @AuraEnabled public List<ensxtx_SBO_SFCIDelivery_Detail.HEADER_TEXTS> getAsList()
        {
            return (List<ensxtx_SBO_SFCIDelivery_Detail.HEADER_TEXTS>)this.buildList(List<ensxtx_SBO_SFCIDelivery_Detail.HEADER_TEXTS>.class);
        }
    }
    global class ITEMS_TEXT extends ensxsdk.EnosixFramework.ValueObject 
    {
        global ITEMS_TEXT() { super(); }
        public override Type getType() { return ensxtx_SBO_SFCIDelivery_Detail.ITEMS_TEXT.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCIDelivery_Detail.registerReflectionInfo();
        }

        public override List<string> getKeyFields()
        {
            List<string> keyFields = new List<string>{ 'EnosixObjKey','iindex' };
    
            return keyFields;
        }

                @AuraEnabled public String DeliveryItem
        {
            get { return this.getString ('POSNR'); } 
            set { this.Set (value, 'POSNR'); }
        }

        @AuraEnabled public String TextID
        {
            get { return this.getString ('TDID'); } 
            set { this.Set (value, 'TDID'); }
        }

        @AuraEnabled public String TextLanguage
        {
            get { return this.getString ('TDSPRAS'); } 
            set { this.Set (value, 'TDSPRAS'); }
        }

        @AuraEnabled public String TextIDDescription
        {
            get { return this.getString ('TDTEXT'); } 
            set { this.Set (value, 'TDTEXT'); }
        }

        @AuraEnabled public String Text
        {
            get { return this.getString ('TEXT'); } 
            set { this.Set (value, 'TEXT'); }
        }

    }
    global class ITEMS_TEXT_COLLECTION extends ensxsdk.EnosixFramework.FrameworkCollection
    {
        global ITEMS_TEXT_COLLECTION()
        {
            super('ITEMS_TEXT', ensxtx_SBO_SFCIDelivery_Detail.ITEMS_TEXT.class, null);
        }

        @AuraEnabled public List<ensxtx_SBO_SFCIDelivery_Detail.ITEMS_TEXT> getAsList()
        {
            return (List<ensxtx_SBO_SFCIDelivery_Detail.ITEMS_TEXT>)this.buildList(List<ensxtx_SBO_SFCIDelivery_Detail.ITEMS_TEXT>.class);
        }
    }
    global class USER_DEFINED extends ensxsdk.EnosixFramework.ValueObject 
    {
        global USER_DEFINED() { super(); }
        public override Type getType() { return ensxtx_SBO_SFCIDelivery_Detail.USER_DEFINED.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCIDelivery_Detail.registerReflectionInfo();
        }

        public override List<string> getKeyFields()
        {
            List<string> keyFields = new List<string>{ 'EnosixObjKey','iindex' };
    
            return keyFields;
        }

                @AuraEnabled public String FIELD
        {
            get { return this.getString ('FIELD'); } 
            set { this.Set (value, 'FIELD'); }
        }

        @AuraEnabled public String VALUE
        {
            get { return this.getString ('VALUE'); } 
            set { this.Set (value, 'VALUE'); }
        }

    }
    global class USER_DEFINED_COLLECTION extends ensxsdk.EnosixFramework.FrameworkCollection
    {
        global USER_DEFINED_COLLECTION()
        {
            super('USER_DEFINED', ensxtx_SBO_SFCIDelivery_Detail.USER_DEFINED.class, null);
        }

        @AuraEnabled public List<ensxtx_SBO_SFCIDelivery_Detail.USER_DEFINED> getAsList()
        {
            return (List<ensxtx_SBO_SFCIDelivery_Detail.USER_DEFINED>)this.buildList(List<ensxtx_SBO_SFCIDelivery_Detail.USER_DEFINED>.class);
        }
    }
    global class ITEM_USER_DEFINED extends ensxsdk.EnosixFramework.ValueObject 
    {
        global ITEM_USER_DEFINED() { super(); }
        public override Type getType() { return ensxtx_SBO_SFCIDelivery_Detail.ITEM_USER_DEFINED.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCIDelivery_Detail.registerReflectionInfo();
        }

        public override List<string> getKeyFields()
        {
            List<string> keyFields = new List<string>{ 'EnosixObjKey','iindex' };
    
            return keyFields;
        }

                @AuraEnabled public String DeliveryItem
        {
            get { return this.getString ('POSNR'); } 
            set { this.Set (value, 'POSNR'); }
        }

        @AuraEnabled public String FIELD
        {
            get { return this.getString ('FIELD'); } 
            set { this.Set (value, 'FIELD'); }
        }

        @AuraEnabled public String VALUE
        {
            get { return this.getString ('VALUE'); } 
            set { this.Set (value, 'VALUE'); }
        }

    }
    global class ITEM_USER_DEFINED_COLLECTION extends ensxsdk.EnosixFramework.FrameworkCollection
    {
        global ITEM_USER_DEFINED_COLLECTION()
        {
            super('ITEM_USER_DEFINED', ensxtx_SBO_SFCIDelivery_Detail.ITEM_USER_DEFINED.class, null);
        }

        @AuraEnabled public List<ensxtx_SBO_SFCIDelivery_Detail.ITEM_USER_DEFINED> getAsList()
        {
            return (List<ensxtx_SBO_SFCIDelivery_Detail.ITEM_USER_DEFINED>)this.buildList(List<ensxtx_SBO_SFCIDelivery_Detail.ITEM_USER_DEFINED>.class);
        }
    }
}