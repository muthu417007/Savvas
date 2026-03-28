({
    doInit: function (component, event, helper) {
        
        // find the flowData element
        var flow = component.find("flowData"); 
        
        // Launch ScreenFlow_NewOpportunity_FromAcct
        flow.startFlow("ScreenFlow_NewOpportunity_FromAcct");

    }

  })