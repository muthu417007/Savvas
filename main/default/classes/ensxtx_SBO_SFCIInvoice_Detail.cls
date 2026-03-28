/// enosiX Inc. Generated Apex Model
/// Generated On: 5/16/2024 8:45:26 PM
/// SAP Host: From REST Service On: https://savvas--dev3.sandbox.my.salesforce.com
/// CID: From REST Service On: https://savvas--dev3.sandbox.my.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework ensxapp.v1.2

global with sharing class ensxtx_SBO_SFCIInvoice_Detail extends ensxsdk.EnosixFramework.DetailSBO
{
        static void registerReflectionInfo()
    {
        ensxsdk.EnosixFramework.registerReflectionResource('ensxtx_SBO_SFCIInvoice_Detail_Meta', new Type[] {
            ensxtx_SBO_SFCIInvoice_Detail.SFCIInvoice.class
            , ensxtx_SBO_SFCIInvoice_Detail.ITEMS.class
            , ensxtx_SBO_SFCIInvoice_Detail.CONDITIONS.class
            , ensxtx_SBO_SFCIInvoice_Detail.USER_DEFINED.class
            , ensxtx_SBO_SFCIInvoice_Detail.ITEM_USER_DEFINED.class
            } 
        );
    }

    global ensxtx_SBO_SFCIInvoice_Detail()
    {
        super('SFCIInvoice', ensxtx_SBO_SFCIInvoice_Detail.SFCIInvoice.class);
    }

    public override Type getType() { return ensxtx_SBO_SFCIInvoice_Detail.class; }

    public SFCIInvoice initialize(SFCIInvoice obj)
    {
        return (SFCIInvoice)this.executeInitialize(obj);
    }
    
    public SFCIInvoice getDetail(object key)
    {
        return (SFCIInvoice)this.executeGetDetail(key);
    }
    
    public SFCIInvoice save(SFCIInvoice obj)
    {
        return (SFCIInvoice) this.executeSave(obj);
    }

    public SFCIInvoice command(string command, SFCIInvoice obj)
    {
        return (SFCIInvoice) this.executeCommand(command, obj);
    }
    
    global with sharing class SFCIInvoice extends ensxsdk.EnosixFramework.DetailObject
    {
        global SFCIInvoice()
        {
            super('HEADER', new Map<string,type>
                {
                    'ITEMS' => ensxtx_SBO_SFCIInvoice_Detail.ITEMS_COLLECTION.class
                    ,'CONDITIONS' => ensxtx_SBO_SFCIInvoice_Detail.CONDITIONS_COLLECTION.class
                    ,'USER_DEFINED' => ensxtx_SBO_SFCIInvoice_Detail.USER_DEFINED_COLLECTION.class
                    ,'ITEM_USER_DEFINED' => ensxtx_SBO_SFCIInvoice_Detail.ITEM_USER_DEFINED_COLLECTION.class
                });	
        }

        public override Type getType() { return ensxtx_SBO_SFCIInvoice_Detail.SFCIInvoice.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCIInvoice_Detail.registerReflectionInfo();
        }

                @AuraEnabled public String BillingDocument
        {
            get { return this.getString ('VBELN'); } 
            set { this.Set (value, 'VBELN'); }
        }

        @AuraEnabled public String BillingType
        {
            get { return this.getString ('FKART'); } 
            set { this.Set (value, 'FKART'); }
        }

        @AuraEnabled public String BillingTypeDescription
        {
            get { return this.getString ('FKART_TEXT'); } 
            set { this.Set (value, 'FKART_TEXT'); }
        }

        @AuraEnabled public String CompanyCode
        {
            get { return this.getString ('BUKRS'); } 
            set { this.Set (value, 'BUKRS'); }
        }

        @AuraEnabled public String CompanyCodeName
        {
            get { return this.getString ('BUKRS_TEXT'); } 
            set { this.Set (value, 'BUKRS_TEXT'); }
        }

        @AuraEnabled public String SalesOrganization
        {
            get { return this.getString ('VKORG'); } 
            set { this.Set (value, 'VKORG'); }
        }

        @AuraEnabled public String SalesOrgDescription
        {
            get { return this.getString ('VKORG_TEXT'); } 
            set { this.Set (value, 'VKORG_TEXT'); }
        }

        @AuraEnabled public Date BillingDate
        {
            get { return this.getDate ('FKDAT'); } 
            set { this.Set (value, 'FKDAT'); }
        }

        @AuraEnabled public Date ShipDate
        {
            get { return this.getDate ('WADAT'); } 
            set { this.Set (value, 'WADAT'); }
        }

        @AuraEnabled public String SalesOrderNumber
        {
            get { return this.getString ('AUBEL'); } 
            set { this.Set (value, 'AUBEL'); }
        }

        @AuraEnabled public String Payer
        {
            get { return this.getString ('KUNRG'); } 
            set { this.Set (value, 'KUNRG'); }
        }

        @AuraEnabled public String PayerName
        {
            get { return this.getString ('KUNRG_NAME'); } 
            set { this.Set (value, 'KUNRG_NAME'); }
        }

        @AuraEnabled public String SoldToParty
        {
            get { return this.getString ('KUNAG'); } 
            set { this.Set (value, 'KUNAG'); }
        }

        @AuraEnabled public String SoldToName
        {
            get { return this.getString ('KUNAG_NAME'); } 
            set { this.Set (value, 'KUNAG_NAME'); }
        }

        @AuraEnabled public String ShipToParty
        {
            get { return this.getString ('KUNWE'); } 
            set { this.Set (value, 'KUNWE'); }
        }

        @AuraEnabled public String ShipToName
        {
            get { return this.getString ('KUNWE_NAME'); } 
            set { this.Set (value, 'KUNWE_NAME'); }
        }

        @AuraEnabled public String TrackingNumber
        {
            get { return this.getString ('BOLNR'); } 
            set { this.Set (value, 'BOLNR'); }
        }

        @AuraEnabled public String PaymentMethod
        {
            get { return this.getString ('ZLSCH'); } 
            set { this.Set (value, 'ZLSCH'); }
        }

        @AuraEnabled public String PaymentMethodDescription
        {
            get { return this.getString ('ZLSCH_TEXT'); } 
            set { this.Set (value, 'ZLSCH_TEXT'); }
        }

        @AuraEnabled public String TermsofPaymentKey
        {
            get { return this.getString ('ZTERM'); } 
            set { this.Set (value, 'ZTERM'); }
        }

        @AuraEnabled public String PaymentTermsDescription
        {
            get { return this.getString ('ZTERM_TEXT'); } 
            set { this.Set (value, 'ZTERM_TEXT'); }
        }

        @AuraEnabled public Decimal NetOrderValue
        {
            get { return this.getDecimal ('NETWR'); } 
            set { this.Set (value, 'NETWR'); }
        }

        @AuraEnabled public Decimal TaxAmount
        {
            get { return this.getDecimal ('MWSBK'); } 
            set { this.Set (value, 'MWSBK'); }
        }

        @AuraEnabled public String SalesDocumentCurrency
        {
            get { return this.getString ('WAERK'); } 
            set { this.Set (value, 'WAERK'); }
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

        @AuraEnabled public String BillingStatus
        {
            get { return this.getString ('FKSTK'); } 
            set { this.Set (value, 'FKSTK'); }
        }

        @AuraEnabled public String BillingStatusDescription
        {
            get { return this.getString ('FKSTK_TEXT'); } 
            set { this.Set (value, 'FKSTK_TEXT'); }
        }

        @AuraEnabled public Decimal GrossAmount
        {
            get { return this.getDecimal ('NETPR'); } 
            set { this.Set (value, 'NETPR'); }
        }

        @AuraEnabled public Integer DecimalPlaces
        {
            get { return this.getInteger ('DECIMAL_PLACES'); } 
            set { this.Set (value, 'DECIMAL_PLACES'); }
        }

        @AuraEnabled public Decimal ActualInvoicedQuantity
        {
            get { return this.getDecimal ('FKIMG'); } 
            set { this.Set (value, 'FKIMG'); }
        }

        @AuraEnabled public Decimal NetProduct
        {
            get { return this.getDecimal ('KZWI1'); } 
            set { this.Set (value, 'KZWI1'); }
        }

        @AuraEnabled public Decimal Discount
        {
            get { return this.getDecimal ('KZWI2'); } 
            set { this.Set (value, 'KZWI2'); }
        }

        @AuraEnabled public Decimal Transportation
        {
            get { return this.getDecimal ('KZWI5'); } 
            set { this.Set (value, 'KZWI5'); }
        }

        @AuraEnabled public ITEMS_COLLECTION ITEMS
        {
            get 
            { 
                return (ITEMS_COLLECTION)this.getCollection(ensxtx_SBO_SFCIInvoice_Detail.ITEMS_COLLECTION.class); 
            }
        }

                @AuraEnabled public CONDITIONS_COLLECTION CONDITIONS
        {
            get 
            { 
                return (CONDITIONS_COLLECTION)this.getCollection(ensxtx_SBO_SFCIInvoice_Detail.CONDITIONS_COLLECTION.class); 
            }
        }

                @AuraEnabled public USER_DEFINED_COLLECTION USER_DEFINED
        {
            get 
            { 
                return (USER_DEFINED_COLLECTION)this.getCollection(ensxtx_SBO_SFCIInvoice_Detail.USER_DEFINED_COLLECTION.class); 
            }
        }

                @AuraEnabled public ITEM_USER_DEFINED_COLLECTION ITEM_USER_DEFINED
        {
            get 
            { 
                return (ITEM_USER_DEFINED_COLLECTION)this.getCollection(ensxtx_SBO_SFCIInvoice_Detail.ITEM_USER_DEFINED_COLLECTION.class); 
            }
        }

            }

    //Write child objects
        global class ITEMS extends ensxsdk.EnosixFramework.ValueObject 
    {
        global ITEMS() { super(); }
        public override Type getType() { return ensxtx_SBO_SFCIInvoice_Detail.ITEMS.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCIInvoice_Detail.registerReflectionInfo();
        }

        public override List<string> getKeyFields()
        {
            List<string> keyFields = new List<string>{ 'EnosixObjKey','iindex' };
    
            return keyFields;
        }

                @AuraEnabled public String ItemNumber
        {
            get { return this.getString ('POSNR'); } 
            set { this.Set (value, 'POSNR'); }
        }

        @AuraEnabled public String Material
        {
            get { return this.getString ('MATNR'); } 
            set { this.Set (value, 'MATNR'); }
        }

        @AuraEnabled public String ItemDescription
        {
            get { return this.getString ('ARKTX'); } 
            set { this.Set (value, 'ARKTX'); }
        }

        @AuraEnabled public Decimal ActualInvoicedQuantity
        {
            get { return this.getDecimal ('FKIMG'); } 
            set { this.Set (value, 'FKIMG'); }
        }

        @AuraEnabled public String SalesUnit
        {
            get { return this.getString ('VRKME'); } 
            set { this.Set (value, 'VRKME'); }
        }

        @AuraEnabled public String Plant
        {
            get { return this.getString ('WERKS'); } 
            set { this.Set (value, 'WERKS'); }
        }

        @AuraEnabled public String PlantDescription
        {
            get { return this.getString ('WERKS_TEXT'); } 
            set { this.Set (value, 'WERKS_TEXT'); }
        }

        @AuraEnabled public Decimal NetOrderValue
        {
            get { return this.getDecimal ('NETWR'); } 
            set { this.Set (value, 'NETWR'); }
        }

        @AuraEnabled public Decimal TaxAmount
        {
            get { return this.getDecimal ('MWSBP'); } 
            set { this.Set (value, 'MWSBP'); }
        }

        @AuraEnabled public Decimal ItemGrossAmount
        {
            get { return this.getDecimal ('BRTWR'); } 
            set { this.Set (value, 'BRTWR'); }
        }

        @AuraEnabled public Decimal NetProduct
        {
            get { return this.getDecimal ('KZWI1'); } 
            set { this.Set (value, 'KZWI1'); }
        }

        @AuraEnabled public Decimal Discount
        {
            get { return this.getDecimal ('KZWI2'); } 
            set { this.Set (value, 'KZWI2'); }
        }

        @AuraEnabled public Decimal Transportation
        {
            get { return this.getDecimal ('KZWI5'); } 
            set { this.Set (value, 'KZWI5'); }
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
            super('ITEMS', ensxtx_SBO_SFCIInvoice_Detail.ITEMS.class, null);
        }

        @AuraEnabled public List<ensxtx_SBO_SFCIInvoice_Detail.ITEMS> getAsList()
        {
            return (List<ensxtx_SBO_SFCIInvoice_Detail.ITEMS>)this.buildList(List<ensxtx_SBO_SFCIInvoice_Detail.ITEMS>.class);
        }
    }
    global class CONDITIONS extends ensxsdk.EnosixFramework.ValueObject 
    {
        global CONDITIONS() { super(); }
        public override Type getType() { return ensxtx_SBO_SFCIInvoice_Detail.CONDITIONS.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCIInvoice_Detail.registerReflectionInfo();
        }

        public override List<string> getKeyFields()
        {
            List<string> keyFields = new List<string>{ 'EnosixObjKey','iindex' };
    
            return keyFields;
        }

                @AuraEnabled public String ConditionNumber
        {
            get { return this.getString ('KNUMV'); } 
            set { this.Set (value, 'KNUMV'); }
        }

        @AuraEnabled public String ConditionItemNumber
        {
            get { return this.getString ('KPOSN'); } 
            set { this.Set (value, 'KPOSN'); }
        }

        @AuraEnabled public String StepNumber
        {
            get { return this.getString ('STUNR'); } 
            set { this.Set (value, 'STUNR'); }
        }

        @AuraEnabled public String ConditionCounter
        {
            get { return this.getString ('ZAEHK'); } 
            set { this.Set (value, 'ZAEHK'); }
        }

        @AuraEnabled public String ConditionType
        {
            get { return this.getString ('KSCHL'); } 
            set { this.Set (value, 'KSCHL'); }
        }

        @AuraEnabled public String ConditionTypeName
        {
            get { return this.getString ('KSCHL_VTEXT'); } 
            set { this.Set (value, 'KSCHL_VTEXT'); }
        }

        @AuraEnabled public Decimal Rate
        {
            get { return this.getDecimal ('KBETR'); } 
            set { this.Set (value, 'KBETR'); }
        }

        @AuraEnabled public String RateUnit
        {
            get { return this.getString ('KOEIN'); } 
            set { this.Set (value, 'KOEIN'); }
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

        @AuraEnabled public Decimal ConditionValue
        {
            get { return this.getDecimal ('KWERT'); } 
            set { this.Set (value, 'KWERT'); }
        }

        @AuraEnabled public String SalesDocumentCurrency
        {
            get { return this.getString ('WAERK'); } 
            set { this.Set (value, 'WAERK'); }
        }

        @AuraEnabled public Decimal CondValueforCumulationFields
        {
            get { return this.getDecimal ('KWERT_K'); } 
            set { this.Set (value, 'KWERT_K'); }
        }

        @AuraEnabled public String CondCurrencyforCumulationFlds
        {
            get { return this.getString ('KWAEH'); } 
            set { this.Set (value, 'KWAEH'); }
        }

        @AuraEnabled public Boolean ConditionStatistics
        {
            get { return this.getBoolean('KSTAT'); } 
            set { this.setBoolean(value, 'KSTAT'); }
        }

        @AuraEnabled public String KRECH
        {
            get { return this.getString ('KRECH'); } 
            set { this.Set (value, 'KRECH'); }
        }

        @AuraEnabled public String KMANU
        {
            get { return this.getString ('KMANU'); } 
            set { this.Set (value, 'KMANU'); }
        }

    }
    global class CONDITIONS_COLLECTION extends ensxsdk.EnosixFramework.FrameworkCollection
    {
        global CONDITIONS_COLLECTION()
        {
            super('CONDITIONS', ensxtx_SBO_SFCIInvoice_Detail.CONDITIONS.class, null);
        }

        @AuraEnabled public List<ensxtx_SBO_SFCIInvoice_Detail.CONDITIONS> getAsList()
        {
            return (List<ensxtx_SBO_SFCIInvoice_Detail.CONDITIONS>)this.buildList(List<ensxtx_SBO_SFCIInvoice_Detail.CONDITIONS>.class);
        }
    }
    global class USER_DEFINED extends ensxsdk.EnosixFramework.ValueObject 
    {
        global USER_DEFINED() { super(); }
        public override Type getType() { return ensxtx_SBO_SFCIInvoice_Detail.USER_DEFINED.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCIInvoice_Detail.registerReflectionInfo();
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
            super('USER_DEFINED', ensxtx_SBO_SFCIInvoice_Detail.USER_DEFINED.class, null);
        }

        @AuraEnabled public List<ensxtx_SBO_SFCIInvoice_Detail.USER_DEFINED> getAsList()
        {
            return (List<ensxtx_SBO_SFCIInvoice_Detail.USER_DEFINED>)this.buildList(List<ensxtx_SBO_SFCIInvoice_Detail.USER_DEFINED>.class);
        }
    }
    global class ITEM_USER_DEFINED extends ensxsdk.EnosixFramework.ValueObject 
    {
        global ITEM_USER_DEFINED() { super(); }
        public override Type getType() { return ensxtx_SBO_SFCIInvoice_Detail.ITEM_USER_DEFINED.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCIInvoice_Detail.registerReflectionInfo();
        }

        public override List<string> getKeyFields()
        {
            List<string> keyFields = new List<string>{ 'EnosixObjKey','iindex' };
    
            return keyFields;
        }

                @AuraEnabled public String ItemNumber
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
            super('ITEM_USER_DEFINED', ensxtx_SBO_SFCIInvoice_Detail.ITEM_USER_DEFINED.class, null);
        }

        @AuraEnabled public List<ensxtx_SBO_SFCIInvoice_Detail.ITEM_USER_DEFINED> getAsList()
        {
            return (List<ensxtx_SBO_SFCIInvoice_Detail.ITEM_USER_DEFINED>)this.buildList(List<ensxtx_SBO_SFCIInvoice_Detail.ITEM_USER_DEFINED>.class);
        }
    }
}