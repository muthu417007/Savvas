public class ScheduleEAccessThresholdBatch implements Schedulable {
    public void execute(SchedulableContext SC) {
        EAccessThresholdBatch batch = new EAccessThresholdBatch();
        Database.executeBatch(batch, 200);
    }
}