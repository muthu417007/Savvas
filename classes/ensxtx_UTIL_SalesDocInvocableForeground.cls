public class ensxtx_UTIL_SalesDocInvocableForeground
{
    @InvocableMethod(label='Sales Doc Invocable Foreground' description='Invoke create or update SAP sales document in foreground' category='enosix' callout=true)
    public static void salesDocInvocable(List<ensxtx_UTIL_SalesDocInvocableActions.Request> requestList)
    {
        if (requestList.size() > 1) {
            throw new ensxtx_UTIL_SalesDocInvocableActions.SalesDocActionException('Processing more than one Sales Document at a time must be done in the Background');
        }
        ensxtx_UTIL_SalesDocInvocableActions.invokeSalesDoc(requestList[0]);
    }
}