public class implOppSobjectMashupSoapSforceCom {
    public class sObject_x {
        public String[] fieldsToNull;
        public String Id;

        //Begin Implementation Opportunity fields for Mashup

        public String Name;
        public String RecordType;
        public String RecordTypeName;
        public String Type;
        public String Owner;
        public String FirstName;
        public String LastName;
        public Double ImplementationFees;
        public Double Project_Management_Fees;
        public String Oracle_Project_Number;
        public String StageName;
        public String Booking_Start_Date;
        public String Kick_off_Call_Completed_Date;
        public String Support_Target_Date;
        public String IMP_Project_Status;
        public String Imp_Current_Status_Overview;
        public String IPP_Project_Link;
        
        //End Implementation Opportunity fields for Mashup

        private String[] fieldsToNull_type_info = new String[]{'fieldsToNull','http://www.w3.org/2001/XMLSchema','string','0','-1','true'};
        private String[] Id_type_info = new String[]{'Id','urn:enterprise.soap.sforce.com','ID','1','1','true'};

        //Begin Implementation Opportunity fields for Mashup

        private String[] Name_type_info = new String[]{'Name','http://www.w3.org/2001/XMLSchema','string','0','1','true'};
        private String[] RecordType_type_info = new String[]{'RecordType','http://www.w3.org/2001/XMLSchema','string','0','1','true'};
        private String[] RecordTypeName_type_info = new String[]{'Name','http://www.w3.org/2001/XMLSchema','string','0','1','true'};
        private String[] Type_type_info = new String[]{'Type','http://www.w3.org/2001/XMLSchema','string','0','1','true'};
		private String[] Owner_type_info = new String[]{'Owner','http://www.w3.org/2001/XMLSchema','string','0','1','true'};
        private String[] FirstName_type_info = new String[]{'FirstName','http://www.w3.org/2001/XMLSchema','string','0','1','true'};
        private String[] LastName_type_info = new String[]{'LastName','http://www.w3.org/2001/XMLSchema','string','0','1','true'};
        private String[] ImplementationFees_type_info = new String[]{'ImplementationFees__c','http://www.w3.org/2001/XMLSchema','double','0','1','true'};
        private String[] Project_Management_Fees_type_info = new String[]{'Project_Management_Fees__c','http://www.w3.org/2001/XMLSchema','double','0','1','true'};
        private String[] Oracle_Project_Number_type_info = new String[]{'Oracle_Project_Number__c','http://www.w3.org/2001/XMLSchema','string','0','1','true'};
        private String[] StageName_type_info = new String[]{'StageName','http://www.w3.org/2001/XMLSchema','string','0','1','true'};
		private String[] Booking_Start_Date_type_info = new String[]{'Booking_Start_Date__c','http://www.w3.org/2001/XMLSchema','date','0','1','true'};
        private String[] Kick_off_Call_Completed_Date_type_info = new String[]{'Kick_off_Call_Completed_Date__c','http://www.w3.org/2001/XMLSchema','date','0','1','true'};
        private String[] Support_Target_Date_type_info = new String[]{'Support_Target_Date__c','http://www.w3.org/2001/XMLSchema','date','0','1','true'};
        private String[] IMP_Project_Status_type_info = new String[]{'IMP_Project_Status__c','http://www.w3.org/2001/XMLSchema','string','0','1','true'};
        private String[] Imp_Current_Status_Overview_type_info = new String[]{'Imp_Current_Status_Overview__c','http://www.w3.org/2001/XMLSchema','string','0','1','true'};
		private String[] IPP_Project_Link_type_info = new String[]{'IPP_Project_Link__c','http://www.w3.org/2001/XMLSchema','string','0','1','true'};
        
        //End Implementation Opportunity fields for Mashup

        private String[] apex_schema_type_info = new String[]{'urn:sobject.enterprise.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'fieldsToNull','Name','RecordType','RecordTypeName','Type','Owner','FirstName','LastName','ImplementationFees','Project_Management_Fees','Oracle_Project_Number','StageName','Booking_Start_Date','Kick_off_Call_Completed_Date','Support_Target_Date','IMP_Project_Status','Imp_Current_Status_Overview','IPP_Project_Link'};
    }
}