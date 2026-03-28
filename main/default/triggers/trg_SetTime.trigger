trigger trg_SetTime on Kimble_Scheduling_Request__c (before insert) {
     for(Kimble_Scheduling_Request__c  KSR: Trigger.new){
      if(KSR.Start__c!=null && KSR.End__c!=null){
          String[] strstTimeSplit = KSR.Start__c.split(':');
          String[] strstMin =strstTimeSplit[1].split(' ');
          Integer StHour=(strstMin[1] == 'PM' && Integer.valueOf(strstTimeSplit[0])!= 12) ? Integer.valueOf(strstTimeSplit[0]) +12 : Integer.valueOf(strstTimeSplit[0]);
          Time timeChangeStart = Time.newInstance( (strstMin[1] == 'PM' && Integer.valueOf(strstTimeSplit[0])!= 12) ? Integer.valueOf(strstTimeSplit[0]) +12 : Integer.valueOf(strstTimeSplit[0]) //hour
                                         ,Integer.valueOf(strstMin[0]) //min
                                         ,0                                //sec
                                         ,0);                              //ms
          
          KSR.Presentation_Start_Time__c=timeChangeStart  ;
          String[] strTimeSplit = KSR.End__c.split(':');
          String[] strMin =strTimeSplit[1].split(' ');
          Integer EndHour=(strMin[1] == 'PM' && Integer.valueOf(strTimeSplit[0])!= 12) ? Integer.valueOf(strTimeSplit[0]) +12 : Integer.valueOf(strTimeSplit[0]);
          Time timeChangeEnd = Time.newInstance( (strMin[1] == 'PM' && Integer.valueOf(strTimeSplit[0])!= 12) ? Integer.valueOf(strTimeSplit[0]) +12 : Integer.valueOf(strTimeSplit[0]) //hour
                                         ,Integer.valueOf(strMin [0]) //min
                                         ,0                                //sec
                                         ,0);                              //ms
          KSR.Presentation_End_Time__c =timeChangeEnd ;
          
          KSR.PresentationStartDateTime__c = DateTime.newInstance(KSR.Delivery_Date__c.Year(),KSR.Delivery_Date__c.Month(), KSR.Delivery_Date__c.Day(), StHour, Integer.valueOf(strstMin[0]), 0);
          KSR.PresentationEndDatetime__c = DateTime.newInstance(KSR.Delivery_Date__c.Year(),KSR.Delivery_Date__c.Month(), KSR.Delivery_Date__c.Day(), EndHour, Integer.valueOf(strMin[0]), 0);
      }
   }
}