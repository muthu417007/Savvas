public class assetSobjectMashupSoapSforceCom {
    public class sObject_x {
        public String[] fieldsToNull;
        public String Id;

        //Begin Asset fields for Mashup

        public String Name;
        public String Product2;
        public String Product2Name;
        public String SerialNumber;
        public String InstallDate;
        public Double Quantity;
        public String Contact;
        public String FirstName;
        public String LastName;
        public String Status;
        
        //End Asset fields for Mashup

        private String[] fieldsToNull_type_info = new String[]{'fieldsToNull','http://www.w3.org/2001/XMLSchema','string','0','-1','true'};
        private String[] Id_type_info = new String[]{'Id','urn:enterprise.soap.sforce.com','ID','1','1','true'};

        //Begin Asset fields for Mashup

        private String[] Name_type_info = new String[]{'Name','http://www.w3.org/2001/XMLSchema','string','0','1','true'};
        private String[] Product2_type_info = new String[]{'Product2','http://www.w3.org/2001/XMLSchema','string','0','1','true'};
        private String[] Product2Name_type_info = new String[]{'Name','http://www.w3.org/2001/XMLSchema','string','0','1','true'};
        private String[] SerialNumber_type_info = new String[]{'SerialNumber','http://www.w3.org/2001/XMLSchema','string','0','1','true'};
        private String[] InstallDate_type_info = new String[]{'InstallDate','http://www.w3.org/2001/XMLSchema','string','0','1','true'};
        private String[] Quantity_type_info = new String[]{'Quantity','http://www.w3.org/2001/XMLSchema','double','0','1','true'};
        private String[] Contact_type_info = new String[]{'Contact','http://www.w3.org/2001/XMLSchema','string','0','1','true'};
        private String[] FirstName_type_info = new String[]{'FirstName','http://www.w3.org/2001/XMLSchema','string','0','1','true'};
        private String[] LastName_type_info = new String[]{'LastName','http://www.w3.org/2001/XMLSchema','string','0','1','true'};
        private String[] Status_type_info = new String[]{'Status','http://www.w3.org/2001/XMLSchema','string','0','1','true'};
        
        //End Asset fields for Mashup

        private String[] apex_schema_type_info = new String[]{'urn:sobject.enterprise.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'fieldsToNull','Name','Product2','Product2Name','SerialNumber','InstallDate','Quantity','Contact','FirstName','LastName','Status'};
    }
}