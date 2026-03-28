/// enosiX Inc. Generated Apex Model
/// Generated On: 12/2/2020 9:09:01 AM
/// SAP Host: From REST Service On: https://ruby-force-7286-dev-ed.cs95.my.salesforce.com
/// CID: From REST Service On: https://ruby-force-7286-dev-ed.cs95.my.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework ensxapp.v1.2

public with sharing class ensxtx_RFC_SD_GET_MATERIAL_UOM extends ensxsdk.EnosixFramework.RFC
{
        static void registerReflectionInfo()
    {
        ensxsdk.EnosixFramework.registerReflectionResource('ensxtx_RFC_SD_GET_MATERIAL_UOM_Meta', new Type[] {
            ensxtx_RFC_SD_GET_MATERIAL_UOM.RESULT.class
            , ensxtx_RFC_SD_GET_MATERIAL_UOM.ET_OUTPUT.class
            } 
        );
    }

    public ensxtx_RFC_SD_GET_MATERIAL_UOM()
    {
        super('/ENSX/SD_GET_MATERIAL_UOM', ensxtx_RFC_SD_GET_MATERIAL_UOM.RESULT.class);
    }

    public override Type getType() { return ensxtx_RFC_SD_GET_MATERIAL_UOM.class; }

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
                'ET_OUTPUT' => ensxtx_RFC_SD_GET_MATERIAL_UOM.ET_OUTPUT.class
            });	
        }
        
        public override Type getType() { return ensxtx_RFC_SD_GET_MATERIAL_UOM.RESULT.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_RFC_SD_GET_MATERIAL_UOM.registerReflectionInfo();
        }

        @AuraEnabled public List<ET_OUTPUT> ET_OUTPUT_List
    {
        get 
        {
            List<ET_OUTPUT> results = new List<ET_OUTPUT>();
            this.getCollection(ensxtx_RFC_SD_GET_MATERIAL_UOM.ET_OUTPUT.class).copyTo(results);
            return results;
        }
    }
        @AuraEnabled public String IV_MATNR
        { 
            get { return this.getString ('IV_MATNR'); } 
            set { this.Set (value, 'IV_MATNR'); }
        }

    	
    }
    public class ET_OUTPUT extends ensxsdk.EnosixFramework.ValueObject
    {
        public ET_OUTPUT()
        {
            super('ET_OUTPUT', new Map<string,type>());
        }

        public override Type getType() { return ensxtx_RFC_SD_GET_MATERIAL_UOM.ET_OUTPUT.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_RFC_SD_GET_MATERIAL_UOM.registerReflectionInfo();
        }

                    @AuraEnabled public String MEINH
        { 
            get { return this.getString ('MEINH'); } 
            set { this.Set (value, 'MEINH'); }
        }

        @AuraEnabled public String MEINH_INTERNAL
        { 
            get { return this.getString ('MEINH_INTERNAL'); } 
            set { this.Set (value, 'MEINH_INTERNAL'); }
        }

        @AuraEnabled public String MSEHL
        { 
            get { return this.getString ('MSEHL'); } 
            set { this.Set (value, 'MSEHL'); }
        }

            
        }
}