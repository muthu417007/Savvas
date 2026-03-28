// sfdx force:data:record:create -s ensxapp__LogSetting__c -v "ensxapp__Log_Sink__c=ensxtx_UTIL_EnsxAppLogSink"
global with sharing class ensxtx_UTIL_EnsxAppLogSink implements ensxapp.Invokable, Callable {
    // void log(ensxapp__Log__c logEntry)
    public Object invoke(Object logEntry) {
        if (logEntry == null) { return null; }

        // Adding extra debug line since the first debug message is not always being displayed.
        System.debug(System.LoggingLevel.ERROR, 'ensxtx_UTIL_EnsxAppLogSink.invoke');
        if (logEntry instanceof ensxapp__Log__c) {
            ensxapp__Log__c log = (ensxapp__Log__c) logEntry;
            if (log.ensxapp__LogLevel__c == 'HTTP_TRACE') {
                ensxtx_UTIL_Aura.addHttpTrace(log);
            }
        }
        // Logging at the highest level (ERROR) makes it less likely for the entries to be culled
        // when the log approaches the 2mb maximum size.
        System.debug(System.LoggingLevel.ERROR, logEntry);
        return null;
    }
    // enosix Sync: Link > Data Source [Configure] > Callout Logging Class
    global Object call(String action, Map<String, Object> args) {
        // Adding extra debug line since the first debug message is not always being displayed.
        System.debug(System.LoggingLevel.ERROR, 'ensxtx_UTIL_EnsxAppLogSink.call');
        String message = action + ':\n';
        try {
            ensxapp__Log__c log = new ensxapp__Log__c();
            log.ensxapp__Operation__c = action;
            log.ensxapp__LogLevel__c = 'HTTP_TRACE';
            for (String key : args.keySet()) {
                message += key + ':\n' + args.get(key) + '\n';
                switch on key {
                    when 'url'{
                        log.ensxapp__Request_URL__c = String.valueOf(args.get(key));
                    }
                    when 'reqHeaders'{
                        log.ensxapp__Request_Headers__c = String.valueOf(args.get(key));
                    }
                    when 'reqBody'{
                        log.ensxapp__Request_Body__c = String.valueOf(args.get(key));
                    }
                    when 'resHeaders'{
                        log.ensxapp__Response_Headers__c = String.valueOf(args.get(key));
                    }
                    when 'resBody'{
                        log.ensxapp__Response_Body__c = String.valueOf(args.get(key));
                    }
                    when 'page'{
                        log.ensxapp__Page__c = String.valueOf(args.get(key));
                    }
                    when 'start'{
                        log.ensxapp__Start_Time__c = DateTime.valueOf(args.get(key));
                    }
                    when 'end' {
                        log.ensxapp__End_Time__c = DateTime.valueOf(args.get(key));
                    }
                    when 'sbo'{
                        log.ensxapp__SBO_Name__c = String.valueOf(args.get(key));
                    }
                    when 'statusCode'{
                        log.ensxapp__Status_Code__c = Integer.valueOf(args.get(key));
                    }
                    when 'statusMessage'{
                        log.ensxapp__Status_Message__c = String.valueOf(args.get(key));
                    }
                    when 'context'{
                        log.ensxapp__Context_ID__c = String.valueOf(args.get(key));
                    }
                }
            }
            if (log.ensxapp__End_Time__c == null) {
                log.ensxapp__End_Time__c = datetime.now();
            }
            if (log.ensxapp__Start_Time__c == null) {
                log.ensxapp__Start_Time__c = log.ensxapp__End_Time__c;
            }
            log.ensxapp__Execution_Time__c = (log.ensxapp__End_Time__c.getTime() - log.ensxapp__Start_Time__c.getTime()) / 1000;

            ensxapp__LogSetting__c logSettings = ensxapp__LogSetting__c.getInstance();
            if (true == logSettings.ensxapp__HTTP_Trace__c && logSettings.ensxapp__LoggingLevel__c > 0)
            {
                Database.insert(log);
            }
        } catch (Exception e) { }
        System.debug(System.LoggingLevel.ERROR, message);
        if (!('httpRequest' == action || 'FetchPage' == action)) {
            String assertMessage =
                'ensxtx_UTIL_EnsxAppLogSink.call(action): Expected action to be "httpRequest" ' +
                'or "FetchPage". Actual action "' + action + '". Ensure this is only registered ' +
                'in "enosix Sync: Link > Data Source [Configure] > Callout Logging Class"';
            if(!Test.isRunningTest()) { System.assert(false, assertMessage); }
        }
        return null;
    }
}