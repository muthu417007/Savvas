public class ensxtx_UTIL_SalesDocInvocableBackground
{
    @InvocableMethod(label='Sales Doc Invocable Background' description='Invoke create or update SAP sales document in background' category='enosix' callout=false)
    public static void salesDocInvocable(List<ensxtx_UTIL_SalesDocInvocableActions.Request> requestList)
    {
        Integer queueCnt = 0;
        Integer queueTot = (Limits.getLimitQueueableJobs() / 2) - Limits.getQueueableJobs();
        Map<Integer, List<ensxtx_UTIL_SalesDocInvocableActions.Request>> requestQueueMap = new Map<Integer, List<ensxtx_UTIL_SalesDocInvocableActions.Request>>();
        for (ensxtx_UTIL_SalesDocInvocableActions.Request request : requestList)
        {
            List<ensxtx_UTIL_SalesDocInvocableActions.Request> splitRequestList = requestQueueMap.containsKey(queueCnt) ? requestQueueMap.get(queueCnt) : new List<ensxtx_UTIL_SalesDocInvocableActions.Request>();
            splitRequestList.add(request);
            requestQueueMap.put(queueCnt, splitRequestList);
            queueCnt += 1;
            if (queueCnt == queueTot) queueCnt = 0;
        }
        for (List<ensxtx_UTIL_SalesDocInvocableActions.Request> splitRequestList : requestQueueMap.values())
        {
            System.enqueueJob(new InvokeSalesDoc(splitRequestList));
        }
    }

    private class InvokeSalesDoc implements Queueable, Database.AllowsCallouts 
    {
        private List<ensxtx_UTIL_SalesDocInvocableActions.Request> requestList;

        InvokeSalesDoc(List<ensxtx_UTIL_SalesDocInvocableActions.Request> splitRequestList)
        {
            requestList = splitRequestList;
        }

        public void execute(QueueableContext context) 
        {
            ensxtx_UTIL_SalesDocInvocableActions.invokeSalesDoc(requestList[0]);

            requestList.remove(0);
            if (!Test.isRunningTest() && requestList.size() > 0) System.enqueueJob(new InvokeSalesDoc(requestList));
        }
    }
}