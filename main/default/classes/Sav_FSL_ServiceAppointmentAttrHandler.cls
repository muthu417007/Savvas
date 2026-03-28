/**
* Author: Cognizant Team
* Description: Handler class for Sav_FSL_ServiceAppointmentAttribute
* Date Created: 17-06-2023
* Version: 1.0
*/

public without sharing class Sav_FSL_ServiceAppointmentAttrHandler {
    public static Boolean boolStopRun = false;
    
    /**
    * Method Signature : handleAfterInsert
    * Input parameters :List of Service_Appointment_Attributes__c
    * Output: It will convert the existing Requested Delivery Start Date, Requested Delivery End Date, Alternate Date Fields as per customer timezone.
    * Description : This method converts the Requested Delivery Start Date, Requested Delivery End Date, Alternate Date Fields
    * as per the Customer Time Zone.
    */
    public static void handleAfterInsert(list<Service_Appointment_Attributes__c> listTriggerNew){
        //recursive check
        if (boolStopRun) return;
        boolStopRun = true;
        
        String RequestedDeliveryStartDate,AlternateDeliveryDate1,AlternateDeliveryDate2,RequestedDeliveryEndDate;
        Map<String,String> timeZoneMetaMap = new Map<String,String>();
        List<Service_Appointment_Attributes__c> saaLst = new List<Service_Appointment_Attributes__c>();
        List<Service_Appointment_Attributes__c> saaLstToUpd = new List<Service_Appointment_Attributes__c>();
        //fetch service appointment attributes
        saaLst = [Select Id, Work_Order__r.Sav_FSL_Customer_Time_Zone__c,Sav_FSL_Alternate_Delivery_Dates1__c,Sav_FSL_Alternate_Delivery_Dates2__c,Sav_FSL_Alternate_Delivery_Dates3__c,Sav_FSL_Requested_Delivery_Dates__c from Service_Appointment_Attributes__c where Id IN :listTriggerNew];
        //fetch timezone metadata records
        List<Sav_FSL_TimeZone_Names__mdt> timezone_metadatalist = [SELECT TimeZone_Name__c,MasterLabel from Sav_FSL_TimeZone_Names__mdt];
        if(timezone_metadatalist !=null && !timezone_metadatalist.isEmpty()){
            for(Sav_FSL_TimeZone_Names__mdt tzmdt:timezone_metadatalist){
                timeZoneMetaMap.put(tzmdt.MasterLabel,tzmdt.TimeZone_Name__c);
            }
        }
        if(!saaLst.isEmpty()){
            for(Service_Appointment_Attributes__c saa :saaLst){
                if(!String.ISBLANK(saa.Work_Order__r.Sav_FSL_Customer_Time_Zone__c)){
                    //get the customer time zone value
					String customerTZ = timeZoneMetaMap.get(saa.Work_Order__r.Sav_FSL_Customer_Time_Zone__c);

					// Set these time zones as per your need
					TimeZone customerTimeZone = TimeZone.getTimeZone(customerTZ);
					TimeZone userTimeZone = UserInfo.getTimeZone(); 

					Integer offsetToGMT = customerTimeZone.getOffset(DateTime.now());
					Integer offsetToUserTZ = userTimeZone.getOffset(DateTime.now());
					Integer offsetDiff = offsetToUserTZ - offsetToGMT ;
                    
                    if (saa.Sav_FSL_Requested_Delivery_Dates__c != Null) {
                        saa.Sav_FSL_Requested_Delivery_Dates__c = saa.Sav_FSL_Requested_Delivery_Dates__c.addMinutes(offsetDiff / (1000 * 60));
                        
                    }
                    if (saa.Sav_FSL_Alternate_Delivery_Dates1__c != Null) {
                        saa.Sav_FSL_Alternate_Delivery_Dates1__c = saa.Sav_FSL_Alternate_Delivery_Dates1__c.addMinutes(offsetDiff / (1000 * 60));
                    }
                    if (saa.Sav_FSL_Alternate_Delivery_Dates2__c != Null) {
                        saa.Sav_FSL_Alternate_Delivery_Dates2__c = saa.Sav_FSL_Alternate_Delivery_Dates2__c.addMinutes(offsetDiff / (1000 * 60));
                    }
                    if (saa.Sav_FSL_Alternate_Delivery_Dates3__c != Null) {
                        saa.Sav_FSL_Alternate_Delivery_Dates3__c = saa.Sav_FSL_Alternate_Delivery_Dates3__c.addMinutes(offsetDiff / (1000 * 60));
                    }
                    saaLstToUpd.add(saa); 
                }
                
            }
            if(!saaLstToUpd.isEmpty()) {
                list<Database.SaveResult> listResult = Database.update(saaLstToUpd, false);
            }
        }
        
    }
    
}