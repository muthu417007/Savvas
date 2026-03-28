public with sharing class ensxtx_UTIL_SFContact
{
    private static final ensxsdk.Logger logger = new ensxsdk.Logger(ensxtx_UTIL_SFContact.class);

    // Returns the field name which stores the SAP Contact number
    public static String ContactFieldName
    {
        get
        {
            return (String)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.EnterpriseApp, 'Contact.ContactFieldName', 'ensxtx_ContactPersonNumber__c');
        }
    }

    // Returns the field name which stores the SAP Customer number
    public static String ContactCustomerFieldName
    {
        get
        {
            return (String)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.EnterpriseApp, 'Contact.ContactCustomerFieldName', 'ensxtx_CustomerNumber__c');
        }
    }

    // getContactFromId()
    //
    // Get the contact from the given Id
    public static Contact getContactFromId(Id value)
    {
        Contact result = null;

        try
        {
            if (null != value)
            {
                String query = 'SELECT Id, FirstName, LastName, Phone, AccountId, Department, Email, Fax, MobilePhone, Title';
                String contactField = getContactFieldName();
                if (contactField != null) query += ', ' + contactField;
                query += ' FROM Contact WHERE Id = :value LIMIT 1';
                result = Database.query(query);
            }
        }
        catch (Exception e) {}
        return result;
    }

    public static String getContactNumberFromContact(Contact contact)
    {
        String contactField = getContactFieldName();
        if (contactField != null) return (String) contact.get(ensxtx_UTIL_SFContact.ContactFieldName);
        else return null;
    }

    public static void setContactContactNumber(Contact contact, string contactNumber)
    {
        String contactField = getContactFieldName();
        if (contactField != null) contact.put(ensxtx_UTIL_SFContact.ContactFieldName, contactNumber);
    }

    private static String getContactFieldName()
    {
        Map<String, Schema.SObjectField> fields = Schema.SObjectType.Contact.fields.getMap();
        return fields.get(ensxtx_UTIL_SFContact.ContactFieldName) == null ? null : ensxtx_UTIL_SFContact.ContactFieldName;
    }
}