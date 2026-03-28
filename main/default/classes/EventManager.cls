/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Apex REST class designed to provide Kimble Activity Assignment to Qualtrics Forms.
*
* The Apex Rest can be called using the public access of Integration community.
* No authentication is required to access the data
*
* HTTP Verbs Handled:
*
*   GET     -   Provide Kimble Activity Assignment information
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Romer Pasag       <Romer.Pasag@pearson.com>
* @modifiedBy     Heather McLemore  <heather.mclemore@pearson.com>
* @maintainedBy   Romer Pasag       <Romer.Pasag@pearson.com>
* @version        1.0
* @created        2017-07-26
* @modified       2019-05-09
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* 2019-05-09      Removed "Account_City__c" from select query; see W-002133 (Heather McLemore)
* v1.0            Romer.Pasag@pearson.com
* 2017-08-29      Updated the query to return the number of Attendees field
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/


@RestResource(urlMapping='/EventInfo/*')
global class EventManager {

    @HttpGet
    global static KimbleOne__ActivityAssignment__c getEventById() {
        RestRequest request = RestContext.request;
        // grab the EventId from the end of the URL
        String eventId = request.requestURI.substring(
          request.requestURI.lastIndexOf('/')+1);
        KimbleOne__ActivityAssignment__c result =  [select ID, Account_Id__c,Resource_Name__c,KimbleOne__ResourceUser__c,KimbleOne__StartDate__c,Number_of_Attendees__c,Workshop_Name__r.Name,Service_Type__c,Account_Name__c,KimbleOne__Location__r.name,(select ID,Capability_Type_Name__c,Name from KimbleOne__RequiredCapabilities__r where KimbleOne__IsMandatory__c=TRUE)  from KimbleOne__ActivityAssignment__c where event_id__c =:eventid];
        return result;
    }

}