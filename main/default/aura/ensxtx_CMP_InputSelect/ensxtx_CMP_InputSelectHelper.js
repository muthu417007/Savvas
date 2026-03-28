({
    updateOptionValues: function(component) {
        let optionValues = component.get('v.optionValues');
        if (optionValues && optionValues.length) {
            let optionValueField = component.get('v.optionValueField');
            let optionDescriptionField = component.get('v.optionDescriptionField');
            let optionInternalValueField = component.get('v.optionInternalValueField');

            // If the internal value field is passed
            // then we use the internal value as the actual value selected
            let displayOptionValues = optionValues.map(option => {
                return {
                    value: optionInternalValueField ? option[optionInternalValueField] : option[optionValueField],
                    description: option[optionValueField] + ' - ' + option[optionDescriptionField]
                }
            })

            // Filter the values to be shown on the ui
            // The list of filtered values are setup in the app settings
            let optionValuesToInclude = component.get('v.optionValuesToInclude');
            if (optionValuesToInclude && optionValuesToInclude.length) {
                let filterValuesSet = new Set(optionValuesToInclude);
                displayOptionValues = displayOptionValues.filter(option => filterValuesSet.has(option.value))
            }

            component.set('v.displayOptionValues', displayOptionValues);
        }
    }
})