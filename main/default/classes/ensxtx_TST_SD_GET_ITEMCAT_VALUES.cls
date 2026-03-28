/// enosiX Inc. Generated Apex Model
/// Generated On: 8/5/2020 5:50:36 PM
/// SAP Host: From REST Service On: https://platform-force-5128-dev-ed.cs95.my.salesforce.com
/// CID: From REST Service On: https://platform-force-5128-dev-ed.cs95.my.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework ensxapp.v1.2

@isTest
public with sharing class ensxtx_TST_SD_GET_ITEMCAT_VALUES
{
    public class Mockensxtx_RFC_SD_GET_ITEMCAT_VALUES implements ensxsdk.EnosixFramework.RFCMock
    {
        public ensxsdk.EnosixFramework.FunctionObject executeFunction() 
        {
            return null;
        }
    }

    @isTest
    static void testExecute()
    {
        ensxsdk.EnosixFramework.setMock(ensxtx_RFC_SD_GET_ITEMCAT_VALUES.class, new Mockensxtx_RFC_SD_GET_ITEMCAT_VALUES());
        ensxtx_RFC_SD_GET_ITEMCAT_VALUES rfc = new ensxtx_RFC_SD_GET_ITEMCAT_VALUES();
        ensxtx_RFC_SD_GET_ITEMCAT_VALUES.RESULT params = rfc.PARAMS;
        System.assertEquals(null, rfc.execute());
    }

    @isTest
    static void testRESULT()
    {
        ensxtx_RFC_SD_GET_ITEMCAT_VALUES.RESULT funcObj = new ensxtx_RFC_SD_GET_ITEMCAT_VALUES.RESULT();

        funcObj.registerReflectionForClass();

        System.assertEquals(ensxtx_RFC_SD_GET_ITEMCAT_VALUES.RESULT.class, funcObj.getType(), 'getType() does not match object type.');

        funcObj.IV_AUART = 'X';
        System.assertEquals('X', funcObj.IV_AUART);

        funcObj.IV_LANGU = 'X';
        System.assertEquals('X', funcObj.IV_LANGU);

        funcObj.IV_MATNR = 'X';
        System.assertEquals('X', funcObj.IV_MATNR);

        funcObj.IV_UEPST = 'X';
        System.assertEquals('X', funcObj.IV_UEPST);

        funcObj.IV_VKORG = 'X';
        System.assertEquals('X', funcObj.IV_VKORG);

        funcObj.IV_VTWEG = 'X';
        System.assertEquals('X', funcObj.IV_VTWEG);

        //Check all the collections
        funcObj.getCollection(ensxtx_RFC_SD_GET_ITEMCAT_VALUES.ET_VALUES.class).add(new ensxtx_RFC_SD_GET_ITEMCAT_VALUES.ET_VALUES());
        System.assertEquals(1,funcObj.ET_VALUES_List.size());

    }

    @isTest
    static void testET_VALUES()
    {
        ensxtx_RFC_SD_GET_ITEMCAT_VALUES.ET_VALUES funcObj = new ensxtx_RFC_SD_GET_ITEMCAT_VALUES.ET_VALUES();

        funcObj.registerReflectionForClass();

        System.assertEquals(ensxtx_RFC_SD_GET_ITEMCAT_VALUES.ET_VALUES.class, funcObj.getType(), 'getType() does not match object type.');
        funcObj.VALUE = 'X';
        System.assertEquals('X', funcObj.VALUE);

        funcObj.DESCRIPTION = 'X';
        System.assertEquals('X', funcObj.DESCRIPTION);

    }
}