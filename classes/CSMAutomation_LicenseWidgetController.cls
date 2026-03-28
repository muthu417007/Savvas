public class CSMAutomation_LicenseWidgetController {
    
     @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
         Set<Id> processedUserIds = new Set<Id>();
        Id loggedInUserId = '0056T000008PiHQ';//UserInfo.getUserId();
        Set<Id> userIds = new Set<Id>();

        // Start with the logged-in user's ID
        userIds.add(loggedInUserId);

        // Get all reportees recursively
        //Set<Id> reportees = fetchReporteesRecursive(loggedInUserId, processedUserIds);
        Set<Id> reportees = getAllUsersInHierarchy(userIds);
        userIds.addAll(reportees);
        system.debug('userIds '+userIds);
          List<Account> parentAccounts = [
                SELECT Id, Name, Rumba_Organization_ID__c 
                FROM Account 
                WHERE (Customer_Success_Manager__c IN :userIds) OR (SAA_Customer_Success_Manager__c IN :userIds)
            ];
        system.debug('parentAccounts '+parentAccounts);
            if(parentAccounts.isEmpty()){
                return null;
            }
            Set<Id> parentAccountId = new Set<Id>();
            for(Account acc:parentAccounts){
                parentAccountId.add(acc.Id);
            }
            List<Account> returnAccounts = new List<Account>();
            returnAccounts.addAll(parentAccounts);
            List<Account> childAccounts = [
                SELECT Id, Name, Rumba_Organization_ID__c
                FROM Account 
                WHERE ParentId IN :parentAccountId];
                System.debug('childAccounts<> '+childAccounts);

                if(!childAccounts.isEmpty()){
                    returnAccounts.addAll(childAccounts);
                }
                System.debug('returnAccounts<> '+returnAccounts);
                return returnAccounts;
    
    }
 private static Set<Id> fetchReporteesRecursive(Id managerId, Set<Id> processedUserIds) {
        Set<Id> userIds = new Set<Id>();
       
        if (processedUserIds.contains(managerId)) {
            system.debug('inside');
        return null;
        }
        processedUserIds.add(managerId);
        // Query direct reportees of the current manager
        List<User> reportees = [SELECT Id FROM User WHERE ManagerId = :managerId AND IsActive = true];
        
        if (!reportees.isEmpty()) {
            for (User u : reportees) {
                if(!processedUserIds.contains(u.Id)){
                 userIds.add(u.Id);
                // Recursively fetch IDs of reportees of the current user
                userIds.addAll(fetchReporteesRecursive(u.Id,processedUserIds));
                }
                else{
                    system.debug('contains'+u.id);
                }
                
            }
        }
        //system.debug('userIds<> '+userIds);
        return userIds;
    }
     // Helper method to fetch all users in the hierarchy recursively
    public static Set<Id> getAllUsersInHierarchy(Set<Id> userIds) {
        Set<Id> allUserIds = new Set<Id>(userIds);

        // Query direct subordinates of the given users
        List<User> subordinateUsers = [
            SELECT Id 
            FROM User 
            WHERE ManagerId IN :userIds AND IsActive = true
        ];
		system.debug('subordinateUsers'+subordinateUsers.size());
        // Collect subordinate user IDs
        Set<Id> subordinateIds = new Set<Id>();
        for (User user : subordinateUsers) {
            if (!allUserIds.contains(user.Id)) {
                subordinateIds.add(user.Id);
            }
        }
        // If we found subordinates, recurse to fetch their subordinates
        if (!subordinateIds.isEmpty()) {
            allUserIds.addAll(getAllUsersInHierarchy(subordinateIds));
        }
        //system.debug('allUserIds '+allUserIds.size());
        return allUserIds;
    }
    
    /*@AuraEnabled(cacheable=true)
    public static Map<String, Integer> processLicenseData(String recordId) {
  
        StaticResource sampleJSON = [SELECT Body FROM StaticResource WHERE Name = 'SampleLicenseAEJSONResponse' LIMIT 1];
        String jsonString = sampleJSON.Body.toString();

        Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
        List<Object> dataList = (List<Object>) jsonMap.get('data'); // Get the list as List<Object>

        Integer totalQuantity = 0;
        Integer totalUsedLicenses = 0;

        for (Object recordObj : dataList) {
            Map<String, Object> record = (Map<String, Object>) recordObj;

            totalQuantity += (Integer) record.get('quantity');
            totalUsedLicenses += (Integer) record.get('usedLicensesForThisOrg');
        }

        Map<String, Integer> result = new Map<String, Integer>();
        result.put('totalQuantity', totalQuantity);
        result.put('totalUsedLicenses', totalUsedLicenses);

        // Debug the result
        System.debug('Result: ' + result);

        return result;
    }*/
    
 /*  @AuraEnabled(cacheable=true)
public static List<Map<String, Object>> processLicenseData(String recordId) {
    // Fetching the JSON data from a static resource
    StaticResource sampleJSON = [SELECT Body FROM StaticResource WHERE Name = 'SampleLicenseAEJSONResponse' LIMIT 1];
    String jsonString = sampleJSON.Body.toString();
    
    // Deserialize the JSON response into a map
    Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
    List<Object> dataList = (List<Object>) jsonMap.get('data'); // Get the list as List<Object>

    // Initialize counters
    Integer totalQuantity = 0;
    Integer totalUsedLicenses = 0;

    // Iterate through the list and process each item
    for (Object recordObj : dataList) {
        // Cast each object to a map
        Map<String, Object> record = (Map<String, Object>) recordObj;

        // Add field values to counters
        totalQuantity += (Integer) record.get('quantity');
        totalUsedLicenses += (Integer) record.get('usedLicensesForThisOrg');
    }

    // Prepare the result in a suitable format for chart data
    List<Map<String, Object>> result = new List<Map<String, Object>>();
    result.add(new Map<String, Object>{'label' => 'Total Quantity', 'count' => totalQuantity});
    result.add(new Map<String, Object>{'label' => 'Total Used Licenses', 'count' => totalUsedLicenses});
	    // Debug the result
        System.debug('Result: ' + result);
    return result;
}*/

   @AuraEnabled(cacheable=true)
public static List<Map<String, Object>> processLicenseData() {
    // Fetching the JSON data from a static resource
    StaticResource sampleJSON = [SELECT Body FROM StaticResource WHERE Name = 'SampleLicenseAEJSONResponse' LIMIT 1];
    String jsonString = sampleJSON.Body.toString();
    
    // Deserialize the JSON response into a map
    Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
    List<Object> dataList = (List<Object>) jsonMap.get('data'); // Get the list as List<Object>

    // Initialize counters
    Integer totalQuantity = 0;
    Integer totalUsedLicenses = 0;

    // Iterate through the list and process each item
    for (Object recordObj : dataList) {
        // Cast each object to a map
        Map<String, Object> record = (Map<String, Object>) recordObj;

        // Add field values to counters
        totalQuantity += (Integer) record.get('quantity');
        totalUsedLicenses += (Integer) record.get('usedLicensesForThisOrg');
    }

    // Calculate the additional values
    Integer totalLicensesPurchased = totalQuantity;
    Integer totalLicensesProvisioned = totalQuantity;
    Integer totalLicensesAllocated = totalUsedLicenses;
    Integer totalLicensesNotAllocated = totalUsedLicenses > totalQuantity ? 0 : totalQuantity - totalUsedLicenses;
    Integer totalLicensesOverAllocated = totalUsedLicenses > totalQuantity ? totalUsedLicenses - totalQuantity : 0;

    // Prepare the result in a suitable format for chart data
    List<Map<String, Object>> result = new List<Map<String, Object>>();
    result.add(new Map<String, Object>{'label' => 'Licenses Purchased', 'count' => totalLicensesPurchased});
    result.add(new Map<String, Object>{'label' => 'Licenses Provisioned', 'count' => totalLicensesProvisioned});
    result.add(new Map<String, Object>{'label' => 'Licenses Allocated', 'count' => totalLicensesAllocated});
    result.add(new Map<String, Object>{'label' => 'Licenses Not Allocated', 'count' => totalLicensesNotAllocated});
    result.add(new Map<String, Object>{'label' => 'Licenses Over Allocated', 'count' => totalLicensesOverAllocated});

    // Debug the result
    System.debug('Result: ' + result);

    return result;
}

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> calculateExpiringLicenses() {
        // Fetching the JSON data from a static resource
        StaticResource sampleJSON = [SELECT Body FROM StaticResource WHERE Name = 'SampleLicenseAEJSONResponse' LIMIT 1];
        String jsonString = sampleJSON.Body.toString();
    
        // Deserialize the JSON response into a map
        Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
        List<Object> dataList = (List<Object>) jsonMap.get('data'); // Get the list as List<Object>
    
        // Initialize counters
        Integer expiringWithinSixMonths = 0;
        Integer expiringBetweenSixMonthsAndOneYear = 0;
    
        // Calculate date ranges
        Date today = Date.today();
        Date sixMonthsFromNow = today.addMonths(6);
        Date oneYearFromNow = today.addYears(1);
    
        // Iterate through the list and process each item
        for (Object recordObj : dataList) {
            // Cast each object to a map
            Map<String, Object> record = (Map<String, Object>) recordObj;
    
            // Parse the EndDate field (assuming it's in ISO-8601 format)
            String endDateString = (String) record.get('endDate');
            if (String.isNotBlank(endDateString)) {
                Date endDate = Date.valueOf(endDateString);
    
                // Check which category the license falls into
                if (endDate > today && endDate <= sixMonthsFromNow) {
                    expiringWithinSixMonths++;
                } else if (endDate > sixMonthsFromNow && endDate <= oneYearFromNow) {
                    expiringBetweenSixMonthsAndOneYear++;
                }
            }
        }
    
        // Prepare the result
        List<Map<String, Object>> result = new List<Map<String, Object>>();
        result.add(new Map<String, Object>{'label' => 'Expiring Within 6 Months', 'count' => expiringWithinSixMonths});
        result.add(new Map<String, Object>{'label' => 'Expiring Between 6 Months and 1 Year', 'count' => expiringBetweenSixMonthsAndOneYear});
    
        // Debug the result
        System.debug('Result: ' + result);
    
        return result;
    }
}