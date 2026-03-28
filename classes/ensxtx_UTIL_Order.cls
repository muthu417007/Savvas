public with sharing class ensxtx_UTIL_Order
{
    private static final ensxsdk.Logger logger = new ensxsdk.Logger(ensxtx_UTIL_Order.class);

    public static Map<String, Set<String>> allowedItemCategoriesByOrderType
    {
        get
        {
            return (Map<String, Set<String>>)ensxtx_UTIL_AppSettings.getMap(
                ensxtx_UTIL_AppSettings.EnterpriseApp,
                'Order.AllowedItemCategoriesByOrderType',
                String.class,
                Set<String>.class,
                new Map<String, Set<String>>()
            );
        }
    }
}