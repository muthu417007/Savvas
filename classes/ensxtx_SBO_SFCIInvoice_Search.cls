/// enosiX Inc. Generated Apex Model
/// Generated On: 5/16/2024 8:41:41 PM
/// SAP Host: From REST Service On: https://savvas--dev3.sandbox.my.salesforce.com
/// CID: From REST Service On: https://savvas--dev3.sandbox.my.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework ensxapp.v1.2

global with sharing class ensxtx_SBO_SFCIInvoice_Search extends ensxsdk.EnosixFramework.SearchSBO 
{
        static void registerReflectionInfo()
    {
        ensxsdk.EnosixFramework.registerReflectionResource('ensxtx_SBO_SFCIInvoice_Search_Meta', new Type[] {
            ensxtx_SBO_SFCIInvoice_Search.SFCIInvoice_SC.class
            , ensxtx_SBO_SFCIInvoice_Search.SFCIInvoice_SR.class
            , ensxtx_SBO_SFCIInvoice_Search.SEARCHRESULT.class
            , ensxtx_SBO_SFCIInvoice_Search.SEARCHPARAMS.class
            , ensxtx_SBO_SFCIInvoice_Search.BILLINGTYPE.class
            , ensxtx_SBO_SFCIInvoice_Search.CUSTOM.class
            , ensxtx_SBO_SFCIInvoice_Search.SEARCHRESULT.class
            } 
        );
    }

    global ensxtx_SBO_SFCIInvoice_Search() 
    {
        super('SFCIInvoice', ensxtx_SBO_SFCIInvoice_Search.SFCIInvoice_SC.class, ensxtx_SBO_SFCIInvoice_Search.SFCIInvoice_SR.class);
    }
    
    public override Type getType() { return ensxtx_SBO_SFCIInvoice_Search.class; }

    public SFCIInvoice_SC search(SFCIInvoice_SC sc) 
    {
        return (SFCIInvoice_SC)super.executeSearch(sc);
    }

    public SFCIInvoice_SC initialize(SFCIInvoice_SC sc) 
    {
        return (SFCIInvoice_SC)super.executeInitialize(sc);
    }

    global class SFCIInvoice_SC extends ensxsdk.EnosixFramework.SearchContext 
    { 		
        global SFCIInvoice_SC() 
        {		
            super(new Map<string,type>		
                {		
                    'SEARCHPARAMS' => ensxtx_SBO_SFCIInvoice_Search.SEARCHPARAMS.class
                    ,'BILLINGTYPE' => ensxtx_SBO_SFCIInvoice_Search.BILLINGTYPE_COLLECTION.class
                    ,'CUSTOM' => ensxtx_SBO_SFCIInvoice_Search.CUSTOM_COLLECTION.class		
                });		
        }

        public override Type getType() { return ensxtx_SBO_SFCIInvoice_Search.SFCIInvoice_SC.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCIInvoice_Search.registerReflectionInfo();
        }

        public SFCIInvoice_SR result { get { return (SFCIInvoice_SR)baseResult; } }

        @AuraEnabled public ensxtx_SBO_SFCIInvoice_Search.SEARCHPARAMS SEARCHPARAMS 
        {
            get
            {
                return (ensxtx_SBO_SFCIInvoice_Search.SEARCHPARAMS)this.getStruct(ensxtx_SBO_SFCIInvoice_Search.SEARCHPARAMS.class);
            }
        }
                @AuraEnabled public BILLINGTYPE_COLLECTION BILLINGTYPE
        {
            get 
            { 
                return (BILLINGTYPE_COLLECTION)this.getCollection(ensxtx_SBO_SFCIInvoice_Search.BILLINGTYPE_COLLECTION.class); 
            }
        }

                @AuraEnabled public CUSTOM_COLLECTION CUSTOM
        {
            get 
            { 
                return (CUSTOM_COLLECTION)this.getCollection(ensxtx_SBO_SFCIInvoice_Search.CUSTOM_COLLECTION.class); 
            }
        }

            }

    global class SFCIInvoice_SR extends ensxsdk.EnosixFramework.SearchResult 
    {
        global SFCIInvoice_SR() 
        {
            super(new Map<string,type>{'SEARCHRESULT' => ensxtx_SBO_SFCIInvoice_Search.SEARCHRESULT.class } );
        }
        
        public ensxsdk.EnosixFramework.FrameworkCollection SearchResults
        {
            get { return super.getCollection(ensxtx_SBO_SFCIInvoice_Search.SEARCHRESULT.class); }
        }
        
        public List<SEARCHRESULT> getResults() 
        {
            List<SEARCHRESULT> results = new List<SEARCHRESULT>();
            SearchResults.copyTo(results);
            return results;
        }

        public override Type getType() { return ensxtx_SBO_SFCIInvoice_Search.SFCIInvoice_SR.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCIInvoice_Search.registerReflectionInfo();
        }
    }

    global class SEARCHPARAMS extends ensxsdk.EnosixFramework.ValueObject 
    {
        global SEARCHPARAMS() { super(); }
        public override Type getType() { return ensxtx_SBO_SFCIInvoice_Search.SEARCHPARAMS.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCIInvoice_Search.registerReflectionInfo();
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

        @AuraEnabled public String SalesOrganization
        {
            get { return this.getString ('VKORG'); } 
            set { this.Set (value, 'VKORG'); }
        }

        @AuraEnabled public String Payer
        {
            get { return this.getString ('KUNRG'); } 
            set { this.Set (value, 'KUNRG'); }
        }

        @AuraEnabled public String SoldToParty
        {
            get { return this.getString ('KUNAG'); } 
            set { this.Set (value, 'KUNAG'); }
        }

        @AuraEnabled public Date BillingDateFrom
        {
            get { return this.getDate ('FKDAT_FR'); } 
            set { this.Set (value, 'FKDAT_FR'); }
        }

        @AuraEnabled public Date BillingDateTo
        {
            get { return this.getDate ('FKDAT_TO'); } 
            set { this.Set (value, 'FKDAT_TO'); }
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

        @AuraEnabled public String CreatedBy
        {
            get { return this.getString ('ERNAM'); } 
            set { this.Set (value, 'ERNAM'); }
        }

    }

global class BILLINGTYPE extends ensxsdk.EnosixFramework.ValueObject 
    {
        global BILLINGTYPE() { super(); }
        public override Type getType() { return ensxtx_SBO_SFCIInvoice_Search.BILLINGTYPE.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCIInvoice_Search.registerReflectionInfo();
        }
        @AuraEnabled public String BillingType
        {
            get { return this.getString ('FKART'); } 
            set { this.Set (value, 'FKART'); }
        }

    }

    global class BILLINGTYPE_COLLECTION extends ensxsdk.EnosixFramework.FrameworkCollection
    {
        global BILLINGTYPE_COLLECTION()
        {
            super('BILLINGTYPE', ensxtx_SBO_SFCIInvoice_Search.BILLINGTYPE.class, null);
        }

        public List<ensxtx_SBO_SFCIInvoice_Search.BILLINGTYPE> getAsList()
        {
            return (List<ensxtx_SBO_SFCIInvoice_Search.BILLINGTYPE>)this.buildList(List<ensxtx_SBO_SFCIInvoice_Search.BILLINGTYPE>.class);
        }
    }

global class CUSTOM extends ensxsdk.EnosixFramework.ValueObject 
    {
        global CUSTOM() { super(); }
        public override Type getType() { return ensxtx_SBO_SFCIInvoice_Search.CUSTOM.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCIInvoice_Search.registerReflectionInfo();
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
            super('CUSTOM', ensxtx_SBO_SFCIInvoice_Search.CUSTOM.class, null);
        }

        public List<ensxtx_SBO_SFCIInvoice_Search.CUSTOM> getAsList()
        {
            return (List<ensxtx_SBO_SFCIInvoice_Search.CUSTOM>)this.buildList(List<ensxtx_SBO_SFCIInvoice_Search.CUSTOM>.class);
        }
    }

    global class SEARCHRESULT extends ensxsdk.EnosixFramework.ValueObject 
    {
        global SEARCHRESULT() { super(); }
        public override Type getType() { return ensxtx_SBO_SFCIInvoice_Search.SEARCHRESULT.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCIInvoice_Search.registerReflectionInfo();
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
            super('SEARCHRESULT', ensxtx_SBO_SFCIInvoice_Search.SEARCHRESULT.class, null);
        }

        public List<ensxtx_SBO_SFCIInvoice_Search.SEARCHRESULT> getAsList()
        {
            return (List<ensxtx_SBO_SFCIInvoice_Search.SEARCHRESULT>)this.buildList(List<ensxtx_SBO_SFCIInvoice_Search.SEARCHRESULT>.class);
        }
    }


}