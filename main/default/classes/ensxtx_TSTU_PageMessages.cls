@isTest
public class ensxtx_TSTU_PageMessages
{
    @isTest public static void test_init()
    {
        Test.startTest();
        System.assert(ensxtx_UTIL_PageMessages.messageList != null);
        Test.stopTest();
    }

    @isTest public static void test_addMessage()
    {
        String text = 'test';

        Test.startTest();
        ensxtx_UTIL_PageMessages.addMessage(ensxtx_UTIL_PageMessages.SUCCESS, text);
        Test.stopTest();

        System.assertEquals(ensxtx_UTIL_PageMessages.messageList.size(), 1);
        System.assertEquals(ensxtx_UTIL_PageMessages.messageList[0].message, text);
        System.assertEquals(ensxtx_UTIL_PageMessages.messageList[0].messageType, ensxtx_UTIL_PageMessages.SUCCESS);
    }

    @isTest public static void test_addFrameworkMessages()
    {
        ensxsdk.EnosixFramework.Message m1 = new ensxsdk.EnosixFramework.Message(ensxsdk.EnosixFramework.MessageType.SUCCESS, 'm1');
        ensxsdk.EnosixFramework.Message m2 = new ensxsdk.EnosixFramework.Message(ensxsdk.EnosixFramework.MessageType.WARNING, 'm2');
        ensxsdk.EnosixFramework.Message m3 = new ensxsdk.EnosixFramework.Message(ensxsdk.EnosixFramework.MessageType.ERROR, 'm3');
        ensxsdk.EnosixFramework.Message m4 = new ensxsdk.EnosixFramework.Message(ensxsdk.EnosixFramework.MessageType.INFO, 'm4');
        ensxsdk.EnosixFramework.Message m5 = new ensxsdk.EnosixFramework.Message(ensxsdk.EnosixFramework.MessageType.ABNORMALEND, 'm5');
        ensxsdk.EnosixFramework.Message m6 = new ensxsdk.EnosixFramework.Message(ensxsdk.EnosixFramework.MessageType.SAPEXIT, 'm6');
        ensxtx_UTIL_PageMessages.Message m7 = new ensxtx_UTIL_PageMessages.Message();
        List<ensxsdk.EnosixFramework.Message> msgs = new List<ensxsdk.EnosixFramework.Message> { m1, m2, m3, m4, m5, m6 };

        Test.startTest();
        ensxtx_UTIL_PageMessages.addFrameworkMessages(msgs);
        Test.stopTest();
        // INFO messages are suppressed when you're adding framework messages.
        System.assertEquals(4, ensxtx_UTIL_PageMessages.messageList.size());
        System.debug('ensxtx_UTIL_PageMessages.messageList: ' + ensxtx_UTIL_PageMessages.messageList);
        System.assertEquals(ensxtx_UTIL_PageMessages.messageList[0].message, m2.Text);
        System.assertEquals(ensxtx_UTIL_PageMessages.messageList[1].message, m3.Text);
        System.assertEquals(ensxtx_UTIL_PageMessages.messageList[2].message, m5.Text);
        System.assertEquals(ensxtx_UTIL_PageMessages.messageList[3].message, m6.Text);
        System.assertEquals(ensxtx_UTIL_PageMessages.messageList[0].messageType, ensxtx_UTIL_PageMessages.WARNING);
        System.assertEquals(ensxtx_UTIL_PageMessages.messageList[1].messageType, ensxtx_UTIL_PageMessages.ERROR);
        System.assertEquals(ensxtx_UTIL_PageMessages.messageList[2].messageType, ensxtx_UTIL_PageMessages.ERROR);
        System.assertEquals(ensxtx_UTIL_PageMessages.messageList[3].messageType, ensxtx_UTIL_PageMessages.ERROR);
        ensxtx_UTIL_PageMessages.addMessage(ensxtx_UTIL_PageMessages.INFO, 'message');
        ensxtx_UTIL_PageMessages.Message message = new ensxtx_UTIL_PageMessages.Message(m1);
        message = new ensxtx_UTIL_PageMessages.Message(m4);
    }

    @isTest public static void test_addExceptionMessage()
    {
        String msg = 'test exception message';
        TestException ex = new TestException(msg);

        Test.startTest();
        ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
        Test.stopTest();

        System.assertEquals(ensxtx_UTIL_PageMessages.messageList.size(), 1);
        System.assertEquals(ensxtx_UTIL_PageMessages.messageList[0].message, msg);
        System.assertEquals(ensxtx_UTIL_PageMessages.messageList[0].messageType, ensxtx_UTIL_PageMessages.ERROR);
    }

    @isTest
    public static void test_buildMesssageTableString()
    {
        ensxtx_UTIL_PageMessages.addMessage(ensxtx_UTIL_PageMessages.ERROR, 'Error Message');
        ensxtx_UTIL_PageMessages.addMessage(ensxtx_UTIL_PageMessages.WARNING, 'Warning Message');
        ensxtx_UTIL_PageMessages.addMessage(ensxtx_UTIL_PageMessages.INFO, 'Info Message');
        String stringTable = ensxtx_UTIL_PageMessages.buildMesssageTableString();
        System.assertEquals(true, String.isNotEmpty(stringTable));
    }

    class TestException extends Exception { }
}