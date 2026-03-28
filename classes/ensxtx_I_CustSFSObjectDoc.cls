// ensxtx_I_SFSObjectDoc
//
// This interface is implemented by SalesForce Objects which are used to create
// SAP Customers such as Account and ContactPointAddress
public interface ensxtx_I_CustSFSObjectDoc
{
	SObject getSObject(Id id);
    String getCustomerNumber(SObject sfSObject, String partnerFunction);
    String getParentCustomerNumber(SObject sfSObject, String partnerFunction);
    ensxtx_DS_Customer_Detail sObjectToCustomerMapping(
        SObject sfSObject,
        ensxtx_DS_Customer_Detail customerDetail,
        String partnerFunction);
    SObject customerMappingToSObject(
        SObject sfSObject, 
        ensxtx_DS_Customer_Detail customerDetail,
        String partnerFunction);
}