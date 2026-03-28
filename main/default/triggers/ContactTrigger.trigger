trigger ContactTrigger on Contact (before insert,before update,after insert,after update) {
if(Trigger.isBefore){
        if(Trigger.isDelete){
        // In a before delete trigger, the trigger accesses the records that will be
        // deleted with the Trigger.old list.

        }
        else{
        // In before insert or before update triggers, the trigger accesses the new records
        // with the Trigger.new list.
           if(Trigger.isUpdate)
		   		ContactTriggerHandler.handlerBeforeUpdate(trigger.new,trigger.oldMap);
            
           if(Trigger.isInsert){
           } 
        }

    // If the trigger is not a before trigger, it must be an after trigger.
    }else{
        if(Trigger.isUpdate){
            
        }
        if(Trigger.isInsert){
			
        }
    }
}