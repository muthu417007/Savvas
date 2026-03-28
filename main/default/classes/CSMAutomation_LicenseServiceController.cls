public with sharing class CSMAutomation_LicenseServiceController {
    @AuraEnabled(cacheable=true)
    public static List<CSMLicenseWrapper> getLicenseData(Id recordId) {
        // Fetch the static resource (SampleLicenseAEJSONResponse)
        StaticResource resource = [SELECT Body FROM StaticResource WHERE Name = 'SampleLicenseAEJSONResponse' LIMIT 1];
        String jsonResponse = resource.Body.toString();

        // Deserialize JSON into LicenseWrapper object
        LicenseWrapper licenseData = LicenseWrapper.parse(jsonResponse);

        // Fetch account hierarchy map using the passed recordId
        Map<String, Map<String, String>> accountHierarchyMap = getAccountHierarchy(recordId);
        
        // Fetch custom metadata record for the message
        String apiMessage = '';
        List<CSMAutomation_API_Message__mdt> metadataRecords = [
            SELECT Message__c 
            FROM CSMAutomation_API_Message__mdt 
            WHERE Type__c = 'With API Call'
            LIMIT 1
        ];
        if (!metadataRecords.isEmpty()) {
            apiMessage = metadataRecords[0].Message__c;
        }
        // Prepare data for LWC
        List<CSMLicenseWrapper> wrapperList = new List<CSMLicenseWrapper>();
        if (licenseData != null && licenseData.data != null) {
            for (LicenseWrapper.cls_data record : licenseData.data) {
                String accountName = accountHierarchyMap.containsKey(record.orgSAPID)
                    ? accountHierarchyMap.get(record.orgSAPID).get('AccountName')
                    : null;
                String parentAccountName = accountHierarchyMap.containsKey(record.orgSAPID)
                    ? accountHierarchyMap.get(record.orgSAPID).get('ParentAccountName')
                    : null;

             CSMLicenseWrapper wrapper = new CSMLicenseWrapper(
                    record.licensedOrganizationDisplayName,
                    record.programName,
                    record.orderedISBN,
                    record.customerPO,
                    record.sapOrderDocumentNumber,
                    record.sapOrderType,
                    record.licenseId,
                    record.quantity,
                    record.licensePoolStatus,
                    record.organizationId,
                    record.orgSAPID,
                    record.startDate,
                    record.endDate,
                    record.productDisplayName,
                    accountName,
                    parentAccountName
                );
                 // Add the message from custom metadata to the wrapper
                wrapper.apiMessage = apiMessage;
                wrapperList.add(wrapper);
            }
        }
        return wrapperList;
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, Map<String, String>> getAccountHierarchy(Id recordId) {
        // Map to store the hierarchy
        Map<String, Map<String, String>> accountHierarchyMap = new Map<String, Map<String, String>>();

        // Fetch the specified account (recordId) and its parent information
        Account startingAccount;
        if (recordId != null) {
            startingAccount = [SELECT Id, Name, SAP_Account_Id__c, ParentId, Parent.Name 
                               FROM Account WHERE Id = :recordId LIMIT 1];
            System.debug('startingAccount=>'+startingAccount);
        } else {
            throw new AuraHandledException('Record ID cannot be null');
        }

        if (startingAccount != null && startingAccount.SAP_Account_Id__c != null) {
            // Include the starting account in the hierarchy
            accountHierarchyMap.put(
                startingAccount.SAP_Account_Id__c,
                new Map<String, String> {
                    'AccountName' => startingAccount.Name,
                    'ParentAccountName' => startingAccount.Parent != null ? startingAccount.Parent.Name : null
                }
            );

            // Fetch all child accounts in hierarchy
            fetchChildAccounts(new Set<Id>{startingAccount.Id}, accountHierarchyMap);
        }

        System.debug('accountHierarchyMap in getAccountHierarchy method=> ' + accountHierarchyMap);
        return accountHierarchyMap;
    }

    private static void fetchChildAccounts(Set<Id> parentIds, Map<String, Map<String, String>> hierarchyMap) {
        if (parentIds.isEmpty()) return;
        // Query child accounts in batches
        List<Account> childAccounts = [
            SELECT Id, Name, SAP_Account_Id__c, ParentId, Parent.Name
            FROM Account
            WHERE ParentId IN :parentIds
        ];

        // Collect child IDs for the next recursive call
        Set<Id> childIds = new Set<Id>();

        for (Account acc : childAccounts) {
            if (acc.SAP_Account_Id__c != null) {
                hierarchyMap.put(
                    acc.SAP_Account_Id__c,
                    new Map<String, String> {
                        'AccountName' => acc.Name,
                        'ParentAccountName' => acc.Parent != null ? acc.Parent.Name : null
                    }
                );
                childIds.add(acc.Id);
            }
        }

        // Recursive call with collected child IDs
        if (!childIds.isEmpty()) {
            fetchChildAccounts(childIds, hierarchyMap);
        }
    }
    
    

    public class CSMLicenseWrapper {
        @AuraEnabled public String licensedOrganizationDisplayName;
        @AuraEnabled public String programName;
        @AuraEnabled public String orderedISBN;
        @AuraEnabled public String customerPO;
        @AuraEnabled public String sapOrderDocumentNumber;
        @AuraEnabled public String sapOrderType;
        @AuraEnabled public String licenseId;
        @AuraEnabled public Integer quantity;
        @AuraEnabled public String licensePoolStatus;
        @AuraEnabled public String organizationId;
        @AuraEnabled public String orgSAPID;
        @AuraEnabled public String startDate;
        @AuraEnabled public String endDate;
        @AuraEnabled public String productDisplayName;
        @AuraEnabled public String accountName; 
        @AuraEnabled public String parentAccountName;
        @AuraEnabled public String apiMessage; // Add this field for the API message

        public CSMLicenseWrapper(
            String organizationName,
            String productName,
            String isbn,
            String po,
            String orderDoc,
            String orderType,
            String licenseId,
            Integer licenseProvisioned,
            String status,
            String orgId,
            String sapOrgId,
            String startdate,
            String endDate,
            String productDisplayName,
            String accountName,
            String parentAccountName
        ) {
            this.licensedOrganizationDisplayName = organizationName;
            this.programName = productName;
            this.orderedISBN = isbn;
            this.customerPO = po;
            this.sapOrderDocumentNumber = orderDoc;
            this.sapOrderType = orderType;
            this.licenseId = licenseId;
            this.quantity = licenseProvisioned;
            this.licensePoolStatus = status;
            this.organizationId = orgId;
            this.orgSAPID = sapOrgId;
            this.startDate = startdate;
            this.endDate = endDate;
            this.productDisplayName = productDisplayName;
            this.accountName = accountName;
            this.parentAccountName = parentAccountName;
            this.apiMessage = '';
        }
    }
}