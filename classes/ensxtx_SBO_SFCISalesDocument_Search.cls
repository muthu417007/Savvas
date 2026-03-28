/// enosiX Inc. Generated Apex Model
/// Generated On: 5/16/2024 8:03:18 PM
/// SAP Host: From REST Service On: https://savvas--dev3.sandbox.my.salesforce.com
/// CID: From REST Service On: https://savvas--dev3.sandbox.my.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework ensxapp.v1.2

global with sharing class ensxtx_SBO_SFCISalesDocument_Search extends ensxsdk.EnosixFramework.SearchSBO 
{
        static void registerReflectionInfo()
    {
        ensxsdk.EnosixFramework.registerReflectionResource('ensxtx_SBO_SFCISalesDocument_Search_Meta', new Type[] {
            ensxtx_SBO_SFCISalesDocument_Search.SFCISalesDocument_SC.class
            , ensxtx_SBO_SFCISalesDocument_Search.SFCISalesDocument_SR.class
            , ensxtx_SBO_SFCISalesDocument_Search.SEARCHRESULT.class
            , ensxtx_SBO_SFCISalesDocument_Search.SEARCHPARAMS.class
            , ensxtx_SBO_SFCISalesDocument_Search.SALESDOCTYPE.class
            , ensxtx_SBO_SFCISalesDocument_Search.CHANGED_DATE.class
            , ensxtx_SBO_SFCISalesDocument_Search.CUSTOM.class
            , ensxtx_SBO_SFCISalesDocument_Search.SEARCHRESULT.class
            } 
        );
    }

    global ensxtx_SBO_SFCISalesDocument_Search() 
    {
        super('SFCISalesDocument', ensxtx_SBO_SFCISalesDocument_Search.SFCISalesDocument_SC.class, ensxtx_SBO_SFCISalesDocument_Search.SFCISalesDocument_SR.class);
    }
    
    public override Type getType() { return ensxtx_SBO_SFCISalesDocument_Search.class; }

    public SFCISalesDocument_SC search(SFCISalesDocument_SC sc) 
    {
        return (SFCISalesDocument_SC)super.executeSearch(sc);
    }

    public SFCISalesDocument_SC initialize(SFCISalesDocument_SC sc) 
    {
        return (SFCISalesDocument_SC)super.executeInitialize(sc);
    }

    global class SFCISalesDocument_SC extends ensxsdk.EnosixFramework.SearchContext 
    { 		
        global SFCISalesDocument_SC() 
        {		
            super(new Map<string,type>		
                {		
                    'SEARCHPARAMS' => ensxtx_SBO_SFCISalesDocument_Search.SEARCHPARAMS.class
                    ,'SALESDOCTYPE' => ensxtx_SBO_SFCISalesDocument_Search.SALESDOCTYPE_COLLECTION.class
                    ,'CHANGED_DATE' => ensxtx_SBO_SFCISalesDocument_Search.CHANGED_DATE.class
                    ,'CUSTOM' => ensxtx_SBO_SFCISalesDocument_Search.CUSTOM_COLLECTION.class		
                });		
        }

        public override Type getType() { return ensxtx_SBO_SFCISalesDocument_Search.SFCISalesDocument_SC.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCISalesDocument_Search.registerReflectionInfo();
        }

        public SFCISalesDocument_SR result { get { return (SFCISalesDocument_SR)baseResult; } }

        @AuraEnabled public ensxtx_SBO_SFCISalesDocument_Search.SEARCHPARAMS SEARCHPARAMS 
        {
            get
            {
                return (ensxtx_SBO_SFCISalesDocument_Search.SEARCHPARAMS)this.getStruct(ensxtx_SBO_SFCISalesDocument_Search.SEARCHPARAMS.class);
            }
        }
                @AuraEnabled public SALESDOCTYPE_COLLECTION SALESDOCTYPE
        {
            get 
            { 
                return (SALESDOCTYPE_COLLECTION)this.getCollection(ensxtx_SBO_SFCISalesDocument_Search.SALESDOCTYPE_COLLECTION.class); 
            }
        }

                @AuraEnabled public ensxtx_SBO_SFCISalesDocument_Search.CHANGED_DATE CHANGED_DATE 
        {
            get
            {
                return (ensxtx_SBO_SFCISalesDocument_Search.CHANGED_DATE)this.getStruct(ensxtx_SBO_SFCISalesDocument_Search.CHANGED_DATE.class);
            }
        }
                @AuraEnabled public CUSTOM_COLLECTION CUSTOM
        {
            get 
            { 
                return (CUSTOM_COLLECTION)this.getCollection(ensxtx_SBO_SFCISalesDocument_Search.CUSTOM_COLLECTION.class); 
            }
        }

            }

    global class SFCISalesDocument_SR extends ensxsdk.EnosixFramework.SearchResult 
    {
        global SFCISalesDocument_SR() 
        {
            super(new Map<string,type>{'SEARCHRESULT' => ensxtx_SBO_SFCISalesDocument_Search.SEARCHRESULT.class } );
        }
        
        public ensxsdk.EnosixFramework.FrameworkCollection SearchResults
        {
            get { return super.getCollection(ensxtx_SBO_SFCISalesDocument_Search.SEARCHRESULT.class); }
        }
        
        public List<SEARCHRESULT> getResults() 
        {
            List<SEARCHRESULT> results = new List<SEARCHRESULT>();
            SearchResults.copyTo(results);
            return results;
        }

        public override Type getType() { return ensxtx_SBO_SFCISalesDocument_Search.SFCISalesDocument_SR.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCISalesDocument_Search.registerReflectionInfo();
        }
    }

    global class SEARCHPARAMS extends ensxsdk.EnosixFramework.ValueObject 
    {
        global SEARCHPARAMS() { super(); }
        public override Type getType() { return ensxtx_SBO_SFCISalesDocument_Search.SEARCHPARAMS.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCISalesDocument_Search.registerReflectionInfo();
        }
        @AuraEnabled public String FromSalesDocumentNumber
        {
            get { return this.getString ('VBELN_FR'); } 
            set { this.Set (value, 'VBELN_FR'); }
        }

        @AuraEnabled public String ToSalesDocumentNumber
        {
            get { return this.getString ('VBELN_TO'); } 
            set { this.Set (value, 'VBELN_TO'); }
        }

        @AuraEnabled public String SoldToParty
        {
            get { return this.getString ('KUNAG'); } 
            set { this.Set (value, 'KUNAG'); }
        }

        @AuraEnabled public String ShipToParty
        {
            get { return this.getString ('KUNWE'); } 
            set { this.Set (value, 'KUNWE'); }
        }

        @AuraEnabled public String CustomerPONumber
        {
            get { return this.getString ('BSTNK'); } 
            set { this.Set (value, 'BSTNK'); }
        }

        @AuraEnabled public String Material
        {
            get { return this.getString ('MATNR'); } 
            set { this.Set (value, 'MATNR'); }
        }

        @AuraEnabled public String TransactionGroup
        {
            get { return this.getString ('TRVOG'); } 
            set { this.Set (value, 'TRVOG'); }
        }

        @AuraEnabled public Date FromCreateDate
        {
            get { return this.getDate ('ERDAT_FR'); } 
            set { this.Set (value, 'ERDAT_FR'); }
        }

        @AuraEnabled public Date ToCreateDate
        {
            get { return this.getDate ('ERDAT_TO'); } 
            set { this.Set (value, 'ERDAT_TO'); }
        }

        @AuraEnabled public Boolean OpenOnly
        {
            get { return this.getBoolean('X_OPENONLY'); } 
            set { this.setBoolean(value, 'X_OPENONLY'); }
        }

        @AuraEnabled public Boolean CompletedOnly
        {
            get { return this.getBoolean('X_COMPLETEDONLY'); } 
            set { this.setBoolean(value, 'X_COMPLETEDONLY'); }
        }

        @AuraEnabled public String Username
        {
            get { return this.getString ('USERNAME'); } 
            set { this.Set (value, 'USERNAME'); }
        }

        @AuraEnabled public String SalesDocumentVersionNumber
        {
            get { return this.getString ('VSNMR_V'); } 
            set { this.Set (value, 'VSNMR_V'); }
        }

        @AuraEnabled public String YourReference
        {
            get { return this.getString ('IHREZ'); } 
            set { this.Set (value, 'IHREZ'); }
        }

        @AuraEnabled public String ShipToPurchaseOrderNumber
        {
            get { return this.getString ('BSTKD_E'); } 
            set { this.Set (value, 'BSTKD_E'); }
        }

        @AuraEnabled public Boolean X_DeliveryBlock
        {
            get { return this.getBoolean('X_DELIVERY_BLOCK'); } 
            set { this.setBoolean(value, 'X_DELIVERY_BLOCK'); }
        }

        @AuraEnabled public Boolean X_BillingBlock
        {
            get { return this.getBoolean('X_BILLING_BLOCK'); } 
            set { this.setBoolean(value, 'X_BILLING_BLOCK'); }
        }

        @AuraEnabled public Boolean X_CreditBlock
        {
            get { return this.getBoolean('X_CREDIT_BLOCK'); } 
            set { this.setBoolean(value, 'X_CREDIT_BLOCK'); }
        }

    }

global class SALESDOCTYPE extends ensxsdk.EnosixFramework.ValueObject 
    {
        global SALESDOCTYPE() { super(); }
        public override Type getType() { return ensxtx_SBO_SFCISalesDocument_Search.SALESDOCTYPE.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCISalesDocument_Search.registerReflectionInfo();
        }
        @AuraEnabled public String SalesDocumentType
        {
            get { return this.getString ('AUART'); } 
            set { this.Set (value, 'AUART'); }
        }

    }

    global class SALESDOCTYPE_COLLECTION extends ensxsdk.EnosixFramework.FrameworkCollection
    {
        global SALESDOCTYPE_COLLECTION()
        {
            super('SALESDOCTYPE', ensxtx_SBO_SFCISalesDocument_Search.SALESDOCTYPE.class, null);
        }

        public List<ensxtx_SBO_SFCISalesDocument_Search.SALESDOCTYPE> getAsList()
        {
            return (List<ensxtx_SBO_SFCISalesDocument_Search.SALESDOCTYPE>)this.buildList(List<ensxtx_SBO_SFCISalesDocument_Search.SALESDOCTYPE>.class);
        }
    }

global class CHANGED_DATE extends ensxsdk.EnosixFramework.ValueObject 
    {
        global CHANGED_DATE() { super(); }
        public override Type getType() { return ensxtx_SBO_SFCISalesDocument_Search.CHANGED_DATE.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCISalesDocument_Search.registerReflectionInfo();
        }
        @AuraEnabled public Date ChangedDateBegin
        {
            get { return this.getDate ('CHBDATE'); } 
            set { this.Set (value, 'CHBDATE'); }
        }

        @AuraEnabled public Date ChangedDateEnd
        {
            get { return this.getDate ('CHEDATE'); } 
            set { this.Set (value, 'CHEDATE'); }
        }

    }

global class CUSTOM extends ensxsdk.EnosixFramework.ValueObject 
    {
        global CUSTOM() { super(); }
        public override Type getType() { return ensxtx_SBO_SFCISalesDocument_Search.CUSTOM.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCISalesDocument_Search.registerReflectionInfo();
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

    global class CUSTOM_COLLECTION extends ensxsdk.EnosixFramework.FrameworkCollection
    {
        global CUSTOM_COLLECTION()
        {
            super('CUSTOM', ensxtx_SBO_SFCISalesDocument_Search.CUSTOM.class, null);
        }

        public List<ensxtx_SBO_SFCISalesDocument_Search.CUSTOM> getAsList()
        {
            return (List<ensxtx_SBO_SFCISalesDocument_Search.CUSTOM>)this.buildList(List<ensxtx_SBO_SFCISalesDocument_Search.CUSTOM>.class);
        }
    }

    global class SEARCHRESULT extends ensxsdk.EnosixFramework.ValueObject 
    {
        global SEARCHRESULT() { super(); }
        public override Type getType() { return ensxtx_SBO_SFCISalesDocument_Search.SEARCHRESULT.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCISalesDocument_Search.registerReflectionInfo();
        }
        @AuraEnabled public String SalesDocument
        {
            get { return this.getString ('VBELN'); } 
            set { this.Set (value, 'VBELN'); }
        }

        @AuraEnabled public String CustomerPONumber
        {
            get { return this.getString ('BSTNK'); } 
            set { this.Set (value, 'BSTNK'); }
        }

        @AuraEnabled public Date CreateDate
        {
            get { return this.getDate ('ERDAT'); } 
            set { this.Set (value, 'ERDAT'); }
        }

        @AuraEnabled public String SalesDocumentType
        {
            get { return this.getString ('AUART'); } 
            set { this.Set (value, 'AUART'); }
        }

        @AuraEnabled public String SalesDocumentTypeDescription
        {
            get { return this.getString ('AUART_TEXT'); } 
            set { this.Set (value, 'AUART_TEXT'); }
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

        @AuraEnabled public String SoldToCity
        {
            get { return this.getString ('KUNAG_CITY1'); } 
            set { this.Set (value, 'KUNAG_CITY1'); }
        }

        @AuraEnabled public String SoldToRegion
        {
            get { return this.getString ('KUNAG_REGION'); } 
            set { this.Set (value, 'KUNAG_REGION'); }
        }

        @AuraEnabled public String SoldToRegionDescription
        {
            get { return this.getString ('KUNAG_REGION_BEZEI'); } 
            set { this.Set (value, 'KUNAG_REGION_BEZEI'); }
        }

        @AuraEnabled public String SoldToCountry
        {
            get { return this.getString ('KUNAG_COUNTRY'); } 
            set { this.Set (value, 'KUNAG_COUNTRY'); }
        }

        @AuraEnabled public String SoldToCountryDescription
        {
            get { return this.getString ('KUNAG_COUNTRY_LANDX'); } 
            set { this.Set (value, 'KUNAG_COUNTRY_LANDX'); }
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

        @AuraEnabled public String ShipToCity
        {
            get { return this.getString ('KUNWE_CITY1'); } 
            set { this.Set (value, 'KUNWE_CITY1'); }
        }

        @AuraEnabled public String ShipToRegion
        {
            get { return this.getString ('KUNWE_REGION'); } 
            set { this.Set (value, 'KUNWE_REGION'); }
        }

        @AuraEnabled public String ShipToRegionDescription
        {
            get { return this.getString ('KUNWE_REGION_BEZEI'); } 
            set { this.Set (value, 'KUNWE_REGION_BEZEI'); }
        }

        @AuraEnabled public String ShipToCountry
        {
            get { return this.getString ('KUNWE_COUNTRY'); } 
            set { this.Set (value, 'KUNWE_COUNTRY'); }
        }

        @AuraEnabled public String ShipToCountryDescription
        {
            get { return this.getString ('KUNWE_COUNTRY_LANDX'); } 
            set { this.Set (value, 'KUNWE_COUNTRY_LANDX'); }
        }

        @AuraEnabled public Decimal NetValueInDocumentCurrency
        {
            get { return this.getDecimal ('NETWR'); } 
            set { this.Set (value, 'NETWR'); }
        }

        @AuraEnabled public Decimal TaxAmountInDocumentCurrency
        {
            get { return this.getDecimal ('MWSBP'); } 
            set { this.Set (value, 'MWSBP'); }
        }

        @AuraEnabled public String SDDocumentCurrency
        {
            get { return this.getString ('WAERK'); } 
            set { this.Set (value, 'WAERK'); }
        }

        @AuraEnabled public String OrderStatus
        {
            get { return this.getString ('ORDERSTATUS'); } 
            set { this.Set (value, 'ORDERSTATUS'); }
        }

        @AuraEnabled public String SalesDocumentVersionNumber
        {
            get { return this.getString ('VSNMR_V'); } 
            set { this.Set (value, 'VSNMR_V'); }
        }

        @AuraEnabled public String YourReference
        {
            get { return this.getString ('IHREZ'); } 
            set { this.Set (value, 'IHREZ'); }
        }

        @AuraEnabled public String ShipToPurchaseOrderNumber
        {
            get { return this.getString ('BSTKD_E'); } 
            set { this.Set (value, 'BSTKD_E'); }
        }

        @AuraEnabled public String TransactionGroup
        {
            get { return this.getString ('TRVOG'); } 
            set { this.Set (value, 'TRVOG'); }
        }

        @AuraEnabled public String DeliveryBlock
        {
            get { return this.getString ('LIFSK'); } 
            set { this.Set (value, 'LIFSK'); }
        }

        @AuraEnabled public String DeliveryBlockDescription
        {
            get { return this.getString ('LIFSK_TEXT'); } 
            set { this.Set (value, 'LIFSK_TEXT'); }
        }

        @AuraEnabled public String BillingBlock
        {
            get { return this.getString ('FAKSK'); } 
            set { this.Set (value, 'FAKSK'); }
        }

        @AuraEnabled public String BillingBlockDescription
        {
            get { return this.getString ('FAKSK_TEXT'); } 
            set { this.Set (value, 'FAKSK_TEXT'); }
        }

        @AuraEnabled public String CreditBlock
        {
            get { return this.getString ('CMGST'); } 
            set { this.Set (value, 'CMGST'); }
        }

        @AuraEnabled public String CreditBlockDescription
        {
            get { return this.getString ('CMGST_TEXT'); } 
            set { this.Set (value, 'CMGST_TEXT'); }
        }

        @AuraEnabled public String DeliveryStatus
        {
            get { return this.getString ('DLVSTS'); } 
            set { this.Set (value, 'DLVSTS'); }
        }

        @AuraEnabled public String DeliveryStatusDescription
        {
            get { return this.getString ('DLVSTS_TEXT'); } 
            set { this.Set (value, 'DLVSTS_TEXT'); }
        }

        @AuraEnabled public Decimal TotalQuantity
        {
            get { return this.getDecimal ('TOTQTY'); } 
            set { this.Set (value, 'TOTQTY'); }
        }

        @AuraEnabled public Decimal GoodsIssuedQuantity
        {
            get { return this.getDecimal ('PGIQTY'); } 
            set { this.Set (value, 'PGIQTY'); }
        }

        @AuraEnabled public Date LastChangedDate
        {
            get { return this.getDate ('AEDAT'); } 
            set { this.Set (value, 'AEDAT'); }
        }

        @AuraEnabled public Date StartDate
        {
            get { return this.getDate ('VBEGDAT'); } 
            set { this.Set (value, 'VBEGDAT'); }
        }

        @AuraEnabled public Date EndDate
        {
            get { return this.getDate ('VENDDAT'); } 
            set { this.Set (value, 'VENDDAT'); }
        }

        @AuraEnabled public String CUSTOM01
        {
            get { return this.getString ('CUSTOM01'); } 
            set { this.Set (value, 'CUSTOM01'); }
        }

        @AuraEnabled public String CUSTOM02
        {
            get { return this.getString ('CUSTOM02'); } 
            set { this.Set (value, 'CUSTOM02'); }
        }

        @AuraEnabled public String CUSTOM03
        {
            get { return this.getString ('CUSTOM03'); } 
            set { this.Set (value, 'CUSTOM03'); }
        }

        @AuraEnabled public String CUSTOM04
        {
            get { return this.getString ('CUSTOM04'); } 
            set { this.Set (value, 'CUSTOM04'); }
        }

        @AuraEnabled public String CUSTOM05
        {
            get { return this.getString ('CUSTOM05'); } 
            set { this.Set (value, 'CUSTOM05'); }
        }

        @AuraEnabled public String CUSTOM06
        {
            get { return this.getString ('CUSTOM06'); } 
            set { this.Set (value, 'CUSTOM06'); }
        }

        @AuraEnabled public String CUSTOM07
        {
            get { return this.getString ('CUSTOM07'); } 
            set { this.Set (value, 'CUSTOM07'); }
        }

        @AuraEnabled public String CUSTOM08
        {
            get { return this.getString ('CUSTOM08'); } 
            set { this.Set (value, 'CUSTOM08'); }
        }

        @AuraEnabled public String CUSTOM09
        {
            get { return this.getString ('CUSTOM09'); } 
            set { this.Set (value, 'CUSTOM09'); }
        }

        @AuraEnabled public String CUSTOM10
        {
            get { return this.getString ('CUSTOM10'); } 
            set { this.Set (value, 'CUSTOM10'); }
        }

        @AuraEnabled public Integer TotalItems
        {
            get { return this.getInteger ('TOTIT'); } 
            set { this.Set (value, 'TOTIT'); }
        }

    }

    global class SEARCHRESULT_COLLECTION extends ensxsdk.EnosixFramework.FrameworkCollection
    {
        global SEARCHRESULT_COLLECTION()
        {
            super('SEARCHRESULT', ensxtx_SBO_SFCISalesDocument_Search.SEARCHRESULT.class, null);
        }

        public List<ensxtx_SBO_SFCISalesDocument_Search.SEARCHRESULT> getAsList()
        {
            return (List<ensxtx_SBO_SFCISalesDocument_Search.SEARCHRESULT>)this.buildList(List<ensxtx_SBO_SFCISalesDocument_Search.SEARCHRESULT>.class);
        }
    }


}