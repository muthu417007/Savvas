trigger Eventtrigger on Event (before insert) {
    if(Trigger.isBefore){
        if(Trigger.isDelete){
            // In a before delete trigger, the trigger accesses the records that will be
            // deleted with the Trigger.old list.
            
        }
        else{
            // In before insert or before update triggers, the trigger accesses the new records
            // with the Trigger.new list.
            if(Trigger.isUpdate){
                
            }
            
            if(Trigger.isInsert){
                eventTriggerHandler.eventBeforeInsert(trigger.new);
            } 
        }
        
        // If the trigger is not a before trigger, it must be an after trigger.
    }
}