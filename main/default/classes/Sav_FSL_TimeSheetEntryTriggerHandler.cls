/**
* Author: Cognizant Team
* Description: Handler class for Sav_FSL_ServiceAppointTrg
* Date Created: 25-04-2023
* Version: 1.0
*/
public class Sav_FSL_TimeSheetEntryTriggerHandler {
    /**
    *  Method : Gets invoked when the context is Before Insert on TimeSheetEntry.
    *  Name : beforeInsert
    *  param : list<TimeSheetEntry> timeEntryList
    *  return : void
    */
    public static void beforeInsert(List<TimeSheetEntry> timeEntryList){
        for(TimeSheetEntry ts:timeEntryList){
            ts.Sav_Duration__c = (ts.Sav_Duration__c == null) ? 0 : ts.Sav_Duration__c;
            decimal hoursEntered = ts.Sav_Duration__c;
            Integer hours;
            Integer minutes;
            List<String> timeParts = String.valueOf(hoursEntered).split('\\.');
            hours = Integer.valueOf(timeParts[0]);
            minutes = timeParts.size() == 2 ? Integer.valueOf(timeParts[1]) : 0;
            system.debug('minutes '+minutes);
            if(minutes!=null){
                if(minutes == 25){
                    minutes = 15;
                }
                if(minutes == 50 || minutes == 5){
                    minutes = 30;
                }
                if(minutes == 75){
                    minutes = 45;
                }
            }
            
            ts.EndTime = ts.StartTime.addHours(hours);
            ts.EndTime = ts.EndTime.addMinutes(minutes);
            system.debug('ts.EndTime '+ts.EndTime);
            system.debug('minutes '+minutes);
        }
        
    }
    
}