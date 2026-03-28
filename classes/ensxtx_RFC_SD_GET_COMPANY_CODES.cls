/// enosiX Inc. Generated Apex Model
/// Generated On: 12/15/2020 12:09:11 PM
/// SAP Host: From REST Service On: https://saas-force-89542-dev-ed.cs96.my.salesforce.com
/// CID: From REST Service On: https://saas-force-89542-dev-ed.cs96.my.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework ensxapp.v1.2

public with sharing class ensxtx_RFC_SD_GET_COMPANY_CODES extends ensxsdk.EnosixFramework.RFC
{
        static void registerReflectionInfo()
    {
        ensxsdk.EnosixFramework.registerReflectionResource('ensxtx_RFC_SD_GET_COMPANY_CODES_Meta', new Type[] {
            ensxtx_RFC_SD_GET_COMPANY_CODES.RESULT.class
            , ensxtx_RFC_SD_GET_COMPANY_CODES.OUTPUT.class
            } 
        );
    }

    public ensxtx_RFC_SD_GET_COMPANY_CODES()
    {
        super('/ENSX/SD_GET_COMPANY_CODES', ensxtx_RFC_SD_GET_COMPANY_CODES.RESULT.class);
    }

    public override Type getType() { return ensxtx_RFC_SD_GET_COMPANY_CODES.class; }

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
                'OUTPUT' => ensxtx_RFC_SD_GET_COMPANY_CODES.OUTPUT.class
            });	
        }
        
        public override Type getType() { return ensxtx_RFC_SD_GET_COMPANY_CODES.RESULT.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_RFC_SD_GET_COMPANY_CODES.registerReflectionInfo();
        }

        @AuraEnabled public List<OUTPUT> OUTPUT_List
    {
        get 
        {
            List<OUTPUT> results = new List<OUTPUT>();
            this.getCollection(ensxtx_RFC_SD_GET_COMPANY_CODES.OUTPUT.class).copyTo(results);
            return results;
        }
    }
    	
    }
    public class OUTPUT extends ensxsdk.EnosixFramework.ValueObject
    {
        public OUTPUT()
        {
            super('OUTPUT', new Map<string,type>());
        }

        public override Type getType() { return ensxtx_RFC_SD_GET_COMPANY_CODES.OUTPUT.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_RFC_SD_GET_COMPANY_CODES.registerReflectionInfo();
        }

                    @AuraEnabled public String BUKRS
        { 
            get { return this.getString ('BUKRS'); } 
            set { this.Set (value, 'BUKRS'); }
        }

        @AuraEnabled public String BUTXT
        { 
            get { return this.getString ('BUTXT'); } 
            set { this.Set (value, 'BUTXT'); }
        }

            
        }
}