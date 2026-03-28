@isTest
public with sharing class ensxtx_TSTU_ViewHelper
{
    @isTest
    public static void testdisplayResultMessages()
    {
        Test.startTest();
        List<ensxsdk.EnosixFramework.Message> mList = new List<ensxsdk.EnosixFramework.Message>();
        mList.add(new ensxsdk.EnosixFramework.Message(ensxsdk.EnosixFramework.MessageType.WARNING, 'm2'));
        ensxtx_UTIL_ViewHelper.displayResultMessages(mList);
        Test.stopTest();
    }

    @isTest
    public static void testdisplayMessage()
    {
        Test.startTest();
        ensxtx_UTIL_ViewHelper.displayMessage(ensxsdk.EnosixFramework.MessageType.Error, ensxsdk.EnosixFramework.MessageType.Error, '');
        ensxtx_UTIL_ViewHelper.displayMessage(ensxsdk.EnosixFramework.MessageType.SUCCESS, ensxsdk.EnosixFramework.MessageType.WARNING, '');
        ensxtx_UTIL_ViewHelper.displayMessage(ensxsdk.EnosixFramework.MessageType.SUCCESS, ensxsdk.EnosixFramework.MessageType.INFO, '');
        ensxtx_UTIL_ViewHelper.displayMessage(ensxsdk.EnosixFramework.MessageType.SUCCESS, ensxsdk.EnosixFramework.MessageType.SUCCESS, '');
        Test.stopTest();
    }
}