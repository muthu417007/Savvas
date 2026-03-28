/************************************************************************ 
Name: OrderUpdateJSONWrapper
Purpose: W-013027 - Wrapper class to form JSON that sends the updated Order and line item details to ML. Agents review the Order created through RPA process, makes neccessary updates on Order if required and then approves/rejects Orders.
		 These details are sent to ML system for the learning of ML algorithms,
History:
VERSION AUTHOR DATE       DETAIL                DESCRIPITOPN
1.0     CTS               INITIAL DEVELOPMENT   
************************************************************************/
public class OrderUpdateJSONWrapper {
	public List<Data> data;

	public class OrderLineItem {
		public String QUANTITY;
		public String UNITPRICE;
		public String ISBN;
		public String AMOUNT;
	}

	public class Data {
		public String case_id;
		public String Institution_Name;
		public String Ship_to_Contact;
		public String Ship_to_Email;
		public String Ship_to_PhoneNum;
		public String Ship_to_Street;
		public String Ship_to_city;
		public String Ship_to_State;
		public String Ship_to_Zip;
		public String Ship_to_Country;
		public String Bill_to_Street;
		public String Bill_to_city;
		public String Bill_to_State;
		public String Bill_to_Zip;
		public String Bill_to_Country;
		public String PODate;
		public String PONUMBER;
		public List<OrderLineItem> OrderLineItem;
	}
}