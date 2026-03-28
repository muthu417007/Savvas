/// @description Page Messages compatible with Aura or Visualforce
public without sharing class ensxtx_UTIL_PageMessages
{
    private static final ensxsdk.Logger logger = new ensxsdk.Logger(ensxtx_UTIL_PageMessages.class);

    public static String SUCCESS = 'SUCCESS';
    public static String WARNING = 'WARNING';
    public static String ERROR = 'ERROR';
    public static String INFO = 'INFO';

    public static List<Message> messageList { get; private set; }

    static {
        ensxtx_UTIL_PageMessages.messageList = new List<Message>();
    }

    public static void addMessage(String messageType, String message)
    {
        ensxtx_UTIL_PageMessages.messageList.add(new Message(messageType, message));
    }

    public static void addFrameworkMessages(List<ensxsdk.EnosixFramework.Message> messages)
    {
        if (null == messages) return;

        Integer mTot = messages.size();
        for (Integer mCnt = 0 ; mCnt < mTot ; mCnt++)
        {
            ensxsdk.EnosixFramework.Message f = messages[mCnt];
            if (f.Type != ensxsdk.EnosixFramework.MessageType.INFO && 
                f.Type != ensxsdk.EnosixFramework.MessageType.SUCCESS)
            {
                ensxtx_UTIL_PageMessages.messageList.add(new Message(f));
            }
        }
    }

    public static void addExceptionMessage(Exception ex)
    {
        System.debug(LoggingLevel.ERROR, ex.getMessage() + '\n' + ex.getStackTraceString());
        ensxtx_UTIL_PageMessages.messageList.add(new Message(ex));
    }

    // Build an html string table
    // Mainly use for storing the table in a rich text field
    public static String buildMesssageTableString()
    {
        String combineTable = '';
        if (ensxtx_UTIL_PageMessages.messageList.size() > 0) 
        {
            Map<String, List<Message>> messageTypeMessages = new Map<String, List<Message>>();
            for (Message message : ensxtx_UTIL_PageMessages.messageList)
            {
                List<Message> messages = messageTypeMessages.get(message.messageType);
                if (messages == null) messages = new List<Message>();

                messages.add(message);
                messageTypeMessages.put(message.messageType, messages);
            }

            // Build the table
            for (String messageType : messageTypeMessages.keySet()) {

                // Background color for different message type
                String backgroundColor = '';
                if (messageType == ensxtx_UTIL_PageMessages.ERROR) backgroundColor = '#f2a199';
                else if (messageType == ensxtx_UTIL_PageMessages.WARNING) backgroundColor = '#f8e38e';
                else if (messageType == ensxtx_UTIL_PageMessages.INFO) backgroundColor = '#bee6ff';

                String table = '<div style="border: solid black 1px;"><table style="width:100%">';
                table += '<thead>';
                table += '<tr style="background-color:' + backgroundColor + ';">';
                table += '<th style="border: solid black 1px;">' + messageType + '&nbsp;&nbsp;</th>';
                table += '</tr>';
                table += '</thead>';
                table += '<tbody>';

                List<Message> messages = messageTypeMessages.get(messageType);
                for (Message message : messages) {
                    table += '<tr>';
                    table += '<td style="border: solid black 1px;">' + message.message + '&nbsp;&nbsp;</td>';
                    table += '</tr>';
                }
                table += '</tbody>';
                table += '</table></div>';
                table += '<p>&nbsp;</p>';
                combineTable += table;
            }
        }

        return combineTable;
    }

    public with sharing class Message
    {
        @AuraEnabled public String messageType { get; set; }
        @AuraEnabled public String message { get; set; }
        @AuraEnabled public String id { get; set; }
        @AuraEnabled public String msgNumber { get; set; }
        @AuraEnabled public List<String> extendedTexts { get; set; }
        @AuraEnabled public String extendedText1 { get; set; }
        @AuraEnabled public String extendedText2 { get; set; }
        @AuraEnabled public String extendedText3 { get; set; }
        @AuraEnabled public String extendedText4 { get; set; }

        public Message() { }

        public Message(String messageType, String message)
        {
            this.messageType = messageType;
            this.message = message;

            logMessage();
        }

        /// @description Helper constructor to create a message from an EnosixFramework Message
        public Message(ensxsdk.EnosixFramework.Message f)
        {
            this.message = f.Text;
            this.messageType = INFO;
            this.id = f.Id;
            this.msgNumber = f.MsgNumber;
            this.extendedTexts = f.ExtendedText;
            this.extendedText1 = f.ExtendedText1;
            this.extendedText2 = f.ExtendedText2;
            this.extendedText3 = f.ExtendedText3;
            this.extendedText4 = f.ExtendedText4;

            switch on f.Type
            {
                when SUCCESS {
                    this.messageType = SUCCESS;
                }
                when WARNING {
                    this.messageType = WARNING;
                }
                when ERROR
                , ABNORMALEND
                , SAPEXIT {
                    this.messageType = ERROR;
                }
                when else
                {
                   this.messageType = INFO;
                }
            }
            System.debug(LoggingLevel.ERROR, JSON.serialize(new Map<String, Object>{
                    'Id' => f.Id,
                    'MsgNumber' => f.MsgNumber,
                    'Text' => f.Text,
                    'Type' => String.valueOf(f.Type),
                    'ExtendedTexts' => f.ExtendedText,
                    'ExtendedText1' => f.ExtendedText1,
                    'ExtendedText2' => f.ExtendedText2,
                    'ExtendedText3' => f.ExtendedText3,
                    'ExtendedText4' => f.ExtendedText4
                }
            ));
            logMessage();
        }

        /// @description Helper constructor to create a message from an Exception
        public Message(Exception ex)
        {
            this.message = ex.getMessage();
            this.messageType = ERROR;

            logMessage(ex);
        }

        private void logMessage()
        {
            logMessage(null);
        }

        private void logMessage(Exception ex)
        {
            if (null != ex)
                logger.error(ensxtx_UTIL_PageMessages.Message.class, ex);
            else if (ERROR == this.messageType)
                logger.error(this.message, this);
            else if (WARNING == this.messageType)
                logger.warn(this.message, this);
            else
                logger.info(this.message, this);
        }
    }
}