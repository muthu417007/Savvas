({
	getRecentOppId : function(component, event) {
		let action = component.get('c.getRecentOppId');
        action.setParams({
            'accId':component.get('v.recordId')
        });
        action.setCallback(this, function(response){
            component.set('v.isLoading',false);
            
            let state = response.getState();
            let toastEvt = $A.get('e.force:showToast');
            let title = 'Error occured';
            let msg = 'Something went wrong while getting recent Opportunity Id';
            let type = 'error';
            
            if(state == 'SUCCESS'){
                let respVal = response.getReturnValue();
                if(respVal == null || respVal == undefined){
                     msg = 'No Recent Opportunity Found';
                }else{
                    title = 'Success';
                    msg = 'Recent Opportunity record is opened';
                    type = 'success';
                    let navEvt = $A.get('e.force:navigateToSObject');
                    navEvt.setParams({
                        'recordId':respVal,
                        'slideDevName':'detail'
                    });
                    navEvt.fire();
                }
            }
            
            toastEvt.setParams({
                "title":title,
                "message":msg,
                "type":type
            });
            toastEvt.fire();
            
            $A.get('e.force:closeQuickAction').fire();
        });
        $A.enqueueAction(action);
	}
})