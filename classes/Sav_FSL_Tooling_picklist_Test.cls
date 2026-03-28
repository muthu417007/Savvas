/**
 * ClassName: Sav_FSL_Tooling_picklist_Test
 *
 * Description: Test class to cover Sav_FSL_Tooling_picklist class. Also has gloabal MockHttpResponseGenerator which creates mock data for tooling API callouts
 *
 * Methods:
 * respond(HTTPRequest req) : Returns HTTPResponse taking HTTPRequest as input. Used to implement HttpCalloutMock for testing
 * testCreatePicklist() : Returns void data type. Used to test Sav_FSL_Tooling_picklist.createPicklist(String var) method
 * 
 * Author: CTS team
 * Created Date: 2 FEB 2024
 * Version: v1.0
 * Work no : W-013853
 */

@IsTest
global class Sav_FSL_Tooling_picklist_Test {

    // Implementing mock HTTP response wherever needed
    global class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            String jsonData;
            String endpoint = req.getEndpoint();
            if(endpoint.contains('/query')){
                jsonData = '{"Id":"00N5300000RXcCREA1"}';
            } else if(endpoint.contains('/sobjects')){
              		 jsonData = '{'+
		                '  \"Metadata\" : {'+
		                '    \"caseSensitive\" : null,'+
		                '    \"customDataType\" : null,'+
		                '    \"defaultValue\" : null,'+
		                '    \"deleteConstraint\" : null,'+
		                '    \"deprecated\" : null,'+
		                '    \"description\" : null,'+
		                '    \"displayFormat\" : null,'+
		                '    \"displayLocationInDecimal\" : null,'+
		                '    \"escapeMarkup\" : null,'+
		                '    \"externalDeveloperName\" : null,'+
		                '    \"externalId\" : false,'+
		                '    \"formula\" : null,'+
		                '    \"formulaTreatBlanksAs\" : null,'+
		                '    \"inlineHelpText\" : null,'+
		                '    \"isFilteringDisabled\" : null,'+
		                '    \"isNameField\" : null,'+
		                '    \"isSortingDisabled\" : null,'+
		                '    \"label\" : \"Manager\",'+
		                '    \"length\" : null,'+
		                '    \"maskChar\" : null,'+
		                '    \"maskType\" : null,'+
		                '    \"picklist\" : {'+
		                '      \"controllingField\" : null,'+
		                '      \"picklistValues\" : [ {'+
		                '        \"allowEmail\" : null,'+
		                '        \"closed\" : null,'+
		                '        \"color\" : null,'+
		                '        \"controllingFieldValues\" : null,'+
		                '        \"converted\" : null,'+
		                '        \"cssExposed\" : null,'+
		                '        \"default\" : false,'+
		                '        \"description\" : null,'+
		                '        \"forecastCategory\" : null,'+
		                '        \"highPriority\" : null,'+
		                '        \"probability\" : null,'+
		                '        \"reverseRole\" : null,'+
		                '        \"reviewed\" : null,'+
		                '        \"urls\" : null,'+
		                '        \"valueName\" : \"Allison Zimpfer\",'+
		                '        \"won\" : null'+
		                '      }, {'+
		                '        \"allowEmail\" : null,'+
		                '        \"closed\" : null,'+
		                '        \"color\" : null,'+
		                '        \"controllingFieldValues\" : null,'+
		                '        \"converted\" : null,'+
		                '        \"cssExposed\" : null,'+
		                '        \"default\" : false,'+
		                '        \"description\" : null,'+
		                '        \"forecastCategory\" : null,'+
		                '        \"highPriority\" : null,'+
		                '        \"probability\" : null,'+
		                '        \"reverseRole\" : null,'+
		                '        \"reviewed\" : null,'+
		                '        \"urls\" : null,'+
		                '        \"valueName\" : \"Amber J Kasic\",'+
		                '        \"won\" : null'+
		                '      } ],'+
		                '      \"restrictedPicklist\" : true,'+
		                '      \"sorted\" : false'+
		                '    },'+
		                '    \"populateExistingRows\" : null,'+
		                '    \"precision\" : null,'+
		                '    \"readOnlyProxy\" : null,'+
		                '    \"referenceTargetField\" : null,'+
		                '    \"referenceTo\" : null,'+
		                '    \"relationshipLabel\" : null,'+
		                '    \"relationshipName\" : null,'+
		                '    \"relationshipOrder\" : null,'+
		                '    \"reparentableMasterDetail\" : null,'+
		                '    \"required\" : false,'+
		                '    \"restrictedAdminField\" : null,'+
		                '    \"scale\" : null,'+
		                '    \"startingNumber\" : null,'+
		                '    \"stripMarkup\" : null,'+
		                '    \"summarizedField\" : null,'+
		                '    \"summaryFilterItems\" : null,'+
		                '    \"summaryForeignKey\" : null,'+
		                '    \"summaryOperation\" : null,'+
		                '    \"trackFeedHistory\" : null,'+
		                '    \"trackHistory\" : false,'+
		                '    \"type\" : \"Picklist\",'+
		                '    \"unique\" : null,'+
		                '    \"urls\" : null,'+
		                '    \"visibleLines\" : null,'+
		                '    \"writeRequiresMasterRead\" : null'+
		                '  },'+
		                '  \"FullName\" : \"ServiceResource.Sav_FSL_Manager__c\"'+
		                '}';
            }
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(jsonData);
            res.setStatusCode(200);
            return res;
        }
    }

	@TestSetup
    private static void makeData(){
        Profile p = [SELECT Id FROM Profile WHERE Name =: Label.ICOM_Professional_Services];
        User testUser = new User(Alias = 'newUser', Email='newuser@testorg.com',
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                                 LocaleSidKey='en_US', ProfileId = p.Id,
                                 TimeZoneSidKey='America/Los_Angeles', 
                                 Username = UserInfo.getOrganizationId() + System.now().millisecond()+'@test.com');
        insert testUser;
        User testUser1 = new User(Alias = 'newUser1', Email='newuser@testorg.com',
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                                  LocaleSidKey='en_US', ProfileId = p.Id,ManagerId = testUser.id,
                                  TimeZoneSidKey='America/Los_Angeles', Username = UserInfo.getOrganizationId() + System.now().millisecond()+'@test.com');
        insert testUser1;
        
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name =: Label.FSL_Consultant_Manager_Permissions];  //FSL_Resource_Permissions
        insert new PermissionSetAssignment(AssigneeId = testUser.id, PermissionSetId = ps.Id);
        insert new PermissionSetAssignment(AssigneeId = testUser1.id, PermissionSetId = ps.Id);
    }

    @isTest 
		public static void testCreatePicklist() {
        // Prepare test data
		User testUser = [SELECT Id,Name FROM User WHERE Alias = 'newUser'];
        User testUser1 = [SELECT Id,Name FROM User WHERE Alias = 'newUser1'];
        
        ServiceResource sR1 = new ServiceResource();
        sR1.Name = testUser1.Name;
        sR1.RelatedRecordId = testUser1.Id;
        sR1.Sav_FSL_Service_Resource_Type__c = System.Label.Sav_FSL_Service_resource_Type_FTE;
        sR1.ResourceType =System.Label.Sav_FSL_ResourceType_A;
        sR1.Sav_FSL_Primary_Role__c = System.Label.Sav_FSL_Primary_Role_CS;
        sR1.Sav_FSL_Start_Date__c = system.today(); 
        sR1.IsActive = true;
        insert sR1;

        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Call the method to test
        Test.startTest();
        Sav_FSL_Tooling_picklist.createPicklist();
        Test.stopTest();

    }
}