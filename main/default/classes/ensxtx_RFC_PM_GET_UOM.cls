/// enosiX Inc. Generated Apex Model
/// Generated On: 10/10/2022 2:43:26 PM
/// SAP Host: From REST Service On: https://site-nosoftware-9252-dev-ed.my.salesforce.com
/// CID: From REST Service On: https://site-nosoftware-9252-dev-ed.my.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework ensxapp.v1.2

public with sharing class ensxtx_RFC_PM_GET_UOM extends ensxsdk.EnosixFramework.RFC
{
        static void registerReflectionInfo()
    {
        ensxsdk.EnosixFramework.registerReflectionResource('ensxtx_RFC_PM_GET_UOM_Meta', new Type[] {
            ensxtx_RFC_PM_GET_UOM.RESULT.class
            , ensxtx_RFC_PM_GET_UOM.ET_UOM.class
            } 
        );
    }

    public ensxtx_RFC_PM_GET_UOM()
    {
        super('/ENSX/PM_GET_UOM', ensxtx_RFC_PM_GET_UOM.RESULT.class);
    }

    public override Type getType() { return ensxtx_RFC_PM_GET_UOM.class; }

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
                'ET_UOM' => ensxtx_RFC_PM_GET_UOM.ET_UOM.class
            });	
        }
        
        public override Type getType() { return ensxtx_RFC_PM_GET_UOM.RESULT.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_RFC_PM_GET_UOM.registerReflectionInfo();
        }

        @AuraEnabled public List<ET_UOM> ET_UOM_List
    {
        get 
        {
            List<ET_UOM> results = new List<ET_UOM>();
            this.getCollection(ensxtx_RFC_PM_GET_UOM.ET_UOM.class).copyTo(results);
            return results;
        }
    }
    	
    }
    public class ET_UOM extends ensxsdk.EnosixFramework.ValueObject
    {
        public ET_UOM()
        {
            super('ET_UOM', new Map<string,type>());
        }

        public override Type getType() { return ensxtx_RFC_PM_GET_UOM.ET_UOM.class; }

        public override void registerReflectionForClass()
        {
            ensxtx_RFC_PM_GET_UOM.registerReflectionInfo();
        }

                    @AuraEnabled public String MSEH3
        {
            get { return this.getString ('MSEH3'); } 
            set { this.Set (value, 'MSEH3'); }
        }

        @AuraEnabled public String MSEHL
        {
            get { return this.getString ('MSEHL'); } 
            set { this.Set (value, 'MSEHL'); }
        }

            
        }
}