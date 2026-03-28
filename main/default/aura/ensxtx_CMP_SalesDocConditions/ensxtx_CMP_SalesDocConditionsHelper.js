({
    buildConditionsList: function(component, event, helper) {
        let addedConditions = component.get('v.addedConditions');
        let allConditions = component.get('v.allConditions');

        if (addedConditions && allConditions) {
            let currentConditionsMap = new Map();
            addedConditions.forEach(cond => {
                currentConditionsMap.set(cond.ConditionType, cond);
            });

            let conditionsList = allConditions.filter(function(cond) {
                if (!currentConditionsMap.has(cond.ConditionType)) {
                    return true;
                }
                else {
                    let condition = currentConditionsMap.get(cond.ConditionType);
                    condition.ConditionTypeName = cond.KSCHL_TEXT;
                    currentConditionsMap.set(cond.ConditionType, condition);
                    return false;
                }
            });
            component.set('v.conditionsList', conditionsList);
            component.set('v.addedConditions', Array.from(currentConditionsMap.values()));
        }
        else component.set('v.conditionsList', allConditions);
    }
})