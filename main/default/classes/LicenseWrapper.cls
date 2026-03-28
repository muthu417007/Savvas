public class LicenseWrapper{
	public String statusCode;	//200 OK
	public boolean success;
	public cls_data[] data;
	public class cls_data {
		public String organizationId;	//8a72012485fb8d5001860921d25201e9
		public String licenseId;	//8a72043d85f4c49a01860924335a0772
		public String licensedOrganizationId;	//8a72012485fb8d5001860921d25201e9
		public String licensedOrganizationDisplayName;	//Mandalore District Nightly
		public String licensePoolType;	//Student seat based licensing
		public String licensePoolStatus;	//A
		public Integer denyNewSubscription;	//0
		public String programName;	//Realize
		public Integer quantity;	//1
		public Integer usedLicensesForThisOrg;	//0
		public String productId;	//789720
		public String productDisplayName;	//Realize testing data Massachusetts Grade 01 Science Boston 123456789012 Science Boston 1234567890123
		public String startDate;	//2024-09-05T16:58:22.703Z
		public String endDate;	//2025-09-05T16:58:22.703Z
		public String orderedISBN;	//9830220171118
		public String productShortDescription;	//Realize testing data Massachusetts Grade 01 Science Boston 123456789012 Science Boston 1234567890123
		public String productLongDescription;	//Realize testing data Massachusetts Grade 01 Science Boston 123456789012 Science Boston 1234567890123
		//public cls_authContextIds authContextIds;
		//public cls_authContextIdList[] authContextIdList;
		public String productType;	//regular
		//public cls_associatedPlatforms[] associatedPlatforms;
		public Integer daysLeft;	//802
		public String customerPO;	//ABC
		public String sapOrderDocumentNumber;	//1245636253627
		public String sapOrderType;	//
		public String orgSAPID;	//15361275376257
		public String SalesForceID;	//253473748688923748
	}
	/*public class cls_authContextIds {
		public cls_authContextId[] authContextId;
	}
	public class cls_authContextId {
	}
	public class cls_authContextIdList {
	}
	public class cls_associatedPlatforms {
		public String associatedPlatformsName;	//realize		
	}*/
	public static LicenseWrapper parse(String json){
		return (LicenseWrapper) System.JSON.deserialize(json, LicenseWrapper.class);
	}
}