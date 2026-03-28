global class CPQAuditDebug implements CameleonCPQ.CPQAuditUtils.IDebug
{
global void debug(String msg)
{
System.debug(LoggingLevel.INFO,msg);
}
}