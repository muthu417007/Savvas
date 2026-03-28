/*
Apex Test Class: scc_IPAddressCheckTest
Author: CTS (D, Balamurugan)
Created Date: 14/06/2024
Modified Date: 14/06/2024
*/
@isTest
public class scc_IPAddressCheckTest {
    /**
*  Description: Below method is to check IP address range
*  @name: checkIpAddressTest1
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void checkIpAddressTest1(){
        SCC_IpAddressRange__c ipRange = new SCC_IpAddressRange__c(Start_IP_Address__c='49.37.101.240', End_IP_Address__c='49.37.205.164');
        Insert ipRange;
        Test.startTest();
        System.assertEquals(true, scc_IPAddressCheck.checkIpAddress('49.37.130.240'));
        System.assertEquals(false, scc_IPAddressCheck.checkIpAddress('49.37.90.240'));
        Test.stopTest();
    }
    /**
*  Description: Below method is to check IP address range
*  @name: checkIpAddressTest2
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void checkIpAddressTest2(){
        SCC_IpAddressRange__c ipRange = new SCC_IpAddressRange__c(Start_IP_Address__c='49.37.230.120', End_IP_Address__c='49.37.230.164');
        Insert ipRange;
        Test.startTest();
        System.assertEquals(true, scc_IPAddressCheck.checkIpAddress('49.37.230.120'));
        System.assertEquals(true, scc_IPAddressCheck.checkIpAddress('49.37.230.154'));
        System.assertEquals(false, scc_IPAddressCheck.checkIpAddress('49.37.230.190'));
        Test.stopTest();
    }
      /**
*  Description: Below method is to check IP address range
*  @name: checkIpAddressTest3
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void checkIpAddressTest3(){
        Test.startTest();
        System.assertEquals(false, scc_IPAddressCheck.checkIpAddress('49.37.230.120'));
        Test.stopTest();
    }
}