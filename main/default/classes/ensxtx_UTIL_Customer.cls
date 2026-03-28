public without sharing class ensxtx_UTIL_Customer
{
    private static final ensxsdk.Logger logger = new ensxsdk.Logger(ensxtx_UTIL_Customer.class);

    public static final string SOLD_TO_PARTNER_CODE = 'SP';
    public static final string SHIP_TO_PARTNER_CODE = 'SH';
    public static final string CONTACT_PARTNER_CODE = 'CP';
    public static final string CARRIER_PARTNER_CODE = 'CR';
    public static final string PAYER_PARTNER_CODE = 'PY';
    public static final string BILL_TO_PARTNER_CODE = 'BP';
    public static final string CARRIERS_PARTNER_CODE = 'ZA';
    public static final string LICENSE_PARTNER_CODE = 'ZL';
    
    public static final Map<string, string> partnerFunctionMap = new Map<string, string> {
        SOLD_TO_PARTNER_CODE => 'AG',
        SHIP_TO_PARTNER_CODE => 'WE',
        CONTACT_PARTNER_CODE => 'AP',
        PAYER_PARTNER_CODE => 'RG',
        BILL_TO_PARTNER_CODE => 'RE',
        LICENSE_PARTNER_CODE=> 'ZL',
        CARRIERS_PARTNER_CODE=> 'ZA'
    };
}