global class CPQ_CalloutCacheClearScheduler implements Schedulable {
    
    global void execute(SchedulableContext sc){
        CPQ_CalloutCache.clearCache();
    }
}