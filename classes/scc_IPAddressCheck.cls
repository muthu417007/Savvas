/*
Apex Class: scc_IPAddressCheck
Author: CTS (D, Balamurugan)
Reason: Backend logic of "Scc_signInLWC" for the User IpAddress check functionality.
Created Date: 13/06/2024
Modified Date: 14/06/2024
*/
public with sharing class scc_IPAddressCheck {
    /**
    *  Description: Check the user's IpAddress within the range.
    *  @param : none
    *  @return : Boolean .
    */
	@AuraEnabled(cacheable=true)
    public static Boolean checkIpAddress(String guestUserIpAddress){
        List<String> userIpAddressOctets = guestUserIpAddress.split('\\.');
        List<SCC_IpAddressRange__c> IpAddressRangeList = [Select Id, Start_IP_Address__c, End_IP_Address__c from SCC_IpAddressRange__c];        
        List<String> lowIpRangeOctets;
        List<String> highIpRangeOctets;
        Integer userIpAddressInteger;
        Integer lowIpRangeInteger;
        Integer highIpRangeInteger;
        for(SCC_IpAddressRange__c ipRange : IpAddressRangeList){
            lowIpRangeOctets = ipRange.Start_IP_Address__c.split('\\.');
            highIpRangeOctets = ipRange.End_IP_Address__c.split('\\.');
          
            for(Integer i=0;i<4;i++){
                userIpAddressInteger = Integer.valueOf(userIpAddressOctets[i]);
                lowIpRangeInteger = Integer.valueOf(lowIpRangeOctets[i]);
                highIpRangeInteger = Integer.valueOf(highIpRangeOctets[i]);
                if(lowIpRangeInteger>=0 && lowIpRangeInteger<=255 && highIpRangeInteger >=0 && highIpRangeInteger <=255){
                if(i==3){
                    if(lowIpRangeInteger == userIpAddressInteger || highIpRangeInteger == userIpAddressInteger){
                    	return true;
                	}
                	else if(lowIpRangeInteger < userIpAddressInteger && highIpRangeInteger > userIpAddressInteger){
               			return true;
            		}
                	else {
                    	return false;
                	}
                }
                else{  
                if(lowIpRangeInteger == userIpAddressInteger || highIpRangeInteger == userIpAddressInteger){
                    continue;
                }
                else if(lowIpRangeInteger < userIpAddressInteger && highIpRangeInteger > userIpAddressInteger){
               		return true;
            	}
                else if(lowIpRangeInteger > userIpAddressInteger || highIpRangeInteger < userIpAddressInteger){
                    return false;
                }
                }
                }
            }
        }
        return false;        
    }
}