public class CDSupportFlowController{ 
    public Flow.Interview.CD_Support myFlow {get;set;}
       public CDSupportFlowController() {    
    }
    
    public String screenName;
	public String getScreenName() {
      if (myFlow==null) { return '';}
      String flowScreenName = (String) myFlow.getVariableValue('ScreenName');
      return(flowScreenName==null ? '': flowScreenName);
   }    
}