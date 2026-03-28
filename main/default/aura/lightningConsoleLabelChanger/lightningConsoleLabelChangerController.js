({
	doInit: function (cmp) {
		var RecordId = cmp.get("v.recordId");
		var field = cmp.get("v.fieldName");
		cmp.find("recordLoader").set("v.recordId", RecordId);
		cmp.find("recordLoader").set("v.fields", [field]);
		cmp.find("recordLoader").reloadRecord();
	},

	handleRecordUpdated: function (cmp) {
		let field = cmp.get("v.fieldName");
		let labelValue = cmp.get("v.simpleRecord." + field);
		var workspaceAPI = cmp.find("workspace");

		if (labelValue) {
			workspaceAPI
				.getFocusedTabInfo()
				.then(function (response) {
					var focusedTabId = response.tabId;
					workspaceAPI.setTabLabel({
						tabId: focusedTabId,
						label: labelValue
					});
				})
				.catch(function (error) {
					console.log(error);
				});
		}
	}
});