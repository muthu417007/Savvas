/// enosiX Inc. Generated Apex Model
/// Generated On: 12/2/2020 9:09:01 AM
/// SAP Host: From REST Service On: https://ruby-force-7286-dev-ed.cs95.my.salesforce.com
/// CID: From REST Service On: https://ruby-force-7286-dev-ed.cs95.my.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework ensxapp.v1.2

public with sharing class ensxtx_RFC_SD_GET_DOC_TYPE_VALUES extends ensxsdk.EnosixFramework.RFC
{
        static void registerReflectionInfo()
    {
        ensxsdk.EnosixFramework.registerReflectionResource('ensxtx_RFC_SD_GET_DOC_TYPE_VALUES_Meta', new Type[] {
            ensxtx_RFC_SD_GET_DOC_TYPE_VALUES.RESULT.class
            , ensxtx_RFC_SD_GET_DOC_TYPE_VALUES.ET_OUTPUT.class
            } 
        );
    }

    public ensxtx_RFC_SD_GET_DOC_TYPE_VALUES()
    {
        super('/ENSX/SD_GET_DOC_TYPE_VALUES', ensxtx_RFC_SD_GET_DOC_TYPE_VALUES.RESULT.class);
    }

    public override Type getType() { return ensxtx_RFC_SD_GET_DOC_TYPE_VALUES.class; }

    public RESULT PARAMS
    {
        get { return (RESULT)this.getParameterContext(); }
    }

    public RESULT execute()
    {
        return (RESULT)this.executeFunction();
    }
    
    public class RESULT extends ensxsdk.EnosixFramework.FunctionObject
    {    	
        public RESULT()
        {
            super(new Map<string,type>
            {
                'ET_OUTPUT' => ensxtx_RFC_SD_GET_DOC_TYPE_VALUES.ET_OUTPUT.class
            });	
        }
        
        public override Type getType() { return ensxtx_RFC_SD_GET_DOC_TYPE_VALUES.RESULT.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_RFC_SD_GET_DOC_TYPE_VALUES.registerReflectionInfo();
        }

        @AuraEnabled public List<ET_OUTPUT> ET_OUTPUT_List
    {
        get 
        {
            List<ET_OUTPUT> results = new List<ET_OUTPUT>();
            this.getCollection(ensxtx_RFC_SD_GET_DOC_TYPE_VALUES.ET_OUTPUT.class).copyTo(results);
            return results;
        }
    }
    	
    }
    public class ET_OUTPUT extends ensxsdk.EnosixFramework.ValueObject
    {
        public ET_OUTPUT()
        {
            super('ET_OUTPUT', new Map<string,type>());
        }

        public override Type getType() { return ensxtx_RFC_SD_GET_DOC_TYPE_VALUES.ET_OUTPUT.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_RFC_SD_GET_DOC_TYPE_VALUES.registerReflectionInfo();
        }

                    @AuraEnabled public String DocumentType
        { 
            get { return this.getString ('AUART'); } 
            set { this.Set (value, 'AUART'); }
        }

        @AuraEnabled public String AUART_INTERNAL
        { 
            get { return this.getString ('AUART_INTERNAL'); } 
            set { this.Set (value, 'AUART_INTERNAL'); }
        }

        @AuraEnabled public String BEZEI
        { 
            get { return this.getString ('BEZEI'); } 
            set { this.Set (value, 'BEZEI'); }
        }

        @AuraEnabled public String VBTYP
        { 
            get { return this.getString ('VBTYP'); } 
            set { this.Set (value, 'VBTYP'); }
        }

        @AuraEnabled public String VBTYP_TEXT
        { 
            get { return this.getString ('VBTYP_TEXT'); } 
            set { this.Set (value, 'VBTYP_TEXT'); }
        }

        @AuraEnabled public String INCPO
        { 
            get { return this.getString ('INCPO'); } 
            set { this.Set (value, 'INCPO'); }
        }

        @AuraEnabled public Boolean X_PONUM_REQUIRED
        { 
            get { return this.getBoolean('X_PONUM_REQUIRED'); } 
            set { this.setBoolean(value, 'X_PONUM_REQUIRED'); }
        }

            
        }
}