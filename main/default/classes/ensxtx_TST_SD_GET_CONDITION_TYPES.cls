/// enosiX Inc. Generated Apex Model
/// Generated On: 8/5/2020 5:50:36 PM
/// SAP Host: From REST Service On: https://platform-force-5128-dev-ed.cs95.my.salesforce.com
/// CID: From REST Service On: https://platform-force-5128-dev-ed.cs95.my.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework ensxapp.v1.2

@isTest
public with sharing class ensxtx_TST_SD_GET_CONDITION_TYPES
{
    public class Mockensxtx_RFC_SD_GET_CONDITION_TYPES implements ensxsdk.EnosixFramework.RFCMock
    {
        public ensxsdk.EnosixFramework.FunctionObject executeFunction() 
        {
            return null;
        }
    }

    @isTest
    static void testExecute()
    {
        ensxsdk.EnosixFramework.setMock(ensxtx_RFC_SD_GET_CONDITION_TYPES.class, new Mockensxtx_RFC_SD_GET_CONDITION_TYPES());
        ensxtx_RFC_SD_GET_CONDITION_TYPES rfc = new ensxtx_RFC_SD_GET_CONDITION_TYPES();
        ensxtx_RFC_SD_GET_CONDITION_TYPES.RESULT params = rfc.PARAMS;
        System.assertEquals(null, rfc.execute());
    }

    @isTest
    static void testRESULT()
    {
        ensxtx_RFC_SD_GET_CONDITION_TYPES.RESULT funcObj = new ensxtx_RFC_SD_GET_CONDITION_TYPES.RESULT();

        funcObj.registerReflectionForClass();

        System.assertEquals(ensxtx_RFC_SD_GET_CONDITION_TYPES.RESULT.class, funcObj.getType(), 'getType() does not match object type.');

        funcObj.IV_HEADER = 'X';
        System.assertEquals('X', funcObj.IV_HEADER);

        funcObj.IV_KALSM = 'X';
        System.assertEquals('X', funcObj.IV_KALSM);

        funcObj.IV_KAPPL = 'X';
        System.assertEquals('X', funcObj.IV_KAPPL);

        //Check all the collections
        funcObj.getCollection(ensxtx_RFC_SD_GET_CONDITION_TYPES.ET_CONDITIONS.class).add(new ensxtx_RFC_SD_GET_CONDITION_TYPES.ET_CONDITIONS());
        System.assertEquals(1,funcObj.ET_CONDITIONS_List.size());

    }

    @isTest
    static void testET_CONDITIONS()
    {
        ensxtx_RFC_SD_GET_CONDITION_TYPES.ET_CONDITIONS funcObj = new ensxtx_RFC_SD_GET_CONDITION_TYPES.ET_CONDITIONS();

        funcObj.registerReflectionForClass();

        System.assertEquals(ensxtx_RFC_SD_GET_CONDITION_TYPES.ET_CONDITIONS.class, funcObj.getType(), 'getType() does not match object type.');
        funcObj.ConditionType = 'X';
        System.assertEquals('X', funcObj.ConditionType);

        funcObj.KSCHL_TEXT = 'X';
        System.assertEquals('X', funcObj.KSCHL_TEXT);

        funcObj.KRECH = 'X';
        System.assertEquals('X', funcObj.KRECH);

        funcObj.KRECH_TEXT = 'X';
        System.assertEquals('X', funcObj.KRECH_TEXT);

    }
}