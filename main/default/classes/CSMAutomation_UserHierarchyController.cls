public class CSMAutomation_UserHierarchyController {
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getUsersInHierarchyWithCount() {
        Map<String, Object> result = new Map<String, Object>();
        try {
            String profileName = 'ICOM Customer Success Manager';
			
            // Fetch the logged-in user's details
            User loggedInUser = [
                SELECT Id, Name 
                FROM User 
                WHERE Id = :UserInfo.getUserId()
            ];

            // Fetch users under the specified profile
            List<User> initialUsers = [
                SELECT Id, Name, ManagerId 
                FROM User 
                WHERE Profile.Name = :profileName AND IsActive = true
            ];

            // Collect initial user IDs for hierarchy expansion
            Set<Id> userIds = new Set<Id>();
            for (User user : initialUsers) {
                userIds.add(user.Id);
            }

            // Add logged-in user's ID to the set (if not already included)
            userIds.add(loggedInUser.Id);

            // Get all users in the hierarchy
            Set<Id> hierarchyUserIds = getAllUsersInHierarchy(new List<Id>(userIds));

            // Query the details of all users in the hierarchy
            List<User> allUsersList = [
                SELECT Id, Name 
                FROM User 
                WHERE Id IN :hierarchyUserIds AND IsActive = true
            ];

            // Map users to the required structure
            List<Map<String, String>> allUsers = new List<Map<String, String>>();
            for (User user : allUsersList) {
                allUsers.add(new Map<String, String>{'Id' => user.Id, 'Name' => user.Name});
            }

            // Prepare the result
            result.put('users', allUsers);
            result.put('loggedInUser', new Map<String, String>{'Id' => loggedInUser.Id, 'Name' => loggedInUser.Name});
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching users: ' + e.getMessage());
        }
        return result;
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getAccountsForSelectedUsers(List<Id> userIds) {
        Map<String, Object> result = new Map<String, Object>();
        try {
            if (userIds == null || userIds.isEmpty()) {
                result.put('preselectedAccounts', new List<Map<String, String>>());
                return result;
            }

            // Fetch all users in the hierarchy
            Set<Id> hierarchyUserIds = getAllUsersInHierarchy(userIds);

            // Query accounts owned by these users
            List<Account> relatedAccounts = [
                SELECT Id, Name 
                FROM Account 
                WHERE (Customer_Success_Manager__c IN :hierarchyUserIds) OR (SAA_Customer_Success_Manager__c IN :hierarchyUserIds)
            ];

            // Prepare the preselected accounts
            List<Map<String, String>> preselectedAccounts = new List<Map<String, String>>();
            for (Account acc : relatedAccounts) {
                preselectedAccounts.add(new Map<String, String>{'Id' => acc.Id, 'Name' => acc.Name});
            }

            result.put('preselectedAccounts', preselectedAccounts);
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching accounts: ' + e.getMessage());
        }
        return result;
    }

    // Helper method to fetch all users in the hierarchy recursively
    public static Set<Id> getAllUsersInHierarchy(List<Id> userIds) {
        Set<Id> allUserIds = new Set<Id>(userIds);

        // Query direct subordinates of the given users
        List<User> subordinateUsers = [
            SELECT Id 
            FROM User 
            WHERE ManagerId IN :userIds AND IsActive = true
        ];

        // Collect subordinate user IDs
        List<Id> subordinateIds = new List<Id>();
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
}