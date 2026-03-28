({
    onInit: function(component, event, helper) {
        helper.loadAppSettings(component, helper)
            .then($A.getCallback(function() {
                helper.buildColumns(component);
                component.set('v.displaySpinner', false);
            }))
    },

    onDownloadTemplate: function(component, event) {
        let csvContent = "data:text/csv;charset=utf-8,";
        let csvColumns = component.get('v.csvColumns')
        csvContent += csvColumns.join(',');

        let encodedURI = encodeURI(csvContent);
        let link = document.createElement('a');
        let fileName = $A.get('$Label.c.ensxtx_ImportMaterial_Label_MaterialImportTemplate');
        link.href = encodedURI;
        link.download = fileName + '.csv';
        link.target = '_blank';
        document.body.appendChild(link);
        link.click();
    },

    onDragOver: function(component, event, helper) {
        event.preventDefault();
        let dropDiv = component.find('dropDiv');
        $A.util.addClass(dropDiv, 'slds-has-drag-over');
    },

    onDragLeave: function(component, event, helper) {
        event.preventDefault();
        let dropDiv = component.find('dropDiv');
        $A.util.removeClass(dropDiv, 'slds-has-drag-over');
    },

    onDrop: function(component, event, helper) {
        console.log('on drop');
        event.preventDefault();
        let dropDiv = component.find('dropDiv');
        $A.util.removeClass(dropDiv, 'slds-has-drag-over');
        helper.onHandleUpload(component, event.dataTransfer.files, helper);
    },

    onInputFileChange: function(component, event, helper) {
        helper.onHandleUpload(component, event.target.files, helper);
    },

    addMaterials: function(component, event, helper) {
        helper.saveToItems(component, event);
    },

    onClickCancel: function(component, event, helper) {
        component.find("overlayLibImport").notifyClose();
    },
})