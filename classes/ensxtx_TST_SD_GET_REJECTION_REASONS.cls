/// enosiX Inc. Generated Apex Model
/// Generated On: 8/5/2020 5:50:36 PM
/// SAP Host: From REST Service On: https://platform-force-5128-dev-ed.cs95.my.salesforce.com
/// CID: From REST Service On: https://platform-force-5128-dev-ed.cs95.my.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework ensxapp.v1.2

@isTest
public with sharing class ensxtx_TST_SD_GET_REJECTION_REASONS
{
    public class Mockensxtx_RFC_SD_GET_REJECTION_REASONS implements ensxsdk.EnosixFramework.RFCMock
    {
        public ensxsdk.EnosixFramework.FunctionObject executeFunction() 
        {
            return null;
        }
    }

    @isTest
    static void testExecute()
    {
        ensxsdk.EnosixFramework.setMock(ensxtx_RFC_SD_GET_REJECTION_REASONS.class, new Mockensxtx_RFC_SD_GET_REJECTION_REASONS());
        ensxtx_RFC_SD_GET_REJECTION_REASONS rfc = new ensxtx_RFC_SD_GET_REJECTION_REASONS();
        ensxtx_RFC_SD_GET_REJECTION_REASONS.RESULT params = rfc.PARAMS;
        System.assertEquals(null, rfc.execute());
    }

    @isTest
    static void testRESULT()
    {
        ensxtx_RFC_SD_GET_REJECTION_REASONS.RESULT funcObj = new ensxtx_RFC_SD_GET_REJECTION_REASONS.RESULT();

        funcObj.registerReflectionForClass();

        System.assertEquals(ensxtx_RFC_SD_GET_REJECTION_REASONS.RESULT.class, funcObj.getType(), 'getType() does not match object type.');

        funcObj.IV_LANGU = 'X';
        System.assertEquals('X', funcObj.IV_LANGU);

        //Check all the collections
        funcObj.getCollection(ensxtx_RFC_SD_GET_REJECTION_REASONS.ET_VALUES.class).add(new ensxtx_RFC_SD_GET_REJECTION_REASONS.ET_VALUES());
        System.assertEquals(1,funcObj.ET_VALUES_List.size());

    }

    @isTest
    static void testET_VALUES()
    {
        ensxtx_RFC_SD_GET_REJECTION_REASONS.ET_VALUES funcObj = new ensxtx_RFC_SD_GET_REJECTION_REASONS.ET_VALUES();

        funcObj.registerReflectionForClass();

        System.assertEquals(ensxtx_RFC_SD_GET_REJECTION_REASONS.ET_VALUES.class, funcObj.getType(), 'getType() does not match object type.');
        funcObj.VALUE = 'X';
        System.assertEquals('X', funcObj.VALUE);

        funcObj.DESCRIPTION = 'X';
        System.assertEquals('X', funcObj.DESCRIPTION);

    }
}