/************************************************************************ 
Name: OrderCreationJSONWrapper
Purpose: Wrapper class to deserialie the JSON returned ML for Order creation(/DataExtraction) API.
History:
VERSION AUTHOR DATE       DETAIL                DESCRIPITOPN
1.0     CTS               INITIAL DEVELOPMENT   Created the wrapper class based on JSON structure.
************************************************************************/
public class OrderCreationJSONWrapper {
	public Schema schema {get;set;} 
	public List<Data> data {get;set;} 
    public String DocType {get;set;}

    public class Schema {
		public List<Fields> fields {get;set;} 
		public List<String> primaryKey {get;set;} 
		public String pandas_version {get;set;} 
    }
    
    public class Data {
		public Integer index {get;set;} 
		public String FileName {get;set;} 
		public String Label {get;set;} 
		public String Value {get;set;} 
		public String X1 {get;set;} 
		public String Y1 {get;set;} 
		public String X2 {get;set;} 
		public String Y2 {get;set;} 
		public String Confidence_Score_Header {get;set;} 
		public String Category {get;set;} 
		public String LineNumber {get;set;} 
		public Integer PageNo {get;set;} 
    }
    
    public class Fields {
		public String name {get;set;} 
		public String type {get;set;} 
    }
}