({
    startFlow : function(component, event, helper) {
        var flow = component.find("flowData");
        var recordId = component.get("v.recordId");
  
        var inputVariables = [
            {
                name : "recordId",
                type : "String",
                value : recordId
            }
        ];
  
        flow.startFlow(component.get("v.flowApiName"), inputVariables);
    }
  })