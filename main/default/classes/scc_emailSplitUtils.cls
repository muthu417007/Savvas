/*
Apex Class:scc_orderDetail_Controller
Author: CTS (Sameer Pujari)
Created Date: 10/07/2024
Reason:Flow invocale method to split emails.
Modified Date: 17/10/2024
*/
public without sharing class scc_emailSplitUtils {
    /**
*  Description: Flow invocale method to split emails.   
*  @name:splitEmails
*  @param: flow request having email string
*  @return: splitted form of emails
*  @throws exception- NA
*/    
    @InvocableMethod
    public static FlowOutput[] splitEmails(List<FlowInput> request){
        List<FlowOutput> results = new List<FlowOutput>();
        if(request[0].emailString != null && request[0].emailString != ''){
            FlowOutput fo = new FlowOutput();
            fo.outputString = request[0].emailString.split(' ');
            results.add(fo);
        }
        return results;
    }
    
    //input details that comes to apex from flow
    public class FlowInput{        
        @InvocableVariable
        public String emailString;
        
    }
    
    //output details which goes from apex to flow
    public class FlowOutput{
        @InvocableVariable
        public List<String> outputString;
        
    }
}