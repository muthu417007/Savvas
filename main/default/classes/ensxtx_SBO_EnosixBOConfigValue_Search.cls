/// enosiX Inc. Generated Apex Model
/// Generated On: 5/17/2022 9:38:35 AM
/// SAP Host: From REST Service On: https://ability-customization-5216-dev-ed.cs90.my.salesforce.com
/// CID: From REST Service On: https://ability-customization-5216-dev-ed.cs90.my.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework ensxapp.v1.2

public with sharing class ensxtx_SBO_EnosixBOConfigValue_Search extends ensxsdk.EnosixFramework.SearchSBO 
{
        static void registerReflectionInfo()
    {
        ensxsdk.EnosixFramework.registerReflectionResource('ensxtx_SBO_EnosixBOConfigValue_Search_Meta', new Type[] {
            ensxtx_SBO_EnosixBOConfigValue_Search.EnosixBOConfigValue_SC.class
            , ensxtx_SBO_EnosixBOConfigValue_Search.EnosixBOConfigValue_SR.class
            , ensxtx_SBO_EnosixBOConfigValue_Search.SEARCHRESULT.class
            , ensxtx_SBO_EnosixBOConfigValue_Search.SEARCHPARAMS.class
            , ensxtx_SBO_EnosixBOConfigValue_Search.SEARCHRESULT.class
            } 
        );
    }

    public ensxtx_SBO_EnosixBOConfigValue_Search() 
    {
        super('EnosixBOConfigValue', ensxtx_SBO_EnosixBOConfigValue_Search.EnosixBOConfigValue_SC.class, ensxtx_SBO_EnosixBOConfigValue_Search.EnosixBOConfigValue_SR.class);
    }
    
    public override Type getType() { return ensxtx_SBO_EnosixBOConfigValue_Search.class; }

    public EnosixBOConfigValue_SC search(EnosixBOConfigValue_SC sc) 
    {
        return (EnosixBOConfigValue_SC)super.executeSearch(sc);
    }

    public EnosixBOConfigValue_SC initialize(EnosixBOConfigValue_SC sc) 
    {
        return (EnosixBOConfigValue_SC)super.executeInitialize(sc);
    }

    public class EnosixBOConfigValue_SC extends ensxsdk.EnosixFramework.SearchContext 
    { 		
        public EnosixBOConfigValue_SC() 
        {		
            super(new Map<string,type>		
                {		
                    'SEARCHPARAMS' => ensxtx_SBO_EnosixBOConfigValue_Search.SEARCHPARAMS.class		
                });		
        }

        public override Type getType() { return ensxtx_SBO_EnosixBOConfigValue_Search.EnosixBOConfigValue_SC.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_EnosixBOConfigValue_Search.registerReflectionInfo();
        }

        public EnosixBOConfigValue_SR result { get { return (EnosixBOConfigValue_SR)baseResult; } }

        @AuraEnabled public ensxtx_SBO_EnosixBOConfigValue_Search.SEARCHPARAMS SEARCHPARAMS 
        {
            get
            {
                return (ensxtx_SBO_EnosixBOConfigValue_Search.SEARCHPARAMS)this.getStruct(ensxtx_SBO_EnosixBOConfigValue_Search.SEARCHPARAMS.class);
            }
        }
            }

    public class EnosixBOConfigValue_SR extends ensxsdk.EnosixFramework.SearchResult 
    {
        public EnosixBOConfigValue_SR() 
        {
            super(new Map<string,type>{'SEARCHRESULT' => ensxtx_SBO_EnosixBOConfigValue_Search.SEARCHRESULT.class } );
        }
        
        public ensxsdk.EnosixFramework.FrameworkCollection SearchResults
        {
            get { return super.getCollection(ensxtx_SBO_EnosixBOConfigValue_Search.SEARCHRESULT.class); }
        }
        
        public List<SEARCHRESULT> getResults() 
        {
            List<SEARCHRESULT> results = new List<SEARCHRESULT>();
            SearchResults.copyTo(results);
            return results;
        }

        public override Type getType() { return ensxtx_SBO_EnosixBOConfigValue_Search.EnosixBOConfigValue_SR.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_EnosixBOConfigValue_Search.registerReflectionInfo();
        }
    }

    public class SEARCHPARAMS extends ensxsdk.EnosixFramework.ValueObject 
    {
        public override Type getType() { return ensxtx_SBO_EnosixBOConfigValue_Search.SEARCHPARAMS.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_EnosixBOConfigValue_Search.registerReflectionInfo();
        }
        @AuraEnabled public String CustomizingID
        {
            get { return this.getString ('CID'); } 
            set { this.Set (value, 'CID'); }
        }

        @AuraEnabled public String BusinessObject
        {
            get { return this.getString ('BOTYPE'); } 
            set { this.Set (value, 'BOTYPE'); }
        }

    }

    public class SEARCHRESULT extends ensxsdk.EnosixFramework.ValueObject 
    {
        public override Type getType() { return ensxtx_SBO_EnosixBOConfigValue_Search.SEARCHRESULT.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_SBO_EnosixBOConfigValue_Search.registerReflectionInfo();
        }
        @AuraEnabled public String CustomizingID
        {
            get { return this.getString ('CID'); } 
            set { this.Set (value, 'CID'); }
        }

        @AuraEnabled public String BusinessObject
        {
            get { return this.getString ('BOTYPE'); } 
            set { this.Set (value, 'BOTYPE'); }
        }

        @AuraEnabled public String BusinessObjectTransaction
        {
            get { return this.getString ('BOPROCESS'); } 
            set { this.Set (value, 'BOPROCESS'); }
        }

        @AuraEnabled public String VariableType
        {
            get { return this.getString ('VARTYPE'); } 
            set { this.Set (value, 'VARTYPE'); }
        }

        @AuraEnabled public String VariableName
        {
            get { return this.getString ('VARNAME'); } 
            set { this.Set (value, 'VARNAME'); }
        }

        @AuraEnabled public String VariableCount
        {
            get { return this.getString ('NUMB'); } 
            set { this.Set (value, 'NUMB'); }
        }

        @AuraEnabled public String Sign
        {
            get { return this.getString ('SIGN'); } 
            set { this.Set (value, 'SIGN'); }
        }

        @AuraEnabled public String Option
        {
            get { return this.getString ('OPTI'); } 
            set { this.Set (value, 'OPTI'); }
        }

        @AuraEnabled public String Low
        {
            get { return this.getString ('LOW'); } 
            set { this.Set (value, 'LOW'); }
        }

        @AuraEnabled public String High
        {
            get { return this.getString ('HIGH'); } 
            set { this.Set (value, 'HIGH'); }
        }

    }

    public class SEARCHRESULT_COLLECTION extends ensxsdk.EnosixFramework.FrameworkCollection
    {
        public SEARCHRESULT_COLLECTION()
        {
            super('SEARCHRESULT', ensxtx_SBO_EnosixBOConfigValue_Search.SEARCHRESULT.class, null);
        }

        public List<ensxtx_SBO_EnosixBOConfigValue_Search.SEARCHRESULT> getAsList()
        {
            return (List<ensxtx_SBO_EnosixBOConfigValue_Search.SEARCHRESULT>)this.buildList(List<ensxtx_SBO_EnosixBOConfigValue_Search.SEARCHRESULT>.class);
        }
    }


}