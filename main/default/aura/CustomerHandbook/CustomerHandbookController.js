({
	openHandbook: function(component, event, helper) 
    {
       var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": 'https://cloud.3dissue.com/202077/205776/241865/Na0322SavvasCustomerHandbook/index.html?r=16'
        });
        urlEvent.fire();
    }
})