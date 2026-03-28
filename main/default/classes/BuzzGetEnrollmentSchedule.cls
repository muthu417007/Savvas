/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Apex scheduled Class that does callout and to Buzz Agilix.
*
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Romer Pasag       <Romer.Pasag@pearson.com>
* @modifiedBy     Romer Pasag       <Romer.Pasag@pearson.com>
* @maintainedBy   Romer Pasag       <Romer.Pasag@pearson.com>
* @version        1.0
* @created        2017-09-13
* @modified       
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* v1.0            Romer.Pasag@pearson.com
* 
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

public class BuzzGetEnrollmentSchedule implements Schedulable {
    public void execute(SchedulableContext ctx){
        BuzzGetEnrollmentCallout.queryCapability();
     }
}