/// enosiX Inc. Generated Apex Model
/// Generated On: 12/2/2020 9:09:01 AM
/// SAP Host: From REST Service On: https://ruby-force-7286-dev-ed.cs95.my.salesforce.com
/// CID: From REST Service On: https://ruby-force-7286-dev-ed.cs95.my.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework ensxapp.v1.2

@isTest
public with sharing class ensxtx_TST_SD_GET_DOC_TYPE_VALUES
{
    public class Mockensxtx_RFC_SD_GET_DOC_TYPE_VALUES implements ensxsdk.EnosixFramework.RFCMock
    {
        public ensxsdk.EnosixFramework.FunctionObject executeFunction() 
        {
            return null;
        }
    }

    @isTest
    static void testExecute()
    {
        ensxsdk.EnosixFramework.setMock(ensxtx_RFC_SD_GET_DOC_TYPE_VALUES.class, new Mockensxtx_RFC_SD_GET_DOC_TYPE_VALUES());
        ensxtx_RFC_SD_GET_DOC_TYPE_VALUES rfc = new ensxtx_RFC_SD_GET_DOC_TYPE_VALUES();
        ensxtx_RFC_SD_GET_DOC_TYPE_VALUES.RESULT params = rfc.PARAMS;
        System.assertEquals(null, rfc.execute());
    }

    @isTest
    static void testRESULT()
    {
        ensxtx_RFC_SD_GET_DOC_TYPE_VALUES.RESULT funcObj = new ensxtx_RFC_SD_GET_DOC_TYPE_VALUES.RESULT();

        funcObj.registerReflectionForClass();

        System.assertEquals(ensxtx_RFC_SD_GET_DOC_TYPE_VALUES.RESULT.class, funcObj.getType(), 'getType() does not match object type.');

        //Check all the collections
        funcObj.getCollection(ensxtx_RFC_SD_GET_DOC_TYPE_VALUES.ET_OUTPUT.class).add(new ensxtx_RFC_SD_GET_DOC_TYPE_VALUES.ET_OUTPUT());
        System.assertEquals(1,funcObj.ET_OUTPUT_List.size());

    }

    @isTest
    static void testET_OUTPUT()
    {
        ensxtx_RFC_SD_GET_DOC_TYPE_VALUES.ET_OUTPUT funcObj = new ensxtx_RFC_SD_GET_DOC_TYPE_VALUES.ET_OUTPUT();

        funcObj.registerReflectionForClass();

        System.assertEquals(ensxtx_RFC_SD_GET_DOC_TYPE_VALUES.ET_OUTPUT.class, funcObj.getType(), 'getType() does not match object type.');
        funcObj.DocumentType = 'X';
        System.assertEquals('X', funcObj.DocumentType);

        funcObj.AUART_INTERNAL = 'X';
        System.assertEquals('X', funcObj.AUART_INTERNAL);

        funcObj.BEZEI = 'X';
        System.assertEquals('X', funcObj.BEZEI);

        funcObj.VBTYP = 'X';
        System.assertEquals('X', funcObj.VBTYP);

        funcObj.VBTYP_TEXT = 'X';
        System.assertEquals('X', funcObj.VBTYP_TEXT);

        funcObj.INCPO = 'X';
        System.assertEquals('X', funcObj.INCPO);

        funcObj.X_PONUM_REQUIRED = true;
        System.assertEquals(true, funcObj.X_PONUM_REQUIRED);

    }
}