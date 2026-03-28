/// enosiX Inc. Generated Apex Model
/// Generated On: 8/5/2020 5:50:36 PM
/// SAP Host: From REST Service On: https://platform-force-5128-dev-ed.cs95.my.salesforce.com
/// CID: From REST Service On: https://platform-force-5128-dev-ed.cs95.my.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework ensxapp.v1.2

@isTest
public with sharing class ensxtx_TST_SD_GET_CURRENCY_LIST
{
    public class Mockensxtx_RFC_SD_GET_CURRENCY_LIST implements ensxsdk.EnosixFramework.RFCMock
    {
        public ensxsdk.EnosixFramework.FunctionObject executeFunction() 
        {
            return null;
        }
    }

    @isTest
    static void testExecute()
    {
        ensxsdk.EnosixFramework.setMock(ensxtx_RFC_SD_GET_CURRENCY_LIST.class, new Mockensxtx_RFC_SD_GET_CURRENCY_LIST());
        ensxtx_RFC_SD_GET_CURRENCY_LIST rfc = new ensxtx_RFC_SD_GET_CURRENCY_LIST();
        ensxtx_RFC_SD_GET_CURRENCY_LIST.RESULT params = rfc.PARAMS;
        System.assertEquals(null, rfc.execute());
    }

    @isTest
    static void testRESULT()
    {
        ensxtx_RFC_SD_GET_CURRENCY_LIST.RESULT funcObj = new ensxtx_RFC_SD_GET_CURRENCY_LIST.RESULT();

        funcObj.registerReflectionForClass();

        System.assertEquals(ensxtx_RFC_SD_GET_CURRENCY_LIST.RESULT.class, funcObj.getType(), 'getType() does not match object type.');

        //Check all the collections
        funcObj.getCollection(ensxtx_RFC_SD_GET_CURRENCY_LIST.ET_CURRENCY.class).add(new ensxtx_RFC_SD_GET_CURRENCY_LIST.ET_CURRENCY());
        System.assertEquals(1,funcObj.ET_CURRENCY_List.size());

    }

    @isTest
    static void testET_CURRENCY()
    {
        ensxtx_RFC_SD_GET_CURRENCY_LIST.ET_CURRENCY funcObj = new ensxtx_RFC_SD_GET_CURRENCY_LIST.ET_CURRENCY();

        funcObj.registerReflectionForClass();

        System.assertEquals(ensxtx_RFC_SD_GET_CURRENCY_LIST.ET_CURRENCY.class, funcObj.getType(), 'getType() does not match object type.');
        funcObj.FieldCurrency = 'X';
        System.assertEquals('X', funcObj.FieldCurrency);

        funcObj.LTEXT = 'X';
        System.assertEquals('X', funcObj.LTEXT);

        funcObj.KTEXT = 'X';
        System.assertEquals('X', funcObj.KTEXT);

    }
}