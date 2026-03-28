/*
Class Name : clsKimble_Process_Scheduling
Purpose : This controller is used to validate the date and calculate the working days
Created by : Nantha Eswaran
Modified by/date :
Lines Modified and Purpose: 
*/
public with sharing class clsKimble_Process_Scheduling{
// this function is getting called from Kimble_Scheduling_Request visual flow.
// Date time param contains date and time values with addition delivery date field values (ex: 2020-11-04,7:00 AM,8:00 AM,Dev Test)
// Calculates working days and retuns validation to flow to intimate the user to provide addition delivery date if the given date is less than 6 working date
// Validates the presentation start time and end time
   @InvocableMethod
   public static list<string> validateDates(List<string> DateTimes){
       System.Debug('DateTimes+++'+DateTimes);
       string[] dataparams = DateTimes[0].split(',');
       system.debug('dataparams+++'+dataparams.size());
       string[] dateparts = dataparams[0].split('-');
       string dateValue = dateparts[1]+'/'+dateparts[2]+'/'+dateparts[0];
        List<string> valid=new List<string>();
      
        System.debug('Date:+++'+dataparams);
        System.debug('Date:+++'+dateValue);
        Date dat= date.parse(dateValue);
        Date toD = date.today();
        Integer diff= toD.daysBetween(dat);
     //   if(calculateWorkingDays(toD,dat)<6 && dataparams.size()==3){
       if(calculateWorkingDays(toD,dat)<6){
            valid.add('R');
            return valid;
        }
    /*    DateTime dt=datetime.parse (dateValue+' '+dataparams[1]);
        DateTime dt1=datetime.parse (dateValue+' '+dataparams[2]);
        System.Debug('dt+++'+dt);
        System.Debug('dt1+++'+dt1);
        if(dt1>dt){
         valid.add('Y');   
        }else{
         valid.add('N'); 
        }*/
        System.Debug(valid);
    return valid; 
   }
public static Integer calculateWorkingDays(Date startDate, Date endDate){          
      
        Set<Date> holidaysSet = new Set<Date>();  
        Integer workingDays = 0;  
        for(integer i=0; i <= startDate.daysBetween(endDate); i++){  
            Date dt = startDate + i;  
            DateTime currDate = DateTime.newInstance(dt.year(), dt.month(), dt.day());  
            String todayDay = currDate.format('EEEE');  
            if(todayDay != 'Saturday' && todayDay !='Sunday' && (!holidaysSet.contains(dt))){  
                    workingDays = workingDays + 1;  
                }     
        }  
        System.debug('--Working days'+workingDays);  
        return workingDays;  
    }  
}