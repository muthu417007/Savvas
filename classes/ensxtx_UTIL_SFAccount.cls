public with sharing class ensxtx_UTIL_SFAccount implements ensxtx_I_CustSFSObjectDoc
{
    private static final ensxsdk.Logger logger = new ensxsdk.Logger(ensxtx_UTIL_SFAccount.class);

    public class CustomerFieldNameAccessException extends Exception 
    { 
        public override String getMessage()
        {
            return String.format(System.Label.ensxtx_CustomerNumberAccessException_Error, new String[]{CustomerFieldName});
        }
    }

    // The field name which stores the SAP Customer number
    private static String CustomerFieldNameSave = null;

    public static String CustomerFieldName
    {
        get
        {
            if (CustomerFieldNameSave == null) {
                CustomerFieldNameSave = '';
                try
                {
                    ensxtx_UTIL_CustomerMapping.CustomerInformationMapping mapping = ensxtx_UTIL_CustomerMapping.getMapping();
                    CustomerFieldNameSave = mapping.customerNumber.sObjectField;
                }
                catch(Exception ex) 
                { 
                    System.debug('Customer Field Name not found'); 
                }
                
                CustomerFieldNameSave = String.isNotEmpty(CustomerFieldNameSave) ? CustomerFieldNameSave : (String)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.EnterpriseApp, 'Account.CustomerFieldName', 'AccountNumber');
            }
            
            return CustomerFieldNameSave;
        }
    }

    public static Account getAccountById(Id value, List<String> fields)
    {
        return ensxtx_UTIL_SFAccount.getAccountByField('Id', value, fields);
    }

    public static Account getAccountById(Id value)
    {
        return ensxtx_UTIL_SFAccount.getAccountById(value, null);
    }

    private static Account getAccountByField(String selectField, String value, List<String> fields)
    {
        Account result = null;

        // These need to be lowercase so we can merge with `fields` var without duplicates
        // Duplicates cause SOQL exception
        List<String> selectFieldsList = new List<String> {
            'Name',
            'Phone',
            'Fax',
            'Billingstreet',
            'Billingcity',
            'Billingpostalcode',
            'Createddate',
            'ParentId',
            'Parent.' + ensxtx_UTIL_SFAccount.CustomerFieldName.toLowerCase(),
            ensxtx_UTIL_SFAccount.CustomerFieldName.toLowerCase()
        };

        Set<String> selectFieldSet = new Set<String>();
        for (String sf : selectFieldsList) selectFieldSet.add(sf.toLowerCase());

        Boolean isStateCode = ensxtx_UTIL_SObject.doesSobjectFieldExist('Account', 'BillingStateCode');
        String stateField = isStateCode ? 'BillingStateCode' : 'BillingState';
        String countryField = isStateCode ? 'BillingCountryCode' : 'BillingCountry';
        selectFieldSet.add(stateField.toLowerCase());
        selectFieldSet.add(countryField.toLowerCase());

        if (fields != null)
        {
            Integer fieldTot = fields.size();
            for (Integer fieldCnt = 0 ; fieldCnt < fieldTot ; fieldCnt++)
            {
                String field = fields[fieldCnt];
                if (String.isNotBlank(field))
                {
                    selectFieldSet.add(field.toLowerCase());
                }
            }
        }

        Map<String, Schema.SObjectField> fieldDefs = Schema.SObjectType.Account.fields.getMap();
        Set<String> accessibleFields = new Set<String>();
        selectFieldsList = new List<String>(selectFieldSet);
        Integer fieldTot = selectFieldsList.size();
        for (Integer fieldCnt = 0 ; fieldCnt < fieldTot ; fieldCnt++)
        {
            String field = selectFieldsList[fieldCnt];
            if (field.contains('.') || fieldDefs.get(field).getDescribe().isAccessible())
            {
                accessibleFields.add(field);
            }
        }

        try
        {
            if (null != value)
            {
                String query = 'SELECT ' +
                    String.escapeSingleQuotes(String.join(new List<String>(accessibleFields), ', ')) +
                    ' FROM Account WHERE ' +
                    String.escapeSingleQuotes(selectField.toLowerCase()) +
                    ' = :value LIMIT 1';
                result = Database.query(query);
            }
        }
		catch (Exception e)
		{
            System.debug(e);
            ensxtx_UTIL_PageMessages.addMessage(ensxtx_UTIL_PageMessages.WARNING, 'There was an issue retrieving an Account record for the provided Id');
		}
        return result;
    }

    public static Boolean canUserSetCustomerNumber()
    {
        Map<String, Schema.SObjectField> fields = Schema.SObjectType.Account.fields.getMap();
        return fields.get(ensxtx_UTIL_SFAccount.CustomerFieldName).getDescribe().isUpdateable();
    }

    public static Boolean canUserAccessCustomerNumber()
    {
        Map<String, Schema.SObjectField> fields = Schema.SObjectType.Account.fields.getMap();
        return fields.get(ensxtx_UTIL_SFAccount.CustomerFieldName).getDescribe().isAccessible();
    }

    public static String getCustomerNumberFromAccount(Account account)
    {
        String custFieldName = ensxtx_UTIL_SFAccount.CustomerFieldName;

        if (!canUserAccessCustomerNumber()) throw new CustomerFieldNameAccessException();

        return (String) account.get(custFieldName);
    }

    public static void setAccountCustomerNumber(Account account, String customerNumber)
    {
        if (canUserSetCustomerNumber())
        {
            String customerField = ensxtx_UTIL_SFAccount.CustomerFieldName;
            account.put(customerField, customerNumber);
        }
    }

    public static String getValueFromAccountField(Account a, string field, String warningMessageFormat)
    {
        String result = null;

        if (null == a || String.isBlank(field))
        {
            return result;
        }

        Map<String, Schema.SObjectField> fields = Schema.SObjectType.Account.fields.getMap();
        DescribeFieldResult fieldDef = fields.get(field) == null ? null : fields.get(field).getDescribe();
        if (fieldDef == null || !fieldDef.isAccessible())
        {
            String fieldLable = fieldDef == null ? 'Invalid Field' : fieldDef.getLabel();
            ensxtx_UTIL_PageMessages.addMessage(
                ensxtx_UTIL_PageMessages.WARNING,
                String.format(warningMessageFormat, new String[]{ fieldLable })
            );
            return result;
        }

        String accountField = field.toLowerCase();
        Object value = a.get(accountField);

        if (null != value)
        {
            return String.valueOf(value);
        }

        return result;
    }

    private SObject loadedSObject;
    private Id loadedId;

	public SObject getSObject(Id id)
	{
        if (loadedSObject != null && loadedId == id)
        {
            return loadedSObject;
        }

        loadedId = id;

		SObject result = null;

        string errorString = '';
        if (id != null)
        {
            result = ensxtx_UTIL_SFAccount.getAccountById(id);
            if (result != null) loadedId = result.Id;
        }

        if (result == null)
        {
            ensxtx_UTIL_PageMessages.addMessage(ensxtx_UTIL_PageMessages.ERROR, 
                'There was an issue retrieving an Account record: ' + errorString);
        }

        loadedSObject = result;
		return result;
	}

    public String getCustomerNumber(SObject sfSObject, String partnerFunction)
	{
        return sfSObject == null || sfSObject.getSObjectType().getDescribe().getName() != 'Account' ? null : (String) ((Account) sfSObject).get(ensxtx_UTIL_SFAccount.CustomerFieldName);
	}

    public String getParentCustomerNumber(SObject sfSObject, String partnerFunction)
	{
        return sfSObject == null || sfSObject.getSObjectType().getDescribe().getName() != 'Account' || ((Account) sfSObject).ParentId == null ? null : (String) ((Account) sfSObject).Parent.get(ensxtx_UTIL_SFAccount.CustomerFieldName);
	}

    public ensxtx_DS_Customer_Detail sObjectToCustomerMapping(
        SObject sfSObject,
        ensxtx_DS_Customer_Detail customerDetail,
        String partnerFunction)
    {
        //Do the mapping from SObject and SF Line Items to salesDocDetail here
        Account aObj = (Account) sfSObject;

        if (customerDetail == null) customerDetail = new ensxtx_DS_Customer_Detail();
        customerDetail.Name = aObj.Name;
        customerDetail.PhoneNumber = aObj.Phone;
        customerDetail.FaxNumber = aObj.Fax;
        customerDetail.StreetAddress = aObj.BillingStreet;
        customerDetail.City = aObj.BillingCity;
        customerDetail.PostalCode = aObj.BillingPostalCode;
        Boolean isStateCode = ensxtx_UTIL_SObject.doesSobjectFieldExist('Account', 'BillingStateCode');
        String stateField = isStateCode ? 'BillingStateCode' : 'BillingState';
        String countryField = isStateCode ? 'BillingCountryCode' : 'BillingCountry';
        customerDetail.Region = (String) aObj.get(stateField);
        customerDetail.Country = (String) aObj.get(countryField);
        customerDetail.CustomerNumber = getCustomerNumber(sfSObject, partnerFunction);

        // SALES DATA
        // New Sales Data and Company Data for new customer
        ensxtx_DS_Customer_Detail.SALES_DATA newSalesData = new ensxtx_DS_Customer_Detail.SALES_DATA();
        newSalesData.SalesOrganization = (String) ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.CustInvocable, 'DefaultSalesOrganization', null);
        newSalesData.DistributionChannel = (String) ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.CustInvocable, 'DefaultDistributionChannel', null);
        newSalesData.Division = (String) ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.CustInvocable, 'DefaultDivision', null);
        customerDetail.SALES_DATA = new List<ensxtx_DS_Customer_Detail.SALES_DATA>();
        customerDetail.SALES_DATA.add(newSalesData);

        // COMPANY DATA
        ensxtx_DS_Customer_Detail.COMPANY_DATA newCompanyData = new ensxtx_DS_Customer_Detail.COMPANY_DATA();
        customerDetail.COMPANY_DATA = new List<ensxtx_DS_Customer_Detail.COMPANY_DATA>();
        customerDetail.COMPANY_DATA.add(newCompanyData);

        return customerDetail;
    }

    public SObject customerMappingToSObject(
        SObject sfSObject, 
        ensxtx_DS_Customer_Detail customerDetail,
        String partnerFunction)
    {
        Account aObj = (Account) sfSObject;
        
        if (customerDetail.IsSuccess) aObj.put(ensxtx_UTIL_SFAccount.CustomerFieldName, customerDetail.CustomerNumber);
        
        return aObj;
    }
}