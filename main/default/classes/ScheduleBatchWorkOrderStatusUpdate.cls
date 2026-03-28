global class ScheduleBatchWorkOrderStatusUpdate implements Schedulable {
    global void execute(SchedulableContext ctx) {
        
       ID BatchId = Database.executeBatch(new BatchWorkOrderStatusUpdate(), 200);
    }

}