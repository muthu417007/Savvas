/// enosiX Inc. Generated Apex Model
/// Generated On: 9/12/2023 9:30:14 PM
/// SAP Host: From REST Service On: https://computing-computing-1408-dev-ed.scratch.my.salesforce.com
/// CID: From REST Service On: https://computing-computing-1408-dev-ed.scratch.my.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework ensxapp.v1.2

global without sharing class ensxtx_SBO_SFCIMaterialScales_Search extends ensxsdk.EnosixFramework.SearchSBO 
{
        static void registerReflectionInfo()
    {
        ensxsdk.EnosixFramework.registerReflectionResource('ensxtx_SBO_SFCIMaterialScales_Search_Meta', new Type[] {
            ensxtx_SBO_SFCIMaterialScales_Search.SFCIMaterialScales_SC.class
            , ensxtx_SBO_SFCIMaterialScales_Search.SFCIMaterialScales_SR.class
            , ensxtx_SBO_SFCIMaterialScales_Search.SEARCHRESULT.class
            , ensxtx_SBO_SFCIMaterialScales_Search.SEARCHPARAMS.class
            , ensxtx_SBO_SFCIMaterialScales_Search.SEARCHRESULT.class
            } 
        );
    }

    global ensxtx_SBO_SFCIMaterialScales_Search() 
    {
        super('SFCIMaterialScales', ensxtx_SBO_SFCIMaterialScales_Search.SFCIMaterialScales_SC.class, ensxtx_SBO_SFCIMaterialScales_Search.SFCIMaterialScales_SR.class);
    }
    
    public override Type getType() { return ensxtx_SBO_SFCIMaterialScales_Search.class; }

    public SFCIMaterialScales_SC search(SFCIMaterialScales_SC sc) 
    {
        return (SFCIMaterialScales_SC)super.executeSearch(sc);
    }

    public SFCIMaterialScales_SC initialize(SFCIMaterialScales_SC sc) 
    {
        return (SFCIMaterialScales_SC)super.executeInitialize(sc);
    }

    global class SFCIMaterialScales_SC extends ensxsdk.EnosixFramework.SearchContext 
    { 		
        global SFCIMaterialScales_SC() 
        {		
            super(new Map<string,type>		
                {		
                    'SEARCHPARAMS' => ensxtx_SBO_SFCIMaterialScales_Search.SEARCHPARAMS.class		
                });		
        }

        public override Type getType() { return ensxtx_SBO_SFCIMaterialScales_Search.SFCIMaterialScales_SC.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCIMaterialScales_Search.registerReflectionInfo();
        }

        public SFCIMaterialScales_SR result { get { return (SFCIMaterialScales_SR)baseResult; } }

        @AuraEnabled public ensxtx_SBO_SFCIMaterialScales_Search.SEARCHPARAMS SEARCHPARAMS 
        {
            get
            {
                return (ensxtx_SBO_SFCIMaterialScales_Search.SEARCHPARAMS)this.getStruct(ensxtx_SBO_SFCIMaterialScales_Search.SEARCHPARAMS.class);
            }
        }
            }

    global class SFCIMaterialScales_SR extends ensxsdk.EnosixFramework.SearchResult 
    {
        global SFCIMaterialScales_SR() 
        {
            super(new Map<string,type>{'SEARCHRESULT' => ensxtx_SBO_SFCIMaterialScales_Search.SEARCHRESULT.class } );
        }
        
        public ensxsdk.EnosixFramework.FrameworkCollection SearchResults
        {
            get { return super.getCollection(ensxtx_SBO_SFCIMaterialScales_Search.SEARCHRESULT.class); }
        }
        
        public List<SEARCHRESULT> getResults() 
        {
            List<SEARCHRESULT> results = new List<SEARCHRESULT>();
            SearchResults.copyTo(results);
            return results;
        }

        public override Type getType() { return ensxtx_SBO_SFCIMaterialScales_Search.SFCIMaterialScales_SR.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCIMaterialScales_Search.registerReflectionInfo();
        }
    }

    global class SEARCHPARAMS extends ensxsdk.EnosixFramework.ValueObject 
    {
        global SEARCHPARAMS() { super(); }
        public override Type getType() { return ensxtx_SBO_SFCIMaterialScales_Search.SEARCHPARAMS.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCIMaterialScales_Search.registerReflectionInfo();
        }
        @AuraEnabled public String SalesOrganization
        {
            get { return this.getString ('VKORG'); } 
            set { this.Set (value, 'VKORG'); }
        }

        @AuraEnabled public String DistributionChannel
        {
            get { return this.getString ('VTWEG'); } 
            set { this.Set (value, 'VTWEG'); }
        }

        @AuraEnabled public String Division
        {
            get { return this.getString ('SPART'); } 
            set { this.Set (value, 'SPART'); }
        }

        @AuraEnabled public String SalesDocumentType
        {
            get { return this.getString ('AUART'); } 
            set { this.Set (value, 'AUART'); }
        }

        @AuraEnabled public String Material
        {
            get { return this.getString ('MATNR'); } 
            set { this.Set (value, 'MATNR'); }
        }

        @AuraEnabled public String CustomerNumber
        {
            get { return this.getString ('KUNNR'); } 
            set { this.Set (value, 'KUNNR'); }
        }

        @AuraEnabled public String ConditionType
        {
            get { return this.getString ('KSCHL'); } 
            set { this.Set (value, 'KSCHL'); }
        }

        @AuraEnabled public String SalesUnit
        {
            get { return this.getString ('VRKME'); } 
            set { this.Set (value, 'VRKME'); }
        }

    }

    global class SEARCHRESULT extends ensxsdk.EnosixFramework.ValueObject 
    {
        global SEARCHRESULT() { super(); }
        public override Type getType() { return ensxtx_SBO_SFCIMaterialScales_Search.SEARCHRESULT.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCIMaterialScales_Search.registerReflectionInfo();
        }
        @AuraEnabled public String ConditionNumber
        {
            get { return this.getString ('KNUMH'); } 
            set { this.Set (value, 'KNUMH'); }
        }

        @AuraEnabled public String SequenceNumber
        {
            get { return this.getString ('KLFN1'); } 
            set { this.Set (value, 'KLFN1'); }
        }

        @AuraEnabled public Decimal FromValue
        {
            get { return this.getDecimal ('FRQTY'); } 
            set { this.Set (value, 'FRQTY'); }
        }

        @AuraEnabled public Decimal ToValue
        {
            get { return this.getDecimal ('TOQTY'); } 
            set { this.Set (value, 'TOQTY'); }
        }

        @AuraEnabled public String ConditionUnit
        {
            get { return this.getString ('KMEIN'); } 
            set { this.Set (value, 'KMEIN'); }
        }

        @AuraEnabled public Decimal Rate
        {
            get { return this.getDecimal ('KBETR'); } 
            set { this.Set (value, 'KBETR'); }
        }

        @AuraEnabled public String FieldCurrency
        {
            get { return this.getString ('KONWA'); } 
            set { this.Set (value, 'KONWA'); }
        }

    }

    global class SEARCHRESULT_COLLECTION extends ensxsdk.EnosixFramework.FrameworkCollection
    {
        global SEARCHRESULT_COLLECTION()
        {
            super('SEARCHRESULT', ensxtx_SBO_SFCIMaterialScales_Search.SEARCHRESULT.class, null);
        }

        public List<ensxtx_SBO_SFCIMaterialScales_Search.SEARCHRESULT> getAsList()
        {
            return (List<ensxtx_SBO_SFCIMaterialScales_Search.SEARCHRESULT>)this.buildList(List<ensxtx_SBO_SFCIMaterialScales_Search.SEARCHRESULT>.class);
        }
    }


}