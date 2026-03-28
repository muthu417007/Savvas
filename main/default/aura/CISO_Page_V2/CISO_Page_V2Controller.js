({
	myAction : function(component, event, helper) {
		
	},
    handleClick: function(component,event,helper)
    {

		var target =event.currentTarget;
      	var cat =target.getAttribute("title");        
        console.log(cat);
       // var cat = event.getSource().get("v.name");
        component.set("v.catName",cat);
        var action = component.get("c.getFolderContents");
        action.setParams({ "Folder_Name" : cat });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               
                    component.set('v.contentDocs', response.getReturnValue());
               
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
        
                }
            }
        });
        $A.enqueueAction(action);
         component.set("v.hasMainModalOpen", true);
    },
	getSelected : function(component,event,helper){
        // display modle and set seletedDocumentId attribute with selected record Id   
        component.set("v.hasModalOpen" , true);
        component.set("v.selectedDocumentId" , event.currentTarget.getAttribute("data-Id")); 
        
    },
    closeModel: function(component, event, helper) {
        // for Close Model, set the "hasModalOpen" attribute to "FALSE"  
        component.set("v.hasModalOpen", false);
        component.set("v.selectedDocumentId" , null); 
    },
    closeMainModel: function(component, event, helper) {
        // for Close Model, set the "hasModalOpen" attribute to "FALSE"  
        component.set('v.contentDocs', "");
        component.set("v.hasMainModalOpen", false);
    }

})