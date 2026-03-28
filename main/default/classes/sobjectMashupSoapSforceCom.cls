public class sobjectMashupSoapSforceCom {
    public class sObject_x {
        public String[] fieldsToNull;
        public String Id;

        //Begin Case fields for Mashup

        public String CaseNumber;
        public String Contact;
        public String Name;
        public String FirstName;
        public String LastName;
        public String Subject;
        public String Priority;
        public DateTime CreatedDate;
        public String Status;
        public String Owner;
        public String Type;
        
        //End Case fields for Mashup

        private String[] fieldsToNull_type_info = new String[]{'fieldsToNull','http://www.w3.org/2001/XMLSchema','string','0','-1','true'};
        private String[] Id_type_info = new String[]{'Id','urn:enterprise.soap.sforce.com','ID','1','1','true'};

        //Begin Case fields for Mashup

        private String[] CaseNumber_type_info = new String[]{'CaseNumber','http://www.w3.org/2001/XMLSchema','string','0','1','true'};
        private String[] Contact_type_info = new String[]{'Contact','http://www.w3.org/2001/XMLSchema','string','0','1','true'};
        private String[] Name_type_info = new String[]{'Name','http://www.w3.org/2001/XMLSchema','string','0','1','true'};
        private String[] FirstName_type_info = new String[]{'FirstName','http://www.w3.org/2001/XMLSchema','string','0','1','true'};
        private String[] LastName_type_info = new String[]{'LastName','http://www.w3.org/2001/XMLSchema','string','0','1','true'};
        private String[] Subject_type_info = new String[]{'Subject','http://www.w3.org/2001/XMLSchema','string','0','1','true'};
        private String[] Priority_type_info = new String[]{'Priority','http://www.w3.org/2001/XMLSchema','string','0','1','true'};
        private String[] CreatedDate_type_info = new String[]{'CreatedDate','http://www.w3.org/2001/XMLSchema','dateTime','0','1','true'};
		private String[] Status_type_info = new String[]{'Status','http://www.w3.org/2001/XMLSchema','string','0','1','true'};
		private String[] Owner_type_info = new String[]{'Owner','http://www.w3.org/2001/XMLSchema','string','0','1','true'};
        private String[] Type_type_info = new String[]{'Type','http://www.w3.org/2001/XMLSchema','string','0','1','true'};
        
        //End Case fields for Mashup

        private String[] apex_schema_type_info = new String[]{'urn:sobject.enterprise.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'fieldsToNull','CaseNumber','Contact','Name','Priority','CreatedDate','Status','Type'};
    }
}