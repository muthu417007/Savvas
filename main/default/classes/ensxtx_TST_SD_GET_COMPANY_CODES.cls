/// enosiX Inc. Generated Apex Model
/// Generated On: 12/15/2020 12:09:11 PM
/// SAP Host: From REST Service On: https://saas-force-89542-dev-ed.cs96.my.salesforce.com
/// CID: From REST Service On: https://saas-force-89542-dev-ed.cs96.my.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework ensxapp.v1.2

@isTest
public with sharing class ensxtx_TST_SD_GET_COMPANY_CODES
{
    public class Mockensxtx_RFC_SD_GET_COMPANY_CODES implements ensxsdk.EnosixFramework.RFCMock
    {
        public ensxsdk.EnosixFramework.FunctionObject executeFunction() 
        {
            return null;
        }
    }

    @isTest
    static void testExecute()
    {
        ensxsdk.EnosixFramework.setMock(ensxtx_RFC_SD_GET_COMPANY_CODES.class, new Mockensxtx_RFC_SD_GET_COMPANY_CODES());
        ensxtx_RFC_SD_GET_COMPANY_CODES rfc = new ensxtx_RFC_SD_GET_COMPANY_CODES();
        ensxtx_RFC_SD_GET_COMPANY_CODES.RESULT params = rfc.PARAMS;
        System.assertEquals(null, rfc.execute());
    }

    @isTest
    static void testRESULT()
    {
        ensxtx_RFC_SD_GET_COMPANY_CODES.RESULT funcObj = new ensxtx_RFC_SD_GET_COMPANY_CODES.RESULT();

        funcObj.registerReflectionForClass();

        System.assertEquals(ensxtx_RFC_SD_GET_COMPANY_CODES.RESULT.class, funcObj.getType(), 'getType() does not match object type.');

        //Check all the collections
        funcObj.getCollection(ensxtx_RFC_SD_GET_COMPANY_CODES.OUTPUT.class).add(new ensxtx_RFC_SD_GET_COMPANY_CODES.OUTPUT());
        System.assertEquals(1,funcObj.OUTPUT_List.size());

    }

    @isTest
    static void testOUTPUT()
    {
        ensxtx_RFC_SD_GET_COMPANY_CODES.OUTPUT funcObj = new ensxtx_RFC_SD_GET_COMPANY_CODES.OUTPUT();

        funcObj.registerReflectionForClass();

        System.assertEquals(ensxtx_RFC_SD_GET_COMPANY_CODES.OUTPUT.class, funcObj.getType(), 'getType() does not match object type.');
        funcObj.BUKRS = 'X';
        System.assertEquals('X', funcObj.BUKRS);

        funcObj.BUTXT = 'X';
        System.assertEquals('X', funcObj.BUTXT);

    }
}