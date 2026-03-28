/*
@see: Controller for Legal_Team_Bio Aura Component
@Implemented as a part of Community Pages Build for Savvas Central Community
@Author: Prabhat Kanuri (Cognizant)
*/



({
   openBio: function(component, event, helper) {
      console.log("Model Open");
      var target =event.currentTarget;
      var name =target.getAttribute("title");
       if(name=="Erin")
       {
           component.set("v.isModalOpen", true);
           component.set("v.cand","Erin Lungerich");
           var path = $A.get("$Resource.Erin_Pic_Lgl");
           component.set("v.image_1",path);
           component.set("v.Bio_Name","Erin_Bio");
           var a = component.get('c.callApex');
        	$A.enqueueAction(a);
       }
       if(name=="Ryan")
       {
           component.set("v.isModalOpen", true);
           component.set("v.cand","Ryan Johnson");
           var path = $A.get("$Resource.RJ_Pic_Lgl");
           component.set("v.image_1",path);
           component.set("v.Bio_Name","RJ_Bio");
           var a = component.get('c.callApex');
        	$A.enqueueAction(a);
       }
        if(name=="Christine")
       {
           component.set("v.isModalOpen", true);
           component.set("v.cand","Christine Doebbler");
           var path = $A.get("$Resource.Christine_Pic_Lgl");
           component.set("v.image_1",path);
           component.set("v.Bio_Name","Christine_Bio");
           var a = component.get('c.callApex');
        	$A.enqueueAction(a);
       }
       if(name=="DFD")
       {
           component.set("v.isModalOpen", true);
           component.set("v.cand","Debi Debiak");
           var path = $A.get("$Resource.Debi_pic_lgl");
           component.set("v.image_1",path);
           component.set("v.Bio_Name","DFD_Bio");
           var a = component.get('c.callApex');
        	$A.enqueueAction(a);
       }
       if(name=="Kevin")
       {
           component.set("v.isModalOpen", true);
           component.set("v.cand","Kevin Schutz");
           var path = $A.get("$Resource.KS_Pic_Lgl");
           component.set("v.image_1",path);
           component.set("v.Bio_Name","KS_Bio");
           var a = component.get('c.callApex');
        	$A.enqueueAction(a);

       }
       if(name=="Paula")
       {
           component.set("v.isModalOpen", true);
           component.set("v.cand","Paula Massenaro"); // This Displays title for Modal
           var path = $A.get("$Resource.Paula_Pic_Lgl"); 
           component.set("v.image_1",path);
           component.set("v.Bio_Name","Paula_Bio");
           var a = component.get('c.callApex'); // Makes APex Call to retrieve Bio Data
        	$A.enqueueAction(a);
       }
       if(name=="AY")
       {
           component.set("v.isModalOpen", true);
           component.set("v.cand","Andy Yoo"); // This Displays title for Modal
           var path = $A.get("$Resource.AY_Pic_Lgl"); 
           component.set("v.image_1",path);
           component.set("v.Bio_Name","Andy_Yoo_Bio");
           var a = component.get('c.callApex'); // Makes APex Call to retrieve Bio Data
        	$A.enqueueAction(a);
       }
       if(name=="Meredith")
       {
           component.set("v.isModalOpen", true);
           component.set("v.cand","Meredith Chester"); // This Displays title for Modal
           var path = $A.get("$Resource.Mer_Pic_Lgl"); 
           component.set("v.image_1",path);
           component.set("v.Bio_Name","Meredith_Bio");
           var a = component.get('c.callApex'); // Makes APex Call to retrieve Bio Data
        	$A.enqueueAction(a);
       }
       if(name=="Rosa")
       {
           component.set("v.isModalOpen", true);
           component.set("v.cand","Rosa Balestrino"); // This Displays title for Modal
           var path = $A.get("$Resource.Rosa_Pic_Lgl"); 
           component.set("v.image_1",path);
           component.set("v.Bio_Name","Rosa_bio");
           var a = component.get('c.callApex'); // Makes APex Call to retrieve Bio Data
        	$A.enqueueAction(a);
       }
   },
  
   goBack: function(component, event, helper) {
      // Set isModalOpen attribute to false  
      component.set("v.isModalOpen", false);
      component.set("v.body","");
   },
    callApex: function (cmp, event, helper) {
        var param_b = cmp.get("v.Bio_Name");
    	var action = cmp.get("c.getBioBody");
   	 	action.setParams({ staticResourceName : param_b });
   	 	action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS") {
            cmp.set('v.body', response.getReturnValue());
        }
    });
 	$A.enqueueAction(action);
    },
})


/*****Model Js Code for additional Bio**************/

/*
 * if(name=="<Name of Candidate whose Bio tobe displayed>")
       {
           component.set("v.isModalOpen", true);
           component.set("v.cand","<Candidate_Name>"); // This Displays title for Modal
           var path = $A.get("$Resource.<Static Resource for Photo>"); 
           component.set("v.image_1",path);
           component.set("v.Bio_Name","<Static Resource Name for Bio>");
           var a = component.get('c.callApex'); // Makes APex Call to retrieve Bio Data
        	$A.enqueueAction(a);
       }
       
*******/

/**********Model Js Code Ends*****************/