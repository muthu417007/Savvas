public with sharing class ensxtx_UTIL_ViewHelper
{
    private static final ensxsdk.Logger logger = new ensxsdk.Logger(ensxtx_UTIL_ViewHelper.class);

    public static void displayResultMessages(List<ensxsdk.EnosixFramework.Message> mList, ensxsdk.EnosixFramework.MessageType level) 
    {
        if (mList == null) return;    
        Integer mTot = mList.size();
        for (Integer mCnt = 0 ; mCnt < mTot ; mCnt++) {
            ensxsdk.EnosixFramework.Message m = mList[mCnt]; 
            displayMessage(level, m.Type, m.Text);
        }
    }

    @testVisible
    private static void displayMessage(
        ensxsdk.EnosixFramework.MessageType logLevel, 
        ensxsdk.EnosixFramework.MessageType mType, 
        String mText)
    {
            boolean showMessage = false;
            String severity = ensxtx_UTIL_PageMessages.INFO;

            if (ensxsdk.EnosixFramework.MessageType.Error == mType) 
            {
                showMessage = true;
                severity = ensxtx_UTIL_PageMessages.ERROR;
            } 
            else if (ensxsdk.EnosixFramework.MessageType.WARNING == mType && 
                (ensxsdk.EnosixFramework.MessageType.WARNING == logLevel || 
                    ensxsdk.EnosixFramework.MessageType.INFO == logLevel || 
                    ensxsdk.EnosixFramework.MessageType.SUCCESS == logLevel)) 
            {
                showMessage = true;
                severity = ensxtx_UTIL_PageMessages.WARNING;
            } 
            else if (ensxsdk.EnosixFramework.MessageType.INFO == mType && 
                (ensxsdk.EnosixFramework.MessageType.WARNING == logLevel || 
                    ensxsdk.EnosixFramework.MessageType.INFO == logLevel || 
                    ensxsdk.EnosixFramework.MessageType.SUCCESS == logLevel)) 
            {
                showMessage = true;
                severity = ensxtx_UTIL_PageMessages.INFO;
            } 
            else if (ensxsdk.EnosixFramework.MessageType.SUCCESS == mType && 
                ensxsdk.EnosixFramework.MessageType.SUCCESS == logLevel) 
            {
                showMessage = true;
                severity = ensxtx_UTIL_PageMessages.INFO;
            }

            if (showMessage) ensxtx_UTIL_PageMessages.addMessage(severity, mText);
	}

    public static void displayResultMessages(List<ensxsdk.EnosixFramework.Message> mList) 
    {
        displayResultMessages(mList, ensxsdk.EnosixFramework.MessageType.WARNING);
    }
}