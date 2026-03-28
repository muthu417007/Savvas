/// enosiX Inc. Generated Apex Model
/// Generated On: 10/10/2022 2:43:26 PM
/// SAP Host: From REST Service On: https://site-nosoftware-9252-dev-ed.my.salesforce.com
/// CID: From REST Service On: https://site-nosoftware-9252-dev-ed.my.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework ensxapp.v1.2

@isTest
public with sharing class ensxtx_TST_PM_GET_UOM
{
    public class Mockensxtx_RFC_PM_GET_UOM implements ensxsdk.EnosixFramework.RFCMock
    {
        public ensxsdk.EnosixFramework.FunctionObject executeFunction() 
        {
            return null;
        }
    }

    @isTest
    static void testExecute()
    {
        ensxsdk.EnosixFramework.setMock(ensxtx_RFC_PM_GET_UOM.class, new Mockensxtx_RFC_PM_GET_UOM());
        ensxtx_RFC_PM_GET_UOM rfc = new ensxtx_RFC_PM_GET_UOM();
        ensxtx_RFC_PM_GET_UOM.RESULT params = rfc.PARAMS;
        System.assertEquals(null, rfc.execute());
    }

    @isTest
    static void testRESULT()
    {
        ensxtx_RFC_PM_GET_UOM.RESULT funcObj = new ensxtx_RFC_PM_GET_UOM.RESULT();

        funcObj.registerReflectionForClass();

        System.assertEquals(ensxtx_RFC_PM_GET_UOM.RESULT.class, funcObj.getType(), 'getType() does not match object type.');

        //Check all the collections
        funcObj.getCollection(ensxtx_RFC_PM_GET_UOM.ET_UOM.class).add(new ensxtx_RFC_PM_GET_UOM.ET_UOM());
        System.assertEquals(1,funcObj.ET_UOM_List.size());

    }

    @isTest
    static void testET_UOM()
    {
        ensxtx_RFC_PM_GET_UOM.ET_UOM funcObj = new ensxtx_RFC_PM_GET_UOM.ET_UOM();

        funcObj.registerReflectionForClass();

        System.assertEquals(ensxtx_RFC_PM_GET_UOM.ET_UOM.class, funcObj.getType(), 'getType() does not match object type.');
        funcObj.MSEH3 = 'X';
        System.assertEquals('X', funcObj.MSEH3);

        funcObj.MSEHL = 'X';
        System.assertEquals('X', funcObj.MSEHL);

    }
}