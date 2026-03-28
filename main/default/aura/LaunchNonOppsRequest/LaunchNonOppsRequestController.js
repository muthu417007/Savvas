({
	doInit : function(component, event, helper) {
        var flow = component.find("nonOppFlow");
		flow.startFlow("Request_for_Non_Opportunity_Assignment");
        
	},
    handleStatusChange : function (component, event) {
       
   if(event.getParam("status") === "FINISHED") {
       
    $A.get("e.force:closeQuickAction").fire();
   }
}
})