/// enosiX Inc. Generated Apex Model
/// Generated On: 4/19/2024 4:25:22 PM
/// SAP Host: From REST Service On: https://savvas--dev3.sandbox.my.salesforce.com
/// CID: From REST Service On: https://savvas--dev3.sandbox.my.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework ensxapp.v1.2

global with sharing class ensxtx_SBO_SFCISalesDocFlow_Search extends ensxsdk.EnosixFramework.SearchSBO 
{
        static void registerReflectionInfo()
    {
        ensxsdk.EnosixFramework.registerReflectionResource('ensxtx_SBO_SFCISalesDocFlow_Search_Meta', new Type[] {
            ensxtx_SBO_SFCISalesDocFlow_Search.SFCISalesDocFlow_SC.class
            , ensxtx_SBO_SFCISalesDocFlow_Search.SFCISalesDocFlow_SR.class
            , ensxtx_SBO_SFCISalesDocFlow_Search.SEARCHRESULT.class
            , ensxtx_SBO_SFCISalesDocFlow_Search.SEARCHPARAMS.class
            , ensxtx_SBO_SFCISalesDocFlow_Search.SEARCHRESULT.class
            } 
        );
    }

    global ensxtx_SBO_SFCISalesDocFlow_Search() 
    {
        super('SFCISalesDocFlow', ensxtx_SBO_SFCISalesDocFlow_Search.SFCISalesDocFlow_SC.class, ensxtx_SBO_SFCISalesDocFlow_Search.SFCISalesDocFlow_SR.class);
    }
    
    public override Type getType() { return ensxtx_SBO_SFCISalesDocFlow_Search.class; }

    public SFCISalesDocFlow_SC search(SFCISalesDocFlow_SC sc) 
    {
        return (SFCISalesDocFlow_SC)super.executeSearch(sc);
    }

    public SFCISalesDocFlow_SC initialize(SFCISalesDocFlow_SC sc) 
    {
        return (SFCISalesDocFlow_SC)super.executeInitialize(sc);
    }

    global class SFCISalesDocFlow_SC extends ensxsdk.EnosixFramework.SearchContext 
    { 		
        global SFCISalesDocFlow_SC() 
        {		
            super(new Map<string,type>		
                {		
                    'SEARCHPARAMS' => ensxtx_SBO_SFCISalesDocFlow_Search.SEARCHPARAMS.class		
                });		
        }

        public override Type getType() { return ensxtx_SBO_SFCISalesDocFlow_Search.SFCISalesDocFlow_SC.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCISalesDocFlow_Search.registerReflectionInfo();
        }

        public SFCISalesDocFlow_SR result { get { return (SFCISalesDocFlow_SR)baseResult; } }

        @AuraEnabled public ensxtx_SBO_SFCISalesDocFlow_Search.SEARCHPARAMS SEARCHPARAMS 
        {
            get
            {
                return (ensxtx_SBO_SFCISalesDocFlow_Search.SEARCHPARAMS)this.getStruct(ensxtx_SBO_SFCISalesDocFlow_Search.SEARCHPARAMS.class);
            }
        }
            }

    global class SFCISalesDocFlow_SR extends ensxsdk.EnosixFramework.SearchResult 
    {
        global SFCISalesDocFlow_SR() 
        {
            super(new Map<string,type>{'SEARCHRESULT' => ensxtx_SBO_SFCISalesDocFlow_Search.SEARCHRESULT.class } );
        }
        
        public ensxsdk.EnosixFramework.FrameworkCollection SearchResults
        {
            get { return super.getCollection(ensxtx_SBO_SFCISalesDocFlow_Search.SEARCHRESULT.class); }
        }
        
        public List<SEARCHRESULT> getResults() 
        {
            List<SEARCHRESULT> results = new List<SEARCHRESULT>();
            SearchResults.copyTo(results);
            return results;
        }

        public override Type getType() { return ensxtx_SBO_SFCISalesDocFlow_Search.SFCISalesDocFlow_SR.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCISalesDocFlow_Search.registerReflectionInfo();
        }
    }

    global class SEARCHPARAMS extends ensxsdk.EnosixFramework.ValueObject 
    {
        global SEARCHPARAMS() { super(); }
        public override Type getType() { return ensxtx_SBO_SFCISalesDocFlow_Search.SEARCHPARAMS.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCISalesDocFlow_Search.registerReflectionInfo();
        }
        @AuraEnabled public String SalesDocument
        {
            get { return this.getString ('VBELN'); } 
            set { this.Set (value, 'VBELN'); }
        }

        @AuraEnabled public String ItemNumber
        {
            get { return this.getString ('POSNR'); } 
            set { this.Set (value, 'POSNR'); }
        }

    }

    global class SEARCHRESULT extends ensxsdk.EnosixFramework.ValueObject 
    {
        global SEARCHRESULT() { super(); }
        public override Type getType() { return ensxtx_SBO_SFCISalesDocFlow_Search.SEARCHRESULT.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCISalesDocFlow_Search.registerReflectionInfo();
        }
        @AuraEnabled public String SalesDocument
        {
            get { return this.getString ('VBELN'); } 
            set { this.Set (value, 'VBELN'); }
        }

        @AuraEnabled public String ItemNumber
        {
            get { return this.getString ('POSNR'); } 
            set { this.Set (value, 'POSNR'); }
        }

        @AuraEnabled public String DocumentCategory
        {
            get { return this.getString ('VBTYP'); } 
            set { this.Set (value, 'VBTYP'); }
        }

        @AuraEnabled public String DocumentCategoryText
        {
            get { return this.getString ('VBTYP_TEXT'); } 
            set { this.Set (value, 'VBTYP_TEXT'); }
        }

        @AuraEnabled public String OriginatingDocument
        {
            get { return this.getString ('DOCNUV'); } 
            set { this.Set (value, 'DOCNUV'); }
        }

        @AuraEnabled public String OriginatingItem
        {
            get { return this.getString ('ITEMNUV'); } 
            set { this.Set (value, 'ITEMNUV'); }
        }

        @AuraEnabled public Integer HierarchyLevel
        {
            get { return this.getInteger ('HLEVEL'); } 
            set { this.Set (value, 'HLEVEL'); }
        }

        @AuraEnabled public String CustomerNumber
        {
            get { return this.getString ('KUNNR'); } 
            set { this.Set (value, 'KUNNR'); }
        }

        @AuraEnabled public Date CreateDate
        {
            get { return this.getDate ('ERDAT'); } 
            set { this.Set (value, 'ERDAT'); }
        }

        @AuraEnabled public String CreatedBy
        {
            get { return this.getString ('ERNAM'); } 
            set { this.Set (value, 'ERNAM'); }
        }

        @AuraEnabled public Date DateChanged
        {
            get { return this.getDate ('AEDAT'); } 
            set { this.Set (value, 'AEDAT'); }
        }

        @AuraEnabled public String ChangedBy
        {
            get { return this.getString ('AENAM'); } 
            set { this.Set (value, 'AENAM'); }
        }

        @AuraEnabled public String DocumentStatus
        {
            get { return this.getString ('STATUS'); } 
            set { this.Set (value, 'STATUS'); }
        }

    }

    global class SEARCHRESULT_COLLECTION extends ensxsdk.EnosixFramework.FrameworkCollection
    {
        global SEARCHRESULT_COLLECTION()
        {
            super('SEARCHRESULT', ensxtx_SBO_SFCISalesDocFlow_Search.SEARCHRESULT.class, null);
        }

        public List<ensxtx_SBO_SFCISalesDocFlow_Search.SEARCHRESULT> getAsList()
        {
            return (List<ensxtx_SBO_SFCISalesDocFlow_Search.SEARCHRESULT>)this.buildList(List<ensxtx_SBO_SFCISalesDocFlow_Search.SEARCHRESULT>.class);
        }
    }


}