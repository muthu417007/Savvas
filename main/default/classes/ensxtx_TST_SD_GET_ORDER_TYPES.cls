/// enosiX Inc. Generated Apex Model
/// Generated On: 8/5/2020 5:50:36 PM
/// SAP Host: From REST Service On: https://platform-force-5128-dev-ed.cs95.my.salesforce.com
/// CID: From REST Service On: https://platform-force-5128-dev-ed.cs95.my.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework ensxapp.v1.2

@isTest
public with sharing class ensxtx_TST_SD_GET_ORDER_TYPES
{
    public class Mockensxtx_RFC_SD_GET_ORDER_TYPES implements ensxsdk.EnosixFramework.RFCMock
    {
        public ensxsdk.EnosixFramework.FunctionObject executeFunction() 
        {
            return null;
        }
    }

    @isTest
    static void testExecute()
    {
        ensxsdk.EnosixFramework.setMock(ensxtx_RFC_SD_GET_ORDER_TYPES.class, new Mockensxtx_RFC_SD_GET_ORDER_TYPES());
        ensxtx_RFC_SD_GET_ORDER_TYPES rfc = new ensxtx_RFC_SD_GET_ORDER_TYPES();
        ensxtx_RFC_SD_GET_ORDER_TYPES.RESULT params = rfc.PARAMS;
        System.assertEquals(null, rfc.execute());
    }

    @isTest
    static void testRESULT()
    {
        ensxtx_RFC_SD_GET_ORDER_TYPES.RESULT funcObj = new ensxtx_RFC_SD_GET_ORDER_TYPES.RESULT();

        funcObj.registerReflectionForClass();

        System.assertEquals(ensxtx_RFC_SD_GET_ORDER_TYPES.RESULT.class, funcObj.getType(), 'getType() does not match object type.');

        funcObj.IV_AUART = 'X';
        System.assertEquals('X', funcObj.IV_AUART);

        funcObj.IV_BOPROCESS = 'X';
        System.assertEquals('X', funcObj.IV_BOPROCESS);

        funcObj.IV_BOTYPE = 'X';
        System.assertEquals('X', funcObj.IV_BOTYPE);

        funcObj.IV_CID = 'X';
        System.assertEquals('X', funcObj.IV_CID);

        funcObj.IV_LANGU = 'X';
        System.assertEquals('X', funcObj.IV_LANGU);

        funcObj.IV_MAT = 'X';
        System.assertEquals('X', funcObj.IV_MAT);

        funcObj.IV_USERNAME = 'X';
        System.assertEquals('X', funcObj.IV_USERNAME);

        funcObj.IV_VKORG = 'X';
        System.assertEquals('X', funcObj.IV_VKORG);

        funcObj.IV_VTWEG = 'X';
        System.assertEquals('X', funcObj.IV_VTWEG);

        //Check all the collections
        funcObj.getCollection(ensxtx_RFC_SD_GET_ORDER_TYPES.IT_MAT.class).add(new ensxtx_RFC_SD_GET_ORDER_TYPES.IT_MAT());
        System.assertEquals(1,funcObj.IT_MAT_List.size());

        funcObj.getCollection(ensxtx_RFC_SD_GET_ORDER_TYPES.ET_ITEM_CAT.class).add(new ensxtx_RFC_SD_GET_ORDER_TYPES.ET_ITEM_CAT());
        System.assertEquals(1,funcObj.ET_ITEM_CAT_List.size());

        funcObj.getCollection(ensxtx_RFC_SD_GET_ORDER_TYPES.ET_MAT_ITEM_CAT.class).add(new ensxtx_RFC_SD_GET_ORDER_TYPES.ET_MAT_ITEM_CAT());
        System.assertEquals(1,funcObj.ET_MAT_ITEM_CAT_List.size());

        funcObj.getCollection(ensxtx_RFC_SD_GET_ORDER_TYPES.ET_VALUES.class).add(new ensxtx_RFC_SD_GET_ORDER_TYPES.ET_VALUES());
        System.assertEquals(1,funcObj.ET_VALUES_List.size());

    }

    @isTest
    static void testIT_MAT()
    {
        ensxtx_RFC_SD_GET_ORDER_TYPES.IT_MAT funcObj = new ensxtx_RFC_SD_GET_ORDER_TYPES.IT_MAT();

        funcObj.registerReflectionForClass();

        System.assertEquals(ensxtx_RFC_SD_GET_ORDER_TYPES.IT_MAT.class, funcObj.getType(), 'getType() does not match object type.');
        funcObj.MaterialNumber = 'X';
        System.assertEquals('X', funcObj.MaterialNumber);

    }
    @isTest
    static void testET_ITEM_CAT()
    {
        ensxtx_RFC_SD_GET_ORDER_TYPES.ET_ITEM_CAT funcObj = new ensxtx_RFC_SD_GET_ORDER_TYPES.ET_ITEM_CAT();

        funcObj.registerReflectionForClass();

        System.assertEquals(ensxtx_RFC_SD_GET_ORDER_TYPES.ET_ITEM_CAT.class, funcObj.getType(), 'getType() does not match object type.');
        funcObj.DocumentType = 'X';
        System.assertEquals('X', funcObj.DocumentType);

        funcObj.SalesItemCategory = 'X';
        System.assertEquals('X', funcObj.SalesItemCategory);

        funcObj.MTPOS = 'X';
        System.assertEquals('X', funcObj.MTPOS);

    }
    @isTest
    static void testET_MAT_ITEM_CAT()
    {
        ensxtx_RFC_SD_GET_ORDER_TYPES.ET_MAT_ITEM_CAT funcObj = new ensxtx_RFC_SD_GET_ORDER_TYPES.ET_MAT_ITEM_CAT();

        funcObj.registerReflectionForClass();

        System.assertEquals(ensxtx_RFC_SD_GET_ORDER_TYPES.ET_MAT_ITEM_CAT.class, funcObj.getType(), 'getType() does not match object type.');
        funcObj.MaterialNumber = 'X';
        System.assertEquals('X', funcObj.MaterialNumber);

        funcObj.PSTVY = 'X';
        System.assertEquals('X', funcObj.PSTVY);

    }
    @isTest
    static void testET_VALUES()
    {
        ensxtx_RFC_SD_GET_ORDER_TYPES.ET_VALUES funcObj = new ensxtx_RFC_SD_GET_ORDER_TYPES.ET_VALUES();

        funcObj.registerReflectionForClass();

        System.assertEquals(ensxtx_RFC_SD_GET_ORDER_TYPES.ET_VALUES.class, funcObj.getType(), 'getType() does not match object type.');
        funcObj.VALUE = 'X';
        System.assertEquals('X', funcObj.VALUE);

        funcObj.DESCRIPTION = 'X';
        System.assertEquals('X', funcObj.DESCRIPTION);

    }
}