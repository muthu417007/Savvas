/* -----------------------------------------------------------------------------------------------------------------------
Name:        CustomLookupLwcController
Description: This class is called from CustomLookupComp LWC component.
             This is generic class which will query based on the user input and send the result to the Lightning Component

Date         Version  Author             Summary of Changes
-----------  -------  -----------------  ------------------------------------------------------------------------------
03/12/2022     1.0     Soundhariya       Initial Release
13/02/2022     2.0     Soundhariya       February First Biweekly Release
----------------------------------------------------------*/
public class CustomLookupLwcController {
/*
Method Name : fetchLookupData
Arguments: 
	searchTerm - Contains search text for the Query
	myObject - Contains object details for the Query
	filter - Contains filter condition for the Query
	relatedField - Contains parent field for the Query
	queryFields - Contains other field details for the Query
Description: This method will query based on the user input and send the result to the Lightning Component
*/
    @AuraEnabled(cacheable=true)  
    public static List<sObject> fetchLookupData(String searchTerm, string myObject, String filter,String relatedField, String queryFields) {
        String myQuery = null;
        List<sObject> lookUpList = new List<sObject>();
        //Contact search
        if(filter != null && filter != ''){
			if(searchTerm == null || searchTerm == ''){
				myQuery = 'Select Id, Name, '+queryFields+' from '+myObject+' Where '+relatedField+' = \''+filter+'\''+' ORDER BY LastViewedDate DESC LIMIT  5';
			}
			else{
				myQuery = 'Select Id, Name, '+queryFields+' from '+myObject+' Where '+relatedField+' = \''+filter+'\''+' AND Name Like  \'%' + searchTerm + '%\' ORDER BY LastViewedDate DESC LIMIT  5';
			}            
        }
        else {
            if(searchTerm != null && searchTerm != '' && myObject == 'Account'){
                myQuery = 'Select Id, Name, '+queryFields+' from '+myObject+' Where Name Like  \'%' + searchTerm + '%\' ORDER BY LastViewedDate DESC LIMIT  5';
            }
			else if((searchTerm == null || searchTerm == '') && myObject == 'Account'){
				myQuery = 'Select Id, Name, '+queryFields+' from '+myObject+' Where LastViewedDate!= null ORDER BY LastViewedDate DESC LIMIT  5';
			}
        }
        system.debug('myQuery: '+myQuery);
        if(myQuery != null){            
       	 lookUpList = database.query(myQuery);
        }
        return lookUpList;
    }
    
}