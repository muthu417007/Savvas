/// enosiX Inc. Generated Apex Model
/// Generated On: 5/16/2024 8:25:29 PM
/// SAP Host: From REST Service On: https://savvas--dev3.sandbox.my.salesforce.com
/// CID: From REST Service On: https://savvas--dev3.sandbox.my.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework ensxapp.v1.2

global with sharing class ensxtx_SBO_SFCIDelivery_Search extends ensxsdk.EnosixFramework.SearchSBO 
{
        static void registerReflectionInfo()
    {
        ensxsdk.EnosixFramework.registerReflectionResource('ensxtx_SBO_SFCIDelivery_Search_Meta', new Type[] {
            ensxtx_SBO_SFCIDelivery_Search.SFCIDelivery_SC.class
            , ensxtx_SBO_SFCIDelivery_Search.SFCIDelivery_SR.class
            , ensxtx_SBO_SFCIDelivery_Search.SEARCHRESULT.class
            , ensxtx_SBO_SFCIDelivery_Search.SEARCHPARAMS.class
            , ensxtx_SBO_SFCIDelivery_Search.DELIVERYTYPE.class
            , ensxtx_SBO_SFCIDelivery_Search.CUSTOM.class
            , ensxtx_SBO_SFCIDelivery_Search.SEARCHRESULT.class
            } 
        );
    }

    global ensxtx_SBO_SFCIDelivery_Search() 
    {
        super('SFCIDelivery', ensxtx_SBO_SFCIDelivery_Search.SFCIDelivery_SC.class, ensxtx_SBO_SFCIDelivery_Search.SFCIDelivery_SR.class);
    }
    
    public override Type getType() { return ensxtx_SBO_SFCIDelivery_Search.class; }

    public SFCIDelivery_SC search(SFCIDelivery_SC sc) 
    {
        return (SFCIDelivery_SC)super.executeSearch(sc);
    }

    public SFCIDelivery_SC initialize(SFCIDelivery_SC sc) 
    {
        return (SFCIDelivery_SC)super.executeInitialize(sc);
    }

    global class SFCIDelivery_SC extends ensxsdk.EnosixFramework.SearchContext 
    { 		
        global SFCIDelivery_SC() 
        {		
            super(new Map<string,type>		
                {		
                    'SEARCHPARAMS' => ensxtx_SBO_SFCIDelivery_Search.SEARCHPARAMS.class
                    ,'DELIVERYTYPE' => ensxtx_SBO_SFCIDelivery_Search.DELIVERYTYPE_COLLECTION.class
                    ,'CUSTOM' => ensxtx_SBO_SFCIDelivery_Search.CUSTOM_COLLECTION.class		
                });		
        }

        public override Type getType() { return ensxtx_SBO_SFCIDelivery_Search.SFCIDelivery_SC.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCIDelivery_Search.registerReflectionInfo();
        }

        public SFCIDelivery_SR result { get { return (SFCIDelivery_SR)baseResult; } }

        @AuraEnabled public ensxtx_SBO_SFCIDelivery_Search.SEARCHPARAMS SEARCHPARAMS 
        {
            get
            {
                return (ensxtx_SBO_SFCIDelivery_Search.SEARCHPARAMS)this.getStruct(ensxtx_SBO_SFCIDelivery_Search.SEARCHPARAMS.class);
            }
        }
                @AuraEnabled public DELIVERYTYPE_COLLECTION DELIVERYTYPE
        {
            get 
            { 
                return (DELIVERYTYPE_COLLECTION)this.getCollection(ensxtx_SBO_SFCIDelivery_Search.DELIVERYTYPE_COLLECTION.class); 
            }
        }

                @AuraEnabled public CUSTOM_COLLECTION CUSTOM
        {
            get 
            { 
                return (CUSTOM_COLLECTION)this.getCollection(ensxtx_SBO_SFCIDelivery_Search.CUSTOM_COLLECTION.class); 
            }
        }

            }

    global class SFCIDelivery_SR extends ensxsdk.EnosixFramework.SearchResult 
    {
        global SFCIDelivery_SR() 
        {
            super(new Map<string,type>{'SEARCHRESULT' => ensxtx_SBO_SFCIDelivery_Search.SEARCHRESULT.class } );
        }
        
        public ensxsdk.EnosixFramework.FrameworkCollection SearchResults
        {
            get { return super.getCollection(ensxtx_SBO_SFCIDelivery_Search.SEARCHRESULT.class); }
        }
        
        public List<SEARCHRESULT> getResults() 
        {
            List<SEARCHRESULT> results = new List<SEARCHRESULT>();
            SearchResults.copyTo(results);
            return results;
        }

        public override Type getType() { return ensxtx_SBO_SFCIDelivery_Search.SFCIDelivery_SR.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCIDelivery_Search.registerReflectionInfo();
        }
    }

    global class SEARCHPARAMS extends ensxsdk.EnosixFramework.ValueObject 
    {
        global SEARCHPARAMS() { super(); }
        public override Type getType() { return ensxtx_SBO_SFCIDelivery_Search.SEARCHPARAMS.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCIDelivery_Search.registerReflectionInfo();
        }
        @AuraEnabled public String Route
        {
            get { return this.getString ('ROUTE'); } 
            set { this.Set (value, 'ROUTE'); }
        }

        @AuraEnabled public String MeansOfTransportID
        {
            get { return this.getString ('TRAID'); } 
            set { this.Set (value, 'TRAID'); }
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

        @AuraEnabled public Date DeliveryDateFrom
        {
            get { return this.getDate ('LFDAT_FR'); } 
            set { this.Set (value, 'LFDAT_FR'); }
        }

        @AuraEnabled public Date DeliveryDateTo
        {
            get { return this.getDate ('LFDAT_TO'); } 
            set { this.Set (value, 'LFDAT_TO'); }
        }

        @AuraEnabled public String DeliveryFrom
        {
            get { return this.getString ('VBELN_FR'); } 
            set { this.Set (value, 'VBELN_FR'); }
        }

        @AuraEnabled public String DeliveryTo
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

        @AuraEnabled public String ShippingPoint
        {
            get { return this.getString ('VSTEL'); } 
            set { this.Set (value, 'VSTEL'); }
        }

        @AuraEnabled public String ShippingConditions
        {
            get { return this.getString ('VSBED'); } 
            set { this.Set (value, 'VSBED'); }
        }

        @AuraEnabled public String DeliveryPriority
        {
            get { return this.getString ('LPRIO'); } 
            set { this.Set (value, 'LPRIO'); }
        }

        @AuraEnabled public String BillofLading
        {
            get { return this.getString ('BOLNR'); } 
            set { this.Set (value, 'BOLNR'); }
        }

        @AuraEnabled public Date PGIDateFrom
        {
            get { return this.getDate ('WADAT_FR'); } 
            set { this.Set (value, 'WADAT_FR'); }
        }

        @AuraEnabled public Date PGIDateTo
        {
            get { return this.getDate ('WADAT_TO'); } 
            set { this.Set (value, 'WADAT_TO'); }
        }

        @AuraEnabled public String Username
        {
            get { return this.getString ('USERNAME'); } 
            set { this.Set (value, 'USERNAME'); }
        }

        @AuraEnabled public Boolean X_Open
        {
            get { return this.getBoolean('X_OPEN'); } 
            set { this.setBoolean(value, 'X_OPEN'); }
        }

        @AuraEnabled public Boolean X_Picked
        {
            get { return this.getBoolean('X_PICKED'); } 
            set { this.setBoolean(value, 'X_PICKED'); }
        }

        @AuraEnabled public Boolean X_Packed
        {
            get { return this.getBoolean('X_PACKED'); } 
            set { this.setBoolean(value, 'X_PACKED'); }
        }

        @AuraEnabled public Boolean X_PGIed
        {
            get { return this.getBoolean('X_PGIED'); } 
            set { this.setBoolean(value, 'X_PGIED'); }
        }

    }

global class DELIVERYTYPE extends ensxsdk.EnosixFramework.ValueObject 
    {
        global DELIVERYTYPE() { super(); }
        public override Type getType() { return ensxtx_SBO_SFCIDelivery_Search.DELIVERYTYPE.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCIDelivery_Search.registerReflectionInfo();
        }
        @AuraEnabled public String DeliveryType
        {
            get { return this.getString ('LFART'); } 
            set { this.Set (value, 'LFART'); }
        }

    }

    global class DELIVERYTYPE_COLLECTION extends ensxsdk.EnosixFramework.FrameworkCollection
    {
        global DELIVERYTYPE_COLLECTION()
        {
            super('DELIVERYTYPE', ensxtx_SBO_SFCIDelivery_Search.DELIVERYTYPE.class, null);
        }

        public List<ensxtx_SBO_SFCIDelivery_Search.DELIVERYTYPE> getAsList()
        {
            return (List<ensxtx_SBO_SFCIDelivery_Search.DELIVERYTYPE>)this.buildList(List<ensxtx_SBO_SFCIDelivery_Search.DELIVERYTYPE>.class);
        }
    }

global class CUSTOM extends ensxsdk.EnosixFramework.ValueObject 
    {
        global CUSTOM() { super(); }
        public override Type getType() { return ensxtx_SBO_SFCIDelivery_Search.CUSTOM.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCIDelivery_Search.registerReflectionInfo();
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
            super('CUSTOM', ensxtx_SBO_SFCIDelivery_Search.CUSTOM.class, null);
        }

        public List<ensxtx_SBO_SFCIDelivery_Search.CUSTOM> getAsList()
        {
            return (List<ensxtx_SBO_SFCIDelivery_Search.CUSTOM>)this.buildList(List<ensxtx_SBO_SFCIDelivery_Search.CUSTOM>.class);
        }
    }

    global class SEARCHRESULT extends ensxsdk.EnosixFramework.ValueObject 
    {
        global SEARCHRESULT() { super(); }
        public override Type getType() { return ensxtx_SBO_SFCIDelivery_Search.SEARCHRESULT.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCIDelivery_Search.registerReflectionInfo();
        }
        @AuraEnabled public String Delivery
        {
            get { return this.getString ('VBELN'); } 
            set { this.Set (value, 'VBELN'); }
        }

        @AuraEnabled public String Route
        {
            get { return this.getString ('ROUTE'); } 
            set { this.Set (value, 'ROUTE'); }
        }

        @AuraEnabled public String MeansOfTransportID
        {
            get { return this.getString ('TRAID'); } 
            set { this.Set (value, 'TRAID'); }
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

        @AuraEnabled public String ShippingPoint
        {
            get { return this.getString ('VSTEL'); } 
            set { this.Set (value, 'VSTEL'); }
        }

        @AuraEnabled public String ShippingConditions
        {
            get { return this.getString ('VSBED'); } 
            set { this.Set (value, 'VSBED'); }
        }

        @AuraEnabled public String DeliveryPriority
        {
            get { return this.getString ('LPRIO'); } 
            set { this.Set (value, 'LPRIO'); }
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

        @AuraEnabled public String DeliveryStatus
        {
            get { return this.getString ('DELV_STAT'); } 
            set { this.Set (value, 'DELV_STAT'); }
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

    }

    global class SEARCHRESULT_COLLECTION extends ensxsdk.EnosixFramework.FrameworkCollection
    {
        global SEARCHRESULT_COLLECTION()
        {
            super('SEARCHRESULT', ensxtx_SBO_SFCIDelivery_Search.SEARCHRESULT.class, null);
        }

        public List<ensxtx_SBO_SFCIDelivery_Search.SEARCHRESULT> getAsList()
        {
            return (List<ensxtx_SBO_SFCIDelivery_Search.SEARCHRESULT>)this.buildList(List<ensxtx_SBO_SFCIDelivery_Search.SEARCHRESULT>.class);
        }
    }


}