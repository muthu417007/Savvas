/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Apex class invoked by process builder to update the Buzz Agilix Enrollment.
*
* When a new Kimble Resource Capability is inserted with a Buzz Enrollment ID
* The method does a callout to Buzz and update the External ID of the enrollment
* with the Salesforce Resource Capability ID.
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Romer Pasag   	<Romer.Pasag@pearson.com>
* @modifiedBy     Romer Pasag   	<Romer.Pasag@pearson.com>
* @maintainedBy   Romer Pasag   	<Romer.Pasag@pearson.com>
* @version        1.0
* @created        2017-09-14
* @modified       
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* v1.0        	  Romer.Pasag@pearson.com
* 
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

public class BuzzUpdateEnrollmentMakeCallout {
    @InvocableMethod
    public static void invokeCalloutToBuzz(List<KimbleOne__ResourceCapability__c> capabilities){
        // Create a JSONGenerator object.
        // Format the JSON to the Buzz acceptable format
        // Pass true to the constructor for pretty print formatting.
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('requests');
        gen.writeStartObject();
        gen.writeFieldName('enrollment');
        gen.writeStartArray();
        //Use the Resource Capability ID and Buzz Enrollment ID on the JSON
        for(KimbleOne__ResourceCapability__c rc:capabilities){
            gen.writeStartObject();
            gen.writeStringField('enrollmentid',rc.Buzz_Enrollment_ID__c);
            gen.writeStringField('reference',rc.Id);
            gen.writeEndObject();
        }           
        gen.writeEndArray();
        gen.writeEndObject();
        gen.writeEndObject();
        String JSONString= gen.getAsString();
        // instantiate a new instance of the Queueable class
        // The queueable class performs the update to Buzz
        BuzzQueueableCallout updateJob=new BuzzQueueableCallout(JSONString,'');
        // enqueue the job for processing
		ID jobID = System.enqueueJob(updateJob);
        
    }
}