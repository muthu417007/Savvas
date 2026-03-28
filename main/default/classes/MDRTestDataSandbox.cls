/* -----------------------------------------------------------------------------------------------------------------------
 *  MDRTestDataForRefresh
Name:       MDRTestDataSandbox
Description: This class will be executed after refresh of the sandbox, it'll create test data in the sandbox


Date         Version         Author                          Summary of Changes
-----------  -------    -----------------           ------------------------------------------------------------------------------
12/09/2023     1.0    Pummy Kumari Gupta       December Biweekly release(W-012307)

-------------------------------------------------------------------------------------------------------------------------- *///MDRTestDataForSandbox//
global class MDRTestDataSandbox implements SandboxPostCopy {
    global void runApexClass(SandboxContext context) {
        createTestData();
    }
   @TestVisible
    public void createTestData()
    {
        List<sObject> records = new List<sObject>();
        String siteDomain = Url.getOrgDomainURL().getHost().split('\\.')[0];
        system.debug('siteDomain: '+siteDomain);
        String username='easybridgetest@test.com.'+siteDomain;
        List<User> userList = [SELECT Id FROM User WHERE Username = :username LIMIT 1];
        User testuser = new User();
        if (userList.size() == 0 || Test.isRunningTest()) {
            Id systemAdminProfileId = [SELECT Id FROM Profile WHERE Name = 'ICOM Integration User' LIMIT 1].Id;
            if(Test.isRunningTest())
         		testuser.Username = 'easytest@abc.com.'+siteDomain;
            else
                testuser.Username = 'easybridgetest@test.com.'+siteDomain;
        	testuser.FirstName = 'EasyBridge';
        	testuser.LastName = 'test';
        	testuser.Alias = 'Alias';
        	testuser.Email = 'easybridgetest@test.com';
        	testuser.TimeZoneSidKey = 'America/New_York';
        	testuser.LocaleSidKey = 'en_US';
        	testuser.EmailEncodingKey = 'ISO-8859-1';
        	testuser.ProfileId = systemAdminProfileId;
        	testuser.LanguageLocaleKey = 'en_US';
        	insert testuser;
        }
        else {
            Id matchedUserId=userList[0].Id;
            testuser.Id=matchedUserId;
         }
        //creating parent accounts 
      
         StaticResource parentAccountStaticResource = [select Body from StaticResource
                                                where Name = 'ParentAccountCSV'];
        String ParentAccountCSV = parentAccountStaticResource.Body.toString();
        System.debug('ParentAccountCSV ' +ParentAccountCSV);
        Account[] parentAccountList = new Account[] {};
        for(String row : ParentAccountCSV.split('\n|\r\n')) {
            String[] column = row.split(',');
            system.debug('column size: '+column.size());
            system.debug('column content: '+column);
          // String rumbaOrganizationId =column[1]!='null'? column[1]:null;
            parentAccountList.add(new Account(
                Name = column[0],
                //Rumba_Organization_ID__c=column[1], 
                OwnerId=testuser.Id                
            ));
            //else
           
        }
        insert parentAccountList;
         
        /*
         * Use a Map to avoid creating an unnecessary External ID field on Account
         */
        Map<String, Id> parentAccountMap = new Map<String, Id>();
        for (Account acc : parentAccountList) {
            if(String.isNotBlank(acc.Name))
            	parentAccountMap.put(acc.Name, acc.Id);
        }
        //creating child account
        StaticResource childAccountStaticResource = [select Body from StaticResource
                                                where Name = 'ChildAccountCSV'];
        String ChildAccountCSV = childAccountStaticResource.Body.toString();
        Account[] childAccountList = new Account[] {};
        for(String row : ChildAccountCSV.split('\n|\r\n')) {
            system.debug('child row--->'+row);
            String[] column = row.split(',');
            String rumbaOrganizationId =column[1]!='null'? column[1]:null;
            system.debug('Parent account name--->'+column[2]);
            system.debug('Parent account id--->'+parentAccountMap.get(column[2]));
            childAccountList.add(new Account(
                Name = column[0],
                Rumba_Organization_ID__c= rumbaOrganizationId,
                OwnerId=testuser.Id,  
                ParentId=parentAccountMap.get(column[2])
            ));
        }
        insert childAccountList;
         
        /*
         * Use a Map to avoid creating an unnecessary External ID field on Account
         */
        Map<String, Id> childAccountMap = new Map<String, Id>();
        for (Account acc : childAccountList) {
            childAccountMap.put(acc.Name, acc.Id);
        }
        //create contacts
        StaticResource contactStaticResource = [select Body from StaticResource
                                                where Name = 'ContactCSV'];
        String ContactCSV = contactStaticResource.Body.toString();
        Contact[] contactList = new Contact[] {};
        for(String row : ContactCSV.split('\n|\r\n')) {
            String[] column = row.split(',');
            Boolean isInactive =column[4].equalsIgnoreCase('true');
            contactList.add(new Contact(
                FirstName = column[0],
                LastName = column[1],
              AccountId = childAccountMap.get(column[6]),
                Primary_Role__c = column[2],
                MDR_ID__c = column[3],
               	Inactive__c= isInactive,
                Email = column[5]
            ));
             system.debug('account name'+childAccountMap.get(column[6]));
        }
        insert contactList;
    }
}