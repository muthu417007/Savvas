/// enosiX Inc. Generated Apex Model
/// Generated On: 8/5/2020 5:50:36 PM
/// SAP Host: From REST Service On: https://platform-force-5128-dev-ed.cs95.my.salesforce.com
/// CID: From REST Service On: https://platform-force-5128-dev-ed.cs95.my.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework ensxapp.v1.2

@isTest
public with sharing class ensxtx_TST_SD_GET_GROUP_OFFICE
{
    public class Mockensxtx_RFC_SD_GET_GROUP_OFFICE implements ensxsdk.EnosixFramework.RFCMock
    {
        public ensxsdk.EnosixFramework.FunctionObject executeFunction() 
        {
            return null;
        }
    }

    @isTest
    static void testExecute()
    {
        ensxsdk.EnosixFramework.setMock(ensxtx_RFC_SD_GET_GROUP_OFFICE.class, new Mockensxtx_RFC_SD_GET_GROUP_OFFICE());
        ensxtx_RFC_SD_GET_GROUP_OFFICE rfc = new ensxtx_RFC_SD_GET_GROUP_OFFICE();
        ensxtx_RFC_SD_GET_GROUP_OFFICE.RESULT params = rfc.PARAMS;
        System.assertEquals(null, rfc.execute());
    }

    @isTest
    static void testRESULT()
    {
        ensxtx_RFC_SD_GET_GROUP_OFFICE.RESULT funcObj = new ensxtx_RFC_SD_GET_GROUP_OFFICE.RESULT();

        funcObj.registerReflectionForClass();

        System.assertEquals(ensxtx_RFC_SD_GET_GROUP_OFFICE.RESULT.class, funcObj.getType(), 'getType() does not match object type.');

        funcObj.SALES_DISTRICT = true;
        System.assertEquals(true, funcObj.SALES_DISTRICT);

        funcObj.SALES_GROUP = true;
        System.assertEquals(true, funcObj.SALES_GROUP);

        funcObj.SALES_OFFICE = true;
        System.assertEquals(true, funcObj.SALES_OFFICE);

        //Check all the collections
        funcObj.getCollection(ensxtx_RFC_SD_GET_GROUP_OFFICE.ET_SALES_DISTRICT.class).add(new ensxtx_RFC_SD_GET_GROUP_OFFICE.ET_SALES_DISTRICT());
        System.assertEquals(1,funcObj.ET_SALES_DISTRICT_List.size());

        funcObj.getCollection(ensxtx_RFC_SD_GET_GROUP_OFFICE.ET_SALES_GROUP.class).add(new ensxtx_RFC_SD_GET_GROUP_OFFICE.ET_SALES_GROUP());
        System.assertEquals(1,funcObj.ET_SALES_GROUP_List.size());

        funcObj.getCollection(ensxtx_RFC_SD_GET_GROUP_OFFICE.ET_SALES_OFFICE.class).add(new ensxtx_RFC_SD_GET_GROUP_OFFICE.ET_SALES_OFFICE());
        System.assertEquals(1,funcObj.ET_SALES_OFFICE_List.size());

    }

    @isTest
    static void testET_SALES_DISTRICT()
    {
        ensxtx_RFC_SD_GET_GROUP_OFFICE.ET_SALES_DISTRICT funcObj = new ensxtx_RFC_SD_GET_GROUP_OFFICE.ET_SALES_DISTRICT();

        funcObj.registerReflectionForClass();

        System.assertEquals(ensxtx_RFC_SD_GET_GROUP_OFFICE.ET_SALES_DISTRICT.class, funcObj.getType(), 'getType() does not match object type.');
        funcObj.BZIRK = 'X';
        System.assertEquals('X', funcObj.BZIRK);

        funcObj.BZTXT = 'X';
        System.assertEquals('X', funcObj.BZTXT);

    }
    @isTest
    static void testET_SALES_GROUP()
    {
        ensxtx_RFC_SD_GET_GROUP_OFFICE.ET_SALES_GROUP funcObj = new ensxtx_RFC_SD_GET_GROUP_OFFICE.ET_SALES_GROUP();

        funcObj.registerReflectionForClass();

        System.assertEquals(ensxtx_RFC_SD_GET_GROUP_OFFICE.ET_SALES_GROUP.class, funcObj.getType(), 'getType() does not match object type.');
        funcObj.VKBUR = 'X';
        System.assertEquals('X', funcObj.VKBUR);

        funcObj.SalesGroup = 'X';
        System.assertEquals('X', funcObj.SalesGroup);

        funcObj.BEZEI = 'X';
        System.assertEquals('X', funcObj.BEZEI);

    }
    @isTest
    static void testET_SALES_OFFICE()
    {
        ensxtx_RFC_SD_GET_GROUP_OFFICE.ET_SALES_OFFICE funcObj = new ensxtx_RFC_SD_GET_GROUP_OFFICE.ET_SALES_OFFICE();

        funcObj.registerReflectionForClass();

        System.assertEquals(ensxtx_RFC_SD_GET_GROUP_OFFICE.ET_SALES_OFFICE.class, funcObj.getType(), 'getType() does not match object type.');
        funcObj.SalesOrganization = 'X';
        System.assertEquals('X', funcObj.SalesOrganization);

        funcObj.DistributionChannel = 'X';
        System.assertEquals('X', funcObj.DistributionChannel);

        funcObj.Division = 'X';
        System.assertEquals('X', funcObj.Division);

        funcObj.VKBUR = 'X';
        System.assertEquals('X', funcObj.VKBUR);

        funcObj.BEZEI = 'X';
        System.assertEquals('X', funcObj.BEZEI);

    }
}