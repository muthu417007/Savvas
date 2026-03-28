public without sharing class ensxtx_UTIL_LoadValuesMap
{
    public static Map<String, String> loadValuesMap(List<Map<String, Object>> mapFieldsList, Map<String, Id> sfObjectIdMap) {
        if (sfObjectIdMap != null) {
            for (String key : sfObjectIdMap.keySet()) {
                sfObjectIdMap.put(key.toUpperCase(), sfObjectIdMap.get(key));
            }
        }
        Map<String, Set<String>> sfObjectMap = new Map<String, Set<String>>();
        for (Map<String, Object> mapFieldMap : mapFieldsList) {
            String sapField = (String) mapFieldMap.get('sapField');
            String sfObjectType = (String) mapFieldMap.get('sfObjectType');
            if (String.isNotEmpty(sfObjectType) && sfObjectIdMap != null && sfObjectIdMap.containsKey(sfObjectType.toUpperCase())) {
                sfObjectType = sfObjectType.toUpperCase();
                String sfField = (String) mapFieldMap.get('sfField');
                Set<String> fieldSet = sfObjectMap.containsKey(sfObjectType) ? sfObjectMap.get(sfObjectType) : new Set<String>();
                if (String.isNotEmpty(sfField)) fieldSet.add(sfField);
                sfObjectMap.put(sfObjectType, fieldSet);
            }
        }

        Map<String, SObject> sfObjectResultMap = new Map<String, SObject>();
        if (sfObjectIdMap != null) {
            for (String sfObjectType : sfObjectMap.keySet()) {
                Set<String> fieldSet = sfObjectMap.get(sfObjectType);
                String query = 'SELECT Id';
                for (String field : fieldSet) {
                    query += ', ' + field;
                }
                Id sfObjectId = sfObjectIdMap.get(sfObjectType);
                if (String.isNotEmpty(sfObjectId)) {
                    query += ' FROM ' + sfObjectType + ' WHERE Id = \'' + sfObjectId + '\'';
                    List<SObject> resultList = Database.query(query);
                    if (resultList.size() > 0) sfObjectResultMap.put(sfObjectType, resultList[0]);
                }
            }
        }

        Map<String, String> resultMap = new Map<String, String>();
        Map<String, String> defaultValues = new Map<String, String>();
        for (Map<String, Object> mapFieldMap : mapFieldsList) {
            String sapField = (String) mapFieldMap.get('sapField');
            String value = '';
            String sfObjectType = (String) mapFieldMap.get('sfObjectType');
            if (String.isNotEmpty(sfObjectType) && sfObjectResultMap.containsKey(sfObjectType.toUpperCase())) {
                sfObjectType = sfObjectType.toUpperCase();
                String sfField = (String) mapFieldMap.get('sfField');
                String sfValue = (String) sfObjectResultMap.get(sfObjectType).get(sfField);
                if (String.isNotEmpty(sfValue)) value = sfValue;
            }
            String defaultValue = (String) mapFieldMap.get('defaultValue');
            if (String.isNotEmpty(defaultValue)) defaultValues.put(sapField, defaultValue);
            if (String.isNotEmpty(value)) resultMap.put(sapField, value);
        }
        for (String key : defaultValues.keySet()) {
            if (!resultMap.containsKey(key)) resultMap.put(key, defaultValues.get(key));
        }
        return resultMap;
    }
}