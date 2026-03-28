/// enosiX Inc. Generated Apex Model
/// Generated On: 8/28/2023 1:35:03 PM
/// SAP Host: From REST Service On: https://site-platform-5752-dev-ed.scratch.my.salesforce.com
/// CID: From REST Service On: https://site-platform-5752-dev-ed.scratch.my.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework ensxapp.v1.2

public with sharing class ensxtx_SBO_SFCISalesDocOutput_Search extends ensxsdk.EnosixFramework.SearchSBO 
{
        static void registerReflectionInfo()
    {
        ensxsdk.EnosixFramework.registerReflectionResource('ensxtx_SBO_SFCISalesDocOutput_Search_Meta', new Type[] {
            ensxtx_SBO_SFCISalesDocOutput_Search.SFCISalesDocOutput_SC.class
            , ensxtx_SBO_SFCISalesDocOutput_Search.SFCISalesDocOutput_SR.class
            , ensxtx_SBO_SFCISalesDocOutput_Search.SEARCHRESULT.class
            , ensxtx_SBO_SFCISalesDocOutput_Search.SEARCHPARAMS.class
            , ensxtx_SBO_SFCISalesDocOutput_Search.OUTPUT_TYPE.class
            , ensxtx_SBO_SFCISalesDocOutput_Search.SEARCHRESULT.class
            } 
        );
    }

    public ensxtx_SBO_SFCISalesDocOutput_Search() 
    {
        super('SFCISalesDocOutput', ensxtx_SBO_SFCISalesDocOutput_Search.SFCISalesDocOutput_SC.class, ensxtx_SBO_SFCISalesDocOutput_Search.SFCISalesDocOutput_SR.class);
    }
    
    public override Type getType() { return ensxtx_SBO_SFCISalesDocOutput_Search.class; }

    public SFCISalesDocOutput_SC search(SFCISalesDocOutput_SC sc) 
    {
        return (SFCISalesDocOutput_SC)super.executeSearch(sc);
    }

    public SFCISalesDocOutput_SC initialize(SFCISalesDocOutput_SC sc) 
    {
        return (SFCISalesDocOutput_SC)super.executeInitialize(sc);
    }

    public class SFCISalesDocOutput_SC extends ensxsdk.EnosixFramework.SearchContext 
    { 		
        public SFCISalesDocOutput_SC() 
        {		
            super(new Map<string,type>		
                {		
                    'SEARCHPARAMS' => ensxtx_SBO_SFCISalesDocOutput_Search.SEARCHPARAMS.class
                    ,'OUTPUT_TYPE' => ensxtx_SBO_SFCISalesDocOutput_Search.OUTPUT_TYPE_COLLECTION.class		
                });		
        }

        public override Type getType() { return ensxtx_SBO_SFCISalesDocOutput_Search.SFCISalesDocOutput_SC.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCISalesDocOutput_Search.registerReflectionInfo();
        }

        public SFCISalesDocOutput_SR result { get { return (SFCISalesDocOutput_SR)baseResult; } }

        @AuraEnabled public ensxtx_SBO_SFCISalesDocOutput_Search.SEARCHPARAMS SEARCHPARAMS 
        {
            get
            {
                return (ensxtx_SBO_SFCISalesDocOutput_Search.SEARCHPARAMS)this.getStruct(ensxtx_SBO_SFCISalesDocOutput_Search.SEARCHPARAMS.class);
            }
        }
                @AuraEnabled public OUTPUT_TYPE_COLLECTION OUTPUT_TYPE
        {
            get 
            { 
                return (OUTPUT_TYPE_COLLECTION)this.getCollection(ensxtx_SBO_SFCISalesDocOutput_Search.OUTPUT_TYPE_COLLECTION.class); 
            }
        }

            }

    public class SFCISalesDocOutput_SR extends ensxsdk.EnosixFramework.SearchResult 
    {
        public SFCISalesDocOutput_SR() 
        {
            super(new Map<string,type>{'SEARCHRESULT' => ensxtx_SBO_SFCISalesDocOutput_Search.SEARCHRESULT.class } );
        }
        
        public ensxsdk.EnosixFramework.FrameworkCollection SearchResults
        {
            get { return super.getCollection(ensxtx_SBO_SFCISalesDocOutput_Search.SEARCHRESULT.class); }
        }
        
        public List<SEARCHRESULT> getResults() 
        {
            List<SEARCHRESULT> results = new List<SEARCHRESULT>();
            SearchResults.copyTo(results);
            return results;
        }

        public override Type getType() { return ensxtx_SBO_SFCISalesDocOutput_Search.SFCISalesDocOutput_SR.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCISalesDocOutput_Search.registerReflectionInfo();
        }
    }

    public class SEARCHPARAMS extends ensxsdk.EnosixFramework.ValueObject 
    {
        public override Type getType() { return ensxtx_SBO_SFCISalesDocOutput_Search.SEARCHPARAMS.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCISalesDocOutput_Search.registerReflectionInfo();
        }
        @AuraEnabled public String SalesDocument
        {
            get { return this.getString ('VBELN'); } 
            set { this.Set (value, 'VBELN'); }
        }

        @AuraEnabled public String OutputApplication
        {
            get { return this.getString ('KAPPL'); } 
            set { this.Set (value, 'KAPPL'); }
        }

    }

public class OUTPUT_TYPE extends ensxsdk.EnosixFramework.ValueObject 
    {
        public override Type getType() { return ensxtx_SBO_SFCISalesDocOutput_Search.OUTPUT_TYPE.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCISalesDocOutput_Search.registerReflectionInfo();
        }
        @AuraEnabled public String ConditionType
        {
            get { return this.getString ('KSCHL'); } 
            set { this.Set (value, 'KSCHL'); }
        }

        @AuraEnabled public Boolean X_GetPDF
        {
            get { return this.getBoolean('X_GET_PDF'); } 
            set { this.setBoolean(value, 'X_GET_PDF'); }
        }

    }

    public class OUTPUT_TYPE_COLLECTION extends ensxsdk.EnosixFramework.FrameworkCollection
    {
        public OUTPUT_TYPE_COLLECTION()
        {
            super('OUTPUT_TYPE', ensxtx_SBO_SFCISalesDocOutput_Search.OUTPUT_TYPE.class, null);
        }

        public List<ensxtx_SBO_SFCISalesDocOutput_Search.OUTPUT_TYPE> getAsList()
        {
            return (List<ensxtx_SBO_SFCISalesDocOutput_Search.OUTPUT_TYPE>)this.buildList(List<ensxtx_SBO_SFCISalesDocOutput_Search.OUTPUT_TYPE>.class);
        }
    }

    public class SEARCHRESULT extends ensxsdk.EnosixFramework.ValueObject 
    {
        public override Type getType() { return ensxtx_SBO_SFCISalesDocOutput_Search.SEARCHRESULT.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_SFCISalesDocOutput_Search.registerReflectionInfo();
        }
        @AuraEnabled public String SalesDocument
        {
            get { return this.getString ('VBELN'); } 
            set { this.Set (value, 'VBELN'); }
        }

        @AuraEnabled public String ConditionType
        {
            get { return this.getString ('KSCHL'); } 
            set { this.Set (value, 'KSCHL'); }
        }

        @AuraEnabled public String ConditionTypeDescription
        {
            get { return this.getString ('KSCHL_TEXT'); } 
            set { this.Set (value, 'KSCHL_TEXT'); }
        }

        @AuraEnabled public String Language
        {
            get { return this.getString ('SPRAS'); } 
            set { this.Set (value, 'SPRAS'); }
        }

        @AuraEnabled public String PDF_B64STR
        {
            get { return this.getString ('PDF_B64STR'); } 
            set { this.Set (value, 'PDF_B64STR'); }
        }

    }

    public class SEARCHRESULT_COLLECTION extends ensxsdk.EnosixFramework.FrameworkCollection
    {
        public SEARCHRESULT_COLLECTION()
        {
            super('SEARCHRESULT', ensxtx_SBO_SFCISalesDocOutput_Search.SEARCHRESULT.class, null);
        }

        public List<ensxtx_SBO_SFCISalesDocOutput_Search.SEARCHRESULT> getAsList()
        {
            return (List<ensxtx_SBO_SFCISalesDocOutput_Search.SEARCHRESULT>)this.buildList(List<ensxtx_SBO_SFCISalesDocOutput_Search.SEARCHRESULT>.class);
        }
    }


}