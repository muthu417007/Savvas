/// enosiX Inc. Generated Apex Model
/// Generated On: 12/2/2020 9:09:01 AM
/// SAP Host: From REST Service On: https://ruby-force-7286-dev-ed.cs95.my.salesforce.com
/// CID: From REST Service On: https://ruby-force-7286-dev-ed.cs95.my.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework ensxapp.v1.2

@isTest
public with sharing class ensxtx_TST_SD_GET_MATERIAL_UOM
{
    public class Mockensxtx_RFC_SD_GET_MATERIAL_UOM implements ensxsdk.EnosixFramework.RFCMock
    {
        public ensxsdk.EnosixFramework.FunctionObject executeFunction() 
        {
            return null;
        }
    }

    @isTest
    static void testExecute()
    {
        ensxsdk.EnosixFramework.setMock(ensxtx_RFC_SD_GET_MATERIAL_UOM.class, new Mockensxtx_RFC_SD_GET_MATERIAL_UOM());
        ensxtx_RFC_SD_GET_MATERIAL_UOM rfc = new ensxtx_RFC_SD_GET_MATERIAL_UOM();
        ensxtx_RFC_SD_GET_MATERIAL_UOM.RESULT params = rfc.PARAMS;
        System.assertEquals(null, rfc.execute());
    }

    @isTest
    static void testRESULT()
    {
        ensxtx_RFC_SD_GET_MATERIAL_UOM.RESULT funcObj = new ensxtx_RFC_SD_GET_MATERIAL_UOM.RESULT();

        funcObj.registerReflectionForClass();

        System.assertEquals(ensxtx_RFC_SD_GET_MATERIAL_UOM.RESULT.class, funcObj.getType(), 'getType() does not match object type.');

        funcObj.IV_MATNR = 'X';
        System.assertEquals('X', funcObj.IV_MATNR);

        //Check all the collections
        funcObj.getCollection(ensxtx_RFC_SD_GET_MATERIAL_UOM.ET_OUTPUT.class).add(new ensxtx_RFC_SD_GET_MATERIAL_UOM.ET_OUTPUT());
        System.assertEquals(1,funcObj.ET_OUTPUT_List.size());

    }

    @isTest
    static void testET_OUTPUT()
    {
        ensxtx_RFC_SD_GET_MATERIAL_UOM.ET_OUTPUT funcObj = new ensxtx_RFC_SD_GET_MATERIAL_UOM.ET_OUTPUT();

        funcObj.registerReflectionForClass();

        System.assertEquals(ensxtx_RFC_SD_GET_MATERIAL_UOM.ET_OUTPUT.class, funcObj.getType(), 'getType() does not match object type.');
        funcObj.MEINH = 'X';
        System.assertEquals('X', funcObj.MEINH);

        funcObj.MEINH_INTERNAL = 'X';
        System.assertEquals('X', funcObj.MEINH_INTERNAL);

        funcObj.MSEHL = 'X';
        System.assertEquals('X', funcObj.MSEHL);

    }
}