@isTest
public class LicenseWrapperTest {
	static testMethod void testParse() {
		String json=		'{'+
		'    "statusCode": "200 OK",'+
		'    "success": true,'+
		'    "data": ['+
		'        {'+
		'            "organizationId": "8a72012485fb8d5001860921d25201e9",'+
		'            "licenseId": "8a72043d85f4c49a01860924335a0772",'+
		'            "licensedOrganizationId": "8a72012485fb8d5001860921d25201e9",'+
		'            "licensedOrganizationDisplayName": "Mandalore District Nightly",'+
		'            "licensePoolType": "Student seat based licensing",'+
		'            "licensePoolStatus": "A",'+
		'            "denyNewSubscription": 0,'+
		'            "programName": "Realize",'+
		'            "quantity": 1,'+
		'            "usedLicensesForThisOrg": 0,'+
		'            "productId": "789720",'+
		'            "productDisplayName": "Realize testing data Massachusetts Grade 01 Science Boston 123456789012 Science Boston 1234567890123",'+
		'            "startDate": "2024-09-05T16:58:22.703Z",'+
		'            "endDate": "2025-09-05T16:58:22.703Z",'+
		'            "orderedISBN": "9830220171118",'+
		'            "productShortDescription": "Realize testing data Massachusetts Grade 01 Science Boston 123456789012 Science Boston 1234567890123",'+
		'            "productLongDescription": "Realize testing data Massachusetts Grade 01 Science Boston 123456789012 Science Boston 1234567890123",'+
		'            "authContextIds": {'+
		'                "authContextId": ['+
		'                    6065'+
		'                ]'+
		'            },'+
		'            "authContextIdList": ['+
		'                6065'+
		'            ],'+
		'            "productType": "regular",'+
		'            "associatedPlatforms": ['+
		'                "realize"'+
		'            ],'+
		'            "daysLeft": 802,'+
		'            "customerPO": "ABC",'+
		'            "sapOrderDocumentNumber": "1245636253627",'+
		'            "sapOrderType": "",'+
		'            "orgSAPID": "15361275376257",'+
		'            "SalesForceID": "253473748688923748"'+
		'        },'+
		'		{'+
		'            "organizationId": "8a72012485fb8d5001860921d25201e9",'+
		'            "licenseId": "8a72043d85f4c49a01860924335a0772",'+
		'            "licensedOrganizationId": "8a72012485fb8d5001860921d25201e9",'+
		'            "licensedOrganizationDisplayName": "Mandalore District Nightly",'+
		'            "licensePoolType": "Student seat based licensing",'+
		'            "licensePoolStatus": "A",'+
		'            "denyNewSubscription": 0,'+
		'            "programName": "Realize",'+
		'            "quantity": 1,'+
		'            "usedLicensesForThisOrg": 0,'+
		'            "productId": "789720",'+
		'            "productDisplayName": "Realize testing data Massachusetts Grade 01 Science Boston 123456789012 Science Boston 1234567890123",'+
		'            "startDate": "2024-09-05T16:58:22.703Z",'+
		'            "endDate": "2025-09-05T16:58:22.703Z",'+
		'            "orderedISBN": "9830220171118",'+
		'            "productShortDescription": "Realize testing data Massachusetts Grade 01 Science Boston 123456789012 Science Boston 1234567890123",'+
		'            "productLongDescription": "Realize testing data Massachusetts Grade 01 Science Boston 123456789012 Science Boston 1234567890123",'+
		'            "authContextIds": {'+
		'                "authContextId": ['+
		'                    6065'+
		'                ]'+
		'            },'+
		'            "authContextIdList": ['+
		'                6065'+
		'            ],'+
		'            "productType": "regular",'+
		'            "associatedPlatforms": ['+
		'                "realize"'+
		'            ],'+
		'            "daysLeft": 802,'+
		'            "customerPO": "ABCE",'+
		'            "sapOrderDocumentNumber": "1245636253622",'+
		'            "sapOrderType": "",'+
		'            "orgSAPID": "15361275376255",'+
		'            "SalesForceID": "253473748688923747"'+
		'        },'+
		'		{'+
		'            "organizationId": "8a72012485fb8d5001860921d25201e9",'+
		'            "licenseId": "8a72043d85f4c49a01860924335a0772",'+
		'            "licensedOrganizationId": "8a72012485fb8d5001860921d25201e9",'+
		'            "licensedOrganizationDisplayName": "Mandalore District Nightly",'+
		'            "licensePoolType": "Student seat based licensing",'+
		'            "licensePoolStatus": "A",'+
		'            "denyNewSubscription": 0,'+
		'            "programName": "Realize",'+
		'            "quantity": 1,'+
		'            "usedLicensesForThisOrg": 0,'+
		'            "productId": "789720",'+
		'            "productDisplayName": "Realize testing data Massachusetts Grade 01 Science Boston 123456789012 Science Boston 1234567890123",'+
		'            "startDate": "2024-09-05T16:58:22.703Z",'+
		'            "endDate": "2025-09-05T16:58:22.703Z",'+
		'            "orderedISBN": "9830220171118",'+
		'            "productShortDescription": "Realize testing data Massachusetts Grade 01 Science Boston 123456789012 Science Boston 1234567890123",'+
		'            "productLongDescription": "Realize testing data Massachusetts Grade 01 Science Boston 123456789012 Science Boston 1234567890123",'+
		'            "authContextIds": {'+
		'                "authContextId": ['+
		'                    6065'+
		'                ]'+
		'            },'+
		'            "authContextIdList": ['+
		'                6065'+
		'            ],'+
		'            "productType": "regular",'+
		'            "associatedPlatforms": ['+
		'                "realize"'+
		'            ],'+
		'            "daysLeft": 802,'+
		'            "customerPO": "ABCD",'+
		'            "sapOrderDocumentNumber": "1245636253624",'+
		'            "sapOrderType": "",'+
		'            "orgSAPID": "15361275376256",'+
		'            "SalesForceID": "253473748688923749"'+
		'        }'+
		'    ]'+
		'}'+
		'';
		LicenseWrapper obj = LicenseWrapper.parse(json);
		System.assert(obj != null);
	}
}