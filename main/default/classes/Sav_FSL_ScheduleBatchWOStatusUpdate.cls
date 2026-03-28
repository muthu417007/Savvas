global class Sav_FSL_ScheduleBatchWOStatusUpdate implements Schedulable{
    global void execute(SchedulableContext ctx) {
        
       ID BatchId = Database.executeBatch(new Sav_FSL_BatchWorkOrderStatusUpdate(), 200);
    }

}