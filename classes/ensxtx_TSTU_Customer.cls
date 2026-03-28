@isTest
public class ensxtx_TSTU_Customer
{
    @isTest
    static void test_TouchProps()
    {
        Test.startTest();
        String soldTo = ensxtx_UTIL_Customer.SOLD_TO_PARTNER_CODE;
        String shipTo = ensxtx_UTIL_Customer.SHIP_TO_PARTNER_CODE;
        String carrier = ensxtx_UTIL_Customer.CARRIER_PARTNER_CODE;
        String payer = ensxtx_UTIL_Customer.PAYER_PARTNER_CODE;
        String billTo = ensxtx_UTIL_Customer.BILL_TO_PARTNER_CODE;
        Test.stopTest();
    }
}