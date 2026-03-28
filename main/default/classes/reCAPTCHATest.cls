@isTest
private class reCAPTCHATest {                      
     @isTest static void testCallout() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new reCAPTCHAMockCallout());
        
        system.assert(reCAPTCHA.verify('abc', 'def'));
    }


}